Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754940Ab2IYKgj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 06:36:39 -0400
Received: from service87.mimecast.com ([91.220.42.44]:34655 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754796Ab2IYKgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 06:36:37 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: pjt@google.com, paul.mckenney@linaro.org, tglx@linutronix.de,
        tj@kernel.org, suresh.b.siddha@intel.com, venki@google.com,
        mingo@redhat.com, peterz@infradead.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Arvind.Chauhan@arm.com,
        amit.kucheria@linaro.org, vincent.guittot@linaro.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 2/3] workqueue: create __flush_delayed_work to avoid duplicating code
Date: Tue, 25 Sep 2012 16:06:07 +0530
Message-Id: <e2ec86881d767207abbcdc9e49d2aa389e1689b1.1348568074.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1348568074.git.viresh.kumar@linaro.org>
References: <viresh.kumar@linaro.org>
 <cover.1348568074.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1348568074.git.viresh.kumar@linaro.org>
References: <cover.1348568074.git.viresh.kumar@linaro.org>
X-OriginalArrivalTime: 25 Sep 2012 10:36:31.0741 (UTC) FILETIME=[A0BDB2D0:01CD9B09]
X-MC-Unique: 112092511363507401
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id q8PAahn6025570

flush_delayed_work() and flush_delayed_work_sync() had major portion of code
similar. This patch introduces another routine __flush_delayed_work() which
contains the common part to avoid code duplication.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/workqueue.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 692d976..692a55b 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2820,6 +2820,13 @@ bool cancel_work_sync(struct work_struct *work)
 }
 EXPORT_SYMBOL_GPL(cancel_work_sync);
 
+static inline void __flush_delayed_work(struct delayed_work *dwork)
+{
+	if (del_timer_sync(&dwork->timer))
+		__queue_work(raw_smp_processor_id(),
+			     get_work_cwq(&dwork->work)->wq, &dwork->work);
+}
+
 /**
  * flush_delayed_work - wait for a dwork to finish executing the last queueing
  * @dwork: the delayed work to flush
@@ -2834,9 +2841,7 @@ EXPORT_SYMBOL_GPL(cancel_work_sync);
  */
 bool flush_delayed_work(struct delayed_work *dwork)
 {
-	if (del_timer_sync(&dwork->timer))
-		__queue_work(raw_smp_processor_id(),
-			     get_work_cwq(&dwork->work)->wq, &dwork->work);
+	__flush_delayed_work(dwork);
 	return flush_work(&dwork->work);
 }
 EXPORT_SYMBOL(flush_delayed_work);
@@ -2855,9 +2860,7 @@ EXPORT_SYMBOL(flush_delayed_work);
  */
 bool flush_delayed_work_sync(struct delayed_work *dwork)
 {
-	if (del_timer_sync(&dwork->timer))
-		__queue_work(raw_smp_processor_id(),
-			     get_work_cwq(&dwork->work)->wq, &dwork->work);
+	__flush_delayed_work(dwork);
 	return flush_work_sync(&dwork->work);
 }
 EXPORT_SYMBOL(flush_delayed_work_sync);
-- 
1.7.12.rc2.18.g61b472e


