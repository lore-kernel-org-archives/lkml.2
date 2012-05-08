Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846Ab2EHE3B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 00:29:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51366 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038Ab2EHE27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 00:28:59 -0400
Date: Mon, 7 May 2012 21:28:40 -0700
From: "tip-bot for Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Message-ID: <tip-7164b3f5e5461b58baa82e82544ca5af71af287b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        kay.sievers@vrfy.org, andreas.herrmann3@amd.com, davej@redhat.com,
        srivatsa.bhat@linux.vnet.ibm.com, gregkh@linuxfoundation.org,
        tglx@linutronix.de, borislav.petkov@amd.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        kay.sievers@vrfy.org, andreas.herrmann3@amd.com,
        srivatsa.bhat@linux.vnet.ibm.com, davej@redhat.com,
        gregkh@linuxfoundation.org, tglx@linutronix.de,
        borislav.petkov@amd.com
In-Reply-To: <4F8BDB58.6070007@linux.vnet.ibm.com>
References: <4F8BDB58.6070007@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/microcode:
  Ensure that module is only loaded on supported Intel CPUs
Git-Commit-ID: 7164b3f5e5461b58baa82e82544ca5af71af287b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 07 May 2012 21:28:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7164b3f5e5461b58baa82e82544ca5af71af287b
Gitweb:     http://git.kernel.org/tip/7164b3f5e5461b58baa82e82544ca5af71af287b
Author:     Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
AuthorDate: Mon, 16 Apr 2012 14:12:00 +0530
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 7 May 2012 14:37:14 +0200

x86/microcode: Ensure that module is only loaded on supported Intel CPUs

Exit early when there's no support for a particular CPU family.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Dave Jones <davej@redhat.com>
Cc: tigran@aivazian.fsnet.co.uk
Cc: Borislav Petkov <borislav.petkov@amd.com>
Link: http://lkml.kernel.org/r/4F8BDB58.6070007@linux.vnet.ibm.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/microcode_intel.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/microcode_intel.c b/arch/x86/kernel/microcode_intel.c
index 3ca42d0..0327e2b 100644
--- a/arch/x86/kernel/microcode_intel.c
+++ b/arch/x86/kernel/microcode_intel.c
@@ -147,12 +147,6 @@ static int collect_cpu_info(int cpu_num, struct cpu_signature *csig)
 
 	memset(csig, 0, sizeof(*csig));
 
-	if (c->x86_vendor != X86_VENDOR_INTEL || c->x86 < 6 ||
-	    cpu_has(c, X86_FEATURE_IA64)) {
-		pr_err("CPU%d not a capable Intel processor\n", cpu_num);
-		return -1;
-	}
-
 	csig->sig = cpuid_eax(0x00000001);
 
 	if ((c->x86_model >= 5) || (c->x86 > 6)) {
@@ -463,6 +457,14 @@ static struct microcode_ops microcode_intel_ops = {
 
 struct microcode_ops * __init init_intel_microcode(void)
 {
+	struct cpuinfo_x86 *c = &cpu_data(0);
+
+	if (c->x86_vendor != X86_VENDOR_INTEL || c->x86 < 6 ||
+	    cpu_has(c, X86_FEATURE_IA64)) {
+		pr_err("Intel CPU family 0x%x not supported\n", c->x86);
+		return NULL;
+	}
+
 	return &microcode_intel_ops;
 }
 
