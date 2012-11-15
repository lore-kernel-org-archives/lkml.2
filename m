Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575Ab2KOA0W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 19:26:22 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45094 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755412Ab2KOA0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 19:26:21 -0500
Date: Wed, 14 Nov 2012 16:25:43 -0800
From: tip-bot for Fenghua Yu <fenghua.yu@intel.com>
Message-ID: <tip-30242aa6023b71325c6b8addac06faf544a85fd0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1352835171-3958-12-git-send-email-fenghua.yu@intel.com>
References: <1352835171-3958-12-git-send-email-fenghua.yu@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/bsp-hotplug] x86, hotplug:
  The first online processor saves the MTRR state
Git-Commit-ID: 30242aa6023b71325c6b8addac06faf544a85fd0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 14 Nov 2012 16:26:14 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  30242aa6023b71325c6b8addac06faf544a85fd0
Gitweb:     http://git.kernel.org/tip/30242aa6023b71325c6b8addac06faf544a85fd0
Author:     Fenghua Yu <fenghua.yu@intel.com>
AuthorDate: Tue, 13 Nov 2012 11:32:48 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 14 Nov 2012 15:28:10 -0800

x86, hotplug: The first online processor saves the MTRR state

Ask the first online CPU to save mtrr instead of asking BSP. BSP could be
offline when mtrr_save_state() is called.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Link: http://lkml.kernel.org/r/1352835171-3958-12-git-send-email-fenghua.yu@intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/cpu/mtrr/main.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/main.c b/arch/x86/kernel/cpu/mtrr/main.c
index 6b96110..e4c1a41 100644
--- a/arch/x86/kernel/cpu/mtrr/main.c
+++ b/arch/x86/kernel/cpu/mtrr/main.c
@@ -695,11 +695,16 @@ void mtrr_ap_init(void)
 }
 
 /**
- * Save current fixed-range MTRR state of the BSP
+ * Save current fixed-range MTRR state of the first cpu in cpu_online_mask.
  */
 void mtrr_save_state(void)
 {
-	smp_call_function_single(0, mtrr_save_fixed_ranges, NULL, 1);
+	int first_cpu;
+
+	get_online_cpus();
+	first_cpu = cpumask_first(cpu_online_mask);
+	smp_call_function_single(first_cpu, mtrr_save_fixed_ranges, NULL, 1);
+	put_online_cpus();
 }
 
 void set_mtrr_aps_delayed_init(void)
