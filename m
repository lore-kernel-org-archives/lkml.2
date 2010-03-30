Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756712Ab0C3XNR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:13:17 -0400
Received: from kroah.org ([198.145.64.141]:49253 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756652Ab0C3XND (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:13:03 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:58:57 2010
Message-Id: <20100330225857.177980655@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:58:20 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Peter Anvin <hpa@zytor.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       Stefan Bader <stefan.bader@canonical.com>
Subject: [78/89] [PATCH 4/5] Fix flush_old_exec()/setup_new_exec() split
In-Reply-To: <20100330230520.GA28779@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 7ab02af428c2d312c0cf8fb0b01cc1eb21131a3d upstream.

Commit 221af7f87b9 ("Split 'flush_old_exec' into two functions") split
the function at the point of no return - ie right where there were no
more error cases to check.  That made sense from a technical standpoint,
but when we then also combined it with the actual personality setting
going in between flush_old_exec() and setup_new_exec(), it needs to be a
bit more careful.

In particular, we need to make sure that we really flush the old
personality bits in the 'flush' stage, rather than later in the 'setup'
stage, since otherwise we might be flushing the _new_ personality state
that we're just setting up.

So this moves the flags and personality flushing (and 'flush_thread()',
which is the arch-specific function that generally resets lazy FP state
etc) of the old process into flush_old_exec(), so that it doesn't affect
any state that execve() is setting up for the new process environment.

This was reported by Michal Simek as breaking his Microblaze qemu
environment.

Reported-and-tested-by: Michal Simek <michal.simek@petalogix.com>
Cc: Peter Anvin <hpa@zytor.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>

---
 fs/exec.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/fs/exec.c
+++ b/fs/exec.c
@@ -948,6 +948,11 @@ int flush_old_exec(struct linux_binprm *
 		goto out;
 
 	bprm->mm = NULL;		/* We're using it now */
+
+	current->flags &= ~PF_RANDOMIZE;
+	flush_thread();
+	current->personality &= ~bprm->per_clear;
+
 	return 0;
 
 out:
@@ -984,9 +989,6 @@ void setup_new_exec(struct linux_binprm
 	tcomm[i] = '\0';
 	set_task_comm(current, tcomm);
 
-	current->flags &= ~PF_RANDOMIZE;
-	flush_thread();
-
 	/* Set the new mm task size. We have to do that late because it may
 	 * depend on TIF_32BIT which is only updated in flush_thread() on
 	 * some architectures like powerpc
@@ -1002,8 +1004,6 @@ void setup_new_exec(struct linux_binprm
 		set_dumpable(current->mm, suid_dumpable);
 	}
 
-	current->personality &= ~bprm->per_clear;
-
 	/*
 	 * Flush performance counters when crossing a
 	 * security domain:


