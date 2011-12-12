Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753084Ab1LLHPU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 02:15:20 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:56305 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750962Ab1LLHOA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 02:14:00 -0500
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Pekka Enberg <penberg@kernel.org>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 01/11] kvm tools: check condition before wait
Date: Mon, 12 Dec 2011 15:15:45 +0800
Message-Id: <1323674155-17570-2-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1323674155-17570-1-git-send-email-laijs@cn.fujitsu.com>
References: <1323674155-17570-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-12-12 15:13:20,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-12-12 15:13:21,
	Serialize complete at 2011-12-12 15:13:21
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should check the condition before wait it,
otherewise we may get deadlock.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 tools/kvm/threadpool.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/tools/kvm/threadpool.c b/tools/kvm/threadpool.c
index fdc5fa7..2e59e62 100644
--- a/tools/kvm/threadpool.c
+++ b/tools/kvm/threadpool.c
@@ -80,12 +80,11 @@ static void *thread_pool__threadfunc(void *param)
 		struct thread_pool__job *curjob;
 
 		mutex_lock(&job_mutex);
-		pthread_cond_wait(&job_cond, &job_mutex);
-		curjob = thread_pool__job_pop();
+		while ((curjob = thread_pool__job_pop()) == NULL)
+			pthread_cond_wait(&job_cond, &job_mutex);
 		mutex_unlock(&job_mutex);
 
-		if (curjob)
-			thread_pool__handle_job(curjob);
+		thread_pool__handle_job(curjob);
 	}
 
 	pthread_cleanup_pop(0);
-- 
1.7.4.4

