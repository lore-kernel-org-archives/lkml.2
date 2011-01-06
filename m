Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763Ab1AFP6P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 10:58:15 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37013 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753594Ab1AFP6N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 10:58:13 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH 1/1] PM: fix oops in suspend/hibernate code
Date: Thu, 6 Jan 2011 16:57:39 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37+; KDE/4.4.4; x86_64; ; )
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        jirislaby@gmail.com,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Len Brown <lenb@kernel.org>
References: <201101060028.43342.rjw@sisk.pl> <1294305504-5787-1-git-send-email-jslaby@suse.cz>
In-Reply-To: <1294305504-5787-1-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201101061657.39723.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, January 06, 2011, Jiri Slaby wrote:
> When ioremap fails (which might happen for some reason),

If it happens, something is seriously wrong (see below).

BTW, to keep things in context, please post fixes like this in the same thread
in which you reported the problem.  At lease please retain the CC list from
there.

> we nicely oops in suspend_nvs_save due to NULL dereference by memcpy in
> there.  Fail gracefully instead.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> ---
>  drivers/acpi/sleep.c    |    5 ++---
>  include/linux/suspend.h |    4 ++--
>  kernel/power/nvs.c      |    8 +++++++-
>  3 files changed, 11 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
> index c423231..f94c9a9 100644
> --- a/drivers/acpi/sleep.c
> +++ b/drivers/acpi/sleep.c
> @@ -124,8 +124,7 @@ static int acpi_pm_freeze(void)
>  static int acpi_pm_pre_suspend(void)
>  {
>  	acpi_pm_freeze();
> -	suspend_nvs_save();
> -	return 0;
> +	return suspend_nvs_save();
>  }
>  
>  /**
> @@ -151,7 +150,7 @@ static int acpi_pm_prepare(void)
>  {
>  	int error = __acpi_pm_prepare();
>  	if (!error)
> -		acpi_pm_pre_suspend();
> +		error = acpi_pm_pre_suspend();
>  
>  	return error;
>  }
> diff --git a/include/linux/suspend.h b/include/linux/suspend.h
> index c1f4998..3ac2551 100644
> --- a/include/linux/suspend.h
> +++ b/include/linux/suspend.h
> @@ -262,7 +262,7 @@ static inline bool system_entering_hibernation(void) { return false; }
>  extern int suspend_nvs_register(unsigned long start, unsigned long size);
>  extern int suspend_nvs_alloc(void);
>  extern void suspend_nvs_free(void);
> -extern void suspend_nvs_save(void);
> +extern int suspend_nvs_save(void);
>  extern void suspend_nvs_restore(void);
>  #else /* CONFIG_SUSPEND_NVS */
>  static inline int suspend_nvs_register(unsigned long a, unsigned long b)
> @@ -271,7 +271,7 @@ static inline int suspend_nvs_register(unsigned long a, unsigned long b)
>  }
>  static inline int suspend_nvs_alloc(void) { return 0; }
>  static inline void suspend_nvs_free(void) {}
> -static inline void suspend_nvs_save(void) {}
> +static inline int suspend_nvs_save(void) {}
>  static inline void suspend_nvs_restore(void) {}
>  #endif /* CONFIG_SUSPEND_NVS */
>  
> diff --git a/kernel/power/nvs.c b/kernel/power/nvs.c
> index 1836db6..57c6fab 100644
> --- a/kernel/power/nvs.c
> +++ b/kernel/power/nvs.c
> @@ -105,7 +105,7 @@ int suspend_nvs_alloc(void)
>  /**
>   *	suspend_nvs_save - save NVS memory regions
>   */
> -void suspend_nvs_save(void)
> +int suspend_nvs_save(void)
>  {
>  	struct nvs_page *entry;
>  
> @@ -114,8 +114,14 @@ void suspend_nvs_save(void)
>  	list_for_each_entry(entry, &nvs_list, node)
>  		if (entry->data) {
>  			entry->kaddr = ioremap(entry->phys_start, entry->size);

I wonder what happens if you simply change the ioremap() here to
ioremap_nocache() without any other modifications?

It _really_ shouldn't fail here, because the NVS pages are known to be present.

> +			if (!entry->kaddr) {
> +				suspend_nvs_free();
> +				return -ENOMEM;
> +			}
>  			memcpy(entry->data, entry->kaddr, entry->size);
>  		}
> +
> +	return 0;
>  }
>  
>  /**
> 

Rafael
