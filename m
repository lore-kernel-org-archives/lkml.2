Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753857Ab1HNQGg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:06:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36341 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753838Ab1HNQGd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:06:33 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 12 14:05:53 2011
Message-Id: <20110812210553.587939730@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 12 Aug 2011 14:04:02 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Anton Blanchard <anton@samba.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [17/90] net: Fix security_socket_sendmsg() bypass problem.
In-Reply-To: <20110812210626.GA4725@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

commit c71d8ebe7a4496fb7231151cb70a6baa0cb56f9a upstream.

The sendmmsg() introduced by commit 228e548e "net: Add sendmmsg socket system
call" is capable of sending to multiple different destination addresses.

SMACK is using destination's address for checking sendmsg() permission.
However, security_socket_sendmsg() is called for only once even if multiple
different destination addresses are passed to sendmmsg().

Therefore, we need to call security_socket_sendmsg() for each destination
address rather than only the first destination address.

Since calling security_socket_sendmsg() every time when only single destination
address was passed to sendmmsg() is a waste of time, omit calling
security_socket_sendmsg() unless destination address of previous datagram and
that of current datagram differs.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Acked-by: Anton Blanchard <anton@samba.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/socket.c |   43 ++++++++++++++++++++++++++++++++++---------
 1 file changed, 34 insertions(+), 9 deletions(-)

--- a/net/socket.c
+++ b/net/socket.c
@@ -1871,8 +1871,14 @@ SYSCALL_DEFINE2(shutdown, int, fd, int,
 #define COMPAT_NAMELEN(msg)	COMPAT_MSG(msg, msg_namelen)
 #define COMPAT_FLAGS(msg)	COMPAT_MSG(msg, msg_flags)
 
+struct used_address {
+	struct sockaddr_storage name;
+	unsigned int name_len;
+};
+
 static int __sys_sendmsg(struct socket *sock, struct msghdr __user *msg,
-			 struct msghdr *msg_sys, unsigned flags, int nosec)
+			 struct msghdr *msg_sys, unsigned flags,
+			 struct used_address *used_address)
 {
 	struct compat_msghdr __user *msg_compat =
 	    (struct compat_msghdr __user *)msg;
@@ -1953,8 +1959,28 @@ static int __sys_sendmsg(struct socket *
 
 	if (sock->file->f_flags & O_NONBLOCK)
 		msg_sys->msg_flags |= MSG_DONTWAIT;
-	err = (nosec ? sock_sendmsg_nosec : sock_sendmsg)(sock, msg_sys,
-							  total_len);
+	/*
+	 * If this is sendmmsg() and current destination address is same as
+	 * previously succeeded address, omit asking LSM's decision.
+	 * used_address->name_len is initialized to UINT_MAX so that the first
+	 * destination address never matches.
+	 */
+	if (used_address && used_address->name_len == msg_sys->msg_namelen &&
+	    !memcmp(&used_address->name, msg->msg_name,
+		    used_address->name_len)) {
+		err = sock_sendmsg_nosec(sock, msg_sys, total_len);
+		goto out_freectl;
+	}
+	err = sock_sendmsg(sock, msg_sys, total_len);
+	/*
+	 * If this is sendmmsg() and sending to current destination address was
+	 * successful, remember it.
+	 */
+	if (used_address && err >= 0) {
+		used_address->name_len = msg_sys->msg_namelen;
+		memcpy(&used_address->name, msg->msg_name,
+		       used_address->name_len);
+	}
 
 out_freectl:
 	if (ctl_buf != ctl)
@@ -1979,7 +2005,7 @@ SYSCALL_DEFINE3(sendmsg, int, fd, struct
 	if (!sock)
 		goto out;
 
-	err = __sys_sendmsg(sock, msg, &msg_sys, flags, 0);
+	err = __sys_sendmsg(sock, msg, &msg_sys, flags, NULL);
 
 	fput_light(sock->file, fput_needed);
 out:
@@ -1998,6 +2024,7 @@ int __sys_sendmmsg(int fd, struct mmsghd
 	struct mmsghdr __user *entry;
 	struct compat_mmsghdr __user *compat_entry;
 	struct msghdr msg_sys;
+	struct used_address used_address;
 
 	if (vlen > UIO_MAXIOV)
 		vlen = UIO_MAXIOV;
@@ -2008,24 +2035,22 @@ int __sys_sendmmsg(int fd, struct mmsghd
 	if (!sock)
 		return err;
 
+	used_address.name_len = UINT_MAX;
 	entry = mmsg;
 	compat_entry = (struct compat_mmsghdr __user *)mmsg;
 	err = 0;
 
 	while (datagrams < vlen) {
-		/*
-		 * No need to ask LSM for more than the first datagram.
-		 */
 		if (MSG_CMSG_COMPAT & flags) {
 			err = __sys_sendmsg(sock, (struct msghdr __user *)compat_entry,
-					    &msg_sys, flags, datagrams);
+					    &msg_sys, flags, &used_address);
 			if (err < 0)
 				break;
 			err = __put_user(err, &compat_entry->msg_len);
 			++compat_entry;
 		} else {
 			err = __sys_sendmsg(sock, (struct msghdr __user *)entry,
-					    &msg_sys, flags, datagrams);
+					    &msg_sys, flags, &used_address);
 			if (err < 0)
 				break;
 			err = put_user(err, &entry->msg_len);


