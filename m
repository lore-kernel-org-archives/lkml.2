Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932903Ab1LFD3H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 22:29:07 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33739 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932859Ab1LFD3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 22:29:03 -0500
Date: Tue, 6 Dec 2011 11:28:45 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, patches@linaro.org
Subject: [PATCH 2/3] rtmutex: introduce rt_mutex_lock_irqdisabled()
Message-ID: <20111206032845.GB17091@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <20111203183417.GA18914@linux.vnet.ibm.com>
 <1322937282-19846-7-git-send-email-paulmck@linux.vnet.ibm.com>
 <20111205091924.GA28117@zhy>
 <20111205164505.GB2326@linux.vnet.ibm.com>
 <20111206012635.GA32498@zhy>
 <20111206021227.GO2326@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20111206021227.GO2326@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we permit rt_mutex_lock() to be called with irq disabled
in commit 5342e269, and we will call might_sleep() in
rt_mutex_lock() unconditionally, false positive will be
made. So introduce rt_mutex_lock_irqdisabled() for that kind
of usage.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
---
 include/linux/rtmutex.h |    1 +
 kernel/rtmutex.c        |   13 +++++++++++++
 2 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/include/linux/rtmutex.h b/include/linux/rtmutex.h
index de17134..0732a25 100644
--- a/include/linux/rtmutex.h
+++ b/include/linux/rtmutex.h
@@ -88,6 +88,7 @@ extern void __rt_mutex_init(struct rt_mutex *lock, const char *name);
 extern void rt_mutex_destroy(struct rt_mutex *lock);
 
 extern void rt_mutex_lock(struct rt_mutex *lock);
+extern void rt_mutex_lock_irqdisabled(struct rt_mutex *lock);
 extern int rt_mutex_lock_interruptible(struct rt_mutex *lock,
 						int detect_deadlock);
 extern int rt_mutex_timed_lock(struct rt_mutex *lock,
diff --git a/kernel/rtmutex.c b/kernel/rtmutex.c
index f9d8482..961a100 100644
--- a/kernel/rtmutex.c
+++ b/kernel/rtmutex.c
@@ -797,6 +797,19 @@ void __sched rt_mutex_lock(struct rt_mutex *lock)
 EXPORT_SYMBOL_GPL(rt_mutex_lock);
 
 /**
+ * rt_mutex_lock_irqdisabled - lock a rt_mutex with irq disabled
+ *
+ * @lock: the rt_mutex to be locked
+ */
+void __sched rt_mutex_lock_irqdisabled(struct rt_mutex *lock)
+{
+	might_sleep_irqdisabled();
+
+	rt_mutex_fastlock(lock, TASK_UNINTERRUPTIBLE, 0, rt_mutex_slowlock);
+}
+EXPORT_SYMBOL_GPL(rt_mutex_lock_irqdisabled);
+
+/**
  * rt_mutex_lock_interruptible - lock a rt_mutex interruptible
  *
  * @lock: 		the rt_mutex to be locked
-- 
1.7.5.4

