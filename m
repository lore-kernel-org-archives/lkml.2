Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932996Ab2BJXBQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 18:01:16 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:42369 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932948Ab2BJWoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 17:44:34 -0500
MIME-Version: 1.0
Message-Id: <20120210223440.859209661@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Fri, 10 Feb 2012 14:33:10 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Dave Martin <dave.martin@linaro.org>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [patch 06/55] ARM: 7307/1: vfp: fix ptrace regset modification race
In-Reply-To: <20120210223500.GA24178@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Martin <dave.martin@linaro.org>

commit 247f4993a5974e6759606c4d380748eecfd273ff upstream.

In a preemptible kernel, vfp_set() can be preempted, causing the
hardware VFP context to be switched while the thread vfp state is
being read and modified.  This leads to a race condition which can
cause the thread vfp state to become corrupted if lazy VFP context
save occurs due to preemption in between the time thread->vfpstate
is read and the time the modified state is written back.

This may occur if preemption occurs during the execution of a
ptrace() call which modifies the VFP register state of a thread.
Such instances should be very rare in most realistic scenarios --
none has been reported, so far as I am aware.  Only uniprocessor
systems should be affected, since VFP context save is not currently
lazy in SMP kernels.

The problem was introduced by my earlier patch migrating to use
regsets to implement ptrace.

This patch does a vfp_sync_hwstate() before reading
thread->vfpstate, to make sure that the thread's VFP state is not
live in the hardware registers while the registers are modified.

Thanks to Will Deacon for spotting this.

Signed-off-by: Dave Martin <dave.martin@linaro.org>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/kernel/ptrace.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/arch/arm/kernel/ptrace.c
+++ b/arch/arm/kernel/ptrace.c
@@ -719,10 +719,13 @@ static int vfp_set(struct task_struct *t
 {
 	int ret;
 	struct thread_info *thread = task_thread_info(target);
-	struct vfp_hard_struct new_vfp = thread->vfpstate.hard;
+	struct vfp_hard_struct new_vfp;
 	const size_t user_fpregs_offset = offsetof(struct user_vfp, fpregs);
 	const size_t user_fpscr_offset = offsetof(struct user_vfp, fpscr);
 
+	vfp_sync_hwstate(thread);
+	new_vfp = thread->vfpstate.hard;
+
 	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
 				  &new_vfp.fpregs,
 				  user_fpregs_offset,
@@ -743,7 +746,6 @@ static int vfp_set(struct task_struct *t
 	if (ret)
 		return ret;
 
-	vfp_sync_hwstate(thread);
 	thread->vfpstate.hard = new_vfp;
 	vfp_flush_hwstate(thread);
 


