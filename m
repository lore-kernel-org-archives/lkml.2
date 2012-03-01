Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757959Ab2CAVLe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 16:11:34 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40344 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757760Ab2CAVLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 16:11:32 -0500
Date: Thu, 1 Mar 2012 13:07:59 -0800
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Message-ID: <tip-vwvnlu3hjmtkwvij4qxtm90l@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        nitin.a.kamble@intel.com, tglx@linutronix.de, hpa@linux.intel.com,
        hjl.tools@gmail.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        nitin.a.kamble@intel.com, tglx@linutronix.de, hpa@linux.intel.com,
        hjl.tools@gmail.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/x32] x86, mtrr:
  Use explicit sizing and padding for the 64-bit ioctls
Git-Commit-ID: b263b31e8ad65cdbfa5a7f739460f350554a2dc1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 01 Mar 2012 13:08:25 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b263b31e8ad65cdbfa5a7f739460f350554a2dc1
Gitweb:     http://git.kernel.org/tip/b263b31e8ad65cdbfa5a7f739460f350554a2dc1
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Mon, 27 Feb 2012 15:15:25 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 1 Mar 2012 12:48:52 -0800

x86, mtrr: Use explicit sizing and padding for the 64-bit ioctls

Specify the data structures for the 64-bit ioctls with explicit sizing
and padding so that the x32 kernel will correctly use the 64-bit forms
of these ioctls.  Note that these ioctls are bogus in both forms on
both 32 and 64 bits; even on 64 bits the maximum MTRR size is only 44
bits long.

Note that nothing really is supposed to use these ioctls and that the
preferred interface is text strings on /proc/mtrr, or better yet,
nothing at all (use /sys/bus/pci/devices/*/resource*_wc for write
combining; that uses PAT not MTRRs.)

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: H. J. Lu <hjl.tools@gmail.com>
Tested-by: Nitin A. Kamble <nitin.a.kamble@intel.com>
Link: http://lkml.kernel.org/n/tip-vwvnlu3hjmtkwvij4qxtm90l@git.kernel.org
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/mtrr.h   |   28 ++++++++++++++++++----------
 arch/x86/kernel/cpu/mtrr/if.c |   10 ++++++----
 2 files changed, 24 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/mtrr.h b/arch/x86/include/asm/mtrr.h
index 4365ffd..7e3f17f 100644
--- a/arch/x86/include/asm/mtrr.h
+++ b/arch/x86/include/asm/mtrr.h
@@ -29,18 +29,18 @@
 
 #define	MTRR_IOCTL_BASE	'M'
 
-struct mtrr_sentry {
-    unsigned long base;    /*  Base address     */
-    unsigned int size;    /*  Size of region   */
-    unsigned int type;     /*  Type of region   */
-};
-
 /* Warning: this structure has a different order from i386
    on x86-64. The 32bit emulation code takes care of that.
    But you need to use this for 64bit, otherwise your X server
    will break. */
 
 #ifdef __i386__
+struct mtrr_sentry {
+    unsigned long base;    /*  Base address     */
+    unsigned int size;    /*  Size of region   */
+    unsigned int type;     /*  Type of region   */
+};
+
 struct mtrr_gentry {
     unsigned int regnum;   /*  Register number  */
     unsigned long base;    /*  Base address     */
@@ -50,12 +50,20 @@ struct mtrr_gentry {
 
 #else /* __i386__ */
 
+struct mtrr_sentry {
+	__u64 base;		/*  Base address     */
+	__u32 size;		/*  Size of region   */
+	__u32 type;		/*  Type of region   */
+};
+
 struct mtrr_gentry {
-    unsigned long base;    /*  Base address     */
-    unsigned int size;    /*  Size of region   */
-    unsigned int regnum;   /*  Register number  */
-    unsigned int type;     /*  Type of region   */
+	__u64 base;		/*  Base address     */
+	__u32 size;		/*  Size of region   */
+	__u32 regnum;		/*  Register number  */
+	__u32 type;		/*  Type of region   */
+	__u32 _pad;		/*  Unused	     */
 };
+
 #endif /* !__i386__ */
 
 struct mtrr_var_range {
diff --git a/arch/x86/kernel/cpu/mtrr/if.c b/arch/x86/kernel/cpu/mtrr/if.c
index 7928963..a041e09 100644
--- a/arch/x86/kernel/cpu/mtrr/if.c
+++ b/arch/x86/kernel/cpu/mtrr/if.c
@@ -167,6 +167,7 @@ mtrr_ioctl(struct file *file, unsigned int cmd, unsigned long __arg)
 {
 	int err = 0;
 	mtrr_type type;
+	unsigned long base;
 	unsigned long size;
 	struct mtrr_sentry sentry;
 	struct mtrr_gentry gentry;
@@ -267,14 +268,14 @@ mtrr_ioctl(struct file *file, unsigned int cmd, unsigned long __arg)
 #endif
 		if (gentry.regnum >= num_var_ranges)
 			return -EINVAL;
-		mtrr_if->get(gentry.regnum, &gentry.base, &size, &type);
+		mtrr_if->get(gentry.regnum, &base, &size, &type);
 
 		/* Hide entries that go above 4GB */
-		if (gentry.base + size - 1 >= (1UL << (8 * sizeof(gentry.size) - PAGE_SHIFT))
+		if (base + size - 1 >= (1UL << (8 * sizeof(gentry.size) - PAGE_SHIFT))
 		    || size >= (1UL << (8 * sizeof(gentry.size) - PAGE_SHIFT)))
 			gentry.base = gentry.size = gentry.type = 0;
 		else {
-			gentry.base <<= PAGE_SHIFT;
+			gentry.base = base << PAGE_SHIFT;
 			gentry.size = size << PAGE_SHIFT;
 			gentry.type = type;
 		}
@@ -321,11 +322,12 @@ mtrr_ioctl(struct file *file, unsigned int cmd, unsigned long __arg)
 #endif
 		if (gentry.regnum >= num_var_ranges)
 			return -EINVAL;
-		mtrr_if->get(gentry.regnum, &gentry.base, &size, &type);
+		mtrr_if->get(gentry.regnum, &base, &size, &type);
 		/* Hide entries that would overflow */
 		if (size != (__typeof__(gentry.size))size)
 			gentry.base = gentry.size = gentry.type = 0;
 		else {
+			gentry.base = base;
 			gentry.size = size;
 			gentry.type = type;
 		}
