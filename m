Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120Ab0D0OZL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 10:25:11 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:64303 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756101Ab0D0OZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 10:25:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: John Kacur <jkacur@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jan Blunck <jblunck@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 4/7] sn_hwperf: kill BKL usage
Date: Tue, 27 Apr 2010 16:24:22 +0200
Message-Id: <1272378265-10909-5-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <alpine.LFD.2.00.1004271359180.3318@localhost>
References: <alpine.LFD.2.00.1004271359180.3318@localhost>
X-Provags-ID: V01U2FsdGVkX1+hbT0XS8keoDdloxnrQiR8QLTSX/mxzibKdCF
 26wrvCYuHy7Atv5VvNt7z3RXRBFdRdLRfqOCiszubtIRbeGYt8
 jvse0MmphiaRvOmSeZpDg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver always gave up the BKL in its ioctl function, so just
convert it to unlocked_ioctl and remove the BKL here.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/ia64/sn/kernel/sn2/sn_hwperf.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/arch/ia64/sn/kernel/sn2/sn_hwperf.c b/arch/ia64/sn/kernel/sn2/sn_hwperf.c
index 55ac3c4..d68fe0f 100644
--- a/arch/ia64/sn/kernel/sn2/sn_hwperf.c
+++ b/arch/ia64/sn/kernel/sn2/sn_hwperf.c
@@ -30,7 +30,6 @@
 #include <linux/miscdevice.h>
 #include <linux/utsname.h>
 #include <linux/cpumask.h>
-#include <linux/smp_lock.h>
 #include <linux/nodemask.h>
 #include <linux/smp.h>
 #include <linux/mutex.h>
@@ -682,8 +681,7 @@ static int sn_hwperf_map_err(int hwperf_err)
 /*
  * ioctl for "sn_hwperf" misc device
  */
-static int
-sn_hwperf_ioctl(struct inode *in, struct file *fp, u32 op, unsigned long arg)
+static long sn_hwperf_ioctl(struct file *fp, u32 op, unsigned long arg)
 {
 	struct sn_hwperf_ioctl_args a;
 	struct cpuinfo_ia64 *cdata;
@@ -699,8 +697,6 @@ sn_hwperf_ioctl(struct inode *in, struct file *fp, u32 op, unsigned long arg)
 	int i;
 	int j;
 
-	unlock_kernel();
-
 	/* only user requests are allowed here */
 	if ((op & SN_HWPERF_OP_MASK) < 10) {
 		r = -EINVAL;
@@ -859,12 +855,11 @@ sn_hwperf_ioctl(struct inode *in, struct file *fp, u32 op, unsigned long arg)
 error:
 	vfree(p);
 
-	lock_kernel();
 	return r;
 }
 
 static const struct file_operations sn_hwperf_fops = {
-	.ioctl = sn_hwperf_ioctl,
+	.unlocked_ioctl = sn_hwperf_ioctl,
 };
 
 static struct miscdevice sn_hwperf_dev = {
-- 
1.6.3.3

