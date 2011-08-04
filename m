Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755052Ab1HDRcZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 13:32:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22171 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754446Ab1HDRcT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 13:32:19 -0400
Date: Thu, 4 Aug 2011 13:31:45 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 3.0-git15 Atomic scheduling in pidmap_init
Message-ID: <20110804173145.GM2096@zod.bos.redhat.com>
References: <20110801154636.GA2096@zod.bos.redhat.com>
 <CA+5PVA5EZWHv_tuzA22twGQ7rZZ2zhqi1zs6OiFbpORiiYbzMg@mail.gmail.com>
 <20110804140438.GT13065@linux.vnet.ibm.com>
 <20110804150603.GL2096@zod.bos.redhat.com>
 <20110804162658.GZ13065@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110804162658.GZ13065@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 04, 2011 at 09:26:58AM -0700, Paul E. McKenney wrote:
> > > You really do need to be able to handle set_need_resched() at random
> > > times, and at first glance it appears to me that the warning could be
> > > triggered at runtime as well.  If so, the real fix is elsewhere, right?
> > > Especially given that the patch imposes extra cost at runtime...
> > 
> > In staring at it for a while it seems to be a combination of being in
> > atomic context according to the scheduler but things in early boot using
> > GFP_KERNEL.  At the point we're at in the boot, that is perfectly legal
> > as it's not being called from an interrupt handler and the mm subsystem
> > should be all setup, but we're still really early in boot and preempt is
> > disabled.
> 
> Isn't preemption disabled at that point in boot?  And isn't GFP_KERNEL
> illegal within preemption-disabled regions?

Yes, it's disabled.  I'm not sure if it's illegal or not.  pidmap_init
is called from start_kernel on line 598 of main.c.  local_irq_enable is
called on line 553, followed immediately by this comment:

	/* Interrupts are enabled now so all GFP allocations are safe. */
	gfp_allowed_mask = __GFP_BITS_MASK;

	kmem_cache_init_late();

So the comments there lead me to think I have no clue :).  That's mostly
why I'm asking for feedback here.  I don't have a huge amount of
experience in what is and isn't allowed in the early bootup path.

> >            As I mentioned before, KMEM_CACHE calls kmalloc with
> > GFP_KERNEL and I don't think we want to change that.
> > 
> > Once we're past early boot, I would expect that things running in true
> > atomic context won't be calling KMEM_CACHE or using GFP_KERNEL.  Or
> > maybe I hope?
> > 
> > I understand the desire to avoid another conditional, but I certainly
> > don't have any other suggestions at the moment.
> 
> How about doing GFP_ATOMIC on allocations done during that portion
> of the boot patch for which preemption is disabled?

Well, in the pidmap_init case there are two spots relevant to this.  The
first is the kzalloc call on line 562 of kernel/pid.c.  I could change
that to use GFP_IOFS even, and it avoids the backtrace from there. (And
I did that originally.)

However, the call on line 567 to KMEM_CACHE calls into
kmem_cache_create.  There is a flags variable, but it's for slab flags,
and kmem_cache_create calls kmalloc internally with GFP_KERNEL.  I don't
see kmem_cache_create_atomic or otherwise that would avoid this.  None
of that code is new either, most if it dating back to 2008.

The same issue exists in some of the next functions called in
start_kernel, like anon_vma_init, cred_init, fork_init, etc.  They all
call kmem_cache_create.

I could be missing something obvious, but I don't see a way to avoid
using GFP_KERNEL without a lot of rip-up in the rest of the init path.

josh
