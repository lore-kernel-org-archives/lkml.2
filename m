Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081Ab1AFJbr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 04:31:47 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41653 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319Ab1AFJbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 04:31:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=DkVFdObUKppuNSLwMfuwRnexs7wCw4G+1r+7fJDhU8+7An1JQngtUuRuN/QuiYsDZx
         8b96keqbbEf2BwuHFZ0NnjcVKUotQZ+90Qy9pj7jN+xgluJg5WEiqrmtPJVt++xmRjc0
         g5tYP9YcDDBjDBcCjAc0XVBSuRSE1pIQjmBZ8=
Message-ID: <4D258BFB.1010006@gmail.com>
Date: Thu, 06 Jan 2011 10:31:39 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] PM: fix oops in suspend/hibernate code
References: <201101060028.43342.rjw@sisk.pl> <1294305504-5787-1-git-send-email-jslaby@suse.cz>
In-Reply-To: <1294305504-5787-1-git-send-email-jslaby@suse.cz>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/2011 10:18 AM, Jiri Slaby wrote:
> When ioremap fails (which might happen for some reason), we nicely
> oops in suspend_nvs_save due to NULL dereference by memcpy in there.
> Fail gracefully instead.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> ---

Just to note, I'm not 100% sure whether the fail paths are OK with this
patch. But it works for me.

So it needs an ACK from Rafael or whoever wrote/understand the code.

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


-- 
js
