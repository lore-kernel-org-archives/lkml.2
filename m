Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758829Ab1COVE4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 17:04:56 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59483 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758771Ab1COVEu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 17:04:50 -0400
Date: Tue, 15 Mar 2011 22:04:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/microcode changes for v2.6.39
Message-ID: <20110315210430.GA8847@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-microcode-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-microcode-for-linus

 Thanks,

	Ingo

------------------>
Borislav Petkov (7):
      x86, microcode: Correct sysdev_add error path
      x86, microcode, AMD: Release firmware on error
      x86, microcode, AMD: Simplify install_equiv_cpu_table
      x86, microcode, AMD: Simplify get_next_ucode
      x86, microcode, AMD: Remove unneeded memset call
      x86, microcode, AMD: Cleanup dmesg output
      x86, microcode, AMD: Extend ucode size verification

Dan Carpenter (1):
      x86, microcode, AMD: Fix signedness bug in generic_load_microcode()


 arch/x86/kernel/microcode_amd.c  |  188 +++++++++++++++++++++-----------------
 arch/x86/kernel/microcode_core.c |    6 +-
 2 files changed, 109 insertions(+), 85 deletions(-)

diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index 0fe6d1a..c561038 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -66,7 +66,6 @@ struct microcode_amd {
 	unsigned int			mpb[0];
 };
 
-#define UCODE_MAX_SIZE			2048
 #define UCODE_CONTAINER_SECTION_HDR	8
 #define UCODE_CONTAINER_HEADER_SIZE	12
 
@@ -77,20 +76,20 @@ static int collect_cpu_info_amd(int cpu, struct cpu_signature *csig)
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
 	u32 dummy;
 
-	memset(csig, 0, sizeof(*csig));
 	if (c->x86_vendor != X86_VENDOR_AMD || c->x86 < 0x10) {
-		pr_warning("microcode: CPU%d: AMD CPU family 0x%x not "
-			   "supported\n", cpu, c->x86);
+		pr_warning("CPU%d: family %d not supported\n", cpu, c->x86);
 		return -1;
 	}
+
 	rdmsr(MSR_AMD64_PATCH_LEVEL, csig->rev, dummy);
-	pr_info("CPU%d: patch_level=0x%x\n", cpu, csig->rev);
+	pr_info("CPU%d: patch_level=0x%08x\n", cpu, csig->rev);
+
 	return 0;
 }
 
