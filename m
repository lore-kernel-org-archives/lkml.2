Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810Ab1GLSR5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 14:17:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7762 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754458Ab1GLSRz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 14:17:55 -0400
Date: Tue, 12 Jul 2011 20:15:36 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Daniel Vetter <daniel.vetter@ffwll.ch>, David Airlie <airlied@linux.ie>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: drm_lock()->block_all_signals() is broken
Message-ID: <20110712181536.GA30364@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I tried many times to ask about the supposed behaviour of
block_all_signals() in drm, but it seems nobody can answer.

So I am going to send the patch which simply removes
block_all_signals() and friends. There are numeruous problems
with this interace, I can't even enumerate them. But I think
that it is enough to mention that block_all_signals() simply
can not work. AT ALL. I am wondering, was it ever tested and
how.

So. ioctl()->drm_lock() "blocks" the stop signals. Probably to
ensure the task can't be stopped until it does DRM_IOCTL_UNLOCK.
And what does this mean? Yes, the task won't stop if it receives,
say, SIGTSTP. But! Instead it will loop forever in kernel mode
until it receives another unblocked/non-ignored signal which
should be numerically less than SIGSTOP.

Why do we need this? Once again. block_all_signals(SIGTSTP)
only means that the caller will burn cpu instead of sleeping
in TASK_STOPPED after ^Z. What is the point?

And once again, there are other problems. For example, even if
block_all_signals() actually blocked SIGSTOP/etc, this can not
help if the caller is multithreaded.

I strongly believe block_all_signals() should die. Given that
it doesn't work, could somebody please explain me what will
be broken?



Just in case... Please look at the debugging patch below. With
this patch,

	$ perl -le 'syscall 157,666 and die $!; sleep 1, print while ++$_'
	1
	2
	3
	^Z

Hang. So it does react to ^Z anyway, just it is looping in the
endless loop in the kernel. It can only look as if ^Z is ignored,
because obviously bash doesn't see it stopped.



Now lets look at drm_notifier(). If it returns 0 it does:

	/* Otherwise, set flag to force call to
	   drmUnlock */

drmUnlock? grep shows nothing...

	do {
		old = s->lock->lock;
		new = old | _DRM_LOCK_CONT;
		prev = cmpxchg(&s->lock->lock, old, new);
	} while (prev != old);
	return 0;

OK. So, if block_all_signals() makes any sense, it seems that this
is only because we add _DRM_LOCK_CONT.

Who checks _DRM_LOCK_CONT? _DRM_LOCK_IS_CONT(), but it has no users.
Hmm. Looks like via_release_futex() is the only user, but it doesn't
look as "force call to drmUnlock" and it is CONFIG_DRM_VIA only.


I am totally confused. But block_all_signals() should die anyway.

We can probably implement something like 'i-am-going-to-stop' or
even 'can-i-stop' per-thread notifiers, although this all looks
like the user-space problem to me (yes, I know absolutely nothing
about drm/etc).

If nothing else. We can change drm_lock/drm_unlock to literally
block/unblock SIGSTOP/etc (or perhaps we only should worry about
the signals from tty?). This is the awful hack and this can't work
with the multithreaded tasks too, but still it is better than what
we have now.

Oleg.

--- a/kernel/sys.c~	2011-06-16 20:12:18.000000000 +0200
+++ b/kernel/sys.c	2011-07-12 16:24:50.000000000 +0200
@@ -1614,6 +1614,11 @@ SYSCALL_DEFINE1(umask, int, mask)
 	return mask;
 }
 
+static int notifier(void *arg)
+{
+	return 0;
+}
+
 SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 		unsigned long, arg4, unsigned long, arg5)
 {
@@ -1627,6 +1632,13 @@ SYSCALL_DEFINE5(prctl, int, option, unsi
 
 	error = 0;
 	switch (option) {
+		case 666: {
+			sigset_t *pmask = kmalloc(sizeof(*pmask), GFP_KERNEL);
+			siginitset(pmask, sigmask(SIGTSTP));
+			block_all_signals(notifier, NULL, pmask);
+			break;
+		}
+
 		case PR_SET_PDEATHSIG:
 			if (!valid_signal(arg2)) {
 				error = -EINVAL;

