Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103Ab2LNOQ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 09:16:29 -0500
Received: from ms.dension.com ([195.56.193.33]:59885 "EHLO ms.dension.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755905Ab2LNOQ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 09:16:28 -0500
Date: Fri, 14 Dec 2012 15:06:19 +0100
From: "Patrik, Kluba" <pkluba@dension.com>
To: <linux-kernel@vger.kernel.org>
Subject: [PATCH 01/01] arm: fix a preempt_count() corruption for
 CONFIG_PREEMPT=n
Message-ID: <20121214150619.32f0126c.pkluba@dension.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/GqQpMrqe/tWQWY2MkUbUVDu"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--MP_/GqQpMrqe/tWQWY2MkUbUVDu
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi All,

After a hard days' work, I've managed to track down a ghost causing
sporadic kernel warnings and system crashes. The patch applies for the
HEAD of linux-stable. I don't know how to create and submit patches
correctly, and hope that somebody will pick it up...

Regards,
Patrik

--MP_/GqQpMrqe/tWQWY2MkUbUVDu
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename=0001-arm-fix-a-preempt_count-corruption-for-CONFIG_PREEMP.patch

>From 4dd31e88a2715389e5ac198dcf00b48b4f148ea6 Mon Sep 17 00:00:00 2001
From: Patrik Kluba <pkluba@dension.com>
Date: Fri, 14 Dec 2012 14:36:27 +0100
Subject: [PATCH] arm: fix a preempt_count() corruption for CONFIG_PREEMPT=n

All the preempt-disabling assembly code is under CONFIG_PREEMPT,
while VFP_bounce calls preempt_enable() uncoditionally, leading to
a preempt_count() corruption (gets set to 0xffffffff). Fix the
imbalance by adding #ifdef CONFIG_PREEMPT before preempt_enable().
---
 arch/arm/vfp/vfpmodule.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/vfp/vfpmodule.c b/arch/arm/vfp/vfpmodule.c
index 3b44e0d..2184f7e 100644
--- a/arch/arm/vfp/vfpmodule.c
+++ b/arch/arm/vfp/vfpmodule.c
@@ -428,7 +428,10 @@ void VFP_bounce(u32 trigger, u32 fpexc, struct pt_regs *regs)
 	if (exceptions)
 		vfp_raise_exceptions(exceptions, trigger, orig_fpscr, regs);
  exit:
+#ifdef CONFIG_PREEMPT
 	preempt_enable();
+#endif
+	return;
 }
 
 static void vfp_enable(void *unused)
-- 
1.7.10.4


--MP_/GqQpMrqe/tWQWY2MkUbUVDu--
