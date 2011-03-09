Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414Ab1CIWQW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 17:16:22 -0500
Received: from flusers.ccur.com ([173.221.59.2]:54203 "EHLO gamx.iccur.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751405Ab1CIWQV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 17:16:21 -0500
Date: Wed, 9 Mar 2011 17:15:17 -0500
From: Joe Korty <joe.korty@ccur.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        "mathieu.desnoyers@efficios.com" <mathieu.desnoyers@efficios.com>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "loic.minier@linaro.org" <loic.minier@linaro.org>,
        "dhaval.giani@gmail.com" <dhaval.giani@gmail.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "josh@joshtriplett.org" <josh@joshtriplett.org>,
        "houston.jim@comcast.net" <houston.jim@comcast.net>
Subject: [PATCH 2/4] jrcu: tap rcu_read_unlock
Message-ID: <20110309221517.GB24670@tsunami.ccur.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
References: <4CD912E9.1080907@cn.fujitsu.com>
 <20101110155419.GC5750@nowhere>
 <1289410271.2084.25.camel@laptop>
 <20101111041920.GD3134@linux.vnet.ibm.com>
 <20101113223046.GB5445@nowhere>
 <20101116012846.GV2555@linux.vnet.ibm.com>
 <20101116135230.GA5362@nowhere>
 <20101116155104.GB2497@linux.vnet.ibm.com>
 <20101117005229.GC26243@nowhere>
 <20110307203106.GA23002@tsunami.ccur.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110307203106.GA23002@tsunami.ccur.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jrcu: tap into rcu_read_unlock().

All places where rcu_read_unlock() is the final lock in
a set of nested rcu locks are known rcu quiescent points.
This patch recognizes that subset of those which also make
the task preemptable.  The others are left unrecognized.

Not fundamentally needed, accelerates rcu batching.

Signed-off-by: Joe Korty <joe.korty@ccur.com>

Index: b/include/linux/jrcu.h
===================================================================
--- a/include/linux/jrcu.h
+++ b/include/linux/jrcu.h
@@ -21,8 +21,10 @@
 #ifndef __LINUX_JRCU_H
 #define __LINUX_JRCU_H
 
+extern void rcu_read_unlock_jrcu(void);
+
 #define __rcu_read_lock()			preempt_disable()
-#define __rcu_read_unlock()			preempt_enable()
+#define __rcu_read_unlock()			rcu_read_unlock_jrcu()
 
 #define __rcu_read_lock_bh()			__rcu_read_lock()
 #define __rcu_read_unlock_bh()			__rcu_read_unlock()
Index: b/kernel/jrcu.c
===================================================================
--- a/kernel/jrcu.c
+++ b/kernel/jrcu.c
@@ -153,6 +153,14 @@ static inline void rcu_eob(int cpu)
 	}
 }
 
+void rcu_read_unlock_jrcu(void)
+{
+	if (preempt_count() == 1)
+		rcu_eob(rcu_cpu());
+	preempt_enable();
+}
+EXPORT_SYMBOL_GPL(rcu_read_unlock_jrcu);
+
 void rcu_note_context_switch(int cpu)
 {
 	rcu_eob(cpu);
