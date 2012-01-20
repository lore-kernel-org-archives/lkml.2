Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155Ab2ATQoX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 11:44:23 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:59620 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755103Ab2ATQoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 11:44:19 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dhc1bhc31hc1ah668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LY3VTQ-01-K1O-02
X-M-MSG: 
Date: Fri, 20 Jan 2012 17:44:12 +0100
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
CC: <linux-kernel@vger.kernel.org>, Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH resend] x86, microcode_amd: Add support for CPU family
 specific container files
Message-ID: <20120120164412.GD24508@alberich.amd.com>
References: <20120105200230.GA24451@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120105200230.GA24451@alberich.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We've decided to provide CPU family specific container files (starting
with CPU family 15h). E.g. for family 15h we have to load
microcode_amd_fam15h.bin instead of microcode_amd.bin

Rationale is that starting with family 15h patch size is larger than
2KB which was hard coded as maximum patch size in various microcode
loaders (not just Linux).

Container files which include patches larger than 2KB cause different
kinds of trouble with such old patch loaders. Thus we have to ensure
that the default container file provides only patches with size less
than 2KB.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/kernel/microcode_amd.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index fe86493..d4e679a 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -313,11 +313,16 @@ out:
 
 static enum ucode_state request_microcode_amd(int cpu, struct device *device)
 {
-	const char *fw_name = "amd-ucode/microcode_amd.bin";
+	char fw_name[36] = "amd-ucode/microcode_amd.bin";
 	const struct firmware *fw;
 	enum ucode_state ret = UCODE_NFOUND;
+	struct cpuinfo_x86 *c = &cpu_data(cpu);
+
+	if (c->x86 >= 0x15)
+		snprintf(fw_name, sizeof(fw_name),
+			 "amd-ucode/microcode_amd_fam%.2xh.bin", c->x86);
 
-	if (request_firmware(&fw, fw_name, device)) {
+	if (request_firmware(&fw, (const char *) fw_name, device)) {
 		pr_err("failed to load file %s\n", fw_name);
 		goto out;
 	}
-- 
1.7.8.1



