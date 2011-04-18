Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439Ab1DRW5x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 18:57:53 -0400
Received: from mga01.intel.com ([192.55.52.88]:52675 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752884Ab1DRW5a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 18:57:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,236,1301900400"; 
   d="scan'208";a="911338179"
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Jason Baron <jbaron@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, tglx@linutronix.de,
        mingo@elte.hu, "H. Peter Anvin" <hpa@linux.intel.com>,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/3] x86, cpu: Change NOP selection for certain Intel CPUs
Date: Mon, 18 Apr 2011 15:36:00 -0700
Message-Id: <1303166160-10315-4-git-send-email-hpa@linux.intel.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1303166160-10315-1-git-send-email-hpa@linux.intel.com>
References: <1303166160-10315-1-git-send-email-hpa@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to a decoder implementation quirk, some specific Intel CPUs
actually perform better with the "k8_nops" than with the
SDM-recommended NOPs.  For runtime-selected NOPs, if we detect those
specific CPUs then use the k8_nops instead of the ones we would
normally use.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jason Baron <jbaron@redhat.com>
---
 arch/x86/kernel/alternative.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 2ca3f65..34bf87e 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -190,7 +190,14 @@ void __init arch_init_ideal_nops(void)
 {
 	switch (boot_cpu_data.x86_vendor) {
 	case X86_VENDOR_INTEL:
-		if (boot_cpu_has(X86_FEATURE_NOPL)) {
+		if (boot_cpu_data.x86 == 6 &&
+		    boot_cpu_data.x86_model >= 0x0f &&
+		    boot_cpu_data.x86_model != 0x1c &&
+		    boot_cpu_data.x86_model != 0x26 &&
+		    boot_cpu_data.x86_model != 0x27 &&
+		    boot_cpu_data.x86_model < 0x30) {
+			ideal_nops = k8_nops;
+		} else if (boot_cpu_has(X86_FEATURE_NOPL)) {
 			   ideal_nops = p6_nops;
 		} else {
 #ifdef CONFIG_X86_64
-- 
1.7.3.4

