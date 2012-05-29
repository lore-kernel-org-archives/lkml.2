Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752486Ab2E2MtW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 08:49:22 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:58028 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766Ab2E2MtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 08:49:19 -0400
X-AuditID: b753bd60-921fdba000003d24-92-4fc4c5cd970c
X-AuditID: b753bd60-921fdba000003d24-92-4fc4c5cd970c
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [RFC PATCH -tip 5/9] kprobes: Inverse taking of module_mutex with
 kprobe_mutex
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>
Date: Tue, 29 May 2012 21:49:26 +0900
Message-ID: <20120529124926.9191.18412.stgit@localhost.localdomain>
In-Reply-To: <20120529124833.9191.23007.stgit@localhost.localdomain>
References: <20120529124833.9191.23007.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Currently module_mutex is taken before kprobe_mutex, but this
can cause issues when we have kprobes register ftrace, as the ftrace
mutex is taken before enabling a tracepoint, which currently takes
the module mutex.

If module_mutex is taken before kprobe_mutex, then we can not
have kprobes use the ftrace infrastructure.

There seems to be no reason that the kprobe_mutex can't be taken
before the module_mutex. Running lockdep shows that it is safe
among the kernels I've run.

Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---

 kernel/kprobes.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index c62b854..7a8a122 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -561,9 +561,9 @@ static __kprobes void kprobe_optimizer(struct work_struct *work)
 {
 	LIST_HEAD(free_list);
 
+	mutex_lock(&kprobe_mutex);
 	/* Lock modules while optimizing kprobes */
 	mutex_lock(&module_mutex);
-	mutex_lock(&kprobe_mutex);
 
 	/*
 	 * Step 1: Unoptimize kprobes and collect cleaned (unused and disarmed)
@@ -586,8 +586,8 @@ static __kprobes void kprobe_optimizer(struct work_struct *work)
 	/* Step 4: Free cleaned kprobes after quiesence period */
 	do_free_cleaned_kprobes(&free_list);
 
-	mutex_unlock(&kprobe_mutex);
 	mutex_unlock(&module_mutex);
+	mutex_unlock(&kprobe_mutex);
 
 	/* Step 5: Kick optimizer again if needed */
 	if (!list_empty(&optimizing_list) || !list_empty(&unoptimizing_list))

