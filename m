Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161995Ab2CSRVm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 13:21:42 -0400
Received: from mail-we0-f194.google.com ([74.125.82.194]:34569 "EHLO
	mail-we0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964832Ab2CSRVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 13:21:39 -0400
Date: Mon, 19 Mar 2012 18:21:34 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/urgent leftover fixes from v3.3, for v3.4
Message-ID: <20120319172134.GA16462@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-urgent-for-linus

   HEAD: c7b738351ba92f48b943ac59aff6b5b0f17f37c9 x86, efi: Fix pointer math issue in handle_ramdisks()

Pending x86/urgent bits that were not high prio enough to 
warrant -rc-less v3.3-final inclusion.

 Thanks,

	Ingo

------------------>
Dan Carpenter (1):
      x86, efi: Fix pointer math issue in handle_ramdisks()

Jiri Kosina (1):
      x86, memblock: Move mem_hole_size() to .init

Srivatsa S. Bhat (1):
      x86, mce: Fix rcu splat in drain_mce_log_buffer()

Suresh Siddha (1):
      x86/ioapic: Add register level checks to detect bogus io-apic entries


 arch/x86/boot/compressed/eboot.c |    8 +++---
 arch/x86/kernel/apic/io_apic.c   |   40 ++++++++++++++++++++++++++++++-------
 arch/x86/kernel/cpu/mcheck/mce.c |    2 +-
 arch/x86/mm/numa_emulation.c     |    2 +-
 4 files changed, 38 insertions(+), 14 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index fec216f..0cdfc0d 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -539,7 +539,7 @@ static efi_status_t handle_ramdisks(efi_loaded_image_t *image,
 		struct initrd *initrd;
 		efi_file_handle_t *h;
 		efi_file_info_t *info;
-		efi_char16_t filename[256];
+		efi_char16_t filename_16[256];
 		unsigned long info_sz;
 		efi_guid_t info_guid = EFI_FILE_INFO_ID;
 		efi_char16_t *p;
@@ -552,14 +552,14 @@ static efi_status_t handle_ramdisks(efi_loaded_image_t *image,
 		str += 7;
 
 		initrd = &initrds[i];
-		p = filename;
+		p = filename_16;
 
 		/* Skip any leading slashes */
 		while (*str == '/' || *str == '\\')
 			str++;
 
 		while (*str && *str != ' ' && *str != '\n') {
-			if (p >= filename + sizeof(filename))
+			if ((u8 *)p >= (u8 *)filename_16 + sizeof(filename_16))
 				break;
 
 			*p++ = *str++;
@@ -583,7 +583,7 @@ static efi_status_t handle_ramdisks(efi_loaded_image_t *image,
 				goto free_initrds;
 		}
 
-		status = efi_call_phys5(fh->open, fh, &h, filename,
+		status = efi_call_phys5(fh->open, fh, &h, filename_16,
 					EFI_FILE_MODE_READ, (u64)0);
 		if (status != EFI_SUCCESS)
 			goto close_handles;
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index fb07275..6d10a66 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3967,18 +3967,36 @@ int mp_find_ioapic_pin(int ioapic, u32 gsi)
 static __init int bad_ioapic(unsigned long address)
 {
 	if (nr_ioapics >= MAX_IO_APICS) {
-		printk(KERN_WARNING "WARNING: Max # of I/O APICs (%d) exceeded "
-		       "(found %d), skipping\n", MAX_IO_APICS, nr_ioapics);
+		pr_warn("WARNING: Max # of I/O APICs (%d) exceeded (found %d), skipping\n",
+			MAX_IO_APICS, nr_ioapics);
 		return 1;
 	}
 	if (!address) {
-		printk(KERN_WARNING "WARNING: Bogus (zero) I/O APIC address"
-		       " found in table, skipping!\n");
+		pr_warn("WARNING: Bogus (zero) I/O APIC address found in table, skipping!\n");
 		return 1;
 	}
 	return 0;
 }
 
+static __init int bad_ioapic_register(int idx)
+{
+	union IO_APIC_reg_00 reg_00;
+	union IO_APIC_reg_01 reg_01;
+	union IO_APIC_reg_02 reg_02;
+
+	reg_00.raw = io_apic_read(idx, 0);
+	reg_01.raw = io_apic_read(idx, 1);
+	reg_02.raw = io_apic_read(idx, 2);
+
+	if (reg_00.raw == -1 && reg_01.raw == -1 && reg_02.raw == -1) {
+		pr_warn("I/O APIC 0x%x registers return all ones, skipping!\n",
+			mpc_ioapic_addr(idx));
+		return 1;
+	}
+
+	return 0;
+}
+
 void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
 {
 	int idx = 0;
@@ -3995,6 +4013,12 @@ void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
 	ioapics[idx].mp_config.apicaddr = address;
 
 	set_fixmap_nocache(FIX_IO_APIC_BASE_0 + idx, address);
+
+	if (bad_ioapic_register(idx)) {
+		clear_fixmap(FIX_IO_APIC_BASE_0 + idx);
+		return;
+	}
+
 	ioapics[idx].mp_config.apicid = io_apic_unique_id(id);
 	ioapics[idx].mp_config.apicver = io_apic_get_version(idx);
 
@@ -4015,10 +4039,10 @@ void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
 	if (gsi_cfg->gsi_end >= gsi_top)
 		gsi_top = gsi_cfg->gsi_end + 1;
 
-	printk(KERN_INFO "IOAPIC[%d]: apic_id %d, version %d, address 0x%x, "
-	       "GSI %d-%d\n", idx, mpc_ioapic_id(idx),
-	       mpc_ioapic_ver(idx), mpc_ioapic_addr(idx),
-	       gsi_cfg->gsi_base, gsi_cfg->gsi_end);
+	pr_info("IOAPIC[%d]: apic_id %d, version %d, address 0x%x, GSI %d-%d\n",
+		idx, mpc_ioapic_id(idx),
+		mpc_ioapic_ver(idx), mpc_ioapic_addr(idx),
+		gsi_cfg->gsi_base, gsi_cfg->gsi_end);
 
 	nr_ioapics++;
 }
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 5a11ae2..db590af 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -191,7 +191,7 @@ static void drain_mcelog_buffer(void)
 {
 	unsigned int next, i, prev = 0;
 
-	next = rcu_dereference_check_mce(mcelog.next);
+	next = ACCESS_ONCE(mcelog.next);
 
 	do {
 		struct mce *m;
diff --git a/arch/x86/mm/numa_emulation.c b/arch/x86/mm/numa_emulation.c
index 46db568..2fff651 100644
--- a/arch/x86/mm/numa_emulation.c
+++ b/arch/x86/mm/numa_emulation.c
@@ -28,7 +28,7 @@ static int __init emu_find_memblk_by_nid(int nid, const struct numa_meminfo *mi)
 	return -ENOENT;
 }
 
-static u64 mem_hole_size(u64 start, u64 end)
+static u64 __init mem_hole_size(u64 start, u64 end)
 {
 	unsigned long start_pfn = PFN_UP(start);
 	unsigned long end_pfn = PFN_DOWN(end);
