Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759470Ab2EJObY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 10:31:24 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:56055 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757440Ab2EJOaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 10:30:46 -0400
From: Borislav Petkov <bp@amd64.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: X86-ML <x86@kernel.org>, EDAC devel <linux-edac@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 8/9] x86, MCE, AMD: Give proper names to the thresholding banks
Date: Thu, 10 May 2012 16:30:28 +0200
Message-Id: <1336660229-32644-9-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.9.3.362.g71319
In-Reply-To: <1336660229-32644-1-git-send-email-bp@amd64.org>
References: <1336660229-32644-1-git-send-email-bp@amd64.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Having the banks numbered is ok but having real names which mean
something to the user makes a lot more sense:

/sys/devices/system/machinecheck/machinecheck0/
├── bank0
├── bank1
├── bank2
├── bank3
├── bank4
├── bank5
├── bank6
├── check_interval
├── cmci_disabled
├── combined_unit
│   └── combined_unit
│       ├── error_count
│       └── threshold_limit
├── dont_log_ce
├── execution_unit
│   └── execution_unit
│       ├── error_count
│       └── threshold_limit
├── ignore_ce
├── insn_fetch
│   └── insn_fetch
│       ├── error_count
│       └── threshold_limit
├── load_store
│   └── load_store
│       ├── error_count
│       └── threshold_limit
├── monarch_timeout
├── northbridge
│   ├── dram
│   │   ├── error_count
│   │   ├── interrupt_enable
│   │   └── threshold_limit
│   ├── ht_links
│   │   ├── error_count
│   │   ├── interrupt_enable
│   │   └── threshold_limit
│   └── l3_cache
│       ├── error_count
│       ├── interrupt_enable
│       └── threshold_limit
...

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/cpu/mcheck/mce_amd.c |   35 ++++++++++++++++++++++++++++++----
 1 file changed, 31 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c b/arch/x86/kernel/cpu/mcheck/mce_amd.c
index e5ed2c7cb4de..e20bdf8d7c59 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
@@ -46,6 +46,15 @@
 #define MASK_BLKPTR_LO    0xFF000000
 #define MCG_XBLK_ADDR     0xC0000400
 
+static const char * const th_names[] = {
+	"load_store",
+	"insn_fetch",
+	"combined_unit",
+	"",
+	"northbridge",
+	"execution_unit",
+};
+
 static DEFINE_PER_CPU(struct threshold_bank * [NR_BANKS], threshold_banks);
 
 static unsigned char shared_bank[NR_BANKS] = {
@@ -68,6 +77,26 @@ struct thresh_restart {
 	u16			old_limit;
 };
 
+static const char * const bank4_names(struct threshold_block *b)
+{
+	switch (b->address) {
+	/* MSR4_MISC0 */
+	case 0x00000413:
+		return "dram";
+
+	case 0xc0000408:
+		return "ht_links";
+
+	case 0xc0000409:
+		return "l3_cache";
+
+	default:
+		WARN(1, "Funny MSR: 0x%08x\n", b->address);
+		return "";
+	}
+};
+
+
 static bool lvt_interrupt_supported(unsigned int bank, u32 msr_high_bits)
 {
 	/*
@@ -481,7 +510,7 @@ static __cpuinit int allocate_threshold_blocks(unsigned int cpu,
 
 	err = kobject_init_and_add(&b->kobj, &threshold_ktype,
 				   per_cpu(threshold_banks, cpu)[bank]->kobj,
-				   "misc%i", block);
+				   (bank == 4 ? bank4_names(b) : th_names[bank]));
 	if (err)
 		goto out_free;
 recurse:
@@ -541,11 +570,9 @@ static __cpuinit int threshold_create_bank(unsigned int cpu, unsigned int bank)
 	struct device *dev = per_cpu(mce_device, cpu);
 	struct amd_northbridge *nb = NULL;
 	struct threshold_bank *b = NULL;
-	char name[32];
+	const char *name = th_names[bank];
 	int err = 0;
 
-	sprintf(name, "threshold_bank%i", bank);
-
 	if (shared_bank[bank]) {
 
 		nb = node_to_amd_nb(amd_get_nb_id(cpu));
-- 
1.7.9.3.362.g71319

