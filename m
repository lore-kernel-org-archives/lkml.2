Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758736Ab1LODYi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 22:24:38 -0500
Received: from ozlabs.org ([203.10.76.45]:58511 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758698Ab1LODXu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 22:23:50 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Subject: [PATCH 15/15] module_param: check that bool parameters really are bool.
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Thu, 15 Dec 2011 13:52:31 +1030
Message-ID: <8762hisemg.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

module_param(bool) used to counter-intuitively take an int.  In
fddd5201 (mid-2009) we allowed bool or int/unsigned int using a messy
trick.

This tightens the check (you'll get a warning about incompatible
return type) but still allows it.  Next kernel version, we'll remove
it.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 include/linux/moduleparam.h |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
--- a/include/linux/moduleparam.h
+++ b/include/linux/moduleparam.h
@@ -350,17 +350,11 @@ extern int param_set_charp(const char *v
 extern int param_get_charp(char *buffer, const struct kernel_param *kp);
 #define param_check_charp(name, p) __param_check(name, p, char *)
 
-/* For historical reasons "bool" parameters can be (unsigned) "int". */
+/* We used to allow int as well as bool.  We're taking that away! */
 extern struct kernel_param_ops param_ops_bool;
 extern int param_set_bool(const char *val, const struct kernel_param *kp);
 extern int param_get_bool(char *buffer, const struct kernel_param *kp);
-#define param_check_bool(name, p)					\
-	static inline void __check_##name(void)				\
-	{								\
-		BUILD_BUG_ON(!__same_type((p), bool *) &&		\
-			     !__same_type((p), unsigned int *) &&	\
-			     !__same_type((p), int *));			\
-	}
+#define param_check_bool(name, p) __param_check(name, p, bool)
 
 extern struct kernel_param_ops param_ops_invbool;
 extern int param_set_invbool(const char *val, const struct kernel_param *kp);
