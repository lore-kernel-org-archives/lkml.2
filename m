Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787Ab2K2SpX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 13:45:23 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:56397 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754156Ab2K2SpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 13:45:17 -0500
Date: Thu, 29 Nov 2012 10:45:02 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        Jim Cromie <jim.cromie@gmail.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>, Michal Marek <mmarek@suse.cz>,
        Tony Lindgren <tony@atomide.com>,
        Jonathan Kliegman <kliegs@chromium.org>,
        Chris Zankel <chris@zankel.net>
Cc: Bill Pemberton <wfp5p@viridian.itc.virginia.edu>,
        Fengguang Wu <fengguang.wu@intel.com>, Sam Ravnborg <sam@ravnborg.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: Re: [PATCH 1/2] modpost.c: Stop checking __dev* section mismatches
Message-ID: <20121129184502.GC15110@kroah.com>
References: <20121129184133.GA15110@kroah.com>
 <20121129184328.GB15110@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121129184328.GB15110@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Now that the __dev* sections are not being generated, we don't need to
check for them in modpost.c.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 scripts/mod/modpost.c |   24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 0d93856..ff36c50 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -858,25 +858,23 @@ static void check_section(const char *modname, struct elf_info *elf,
 
 #define ALL_INIT_DATA_SECTIONS \
 	".init.setup$", ".init.rodata$", \
-	".devinit.rodata$", ".cpuinit.rodata$", ".meminit.rodata$", \
-	".init.data$", ".devinit.data$", ".cpuinit.data$", ".meminit.data$"
+	".cpuinit.rodata$", ".meminit.rodata$", \
+	".init.data$", ".cpuinit.data$", ".meminit.data$"
 #define ALL_EXIT_DATA_SECTIONS \
-	".exit.data$", ".devexit.data$", ".cpuexit.data$", ".memexit.data$"
+	".exit.data$", ".cpuexit.data$", ".memexit.data$"
 
 #define ALL_INIT_TEXT_SECTIONS \
-	".init.text$", ".devinit.text$", ".cpuinit.text$", ".meminit.text$"
+	".init.text$", ".cpuinit.text$", ".meminit.text$"
 #define ALL_EXIT_TEXT_SECTIONS \
-	".exit.text$", ".devexit.text$", ".cpuexit.text$", ".memexit.text$"
+	".exit.text$", ".cpuexit.text$", ".memexit.text$"
 
 #define ALL_PCI_INIT_SECTIONS	\
 	".pci_fixup_early$", ".pci_fixup_header$", ".pci_fixup_final$", \
 	".pci_fixup_enable$", ".pci_fixup_resume$", \
 	".pci_fixup_resume_early$", ".pci_fixup_suspend$"
 
-#define ALL_XXXINIT_SECTIONS DEV_INIT_SECTIONS, CPU_INIT_SECTIONS, \
-	MEM_INIT_SECTIONS
-#define ALL_XXXEXIT_SECTIONS DEV_EXIT_SECTIONS, CPU_EXIT_SECTIONS, \
-	MEM_EXIT_SECTIONS
+#define ALL_XXXINIT_SECTIONS CPU_INIT_SECTIONS, MEM_INIT_SECTIONS
+#define ALL_XXXEXIT_SECTIONS CPU_EXIT_SECTIONS, MEM_EXIT_SECTIONS
 
 #define ALL_INIT_SECTIONS INIT_SECTIONS, ALL_XXXINIT_SECTIONS
 #define ALL_EXIT_SECTIONS EXIT_SECTIONS, ALL_XXXEXIT_SECTIONS
@@ -885,12 +883,10 @@ static void check_section(const char *modname, struct elf_info *elf,
 #define TEXT_SECTIONS ".text$"
 
 #define INIT_SECTIONS      ".init.*"
-#define DEV_INIT_SECTIONS  ".devinit.*"
 #define CPU_INIT_SECTIONS  ".cpuinit.*"
 #define MEM_INIT_SECTIONS  ".meminit.*"
 
 #define EXIT_SECTIONS      ".exit.*"
-#define DEV_EXIT_SECTIONS  ".devexit.*"
 #define CPU_EXIT_SECTIONS  ".cpuexit.*"
 #define MEM_EXIT_SECTIONS  ".memexit.*"
 
@@ -979,7 +975,7 @@ const struct sectioncheck sectioncheck[] = {
 	.mismatch = DATA_TO_ANY_EXIT,
 	.symbol_white_list = { DEFAULT_SYMBOL_WHITE_LIST, NULL },
 },
-/* Do not reference init code/data from devinit/cpuinit/meminit code/data */
+/* Do not reference init code/data from cpuinit/meminit code/data */
 {
 	.fromsec = { ALL_XXXINIT_SECTIONS, NULL },
 	.tosec   = { INIT_SECTIONS, NULL },
@@ -1000,7 +996,7 @@ const struct sectioncheck sectioncheck[] = {
 	.mismatch = XXXINIT_TO_SOME_INIT,
 	.symbol_white_list = { DEFAULT_SYMBOL_WHITE_LIST, NULL },
 },
-/* Do not reference exit code/data from devexit/cpuexit/memexit code/data */
+/* Do not reference exit code/data from cpuexit/memexit code/data */
 {
 	.fromsec = { ALL_XXXEXIT_SECTIONS, NULL },
 	.tosec   = { EXIT_SECTIONS, NULL },
@@ -1089,7 +1085,7 @@ static const struct sectioncheck *section_mismatch(
  * Pattern 2:
  *   Many drivers utilise a *driver container with references to
  *   add, remove, probe functions etc.
- *   These functions may often be marked __devinit and we do not want to
+ *   These functions may often be marked __cpuinit and we do not want to
  *   warn here.
  *   the pattern is identified by:
  *   tosec   = init or exit section
