Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756899Ab0F3QLl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 12:11:41 -0400
Received: from mga11.intel.com ([192.55.52.93]:6813 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754118Ab0F3QLk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 12:11:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,513,1272870000"; 
   d="scan'208";a="581480535"
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Alan Cox <alan@linux.intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [PATCH] x86/mrst: assign a guessed cpu_khz value before calibration
Date: Wed, 30 Jun 2010 09:11:01 -0700
Message-Id: <1277914261-6918-1-git-send-email-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new setup_local_APIC() code introduced by commit 8c3ba8d0 requires a valid
cpu_khz value used as max loop count for clearing pending interrupts. However,
Moorestown does a early APIC setup for the system timer interrupts which is
before a valid cpu_khz is assigned in tsc calibration code.

This patch assigns a guessed value for cpu_khz to avoid a warning in local APIC
setup code. The acuracy of cpu_khz is not important at the point of local APIC
setup.

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
---
 arch/x86/kernel/mrst.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/mrst.c b/arch/x86/kernel/mrst.c
index 5fd5f9c..4901554 100644
--- a/arch/x86/kernel/mrst.c
+++ b/arch/x86/kernel/mrst.c
@@ -387,7 +387,12 @@ void __init x86_mrst_early_setup(void)
 	/* Avoid searching for BIOS MP tables */
 	x86_init.mpparse.find_smp_config = x86_init_noop;
 	x86_init.mpparse.get_smp_config = x86_init_uint_noop;
-
+	/*
+	 * Give an estimated CPU frequency which will be used by early local
+	 * APIC setup code prior to calibration. The true value will be set
+	 * in tsc calibration later.
+	 */
+	cpu_khz = 1500000;
 }
 
 /*
-- 
1.7.0.4

