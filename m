Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176Ab2JAOYr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 10:24:47 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:41673 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976Ab2JAOYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 10:24:45 -0400
Date: Mon, 1 Oct 2012 16:24:39 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>
Subject: [GIT PULL] x86/microcode changes for v3.7
Message-ID: <20121001142439.GA24959@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-microcode-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-microcode-for-linus

   HEAD: bd13178169d5fd17da3221b55ba313270393649a Merge tag 'microcode_fix_3.7' of git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp into x86/microcode

The biggest changes are to AMD microcode patching: add code for 
caching all microcode patches which belong to the current family 
on which we're running, in the kernel. We look up the patch 
needed for each core from the cache at patch-application time 
instead of holding a single patch per-system.

 Thanks,

	Ingo

------------------>
Borislav Petkov (11):
      x86, microcode: Save an indentation level in reload_for_cpu
      x86, microcode: Drop uci->mc check on resume path
      x86, microcode: Cleanup cpu hotplug notifier callback
      x86, microcode: Straighten out Kconfig text
      x86, microcode, AMD: Remove useless get_ucode_data wrapper
      x86, microcode, AMD: Check before applying a patch
      x86, microcode, AMD: Read CPUID(1).EAX on the correct cpu
      x86, microcode: Add a refresh firmware flag to ->request_microcode_fw
      x86, microcode, AMD: Add reverse equiv table search
      x86, microcode, AMD: Add a small, per-family patches cache
      x86, microcode, AMD: Rewrite patch application procedure

Dan Carpenter (1):
      x86, microcode, AMD: Fix use after free in free_cache()


 arch/x86/Kconfig                  |  20 +--
 arch/x86/include/asm/microcode.h  |  10 +-
 arch/x86/kernel/microcode_amd.c   | 357 ++++++++++++++++++++++++--------------
 arch/x86/kernel/microcode_core.c  |  67 +++----
 arch/x86/kernel/microcode_intel.c |   3 +-
 5 files changed, 273 insertions(+), 184 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 8ec3a1a..1ccccc6 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -982,25 +982,25 @@ config X86_REBOOTFIXUPS
 	  Say N otherwise.
 
 config MICROCODE
-	tristate "/dev/cpu/microcode - microcode support"
+	tristate "CPU microcode loading support"
 	select FW_LOADER
 	---help---
+
 	  If you say Y here, you will be able to update the microcode on
 	  certain Intel and AMD processors. The Intel support is for the
-	  IA32 family, e.g. Pentium Pro, Pentium II, Pentium III,
-	  Pentium 4, Xeon etc. The AMD support is for family 0x10 and
-	  0x11 processors, e.g. Opteron, Phenom and Turion 64 Ultra.
-	  You will obviously need the actual microcode binary data itself
-	  which is not shipped with the Linux kernel.
+	  IA32 family, e.g. Pentium Pro, Pentium II, Pentium III, Pentium 4,
+	  Xeon etc. The AMD support is for families 0x10 and later. You will
+	  obviously need the actual microcode binary data itself which is not
+	  shipped with the Linux kernel.
 
 	  This option selects the general module only, you need to select
 	  at least one vendor specific module as well.
 
-	  To compile this driver as a module, choose M here: the
-	  module will be called microcode.
+	  To compile this driver as a module, choose M here: the module
+	  will be called microcode.
 
 config MICROCODE_INTEL
-	bool "Intel microcode patch loading support"
+	bool "Intel microcode loading support"
 	depends on MICROCODE
 	default MICROCODE
 	select FW_LOADER
@@ -1013,7 +1013,7 @@ config MICROCODE_INTEL
 	  <http://www.urbanmyth.org/microcode/>.
 
 config MICROCODE_AMD
-	bool "AMD microcode patch loading support"
+	bool "AMD microcode loading support"
 	depends on MICROCODE
 	select FW_LOADER
 	---help---