-static int get_matching_microcode(int cpu, void *mc, int rev)
+static int get_matching_microcode(int cpu, struct microcode_header_amd *mc_hdr,
+				  int rev)
 {
-	struct microcode_header_amd *mc_header = mc;
 	unsigned int current_cpu_id;
 	u16 equiv_cpu_id = 0;
 	unsigned int i = 0;
@@ -109,17 +108,17 @@ static int get_matching_microcode(int cpu, void *mc, int rev)
 	if (!equiv_cpu_id)
 		return 0;
 
-	if (mc_header->processor_rev_id != equiv_cpu_id)
+	if (mc_hdr->processor_rev_id != equiv_cpu_id)
 		return 0;
 
 	/* ucode might be chipset specific -- currently we don't support this */
-	if (mc_header->nb_dev_id || mc_header->sb_dev_id) {
-		pr_err("CPU%d: loading of chipset specific code not yet supported\n",
+	if (mc_hdr->nb_dev_id || mc_hdr->sb_dev_id) {
+		pr_err("CPU%d: chipset specific code not yet supported\n",
 		       cpu);
 		return 0;
 	}
 
-	if (mc_header->patch_id <= rev)
+	if (mc_hdr->patch_id <= rev)
 		return 0;
 
 	return 1;
@@ -144,71 +143,93 @@ static int apply_microcode_amd(int cpu)
 
 	/* check current patch id and patch's id for match */
 	if (rev != mc_amd->hdr.patch_id) {
-		pr_err("CPU%d: update failed (for patch_level=0x%x)\n",
+		pr_err("CPU%d: update failed for patch_level=0x%08x\n",
 		       cpu, mc_amd->hdr.patch_id);
 		return -1;
 	}
 
-	pr_info("CPU%d: updated (new patch_level=0x%x)\n", cpu, rev);
+	pr_info("CPU%d: new patch_level=0x%08x\n", cpu, rev);
 	uci->cpu_sig.rev = rev;
 
 	return 0;
 }
 
-static void *
-get_next_ucode(const u8 *buf, unsigned int size, unsigned int *mc_size)
+static unsigned int verify_ucode_size(int cpu, const u8 *buf, unsigned int size)
 {
-	unsigned int total_size;
-	u8 section_hdr[UCODE_CONTAINER_SECTION_HDR];
-	void *mc;
+	struct cpuinfo_x86 *c = &cpu_data(cpu);
+	unsigned int max_size, actual_size;
+
+#define F1XH_MPB_MAX_SIZE 2048
+#define F14H_MPB_MAX_SIZE 1824
+#define F15H_MPB_MAX_SIZE 4096
+
+	switch (c->x86) {
+	case 0x14:
+		max_size = F14H_MPB_MAX_SIZE;
+		break;
+	case 0x15:
+		max_size = F15H_MPB_MAX_SIZE;
+		break;
+	default:
+		max_size = F1XH_MPB_MAX_SIZE;
+		break;
+	}
 
-	get_ucode_data(section_hdr, buf, UCODE_CONTAINER_SECTION_HDR);
+	actual_size = buf[4] + (buf[5] << 8);
 
-	if (section_hdr[0] != UCODE_UCODE_TYPE) {
-		pr_err("error: invalid type field in container file section header\n");
-		return NULL;
+	if (actual_size > size || actual_size > max_size) {
+		pr_err("section size mismatch\n");
+		return 0;
 	}
 
-	total_size = (unsigned long) (section_hdr[4] + (section_hdr[5] << 8));
+	return actual_size;
+}
 
-	if (total_size > size || total_size > UCODE_MAX_SIZE) {
-		pr_err("error: size mismatch\n");
-		return NULL;
+static struct microcode_header_amd *
+get_next_ucode(int cpu, const u8 *buf, unsigned int size, unsigned int *mc_size)
+{
+	struct microcode_header_amd *mc = NULL;
+	unsigned int actual_size = 0;
+
+	if (buf[0] != UCODE_UCODE_TYPE) {
+		pr_err("invalid type field in container file section header\n");
+		goto out;
 	}
 
-	mc = vzalloc(UCODE_MAX_SIZE);
+	actual_size = verify_ucode_size(cpu, buf, size);
+	if (!actual_size)
+		goto out;
+
+	mc = vzalloc(actual_size);
 	if (!mc)
-		return NULL;
+		goto out;
 
-	get_ucode_data(mc, buf + UCODE_CONTAINER_SECTION_HDR, total_size);
-	*mc_size = total_size + UCODE_CONTAINER_SECTION_HDR;
+	get_ucode_data(mc, buf + UCODE_CONTAINER_SECTION_HDR, actual_size);
+	*mc_size = actual_size + UCODE_CONTAINER_SECTION_HDR;
 
+out:
 	return mc;
 }
 
 static int install_equiv_cpu_table(const u8 *buf)
 {
-	u8 *container_hdr[UCODE_CONTAINER_HEADER_SIZE];
-	unsigned int *buf_pos = (unsigned int *)container_hdr;
-	unsigned long size;
-
-	get_ucode_data(&container_hdr, buf, UCODE_CONTAINER_HEADER_SIZE);
-
-	size = buf_pos[2];
-
-	if (buf_pos[1] != UCODE_EQUIV_CPU_TABLE_TYPE || !size) {
-		pr_err("error: invalid type field in container file section header\n");
-		return 0;
+	unsigned int *ibuf = (unsigned int *)buf;
+	unsigned int type = ibuf[1];
+	unsigned int size = ibuf[2];
+
+	if (type != UCODE_EQUIV_CPU_TABLE_TYPE || !size) {
+		pr_err("empty section/"
+		       "invalid type field in container file section header\n");
+		return -EINVAL;
 	}
 
 	equiv_cpu_table = vmalloc(size);
 	if (!equiv_cpu_table) {
 		pr_err("failed to allocate equivalent CPU table\n");
-		return 0;
+		return -ENOMEM;
 	}
 
-	buf += UCODE_CONTAINER_HEADER_SIZE;
-	get_ucode_data(equiv_cpu_table, buf, size);
+	get_ucode_data(equiv_cpu_table, buf + UCODE_CONTAINER_HEADER_SIZE, size);
 
 	return size + UCODE_CONTAINER_HEADER_SIZE; /* add header length */
 }
@@ -223,16 +244,16 @@ static enum ucode_state
 generic_load_microcode(int cpu, const u8 *data, size_t size)
 {
 	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
+	struct microcode_header_amd *mc_hdr = NULL;
+	unsigned int mc_size, leftover;
+	int offset;
 	const u8 *ucode_ptr = data;
 	void *new_mc = NULL;
-	void *mc;
-	int new_rev = uci->cpu_sig.rev;
-	unsigned int leftover;
-	unsigned long offset;
+	unsigned int new_rev = uci->cpu_sig.rev;
 	enum ucode_state state = UCODE_OK;
 
 	offset = install_equiv_cpu_table(ucode_ptr);
-	if (!offset) {
+	if (offset < 0) {
 		pr_err("failed to create equivalent cpu table\n");
 		return UCODE_ERROR;
 	}
@@ -241,64 +262,65 @@ generic_load_microcode(int cpu, const u8 *data, size_t size)
 	leftover = size - offset;
 
 	while (leftover) {
-		unsigned int uninitialized_var(mc_size);
-		struct microcode_header_amd *mc_header;
-
-		mc = get_next_ucode(ucode_ptr, leftover, &mc_size);
-		if (!mc)
+		mc_hdr = get_next_ucode(cpu, ucode_ptr, leftover, &mc_size);
+		if (!mc_hdr)
 			break;
 
-		mc_header = (struct microcode_header_amd *)mc;
-		if (get_matching_microcode(cpu, mc, new_rev)) {
+		if (get_matching_microcode(cpu, mc_hdr, new_rev)) {
 			vfree(new_mc);
-			new_rev = mc_header->patch_id;
-			new_mc  = mc;
+			new_rev = mc_hdr->patch_id;
+			new_mc  = mc_hdr;
 		} else
-			vfree(mc);
+			vfree(mc_hdr);
 
 		ucode_ptr += mc_size;
 		leftover  -= mc_size;
 	}
 
-	if (new_mc) {
-		if (!leftover) {
-			vfree(uci->mc);
-			uci->mc = new_mc;
-			pr_debug("CPU%d found a matching microcode update with version 0x%x (current=0x%x)\n",
-				 cpu, new_rev, uci->cpu_sig.rev);
-		} else {
-			vfree(new_mc);
-			state = UCODE_ERROR;
-		}
-	} else
+	if (!new_mc) {
 		state = UCODE_NFOUND;
+		goto free_table;
+	}
 
+	if (!leftover) {
+		vfree(uci->mc);
+		uci->mc = new_mc;
+		pr_debug("CPU%d update ucode (0x%08x -> 0x%08x)\n",
+			 cpu, uci->cpu_sig.rev, new_rev);
+	} else {
+		vfree(new_mc);
+		state = UCODE_ERROR;
+	}
+
+free_table:
 	free_equiv_cpu_table();
 
 	return state;
 }
 
-static enum ucode_state request_microcode_fw(int cpu, struct device *device)
+static enum ucode_state request_microcode_amd(int cpu, struct device *device)
 {
 	const char *fw_name = "amd-ucode/microcode_amd.bin";
-	const struct firmware *firmware;
-	enum ucode_state ret;
+	const struct firmware *fw;
+	enum ucode_state ret = UCODE_NFOUND;
 
-	if (request_firmware(&firmware, fw_name, device)) {
-		printk(KERN_ERR "microcode: failed to load file %s\n", fw_name);
-		return UCODE_NFOUND;
+	if (request_firmware(&fw, fw_name, device)) {
+		pr_err("failed to load file %s\n", fw_name);
+		goto out;
 	}
 
-	if (*(u32 *)firmware->data != UCODE_MAGIC) {
-		pr_err("invalid UCODE_MAGIC (0x%08x)\n",
-		       *(u32 *)firmware->data);
-		return UCODE_ERROR;
+	ret = UCODE_ERROR;
+	if (*(u32 *)fw->data != UCODE_MAGIC) {
+		pr_err("invalid magic value (0x%08x)\n", *(u32 *)fw->data);
+		goto fw_release;
 	}
 
-	ret = generic_load_microcode(cpu, firmware->data, firmware->size);
+	ret = generic_load_microcode(cpu, fw->data, fw->size);
 
-	release_firmware(firmware);
+fw_release:
+	release_firmware(fw);
 
+out:
 	return ret;
 }
 
@@ -319,7 +341,7 @@ static void microcode_fini_cpu_amd(int cpu)
 
 static struct microcode_ops microcode_amd_ops = {
 	.request_microcode_user           = request_microcode_user,
-	.request_microcode_fw             = request_microcode_fw,
+	.request_microcode_fw             = request_microcode_amd,
 	.collect_cpu_info                 = collect_cpu_info_amd,
 	.apply_microcode                  = apply_microcode_amd,
 	.microcode_fini_cpu               = microcode_fini_cpu_amd,
diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
index 1cca374..87af68e 100644
--- a/arch/x86/kernel/microcode_core.c
+++ b/arch/x86/kernel/microcode_core.c
@@ -417,8 +417,10 @@ static int mc_sysdev_add(struct sys_device *sys_dev)
 	if (err)
 		return err;
 
-	if (microcode_init_cpu(cpu) == UCODE_ERROR)
-		err = -EINVAL;
+	if (microcode_init_cpu(cpu) == UCODE_ERROR) {
+		sysfs_remove_group(&sys_dev->kobj, &mc_attr_group);
+		return -EINVAL;
+	}
 
 	return err;
 }
