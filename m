Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786Ab2BANyY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 08:54:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23695 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753024Ab2BANyW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 08:54:22 -0500
Date: Wed, 1 Feb 2012 11:50:20 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, paulmck@linux.vnet.ibm.com,
        Oleg Nesterov <oleg@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Subject: Re: [RFC][PATCH] srcu: Implement call_srcu()
Message-ID: <20120201135020.GB18998@amt.cnet>
References: <1328016724.2446.229.camel@twins>
 <4F27F0E6.1040309@redhat.com>
 <1328017807.2446.230.camel@twins>
 <20120131222447.GH2391@linux.vnet.ibm.com>
 <1328091749.2760.34.camel@laptop>
 <4F29178A.1090306@redhat.com>
 <4F2918D5.4050104@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F2918D5.4050104@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 01, 2012 at 12:49:57PM +0200, Avi Kivity wrote:
> On 02/01/2012 12:44 PM, Avi Kivity wrote:
> > On 02/01/2012 12:22 PM, Peter Zijlstra wrote:
> > > One of the things I was thinking of is adding a sequence counter in the
> > > per-cpu data. Using that we could do something like:
> > >
> > >   unsigned int seq1 = 0, seq2 = 0, count = 0;
> > >   int cpu, idx;
> > >
> > >   idx = ACCESS_ONCE(sp->completions) & 1;
> > >
> > >   for_each_possible_cpu(cpu)
> > > 	seq1 += per_cpu(sp->per_cpu_ref, cpu)->seq;
> > >
> > >   for_each_possible_cpu(cpu)
> > > 	count += per_cpu(sp->per_cpu_ref, cpu)->c[idx];
> > >
> > >   for_each_possible_cpu(cpu)
> > > 	seq2 += per_cpu(sp->per_cpu_ref, cpu)->seq;
> > >
> > >   /*
> > >    * there's no active references and no activity, we pass
> > >    */
> > >   if (seq1 == seq2 && count == 0)
> > > 	return;
> > >
> > >   synchronize_srcu_slow();
> > >
> > >
> > > This would add a fast-path which should catch the case Avi outlined
> > > where we call sync_srcu() when there's no other SRCU activity.
> >
> > Sorry, I was inaccurate.  In two of the cases indeed we don't expect
> > guest activity, and we're okay with waiting a bit if there is guest
> > activity - when we're altering the guest physical memory map.  But the
> > third case does have concurrent guest activity with
> > synchronize_srcu_expedited() and we still need it fast - that's when
> > userspace reads the dirty bitmap log of a running guest and replaces it
> > with a new bitmap.
> >
> > There may be a way to convert it to call_srcu() though.  Without
> > synchronize_srcu_expedited(), kvm sees both the old and the new bitmaps,
> > but that's fine, since the dirty bits will go *somewhere*, and we can
> > pick them up later in call_srcu().  The only problem is if this is the
> > very last call to kvm_vm_ioctl_get_dirty_log(), and the callback
> > triggers after it returns - we end up with a bag of bits with not one to
> > return them to.  Maybe we can detect this conditions (all vcpus ought to
> > be stopped), and do something like:
> >
> >
> >    if (all vcpus stopped) {
> >         /* no activity, this should be fast */
> >         synchronize_srcu()
> >         /* collect and return bits */
> >    } else {
> >         call_srcu(collect bits)
> >    }
> >
> > still a snag - we can't reliably detect that all vcpus are stopped, they
> > may be just resting in userspace, and restart while synchronize_srcu()
> > is running.
> >
> > Marcelo?
> >

VGABIOS mode constantly destroys and creates 0xa0000 slot, so
performance is required for KVM_SET_MEM too (it can probably be fixed in
qemu, but older qemu's must be supported).

For KVM it would be better for synchronize_srcu_expedited() to remain
relatively fast (think heavy users of GET_DIRTY_LOG such as Kemari),
even if slower than it is today.

synchronize_srcu() takes 10ms or so.

> Or something completely different - we can remove srcu from the equation
> completely in this case.  Use just one bitmap (so no
> rcu_assign_pointer), and use atomic operations to copy and clear:
> 
>   word = bitmap[i]
>   put_user(word)
>   atomic_and(&bitmap[i], ~word)
> 
> 
> -- 
> error compiling committee.c: too many arguments to function
