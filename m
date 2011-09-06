Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184Ab1IFKrh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 06:47:37 -0400
Received: from mail.openrapids.net ([64.15.138.104]:52206 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753846Ab1IFKrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 06:47:33 -0400
Date: Tue, 6 Sep 2011 06:47:28 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Huang Ying <ying.huang@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH -mm 1/4] llist, Make all llist functions inline
Message-ID: <20110906104728.GA21602@Krystal>
References: <1315290307-25145-1-git-send-email-ying.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315290307-25145-1-git-send-email-ying.huang@intel.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 06:46:59 up 286 days, 15:50,  1 user,  load average: 1.00, 1.00,
	0.78
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Huang Ying (ying.huang@intel.com) wrote:
> Because llist may be used in performance critical code path, make all
> llist functions inline to avoid function calling overhead.

Acked-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

Thanks,

Mathieu

> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>
> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> ---
>  drivers/acpi/apei/Kconfig |    1 
>  include/linux/llist.h     |  122 +++++++++++++++++++++++++++++++++++++++++--
>  lib/Kconfig               |    3 -
>  lib/Makefile              |    2 
>  lib/llist.c               |  129 ----------------------------------------------
>  5 files changed, 116 insertions(+), 141 deletions(-)
>  delete mode 100644 lib/llist.c
> 
> --- a/drivers/acpi/apei/Kconfig
> +++ b/drivers/acpi/apei/Kconfig
> @@ -14,7 +14,6 @@ config ACPI_APEI_GHES
>  	depends on ACPI_APEI && X86
>  	select ACPI_HED
>  	select IRQ_WORK
> -	select LLIST
>  	select GENERIC_ALLOCATOR
>  	help
>  	  Generic Hardware Error Source provides a way to report
> --- a/include/linux/llist.h
> +++ b/include/linux/llist.h
> @@ -37,8 +37,28 @@
>   * architectures that don't have NMI-safe cmpxchg implementation, the
>   * list can NOT be used in NMI handler.  So code uses the list in NMI
>   * handler should depend on CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG.
> + *
> + * Copyright 2010,2011 Intel Corp.
> + *   Author: Huang Ying <ying.huang@intel.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License version
> + * 2 as published by the Free Software Foundation;
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
>   */
>  
> +#include <linux/kernel.h>
> +#include <asm/system.h>
> +#include <asm/processor.h>
> +
>  struct llist_head {
>  	struct llist_node *first;
>  };
> @@ -113,14 +133,104 @@ static inline void init_llist_head(struc
>   * test whether the list is empty without deleting something from the
>   * list.
>   */
> -static inline int llist_empty(const struct llist_head *head)
> +static inline bool llist_empty(const struct llist_head *head)
>  {
>  	return ACCESS_ONCE(head->first) == NULL;
>  }
>  
> -void llist_add(struct llist_node *new, struct llist_head *head);
> -void llist_add_batch(struct llist_node *new_first, struct llist_node *new_last,
> -		     struct llist_head *head);
> -struct llist_node *llist_del_first(struct llist_head *head);
> -struct llist_node *llist_del_all(struct llist_head *head);
> +/**
> + * llist_add - add a new entry
> + * @new:	new entry to be added
> + * @head:	the head for your lock-less list
> + */
> +static inline void llist_add(struct llist_node *new, struct llist_head *head)
> +{
> +	struct llist_node *entry, *old_entry;
> +
> +#ifndef CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG
> +	BUG_ON(in_nmi());
> +#endif
> +
> +	entry = head->first;
> +	do {
> +		old_entry = entry;
> +		new->next = entry;
> +		cpu_relax();
> +	} while ((entry = cmpxchg(&head->first, old_entry, new)) != old_entry);
> +}
> +
> +/**
> + * llist_add_batch - add several linked entries in batch
> + * @new_first:	first entry in batch to be added
> + * @new_last:	last entry in batch to be added
> + * @head:	the head for your lock-less list
> + */
> +static inline void llist_add_batch(struct llist_node *new_first,
> +				   struct llist_node *new_last,
> +				   struct llist_head *head)
> +{
> +	struct llist_node *entry, *old_entry;
> +
> +#ifndef CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG
> +	BUG_ON(in_nmi());
> +#endif
> +
> +	entry = head->first;
> +	do {
> +		old_entry = entry;
> +		new_last->next = entry;
> +		cpu_relax();
> +	} while ((entry = cmpxchg(&head->first, old_entry, new_first)) != old_entry);
> +}
> +
> +/**
> + * llist_del_first - delete the first entry of lock-less list
> + * @head:	the head for your lock-less list
> + *
> + * If list is empty, return NULL, otherwise, return the first entry
> + * deleted, this is the newest added one.
> + *
> + * Only one llist_del_first user can be used simultaneously with
> + * multiple llist_add users without lock.  Because otherwise
> + * llist_del_first, llist_add, llist_add (or llist_del_all, llist_add,
> + * llist_add) sequence in another user may change @head->first->next,
> + * but keep @head->first.  If multiple consumers are needed, please
> + * use llist_del_all or use lock between consumers.
> + */
> +static inline struct llist_node *llist_del_first(struct llist_head *head)
> +{
> +	struct llist_node *entry, *old_entry, *next;
> +
> +#ifndef CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG
> +	BUG_ON(in_nmi());
> +#endif
> +
> +	entry = head->first;
> +	do {
> +		if (entry == NULL)
> +			return NULL;
> +		old_entry = entry;
> +		next = entry->next;
> +		cpu_relax();
> +	} while ((entry = cmpxchg(&head->first, old_entry, next)) != old_entry);
> +
> +	return entry;
> +}
> +
> +/**
> + * llist_del_all - delete all entries from lock-less list
> + * @head:	the head of lock-less list to delete all entries
> + *
> + * If list is empty, return NULL, otherwise, delete all entries and
> + * return the pointer to the first entry.  The order of entries
> + * deleted is from the newest to the oldest added one.
> + */
> +static inline struct llist_node *llist_del_all(struct llist_head *head)
> +{
> +#ifndef CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG
> +	BUG_ON(in_nmi());
> +#endif
> +
> +	return xchg(&head->first, NULL);
> +}
>  #endif /* LLIST_H */
> --- a/lib/Kconfig
> +++ b/lib/Kconfig
> @@ -276,7 +276,4 @@ config CORDIC
>  	  so its calculations are in fixed point. Modules can select this
>  	  when they require this function. Module will be called cordic.
>  
> -config LLIST
> -	bool
> -
>  endmenu
> --- a/lib/Makefile
> +++ b/lib/Makefile
> @@ -116,8 +116,6 @@ obj-$(CONFIG_CPU_RMAP) += cpu_rmap.o
>  
>  obj-$(CONFIG_CORDIC) += cordic.o
>  
> -obj-$(CONFIG_LLIST) += llist.o
> -
>  hostprogs-y	:= gen_crc32table
>  clean-files	:= crc32table.h
>  
> --- a/lib/llist.c
> +++ /dev/null
> @@ -1,129 +0,0 @@
> -/*
> - * Lock-less NULL terminated single linked list
> - *
> - * The basic atomic operation of this list is cmpxchg on long.  On
> - * architectures that don't have NMI-safe cmpxchg implementation, the
> - * list can NOT be used in NMI handler.  So code uses the list in NMI
> - * handler should depend on CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG.
> - *
> - * Copyright 2010,2011 Intel Corp.
> - *   Author: Huang Ying <ying.huang@intel.com>
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License version
> - * 2 as published by the Free Software Foundation;
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write to the Free Software
> - * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
> - */
> -#include <linux/kernel.h>
> -#include <linux/module.h>
> -#include <linux/interrupt.h>
> -#include <linux/llist.h>
> -
> -#include <asm/system.h>
> -
> -/**
> - * llist_add - add a new entry
> - * @new:	new entry to be added
> - * @head:	the head for your lock-less list
> - */
> -void llist_add(struct llist_node *new, struct llist_head *head)
> -{
> -	struct llist_node *entry, *old_entry;
> -
> -#ifndef CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG
> -	BUG_ON(in_nmi());
> -#endif
> -
> -	entry = head->first;
> -	do {
> -		old_entry = entry;
> -		new->next = entry;
> -		cpu_relax();
> -	} while ((entry = cmpxchg(&head->first, old_entry, new)) != old_entry);
> -}
> -EXPORT_SYMBOL_GPL(llist_add);
> -
> -/**
> - * llist_add_batch - add several linked entries in batch
> - * @new_first:	first entry in batch to be added
> - * @new_last:	last entry in batch to be added
> - * @head:	the head for your lock-less list
> - */
> -void llist_add_batch(struct llist_node *new_first, struct llist_node *new_last,
> -		     struct llist_head *head)
> -{
> -	struct llist_node *entry, *old_entry;
> -
> -#ifndef CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG
> -	BUG_ON(in_nmi());
> -#endif
> -
> -	entry = head->first;
> -	do {
> -		old_entry = entry;
> -		new_last->next = entry;
> -		cpu_relax();
> -	} while ((entry = cmpxchg(&head->first, old_entry, new_first)) != old_entry);
> -}
> -EXPORT_SYMBOL_GPL(llist_add_batch);
> -
> -/**
> - * llist_del_first - delete the first entry of lock-less list
> - * @head:	the head for your lock-less list
> - *
> - * If list is empty, return NULL, otherwise, return the first entry
> - * deleted, this is the newest added one.
> - *
> - * Only one llist_del_first user can be used simultaneously with
> - * multiple llist_add users without lock.  Because otherwise
> - * llist_del_first, llist_add, llist_add (or llist_del_all, llist_add,
> - * llist_add) sequence in another user may change @head->first->next,
> - * but keep @head->first.  If multiple consumers are needed, please
> - * use llist_del_all or use lock between consumers.
> - */
> -struct llist_node *llist_del_first(struct llist_head *head)
> -{
> -	struct llist_node *entry, *old_entry, *next;
> -
> -#ifndef CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG
> -	BUG_ON(in_nmi());
> -#endif
> -
> -	entry = head->first;
> -	do {
> -		if (entry == NULL)
> -			return NULL;
> -		old_entry = entry;
> -		next = entry->next;
> -		cpu_relax();
> -	} while ((entry = cmpxchg(&head->first, old_entry, next)) != old_entry);
> -
> -	return entry;
> -}
> -EXPORT_SYMBOL_GPL(llist_del_first);
> -
> -/**
> - * llist_del_all - delete all entries from lock-less list
> - * @head:	the head of lock-less list to delete all entries
> - *
> - * If list is empty, return NULL, otherwise, delete all entries and
> - * return the pointer to the first entry.  The order of entries
> - * deleted is from the newest to the oldest added one.
> - */
> -struct llist_node *llist_del_all(struct llist_head *head)
> -{
> -#ifndef CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG
> -	BUG_ON(in_nmi());
> -#endif
> -
> -	return xchg(&head->first, NULL);
> -}
> -EXPORT_SYMBOL_GPL(llist_del_all);

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
