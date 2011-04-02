Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570Ab1DBGXd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 02:23:33 -0400
Received: from vms173001pub.verizon.net ([206.46.173.1]:59858 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754100Ab1DBGX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 02:23:26 -0400
From: Len Brown <lenb@kernel.org>
To: linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>,
        x86@kernel.org, Jiri Kosina <jkosina@suse.cz>, stable@kernel.org
Subject: [PATCH 03/18] x86 idle APM: deprecate CONFIG_APM_CPU_IDLE
Date: Sat, 02 Apr 2011 02:22:45 -0400
Message-id: <392e1ffeeaefd448f69d45041fe4406fbd197852.1301724243.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.5.rc0
In-reply-to: <1301725380-10579-1-git-send-email-lenb@kernel.org>
References: <alpine.LFD.2.02.1104010020280.2797@x980>
 <1301725380-10579-1-git-send-email-lenb@kernel.org>
In-reply-to: <c82cf78992a66bfa7f0c82aeb20ba6922127463b.1301724243.git.len.brown@intel.com>
References: <c82cf78992a66bfa7f0c82aeb20ba6922127463b.1301724243.git.len.brown@intel.com>
X-Patchwork-Hint: ignore
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

We don't want to export the pm_idle function pointer to modules.
Currently CONFIG_APM_CPU_IDLE w/ CONFIG_APM_MODULE forces us to.

CONFIG_APM_CPU_IDLE is of dubious value, it runs only on 32-bit
uniprocessor laptops that are over 10 years old.  It calls into
the BIOS during idle, and is known to cause a number of machines
to fail.

Removing CONFIG_APM_CPU_IDLE and will allow us to stop exporting
pm_idle.  Any systems that were calling into the APM BIOS
at run-time will simply use HLT instead.

cc: x86@kernel.org
cc: Jiri Kosina <jkosina@suse.cz>
cc: stable@kernel.org
Signed-off-by: Len Brown <len.brown@intel.com>
---
 Documentation/feature-removal-schedule.txt |   10 ++++++++++
 arch/x86/kernel/apm_32.c                   |    2 ++
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 54db467..bab1acb 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -14,6 +14,16 @@ Who:	Len Brown <len.brown@intel.com>
 
 ---------------------------
 
+What:	CONFIG_APM_CPU_IDLE, and its ability to call APM BIOS in idle
+When:	2.6.40
+Why:	This optional sub-feature of APM is of dubious reliability,
+	and ancient APM laptops are likely better served by calling HLT.
+	Deleting CONFIG_APM_CPU_IDLE allows x86 to stop exporting
+	the pm_idle function pointer to modules.
+Who:	Len Brown <len.brown@intel.com>
+
+----------------------------
+
 What:	PRISM54
 When:	2.6.34
 
diff --git a/arch/x86/kernel/apm_32.c b/arch/x86/kernel/apm_32.c
index 0e4f24c..072546c 100644
--- a/arch/x86/kernel/apm_32.c
+++ b/arch/x86/kernel/apm_32.c
@@ -359,6 +359,7 @@ struct apm_user {
  * idle percentage above which bios idle calls are done
  */
 #ifdef CONFIG_APM_CPU_IDLE
+#warning deprecated CONFIG_APM_CPU_IDLE will be deleted in 2.6.40
 #define DEFAULT_IDLE_THRESHOLD	95
 #else
 #define DEFAULT_IDLE_THRESHOLD	100
@@ -902,6 +903,7 @@ static void apm_cpu_idle(void)
 	unsigned int jiffies_since_last_check = jiffies - last_jiffies;
 	unsigned int bucket;
 
+	WARN_ONCE(1, "deprecated apm_cpu_idle will be deleted in 2.6.40");
 recalc:
 	if (jiffies_since_last_check > IDLE_CALC_LIMIT) {
 		use_apm_idle = 0;
-- 
1.7.5.rc0

