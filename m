Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755886Ab0EQXQj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 19:16:39 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50341 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752216Ab0EQXQi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 19:16:38 -0400
Date: Tue, 18 May 2010 01:16:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Pavel Machek <pavel@ucw.cz>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/txt changes for v2.6.35
Message-ID: <20100517231607.GA10357@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-txt-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-txt-for-linus


out-of-topic modifications in x86-txt-for-linus:
------------------------------------------------
MAINTAINERS                        # 4bd96a7: x86, tboot: Add support for S3 me

 Thanks,

	Ingo

------------------>
Shane Wang (1):
      x86, tboot: Add support for S3 memory integrity protection


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
 
