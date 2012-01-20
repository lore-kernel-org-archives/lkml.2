Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779Ab2ATPfo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 10:35:44 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39365 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179Ab2ATPfl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 10:35:41 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFyZ-=4J1hVSAJiBiZKgpvuh-t54KPjLijRmU=cBtdi3-w@mail.gmail.com>
References: <49017bd7edab7010cd9ac767e39d99e4.squirrel@webmail.greenhost.nl>
	<20120118015013.GR11715@one.firstfloor.org>
	<20120118020453.GL7180@jl-vm1.vm.bytemark.co.uk>
	<20120118022217.GS11715@one.firstfloor.org>
	<fc8f165e541482d136ff8fc115fe6875.squirrel@webmail.greenhost.nl>
	<CA+55aFysH3h8sLHwNcaLnYMsgA28vmHgd3DSLPVw-=TzgfBrbg@mail.gmail.com>
	<CA+55aFzk6OOHoQ_e3pPQNUGN80tjXT7vYTNaRjXbWiQUnNRiTA@mail.gmail.com>
	<fd4ccb42a25876131e411299d24d9151.squirrel@webmail.greenhost.nl>
	<CA+55aFzcSVmdDj9Lh_gdbz1OzHyEm6ZrGPBDAJnywm2LF_eVyg@mail.gmail.com>
	<CAObL_7FsNQaPQg-3=AO9RuMNZZsRgDSJYPhPevDKERws9vQJWg@mail.gmail.com>
	<20120119160113.GN7180@jl-vm1.vm.bytemark.co.uk>
	<CA+55aFyZ-=4J1hVSAJiBiZKgpvuh-t54KPjLijRmU=cBtdi3-w@mail.gmail.com>
Date: Fri, 20 Jan 2012 09:35:38 -0600
Message-ID: <CABqD9hbUm2Ff7iL5jraE7-J_GqYPf3_r4X+TJKVMeOJBZ9X-Yw@mail.gmail.com>
Subject: Re: Compat 32-bit syscall entry from 64-bit task!?
From: Will Drewry <wad@chromium.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jamie Lokier <jamie@shareable.org>, Andrew Lutomirski <luto@mit.edu>,
        Indan Zupancic <indan@nul.nu>, Andi Kleen <andi@firstfloor.org>,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        keescook@chromium.org, john.johansen@canonical.com,
        serge.hallyn@canonical.com, coreyb@linux.vnet.ibm.com,
        pmoore@redhat.com, eparis@redhat.com, djm@mindrot.org,
        segoon@openwall.com, rostedt@goodmis.org, jmorris@namei.org,
        scarybeasts@gmail.com, avi@redhat.com, penberg@cs.helsinki.fi,
        viro@zeniv.linux.org.uk, mingo@elte.hu, akpm@linux-foundation.org,
        khilman@ti.com, borislav.petkov@amd.com, amwang@redhat.com,
        ak@linux.intel.com, eric.dumazet@gmail.com, gregkh@suse.de,
        dhowells@redhat.com, daniel.lezcano@free.fr,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com,
        Roland McGrath <mcgrathr@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 19, 2012 at 1:21 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Thu, Jan 19, 2012 at 8:01 AM, Jamie Lokier <jamie@shareable.org> wrote:
>> Andrew Lutomirski wrote:
>>> It's reasonable, obvious, and even more wrong than it appears.  On
>>> Xen, there's an extra 64-bit GDT entry, and it gets used by default.
>>> (I got bitten by this in some iteration of the vsyscall emulation
>>> patches -- see user_64bit_mode for the correct and
>>> unusable-from-user-mode way to do this.)
>>
>> Here it is:
>>
>>        static inline bool user_64bit_mode(struct pt_regs *regs)
>
> This is pointless, even if it worked, which it clearly doesn't on Xen
> (or other random situations).
>
> Why would you care?
>
> The issue is *not* whether somebody is running in 32-bit mode or 64-bit mode.
>
> The problem is the system call itself, and that can be 32-bit or
> 64-bit independently of the execution mode. So knowing the user-mode
> mode is simply not relevant.
>
> In the kernel, we know this with the TS_COMPAT flag - exactly because
> it's impossible to tell from any actual CPU state. So *that* is the
> flag you need to figure out, and currently the kernel doesn't export
> it any way (but my suggested patch would export it in the high bits of
> rflags).

Would it be worth considering changing the return from
task_user_regset_view, like:

--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -1311,7 +1311,11 @@ void update_regset_xstate_info(unsigned int
size, u64 xstate_mask)
 const struct user_regset_view *task_user_regset_view(struct task_struct *task)
 {
 #ifdef CONFIG_IA32_EMULATION
-       if (test_tsk_thread_flag(task, TIF_IA32))
+       /* If the task is in a syscall, then the TS_COMPAT status
+        * is more accurate than the personality.
+        */
+       if (test_tsk_thread_flag(task, TIF_IA32) ||
+           task_thread_info(task)->status & TS_COMPAT)
 #endif
 #if defined CONFIG_X86_32 || defined CONFIG_IA32_EMULATION
                return &user_x86_32_view;


This would make TS_COMPAT behave like a personality change.
PTRACE_POKEUSR and PEEKUSR would still access the 64-bit view with no
compat info (just like with TIF_IA32 tasks), but PTRACE_[GS]ETREGS
would return/expect 32-bit struct user_struct_regs.  This would result
in the tracer needing to check the returned regs to see if it was
fully populated (which seems heinous), but it would export the
TS_COMPAT state.

Right now, if a 64-bit tracer changes the regs for a TS_COMPAT call,
the args will be 32-bit truncated (for better or worse). Of course, on
trace_syscall_leave, 64-bit registers won't be truncated so it maybe
makes less sense.

Perhaps this was considered and discarded as being obviously broken,
but it wasn't clear cut to me.

Thanks!
will
