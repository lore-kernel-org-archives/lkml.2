Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758497Ab0GTJRL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 05:17:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:59479 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758413Ab0GTJRJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 05:17:09 -0400
Message-ID: <4C45698F.9010607@kernel.org>
Date: Tue, 20 Jul 2010 11:17:03 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH wq#for-next] workqueue: fix build problem on !CONFIG_SMP
References: <20100720151030.f874832e.sfr@canb.auug.org.au>
In-Reply-To: <20100720151030.f874832e.sfr@canb.auug.org.au>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 20 Jul 2010 09:17:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit f3421797 (workqueue: implement unbound workqueue) incorrectly
tested CONFIG_SMP as part of a C expression in alloc/free_cwqs().  As
CONFIG_SMP is not defined in UP, this breaks build.  Fix it by using

Found during linux-next build test.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 kernel/workqueue.c |   18 ++++++++++++++----
 1 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index aca9472..79a11e4 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2615,11 +2615,15 @@ static int alloc_cwqs(struct workqueue_struct *wq)
 	const size_t size = sizeof(struct cpu_workqueue_struct);
 	const size_t align = max_t(size_t, 1 << WORK_STRUCT_FLAG_BITS,
 				   __alignof__(unsigned long long));
+#ifdef CONFIG_SMP
+	bool percpu = !(wq->flags & WQ_UNBOUND);
+#else
+	bool percpu = false;
+#endif

-	if (CONFIG_SMP && !(wq->flags & WQ_UNBOUND)) {
-		/* on SMP, percpu allocator can align itself */
+	if (percpu)
 		wq->cpu_wq.pcpu = __alloc_percpu(size, align);
-	} else {
+	else {
 		void *ptr;

 		/*
@@ -2641,7 +2645,13 @@ static int alloc_cwqs(struct workqueue_struct *wq)

 static void free_cwqs(struct workqueue_struct *wq)
 {
-	if (CONFIG_SMP && !(wq->flags & WQ_UNBOUND))
+#ifdef CONFIG_SMP
+	bool percpu = !(wq->flags & WQ_UNBOUND);
+#else
+	bool percpu = false;
+#endif
+
+	if (percpu)
 		free_percpu(wq->cpu_wq.pcpu);
 	else if (wq->cpu_wq.single) {
 		/* the pointer to free is stored right after the cwq */
-- 
1.6.4.2

