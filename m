Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756518Ab1GCU6I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 16:58:08 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51720 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750973Ab1GCU6F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 16:58:05 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrea Righi <andrea@betterlinux.com>
Subject: Re: [PATCH v2] ACPI: fix acpi_power_off lockdep splat
Date: Sun, 3 Jul 2011 22:59:05 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Len Brown <lenb@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1309684450-24549-1-git-send-email-andrea@betterlinux.com>
In-Reply-To: <1309684450-24549-1-git-send-email-andrea@betterlinux.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201107032259.05722.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, July 03, 2011, Andrea Righi wrote:
> Implement acpi_os_create_lock() as a C-preprocessor macro to suppress
> lockdep false positive.
> 
> When lockdep is enabled the spin_lock_init macro stringifies it's
> argument and uses that as a name for the lock in the debugging.
> 
> By executing spin_lock_init in a macro the key changes from "lock" for
> all locks to the actual argument of acpi_os_create_lock()
> ("&acpi_gbl_global_lock_pending_lock", "&acpi_gbl_gpe_lock" or
> "&acpi_gbl_hardware_lock" for now).
> 
> This fixes:
> https://bugzilla.kernel.org/show_bug.cgi?id=38152
> 
> ChangeLog (v1 -> v2):
>  - avoid to call spin_lock_init multiple times on the same lock
>  - rewrite patch description (thanks to Florian for providing a better
>    description of the patch)
> 
> Reported-by: Borislav Petkov <bp@alien8.de>
> CC: Florian Mickler <florian@mickler.org>
> Signed-off-by: Andrea Righi <andrea@betterlinux.com>
> ---
>  drivers/acpi/osl.c      |    3 +--
>  include/acpi/acpiosxf.h |   12 +++++++++++-
>  2 files changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
> index 52ca964..4c985d3 100644
> --- a/drivers/acpi/osl.c
> +++ b/drivers/acpi/osl.c
> @@ -1336,14 +1336,13 @@ EXPORT_SYMBOL(acpi_resources_are_enforced);
>   * Create and initialize a spinlock.
>   */
>  acpi_status
> -acpi_os_create_lock(acpi_spinlock *out_handle)
> +__acpi_os_create_lock(acpi_spinlock *out_handle)
>  {

I would rename this to acpi_os_allocate_lock() or acpi_os_alloc_lock(),
so that it doesn't suggest the lock is initialized by this function.

Hmm.  There's one more thing we need to take into account here.  Namely,
include/acpi/acpiosxf.h is used by other OSes, so we shouldn't put
Linux-specific stuff into it.

I'm not sure how to work around that at the moment.

Thanks,
Rafael


>  	spinlock_t *lock;
>  
>  	lock = ACPI_ALLOCATE(sizeof(spinlock_t));
>  	if (!lock)
>  		return AE_NO_MEMORY;
> -	spin_lock_init(lock);
>  	*out_handle = lock;
>  
>  	return AE_OK;
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
> +	ret;						\
> +})
>  
>  void acpi_os_delete_lock(acpi_spinlock handle);
>  
> 

