Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803Ab0FMPEY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 11:04:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27063 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754778Ab0FMPES (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 11:04:18 -0400
From: Avi Kivity <avi@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] x86, fpu: don't save fpu state when switching from a task
Date: Sun, 13 Jun 2010 18:03:47 +0300
Message-Id: <1276441427-31514-5-git-send-email-avi@redhat.com>
In-Reply-To: <1276441427-31514-1-git-send-email-avi@redhat.com>
References: <1276441427-31514-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, we load the fpu state lazily when switching into a task: usually
we leave the fpu state in memory and only load it on demand.

However, when switching out of an fpu-using task, we eagerly save the fpu
state to memory.  This can be detrimental if we'll switch right back to this
task without touching the fpu again - we'll have run a save/load cycle for
nothing.

This patch changes fpu saving on switch out to be lazy - we simply leave the
fpu state alone.  If we're lucky, when we're back in this task the fpu state
will be loaded.  If not the fpu API will save the current fpu state and load
our state back.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kernel/process_32.c |   12 ++++++++----
 arch/x86/kernel/process_64.c |   13 ++++++++-----
 2 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 8d12878..4cb5bc4 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -302,10 +302,12 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	 * If the task has used fpu the last 5 timeslices, just do a full
 	 * restore of the math state immediately to avoid the trap; the
 	 * chances of needing FPU soon are obviously high now
+	 *
+	 * If the fpu is remote, we can't preload it since that requires an
+	 * IPI.  Let a math execption move it locally.
 	 */
-	preload_fpu = tsk_used_math(next_p) && next_p->fpu_counter > 5;
-
-	__unlazy_fpu(prev_p);
+	preload_fpu = tsk_used_math(next_p) && next_p->fpu_counter > 5
+		&& !fpu_remote(&next->fpu);
 
 	/* we're going to use this soon, after a few expensive things */
 	if (preload_fpu)
@@ -351,8 +353,10 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 
 	/* If we're going to preload the fpu context, make sure clts
 	   is run while we're batching the cpu state updates. */
-	if (preload_fpu)
+	if (preload_fpu || fpu_loaded(&next->fpu))
 		clts();
+	else
+		stts();
 
 	/*
 	 * Leave lazy mode, flushing any hypercalls made here.
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 3c2422a..65d2130 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -383,8 +383,12 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	 * If the task has used fpu the last 5 timeslices, just do a full
 	 * restore of the math state immediately to avoid the trap; the
 	 * chances of needing FPU soon are obviously high now
+	 *
+	 * If the fpu is remote, we can't preload it since that requires an
+	 * IPI.  Let a math execption move it locally.
 	 */
-	preload_fpu = tsk_used_math(next_p) && next_p->fpu_counter > 5;
+	preload_fpu = tsk_used_math(next_p) && next_p->fpu_counter > 5
+		&& !fpu_remote(&next->fpu);
 
 	/* we're going to use this soon, after a few expensive things */
 	if (preload_fpu)
@@ -418,12 +422,11 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 
 	load_TLS(next, cpu);
 
-	/* Must be after DS reload */
-	unlazy_fpu(prev_p);
-
 	/* Make sure cpu is ready for new context */
-	if (preload_fpu)
+	if (preload_fpu || fpu_loaded(&next->fpu))
 		clts();
+	else
+		stts();
 
 	/*
 	 * Leave lazy mode, flushing any hypercalls made here.
-- 
1.7.1

