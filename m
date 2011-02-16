Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757550Ab1BPB2Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:28:16 -0500
Received: from kroah.org ([198.145.64.141]:39442 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932145Ab1BPAWB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:22:01 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:38 2011
Message-Id: <20110216001438.849655708@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:13:15 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "David S. Miller" <davem@davemloft.net>
Subject: [138/272] af_unix: Avoid socket->sk NULL OOPS in stream connect security hooks.
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------


From: David S. Miller <davem@davemloft.net>

[ Upstream commit 3610cda53f247e176bcbb7a7cca64bc53b12acdb ]

unix_release() can asynchornously set socket->sk to NULL, and
it does so without holding the unix_state_lock() on "other"
during stream connects.

However, the reverse mapping, sk->sk_socket, is only transitioned
to NULL under the unix_state_lock().

Therefore make the security hooks follow the reverse mapping instead
of the forward mapping.

Reported-by: Jeremy Fitzhardinge <jeremy@goop.org>
Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/security.h   |   15 +++++++--------
 net/unix/af_unix.c         |    2 +-
 security/capability.c      |    2 +-
 security/security.c        |    3 +--
 security/selinux/hooks.c   |   10 +++++-----
 security/smack/smack_lsm.c |   14 +++++++-------
 6 files changed, 22 insertions(+), 24 deletions(-)

--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -796,8 +796,9 @@ static inline void security_free_mnt_opt
  * @unix_stream_connect:
  *	Check permissions before establishing a Unix domain stream connection
  *	between @sock and @other.
- *	@sock contains the socket structure.
- *	@other contains the peer socket structure.
+ *	@sock contains the sock structure.
+ *	@other contains the peer sock structure.
+ *	@newsk contains the new sock structure.
  *	Return 0 if permission is granted.
  * @unix_may_send:
  *	Check permissions before connecting or sending datagrams from @sock to
@@ -1568,8 +1569,7 @@ struct security_operations {
 	int (*inode_getsecctx)(struct inode *inode, void **ctx, u32 *ctxlen);
 
 #ifdef CONFIG_SECURITY_NETWORK
-	int (*unix_stream_connect) (struct socket *sock,
-				    struct socket *other, struct sock *newsk);
+	int (*unix_stream_connect) (struct sock *sock, struct sock *other, struct sock *newsk);
 	int (*unix_may_send) (struct socket *sock, struct socket *other);
 
 	int (*socket_create) (int family, int type, int protocol, int kern);
@@ -2525,8 +2525,7 @@ static inline int security_inode_getsecc
 
 #ifdef CONFIG_SECURITY_NETWORK
 
-int security_unix_stream_connect(struct socket *sock, struct socket *other,
-				 struct sock *newsk);
+int security_unix_stream_connect(struct sock *sock, struct sock *other, struct sock *newsk);
 int security_unix_may_send(struct socket *sock,  struct socket *other);
 int security_socket_create(int family, int type, int protocol, int kern);
 int security_socket_post_create(struct socket *sock, int family,
@@ -2567,8 +2566,8 @@ void security_tun_dev_post_create(struct
 int security_tun_dev_attach(struct sock *sk);
 
 #else	/* CONFIG_SECURITY_NETWORK */
-static inline int security_unix_stream_connect(struct socket *sock,
-					       struct socket *other,
+static inline int security_unix_stream_connect(struct sock *sock,
+					       struct sock *other,
 					       struct sock *newsk)
 {
 	return 0;
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1156,7 +1156,7 @@ restart:
 		goto restart;
 	}
 
-	err = security_unix_stream_connect(sock, other->sk_socket, newsk);
+	err = security_unix_stream_connect(sk, other, newsk);
 	if (err) {
 		unix_state_unlock(sk);
 		goto out_unlock;
--- a/security/capability.c
+++ b/security/capability.c
@@ -548,7 +548,7 @@ static int cap_sem_semop(struct sem_arra
 }
 
 #ifdef CONFIG_SECURITY_NETWORK
-static int cap_unix_stream_connect(struct socket *sock, struct socket *other,
+static int cap_unix_stream_connect(struct sock *sock, struct sock *other,
 				   struct sock *newsk)
 {
 	return 0;
--- a/security/security.c
+++ b/security/security.c
@@ -977,8 +977,7 @@ EXPORT_SYMBOL(security_inode_getsecctx);
 
 #ifdef CONFIG_SECURITY_NETWORK
 
-int security_unix_stream_connect(struct socket *sock, struct socket *other,
-				 struct sock *newsk)
+int security_unix_stream_connect(struct sock *sock, struct sock *other, struct sock *newsk)
 {
 	return security_ops->unix_stream_connect(sock, other, newsk);
 }
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -3921,18 +3921,18 @@ static int selinux_socket_shutdown(struc
 	return sock_has_perm(current, sock->sk, SOCKET__SHUTDOWN);
 }
 
-static int selinux_socket_unix_stream_connect(struct socket *sock,
-					      struct socket *other,
+static int selinux_socket_unix_stream_connect(struct sock *sock,
+					      struct sock *other,
 					      struct sock *newsk)
 {
-	struct sk_security_struct *sksec_sock = sock->sk->sk_security;
-	struct sk_security_struct *sksec_other = other->sk->sk_security;
+	struct sk_security_struct *sksec_sock = sock->sk_security;
+	struct sk_security_struct *sksec_other = other->sk_security;
 	struct sk_security_struct *sksec_new = newsk->sk_security;
 	struct common_audit_data ad;
 	int err;
 
 	COMMON_AUDIT_DATA_INIT(&ad, NET);
-	ad.u.net.sk = other->sk;
+	ad.u.net.sk = other;
 
 	err = avc_has_perm(sksec_sock->sid, sksec_other->sid,
 			   sksec_other->sclass,
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -2408,22 +2408,22 @@ static int smack_setprocattr(struct task
 
 /**
  * smack_unix_stream_connect - Smack access on UDS
- * @sock: one socket
- * @other: the other socket
+ * @sock: one sock
+ * @other: the other sock
  * @newsk: unused
  *
  * Return 0 if a subject with the smack of sock could access
  * an object with the smack of other, otherwise an error code
  */
-static int smack_unix_stream_connect(struct socket *sock,
-				     struct socket *other, struct sock *newsk)
+static int smack_unix_stream_connect(struct sock *sock,
+				     struct sock *other, struct sock *newsk)
 {
-	struct inode *sp = SOCK_INODE(sock);
-	struct inode *op = SOCK_INODE(other);
+	struct inode *sp = SOCK_INODE(sock->sk_socket);
+	struct inode *op = SOCK_INODE(other->sk_socket);
 	struct smk_audit_info ad;
 
 	smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_NET);
-	smk_ad_setfield_u_net_sk(&ad, other->sk);
+	smk_ad_setfield_u_net_sk(&ad, other);
 	return smk_access(smk_of_inode(sp), smk_of_inode(op),
 				 MAY_READWRITE, &ad);
 }


