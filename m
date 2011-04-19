Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430Ab1DSOuF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 10:50:05 -0400
Received: from mail.aknet.ru ([78.158.192.28]:41913 "EHLO mail.aknet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753056Ab1DSOuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 10:50:03 -0400
Message-ID: <4DADA119.40503@aknet.ru>
Date: Tue, 19 Apr 2011 18:50:01 +0400
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [path][rfc] add PR_DETACH prctl command [2/3]
References: <20110224132906.GA15733@redhat.com> <4D6675B0.2010700@aknet.ru> <20110224153221.GA22770@redhat.com> <4D94A788.1050806@aknet.ru> <20110331170244.GA13271@redhat.com> <4D99D6E6.4070008@aknet.ru> <20110404160351.GA23655@redhat.com> <4D9A24A0.5050105@aknet.ru> <20110405151549.GB17490@redhat.com> <4D9B4265.6080403@aknet.ru> <20110405164557.GA23248@redhat.com>
In-Reply-To: <20110405164557.GA23248@redhat.com>
Content-Type: multipart/mixed;
 boundary="------------060809020808090106050408"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060809020808090106050408
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

The attached patch adds the can_wait_task() and
can_wait_task_ptrace() functions by splitting out the
checks from wait_consider_task().

		int ret = wait_consider_task(wo, 0, p);

gets then replaced by

		ret = can_wait_task(wo, p);
		if (!ret)
			continue;
		ret = wait_consider_task(wo, 0, p);


--------------060809020808090106050408
Content-Type: text/plain;
 name="02_cwaittsk.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="02_cwaittsk.diff"

diff --git a/kernel/exit.c b/kernel/exit.c
index f9a45eb..2aa64e8 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1507,21 +1507,11 @@ static int wait_task_continued(struct wait_opts *wo, struct task_struct *p)
 	return retval;
 }
 
-/*
- * Consider @p for a wait by @parent.
- *
- * -ECHILD should be in ->notask_error before the first call.
- * Returns nonzero for a final return, when we have unlocked tasklist_lock.
- * Returns zero if the search for a child should continue;
- * then ->notask_error is 0 if @p is an eligible child,
- * or another error from security_task_wait(), or still -ECHILD.
- */
-static int wait_consider_task(struct wait_opts *wo, int ptrace,
-				struct task_struct *p)
+static int can_wait_task_common(struct wait_opts *wo, struct task_struct *p)
 {
 	int ret = eligible_child(wo, p);
 	if (!ret)
-		return ret;
+		return 0;
 
 	ret = security_task_wait(p);
 	if (unlikely(ret < 0)) {
@@ -1537,7 +1527,25 @@ static int wait_consider_task(struct wait_opts *wo, int ptrace,
 		return 0;
 	}
 
-	if (likely(!ptrace) && unlikely(task_ptrace(p))) {
+	if (p->exit_state == EXIT_DEAD)
+		return 0;
+
+	return 1;
+}
+
+static int can_wait_task_ptrace(struct wait_opts *wo, struct task_struct *p)
+{
+	/* don't worry, gcc will optimize away this function :) */
+	return can_wait_task_common(wo, p);
+}
+
+static int can_wait_task(struct wait_opts *wo, struct task_struct *p)
+{
+	int ret = can_wait_task_common(wo, p);
+	if (!ret)
+		return 0;
+
+	if (unlikely(task_ptrace(p))) {
 		/*
 		 * This child is hidden by ptrace.
 		 * We aren't allowed to see it now, but eventually we will.
@@ -1546,9 +1554,21 @@ static int wait_consider_task(struct wait_opts *wo, int ptrace,
 		return 0;
 	}
 
-	if (p->exit_state == EXIT_DEAD)
-		return 0;
+	return 1;
+}
 
+/*
+ * Consider @p for a wait by @parent.
+ *
+ * -ECHILD should be in ->notask_error before the first call.
+ * Returns nonzero for a final return, when we have unlocked tasklist_lock.
+ * Returns zero if the search for a child should continue;
+ * then ->notask_error is 0 if @p is an eligible child,
+ * or another error from security_task_wait(), or still -ECHILD.
+ */
+static int wait_consider_task(struct wait_opts *wo, int ptrace,
+				struct task_struct *p)
+{
 	/*
 	 * We don't reap group leaders with subthreads.
 	 */
@@ -1578,10 +1598,14 @@ static int wait_consider_task(struct wait_opts *wo, int ptrace,
  */
 static int do_wait_thread(struct wait_opts *wo, struct task_struct *tsk)
 {
+	int ret;
 	struct task_struct *p;
 
 	list_for_each_entry(p, &tsk->children, sibling) {
-		int ret = wait_consider_task(wo, 0, p);
+		ret = can_wait_task(wo, p);
+		if (!ret)
+			continue;
+		ret = wait_consider_task(wo, 0, p);
 		if (ret)
 			return ret;
 	}
@@ -1594,7 +1618,10 @@ static int ptrace_do_wait(struct wait_opts *wo, struct task_struct *tsk)
 	struct task_struct *p;
 
 	list_for_each_entry(p, &tsk->ptraced, ptrace_entry) {
-		int ret = wait_consider_task(wo, 1, p);
+		int ret = can_wait_task_ptrace(wo, p);
+		if (!ret)
+			continue;
+		ret = wait_consider_task(wo, 1, p);
 		if (ret)
 			return ret;
 	}

--------------060809020808090106050408--
