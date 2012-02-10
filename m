Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932959Ab2BJWof (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 17:44:35 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45193 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932946Ab2BJWoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 17:44:32 -0500
MIME-Version: 1.0
Message-Id: <20120210223440.771807253@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Fri, 10 Feb 2012 14:33:09 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Peter Maydell <peter.maydell@linaro.org>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [patch 05/55] ARM: 7306/1: vfp: flush thread hwstate before restoring context from sigframe
In-Reply-To: <20120210223500.GA24178@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will.deacon@arm.com>

commit 2af276dfb1722e97b190bd2e646b079a2aa674db upstream.

Following execution of a signal handler, we currently restore the VFP
context from the ucontext in the signal frame. This involves copying
from the user stack into the current thread's vfp_hard_struct and then
flushing the new data out to the hardware registers.

This is problematic when using a preemptible kernel because we could be
context switched whilst updating the vfp_hard_struct. If the current
thread has made use of VFP since the last context switch, the VFP
notifier will copy from the hardware registers into the vfp_hard_struct,
overwriting any data that had been partially copied by the signal code.

Disabling preemption across copy_from_user calls is a terrible idea, so
instead we move the VFP thread flush *before* we update the
vfp_hard_struct. Since the flushing is performed lazily, this has the
effect of disabling VFP and clearing the CPU's VFP state pointer,
therefore preventing the thread from being updated with stale data on
the next context switch.

Tested-by: Peter Maydell <peter.maydell@linaro.org>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/kernel/signal.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/arch/arm/kernel/signal.c
+++ b/arch/arm/kernel/signal.c
@@ -227,6 +227,8 @@ static int restore_vfp_context(struct vf
 	if (magic != VFP_MAGIC || size != VFP_STORAGE_SIZE)
 		return -EINVAL;
 
+	vfp_flush_hwstate(thread);
+
 	/*
 	 * Copy the floating point registers. There can be unused
 	 * registers see asm/hwcap.h for details.
@@ -251,9 +253,6 @@ static int restore_vfp_context(struct vf
 	__get_user_error(h->fpinst, &frame->ufp_exc.fpinst, err);
 	__get_user_error(h->fpinst2, &frame->ufp_exc.fpinst2, err);
 
-	if (!err)
-		vfp_flush_hwstate(thread);
-
 	return err ? -EFAULT : 0;
 }
 


