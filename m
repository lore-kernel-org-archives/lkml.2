Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758019Ab2ECR6A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 13:58:00 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:55252 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756220Ab2ECR56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 13:57:58 -0400
From: Jim Cromie <jim.cromie@gmail.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Cc: jbaron@redhat.com, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 2/3] params: replace printk(KERN_<LVL>...) with pr_<lvl>(...)
Date: Thu,  3 May 2012 11:57:38 -0600
Message-Id: <1336067860-19953-2-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.8.1
In-Reply-To: <1336067860-19953-1-git-send-email-jim.cromie@gmail.com>
References: <1336067860-19953-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I left 1 printk which uses __FILE__, __LINE__ explicitly, which should
not be subject to generic preferences expressed via pr_fmt().

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 kernel/params.c |   33 ++++++++++++---------------------
 1 files changed, 12 insertions(+), 21 deletions(-)

diff --git a/kernel/params.c b/kernel/params.c
index be78c90..08414ba 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -201,25 +201,21 @@ int parse_args(const char *doing,
 		irq_was_disabled = irqs_disabled();
 		ret = parse_one(param, val, doing, params, num,
 				min_level, max_level, unknown);
-		if (irq_was_disabled && !irqs_disabled()) {
-			printk(KERN_WARNING "parse_args(): option '%s' enabled "
-					"irq's!\n", param);
-		}
+		if (irq_was_disabled && !irqs_disabled())
+			pr_warn("option '%s' enabled irq's!\n", param);
+
 		switch (ret) {
 		case -ENOENT:
-			printk(KERN_ERR "%s: Unknown parameter `%s'\n",
-			       doing, param);
+			pr_err("%s: Unknown parameter `%s'\n", doing, param);
 			return ret;
 		case -ENOSPC:
-			printk(KERN_ERR
-			       "%s: `%s' too large for parameter `%s'\n",
+			pr_err("%s: `%s' too large for parameter `%s'\n",
 			       doing, val ?: "", param);
 			return ret;
 		case 0:
 			break;
 		default:
-			printk(KERN_ERR
-			       "%s: `%s' invalid for parameter `%s'\n",
+			pr_err("%s: `%s' invalid for parameter `%s'\n",
 			       doing, val ?: "", param);
 			return ret;
 		}
@@ -266,8 +262,7 @@ STANDARD_PARAM_DEF(ulong, unsigned long, "%lu", unsigned long, strict_strtoul);
 int param_set_charp(const char *val, const struct kernel_param *kp)
 {
 	if (strlen(val) > 1024) {
-		printk(KERN_ERR "%s: string parameter too long\n",
-		       kp->name);
+		pr_err("%s: string parameter too long\n", kp->name);
 		return -ENOSPC;
 	}
 
@@ -403,8 +398,7 @@ static int param_array(const char *name,
 		int len;
 
 		if (*num == max) {
-			printk(KERN_ERR "%s: can only take %i arguments\n",
-			       name, max);
+			pr_err("%s: can only take %i arguments\n", name, max);
 			return -EINVAL;
 		}
 		len = strcspn(val, ",");
@@ -423,8 +417,7 @@ static int param_array(const char *name,
 	} while (save == ',');
 
 	if (*num < min) {
-		printk(KERN_ERR "%s: needs at least %i arguments\n",
-		       name, min);
+		pr_err("%s: needs at least %i arguments\n", name, min);
 		return -EINVAL;
 	}
 	return 0;
@@ -483,7 +476,7 @@ int param_set_copystring(const char *val, const struct kernel_param *kp)
 	const struct kparam_string *kps = kp->str;
 
 	if (strlen(val)+1 > kps->maxlen) {
-		printk(KERN_ERR "%s: string doesn't fit in %u chars.\n",
+		pr_err("%s: string doesn't fit in %u chars.\n",
 		       kp->name, kps->maxlen-1);
 		return -ENOSPC;
 	}
@@ -753,11 +746,9 @@ static struct module_kobject * __init locate_module_kobject(const char *name)
 #endif
 		if (err) {
 			kobject_put(&mk->kobj);
-			printk(KERN_ERR
-				"Module '%s' failed add to sysfs, error number %d\n",
+			pr_err("Module '%s' failed add to sysfs, error: %d\n"
+				"The system will be unstable now.\n",
 				name, err);
-			printk(KERN_ERR
-				"The system will be unstable now.\n");
 			return NULL;
 		}
 
-- 
1.7.8.1

