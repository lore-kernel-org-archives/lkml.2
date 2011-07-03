Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752101Ab1GCG55 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 02:57:57 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50803 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751647Ab1GCG5z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 02:57:55 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrea Righi <andrea@betterlinux.com>
Subject: Re: [PATCH] ACPI: fix acpi_power_off lockdep splat
Date: Sun, 3 Jul 2011 08:58:41 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Len Brown <lenb@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1309620681-25173-1-git-send-email-andrea@betterlinux.com>
In-Reply-To: <1309620681-25173-1-git-send-email-andrea@betterlinux.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201107030858.41459.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, July 02, 2011, Andrea Righi wrote:
> Implement acpi_os_create_lock() as a C-preprocessor macro to assign
> unique lock_class_key to dynamically allocated locks and suppress wrong
> lockdep warnings.
> 
> This fixes:
> https://bugzilla.kernel.org/show_bug.cgi?id=38152
> 
> Reported-by: Borislav Petkov <bp@alien8.de>
> Signed-off-by: Andrea Righi <andrea@betterlinux.com>

So, how exactly does it work?

> ---
>  drivers/acpi/osl.c      |    2 +-
>  include/acpi/acpiosxf.h |   12 +++++++++++-
>  2 files changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
> index 52ca964..2a67602 100644
> --- a/drivers/acpi/osl.c
> +++ b/drivers/acpi/osl.c
> @@ -1336,7 +1336,7 @@ EXPORT_SYMBOL(acpi_resources_are_enforced);
>   * Create and initialize a spinlock.
>   */
>  acpi_status
> -acpi_os_create_lock(acpi_spinlock *out_handle)
> +__acpi_os_create_lock(acpi_spinlock *out_handle)
>  {
>  	spinlock_t *lock;
>  
> diff --git a/include/acpi/acpiosxf.h b/include/acpi/acpiosxf.h
> index a756bc8..4a0385d 100644
> --- a/include/acpi/acpiosxf.h
> +++ b/include/acpi/acpiosxf.h
> @@ -99,7 +99,17 @@ acpi_os_table_override(struct acpi_table_header *existing_table,
>   * Spinlock primitives
>   */
>  acpi_status
> -acpi_os_create_lock(acpi_spinlock *out_handle);
> +__acpi_os_create_lock(acpi_spinlock *out_handle);
> +
> +#define acpi_os_create_lock(__handle)			\
> +({							\
> +	acpi_status ret;				\
> +							\
> +	ret = __acpi_os_create_lock(__handle);		\
> +	if (ret == AE_OK)				\
> +		spin_lock_init(*(__handle));		\

It seems that spin_lock_init() has already been done on *__handle, right?

> +	ret;						\
> +})
>  
>  void acpi_os_delete_lock(acpi_spinlock handle);

Rafael
