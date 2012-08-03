Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223Ab2HCSPr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 14:15:47 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:51107 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062Ab2HCSPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 14:15:45 -0400
From: julian.pidancet@gmail.com
To: linux-kernel@vger.kernel.org
Cc: maze@google.com, ycheng@google.com, edumazet@google.com,
        davem@davemloft.net, xen-devel@lists.xen.org,
        Julian Pidancet <julian.pidancet@citrix.com>
Subject: [RFC PATCH] Introduce V4V socket family for inter-virtual machines communication
Date: Fri,  3 Aug 2012 19:26:38 +0100
Message-Id: <cf6ab1bc6ccb8e997a4665b59f4dcac374764f96.1344018162.git.julian.pidancet@citrix.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julian Pidancet <julian.pidancet@citrix.com>

V4V is an hypervisor based inter domain-communication system beeing
developed for the Xen hypervisor.

I am currently working on a kernel socket family implementation of this
protocol and realized that socket family numbers were allocated
statically. It basically makes it impossible to create a new socket
family without having to modify the include/linux/socket.h and bump the
AF_MAX definition beforehand. (Any attempt to call sock_register() with
a family value greater than or equal to AF_MAX will fail).

Therefore I am submitting this RFC patch to find out wether it would be
acceptable to add a new socket family in the AF list without breaking
compatibility.

The socket family introduced in this patch is called AF_V4V, which
implies that the family would be Xen specific. But we can also consider
adding a more generic, hypervisor agnostic socket family, which enables
inter-VM communication.

Signed-off-by: Julian Pidancet <julian.pidancet@citrix.com>
---
 include/linux/socket.h |    4 +++-
 include/linux/v4v.h    |   27 +++++++++++++++++++++++++++
 2 files changed, 30 insertions(+), 1 deletions(-)
 create mode 100644 include/linux/v4v.h

diff --git a/include/linux/socket.h b/include/linux/socket.h
index ba7b2e8..5e879d0 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -195,7 +195,8 @@ struct ucred {
 #define AF_CAIF		37	/* CAIF sockets			*/
 #define AF_ALG		38	/* Algorithm sockets		*/
 #define AF_NFC		39	/* NFC sockets			*/
-#define AF_MAX		40	/* For now.. */
+#define AF_V4V		40	/* Inter virtual domain sockets */
+#define AF_MAX		41	/* For now.. */
 
 /* Protocol families, same as address families. */
 #define PF_UNSPEC	AF_UNSPEC
@@ -238,6 +239,7 @@ struct ucred {
 #define PF_CAIF		AF_CAIF
 #define PF_ALG		AF_ALG
 #define PF_NFC		AF_NFC
+#define PF_V4V		AF_V4V
 #define PF_MAX		AF_MAX
 
 /* Maximum queue length specifiable by listen.  */
diff --git a/include/linux/v4v.h b/include/linux/v4v.h
new file mode 100644
index 0000000..172f67f
--- /dev/null
+++ b/include/linux/v4v.h
@@ -0,0 +1,27 @@
+/*
+ * linux/v4v.h
+ *
+ * Definitions for V4V network layer
+ *
+ * Authors: Julian Pidancet <julian.pidancet@citrix.com>
+ * Copyright (c) 2012 Citrix Systems
+ * All rights reserved.
+ *
+ */
+#ifndef V4V_KERNEL_H
+#define V4V_KERNEL_H
+
+#include <linux/types.h>
+#include <linux/socket.h>
+
+typedef struct {
+        __u32                   port;
+        __u16                   domain;
+} v4v_address;
+
+struct sockaddr_v4v {
+        __kernel_sa_family_t    sv4v_family;
+        v4v_address             sv4v_addr;
+};
+
+#endif /* V4V_KERNEL_H */
-- 
Julian Pidancet

