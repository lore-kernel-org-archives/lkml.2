Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932366Ab1BWRPA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 12:15:00 -0500
Received: from anchor-post-2.mail.demon.net ([195.173.77.133]:44943 "EHLO
	anchor-post-2.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755210Ab1BWRO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 12:14:59 -0500
Subject: [PATCH] module: reorder kparam_array to remove alignment padding
 on 64 bit builds
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Feb 2011 17:14:56 +0000
Message-ID: <1298481296.2130.7.camel@castor.rsk>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reorder structure kparam_array to remove 8 bytes of alignment padding on
64 bit builds, dropping its size from 40 to 32 bytes.

Also update the macro module_param_array_named to initialise the
structure using its member names to allow it to be changed without
touching all its call sites.

'git grep' finds module_param_array in 1037 places so this patch will
save a small amount of data space across many modules.

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
----

patch against v2.6.38-rc6
compiled & tested on x86_64

regards
Richard



diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
index 07b4195..ddaae98 100644
--- a/include/linux/moduleparam.h
+++ b/include/linux/moduleparam.h
@@ -67,9 +67,9 @@ struct kparam_string {
 struct kparam_array
 {
 	unsigned int max;
+	unsigned int elemsize;
 	unsigned int *num;
 	const struct kernel_param_ops *ops;
-	unsigned int elemsize;
 	void *elem;
 };
 
@@ -371,8 +371,9 @@ extern int param_get_invbool(char *buffer, const struct kernel_param *kp);
  */
 #define module_param_array_named(name, array, type, nump, perm)		\
 	static const struct kparam_array __param_arr_##name		\
-	= { ARRAY_SIZE(array), nump, &param_ops_##type,			\
-	    sizeof(array[0]), array };					\
+	= { .max = ARRAY_SIZE(array), .num = nump,                      \
+	    .ops = &param_ops_##type,					\
+	    .elemsize = sizeof(array[0]), .elem = array };		\
 	__module_param_call(MODULE_PARAM_PREFIX, name,			\
 			    &param_array_ops,				\
 			    .arr = &__param_arr_##name,			\


