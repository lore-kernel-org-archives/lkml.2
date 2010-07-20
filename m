Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933034Ab0GTXBN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 19:01:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:56471 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932927Ab0GTXBL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 19:01:11 -0400
Date: Tue, 20 Jul 2010 23:00:49 GMT
From: tip-bot for Adam Lackorzynski <adam@os.inf.tu-dresden.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        adam@os.inf.tu-dresden.de, akpm@linux-foundation.org,
        jacob.jun.pan@intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        adam@os.inf.tu-dresden.de, akpm@linux-foundation.org,
        jacob.jun.pan@intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <201007202218.o6KMIJ3m020955@imap1.linux-foundation.org>
References: <201007202218.o6KMIJ3m020955@imap1.linux-foundation.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, i8259: Only register sysdev if we have a real 8259 PIC
Message-ID: <tip-087b255a2b43f417af83cb44e0bb02507f36b7fe@git.kernel.org>
Git-Commit-ID: 087b255a2b43f417af83cb44e0bb02507f36b7fe
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 20 Jul 2010 23:00:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  087b255a2b43f417af83cb44e0bb02507f36b7fe
Gitweb:     http://git.kernel.org/tip/087b255a2b43f417af83cb44e0bb02507f36b7fe
Author:     Adam Lackorzynski <adam@os.inf.tu-dresden.de>
AuthorDate: Tue, 20 Jul 2010 15:18:19 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 20 Jul 2010 15:27:33 -0700

x86, i8259: Only register sysdev if we have a real 8259 PIC

My platform makes use of the null_legacy_pic choice and oopses when doing
a shutdown as the shutdown code goes through all the registered sysdevs
and calls their shutdown method which in my case poke on a non-existing
i8259.  Imho the i8259 specific sysdev should only be registered if the
i8259 is actually there.

Do not register the sysdev function when the null_legacy_pic is used so
that the i8259 resume, suspend and shutdown functions are not called.

Signed-off-by: Adam Lackorzynski <adam@os.inf.tu-dresden.de>
LKML-Reference: <201007202218.o6KMIJ3m020955@imap1.linux-foundation.org>
Cc: Jacob Pan <jacob.jun.pan@intel.com>
Cc: <stable@kernel.org> 2.6.34
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/i8259.c |   25 +++++++++++++++----------
 1 files changed, 15 insertions(+), 10 deletions(-)

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
