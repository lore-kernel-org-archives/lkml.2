Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751960Ab2AZNmQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 08:42:16 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36138 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241Ab2AZNmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 08:42:15 -0500
Date: Thu, 26 Jan 2012 05:41:53 -0800
From: tip-bot for Andreas Herrmann <andreas.herrmann3@amd.com>
Message-ID: <tip-5b68edc91cdc972c46f76f85eded7ffddc3ff5c2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        andreas.herrmann3@amd.com, stable@kernel.org, tglx@linutronix.de,
        borislav.petkov@amd.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        andreas.herrmann3@amd.com, stable@kernel.org, tglx@linutronix.de,
        borislav.petkov@amd.com, mingo@elte.hu
In-Reply-To: <20120120164412.GD24508@alberich.amd.com>
References: <20120120164412.GD24508@alberich.amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/microcode_amd:
  Add support for CPU family specific container files
Git-Commit-ID: 5b68edc91cdc972c46f76f85eded7ffddc3ff5c2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 26 Jan 2012 05:41:58 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5b68edc91cdc972c46f76f85eded7ffddc3ff5c2
Gitweb:     http://git.kernel.org/tip/5b68edc91cdc972c46f76f85eded7ffddc3ff5c2
Author:     Andreas Herrmann <andreas.herrmann3@amd.com>
AuthorDate: Fri, 20 Jan 2012 17:44:12 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 26 Jan 2012 12:06:39 +0100

x86/microcode_amd: Add support for CPU family specific container files

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
---
 arch/x86/kernel/microcode_amd.c |   24 ++++++++++++++++++++++--
 1 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index fe86493..ac0417b 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -311,13 +311,33 @@ out:
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
+
+	if (c->x86 >= 0x15)
+		snprintf(fw_name, sizeof(fw_name), "amd-ucode/microcode_amd_fam%.2xh.bin", c->x86);
 
-	if (request_firmware(&fw, fw_name, device)) {
+	if (request_firmware(&fw, (const char *)fw_name, device)) {
 		pr_err("failed to load file %s\n", fw_name);
 		goto out;
 	}
