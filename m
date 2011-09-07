Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757473Ab1IGXZy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 19:25:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47750 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755695Ab1IGXZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 19:25:53 -0400
Date: Wed, 7 Sep 2011 16:25:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, jeremy@goop.org,
        hughd@google.com, ngupta@vflare.org, konrad.wilk@oracle.com,
        JBeulich@novell.com, kurt.hackel@oracle.com, npiggin@kernel.dk,
        riel@redhat.com, hannes@cmpxchg.org, matthew@wil.cx,
        chris.mason@oracle.com, sjenning@linux.vnet.ibm.com,
        kamezawa.hiroyu@jp.fujitsu.com, jackdachef@gmail.com,
        cyclonusj@gmail.com, levinsasha928@gmail.com
Subject: Re: [PATCH V8 2/4] mm: frontswap: core code
Message-Id: <20110907162510.3547d67a.akpm@linux-foundation.org>
In-Reply-To: <20110829164908.GA27200@ca-server1.us.oracle.com>
References: <20110829164908.GA27200@ca-server1.us.oracle.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Aug 2011 09:49:09 -0700
Dan Magenheimer <dan.magenheimer@oracle.com> wrote:

> From: Dan Magenheimer <dan.magenheimer@oracle.com>
> Subject: [PATCH V8 2/4] mm: frontswap: core code
> 
> This second patch of four in this frontswap series provides the core code
> for frontswap that interfaces between the hooks in the swap subsystem and
> a frontswap backend via frontswap_ops.
> 
> Two new files are added: mm/frontswap.c and include/linux/frontswap.h
> 
> Credits: Frontswap_ops design derived from Jeremy Fitzhardinge
> design for tmem; sysfs code modelled after mm/ksm.c
> 
>
> ...
>
> --- linux/include/linux/frontswap.h	1969-12-31 17:00:00.000000000 -0700
> +++ frontswap/include/linux/frontswap.h	2011-08-29 09:52:14.304747064 -0600
> @@ -0,0 +1,125 @@
> +#ifndef _LINUX_FRONTSWAP_H
> +#define _LINUX_FRONTSWAP_H
> +
> +#include <linux/swap.h>
> +#include <linux/mm.h>
> +
> +struct frontswap_ops {
> +	void (*init)(unsigned);
> +	int (*put_page)(unsigned, pgoff_t, struct page *);
> +	int (*get_page)(unsigned, pgoff_t, struct page *);
> +	void (*flush_page)(unsigned, pgoff_t);
> +	void (*flush_area)(unsigned);
> +};

Please don't use the term "flush".  In both the pagecache code and the
pte code it is interchangably used to refer to both writeback and
invalidation.  The way to avoid this ambiguity and confusion is to use
the terms "writeback" and "invalidate" instead.

Here, you're referring to invalidation.

>
> ...
>
> +/*
> + * frontswap_ops is set by frontswap_register_ops to contain the pointers
> + * to the frontswap "backend" implementation functions.
> + */
> +static struct frontswap_ops frontswap_ops;

__read_mostly?

> +/*
> + * This global enablement flag reduces overhead on systems where frontswap_ops
> + * has not been registered, so is preferred to the slower alternative: a
> + * function call that checks a non-global.
> + */
> +int frontswap_enabled;

__read_mostly?

bool?

> +EXPORT_SYMBOL(frontswap_enabled);
> +
> +/*
> + * Useful stats available in /sys/kernel/mm/frontswap.  These are for
> + * information only so are not protected against increment/decrement races.
> + */
> +static unsigned long frontswap_gets;
> +static unsigned long frontswap_succ_puts;
> +static unsigned long frontswap_failed_puts;
> +static unsigned long frontswap_flushes;

If they're in /sys/kernel/mm then they rather become permanent parts of
the exported kernel interface.  We're stuck with them.  Plus they're
inaccurate and updating them might be inefficient, so we don't want to
be stuck with them.

