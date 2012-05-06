Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754343Ab2EFRvs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 13:51:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34827 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754172Ab2EFRvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 13:51:46 -0400
Date: Sun, 6 May 2012 10:51:00 -0700
Message-Id: <201205061751.q46Hp0Ao014533@terminus.zytor.com>
From: "H. Peter Anvin" <hpa@zytor.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86 fixes for v3.4-rc6
Cc: <stable@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Alan Cox <alan@linux.intel.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Bjarke Istrup Pedersen <gurligebis@gentoo.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "H.J. Lu" <hjl.tools@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Ingo Molnar <mingo@kernel.org>,
        Kangkai Yin <kangkai.yin@intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Kusanagi Kouichi <slash@ac.auone-net.jp>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg@redhat.com>,
        Philip Prindeville <philipp@redfish-solutions.com>,
        Pierre Tardy <pierre.tardy@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Yong Wang <yong.y.wang@intel.com>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 06 May 2012 10:51:05 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit ea0dcf903e7d76aa5d483d876215fedcfdfe140f:

  x86/apic: Use x2apic physical mode based on FADT setting (2012-04-25 12:47:08 +0200)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-urgent-for-linus

The head of this tree is 2be8e9ec677d6dfd4268b80e1ccd7d21777b86e3.

[ Note: this includes Al Viro's patch that I belive you picked up from
  email; that is the topmost commit and you can drop it.  The head without that
  commit is ab27a20e6212cd1d96d813352b47e1fc1cfd01db.]

Al Viro (1):
      x86, compat: Correct broken TASK_SIZE for ia32 a.out binaries

Andreas Herrmann (1):
      x86/amd: Re-enable CPU topology extensions in case BIOS has disabled it

Bjarke Istrup Pedersen (1):
      arch/x86/platform/geode/net5501.c: change active_low to 0 for LED driver

H. Peter Anvin (1):
      asm-generic: Use __BITS_PER_LONG in statfs.h

Kusanagi Kouichi (1):
      x86, relocs: Remove an unused variable

Yong Wang (1):
      intel_mid_powerbtn: mark irq as IRQF_NO_SUSPEND

 arch/x86/boot/compressed/relocs.c         |    2 --
 arch/x86/ia32/ia32_aout.c                 |    3 +--
 arch/x86/kernel/cpu/amd.c                 |   18 ++++++++++++++++++
 arch/x86/platform/geode/net5501.c         |    2 +-
 drivers/platform/x86/intel_mid_powerbtn.c |    2 +-
 include/asm-generic/statfs.h              |    2 +-
 6 files changed, 22 insertions(+), 7 deletions(-)

diff --git a/arch/x86/boot/compressed/relocs.c b/arch/x86/boot/compressed/relocs.c
index d3c0b02..fb7117a 100644
--- a/arch/x86/boot/compressed/relocs.c
+++ b/arch/x86/boot/compressed/relocs.c
@@ -403,13 +403,11 @@ static void print_absolute_symbols(void)
 	for (i = 0; i < ehdr.e_shnum; i++) {
 		struct section *sec = &secs[i];
 		char *sym_strtab;
-		Elf32_Sym *sh_symtab;
 		int j;
 
 		if (sec->shdr.sh_type != SHT_SYMTAB) {
 			continue;
 		}
-		sh_symtab = sec->symtab;
 		sym_strtab = sec->link->strtab;
 		for (j = 0; j < sec->shdr.sh_size/sizeof(Elf32_Sym); j++) {
 			Elf32_Sym *sym;
diff --git a/arch/x86/ia32/ia32_aout.c b/arch/x86/ia32/ia32_aout.c
index d511d95..4c979cf 100644
--- a/arch/x86/ia32/ia32_aout.c
+++ b/arch/x86/ia32/ia32_aout.c
@@ -296,8 +296,7 @@ static int load_aout_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 
 	/* OK, This is the point of no return */
 	set_personality(PER_LINUX);
-	set_thread_flag(TIF_IA32);
-	current->mm->context.ia32_compat = 1;
+	set_personality_ia32(false);
 
 	setup_new_exec(bprm);
 
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 1c67ca1..146bb62 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -580,6 +580,24 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 		}
 	}
 
+	/* re-enable TopologyExtensions if switched off by BIOS */
+	if ((c->x86 == 0x15) &&
+	    (c->x86_model >= 0x10) && (c->x86_model <= 0x1f) &&
+	    !cpu_has(c, X86_FEATURE_TOPOEXT)) {
+		u64 val;
+
+		if (!rdmsrl_amd_safe(0xc0011005, &val)) {
+			val |= 1ULL << 54;
+			wrmsrl_amd_safe(0xc0011005, val);
+			rdmsrl(0xc0011005, val);
+			if (val & (1ULL << 54)) {
+				set_cpu_cap(c, X86_FEATURE_TOPOEXT);
+				printk(KERN_INFO FW_INFO "CPU: Re-enabling "
+				  "disabled Topology Extensions Support\n");
+			}
+		}
+	}
+
 	cpu_detect_cache_sizes(c);
 
 	/* Multi core CPU? */
diff --git a/arch/x86/platform/geode/net5501.c b/arch/x86/platform/geode/net5501.c
index 66d377e..646e3b5 100644
--- a/arch/x86/platform/geode/net5501.c
+++ b/arch/x86/platform/geode/net5501.c
@@ -63,7 +63,7 @@ static struct gpio_led net5501_leds[] = {
 		.name = "net5501:1",
 		.gpio = 6,
 		.default_trigger = "default-on",
-		.active_low = 1,
+		.active_low = 0,
 	},
 };
 
diff --git a/drivers/platform/x86/intel_mid_powerbtn.c b/drivers/platform/x86/intel_mid_powerbtn.c
index 0a3594c..bcbad84 100644
--- a/drivers/platform/x86/intel_mid_powerbtn.c
+++ b/drivers/platform/x86/intel_mid_powerbtn.c
@@ -78,7 +78,7 @@ static int __devinit mfld_pb_probe(struct platform_device *pdev)
 
 	input_set_capability(input, EV_KEY, KEY_POWER);
 
-	error = request_threaded_irq(irq, NULL, mfld_pb_isr, 0,
+	error = request_threaded_irq(irq, NULL, mfld_pb_isr, IRQF_NO_SUSPEND,
 			DRIVER_NAME, input);
 	if (error) {
 		dev_err(&pdev->dev, "Unable to request irq %d for mfld power"
diff --git a/include/asm-generic/statfs.h b/include/asm-generic/statfs.h
index 0fd28e0..c749af9 100644
--- a/include/asm-generic/statfs.h
+++ b/include/asm-generic/statfs.h
@@ -15,7 +15,7 @@ typedef __kernel_fsid_t	fsid_t;
  * with a 10' pole.
  */
 #ifndef __statfs_word
-#if BITS_PER_LONG == 64
+#if __BITS_PER_LONG == 64
 #define __statfs_word long
 #else
 #define __statfs_word __u32
