Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762457Ab2FVPf3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 11:35:29 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:56272 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762422Ab2FVPf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 11:35:27 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 04/17] rcu: Add a gcc-style structure initializer for RCU pointers
Date: Fri, 22 Jun 2012 08:34:59 -0700
Message-Id: <1340379312-6684-4-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1340379312-6684-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120622153501.GA6626@linux.vnet.ibm.com>
 <1340379312-6684-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12062215-5518-0000-0000-0000056D6602
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

RCU_INIT_POINTER() returns a value that is never used, and which should
be abolished due to terminal ugliness:

	q = RCU_INIT_POINTER(global_p, p);

However, there are two uses that cannot be handled by a do-while
formulation because they do gcc-style initialization:

	RCU_INIT_POINTER(.real_cred, &init_cred),
	RCU_INIT_POINTER(.cred, &init_cred),

This usage is clever, but not necessarily the nicest approach.
This commit therefore creates an RCU_POINTER_INITIALIZER() macro that
is specifically designed for gcc-style initialization.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 26d1a47..88e4e08 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -906,6 +906,14 @@ static inline notrace void rcu_read_unlock_sched_notrace(void)
 #define RCU_INIT_POINTER(p, v) \
 		p = (typeof(*v) __force __rcu *)(v)
 
+/**
+ * RCU_POINTER_INITIALIZER() - statically initialize an RCU protected pointer
+ *
+ * GCC-style initialization for an RCU-protected pointer in a structure field.
+ */
+#define RCU_POINTER_INITIALIZER(p, v) \
+		.p = (typeof(*v) __force __rcu *)(v)
+
 static __always_inline bool __is_kfree_rcu_offset(unsigned long offset)
 {
 	return offset < 4096;
-- 
1.7.8