I suggest moving these to debugfs from where we can remove them if we
feel like doing so.

>
> ...
>
> +/*
> + * Frontswap, like a true swap device, may unnecessarily retain pages
> + * under certain circumstances; "shrink" frontswap is essentially a
> + * "partial swapoff" and works by calling try_to_unuse to attempt to
> + * unuse enough frontswap pages to attempt to -- subject to memory
> + * constraints -- reduce the number of pages in frontswap
> + */
> +void frontswap_shrink(unsigned long target_pages)

It's unclear whether `target_pages' refers to the number of pages to
remove or to the number of pages to retain.  A comment is needed.

> +{
> +	int wrapped = 0;
> +	bool locked = false;
> +
> +	/* try a few times to maximize chance of try_to_unuse success */

Why?  Is this necessary?  How often does try_to_unuse fail?

> +	for (wrapped = 0; wrapped < 3; wrapped++) {

`wrapped' seems an inappropriate identifier.

> +

unneeded newline

> +		struct swap_info_struct *si = NULL;
> +		int si_frontswap_pages;
> +		unsigned long total_pages = 0, total_pages_to_unuse;
> +		unsigned long pages = 0, pages_to_unuse = 0;
> +		int type;
> +
> +		/*
> +		 * we don't want to hold swap_lock while doing a very
> +		 * lengthy try_to_unuse, but swap_list may change
> +		 * so restart scan from swap_list.head each time
> +		 */
> +		spin_lock(&swap_lock);
> +		locked = true;
> +		total_pages = 0;
> +		for (type = swap_list.head; type >= 0; type = si->next) {
> +			si = swap_info[type];
> +			total_pages += atomic_read(&si->frontswap_pages);
> +		}
> +		if (total_pages <= target_pages)
> +			goto out;
> +		total_pages_to_unuse = total_pages - target_pages;
> +		for (type = swap_list.head; type >= 0; type = si->next) {
> +			si = swap_info[type];
> +			si_frontswap_pages = atomic_read(&si->frontswap_pages);
> +			if (total_pages_to_unuse < si_frontswap_pages)
> +				pages = pages_to_unuse = total_pages_to_unuse;
> +			else {
> +				pages = si_frontswap_pages;
> +				pages_to_unuse = 0; /* unuse all */
> +			}
> +			if (security_vm_enough_memory_kern(pages))

What's this doing here?  Needs a comment please.

> +				continue;
> +			vm_unacct_memory(pages);

hm, is that accurate?  Or should we account for the pages which
try_to_unuse() actually unused?

> +			break;
> +		}
> +		if (type < 0)
> +			goto out;
> +		locked = false;
> +		spin_unlock(&swap_lock);
> +		try_to_unuse(type, true, pages_to_unuse);
> +	}
> +
> +out:
> +	if (locked)
> +		spin_unlock(&swap_lock);
> +	return;
> +}
> +EXPORT_SYMBOL(frontswap_shrink);
> +
> +/*
> + * Count and return the number of pages frontswap pages across all

s/pages//

> + * swap devices.  This is exported so that a kernel module can
> + * determine current usage without reading sysfs.

Which kernel module might want to do this?

> + */
> +unsigned long frontswap_curr_pages(void)
> +{
> +	int type;
> +	unsigned long totalpages = 0;
> +	struct swap_info_struct *si = NULL;
> +
> +	spin_lock(&swap_lock);
> +	for (type = swap_list.head; type >= 0; type = si->next) {
> +		si = swap_info[type];
> +		if (si != NULL)
> +			totalpages += atomic_read(&si->frontswap_pages);
> +	}
> +	spin_unlock(&swap_lock);
> +	return totalpages;
> +}
> +EXPORT_SYMBOL(frontswap_curr_pages);
> +
> +#ifdef CONFIG_SYSFS

Has the code been tested with CONFIG_SYSFS=n?

>
> ...
>

