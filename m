Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757431Ab1EYIO0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 04:14:26 -0400
Received: from www.linutronix.de ([62.245.132.108]:55240 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755712Ab1EYIOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 04:14:23 -0400
Date: Wed, 25 May 2011 10:14:20 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Milton Miller <miltonm@bga.com>
cc: linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/4] sparse irq: protect irq_to_desc against
 irq_free_descs
In-Reply-To: <rcu-lock-radix-lookup-sparse-irq@mdm.bga.com>
Message-ID: <alpine.LFD.2.02.1105250958380.3078@ionos>
References: <generic-irq-changes@mdm.bga.com> <rcu-lock-radix-lookup-sparse-irq@mdm.bga.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 May 2011, Milton Miller wrote:
> The radix-tree code uses call_rcu to delay freeing internal data
> elements when removing when deleting an entry.  We must protect
> against the elements being freed while we traverse the tree.
> 
> While preparing a patch to expand the contexts in which the radix
> tree optionally used by powerpc for mapping hardware irq numbers to
> linux numbers would be called, I realized that the radix tree was
> not locked when radix_tree_lookup was called.  I then realized the
> same issue applies to the generic irq code when sparse irqs are in use.
> 
> While the powerpc radix tree was only referenced from one callsite
> that was irqs_disabled and irq_enter, irq_to_desc is called from
> many more contexts including threaded irq handlers and other
> process contexts.
> 
> This does not show up in the rcu lockdep because in 2.6.34 commit
> 2676a58c98 (radix-tree: Disable RCU lockdep checking in radix tree)
> deemed it too hard to pass the condition of the protecting lock
> to the library.
> 
> Signed-off-by: Milton Miller <miltonm@bga.com>
> Cc: <stable@kernel.org>
> ---
> I expect the relatively infrequent calls to irq_free_descs, combined
> with most calls to irq_to_desc being irqs_disabled and the fact
> merged to mainline implemntations of call_rcu requiring a cpu to
> respond to a hard irq or schedule has hidden this error to date.

The reason why nobody ever noticed is that the free happens in the
teardown path of PCI devices and at this point nothing accesses that
irq anymore.
 
> Index: work.git/kernel/irq/irqdesc.c
> ===================================================================
> --- work.git.orig/kernel/irq/irqdesc.c	2011-05-23 13:34:08.728585785 -0500
> +++ work.git/kernel/irq/irqdesc.c	2011-05-23 13:46:09.197635762 -0500
> @@ -108,7 +108,13 @@ static void irq_insert_desc(unsigned int
>  
>  struct irq_desc *irq_to_desc(unsigned int irq)
>  {
> -	return radix_tree_lookup(&irq_desc_tree, irq);
> +	struct irq_desc *desc;
> +
> +	rcu_read_lock();
> +	desc = radix_tree_lookup(&irq_desc_tree, irq);
> +	rcu_read_unlock();
> +
> +	return desc

That does not really compile :)

And it does not help at all because we unconditionally free the irq
descriptor and do not use rcu based kfree. Further you protect only
the lookup and not the complete section which uses the descriptor, so
it could go away after the rcu_read_unlock() in theory.

Thanks,

	tglx
