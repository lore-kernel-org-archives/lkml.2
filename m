Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924Ab2E2NQp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 09:16:45 -0400
Received: from casper.infradead.org ([85.118.1.10]:55507 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369Ab2E2NQo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 09:16:44 -0400
Message-ID: <1338297385.26856.74.camel@twins>
Subject: Re: [PATCH 13/35] autonuma: add page structure fields
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Hillf Danton <dhillf@gmail.com>, Dan Smith <danms@us.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Bharata B Rao <bharata.rao@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Christoph Lameter <cl@linux.com>
Date: Tue, 29 May 2012 15:16:25 +0200
In-Reply-To: <1337965359-29725-14-git-send-email-aarcange@redhat.com>
References: <1337965359-29725-1-git-send-email-aarcange@redhat.com>
	 <1337965359-29725-14-git-send-email-aarcange@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-25 at 19:02 +0200, Andrea Arcangeli wrote:

> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index 780ded7..e8dc82c 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -126,6 +126,31 @@ struct page {
>  		struct page *first_page;	/* Compound tail pages */
>  	};
>  
> +#ifdef CONFIG_AUTONUMA
> +	/*
> +	 * FIXME: move to pgdat section along with the memcg and allocate
> +	 * at runtime only in presence of a numa system.
> +	 */
> +	/*
> +	 * To modify autonuma_last_nid lockless the architecture,
> +	 * needs SMP atomic granularity < sizeof(long), not all archs
> +	 * have that, notably some alpha. Archs without that requires
> +	 * autonuma_last_nid to be a long.
> +	 */
> +#if BITS_PER_LONG > 32
> +	int autonuma_migrate_nid;
> +	int autonuma_last_nid;
> +#else
> +#if MAX_NUMNODES >= 32768
> +#error "too many nodes"
> +#endif
> +	/* FIXME: remember to check the updates are atomic */
> +	short autonuma_migrate_nid;
> +	short autonuma_last_nid;
> +#endif
> +	struct list_head autonuma_migrate_node;
> +#endif
> +
>  	/*
>  	 * On machines where all RAM is mapped into kernel address space,
>  	 * we can simply calculate the virtual address. On machines with


24 bytes per page.. or ~0.6% of memory gone. This is far too great a
price to pay.

At LSF/MM Rik already suggested you limit the number of pages that can
be migrated concurrently and use this to move the extra list_head out of
struct page and into a smaller amount of extra structures, reducing the
total overhead.


