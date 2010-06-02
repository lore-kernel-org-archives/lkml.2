Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932358Ab0FBLcA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 07:32:00 -0400
Received: from os.inf.tu-dresden.de ([141.76.48.99]:48231 "EHLO
	os.inf.tu-dresden.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757892Ab0FBLb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 07:31:58 -0400
Date: Wed, 2 Jun 2010 13:31:50 +0200
From: Adam Lackorzynski <adam@os.inf.tu-dresden.de>
To: Jacob Pan <jacob.jun.pan@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] x86, i8259: Only register sysdev for real PIC
Message-ID: <20100602113150.GB21413@os.inf.tu-dresden.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not register the sysdev function when the null_legacy_pic is used so
that the i8259 resume, suspend and shutdown functions are not called.

Signed-off-by: Adam Lackorzynski <adam@os.inf.tu-dresden.de>
---
 arch/x86/kernel/i8259.c |   26 ++++++++++++++++----------
 1 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/i8259.c b/arch/x86/kernel/i8259.c
index 7c9f02c..dfadc74 100644
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
@@ -407,3 +397,19 @@ struct legacy_pic default_legacy_pic = {
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
+
-- 
1.5.6.5
