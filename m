Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293Ab1BBAoI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:44:08 -0500
Received: from mga09.intel.com ([134.134.136.24]:58186 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753175Ab1BBAoC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:44:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="703028401"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: ebiederm@xmission.com, xemul@openvz.org, davem@davemloft.net,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [57/139] sock: Introduce cred_to_ucred
Message-Id: <20110202004413.7904F3E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:44:13 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
Upstream commit 3f551f9436c05a3b5eccdd6e94733df5bb98d2a5

To keep the coming code clear and to allow both the sock
code and the scm code to share the logic introduce a
fuction to translate from struct cred to struct ucred.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Acked-by: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

Index: linux-2.6.35.y/include/linux/socket.h
===================================================================
--- linux-2.6.35.y.orig/include/linux/socket.h
+++ linux-2.6.35.y/include/linux/socket.h
@@ -24,6 +24,9 @@ struct __kernel_sockaddr_storage {
 #include <linux/types.h>		/* pid_t			*/
 #include <linux/compiler.h>		/* __user			*/
 
+struct pid;
+struct cred;
+
 #define __sockaddr_check_size(size)	\
 	BUILD_BUG_ON(((size) > sizeof(struct __kernel_sockaddr_storage)))
 
@@ -309,6 +312,8 @@ struct ucred {
 #define IPX_TYPE	1
 
 #ifdef __KERNEL__
+extern void cred_to_ucred(struct pid *pid, const struct cred *cred, struct ucred *ucred);
+
 extern int memcpy_fromiovec(unsigned char *kdata, struct iovec *iov, int len);
 extern int memcpy_fromiovecend(unsigned char *kdata, const struct iovec *iov,
 			       int offset, int len);
Index: linux-2.6.35.y/net/core/sock.c
===================================================================
--- linux-2.6.35.y.orig/net/core/sock.c
+++ linux-2.6.35.y/net/core/sock.c
@@ -110,6 +110,7 @@
 #include <linux/tcp.h>
 #include <linux/init.h>
 #include <linux/highmem.h>
+#include <linux/user_namespace.h>
 
 #include <asm/uaccess.h>
 #include <asm/system.h>
@@ -749,6 +750,19 @@ set_rcvbuf:
 EXPORT_SYMBOL(sock_setsockopt);
 
 
+void cred_to_ucred(struct pid *pid, const struct cred *cred,
+		   struct ucred *ucred)
+{
+	ucred->pid = pid_vnr(pid);
+	ucred->uid = ucred->gid = -1;
+	if (cred) {
+		struct user_namespace *current_ns = current_user_ns();
+
+		ucred->uid = user_ns_map_uid(current_ns, cred, cred->euid);
+		ucred->gid = user_ns_map_gid(current_ns, cred, cred->egid);
+	}
+}
+
 int sock_getsockopt(struct socket *sock, int level, int optname,
 		    char __user *optval, int __user *optlen)
 {
