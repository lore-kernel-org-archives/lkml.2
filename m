Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933079Ab1LFJlb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 04:41:31 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34759 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933007Ab1LFJl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 04:41:29 -0500
Date: Tue, 6 Dec 2011 01:41:14 -0800
From: tip-bot for Ming Lei <tom.leiming@gmail.com>
Message-ID: <tip-81140acc66322dcde8346dabdf1ab4c229fce8d4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, tom.leiming@gmail.com,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, tom.leiming@gmail.com,
        mingo@elte.hu
In-Reply-To: <1321508072-23853-2-git-send-email-tom.leiming@gmail.com>
References: <1321508072-23853-2-git-send-email-tom.leiming@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] lockdep: Print lock name in lockdep_init_error()
Git-Commit-ID: 81140acc66322dcde8346dabdf1ab4c229fce8d4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 06 Dec 2011 01:41:19 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  81140acc66322dcde8346dabdf1ab4c229fce8d4
Gitweb:     http://git.kernel.org/tip/81140acc66322dcde8346dabdf1ab4c229fce8d4
Author:     Ming Lei <tom.leiming@gmail.com>
AuthorDate: Thu, 17 Nov 2011 13:34:32 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 6 Dec 2011 08:16:55 +0100

lockdep: Print lock name in lockdep_init_error()

This patch prints the name of the lock which is acquired
before lockdep_init() is called, so that users can easily
find which lock triggered the lockdep init error warning.

This patch also removes the lockdep_init_error() message
of "Arch code didn't call lockdep_init() early enough?"
since lockdep_init() is called in arch independent code now.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1321508072-23853-2-git-send-email-tom.leiming@gmail.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/lockdep.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 54cc0dc..e69d633 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -431,6 +431,7 @@ unsigned int max_lockdep_depth;
  * about it later on, in lockdep_info().
  */
 static int lockdep_init_error;
+static const char *lock_init_error;
 static unsigned long lockdep_init_trace_data[20];
 static struct stack_trace lockdep_init_trace = {
 	.max_entries = ARRAY_SIZE(lockdep_init_trace_data),
@@ -657,6 +658,7 @@ look_up_lock_class(struct lockdep_map *lock, unsigned int subclass)
 	if (unlikely(!lockdep_initialized)) {
 		lockdep_init();
 		lockdep_init_error = 1;
+		lock_init_error = lock->name;
 		save_stack_trace(&lockdep_init_trace);
 	}
 #endif
@@ -3978,7 +3980,8 @@ void __init lockdep_info(void)
 
 #ifdef CONFIG_DEBUG_LOCKDEP
 	if (lockdep_init_error) {
-		printk("WARNING: lockdep init error! Arch code didn't call lockdep_init() early enough?\n");
+		printk("WARNING: lockdep init error! lock-%s was acquired"
+			"before lockdep_init\n", lock_init_error);
 		printk("Call stack leading to lockdep invocation was:\n");
 		print_stack_trace(&lockdep_init_trace, 0);
 	}
