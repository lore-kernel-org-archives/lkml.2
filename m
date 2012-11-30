Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756068Ab2K3Itd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 03:49:33 -0500
Received: from mga01.intel.com ([192.55.52.88]:45218 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755861Ab2K3It2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 03:49:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,191,1355126400"; 
   d="scan'208";a="255459077"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "H Peter Anvin" <hpa@zytor.com>, "Ingo Molnar" <mingo@elte.hu>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Asit K Mallick" <asit.k.mallick@intel.com>,
        "Tigran Aivazian" <tigran@aivazian.fsnet.co.uk>,
        "Andreas Herrmann" <andreas.herrmann3@amd.com>,
        "Borislav Petkov" <borislav.petkov@amd.com>,
        "linux-kernel" <linux-kernel@vger.kernel.org>, "x86" <x86@kernel.org>
Cc: "Fenghua Yu" <fenghua.yu@intel.com>
Subject: [PATCH v2 04/10] x86/microcode_intel_lib.c: Early update ucode on Intel's CPU
Date: Thu, 29 Nov 2012 17:47:42 -0800
Message-Id: <1354240068-9821-5-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1354240068-9821-1-git-send-email-fenghua.yu@intel.com>
References: <1354240068-9821-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

Define interfaces microcode_sanity_check() and get_matching_microcode(). They
are called both in early boot time and in microcode Intel driver.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/kernel/microcode_intel_lib.c |  174 +++++++++++++++++++++++++++++++++
 1 files changed, 174 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/kernel/microcode_intel_lib.c

diff --git a/arch/x86/kernel/microcode_intel_lib.c b/arch/x86/kernel/microcode_intel_lib.c
new file mode 100644
index 0000000..ce69320
--- /dev/null
+++ b/arch/x86/kernel/microcode_intel_lib.c
@@ -0,0 +1,174 @@
+/*
+ *	Intel CPU Microcode Update Driver for Linux
+ *
+ *	Copyright (C) 2012 Fenghua Yu <fenghua.yu@intel.com>
+ *			   H Peter Anvin" <hpa@zytor.com>
+ *
+ *	This driver allows to upgrade microcode on Intel processors
+ *	belonging to IA-32 family - PentiumPro, Pentium II,
+ *	Pentium III, Xeon, Pentium 4, etc.
+ *
+ *	Reference: Section 8.11 of Volume 3a, IA-32 Intel? Architecture
+ *	Software Developer's Manual
+ *	Order Number 253668 or free download from:
+ *
+ *	http://developer.intel.com/Assets/PDF/manual/253668.pdf
+ *
+ *	For more information, go to http://www.urbanmyth.org/microcode
+ *
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License
+ *	as published by the Free Software Foundation; either version
+ *	2 of the License, or (at your option) any later version.
+ *
+ */
+#include <linux/firmware.h>
+#include <linux/uaccess.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+
+#include <asm/microcode_intel.h>
+#include <asm/processor.h>
+#include <asm/msr.h>
+
+static inline int
+update_match_cpu(unsigned int csig, unsigned int cpf,
+		 unsigned int sig, unsigned int pf)
+{
+	return (!sigmatch(sig, csig, pf, cpf)) ? 0 : 1;
+}
+
+int
+update_match_revision(struct microcode_header_intel *mc_header, int rev)
+{
+	return (mc_header->rev <= rev) ? 0 : 1;
+}
+
+int microcode_sanity_check(void *mc, int print_err)
+{
+	unsigned long total_size, data_size, ext_table_size;
+	struct microcode_header_intel *mc_header = mc;
+	struct extended_sigtable *ext_header = NULL;
+	int sum, orig_sum, ext_sigcount = 0, i;
+	struct extended_signature *ext_sig;
+
+	total_size = get_totalsize(mc_header);
+	data_size = get_datasize(mc_header);
+
+	if (data_size + MC_HEADER_SIZE > total_size) {
+		if (print_err)
+			pr_err("error! Bad data size in microcode data file\n");
+		return -EINVAL;
+	}
+
+	if (mc_header->ldrver != 1 || mc_header->hdrver != 1) {
+		if (print_err)
+			pr_err("error! Unknown microcode update format\n");
+		return -EINVAL;
+	}
+	ext_table_size = total_size - (MC_HEADER_SIZE + data_size);
+	if (ext_table_size) {
+		if ((ext_table_size < EXT_HEADER_SIZE)
+		 || ((ext_table_size - EXT_HEADER_SIZE) % EXT_SIGNATURE_SIZE)) {
+			if (print_err)
+				pr_err("error! Small exttable size in microcode data file\n");
+			return -EINVAL;
+		}
+		ext_header = mc + MC_HEADER_SIZE + data_size;
+		if (ext_table_size != exttable_size(ext_header)) {
+			if (print_err)
+				pr_err("error! Bad exttable size in microcode data file\n");
+			return -EFAULT;
+		}
+		ext_sigcount = ext_header->count;
+	}
+
+	/* check extended table checksum */
+	if (ext_table_size) {
+		int ext_table_sum = 0;
+		int *ext_tablep = (int *)ext_header;
+
+		i = ext_table_size / DWSIZE;
+		while (i--)
+			ext_table_sum += ext_tablep[i];
+		if (ext_table_sum) {
+			if (print_err)
+				pr_warn("aborting, bad extended signature table checksum\n");
+			return -EINVAL;
+		}
+	}
+
+	/* calculate the checksum */
+	orig_sum = 0;
+	i = (MC_HEADER_SIZE + data_size) / DWSIZE;
+	while (i--)
+		orig_sum += ((int *)mc)[i];
+	if (orig_sum) {
+		if (print_err)
+			pr_err("aborting, bad checksum\n");
+		return -EINVAL;
+	}
+	if (!ext_table_size)
+		return 0;
+	/* check extended signature checksum */
+	for (i = 0; i < ext_sigcount; i++) {
+		ext_sig = (void *)ext_header + EXT_HEADER_SIZE +
+			  EXT_SIGNATURE_SIZE * i;
+		sum = orig_sum
+			- (mc_header->sig + mc_header->pf + mc_header->cksum)
+			+ (ext_sig->sig + ext_sig->pf + ext_sig->cksum);
+		if (sum) {
+			if (print_err)
+				pr_err("aborting, bad checksum\n");
+			return -EINVAL;
+		}
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(microcode_sanity_check);
+
+/*
+ * return 0 - no update found
+ * return 1 - found update
+ */
+int get_matching_sig(unsigned int csig, int cpf, void *mc, int rev)
+{
+	struct microcode_header_intel *mc_header = mc;
+	struct extended_sigtable *ext_header;
+	unsigned long total_size = get_totalsize(mc_header);
+	int ext_sigcount, i;
+	struct extended_signature *ext_sig;
+
+	if (update_match_cpu(csig, cpf, mc_header->sig, mc_header->pf))
+		return 1;
+
+	/* Look for ext. headers: */
+	if (total_size <= get_datasize(mc_header) + MC_HEADER_SIZE)
+		return 0;
+
+	ext_header = mc + get_datasize(mc_header) + MC_HEADER_SIZE;
+	ext_sigcount = ext_header->count;
+	ext_sig = (void *)ext_header + EXT_HEADER_SIZE;
+
+	for (i = 0; i < ext_sigcount; i++) {
+		if (update_match_cpu(csig, cpf, ext_sig->sig, ext_sig->pf))
+			return 1;
+		ext_sig++;
+	}
+	return 0;
+}
+
+/*
+ * return 0 - no update found
+ * return 1 - found update
+ */
+int get_matching_microcode(unsigned int csig, int cpf, void *mc, int rev)
+{
+	struct microcode_header_intel *mc_header = mc;
+
+	if (!update_match_revision(mc_header, rev))
+		return 0;
+
+	return get_matching_sig(csig, cpf, mc, rev);
+}
+EXPORT_SYMBOL_GPL(get_matching_microcode);
-- 
1.7.2

