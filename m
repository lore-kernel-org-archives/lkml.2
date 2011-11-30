Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783Ab1K3ETp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 23:19:45 -0500
Received: from gate.crashing.org ([63.228.1.57]:35827 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751996Ab1K3ETo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 23:19:44 -0500
Message-ID: <1322626752.21641.22.camel@pasglop>
Subject: Re: [BUG?]3.0-rc4+ftrace+kprobe: set kprobe at instruction 'stwu'
 lead to system crash/freeze
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "tiejun.chen" <tiejun.chen@windriver.com>
Cc: Yong Zhang <yong.zhang0@gmail.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, paulus@samba.org,
        yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linuxppc-dev@lists.ozlabs.org, Anton Blanchard <anton@au1.ibm.com>
Date: Wed, 30 Nov 2011 15:19:12 +1100
In-Reply-To: <4E0D9B5E.3010901@windriver.com>
References: <BANLkTi=gx73d6-s-jqeke05SQYorpnzLVw@mail.gmail.com>
	 <1308911347.531.56.camel@gandalf.stny.rr.com>
	 <4E074671.7060100@hitachi.com> <20110627100104.GA24705@in.ibm.com>
	 <BANLkTimYej4_dmBqvPBCLej=JA5atLrZVA@mail.gmail.com>
	 <4E0D9B5E.3010901@windriver.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-01 at 18:03 +0800, tiejun.chen wrote:
> 
> Here emulate_step() is called to emulate 'stwu'. Actually this is equivalent to
> 1> update pr_regs->gpr[1] = mem(old r1 + (-A))
> 2> 'stw <old r1>, mem<(old r1 + (-A)) >
> 
> You should notice the stack based on new r1 would be covered with mem<old r1
> +(-A)>. So after this, the kernel exit from post_krpobe, something would be
> broken. This should depend on sizeof(-A).
> 
> For kprobe show_interrupts, you can see pregs->nip is re-written violently so
> kernel issued.
> 
> But sometimes we may only re-write some violate registers the kernel still
> alive. And so this is just why the kernel works well for some kprobed point
> after you change some kernel options/toolchains.
> 
> If I'm correct its difficult to kprobe these stwu sp operation since the
> sizeof(-A) is undermined for the kernel. So we have to implement in-depend
> interrupt stack like PPC64.

So I've spent a lot of time trying to find a better way to fix that bug
and I think I might have finally found one :-)

 - When you try to emulate stwcx on the kernel stack (and only there),
don't actually perform the store. Set a TIF flag instead to indicate
special processing in the exception return path and store the address to
update somewhere either in a free slot of the stack frame itself of
somewhere in the thread struct (the former would be easier). You may as
well do some sanity checking on the value while at it to catch errors
early.

 - In the exception return code, we already test for various TIF flags
(*** see comment below, it's even buggy today for preempt ***), so we
add a test for that flag and go to do_work.

 - At the end of do_work, we check for this TIF flag. If it's not set or
any other flag is set, move on as usual. However, if it's the only flag
still set:

 - Copy the exception frame we're about to unwind to just -below- the
new r1 value we want to write to. Then perform the write, and change
r1 to point to that copy of the frame.

 - Branch to restore: which will unwind everything from that copy of
the frame, and eventually set r1 to GPR(1) in the copy which contains
the new value of r1.

This is the less intrusive approach and should work just fine, it's also
more robust than anything I've been able to think of and the approach
would work for 32 and 64-bit similarily.

(***) Above comment about a bug: If you look at entry_64.S version of
ret_from_except_lite you'll notice that in the !preempt case, after
we've checked MSR_PR we test for any TIF flag in _TIF_USER_WORK_MASK to
decide whether to go to do_work or not. However, in the preempt case, we
do a convoluted trick to test SIGPENDING only if PR was set and always
test NEED_RESCHED ... but we forget to test any other bit of
_TIF_USER_WORK_MASK !!! So that means that with preempt, we completely
fail to test for things like single step, syscall tracing, etc...

I think this should be fixed at the same time, by simplifying the code
by doing:

 - Test PR. If set, go to test_work_user, else continue (or the other
way around and call it test_work_kernel)

 - In test_work_user, always test for _TIF_USER_WORK_MASK to decide to
go to do_work, maybe call it do_user_work

 - In test_work_kernel, test for _TIF_KERNEL_WORK_MASK which is set to
our new flag along with NEED_RESCHED if preempt is enabled and branch to
do_kernel_work.

do_user_work is basically the same as today's user_work

do_kernel_work is basically the same as today preempt block with added
code to handle the new flag as described above.

Is anybody volunteering for fixing that ? I don't have the bandwidth
right now, but if nobody shows up I suppose I'll have to eventually deal
with it myself :-)

Cheers,
Ben.


