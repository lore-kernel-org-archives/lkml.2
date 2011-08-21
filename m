Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325Ab1HUImw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 04:42:52 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60979 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135Ab1HUImu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 04:42:50 -0400
Date: Sun, 21 Aug 2011 09:42:30 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, mingo@redhat.com,
        Richard Weinberger <richard@nod.at>,
        user-mode-linux-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, Andrew Lutomirski <luto@mit.edu>
Subject: SYSCALL, ptrace and syscall restart breakages (Re: [RFC] weird crap
 with vdso on uml/i386)
Message-ID: <20110821084230.GI2203@ZenIV.linux.org.uk>
References: <20110818191946.GW2203@ZenIV.linux.org.uk>
 <20110819043120.GY2203@ZenIV.linux.org.uk>
 <4E4E2427.9080602@nod.at>
 <20110820011845.GC2203@ZenIV.linux.org.uk>
 <4E4FD12F.70508@nod.at>
 <20110820201406.GF2203@ZenIV.linux.org.uk>
 <4E501F51.9060905@nod.at>
 <CAObL_7FoPHu6AKneswjEmiU4UBjUuKpYahakOaTNXM3=ZCpYaA@mail.gmail.com>
 <CAObL_7H8E1fde-d_Kfjrg2mQ5PdAp9X=fVRTqXJKzzYmQ1vAQQ@mail.gmail.com>
 <20110821063443.GH2203@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110821063443.GH2203@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 21, 2011 at 07:34:43AM +0100, Al Viro wrote:
> Suppose we have a traced process.  foo6() is called and the thing it
> stopped before the sys_foo6() is reached kernel-side.  The sixth argument
> is on stack, ebp is set to user esp.  SYSENTER happens, we read the
> 6th argument from userland stack and put it along with the rest into
> pt_regs.  tracer examines the arguments, modifies them (including the last
> one) and lets the tracee run free - e.g. detaches from the tracee.  
> 
> What should happen if we happen to get a signal that would restart that
> sucker?  Granted, it's not going to happen with mmap() - it doesn't, AFAICS,
> do anything of that kind.  However, I wouldn't bet a dime on other 6-argument
> syscalls not stepping on that.  sendto() and recvfrom(), in particular...
> 
> OK, we return to userland.  The sixth argument is placed into %ebp.  Linus'
> "pig and proud of that" trick works and we end up slapping userland
> %esp into %ebp and hitting SYSENTER again.  Only one problem, though -
> the sixth argument on user stack is completely unaffected by what tracer
> had done.  Unlike the rest of arguments, that *are* changed.
> 
> We could deal with that in case of SYSENTER if we e.g. replaced that
>         jmp .Lenter_kernel
> with
>         jmp .Lrestart
> and added
> .Lrestart:
> 	movl %ebp, (%esp)
> 	jmp .Lenter_kernel
> but in case of SYSCALL it seems to be even messier...  Comments?

Oh, hell...  Compat SYSCALL one is really buggered on syscall restarts,
ptrace or no ptrace.  Look: calling conventions for SYSCALL are
	arg1..5: ebx, ebp, edx, edi, esi.  arg6: stack
and after syscall restart we end up with
	arg1..5: ebx, ecx, edx, edi, esi.  arg6: ebp
so restart will instantly clobber arg2, in effect replacing it with arg6.

And yes, adding ptrace to the mix makes things even uglier.  For one thing,
changes to ECX via ptrace are completely lost on the fast exit.  Not pretty,
and might make life painful for uml, but not for the majority of programs.
What's worse, combination of ptrace with restart will lose changes to arg6
(again, value on stack left as it was, changes to arg6 by tracer lost) *and*
it will lose changes to arg2 (along with arg2 itself - see above).

Linus' Dirty Trick(tm) is not trivial to apply - with SYSCALL we *do* retain
the address of next insn and that's where we end up going.  IOW, SYSCALL not
inside vdso32 currently works (for small values of "works", due to restart
issues).  Playing with return elsewhere might break some userland code...

Guys, that's *way* out of the area I'm comfortable with.
