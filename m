Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754318Ab2BFIdQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 03:33:16 -0500
Received: from smarthost1.greenhost.nl ([195.190.28.78]:55847 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620Ab2BFIdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 03:33:14 -0500
Message-ID: <dac05d1da093cb86e2f654fbfe66dfce.squirrel@webmail.greenhost.nl>
In-Reply-To: <CA+55aFwMd8MMrcfG5f0zg=qjrBzUhgY1HgJx6QFcnpMQsW1PNg@mail.gmail.com>
References: <20120116183730.GB21112@redhat.com>
    <20120117164523.GA17070@redhat.com>
    <CABqD9hYZ4yX76EaWgm2G8HuKgYPMxcxWRTHEazmxWNFL-mgY2A@mail.gmail.com>
    <CAObL_7E1gtDF8Bjb9vmFFkVFmxWbx4DrgGU0QPJEd6KXgS7U8A@mail.gmail.com>
    <20120117170512.GB17070@redhat.com>
    <CAObL_7EA-Z8yBbr1+-VW0v8k1okdcMfjRe5LgWo8YL5uvOkXbQ@mail.gmail.com>
    <49017bd7edab7010cd9ac767e39d99e4.squirrel@webmail.greenhost.nl>
    <20120118015013.GR11715@one.firstfloor.org>
    <20120118020453.GL7180@jl-vm1.vm.bytemark.co.uk>
    <20120118022217.GS11715@one.firstfloor.org>
    <fc8f165e541482d136ff8fc115fe6875.squirrel@webmail.greenhost.nl>
    <CA+55aFysH3h8sLHwNcaLnYMsgA28vmHgd3DSLPVw-=TzgfBrbg@mail.gmail.com>
    <CA+55aFzk6OOHoQ_e3pPQNUGN80tjXT7vYTNaRjXbWiQUnNRiTA@mail.gmail.com>
    <fd4ccb42a25876131e411299d24d9151.squirrel@webmail.greenhost.nl>
    <CA+55aFzcSVmdDj9Lh_gdbz1OzHyEm6ZrGPBDAJnywm2LF_eVyg@mail.gmail.com>
    <CA+55aFwMd8MMrcfG5f0zg=qjrBzUhgY1HgJx6QFcnpMQsW1PNg@mail.gmail.com>
Date: Mon, 6 Feb 2012 09:32:43 +0100
Subject: Re: Compat 32-bit syscall entry from 64-bit task!?
From: "Indan Zupancic" <indan@nul.nu>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Andi Kleen" <andi@firstfloor.org>,
        "Jamie Lokier" <jamie@shareable.org>,
        "Andrew Lutomirski" <luto@mit.edu>, "Oleg Nesterov" <oleg@redhat.com>,
        "Will Drewry" <wad@chromium.org>, linux-kernel@vger.kernel.org,
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
        "Roland McGrath" <mcgrathr@chromium.org>
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: 1.4
X-Scan-Signature: 2d0a7f6a049cc125cd28f2ceffdc0173
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, January 18, 2012 21:26, Linus Torvalds wrote:
> Added Peter to the cc, since this is now about some x86-specific
> things. Ingo was already cc'd earlier.
>
> On Wed, Jan 18, 2012 at 11:31 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> Using the high bits of 'eflags' might work. Hopefully nobody tests
>> that. IOW, something like the attached might work. It just sets bit#32
>> in eflags if the system call is a compat call.
>
> So that description was bogus, it was what my original patch did, but
> not the one I actually sent out (Peter - you can find it on lkml,
> although the description below is probably sufficient for you to
> understand what it does, or the obvious nature of the attached patch
> for strace).
>
> The one I sent out *unconditionally* sets one bit in the high bits of
> the returned value of the eflags register from ptrace(), very much on
> purpose. That way you can unambiguously see whether it's an old kernel
> (bits clear) or a new kernel that supports the feature. On a new
> kernel, bit #32 of eflags will be set for a native 64-bit system call,
> and bit #33 will be set for a compat system call.
>
> And some testing says that it works. In particular, I have a patch to
> strace-4.6 that is able to correctly decode my mixed-case binary that
> uses both the compat system call and the native system calls from
> 64-bit long mode. Also, it looks like gdb ignores the high bits of
> eflags, since it "knows" that eflags is just a 32-bit register even in
> 64-bit mode, so the fact that we set some random bits in there doesn't
> end up being noisy for at least one debugger.
>
> HOWEVER. I'm not going to guarantee that this is the right approach.
> It seems to work, and it clearly gives people real information, but
> whether this is the best way to do things or not is open.

It seems that just using eflags is a lot simpler than the alternatives,
let's just go for it.

>
> The reason I picked 'eflags' was that it
>
>  (a) was easy from an implementation standpoint, since we already have
> to handle reading of eflags specially in ptrace (we have to fake out
> the resume bit)
>
>  (b) it "kind of" makes sense to make high bits be "system flags",
> with low bits being "cpu flags", so it fits at least *some* kind of
> conceptual model.
>
>  (c) the other sane places to put it (high bits of CS and/or ORIG_AX)
> were being used and compared as 64-bit values at least by strace.
> Whether eflags works for all users, I have no idea, but generally you
> would never compare eflags for one particular value - you might check
> individual bits in eflags, but hopefully setting a few new bits should
> not be something that any legacy user would ever really notice.
>
> So there are reasons to think that my patch is sane, but...
>
> Here's the strace patch, so people can look. I didn't even test it on
> an old kernel, but the fallback case to the old behavior looks
> trivial.
>
> Comments?

I propose using bits somewhere in the middle of the upper half. If new
flags are ever added by Intel or AMD, they will use the lower bits. If
anyone else ever adds flags, they most likely add them to the top (VIA).
So the middle seems the safest spot as far as long-term maintenance goes.

The below version does that, but instead of setting one of the two bits,
it always sets bit 50 for newer kernels and sets bit 51 if it's a compat
system call. I find this version more readable and after compilation it's
also a couple of bytes smaller compared to Linus' original version.

Should we make sure that the top 32 bits are zero, in case any weird
hardware does set our bits?

Greetings,

Indan

---

diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 5026738..a7fda48 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -353,6 +353,7 @@ static int set_segment_reg(struct task_struct *task,

 static unsigned long get_flags(struct task_struct *task)
 {
+	int bit = 50;
 	unsigned long retval = task_pt_regs(task)->flags;

 	/*
@@ -360,8 +361,11 @@ static unsigned long get_flags(struct task_struct *task)
 	 */
 	if (test_tsk_thread_flag(task, TIF_FORCED_TF))
 		retval &= ~X86_EFLAGS_TF;
-
-	return retval;
+#ifdef CONFIG_IA32_EMULATION
+	if (task_thread_info(task)->status & TS_COMPAT)
+		retval |= (1ul << 51);
+#endif
+	return retval | (1ul << bit);
 }

 static int set_flags(struct task_struct *task, unsigned long value)


