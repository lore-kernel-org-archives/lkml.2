Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757267Ab2BAVJv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:09:51 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:41521 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757200Ab2BAVJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:09:46 -0500
X-Sasl-enc: 2OAFtvCu7JH3ngGz33lJi6m90flIXfARf9J9JpF22ctJ 1328130585
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Feb  1 13:00:46 2012
Message-Id: <20120201210046.121039322@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Wed, 01 Feb 2012 12:59:49 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>, <stable@kernel.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: [25/89] x86/microcode_amd: Add support for CPU family specific container files
In-Reply-To: <20120201210505.GA26028@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Herrmann <andreas.herrmann3@amd.com>

commit 5b68edc91cdc972c46f76f85eded7ffddc3ff5c2 upstream.

We've decided to provide CPU family specific container files
(starting with CPU family 15h). E.g. for family 15h we have to
load microcode_amd_fam15h.bin instead of microcode_amd.bin

Rationale is that starting with family 15h patch size is larger
than 2KB which was hard coded as maximum patch size in various
microcode loaders (not just Linux).

Container files which include patches larger than 2KB cause
different kinds of trouble with such old patch loaders. Thus we
have to ensure that the default container file provides only
patches with size less than 2KB.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Borislav Petkov <borislav.petkov@amd.com>
Cc: <stable@kernel.org>
Link: http://lkml.kernel.org/r/20120120164412.GD24508@alberich.amd.com
[ documented the naming convention and tidied the code a bit. ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/microcode_amd.c |   24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -300,13 +300,33 @@ free_table:
 	return state;
 }
 
+/*
+ * AMD microcode firmware naming convention, up to family 15h they are in
+ * the legacy file:
+ *
+ *    amd-ucode/microcode_amd.bin
+ *
+ * This legacy file is always smaller than 2K in size.
+ *
+ * Starting at family 15h they are in family specific firmware files:
+ *
+ *    amd-ucode/microcode_amd_fam15h.bin
+ *    amd-ucode/microcode_amd_fam16h.bin
+ *    ...
+ *
+ * These might be larger than 2K.
+ */
 static enum ucode_state request_microcode_amd(int cpu, struct device *device)
 {
-	const char *fw_name = "amd-ucode/microcode_amd.bin";
+	char fw_name[36] = "amd-ucode/microcode_amd.bin";
 	const struct firmware *fw;
 	enum ucode_state ret = UCODE_NFOUND;
+	struct cpuinfo_x86 *c = &cpu_data(cpu);
 
-	if (request_firmware(&fw, fw_name, device)) {
+	if (c->x86 >= 0x15)
+		snprintf(fw_name, sizeof(fw_name), "amd-ucode/microcode_amd_fam%.2xh.bin", c->x86);
+
+	if (request_firmware(&fw, (const char *)fw_name, device)) {
 		pr_err("failed to load file %s\n", fw_name);
 		goto out;
 	}


