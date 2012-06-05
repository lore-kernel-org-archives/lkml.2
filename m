Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933353Ab2FEK2V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 06:28:21 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:50135 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933155Ab2FEK2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 06:28:15 -0400
X-AuditID: b753bd60-92fc6ba000002ea5-77-4fcddf3d9381
X-AuditID: b753bd60-92fc6ba000002ea5-77-4fcddf3d9381
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH -tip v2 5/9] kprobes: Inverse taking of module_mutex with
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
Date: Tue, 05 Jun 2012 19:28:14 +0900
Message-ID: <20120605102814.27845.21047.stgit@localhost.localdomain>
In-Reply-To: <20120605102734.27845.43401.stgit@localhost.localdomain>
References: <20120605102734.27845.43401.stgit@localhost.localdomain>
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

