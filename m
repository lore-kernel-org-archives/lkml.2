Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500Ab1HUNhj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 09:37:39 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:34720 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752365Ab1HUNhi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 09:37:38 -0400
MIME-Version: 1.0
In-Reply-To: <CAObL_7GXyzAzNjBtgye9BwXLyHm337oBTdjRDjbSPqoKZGWyyA@mail.gmail.com>
References: <20110818191946.GW2203@ZenIV.linux.org.uk> <20110819043120.GY2203@ZenIV.linux.org.uk>
 <4E4E2427.9080602@nod.at> <20110820011845.GC2203@ZenIV.linux.org.uk>
 <4E4FD12F.70508@nod.at> <20110820201406.GF2203@ZenIV.linux.org.uk>
 <4E501F51.9060905@nod.at> <CAObL_7FoPHu6AKneswjEmiU4UBjUuKpYahakOaTNXM3=ZCpYaA@mail.gmail.com>
 <CAObL_7H8E1fde-d_Kfjrg2mQ5PdAp9X=fVRTqXJKzzYmQ1vAQQ@mail.gmail.com>
 <20110821063443.GH2203@ZenIV.linux.org.uk> <20110821084230.GI2203@ZenIV.linux.org.uk>
 <CAObL_7GXyzAzNjBtgye9BwXLyHm337oBTdjRDjbSPqoKZGWyyA@mail.gmail.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Sun, 21 Aug 2011 09:37:18 -0400
X-Google-Sender-Auth: Gdzh8w0bCK54ENvJ5sNT8diBUTY
Message-ID: <CAObL_7HGJqP-hdXpdRLYkksfeVtQ1z1ngP58gdTnWwD57duaXA@mail.gmail.com>
Subject: Re: SYSCALL, ptrace and syscall restart breakages (Re: [RFC] weird
 crap with vdso on uml/i386)
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, mingo@redhat.com,
        Richard Weinberger <richard@nod.at>,
        user-mode-linux-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 21, 2011 at 7:24 AM, Andrew Lutomirski <luto@mit.edu> wrote:
> On Sun, Aug 21, 2011 at 4:42 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>> On Sun, Aug 21, 2011 at 07:34:43AM +0100, Al Viro wrote:
>>> Suppose we have a traced process.  foo6() is called and the thing it
>>> stopped before the sys_foo6() is reached kernel-side.  The sixth argument
>>> is on stack, ebp is set to user esp.  SYSENTER happens, we read the
>>> 6th argument from userland stack and put it along with the rest into
>>> pt_regs.  tracer examines the arguments, modifies them (including the last
>>> one) and lets the tracee run free - e.g. detaches from the tracee.
>>>
>>> What should happen if we happen to get a signal that would restart that
>>> sucker?  Granted, it's not going to happen with mmap() - it doesn't, AFAICS,
>>> do anything of that kind.  However, I wouldn't bet a dime on other 6-argument
>>> syscalls not stepping on that.  sendto() and recvfrom(), in particular...
>>>
>>> OK, we return to userland.  The sixth argument is placed into %ebp.  Linus'
>>> "pig and proud of that" trick works and we end up slapping userland
>>> %esp into %ebp and hitting SYSENTER again.  Only one problem, though -
>>> the sixth argument on user stack is completely unaffected by what tracer
>>> had done.  Unlike the rest of arguments, that *are* changed.
>>>
>>> We could deal with that in case of SYSENTER if we e.g. replaced that
>>>         jmp .Lenter_kernel
>>> with
>>>         jmp .Lrestart
>>> and added
>>> .Lrestart:
>>>       movl %ebp, (%esp)
>>>       jmp .Lenter_kernel
>>> but in case of SYSCALL it seems to be even messier...  Comments?
>>
>> Oh, hell...  Compat SYSCALL one is really buggered on syscall restarts,
>> ptrace or no ptrace.  Look: calling conventions for SYSCALL are
>>        arg1..5: ebx, ebp, edx, edi, esi.  arg6: stack
>> and after syscall restart we end up with
>>        arg1..5: ebx, ecx, edx, edi, esi.  arg6: ebp
>> so restart will instantly clobber arg2, in effect replacing it with arg6.
>>
>> And yes, adding ptrace to the mix makes things even uglier.  For one thing,
>> changes to ECX via ptrace are completely lost on the fast exit.  Not pretty,
>> and might make life painful for uml, but not for the majority of programs.
>> What's worse, combination of ptrace with restart will lose changes to arg6
>> (again, value on stack left as it was, changes to arg6 by tracer lost) *and*
>> it will lose changes to arg2 (along with arg2 itself - see above).
>>
>> Linus' Dirty Trick(tm) is not trivial to apply - with SYSCALL we *do* retain
>> the address of next insn and that's where we end up going.  IOW, SYSCALL not
>> inside vdso32 currently works (for small values of "works", due to restart
>> issues).  Playing with return elsewhere might break some userland code...
>>
>> Guys, that's *way* out of the area I'm comfortable with.
>>
>
> I don't see the point of all this hackery at all.  sysenter/sysexit
> indeed screws up some registers, but we can return on the iret path in
> the case of restart.
>
> So why do we lie to ptrace (and iret!) at all?  Why not just fill in
> pt_regs with the registers as they were (at least the
> non-clobbered-by-sysenter ones), set the actual C parameters correctly
> to contain the six arguments (in rdi, rsi, etc.), do the syscall, and
> return back to userspace without any funny business?  Is there some
> ABI reason that, once we've started lying to tracers, we have to keep
> doing so?

Gack.  Is this a holdover from the 32-bit code that shares the
argument save area with the parameters passed on the C stack?  If so,
we could just set up the argument save area honestly and pass the real
parameters in registers like 64-bit C code expects.

If the tracing and restart cases use iret to return to userspace, this
should all just work.  ptrace users shouldn't notice the overhead, and
syscall restart is presumably slow enough anyway that it wouldn't
matter.  The userspace entry code would be as simple as:

sysenter
ret

or

sysexit
ret

--Andy
