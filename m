Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752237Ab0J2Ekz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 00:40:55 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:38075 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148Ab0J2Eks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 00:40:48 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.5.1
Message-ID: <4CCA50AF.1030302@np.css.fujitsu.com>
Date: Fri, 29 Oct 2010 13:42:23 +0900
From: Jin Dongming <jin.dongming@np.css.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; ja; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, "H.Peter Anvin" <hpa@zytor.com>,
        Andi Kleen <andi@firstfloor.org>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        LKLM <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] [x86, next] Add mce_sys_info interface for debug.
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add mce_sys_info interface for testing mce.

Following is the reason why the interface is needed:
  1. Sometimes before testing mce, we want to know the basic
     information of mce on the test machine. Though there are
     some provided interfaces, there are some kernel variables
     which could not be known still.
  2. When we inject mce data to test mce, the value of some
     interfaces may be changed. It is hard for everybody to confirm
     all the information of mce on the system.

This interface could help us know what has happened and make mce test
become easier.

The content of mce_sys_info will be like following:

  MCE status:                      Original/(Current) Value
      mce_disabled:                N

      mce_ser:                     0/1
      tolerant:                    1/1
      panic_on_oops:               0/0
      monarch_timeout:             1000000/1000000 us
      mce_ignore_ce:               0/0
      mce_cmci_disabled:           N/N

  MCG Register:
      CAP_Reg_Val           BANKS    EXT_CNT    FUNCTIONS
      0x0000000000000806    0x06     0x00       TES

Please note that it is used for testing only.

I tested this patch on Intel64 next-tree.

Signe-off-by: Jin Dongming <jin.dongming@np.css.fujitsu.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |  126 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 126 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index ed10e76..91108db 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -97,6 +97,25 @@ static DECLARE_WAIT_QUEUE_HEAD(mce_wait);
 static DEFINE_PER_CPU(struct mce, mces_seen);
 static int			cpu_missing;
 
+#ifdef CONFIG_DEBUG_FS
+struct mce_sys_info {
+	int mce_disabled;
+
+	u64 mcg_cap_register;
+
+	int mce_ser;
+	int tolerant;
+	int panic_on_oops;
+	int monarch_timeout;
+	int mce_cmci_disable;
+	int mce_ignore_ce;
+	int mce_cmci_disabled;
+};
+
+static struct mce_sys_info mce_sys_infos;
+
+static void mce_sys_infos_init(void);
+#endif
 /*
  * CPU/chipset specific EDAC code can register a notifier call here to print
  * MCE errors in a human-readable form.
@@ -1453,6 +1472,10 @@ void __cpuinit mcheck_cpu_init(struct cpuinfo_x86 *c)
 	__mcheck_cpu_init_timer();
 	INIT_WORK(&__get_cpu_var(mce_work), mce_process_work);
 
+#ifdef CONFIG_DEBUG_FS
+	mce_sys_infos_init();
+#endif
+
 }
 
 /*
@@ -2224,14 +2247,112 @@ static int mce_ser_set(void *data, u64 val)
 DEFINE_SIMPLE_ATTRIBUTE(mce_ser_fops, mce_ser_get,
 			mce_ser_set, "%llu\n");
 
+static void mce_sys_infos_init(void)
+{
+	static int info_init = 0;
+
+	mce_sys_infos.mce_disabled = mce_disabled;
+
+	if (!mce_disabled && !info_init) {
+		u64 cap;
+
+		info_init++;
+		rdmsrl(MSR_IA32_MCG_CAP, cap);
+		mce_sys_infos.mcg_cap_register	= cap;
+
+		mce_sys_infos.mce_ser		= mce_ser;
+		mce_sys_infos.tolerant		= tolerant;
+		mce_sys_infos.panic_on_oops	= panic_on_oops;
+		mce_sys_infos.monarch_timeout	= monarch_timeout;
+		mce_sys_infos.mce_ignore_ce	= mce_ignore_ce;
+		mce_sys_infos.mce_cmci_disabled	= mce_cmci_disabled;
+	}
+}
+
+static int mce_sys_info_show(struct seq_file *m, void *v)
+{
+	unsigned long cap_reg;
+	seq_printf(m,
+			"MCE status:                      Original/(Current) Value\n"
+			"    mce_disabled:                %s\n"
+			"\n",
+			mce_sys_infos.mce_disabled ? "Y":"N"
+	);
+
+	if (!mce_disabled) {
+		seq_printf(m,
+			"    mce_ser:                     %d/%d\n"
+			"    tolerant:                    %d/%d\n"
+			"    panic_on_oops:               %d/%d\n"
+			"    monarch_timeout:             %d/%d us\n"
+			"    mce_ignore_ce:               %d/%d\n"
+			"    mce_cmci_disabled:           %s/%s\n"
+			"\n",
+
+			mce_sys_infos.mce_ser,
+			mce_ser,
+			mce_sys_infos.tolerant,
+			tolerant,
+			mce_sys_infos.panic_on_oops,
+			panic_on_oops,
+			mce_sys_infos.monarch_timeout,
+			monarch_timeout,
+			mce_sys_infos.mce_ignore_ce,
+			mce_ignore_ce,
+			mce_sys_infos.mce_cmci_disabled ? "Y":"N",
+			mce_cmci_disabled ? "Y":"N"
+		);
+
+		cap_reg = (unsigned long)(mce_sys_infos.mcg_cap_register);
+		seq_printf(m,
+		"MCG Register:\n"
+		"    CAP_Reg_Val           BANKS    EXT_CNT    FUNCTIONS\n"
+		"    0x%016lx    0x%02x     0x%02x       ",
+			cap_reg,
+			(unsigned int)(cap_reg & MCG_BANKCNT_MASK),
+			(unsigned int)MCG_EXT_CNT(cap_reg)
+		);
+
+		if (cap_reg & MCG_SER_P)
+			seq_printf(m, "SER ");
+#define MCG_TES_P (1ULL << 11)
+		if (cap_reg & MCG_TES_P)
+			seq_printf(m, "TES ");
+		if (cap_reg & MCG_CMCI_P)
+			seq_printf(m, "CMCI ");
+		if (cap_reg & MCG_EXT_P)
+			seq_printf(m, "EXT ");
+		if (cap_reg & MCG_CTL_P)
+			seq_printf(m, "CTL ");
+
+		seq_printf(m, "\n");
+	}
+
+	return 0;
+}
+
+static int mce_sys_info_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, mce_sys_info_show, NULL);
+}
+
+static const struct file_operations mce_sys_info_fops = {
+	.open		= mce_sys_info_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
 static int __init mcheck_debugfs_init(void)
 {
 	struct dentry *dmce, *ffake_panic;
 	struct dentry *fmce_ser = NULL;
+	struct dentry *fmce_sys_info = NULL;
 
 	dmce = mce_get_debugfs_dir();
 	if (!dmce)
 		return -ENOMEM;
+
 	ffake_panic = debugfs_create_file("fake_panic", 0644, dmce, NULL,
 					  &fake_panic_fops);
 	if (!ffake_panic)
@@ -2244,6 +2365,11 @@ static int __init mcheck_debugfs_init(void)
 	if (!fmce_ser)
 		return -ENOMEM;
 
+	fmce_sys_info = debugfs_create_file("mce_sys_info", 0444, dmce,
+						NULL, &mce_sys_info_fops);
+	if (!fmce_sys_info)
+		return -ENOMEM;
+
 	return 0;
 }
 late_initcall(mcheck_debugfs_init);
-- 
1.7.2.2


