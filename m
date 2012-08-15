Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754945Ab2HOO1N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 10:27:13 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:42329 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781Ab2HOO1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 10:27:11 -0400
From: Joonsoo Kim <js1304@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Joonsoo Kim <js1304@gmail.com>
Subject: [PATCH v3 6/6] workqueue: use system_highpri_wq for unbind_work
Date: Wed, 15 Aug 2012 23:25:41 +0900
Message-Id: <1345040741-5508-7-git-send-email-js1304@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1345040741-5508-1-git-send-email-js1304@gmail.com>
References: <Yes>
 <1345040741-5508-1-git-send-email-js1304@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To speed cpu down processing up, use system_highpri_wq.
As scheduling priority of workers on it is higher than system_wq and
it is not contended by other normal works on this cpu, work on it
is processed faster than system_wq.

Signed-off-by: Joonsoo Kim <js1304@gmail.com>

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 2945734..e17326e 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3679,7 +3679,7 @@ static int __devinit workqueue_cpu_down_callback(struct notifier_block *nfb,
 	case CPU_DOWN_PREPARE:
 		/* unbinding should happen on the local CPU */
 		INIT_WORK_ONSTACK(&unbind_work, gcwq_unbind_fn);
-		schedule_work_on(cpu, &unbind_work);
+		queue_work_on(cpu, system_highpri_wq, &unbind_work);
 		flush_work(&unbind_work);
 		break;
 	}
-- 
1.7.9.5

