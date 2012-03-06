Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965156Ab2CFJxQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 04:53:16 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:38725 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S965118Ab2CFJxO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 04:53:14 -0500
X-IronPort-AV: E=Sophos;i="4.73,539,1325433600"; 
   d="scan'208";a="4464391"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, fweisbec@gmail.com, patches@linaro.org
Subject: [PATCH 2/6] Don't touch the snap in srcu_readers_active()
Date: Tue, 6 Mar 2012 17:57:34 +0800
Message-Id: <1331027858-7648-2-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1331027858-7648-1-git-send-email-laijs@cn.fujitsu.com>
References: <1331023359-6987-1-git-send-email-laijs@cn.fujitsu.com>
 <1331027858-7648-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-06 17:51:16,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-06 17:51:19,
	Serialize complete at 2012-03-06 17:51:19
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

srcu_readers_active() is called without the mutex, but it touch the snap.
also achieve better cache locality a little

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/srcu.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/kernel/srcu.c b/kernel/srcu.c
index b6b9ea2..fbe2d5f 100644
--- a/kernel/srcu.c
+++ b/kernel/srcu.c
@@ -181,7 +181,14 @@ static bool srcu_readers_active_idx_check(struct srcu_struct *sp, int idx)
  */
 static int srcu_readers_active(struct srcu_struct *sp)
 {
-	return srcu_readers_active_idx(sp, 0) + srcu_readers_active_idx(sp, 1);
+	int cpu;
+	unsigned long sum = 0;
+
+	for_each_possible_cpu(cpu) {
+		sum += ACCESS_ONCE(per_cpu_ptr(sp->per_cpu_ref, cpu)->c[0]);
+		sum += ACCESS_ONCE(per_cpu_ptr(sp->per_cpu_ref, cpu)->c[1]);
+	}
+	return sum & SRCU_REF_MASK;
 }
 
 /**
-- 
1.7.4.4

