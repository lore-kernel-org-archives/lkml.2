Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913Ab0DSS1n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 14:27:43 -0400
Received: from mga05.intel.com ([192.55.52.89]:9447 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753245Ab0DSS1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 14:27:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,237,1270450800"; 
   d="scan'208";a="559384637"
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [PATCH] x86/apbt: conditionally register cpu hp notifier for apbt
Date: Mon, 19 Apr 2010 11:23:43 -0700
Message-Id: <1271701423-1162-1-git-send-email-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

APB timer is used on Moorestown platforms but not on a standard PC.
If APB timer code is compiled in but not initialized at run-time due
to lack of FW reported SFI table, kernel would panic when the non-boot
CPUs are offlined and notifier is called.

https://bugzilla.kernel.org/show_bug.cgi?id=15786

This patch ensures CPU hotplug notifier for APB timer is only registered
when the APBT timer block is initialized.

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
---
 arch/x86/kernel/apb_timer.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apb_timer.c b/arch/x86/kernel/apb_timer.c
index ff469e4..a353475 100644
--- a/arch/x86/kernel/apb_timer.c
+++ b/arch/x86/kernel/apb_timer.c
@@ -429,7 +429,7 @@ static int apbt_cpuhp_notify(struct notifier_block *n,
 
 static __init int apbt_late_init(void)
 {
-	if (disable_apbt_percpu)
+	if (disable_apbt_percpu || !apb_timer_block_enabled)
 		return 0;
 	/* This notifier should be called after workqueue is ready */
 	hotcpu_notifier(apbt_cpuhp_notify, -20);
-- 
1.5.6.5

