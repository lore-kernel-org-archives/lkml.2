Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758707Ab2D1CmN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 22:42:13 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:42347 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752Ab2D1CmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 22:42:12 -0400
Date: Sat, 28 Apr 2012 03:42:08 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] TIF_NOTIFY_RESUME, arch/*/*/*signal*.c and all such
Message-ID: <20120428024208.GS6871@ZenIV.linux.org.uk>
References: <20120423180150.GA6871@ZenIV.linux.org.uk>
 <20120424072617.GB6871@ZenIV.linux.org.uk>
 <20120426183742.GA324@redhat.com>
 <20120426231942.GJ6871@ZenIV.linux.org.uk>
 <20120427172444.GA30267@redhat.com>
 <20120427184528.GL6871@ZenIV.linux.org.uk>
 <20120427202002.8ED632C0BF@topped-with-meat.com>
 <20120427211244.GO6871@ZenIV.linux.org.uk>
 <20120427212729.652542C0AF@topped-with-meat.com>
 <20120427231526.GP6871@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120427231526.GP6871@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 28, 2012 at 12:15:26AM +0100, Al Viro wrote:

> I think all such architectures need that check lifted to do_notify_resume()
> (and the rest needs it killed, of course).  Including x86, by the look
> of it - we _probably_ can't get there with TIF_NOTIFY_RESUME and
> !user_mode(regs), but I'm not entirely sure of that.  arm is in about the
> same situation; alpha, ppc{32,64}, sparc{32,64} and m68k really can't get
> there like that (they all check it in the asm glue).  mips probably might,
> unless I'm misreading their ret_from_fork()...  Fun.

It's actually worse than I thought - we can't just lift that check
to do_notify_resume() and be done with that.  Suppose do_signal() does
get called on e.g. i386 or arm with !user_mode(regs).  What'll happen next?

We have TIF_SIGPENDING set in thread flags - otherwise we wouldn't get
there at all.  OK, do_signal() doesn't do anything and returns.  So does
do_notify_resume().  And we are back into the loop in asm glue, rereading
the thread flags (still unchanged), checking if anything is to be done
(yes, it is - TIF_SIGPENDING is still set), calling do_notify_resume(),
ad infinitum.

Lifting the check into do_notify_resume() will not help at all, obviously.

AFAICS we can get hit by that.  At least i386, arm and mips have
ret_from_fork going straight to "return from syscall" path, no checks for
return to user mode done.  And process created by kernel_thread() will
go there.  It's a narrow race, but AFAICS it's not impossible to hit -
guess the PID of kernel thread to be launched, send it a signal and hit
the moment before it gets to executing the payload.

It's probably not exploitable unless you are root, since most of the
threads are spawned either by kthreadd or by khelper, both running as
root.  OTOH, there might be other places leading to the same fun - e.g.
kernel_execve() goes through the normal syscall return path almost on
everything and in case of failure it returns to kernel mode.  Again,
that one is unlikely to be exploitable (it only happens from root-owned
threads), but I'm not sure if anything else gets there; IIRC, there had
been an effort to get rid of issuing syscalls via int/syscall/trap/whatnot,
but I don't remember how far did it go, especially under arch...

Comments?
