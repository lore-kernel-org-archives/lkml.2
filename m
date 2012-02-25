Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757609Ab2BYDZv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 22:25:51 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:59282 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753570Ab2BYDWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 22:22:41 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of wad@chromium.org designates 10.236.157.10 as permitted sender) smtp.mail=wad@chromium.org; dkim=pass header.i=wad@chromium.org
MIME-Version: 1.0
From: Will Drewry <wad@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
        kernel-hardening@lists.openwall.com, netdev@vger.kernel.org,
        x86@kernel.org, arnd@arndb.de, davem@davemloft.net, hpa@zytor.com,
        mingo@redhat.com, oleg@redhat.com, peterz@infradead.org,
        rdunlap@xenotime.net, mcgrathr@chromium.org, tglx@linutronix.de,
        luto@mit.edu, eparis@redhat.com, serge.hallyn@canonical.com,
        djm@mindrot.org, scarybeasts@gmail.com, indan@nul.nu,
        pmoore@redhat.com, akpm@linux-foundation.org, corbet@lwn.net,
        eric.dumazet@gmail.com, markus@chromium.org, coreyb@linux.vnet.ibm.com,
        keescook@chromium.org, Will Drewry <wad@chromium.org>
Subject: [PATCH v11 02/12] net/compat.c,linux/filter.h: share compat_sock_fprog
Date: Fri, 24 Feb 2012 21:21:41 -0600
Message-Id: <1330140111-17201-2-git-send-email-wad@chromium.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1330140111-17201-1-git-send-email-wad@chromium.org>
References: <1330140111-17201-1-git-send-email-wad@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any other users of bpf_*_filter that take a struct sock_fprog from
userspace will need to be able to also accept a compat_sock_fprog
if the arch supports compat calls.  This change let's the existing
compat_sock_fprog be shared.

Signed-off-by: Will Drewry <wad@chromium.org>

v11: introduction
---
 include/linux/filter.h |   11 +++++++++++
 net/compat.c           |    8 --------
 2 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/include/linux/filter.h b/include/linux/filter.h
index bdd02f9..f052f5c 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -10,6 +10,7 @@
 
 #ifdef __KERNEL__
 #include <linux/atomic.h>
+#include <linux/compat.h>
 #endif
 
 /*
@@ -135,6 +136,16 @@ struct sock_fprog {	/* Required for SO_ATTACH_FILTER. */
 
 #ifdef __KERNEL__
 
+#ifdef CONFIG_COMPAT
+/*
+ * A struct sock_filter is architecture independent.
+ */
+struct compat_sock_fprog {
+	u16		len;
+	compat_uptr_t	filter;		/* struct sock_filter * */
+};
+#endif
+
 struct sk_buff;
 struct sock;
 
diff --git a/net/compat.c b/net/compat.c
index 6def90e..c5c61c8 100644
--- a/net/compat.c
+++ b/net/compat.c
@@ -326,14 +326,6 @@ void scm_detach_fds_compat(struct msghdr *kmsg, struct scm_cookie *scm)
 	__scm_destroy(scm);
 }
 
-/*
- * A struct sock_filter is architecture independent.
- */
-struct compat_sock_fprog {
-	u16		len;
-	compat_uptr_t	filter;		/* struct sock_filter * */
-};
-
 static int do_set_attach_filter(struct socket *sock, int level, int optname,
 				char __user *optval, unsigned int optlen)
 {
-- 
1.7.5.4

