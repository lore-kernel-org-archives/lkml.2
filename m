Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751660Ab2BTC1k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 21:27:40 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58137 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560Ab2BTC1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 21:27:38 -0500
From: "H. Peter Anvin" <hpa@zytor.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: mingo@kernel.org, tglx@linutronix.de, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, davem@davemloft.net, hjl.tools@gmail.com,
        Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <greg@kroah.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 7/7] compat: Handle COMPAT_USE_64BIT_TIME in net/socket.c
Date: Sun, 19 Feb 2012 18:22:50 -0800
Message-Id: <1329704570-3792-8-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1329704570-3792-1-git-send-email-hpa@zytor.com>
References: <CA+55aFwiV3N-9-pB6ofN-5GBS0mnPTBGAdPH1M70wK8qr-=PQg@mail.gmail.com>
 <1329704570-3792-1-git-send-email-hpa@zytor.com>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 19 Feb 2012 18:27:28 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@zytor.com>

Use helper functions aware of COMPAT_USE_64BIT_TIME to write struct
timeval and struct timespec to userspace in net/socket.c.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 net/socket.c |   18 ++++++++----------
 1 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/net/socket.c b/net/socket.c
index 28a96af..57f5a25 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2600,7 +2600,7 @@ void socket_seq_show(struct seq_file *seq)
 
 #ifdef CONFIG_COMPAT
 static int do_siocgstamp(struct net *net, struct socket *sock,
-			 unsigned int cmd, struct compat_timeval __user *up)
+			 unsigned int cmd, void __user *up)
 {
 	mm_segment_t old_fs = get_fs();
 	struct timeval ktv;
@@ -2609,15 +2609,14 @@ static int do_siocgstamp(struct net *net, struct socket *sock,
 	set_fs(KERNEL_DS);
 	err = sock_do_ioctl(net, sock, cmd, (unsigned long)&ktv);
 	set_fs(old_fs);
-	if (!err) {
-		err = put_user(ktv.tv_sec, &up->tv_sec);
-		err |= __put_user(ktv.tv_usec, &up->tv_usec);
-	}
+	if (!err)
+		err = compat_put_timeval(up, &ktv);
+
 	return err;
 }
 
 static int do_siocgstampns(struct net *net, struct socket *sock,
-			 unsigned int cmd, struct compat_timespec __user *up)
+			 unsigned int cmd, struct void __user *up)
 {
 	mm_segment_t old_fs = get_fs();
 	struct timespec kts;
@@ -2626,10 +2625,9 @@ static int do_siocgstampns(struct net *net, struct socket *sock,
 	set_fs(KERNEL_DS);
 	err = sock_do_ioctl(net, sock, cmd, (unsigned long)&kts);
 	set_fs(old_fs);
-	if (!err) {
-		err = put_user(kts.tv_sec, &up->tv_sec);
-		err |= __put_user(kts.tv_nsec, &up->tv_nsec);
-	}
+	if (!err)
+		err = compat_put_timespec(up, &kts);
+
 	return err;
 }
 
-- 
1.7.6.5

