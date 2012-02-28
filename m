Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030376Ab2B1TqL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 14:46:11 -0500
Received: from www.linutronix.de ([62.245.132.108]:52208 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966064Ab2B1TqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 14:46:05 -0500
Message-Id: <20120228194508.498147421@linutronix.de>
User-Agent: quilt/0.48-1
Date: Tue, 28 Feb 2012 19:46:04 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Anvin <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
        Tony Luck <tony.luck@intel.com>
Subject: [patch 2/4] x86: vdso: Remove bogus locking in update_vsyscall_tz()
References: <20120228194200.180923135@linutronix.de>
Content-Disposition: inline;
 filename=x86-vdso-remove-bogus-locking-in-update_vsyscall_tz.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changing the sequence count in update_vsyscall_tz() is completely
pointless. 

The vdso code copies the data unprotected. There is no point to change
this as sys_tz is nowhere protected at all. See sys_gettimeofday().

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/vsyscall_64.c |    5 -----
 1 file changed, 5 deletions(-)

Index: linux-2.6/arch/x86/kernel/vsyscall_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/vsyscall_64.c
+++ linux-2.6/arch/x86/kernel/vsyscall_64.c
@@ -80,12 +80,7 @@ early_param("vsyscall", vsyscall_setup);
 
 void update_vsyscall_tz(void)
 {
-	unsigned long flags;
-
-	write_seqlock_irqsave(&vsyscall_gtod_data.lock, flags);
-	/* sys_tz has changed */
 	vsyscall_gtod_data.sys_tz = sys_tz;
-	write_sequnlock_irqrestore(&vsyscall_gtod_data.lock, flags);
 }
 
 void update_vsyscall(struct timespec *wall_time, struct timespec *wtm,


