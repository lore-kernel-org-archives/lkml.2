Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871Ab1K3VA4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 16:00:56 -0500
Received: from gate.crashing.org ([63.228.1.57]:50245 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752494Ab1K3VAz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 16:00:55 -0500
Message-ID: <1322686809.29041.10.camel@pasglop>
Subject: Re: [BUG?]3.0-rc4+ftrace+kprobe: set kprobe at instruction 'stwu'
 lead to system crash/freeze
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "tiejun.chen" <tiejun.chen@windriver.com>
Cc: Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Anton Blanchard <anton@au1.ibm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Yong Zhang <yong.zhang0@gmail.com>, paulus@samba.org,
        yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linuxppc-dev@lists.ozlabs.org
Date: Thu, 01 Dec 2011 08:00:09 +1100
In-Reply-To: <4ED60E2B.8030603@windriver.com>
References: <BANLkTi=gx73d6-s-jqeke05SQYorpnzLVw@mail.gmail.com>
	 <1308911347.531.56.camel@gandalf.stny.rr.com>
	 <4E074671.7060100@hitachi.com> <20110627100104.GA24705@in.ibm.com>
	 <BANLkTimYej4_dmBqvPBCLej=JA5atLrZVA@mail.gmail.com>
	 <4E0D9B5E.3010901@windriver.com> <1322626752.21641.22.camel@pasglop>
	 <4ED60E2B.8030603@windriver.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-30 at 19:06 +0800, tiejun.chen wrote:

> >  - Copy the exception frame we're about to unwind to just -below- the
> > new r1 value we want to write to. Then perform the write, and change
> > r1 to point to that copy of the frame.
> > 
> >  - Branch to restore: which will unwind everything from that copy of
> > the frame, and eventually set r1 to GPR(1) in the copy which contains
> > the new value of r1.
> 
> We still can't restore this there.

Yes, we can since we have copied the pt_regs down to -below- where we
are going to write to. That's the whole trick. We copy the pt_regs
somewhere "safe" and restore from there.

> I mean we have to do that real restore here. So I'm really not sure if its a
> good way to add such a codes including check TIF/copy-get new r1/restore
> operation here since this is so deep for the exception return code.

No. Re-read my explanation.

In the do_work case (so when things are still easy), we copy the pt_regs
of the return frame to a safe place (right below where we want to write
to typically), and change r1 to point to this "new" frame which we use
to restore from. Then we do the store which is now safe and go to an
unmodified "restore" exit path.

> > This is the less intrusive approach and should work just fine, it's also
> > more robust than anything I've been able to think of and the approach
> > would work for 32 and 64-bit similarily.
> > 
> > (***) Above comment about a bug: If you look at entry_64.S version of
> > ret_from_except_lite you'll notice that in the !preempt case, after
> > we've checked MSR_PR we test for any TIF flag in _TIF_USER_WORK_MASK to
> > decide whether to go to do_work or not. However, in the preempt case, we
> > do a convoluted trick to test SIGPENDING only if PR was set and always
> > test NEED_RESCHED ... but we forget to test any other bit of
> > _TIF_USER_WORK_MASK !!! So that means that with preempt, we completely
> > fail to test for things like single step, syscall tracing, etc...
> > 
> 
> This is another problem we should address.
> 
> > I think this should be fixed at the same time, by simplifying the code
> > by doing:
> > 
> >  - Test PR. If set, go to test_work_user, else continue (or the other
> > way around and call it test_work_kernel)
> > 
> >  - In test_work_user, always test for _TIF_USER_WORK_MASK to decide to
> > go to do_work, maybe call it do_user_work
> > 
> >  - In test_work_kernel, test for _TIF_KERNEL_WORK_MASK which is set to
> > our new flag along with NEED_RESCHED if preempt is enabled and branch to
> > do_kernel_work.
> > 
> > do_user_work is basically the same as today's user_work
> > 
> > do_kernel_work is basically the same as today preempt block with added
> > code to handle the new flag as described above.
> > 
> > Is anybody volunteering for fixing that ? I don't have the bandwidth
> 
> I always use one specific kprobe stack to fix this for BOOKE and work well in my
> local tree :) Do you remember my v3 patch? I think its possible to extend this
> for all PPC variants.
>
> Anyway, I'd like to be this volunteer with our last solution.

So the second problem I exposed, for which you just volunteered
(hint :-) is an orthogonal issue not related to kprobe or stacks which
happen to be something I discovered yesterday while looking at the code.

As for the solution to the emulation problem, re-read my explanation.
The whole trick is that we can avoid a separate stack (which I really
want to avoid) and we can avoid touching the low level restore code
path.

Cheers,
Ben.