diff --git a/arch/x86/include/asm/microcode.h b/arch/x86/include/asm/microcode.h
index 4ebe157..43d921b 100644
--- a/arch/x86/include/asm/microcode.h
+++ b/arch/x86/include/asm/microcode.h
@@ -15,8 +15,8 @@ struct microcode_ops {
 	enum ucode_state (*request_microcode_user) (int cpu,
 				const void __user *buf, size_t size);
 
-	enum ucode_state (*request_microcode_fw) (int cpu,
-				struct device *device);
+	enum ucode_state (*request_microcode_fw) (int cpu, struct device *,
+						  bool refresh_fw);
 
 	void (*microcode_fini_cpu) (int cpu);
 
@@ -49,12 +49,6 @@ static inline struct microcode_ops * __init init_intel_microcode(void)
 #ifdef CONFIG_MICROCODE_AMD
 extern struct microcode_ops * __init init_amd_microcode(void);
 extern void __exit exit_amd_microcode(void);
-
-static inline void get_ucode_data(void *to, const u8 *from, size_t n)
-{
-	memcpy(to, from, n);
-}
-
 #else
 static inline struct microcode_ops * __init init_amd_microcode(void)
 {
diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index 82746f9..7720ff5 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -75,20 +75,113 @@ struct microcode_amd {
 
 static struct equiv_cpu_entry *equiv_cpu_table;
 
-/* page-sized ucode patch buffer */
-void *patch;
+struct ucode_patch {
+	struct list_head plist;
+	void *data;
+	u32 patch_id;
+	u16 equiv_cpu;
+};
+
+static LIST_HEAD(pcache);
+
+static u16 find_equiv_id(unsigned int cpu)
+{
+	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
+	int i = 0;
+
+	if (!equiv_cpu_table)
+		return 0;
+
+	while (equiv_cpu_table[i].installed_cpu != 0) {
+		if (uci->cpu_sig.sig == equiv_cpu_table[i].installed_cpu)
+			return equiv_cpu_table[i].equiv_cpu;
+
+		i++;
+	}
+	return 0;
+}
+
+static u32 find_cpu_family_by_equiv_cpu(u16 equiv_cpu)
+{
+	int i = 0;
+
+	BUG_ON(!equiv_cpu_table);
+
+	while (equiv_cpu_table[i].equiv_cpu != 0) {
+		if (equiv_cpu == equiv_cpu_table[i].equiv_cpu)
+			return equiv_cpu_table[i].installed_cpu;
+		i++;
+	}
+	return 0;
+}
+
+/*
+ * a small, trivial cache of per-family ucode patches
+ */
+static struct ucode_patch *cache_find_patch(u16 equiv_cpu)
+{
+	struct ucode_patch *p;
+
+	list_for_each_entry(p, &pcache, plist)
+		if (p->equiv_cpu == equiv_cpu)
+			return p;
+	return NULL;
+}
+
+static void update_cache(struct ucode_patch *new_patch)
+{
+	struct ucode_patch *p;
+
+	list_for_each_entry(p, &pcache, plist) {
+		if (p->equiv_cpu == new_patch->equiv_cpu) {
+			if (p->patch_id >= new_patch->patch_id)
+				/* we already have the latest patch */
+				return;
+
+			list_replace(&p->plist, &new_patch->plist);
+			kfree(p->data);
+			kfree(p);
+			return;
+		}
+	}
+	/* no patch found, add it */
+	list_add_tail(&new_patch->plist, &pcache);
+}
+
+static void free_cache(void)
+{
+	struct ucode_patch *p, *tmp;
+
+	list_for_each_entry_safe(p, tmp, &pcache, plist) {
+		__list_del(p->plist.prev, p->plist.next);
+		kfree(p->data);
+		kfree(p);
+	}
+}
+
+static struct ucode_patch *find_patch(unsigned int cpu)
+{
+	u16 equiv_id;
+
+	equiv_id = find_equiv_id(cpu);
+	if (!equiv_id)
+		return NULL;
+
+	return cache_find_patch(equiv_id);
+}
 
 static int collect_cpu_info_amd(int cpu, struct cpu_signature *csig)
 {
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
 
+	csig->sig = cpuid_eax(0x00000001);
 	csig->rev = c->microcode;
 	pr_info("CPU%d: patch_level=0x%08x\n", cpu, csig->rev);
 
 	return 0;
 }
 
-static unsigned int verify_ucode_size(int cpu, u32 patch_size,
+static unsigned int verify_patch_size(int cpu, u32 patch_size,
 				      unsigned int size)
 {
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
@@ -118,95 +211,37 @@ static unsigned int verify_ucode_size(int cpu, u32 patch_size,
 	return patch_size;
 }
 
-static u16 find_equiv_id(void)
+static int apply_microcode_amd(int cpu)
 {
-	unsigned int current_cpu_id, i = 0;
-
-	BUG_ON(equiv_cpu_table == NULL);
-
-	current_cpu_id = cpuid_eax(0x00000001);
-
-	while (equiv_cpu_table[i].installed_cpu != 0) {
-		if (current_cpu_id == equiv_cpu_table[i].installed_cpu)
-			return equiv_cpu_table[i].equiv_cpu;
-
-		i++;
-	}
-	return 0;
-}
+	struct cpuinfo_x86 *c = &cpu_data(cpu);
+	struct microcode_amd *mc_amd;
+	struct ucode_cpu_info *uci;
+	struct ucode_patch *p;
+	u32 rev, dummy;
 
-/*
- * we signal a good patch is found by returning its size > 0
- */
-static int get_matching_microcode(int cpu, const u8 *ucode_ptr,
-				  unsigned int leftover_size, int rev,
-				  unsigned int *current_size)
-{
-	struct microcode_header_amd *mc_hdr;
-	unsigned int actual_size, patch_size;
-	u16 equiv_cpu_id;
+	BUG_ON(raw_smp_processor_id() != cpu);
 
-	/* size of the current patch we're staring at */
-	patch_size = *(u32 *)(ucode_ptr + 4);
-	*current_size = patch_size + SECTION_HDR_SIZE;
+	uci = ucode_cpu_info + cpu;
 
-	equiv_cpu_id = find_equiv_id();
-	if (!equiv_cpu_id)
+	p = find_patch(cpu);
+	if (!p)
 		return 0;
 
-	/*
-	 * let's look at the patch header itself now
-	 */
-	mc_hdr = (struct microcode_header_amd *)(ucode_ptr + SECTION_HDR_SIZE);
+	mc_amd  = p->data;
+	uci->mc = p->data;
 
-	if (mc_hdr->processor_rev_id != equiv_cpu_id)
-		return 0;
+	rdmsr(MSR_AMD64_PATCH_LEVEL, rev, dummy);
 
-	/* ucode might be chipset specific -- currently we don't support this */
-	if (mc_hdr->nb_dev_id || mc_hdr->sb_dev_id) {
-		pr_err("CPU%d: chipset specific code not yet supported\n",
-		       cpu);
+	/* need to apply patch? */
+	if (rev >= mc_amd->hdr.patch_id) {
+		c->microcode = rev;
 		return 0;
 	}
 
-	if (mc_hdr->patch_id <= rev)
-		return 0;
-
-	/*
-	 * now that the header looks sane, verify its size
-	 */
-	actual_size = verify_ucode_size(cpu, patch_size, leftover_size);
-	if (!actual_size)
-		return 0;
-
-	/* clear the patch buffer */
-	memset(patch, 0, PAGE_SIZE);
-
-	/* all looks ok, get the binary patch */
-	get_ucode_data(patch, ucode_ptr + SECTION_HDR_SIZE, actual_size);
-
-	return actual_size;
-}
-
-static int apply_microcode_amd(int cpu)
-{
-	u32 rev, dummy;
-	int cpu_num = raw_smp_processor_id();
-	struct ucode_cpu_info *uci = ucode_cpu_info + cpu_num;
-	struct microcode_amd *mc_amd = uci->mc;
-	struct cpuinfo_x86 *c = &cpu_data(cpu);
-
-	/* We should bind the task to the CPU */
-	BUG_ON(cpu_num != cpu);
-
-	if (mc_amd == NULL)
-		return 0;
-
 	wrmsrl(MSR_AMD64_PATCH_LOADER, (u64)(long)&mc_amd->hdr.data_code);
-	/* get patch id after patching */
-	rdmsr(MSR_AMD64_PATCH_LEVEL, rev, dummy);
 
-	/* check current patch id and patch's id for match */
+	/* verify patch application was successful */
+	rdmsr(MSR_AMD64_PATCH_LEVEL, rev, dummy);
 	if (rev != mc_amd->hdr.patch_id) {
 		pr_err("CPU%d: update failed for patch_level=0x%08x\n",
 		       cpu, mc_amd->hdr.patch_id);
@@ -238,7 +273,7 @@ static int install_equiv_cpu_table(const u8 *buf)
 		return -ENOMEM;
 	}
 
-	get_ucode_data(equiv_cpu_table, buf + CONTAINER_HDR_SZ, size);
+	memcpy(equiv_cpu_table, buf + CONTAINER_HDR_SZ, size);
 
 	/* add header length */
 	return size + CONTAINER_HDR_SZ;
@@ -250,61 +285,113 @@ static void free_equiv_cpu_table(void)
 	equiv_cpu_table = NULL;
 }
 
-static enum ucode_state
-generic_load_microcode(int cpu, const u8 *data, size_t size)
+static void cleanup(void)
 {
-	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
-	struct microcode_header_amd *mc_hdr = NULL;
-	unsigned int mc_size, leftover, current_size = 0;
+	free_equiv_cpu_table();
+	free_cache();
+}
+
+/*
+ * We return the current size even if some of the checks failed so that
+ * we can skip over the next patch. If we return a negative value, we
+ * signal a grave error like a memory allocation has failed and the
+ * driver cannot continue functioning normally. In such cases, we tear
+ * down everything we've used up so far and exit.
+ */
+static int verify_and_add_patch(unsigned int cpu, u8 *fw, unsigned int leftover)
+{
+	struct cpuinfo_x86 *c = &cpu_data(cpu);
+	struct microcode_header_amd *mc_hdr;
+	struct ucode_patch *patch;
+	unsigned int patch_size, crnt_size, ret;
+	u32 proc_fam;
+	u16 proc_id;
+
+	patch_size  = *(u32 *)(fw + 4);
+	crnt_size   = patch_size + SECTION_HDR_SIZE;
+	mc_hdr	    = (struct microcode_header_amd *)(fw + SECTION_HDR_SIZE);
+	proc_id	    = mc_hdr->processor_rev_id;
+
+	proc_fam = find_cpu_family_by_equiv_cpu(proc_id);
+	if (!proc_fam) {
+		pr_err("No patch family for equiv ID: 0x%04x\n", proc_id);
+		return crnt_size;
+	}
+
+	/* check if patch is for the current family */
+	proc_fam = ((proc_fam >> 8) & 0xf) + ((proc_fam >> 20) & 0xff);
+	if (proc_fam != c->x86)
+		return crnt_size;
+
+	if (mc_hdr->nb_dev_id || mc_hdr->sb_dev_id) {
+		pr_err("Patch-ID 0x%08x: chipset-specific code unsupported.\n",
+			mc_hdr->patch_id);
+		return crnt_size;
+	}
+
+	ret = verify_patch_size(cpu, patch_size, leftover);
+	if (!ret) {
+		pr_err("Patch-ID 0x%08x: size mismatch.\n", mc_hdr->patch_id);
+		return crnt_size;
+	}
+
+	patch = kzalloc(sizeof(*patch), GFP_KERNEL);
+	if (!patch) {
+		pr_err("Patch allocation failure.\n");
+		return -EINVAL;
+	}
+
+	patch->data = kzalloc(patch_size, GFP_KERNEL);
+	if (!patch->data) {
+		pr_err("Patch data allocation failure.\n");
+		kfree(patch);
+		return -EINVAL;
+	}
+
+	/* All looks ok, copy patch... */
+	memcpy(patch->data, fw + SECTION_HDR_SIZE, patch_size);
+	INIT_LIST_HEAD(&patch->plist);
+	patch->patch_id  = mc_hdr->patch_id;
+	patch->equiv_cpu = proc_id;
+
+	/* ... and add to cache. */
+	update_cache(patch);
+
+	return crnt_size;
+}
+
+static enum ucode_state load_microcode_amd(int cpu, const u8 *data, size_t size)
+{
+	enum ucode_state ret = UCODE_ERROR;
+	unsigned int leftover;
+	u8 *fw = (u8 *)data;
+	int crnt_size = 0;
 	int offset;
-	const u8 *ucode_ptr = data;
-	void *new_mc = NULL;
-	unsigned int new_rev = uci->cpu_sig.rev;
-	enum ucode_state state = UCODE_ERROR;
 
-	offset = install_equiv_cpu_table(ucode_ptr);
+	offset = install_equiv_cpu_table(data);
 	if (offset < 0) {
 		pr_err("failed to create equivalent cpu table\n");
-		goto out;
+		return ret;
 	}
-	ucode_ptr += offset;
+	fw += offset;
 	leftover = size - offset;
 
-	if (*(u32 *)ucode_ptr != UCODE_UCODE_TYPE) {
+	if (*(u32 *)fw != UCODE_UCODE_TYPE) {
 		pr_err("invalid type field in container file section header\n");
-		goto free_table;
+		free_equiv_cpu_table();
+		return ret;
 	}
 
 	while (leftover) {
-		mc_size = get_matching_microcode(cpu, ucode_ptr, leftover,
-						 new_rev, &current_size);
-		if (mc_size) {
-			mc_hdr  = patch;
-			new_mc  = patch;
-			new_rev = mc_hdr->patch_id;
-			goto out_ok;
-		}
-
-		ucode_ptr += current_size;
-		leftover  -= current_size;
-	}
+		crnt_size = verify_and_add_patch(cpu, fw, leftover);
+		if (crnt_size < 0)
+			return ret;
 
-	if (!new_mc) {
-		state = UCODE_NFOUND;
-		goto free_table;
+		fw	 += crnt_size;
+		leftover -= crnt_size;
 	}
 
-out_ok:
-	uci->mc = new_mc;
-	state = UCODE_OK;
-	pr_debug("CPU%d update ucode (0x%08x -> 0x%08x)\n",
-		 cpu, uci->cpu_sig.rev, new_rev);
-
-free_table:
-	free_equiv_cpu_table();
-
-out:
-	return state;
+	return UCODE_OK;
 }
 
 /*
@@ -315,7 +402,7 @@ out:
  *
  * This legacy file is always smaller than 2K in size.
  *
- * Starting at family 15h they are in family specific firmware files:
+ * Beginning with family 15h, they are in family-specific firmware files:
  *
  *    amd-ucode/microcode_amd_fam15h.bin
  *    amd-ucode/microcode_amd_fam16h.bin
@@ -323,12 +410,17 @@ out:
  *
  * These might be larger than 2K.
  */
-static enum ucode_state request_microcode_amd(int cpu, struct device *device)
+static enum ucode_state request_microcode_amd(int cpu, struct device *device,
+					      bool refresh_fw)
 {
 	char fw_name[36] = "amd-ucode/microcode_amd.bin";
-	const struct firmware *fw;
-	enum ucode_state ret = UCODE_NFOUND;
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
+	enum ucode_state ret = UCODE_NFOUND;
+	const struct firmware *fw;
+
+	/* reload ucode container only on the boot cpu */
+	if (!refresh_fw || c->cpu_index != boot_cpu_data.cpu_index)
+		return UCODE_OK;
 
 	if (c->x86 >= 0x15)
 		snprintf(fw_name, sizeof(fw_name), "amd-ucode/microcode_amd_fam%.2xh.bin", c->x86);
@@ -344,12 +436,17 @@ static enum ucode_state request_microcode_amd(int cpu, struct device *device)
 		goto fw_release;
 	}
 
-	ret = generic_load_microcode(cpu, fw->data, fw->size);
+	/* free old equiv table */
+	free_equiv_cpu_table();
+
+	ret = load_microcode_amd(cpu, fw->data, fw->size);
+	if (ret != UCODE_OK)
+		cleanup();
 
-fw_release:
+ fw_release:
 	release_firmware(fw);
 
-out:
+ out:
 	return ret;
 }
 
@@ -383,14 +480,10 @@ struct microcode_ops * __init init_amd_microcode(void)
 		return NULL;
 	}
 
-	patch = (void *)get_zeroed_page(GFP_KERNEL);
-	if (!patch)
-		return NULL;
-
 	return &microcode_amd_ops;
 }
 
 void __exit exit_amd_microcode(void)
 {
-	free_page((unsigned long)patch);
+	cleanup();
 }
diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
index 4873e62..9420972 100644
--- a/arch/x86/kernel/microcode_core.c
+++ b/arch/x86/kernel/microcode_core.c
@@ -276,19 +276,18 @@ static struct platform_device	*microcode_pdev;
 static int reload_for_cpu(int cpu)
 {
 	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
+	enum ucode_state ustate;
 	int err = 0;
 
-	if (uci->valid) {
-		enum ucode_state ustate;
-
-		ustate = microcode_ops->request_microcode_fw(cpu, &microcode_pdev->dev);
-		if (ustate == UCODE_OK)
-			apply_microcode_on_target(cpu);
-		else
-			if (ustate == UCODE_ERROR)
-				err = -EINVAL;
-	}
+	if (!uci->valid)
+		return err;
 
+	ustate = microcode_ops->request_microcode_fw(cpu, &microcode_pdev->dev, true);
+	if (ustate == UCODE_OK)
+		apply_microcode_on_target(cpu);
+	else
+		if (ustate == UCODE_ERROR)
+			err = -EINVAL;
 	return err;
 }
 
@@ -370,18 +369,15 @@ static void microcode_fini_cpu(int cpu)
 
 static enum ucode_state microcode_resume_cpu(int cpu)
 {
-	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
-
-	if (!uci->mc)
-		return UCODE_NFOUND;
-
 	pr_debug("CPU%d updated upon resume\n", cpu);
-	apply_microcode_on_target(cpu);
+
+	if (apply_microcode_on_target(cpu))
+		return UCODE_ERROR;
 
 	return UCODE_OK;
 }
 
-static enum ucode_state microcode_init_cpu(int cpu)
+static enum ucode_state microcode_init_cpu(int cpu, bool refresh_fw)
 {
 	enum ucode_state ustate;
 
@@ -392,7 +388,8 @@ static enum ucode_state microcode_init_cpu(int cpu)
 	if (system_state != SYSTEM_RUNNING)
 		return UCODE_NFOUND;
 
-	ustate = microcode_ops->request_microcode_fw(cpu, &microcode_pdev->dev);
+	ustate = microcode_ops->request_microcode_fw(cpu, &microcode_pdev->dev,
+						     refresh_fw);
 
 	if (ustate == UCODE_OK) {
 		pr_debug("CPU%d updated upon init\n", cpu);
@@ -405,14 +402,11 @@ static enum ucode_state microcode_init_cpu(int cpu)
 static enum ucode_state microcode_update_cpu(int cpu)
 {
 	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
-	enum ucode_state ustate;
 
 	if (uci->valid)
-		ustate = microcode_resume_cpu(cpu);
-	else
-		ustate = microcode_init_cpu(cpu);
+		return microcode_resume_cpu(cpu);
 
-	return ustate;
+	return microcode_init_cpu(cpu, false);
 }
 
 static int mc_device_add(struct device *dev, struct subsys_interface *sif)
@@ -428,7 +422,7 @@ static int mc_device_add(struct device *dev, struct subsys_interface *sif)
 	if (err)
 		return err;
 
-	if (microcode_init_cpu(cpu) == UCODE_ERROR)
+	if (microcode_init_cpu(cpu, true) == UCODE_ERROR)
 		return -EINVAL;
 
 	return err;
@@ -477,34 +471,41 @@ mc_cpu_callback(struct notifier_block *nb, unsigned long action, void *hcpu)
 	struct device *dev;
 
 	dev = get_cpu_device(cpu);
-	switch (action) {
+
+	switch (action & ~CPU_TASKS_FROZEN) {
 	case CPU_ONLINE:
-	case CPU_ONLINE_FROZEN:
 		microcode_update_cpu(cpu);
-	case CPU_DOWN_FAILED:
-	case CPU_DOWN_FAILED_FROZEN:
 		pr_debug("CPU%d added\n", cpu);
+		/*
+		 * "break" is missing on purpose here because we want to fall
+		 * through in order to create the sysfs group.
+		 */
+
+	case CPU_DOWN_FAILED:
 		if (sysfs_create_group(&dev->kobj, &mc_attr_group))
 			pr_err("Failed to create group for CPU%d\n", cpu);
 		break;
+
 	case CPU_DOWN_PREPARE:
-	case CPU_DOWN_PREPARE_FROZEN:
 		/* Suspend is in progress, only remove the interface */
 		sysfs_remove_group(&dev->kobj, &mc_attr_group);
 		pr_debug("CPU%d removed\n", cpu);
 		break;
 
 	/*
+	 * case CPU_DEAD:
+	 *
 	 * When a CPU goes offline, don't free up or invalidate the copy of
 	 * the microcode in kernel memory, so that we can reuse it when the
 	 * CPU comes back online without unnecessarily requesting the userspace
 	 * for it again.
 	 */
-	case CPU_UP_CANCELED_FROZEN:
-		/* The CPU refused to come up during a system resume */
-		microcode_fini_cpu(cpu);
-		break;
 	}
+
+	/* The CPU refused to come up during a system resume */
+	if (action == CPU_UP_CANCELED_FROZEN)
+		microcode_fini_cpu(cpu);
+
 	return NOTIFY_OK;
 }
 
diff --git a/arch/x86/kernel/microcode_intel.c b/arch/x86/kernel/microcode_intel.c
index 0327e2b..3544aed 100644
--- a/arch/x86/kernel/microcode_intel.c
+++ b/arch/x86/kernel/microcode_intel.c
@@ -405,7 +405,8 @@ static int get_ucode_fw(void *to, const void *from, size_t n)
 	return 0;
 }
 
-static enum ucode_state request_microcode_fw(int cpu, struct device *device)
+static enum ucode_state request_microcode_fw(int cpu, struct device *device,
+					     bool refresh_fw)
 {
 	char name[30];
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
