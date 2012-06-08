Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755591Ab2FHE1m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 00:27:42 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:49665 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418Ab2FHE1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 00:27:08 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH rcu 8/8] rcu: Fix qlen_lazy breakage
Date: Thu,  7 Jun 2012 21:26:55 -0700
Message-Id: <1339129615-1795-8-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1339129615-1795-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120608042632.GA1250@linux.vnet.ibm.com>
 <1339129615-1795-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12060804-7408-0000-0000-000005ADF999
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

Commit d8169d4c (Make __kfree_rcu() less dependent on compiler choices)
created a macro out of an inline function in order to avoid build
breakage for certain combinations of gcc flags.  Unfortunately, it also
converted a kfree_call_rcu() to a call_rcu(), which made the rcu_data
structure's ->qlen_lazy field lose counts.  This commit therefore changes
the call_rcu() back to kfree_call_rcu().

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 26d1a47..62956c7 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -936,7 +936,7 @@ void __kfree_rcu(struct rcu_head *head, unsigned long offset)
 #define __kfree_rcu(head, offset) \
 	do { \
 		BUILD_BUG_ON(!__is_kfree_rcu_offset(offset)); \
-		call_rcu(head, (void (*)(struct rcu_head *))(unsigned long)(offset)); \
+		kfree_call_rcu(head, (void (*)(struct rcu_head *))(unsigned long)(offset)); \
 	} while (0)
 
 /**
-- 
1.7.8

