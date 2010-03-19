Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751812Ab0CSVTe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 17:19:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:55328 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751219Ab0CSVTc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 17:19:32 -0400
Date: Fri, 19 Mar 2010 21:18:50 GMT
From: tip-bot for Shane Wang <shane.wang@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       joseph.cihula@intel.com, pavel@ucw.cz, shane.wang@intel.com,
       tglx@linutronix.de, rjw@sisk.pl
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       joseph.cihula@intel.com, pavel@ucw.cz, shane.wang@intel.com,
       tglx@linutronix.de, rjw@sisk.pl
In-Reply-To: <4B973DDA.6050902@intel.com>
References: <4B973DDA.6050902@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/txt] x86, tboot: Add support for S3 memory integrity protection
Message-ID: <tip-4bd96a7a8185755b091233b16034c7436cbf57af@git.kernel.org>
Git-Commit-ID: 4bd96a7a8185755b091233b16034c7436cbf57af
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 19 Mar 2010 21:18:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4bd96a7a8185755b091233b16034c7436cbf57af
Gitweb:     http://git.kernel.org/tip/4bd96a7a8185755b091233b16034c7436cbf57af
Author:     Shane Wang <shane.wang@intel.com>
AuthorDate: Wed, 10 Mar 2010 14:36:10 +0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Fri, 19 Mar 2010 13:39:58 -0700

x86, tboot: Add support for S3 memory integrity protection

This patch adds support for S3 memory integrity protection within an Intel(R)
TXT launched kernel, for all kernel and userspace memory.  All RAM used by the
kernel and userspace, as indicated by memory ranges of type E820_RAM and
E820_RESERVED_KERN in the e820 table, will be integrity protected.

The MAINTAINERS file is also updated to reflect the maintainers of the
TXT-related code.

All MACing is done in tboot, based on a complexity analysis and tradeoff.

v3: Compared with v2, this patch adds a check of array size in
tboot.c, and a note to specify which c/s of tboot supports this kind
of MACing in intel_txt.txt.

Signed-off-by: Shane Wang <shane.wang@intel.com>
LKML-Reference: <4B973DDA.6050902@intel.com>
Signed-off-by: Joseph Cihula <joseph.cihula@intel.com>
Acked-by: Pavel Machek <pavel@ucw.cz>
Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 Documentation/intel_txt.txt |   16 +++++++++-------
 MAINTAINERS                 |   11 +++++++++++
 arch/x86/include/asm/e820.h |    7 ++++++-
 arch/x86/kernel/tboot.c     |   20 +++++++++++---------
 4 files changed, 37 insertions(+), 17 deletions(-)

diff --git a/Documentation/intel_txt.txt b/Documentation/intel_txt.txt
index f40a1f0..87c8990 100644
--- a/Documentation/intel_txt.txt
+++ b/Documentation/intel_txt.txt
@@ -161,13 +161,15 @@ o  In order to put a system into any of the sleep states after a TXT
       has been restored, it will restore the TPM PCRs and then
       transfer control back to the kernel's S3 resume vector.
       In order to preserve system integrity across S3, the kernel
-      provides tboot with a set of memory ranges (kernel
-      code/data/bss, S3 resume code, and AP trampoline) that tboot
-      will calculate a MAC (message authentication code) over and then
-      seal with the TPM.  On resume and once the measured environment
-      has been re-established, tboot will re-calculate the MAC and
-      verify it against the sealed value.  Tboot's policy determines
-      what happens if the verification fails.
+      provides tboot with a set of memory ranges (RAM and RESERVED_KERN
+      in the e820 table, but not any memory that BIOS might alter over
+      the S3 transition) that tboot will calculate a MAC (message
+      authentication code) over and then seal with the TPM. On resume
+      and once the measured environment has been re-established, tboot
+      will re-calculate the MAC and verify it against the sealed value.
+      Tboot's policy determines what happens if the verification fails.
+      Note that the c/s 194 of tboot which has the new MAC code supports
+      this.
 
 That's pretty much it for TXT support.
 
diff --git a/MAINTAINERS b/MAINTAINERS
index 47cc449..d3072cb 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2940,6 +2940,17 @@ S:	Odd Fixes
 F:	Documentation/networking/README.ipw2200
 F:	drivers/net/wireless/ipw2x00/ipw2200.*
 
+INTEL(R) TRUSTED EXECUTION TECHNOLOGY (TXT)
+M:	Joseph Cihula <joseph.cihula@intel.com>
+M:	Shane Wang <shane.wang@intel.com>
+L:	tboot-devel@lists.sourceforge.net
+W:	http://tboot.sourceforge.net
+T:	Mercurial http://www.bughost.org/repos.hg/tboot.hg
+S:	Supported
+F:	Documentation/intel_txt.txt
+F:	include/linux/tboot.h
+F:	arch/x86/kernel/tboot.c
+
 INTEL WIRELESS WIMAX CONNECTION 2400
 M:	Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
 M:	linux-wimax@intel.com
diff --git a/arch/x86/include/asm/e820.h b/arch/x86/include/asm/e820.h
index 0e22296..ec8a52d 100644
--- a/arch/x86/include/asm/e820.h
+++ b/arch/x86/include/asm/e820.h
@@ -45,7 +45,12 @@
 #define E820_NVS	4
 #define E820_UNUSABLE	5
 
-/* reserved RAM used by kernel itself */
+/*
+ * reserved RAM used by kernel itself
+ * if CONFIG_INTEL_TXT is enabled, memory of this type will be
+ * included in the S3 integrity calculation and so should not include
+ * any memory that BIOS might alter over the S3 transition
+ */
 #define E820_RESERVED_KERN        128
 
 #ifndef __ASSEMBLY__
diff --git a/arch/x86/kernel/tboot.c b/arch/x86/kernel/tboot.c
index 86c9f91..cc2c604 100644
--- a/arch/x86/kernel/tboot.c
+++ b/arch/x86/kernel/tboot.c
@@ -175,6 +175,9 @@ static void add_mac_region(phys_addr_t start, unsigned long size)
 	struct tboot_mac_region *mr;
 	phys_addr_t end = start + size;
 
+	if (tboot->num_mac_regions >= MAX_TB_MAC_REGIONS)
+		panic("tboot: Too many MAC regions\n");
+
 	if (start && size) {
 		mr = &tboot->mac_regions[tboot->num_mac_regions++];
 		mr->start = round_down(start, PAGE_SIZE);
@@ -184,18 +187,17 @@ static void add_mac_region(phys_addr_t start, unsigned long size)
 
 static int tboot_setup_sleep(void)
 {
+	int i;
+
 	tboot->num_mac_regions = 0;
 
-	/* S3 resume code */
-	add_mac_region(acpi_wakeup_address, WAKEUP_SIZE);
+	for (i = 0; i < e820.nr_map; i++) {
+		if ((e820.map[i].type != E820_RAM)
+		 && (e820.map[i].type != E820_RESERVED_KERN))
+			continue;
 
-#ifdef CONFIG_X86_TRAMPOLINE
-	/* AP trampoline code */
-	add_mac_region(virt_to_phys(trampoline_base), TRAMPOLINE_SIZE);
-#endif
-
-	/* kernel code + data + bss */
-	add_mac_region(virt_to_phys(_text), _end - _text);
+		add_mac_region(e820.map[i].addr, e820.map[i].size);
+	}
 
 	tboot->acpi_sinfo.kernel_s3_resume_vector = acpi_wakeup_address;
 
