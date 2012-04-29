Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178Ab2D2QTI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 12:19:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8167 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752918Ab2D2QTH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 12:19:07 -0400
Date: Sun, 29 Apr 2012 18:18:18 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] TIF_NOTIFY_RESUME, arch/*/*/*signal*.c and all such
Message-ID: <20120429161818.GA15792@redhat.com>
References: <20120424072617.GB6871@ZenIV.linux.org.uk> <20120426183742.GA324@redhat.com> <20120426231942.GJ6871@ZenIV.linux.org.uk> <20120427172444.GA30267@redhat.com> <20120427184528.GL6871@ZenIV.linux.org.uk> <20120427202002.8ED632C0BF@topped-with-meat.com> <20120427211244.GO6871@ZenIV.linux.org.uk> <20120427212729.652542C0AF@topped-with-meat.com> <20120427231526.GP6871@ZenIV.linux.org.uk> <20120428024208.GS6871@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120428024208.GS6871@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First of all, let me repeat I am useless when it comes to the low-level
or asm code. I can be easily wrong, and I am going to ask the questions.

On 04/28, Al Viro wrote:
>
> It's actually worse than I thought - we can't just lift that check
> to do_notify_resume() and be done with that.  Suppose do_signal() does
> get called on e.g. i386 or arm with !user_mode(regs).  What'll happen next?
>
> We have TIF_SIGPENDING set in thread flags - otherwise we wouldn't get
> there at all.  OK, do_signal() doesn't do anything and returns.  So does
> do_notify_resume().  And we are back into the loop in asm glue, rereading
> the thread flags (still unchanged), checking if anything is to be done
> (yes, it is - TIF_SIGPENDING is still set), calling do_notify_resume(),
> ad infinitum.
>
> Lifting the check into do_notify_resume() will not help at all, obviously.
>
> AFAICS we can get hit by that.

Please look at 29a2e2836ff9ea65a603c89df217f4198973a74f
x86-32: Fix endless loop when processing signals for kernel tasks

> At least i386, arm and mips have
> ret_from_fork going straight to "return from syscall" path, no checks for
> return to user mode done.  And process created by kernel_thread() will
> go there.

Looks like, the patch above fixes that.

But, we call do_notify_resume() first, it would be nice to avoid this
and remove the user_mode() check in do_signal() or lift into
do_notify_resume().

> It's a narrow race, but AFAICS it's not impossible to hit -
> guess the PID of kernel thread to be launched, send it a signal and hit
> the moment before it gets to executing the payload.

Yes. But note that the kernel threads run with all signals ignored.

This is still possible, but a kernel thread should do allow_signal()
and then call kernel_thread() (not kthread_create).



Question. So far I know that on x86 do_notify_resume() && !user_mode()
is only possible on 32bit system, and the possible callers are
ret_from_fork or kernel_execve (if it fails).

Plus, perhaps CONFIG_VM86 makes a difference?

Could you please clarify?

Oleg.

