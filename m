Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751985Ab2BTC1Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 21:27:16 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58127 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763Ab2BTC1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 21:27:12 -0500
From: "H. Peter Anvin" <hpa@zytor.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: mingo@kernel.org, tglx@linutronix.de, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, davem@davemloft.net, hjl.tools@gmail.com,
        Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <greg@kroah.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 6/7] compat: Use COMPAT_USE_64BIT_TIME in net/compat.c
Date: Sun, 19 Feb 2012 18:22:49 -0800
Message-Id: <1329704570-3792-7-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1329704570-3792-1-git-send-email-hpa@zytor.com>
References: <CA+55aFwiV3N-9-pB6ofN-5GBS0mnPTBGAdPH1M70wK8qr-=PQg@mail.gmail.com>
 <1329704570-3792-1-git-send-email-hpa@zytor.com>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 19 Feb 2012 18:27:02 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. J. Lu" <hjl.tools@gmail.com>

Handle 64-bit time structures in the networking core compat code.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: David S. Miller <davem@davemloft.net>
---
 net/compat.c |   65 +++++++++++++++++++++++++++++++++++----------------------
 1 files changed, 40 insertions(+), 25 deletions(-)

diff --git a/net/compat.c b/net/compat.c
index 6def90e..73bf0e0 100644
--- a/net/compat.c
+++ b/net/compat.c
@@ -219,8 +219,6 @@ Efault:
 
 int put_cmsg_compat(struct msghdr *kmsg, int level, int type, int len, void *data)
 {
-	struct compat_timeval ctv;
-	struct compat_timespec cts[3];
 	struct compat_cmsghdr __user *cm = (struct compat_cmsghdr __user *) kmsg->msg_control;
 	struct compat_cmsghdr cmhdr;
 	int cmlen;
@@ -230,24 +228,28 @@ int put_cmsg_compat(struct msghdr *kmsg, int level, int type, int len, void *dat
 		return 0; /* XXX: return error? check spec. */
 	}
 
-	if (level == SOL_SOCKET && type == SCM_TIMESTAMP) {
-		struct timeval *tv = (struct timeval *)data;
-		ctv.tv_sec = tv->tv_sec;
-		ctv.tv_usec = tv->tv_usec;
-		data = &ctv;
-		len = sizeof(ctv);
-	}
-	if (level == SOL_SOCKET &&
-	    (type == SCM_TIMESTAMPNS || type == SCM_TIMESTAMPING)) {
-		int count = type == SCM_TIMESTAMPNS ? 1 : 3;
-		int i;
-		struct timespec *ts = (struct timespec *)data;
-		for (i = 0; i < count; i++) {
-			cts[i].tv_sec = ts[i].tv_sec;
-			cts[i].tv_nsec = ts[i].tv_nsec;
+	if (!COMPAT_USE_64BIT_TIME) {
+		struct compat_timeval ctv;
+		struct compat_timespec cts[3];
+		if (level == SOL_SOCKET && type == SCM_TIMESTAMP) {
+			struct timeval *tv = (struct timeval *)data;
+			ctv.tv_sec = tv->tv_sec;
+			ctv.tv_usec = tv->tv_usec;
+			data = &ctv;
+			len = sizeof(ctv);
+		}
+		if (level == SOL_SOCKET &&
+		    (type == SCM_TIMESTAMPNS || type == SCM_TIMESTAMPING)) {
+			int count = type == SCM_TIMESTAMPNS ? 1 : 3;
+			int i;
+			struct timespec *ts = (struct timespec *)data;
+			for (i = 0; i < count; i++) {
+				cts[i].tv_sec = ts[i].tv_sec;
+				cts[i].tv_nsec = ts[i].tv_nsec;
+			}
+			data = &cts;
+			len = sizeof(cts[0]) * count;
 		}
-		data = &cts;
-		len = sizeof(cts[0]) * count;
 	}
 
 	cmlen = CMSG_COMPAT_LEN(len);
@@ -454,11 +456,15 @@ static int compat_sock_getsockopt(struct socket *sock, int level, int optname,
 
 int compat_sock_get_timestamp(struct sock *sk, struct timeval __user *userstamp)
 {
-	struct compat_timeval __user *ctv =
-			(struct compat_timeval __user *) userstamp;
-	int err = -ENOENT;
+	struct compat_timeval __user *ctv;
+	int err;
 	struct timeval tv;
 
+	if (COMPAT_USE_64BIT_TIME)
+		return sock_get_timestamp(sk, userstamp);
+
+	ctv = (struct compat_timeval __user *) userstamp;
+	err = -ENOENT;
 	if (!sock_flag(sk, SOCK_TIMESTAMP))
 		sock_enable_timestamp(sk, SOCK_TIMESTAMP);
 	tv = ktime_to_timeval(sk->sk_stamp);
@@ -478,11 +484,15 @@ EXPORT_SYMBOL(compat_sock_get_timestamp);
 
 int compat_sock_get_timestampns(struct sock *sk, struct timespec __user *userstamp)
 {
-	struct compat_timespec __user *ctv =
-			(struct compat_timespec __user *) userstamp;
-	int err = -ENOENT;
+	struct compat_timespec __user *ctv;
+	int err;
 	struct timespec ts;
 
+	if (COMPAT_USE_64BIT_TIME)
+		return sock_get_timestampns (sk, userstamp);
+
+	ctv = (struct compat_timespec __user *) userstamp;
+	err = -ENOENT;
 	if (!sock_flag(sk, SOCK_TIMESTAMP))
 		sock_enable_timestamp(sk, SOCK_TIMESTAMP);
 	ts = ktime_to_timespec(sk->sk_stamp);
@@ -767,6 +777,11 @@ asmlinkage long compat_sys_recvmmsg(int fd, struct compat_mmsghdr __user *mmsg,
 	int datagrams;
 	struct timespec ktspec;
 
+	if (COMPAT_USE_64BIT_TIME)
+		return __sys_recvmmsg(fd, (struct mmsghdr __user *)mmsg, vlen,
+				      flags | MSG_CMSG_COMPAT,
+				      (struct timespec *) timeout);
+
 	if (timeout == NULL)
 		return __sys_recvmmsg(fd, (struct mmsghdr __user *)mmsg, vlen,
 				      flags | MSG_CMSG_COMPAT, NULL);
-- 
1.7.6.5

