Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939Ab2EBSb7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 14:31:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57912 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753405Ab2EBSb5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 14:31:57 -0400
Date: Wed, 2 May 2012 20:30:57 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC] TIF_NOTIFY_RESUME, arch/*/*/*signal*.c and all such
Message-ID: <20120502183057.GA25166@redhat.com>
References: <20120426231942.GJ6871@ZenIV.linux.org.uk> <20120427172444.GA30267@redhat.com> <20120427184528.GL6871@ZenIV.linux.org.uk> <20120427202002.8ED632C0BF@topped-with-meat.com> <20120427211244.GO6871@ZenIV.linux.org.uk> <20120427212729.652542C0AF@topped-with-meat.com> <20120427231526.GP6871@ZenIV.linux.org.uk> <20120428024208.GS6871@ZenIV.linux.org.uk> <20120429161818.GA15792@redhat.com> <20120429180535.GZ6871@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120429180535.GZ6871@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29, Al Viro wrote:
>
> 	* Now, if do_notify_resume() does nothing in case !user_mode(regs),
> let's lift that check to (32bit) caller.  What we have right now is
> 	do_notify_resume(%esp, NULL, %ecx)
> 	goto resume_userspace_sig;
> resume_userspace_sig:
> 	if (!user_mode_vm(%esp))
> 		goto resume_kernel;
> resume_userspace:
> So after lifting the check we get
> 	if (user_mode(%esp))
> 		do_notify_resume(%esp, NULL, %ecx)
> 	goto resume_userspace_sig;
> resume_userspace_sig:
> 	if (!user_mode_vm(%esp))
> 		goto resume_kernel;
> resume_userspace:
> but user_mode(regs) being true means that user_mode_vm(regs) is also true,
> so this code is equivalent to
> 	if (!user_mode(%esp))
> 		goto resume_kernel;
> 	do_notify_resume(%esp, NULL, %ecx)
> 	goto resume_userspace;
> (with stuff around resume_userspace_sig left without changes).

Yes, thanks, this looks correct.

I've read the new patches in your tree. Again, I do not have any
useful comment, but a couple of questions.

And just in case... I will be completely offline till May 9.


----------------------------------------
046a099ad7b3791a7f9dfbe56ac1263bda8b1974 arm: if there's no handler we need to restore sigmask, syscall or no syscall

with or without this patch, set_current_blocked(->saved_sigmask) doesn't
look exactly right after force_sigsegv(), this can block SIGSEGV.

And force_sigsegv(sig => 0) looks strange, but this is off-topic.

And the question, I am just curious...

OTOH. I am not sure I understand the "int syscall" argument correctly,
I'll assume it means the same as "regs->orig_ax > 0" on x86. In this
case it is not clear to me how "!syscall && TIF_RESTORE_SIGMASK" is
possible.

x86 does this outside of the "if (syscall_get_nr(current, regs)" block
too. Probably this makes sense because debugger can change orig_ax in
between?

(The same for the next db7fddb9574c175aabdbcaa74b736bb3d1665a8e change
 in unicore32)

----------------------------------------
415a12e79ebfa703a5ec91c85cb29f6ecc844aa1 most of set_current_blocked() callers want SIGKILL/SIGSTOP removed from set

Cosmetic nit. With this patch we have

	void set_current_blocked(sigset_t *newset)
	{
		struct task_struct *tsk = current;
		sigdelsetmask(newset, sigmask(SIGKILL) | sigmask(SIGSTOP));
		spin_lock_irq(&tsk->sighand->siglock);
		__set_task_blocked(tsk, newset);
		spin_unlock_irq(&tsk->sighand->siglock);
	}

but it could simply do

	void set_current_blocked(sigset_t *newset)
	{
		sigdelsetmask(newset, sigmask(SIGKILL) | sigmask(SIGSTOP));
		__set_current_blocked(newset);
	}

-----------------------------------------
fa04e22b239aa035f3ae77151e26b03400303245 FRV: Shrink TIF_WORK_MASK [ver #2]

Off-topic/stupid question. Even if I know nothing about arch/frv, this looks
like a nice change to me because

	#define _TIF_WORK_MASK         0x0000FFFE
	#define _TIF_ALLWORK_MASK      0x0000FFFF

looks very confusing imho. I mean, it is not clear which bits do we actually
want to check.

Can't we (cough, you ;) also cleanup _TIF_WORK_MASK/_TIF_ALLWORK_MASK on x86?

