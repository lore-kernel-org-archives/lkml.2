Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256Ab2DNSYh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 14:24:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59537 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753492Ab2DNSYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 14:24:36 -0400
Date: Sat, 14 Apr 2012 11:24:22 -0700
From: tip-bot for Andreas Herrmann <andreas.herrmann3@amd.com>
Message-ID: <tip-283c1f2558ef4a4411fe908364b15b73b6ab44cf@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, hpa@zytor.com,
        mingo@kernel.org, andreas.herrmann3@amd.com,
        tigran@aivazian.fsnet.co.uk, tglx@linutronix.de,
        borislav.petkov@amd.com
Reply-To: mingo@kernel.org, hpa@zytor.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, andreas.herrmann3@amd.com,
        tigran@aivazian.fsnet.co.uk, tglx@linutronix.de,
        borislav.petkov@amd.com
In-Reply-To: <20120411163849.GE4794@alberich.amd.com>
References: <20120411163849.GE4794@alberich.amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, microcode:
  Ensure that module is only loaded on supported AMD CPUs
Git-Commit-ID: 283c1f2558ef4a4411fe908364b15b73b6ab44cf
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 14 Apr 2012 11:24:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  283c1f2558ef4a4411fe908364b15b73b6ab44cf
Gitweb:     http://git.kernel.org/tip/283c1f2558ef4a4411fe908364b15b73b6ab44cf
Author:     Andreas Herrmann <andreas.herrmann3@amd.com>
AuthorDate: Thu, 12 Apr 2012 16:51:57 +0200
Committer:  Borislav Petkov <borislav.petkov@amd.com>
CommitDate: Fri, 13 Apr 2012 11:51:05 +0200

x86, microcode: Ensure that module is only loaded on supported AMD CPUs

Exit early when there's no support for a particular CPU family. Also,
fixup the "no support for this CPU vendor" to be issued only when the
driver is attempted to be loaded on an unsupported vendor.

Cc: stable@vger.kernel.org
Cc: Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: http://lkml.kernel.org/r/20120411163849.GE4794@alberich.amd.com
[Boris: add a commit msg because Andreas is lazy]
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/microcode_amd.c  |   12 +++++++-----
 arch/x86/kernel/microcode_core.c |    6 +++---
 2 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index 73465aa..8a2ce8f 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -82,11 +82,6 @@ static int collect_cpu_info_amd(int cpu, struct cpu_signature *csig)
 {
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
 
-	if (c->x86_vendor != X86_VENDOR_AMD || c->x86 < 0x10) {
-		pr_warning("CPU%d: family %d not supported\n", cpu, c->x86);
-		return -1;
-	}
-
 	csig->rev = c->microcode;
 	pr_info("CPU%d: patch_level=0x%08x\n", cpu, csig->rev);
 
@@ -380,6 +375,13 @@ static struct microcode_ops microcode_amd_ops = {
 
 struct microcode_ops * __init init_amd_microcode(void)
 {
+	struct cpuinfo_x86 *c = &cpu_data(0);
+
+	if (c->x86_vendor != X86_VENDOR_AMD || c->x86 < 0x10) {
+		pr_warning("AMD CPU family 0x%x not supported\n", c->x86);
+		return NULL;
+	}
+
 	patch = (void *)get_zeroed_page(GFP_KERNEL);
 	if (!patch)
 		return NULL;
diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
index d389e74..c9bda6d 100644
--- a/arch/x86/kernel/microcode_core.c
+++ b/arch/x86/kernel/microcode_core.c
@@ -526,11 +526,11 @@ static int __init microcode_init(void)
 		microcode_ops = init_intel_microcode();
 	else if (c->x86_vendor == X86_VENDOR_AMD)
 		microcode_ops = init_amd_microcode();
-
-	if (!microcode_ops) {
+	else
 		pr_err("no support for this CPU vendor\n");
+
+	if (!microcode_ops)
 		return -ENODEV;
-	}
 
 	microcode_pdev = platform_device_register_simple("microcode", -1,
 							 NULL, 0);
