Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560Ab0IOISx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 04:18:53 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54663 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152Ab0IOISu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 04:18:50 -0400
Subject: Re: [PATCH 3/3] perf events: Cleanup pid passing
From: Peter Zijlstra <peterz@infradead.org>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        containers@lists.linux-foundation.org,
        Robin Green <greenrd@greenrd.org>, linux-kernel@vger.kernel.org,
        Prasad <prasad@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Will Deacon <will.deacon@arm.com>,
        Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
In-Reply-To: <a134e5e392ab0204961fd1a62c84a222bf5874a9.1284407763.git.matthltc@us.ibm.com>
References: <1284408080-2135-1-git-send-email-matthltc@us.ibm.com>
	 <f63454af09fb1915717251570423eb9ddd338340.1284407762.git.matthltc@us.ibm.com>
	 <561205417b450b8a4bf7488374541d64b4690431.1284407762.git.matthltc@us.ibm.com>
	 <a134e5e392ab0204961fd1a62c84a222bf5874a9.1284407763.git.matthltc@us.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 15 Sep 2010 10:18:30 +0200
Message-ID: <1284538710.3764.245.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-13 at 13:01 -0700, Matt Helsley wrote:
> The kernel perf event creation path shouldn't use find_task_by_vpid()
> because a vpid exists in a specific namespace. find_task_by_vpid() uses
> current's pid namespace which isn't always the correct namespace to use
> for the vpid in all the places perf_event_create_kernel_counter() (and
> thus find_get_context()) is called.
> 
> The goal is to clean up pid namespace handling and prevent bugs like:
> 
>         https://bugzilla.kernel.org/show_bug.cgi?id=17281
> 
> Instead of using pids switch find_get_context() to use task struct
> pointers directly. The syscall is responsible for resolving the pid to
> a task struct. This moves the pid namespace resolution into the syscall
> much like every other syscall that takes pid parameters.


I took the three patches with the following change to this patch:

---
Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -5522,7 +5522,7 @@ SYSCALL_DEFINE5(perf_event_open,
 	struct perf_event_context *ctx;
 	struct file *event_file = NULL;
 	struct file *group_file = NULL;
-	struct task_struct *task;
+	struct task_struct *task = NULL;
 	struct pmu *pmu;
 	int event_fd;
 	int fput_needed = 0;
@@ -5577,14 +5577,12 @@ SYSCALL_DEFINE5(perf_event_open,
 	if ((pmu->task_ctx_nr == perf_sw_context) && group_leader)
 		pmu = group_leader->pmu;
 
+	if (pid != -1)
+		task = find_lively_task_by_vpid(pid);
+
 	/*
 	 * Get the target context (task or percpu):
 	 */
-	if (pid == -1 && cpu != -1)
-		task = NULL;
-	else
-		task = find_lively_task_by_vpid(pid);
-
 	ctx = find_get_context(pmu, task, cpu);
 	if (IS_ERR(ctx)) {
 		err = PTR_ERR(ctx);

