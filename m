Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741Ab1LLHOA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 02:14:00 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:52207 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750962Ab1LLHN4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 02:13:56 -0500
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Pekka Enberg <penberg@kernel.org>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 02/11] kvm tools: fix function name
Date: Mon, 12 Dec 2011 15:15:46 +0800
Message-Id: <1323674155-17570-3-git-send-email-laijs@cn.fujitsu.com>
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

In here, xxx_locked() should means "called with job_mutex locked",
the original funtion are opposite, fix them.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 tools/kvm/threadpool.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/tools/kvm/threadpool.c b/tools/kvm/threadpool.c
index 2e59e62..bafbcd7 100644
--- a/tools/kvm/threadpool.c
+++ b/tools/kvm/threadpool.c
@@ -15,7 +15,7 @@ static LIST_HEAD(head);
 static pthread_t	*threads;
 static long		threadcount;
 
-static struct thread_pool__job *thread_pool__job_pop(void)
+static struct thread_pool__job *thread_pool__job_pop_locked(void)
 {
 	struct thread_pool__job *job;
 
@@ -28,25 +28,25 @@ static struct thread_pool__job *thread_pool__job_pop(void)
 	return job;
 }
 
-static void thread_pool__job_push(struct thread_pool__job *job)
+static void thread_pool__job_push_locked(struct thread_pool__job *job)
 {
 	list_add_tail(&job->queue, &head);
 }
 
-static struct thread_pool__job *thread_pool__job_pop_locked(void)
+static struct thread_pool__job *thread_pool__job_pop(void)
 {
 	struct thread_pool__job *job;
 
 	mutex_lock(&job_mutex);
-	job = thread_pool__job_pop();
+	job = thread_pool__job_pop_locked();
 	mutex_unlock(&job_mutex);
 	return job;
 }
 
-static void thread_pool__job_push_locked(struct thread_pool__job *job)
+static void thread_pool__job_push(struct thread_pool__job *job)
 {
 	mutex_lock(&job_mutex);
-	thread_pool__job_push(job);
+	thread_pool__job_push_locked(job);
 	mutex_unlock(&job_mutex);
 }
 
@@ -59,11 +59,11 @@ static void thread_pool__handle_job(struct thread_pool__job *job)
 
 		if (--job->signalcount > 0)
 			/* If the job was signaled again while we were working */
-			thread_pool__job_push_locked(job);
+			thread_pool__job_push(job);
 
 		mutex_unlock(&job->mutex);
 
-		job = thread_pool__job_pop_locked();
+		job = thread_pool__job_pop();
 	}
 }
 
@@ -80,7 +80,7 @@ static void *thread_pool__threadfunc(void *param)
 		struct thread_pool__job *curjob;
 
 		mutex_lock(&job_mutex);
-		while ((curjob = thread_pool__job_pop()) == NULL)
+		while ((curjob = thread_pool__job_pop_locked()) == NULL)
 			pthread_cond_wait(&job_cond, &job_mutex);
 		mutex_unlock(&job_mutex);
 
@@ -136,7 +136,7 @@ void thread_pool__do_job(struct thread_pool__job *job)
 
 	mutex_lock(&jobinfo->mutex);
 	if (jobinfo->signalcount++ == 0)
-		thread_pool__job_push_locked(job);
+		thread_pool__job_push(job);
 	mutex_unlock(&jobinfo->mutex);
 
 	mutex_lock(&job_mutex);
-- 
1.7.4.4

