Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965759Ab2DLQep (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 12:34:45 -0400
Received: from db3ehsobe002.messaging.microsoft.com ([213.199.154.140]:56919
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965553Ab2DLQen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 12:34:43 -0400
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bh8275dhz2dh668h839h944hd25hd2bh)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M2DKPO-01-CNU-02
X-M-MSG: 
Date: Thu, 12 Apr 2012 18:34:22 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Andreas Herrmann <andreas.herrmann3@amd.com>,
        Kay Sievers <kay.sievers@vrfy.org>, Dave Jones <davej@redhat.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] x86, microcode: Ensure that module is only loaded for
Message-ID: <20120412163422.GM24549@aftab>
References: <20120411163849.GE4794@alberich.amd.com>
 <20120411200601.GC12288@kroah.com>
 <20120411201053.GF18114@aftab>
 <20120412162351.GJ24549@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120412162351.GJ24549@aftab>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Herrmann <andreas.herrmann3@amd.com>
Date: Thu, 12 Apr 2012 16:51:57 +0200
Subject: [PATCH 2/2] x86, microcode: Ensure that module is only loaded for supported AMD CPUs

Exit early when there's no support for a particular CPU family. Also,
fixup the "no support for this CPU vendor" to be issued only when the
driver is attempted to be loaded on an unsupported vendor.

Cc: stable@vger.kernel.org
Cc: Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
Cc: Borislav Petkov <borislav.petkov@amd.com>
[Boris: added a commit msg because Andreas is lazy]
Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
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
-- 
1.7.8.4

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551

