Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539Ab0GZWpt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 18:45:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:58769 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754859Ab0GZWpr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 18:45:47 -0400
Date: Mon, 26 Jul 2010 22:45:21 GMT
Message-Id: <201007262245.o6QMjLrK004535@hera.kernel.org>
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86 fixes for 2.6.35-rc7
Cc: <stable@kernel.org>, Adam Lackorzynski <adam@os.inf.tu-dresden.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Jacob Pan <jacob.jun.pan@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Venkatesh Pallipadi <venki@google.com>, stable@kernel.org
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 26 Jul 2010 22:45:21 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit f82c3d71d6fd2e6a3e3416f09099e29087e39abf:
  Jacob Pan (1):
        x86, pci, mrst: Add extra sanity check in walking the PCI extended cap chain

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

Adam Lackorzynski (1):
      x86, i8259: Only register sysdev if we have a real 8259 PIC

Stefano Stabellini (1):
      x86: Do not try to disable hpet if it hasn't been initialized before

 arch/x86/kernel/hpet.c  |    2 +-
 arch/x86/kernel/i8259.c |   25 +++++++++++++++----------
 2 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index a198b7c..ba390d7 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -964,7 +964,7 @@ fs_initcall(hpet_late_init);
 
 void hpet_disable(void)
 {
-	if (is_hpet_capable()) {
+	if (is_hpet_capable() && hpet_virt_address) {
 		unsigned int cfg = hpet_readl(HPET_CFG);
 
 		if (hpet_legacy_int_enabled) {
diff --git a/arch/x86/kernel/i8259.c b/arch/x86/kernel/i8259.c
index 7c9f02c..cafa7c8 100644
--- a/arch/x86/kernel/i8259.c
+++ b/arch/x86/kernel/i8259.c
@@ -276,16 +276,6 @@ static struct sys_device device_i8259A = {
 	.cls	= &i8259_sysdev_class,
 };
 
-static int __init i8259A_init_sysfs(void)
-{
-	int error = sysdev_class_register(&i8259_sysdev_class);
-	if (!error)
-		error = sysdev_register(&device_i8259A);
-	return error;
-}
-
-device_initcall(i8259A_init_sysfs);
-
 static void mask_8259A(void)
 {
 	unsigned long flags;
@@ -407,3 +397,18 @@ struct legacy_pic default_legacy_pic = {
 };
 
 struct legacy_pic *legacy_pic = &default_legacy_pic;
+
+static int __init i8259A_init_sysfs(void)
+{
+	int error;
+
+	if (legacy_pic != &default_legacy_pic)
+		return 0;
+
+	error = sysdev_class_register(&i8259_sysdev_class);
+	if (!error)
+		error = sysdev_register(&device_i8259A);
+	return error;
+}
+
+device_initcall(i8259A_init_sysfs);
