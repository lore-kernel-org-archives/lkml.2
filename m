Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518Ab1GEIEI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 04:04:08 -0400
Received: from ist.d-labs.de ([213.239.218.44]:49650 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754353Ab1GEIEE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 04:04:04 -0400
Date: Tue, 5 Jul 2011 10:03:58 +0200
From: Florian Mickler <florian@mickler.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrea Righi <andrea@betterlinux.com>, Len Brown <lenb@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Maciej Rutecki <maciej.rutecki@gmail.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI: Fix lockdep false positives in acpi_power_off()
Message-ID: <20110705100358.6857b235@schatten.dmk.lab>
In-Reply-To: <201107050132.11996.rjw@sisk.pl>
References: <1309684450-24549-1-git-send-email-andrea@betterlinux.com>
	<201107040028.23569.rjw@sisk.pl>
	<20110704082307.GA1239@thinkpad>
	<201107050132.11996.rjw@sisk.pl>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jul 2011 01:32:11 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> OK, below is an official version.
> 
> Thanks,
> Rafael
> 
> ---
> From: Rafael J. Wysocki <rjw@sisk.pl>
> Subject: ACPI: Fix lockdep false positives in acpi_power_off()
> 
> All ACPICA locks are allocated and initialized by the same function,
> acpi_os_create_lock(), with the help of a local variable called
> "lock".  Thus, when lockdep is enabled, it uses "lock" as the
> name of all those locks and regards them as instances of the same
> lock, which causes it to report possible locking problems with them
> when there aren't any.
> 
> To work around this problem, define acpi_os_create_lock() as a macro
> and make it pass its argument to spin_lock_init(), so that lockdep
> uses it as the name of the new lock.  Define this macron in a
> Linux-specific file to minimize the resulting modifications of
> the OS-independent ACPICA parts.
> 
> This change is based on an earlier patch from Andrea Righi and it
> addresses a regression from 2.6.39 tracked as
> https://bugzilla.kernel.org/show_bug.cgi?id=38152
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> Reported-by: Borislav Petkov <bp@alien8.de>
> Tested-by: Andrea Righi <andrea@betterlinux.com>
> ---
>  drivers/acpi/osl.c              |   17 -----------------
>  include/acpi/acpiosxf.h         |    3 +++
>  include/acpi/platform/aclinux.h |   18 ++++++++++++++++++
>  3 files changed, 21 insertions(+), 17 deletions(-)
> 
> Index: linux-2.6/drivers/acpi/osl.c
> ===================================================================
> --- linux-2.6.orig/drivers/acpi/osl.c
> +++ linux-2.6/drivers/acpi/osl.c
> @@ -1333,23 +1333,6 @@ int acpi_resources_are_enforced(void)
>  EXPORT_SYMBOL(acpi_resources_are_enforced);
>  
>  /*
> - * Create and initialize a spinlock.
> - */
> -acpi_status
> -acpi_os_create_lock(acpi_spinlock *out_handle)
> -{
> -	spinlock_t *lock;
> -
> -	lock = ACPI_ALLOCATE(sizeof(spinlock_t));
> -	if (!lock)
> -		return AE_NO_MEMORY;
> -	spin_lock_init(lock);
> -	*out_handle = lock;
> -
> -	return AE_OK;
> -}
> -
> -/*
>   * Deallocate the memory for a spinlock.
>   */
>  void acpi_os_delete_lock(acpi_spinlock handle)
> Index: linux-2.6/include/acpi/acpiosxf.h
> ===================================================================
> --- linux-2.6.orig/include/acpi/acpiosxf.h
> +++ linux-2.6/include/acpi/acpiosxf.h
> @@ -98,8 +98,11 @@ acpi_os_table_override(struct acpi_table
>  /*
>   * Spinlock primitives
>   */
> +
> +#ifndef acpi_os_create_lock
>  acpi_status
>  acpi_os_create_lock(acpi_spinlock *out_handle);
> +#endif
>  
>  void acpi_os_delete_lock(acpi_spinlock handle);
>  
> Index: linux-2.6/include/acpi/platform/aclinux.h
> ===================================================================
> --- linux-2.6.orig/include/acpi/platform/aclinux.h
> +++ linux-2.6/include/acpi/platform/aclinux.h
> @@ -159,6 +159,24 @@ static inline void *acpi_os_acquire_obje
>  	} while (0)
>  #endif
>  
> +/*
> + * When lockdep is enabled, the spin_lock_init() macro stringifies it's
> + * argument and uses that as a name for the lock in debugging.
> + * By executing spin_lock_init() in a macro the key changes from "lock" for
> + * all locks to the name of the argument of acpi_os_create_lock(), which
> + * prevents lockdep from reporting false positives for ACPICA locks.
> + */
> +#define acpi_os_create_lock(__handle)				\
> +({								\
> +	spinlock_t *lock = ACPI_ALLOCATE(sizeof(*lock));	\
> +								\
> +	if (lock) {						\
> +		*(__handle) = lock;				\
> +		spin_lock_init(*(__handle));			\
> +	}							\
> +	lock ? AE_OK : AE_NO_MEMORY;				\
> +})
> +
>  #endif /* __KERNEL__ */
>  
>  #endif /* __ACLINUX_H__ */

Since I made the effort of digging into the lockdep code, you can
actually add my 
 Reviewed-by: Florian Mickler <florian@mickler.org>

Regards,
Flo

