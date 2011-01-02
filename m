Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429Ab1ABIEt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 03:04:49 -0500
Received: from mail.windriver.com ([147.11.1.11]:34601 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616Ab1ABHWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:22:15 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Robert Richter <robert.richter@amd.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 059/260] oprofile, x86: fix init_sysfs error handling
Date: Sun,  2 Jan 2011 02:15:55 -0500
Message-Id: <1293952756-15010-60-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:21:10.0210 (UTC) FILETIME=[A1180220:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Richter <robert.richter@amd.com>

commit 10f0412f57f2a76a90eff4376f59cbb0a39e4e18 upstream.

On failure init_sysfs() might not properly free resources. The error
code of the function is not checked. And, when reinitializing the exit
function might be called twice. This patch fixes all this.

Signed-off-by: Robert Richter <robert.richter@amd.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/x86/oprofile/nmi_int.c |   16 +++++++++++++---
 1 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index c41ad50..41b7228 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -518,8 +518,13 @@ static int __init init_sysfs(void)
 	int error;
 
 	error = sysdev_class_register(&oprofile_sysclass);
-	if (!error)
-		error = sysdev_register(&device_oprofile);
+	if (error)
+		return error;
+
+	error = sysdev_register(&device_oprofile);
+	if (error)
+		sysdev_class_unregister(&oprofile_sysclass);
+
 	return error;
 }
 
@@ -645,6 +650,8 @@ int __init op_nmi_init(struct oprofile_operations *ops)
 	char *cpu_type = NULL;
 	int ret = 0;
 
+	using_nmi = 0;
+
 	if (!cpu_has_apic)
 		return -ENODEV;
 
@@ -727,7 +734,10 @@ int __init op_nmi_init(struct oprofile_operations *ops)
 
 	mux_init(ops);
 
-	init_sysfs();
+	ret = init_sysfs();
+	if (ret)
+		return ret;
+
 	using_nmi = 1;
 	printk(KERN_INFO "oprofile: using NMI interrupt.\n");
 	return 0;
-- 
1.7.3.3

