Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032Ab1G0ISp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 04:18:45 -0400
Received: from mga09.intel.com ([134.134.136.24]:20937 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752280Ab1G0ISo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 04:18:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,275,1309762800"; 
   d="scan'208";a="32514077"
From: Darren Hart <dvhart@linux.intel.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Darren Hart <dvhart@linux.intel.com>,
        Maarten Lankhorst <m.b.lankhorst@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: rt_mutex: restore wait_lock init in __rt_mutex_init
Date: Wed, 27 Jul 2011 01:18:31 -0700
Message-Id: <1311754711-19577-1-git-send-email-dvhart@linux.intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without the raw_spin_lock_init(), the wait_lock does not get properly
initialized with CONFIG_DEBUG_SPINLOCK. This can manifest in a BUG() in the
futex requeue_pi path when the pi_state->pi_mutex->wait_lock fails the magic
test in rt_mutex_start_proxy_lock()->raw_spin_lock(&lock->wait_lock).

Signed-off-by: Darren Hart <dvhart@linux.intel.com>
Reported-by: Maarten Lankhorst <m.b.lankhorst@gmail.com>
CC: Maarten Lankhorst <m.b.lankhorst@gmail.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Steven Rostedt <rostedt@goodmis.org>

---
 rtmutex.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-3.0-rt/kernel/rtmutex.c
===================================================================
--- linux-3.0-rt.orig/kernel/rtmutex.c
+++ linux-3.0-rt/kernel/rtmutex.c
@@ -1277,6 +1277,7 @@ EXPORT_SYMBOL_GPL(rt_mutex_destroy);
 void __rt_mutex_init(struct rt_mutex *lock, const char *name)
 {
 	lock->owner = NULL;
+	raw_spin_lock_init(&lock->wait_lock);
 	plist_head_init_raw(&lock->wait_list, &lock->wait_lock);
 
 	debug_rt_mutex_init(lock, name);
