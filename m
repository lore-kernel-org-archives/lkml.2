Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471Ab1DBGX1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 02:23:27 -0400
Received: from vms173017pub.verizon.net ([206.46.173.17]:42466 "EHLO
	vms173017pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753869Ab1DBGXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 02:23:24 -0400
From: Len Brown <lenb@kernel.org>
To: linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>,
        x86@kernel.org, stable@kernel.org
Subject: [PATCH 06/18] x86 idle: deprecate mwait_idle() and "idle=mwait"
 cmdline param
Date: Sat, 02 Apr 2011 02:22:48 -0400
Message-id: <7eaf17a79efa960a4a317d3cb8651375ed61f5a6.1301724243.git.len.brown@intel.com>
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

mwait_idle() is a C1-only idle loop intended to be more efficient
than HLT on SMP hardware that supports it.

But mwait_idle() has been replaced by the more general
mwait_idle_with_hints(), which handles both C1 and deeper C-states.
ACPI uses only mwait_idle_with_hints(), and never uses mwait_idle().

Deprecate mwait_idle() and the "idle=mwait" cmdline param
to simplify the x86 idle code.

After this change, kernels configured with
(!CONFIG_ACPI=n && !CONFIG_INTEL_IDLE=n) when run on hardware
that support MWAIT will simply use HLT.  If MWAIT is desired
on those systems, cpuidle and the cpuidle drivers above
will support it.

cc: x86@kernel.org
cc: stable@kernel.org
Signed-off-by: Len Brown <len.brown@intel.com>
---
 Documentation/feature-removal-schedule.txt |    7 +++++++
 arch/x86/kernel/process.c                  |    1 +
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index f587159..9ee4a2c 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -35,6 +35,13 @@ Who:	Len Brown <len.brown@intel.com>
 
 ----------------------------
 
+What:	x86 "idle=mwait" cmdline param
+When:	2.6.40
+Why:	simplify x86 idle code
+Who:	Len Brown <len.brown@intel.com>
+
+----------------------------
+
 What:	PRISM54
 When:	2.6.34
 
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 17b8771..1f64501 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -645,6 +645,7 @@ static int __init idle_setup(char *str)
 		boot_option_idle_override = IDLE_POLL;
 	} else if (!strcmp(str, "mwait")) {
 		boot_option_idle_override = IDLE_FORCE_MWAIT;
+		WARN_ONCE(1, "\idle=mwait\" will be removed in 2.6.40\"\n");
 	} else if (!strcmp(str, "halt")) {
 		/*
 		 * When the boot option of idle=halt is added, halt is
-- 
1.7.5.rc0

