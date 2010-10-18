Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757418Ab0JRTSL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 15:18:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:59354 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754961Ab0JRTSI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 15:18:08 -0400
Date: Mon, 18 Oct 2010 19:17:35 GMT
From: tip-bot for Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, mitake@dcl.info.waseda.ac.jp, vojtech@ucw.cz,
        fweisbec@gmail.com, dtor@mail.ru, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, mitake@dcl.info.waseda.ac.jp, vojtech@ucw.cz,
        fweisbec@gmail.com, dtor@mail.ru, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1286958626-986-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
References: <1286958626-986-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] lockdep: Check the depth of subclass
Message-ID: <tip-4ba053c04aece1f4734056f21b751eee47ea3fb1@git.kernel.org>
Git-Commit-ID: 4ba053c04aece1f4734056f21b751eee47ea3fb1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 18 Oct 2010 19:17:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4ba053c04aece1f4734056f21b751eee47ea3fb1
Gitweb:     http://git.kernel.org/tip/4ba053c04aece1f4734056f21b751eee47ea3fb1
Author:     Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
AuthorDate: Wed, 13 Oct 2010 17:30:26 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 18 Oct 2010 18:44:26 +0200

lockdep: Check the depth of subclass

Current look_up_lock_class() doesn't check the parameter "subclass".
This rarely rises problems because the main caller of this function,
register_lock_class(), checks it.

But register_lock_class() is not the only function which calls
look_up_lock_class(). lock_set_class() and its callees also call it.
And lock_set_class() doesn't check this parameter.

This will rise problems when the the value of subclass is larger than
MAX_LOCKDEP_SUBCLASSES. Because the address (used as the key of class)
caliculated with too large subclass has a probability to point
another key in different lock_class_key.

Of course this problem depends on the memory layout and
occurs with really low probability.

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Vojtech Pavlik <vojtech@ucw.cz>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1286958626-986-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/lockdep.c |   18 ++++++++++--------
 1 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index bc4d328..42ba65d 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -639,6 +639,16 @@ look_up_lock_class(struct lockdep_map *lock, unsigned int subclass)
 	}
 #endif
 
+	if (unlikely(subclass >= MAX_LOCKDEP_SUBCLASSES)) {
+		debug_locks_off();
+		printk(KERN_ERR
+			"BUG: looking up invalid subclass: %u\n", subclass);
+		printk(KERN_ERR
+			"turning off the locking correctness validator.\n");
+		dump_stack();
+		return NULL;
+	}
+
 	/*
 	 * Static locks do not have their class-keys yet - for them the key
 	 * is the lock object itself:
@@ -2745,14 +2755,6 @@ static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 	if (DEBUG_LOCKS_WARN_ON(!irqs_disabled()))
 		return 0;
 
-	if (unlikely(subclass >= MAX_LOCKDEP_SUBCLASSES)) {
-		debug_locks_off();
-		printk("BUG: MAX_LOCKDEP_SUBCLASSES too low!\n");
-		printk("turning off the locking correctness validator.\n");
-		dump_stack();
-		return 0;
-	}
-
 	if (lock->key == &__lockdep_no_validate__)
 		check = 1;
 
