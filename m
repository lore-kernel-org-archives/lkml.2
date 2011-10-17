Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756100Ab1JQOgO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 10:36:14 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:27232
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756027Ab1JQOfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 10:35:33 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz32i668h839h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LT7SIY-01-BYW-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
        oprofile-list <oprofile-list@lists.sourceforge.net>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 1/5] oprofile, x86: Add kernel parameter
Date: Mon, 17 Oct 2011 16:27:00 +0200
Message-ID: <1318861624-715-2-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1318861624-715-1-git-send-email-robert.richter@amd.com>
References: <1318861624-715-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need this to better test x86 NMI timer mode. Otherwise it is very
hard to setup systems with NMI timer enabled, but we have this e.g. in
virtual machine environments.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 Documentation/kernel-parameters.txt |    3 +++
 arch/x86/oprofile/nmi_int.c         |   27 +++++++++++++++++++++------
 2 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 854ed5ca..f7735a1 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1848,6 +1848,9 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			arch_perfmon: [X86] Force use of architectural
 				perfmon on Intel CPUs instead of the
 				CPU specific event set.
+			timer: [X86] Force use of architectural NMI
+				timer mode (see also oprofile.timer
+				for generic hr timer mode)
 
 	oops=panic	Always panic on oopses. Default is to just kill the
 			process, but there is a small probability of
diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index 68894fd..7ca4d43 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -613,24 +613,36 @@ static int __init p4_init(char **cpu_type)
 	return 0;
 }
 
-static int force_arch_perfmon;
-static int force_cpu_type(const char *str, struct kernel_param *kp)
+enum __force_cpu_type {
+	reserved = 0,		/* do not force */
+	timer,
+	arch_perfmon,
+};
+
+static int force_cpu_type;
+
+static int set_cpu_type(const char *str, struct kernel_param *kp)
 {
-	if (!strcmp(str, "arch_perfmon")) {
-		force_arch_perfmon = 1;
+	if (!strcmp(str, "timer")) {
+		force_cpu_type = timer;
+		printk(KERN_INFO "oprofile: forcing NMI timer mode\n");
+	} else if (!strcmp(str, "arch_perfmon")) {
+		force_cpu_type = arch_perfmon;
 		printk(KERN_INFO "oprofile: forcing architectural perfmon\n");
+	} else {
+		force_cpu_type = 0;
 	}
 
 	return 0;
 }
-module_param_call(cpu_type, force_cpu_type, NULL, NULL, 0);
+module_param_call(cpu_type, set_cpu_type, NULL, NULL, 0);
 
 static int __init ppro_init(char **cpu_type)
 {
 	__u8 cpu_model = boot_cpu_data.x86_model;
 	struct op_x86_model_spec *spec = &op_ppro_spec;	/* default */
 
-	if (force_arch_perfmon && cpu_has_arch_perfmon)
+	if (force_cpu_type == arch_perfmon && cpu_has_arch_perfmon)
 		return 0;
 
 	/*
@@ -697,6 +709,9 @@ int __init op_nmi_init(struct oprofile_operations *ops)
 	if (!cpu_has_apic)
 		return -ENODEV;
 
+	if (force_cpu_type == timer)
+		return -ENODEV;
+
 	switch (vendor) {
 	case X86_VENDOR_AMD:
 		/* Needs to be at least an Athlon (or hammer in 32bit mode) */
-- 
1.7.7


