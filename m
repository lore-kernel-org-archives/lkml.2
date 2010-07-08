Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754354Ab0GHHQY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 03:16:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:51485 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752581Ab0GHHQW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 03:16:22 -0400
Date: Thu, 8 Jul 2010 07:16:01 GMT
From: tip-bot for Feng Tang <feng.tang@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       dtor@mail.ru, tglx@linutronix.de, hpa@linux.intel.com,
       feng.tang@intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       dtor@mail.ru, tglx@linutronix.de, feng.tang@intel.com,
       hpa@linux.intel.com
In-Reply-To: <1278342202-10973-2-git-send-email-feng.tang@intel.com>
References: <1278342202-10973-2-git-send-email-feng.tang@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Add i8042 pre-detection hook to x86_platform_ops
Message-ID: <tip-c516ac583973196162b1ba7e4d597d6f6892dac0@git.kernel.org>
Git-Commit-ID: c516ac583973196162b1ba7e4d597d6f6892dac0
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 08 Jul 2010 07:16:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c516ac583973196162b1ba7e4d597d6f6892dac0
Gitweb:     http://git.kernel.org/tip/c516ac583973196162b1ba7e4d597d6f6892dac0
Author:     Feng Tang <feng.tang@intel.com>
AuthorDate: Mon, 5 Jul 2010 23:03:18 +0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 7 Jul 2010 17:05:06 -0700

x86: Add i8042 pre-detection hook to x86_platform_ops

Some x86 platforms like Intel MID platforms don't have i8042 controllers,
and i8042 driver's probe to some legacy IO ports may hang the MID
processor. With this hook, i8042 driver can runtime check and skip the
probe when the pretection fail which also saves some probe time

[ hpa note: this is currently a compile-time check, which breaks the
  i386 allyesconfig build.  This patch series thus does fix a regression. ]

Signed-off-by: Feng Tang <feng.tang@intel.com>
LKML-Reference: <1278342202-10973-2-git-send-email-feng.tang@intel.com>
Acked-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/x86_init.h |    2 ++
 arch/x86/kernel/x86_init.c      |    4 +++-
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index 519b543..baa579c 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -142,6 +142,7 @@ struct x86_cpuinit_ops {
  * @set_wallclock:		set time back to HW clock
  * @is_untracked_pat_range	exclude from PAT logic
  * @nmi_init			enable NMI on cpus
+ * @i8042_detect		pre-detect if i8042 controller exists
  */
 struct x86_platform_ops {
 	unsigned long (*calibrate_tsc)(void);
@@ -150,6 +151,7 @@ struct x86_platform_ops {
 	void (*iommu_shutdown)(void);
 	bool (*is_untracked_pat_range)(u64 start, u64 end);
 	void (*nmi_init)(void);
+	int (*i8042_detect)(void);
 };
 
 extern struct x86_init_ops x86_init;
diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index ebfb8e4..cd6da6b 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -86,6 +86,7 @@ struct x86_cpuinit_ops x86_cpuinit __cpuinitdata = {
 };
 
 static void default_nmi_init(void) { };
+static int default_i8042_detect(void) { return 1; };
 
 struct x86_platform_ops x86_platform = {
 	.calibrate_tsc			= native_calibrate_tsc,
@@ -93,7 +94,8 @@ struct x86_platform_ops x86_platform = {
 	.set_wallclock			= mach_set_rtc_mmss,
 	.iommu_shutdown			= iommu_shutdown_noop,
 	.is_untracked_pat_range		= is_ISA_range,
-	.nmi_init			= default_nmi_init
+	.nmi_init			= default_nmi_init,
+	.i8042_detect			= default_i8042_detect
 };
 
 EXPORT_SYMBOL_GPL(x86_platform);
