Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756432Ab0KYBMO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 20:12:14 -0500
Received: from smtp104.prem.mail.sp1.yahoo.com ([98.136.44.59]:44063 "HELO
	smtp104.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752382Ab0KYBMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 20:12:12 -0500
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-YMail-OSG: PAxPhlMVM1mImyccaVZKhtkr8dqer2GL28Vh9x7VQ8DjGub
 NmUkIB1IhlJM5fTPGqQz1dBOjcBhr9KRHniX4syDeH.BdRA_qaBALg4wjYw3
 zusko0yXWg2EOI2UoPh_S8luWxnhRKZu7Z1hFIWuNHx5aBtMqeeljkwimUkb
 CgAMpsRPhPLUUv9qCtpepkVAyY8QXXxNb1CF.02iK4BRepG1n9loQIQJ7Q6b
 7skFNi811HmOrSutuq6zSvUz5WhOBavS6FroHbOgTj6YY64d0OWNX9Y757En
 cZTBo46uXV.l52e2R7z_7glkVMdw-
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4CEDB7EA.1070106@schaufler-ca.com>
Date: Wed, 24 Nov 2010 17:12:10 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: James Morris <jmorris@namei.org>
CC: LSM <linux-security-module@vger.kernel.org>,
        LKLM <linux-kernel@vger.kernel.org>,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: [PATCH] Smack: UDS revision
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Subject: [PATCH] Smack: UDS revision

    This patch addresses a number of long standing issues
    with the way Smack treats UNIX domain sockets.
    
    All access control was being done based on the label of
    the file system object. This is inconsistant with the
    internet domain, in which access is done based on the
    IPIN and IPOUT attributes of the socket. As a result
    of the inode label policy it was not possible to use
    a UDS socket for label cognizant services, including
    dbus and the X11 server.
    
    Support for SCM_PEERSEC on UDS sockets is also provided.

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
---
 security/smack/smack_lsm.c                         |  106 ++++++++++++--------
 1 files changed, 63 insertions(+), 43 deletions(-)

diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index bc39f40..a1bdbfa 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -1671,10 +1671,13 @@ static int smack_inode_setsecurity(struct inode *inode, const char *name,
 		ssp->smk_in = sp;
 	else if (strcmp(name, XATTR_SMACK_IPOUT) == 0) {
 		ssp->smk_out = sp;
-		rc = smack_netlabel(sock->sk, SMACK_CIPSO_SOCKET);
-		if (rc != 0)
-			printk(KERN_WARNING "Smack: \"%s\" netlbl error %d.\n",
-			       __func__, -rc);
+		if (sock->sk->sk_family != PF_UNIX) {
+			rc = smack_netlabel(sock->sk, SMACK_CIPSO_SOCKET);
+			if (rc != 0)
+				printk(KERN_WARNING
+					"Smack: \"%s\" netlbl error %d.\n",
+					__func__, -rc);
+		}
 	} else
 		return -EOPNOTSUPP;
 
@@ -2271,9 +2274,10 @@ static void smack_d_instantiate(struct dentry *opt_dentry, struct inode *inode)
 		break;
 	case SOCKFS_MAGIC:
 		/*
-		 * Casey says sockets get the smack of the task.
+		 * Socket access is controlled by the socket
+		 * structures associated with the task involved.
 		 */
-		final = csp;
+		final = smack_known_star.smk_known;
 		break;
 	case PROC_SUPER_MAGIC:
 		/*
@@ -2300,7 +2304,16 @@ static void smack_d_instantiate(struct dentry *opt_dentry, struct inode *inode)
 		/*
 		 * This isn't an understood special case.
 		 * Get the value from the xattr.
-		 *
+		 */
+
+		/*
+		 * UNIX domain sockets use lower level socket data.
+		 */
+		if (S_ISSOCK(inode->i_mode)) {
+			final = smack_known_star.smk_known;
+			break;
+		}
+		/*
 		 * No xattr support means, alas, no SMACK label.
 		 * Use the aforeapplied default.
 		 * It would be curious if the label of the task
@@ -2422,14 +2435,18 @@ static int smack_setprocattr(struct task_struct *p, char *name,
 static int smack_unix_stream_connect(struct socket *sock,
 				     struct socket *other, struct sock *newsk)
 {
-	struct inode *sp = SOCK_INODE(sock);
-	struct inode *op = SOCK_INODE(other);
+	struct socket_smack *ssp = sock->sk->sk_security;
+	struct socket_smack *osp = other->sk->sk_security;
 	struct smk_audit_info ad;
+	int rc = 0;
 
 	smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_NET);
 	smk_ad_setfield_u_net_sk(&ad, other->sk);
-	return smk_access(smk_of_inode(sp), smk_of_inode(op),
-				 MAY_READWRITE, &ad);
+
+	if (!capable(CAP_MAC_OVERRIDE))
+		rc = smk_access(ssp->smk_out, osp->smk_in, MAY_WRITE, &ad);
+
+	return rc;
 }
 
 /**
@@ -2442,13 +2459,18 @@ static int smack_unix_stream_connect(struct socket *sock,
  */
 static int smack_unix_may_send(struct socket *sock, struct socket *other)
 {
-	struct inode *sp = SOCK_INODE(sock);
-	struct inode *op = SOCK_INODE(other);
+	struct socket_smack *ssp = sock->sk->sk_security;
+	struct socket_smack *osp = other->sk->sk_security;
 	struct smk_audit_info ad;
+	int rc = 0;
 
 	smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_NET);
 	smk_ad_setfield_u_net_sk(&ad, other->sk);
-	return smk_access(smk_of_inode(sp), smk_of_inode(op), MAY_WRITE, &ad);
+
+	if (!capable(CAP_MAC_OVERRIDE))
+		rc = smk_access(ssp->smk_out, osp->smk_in, MAY_WRITE, &ad);
+
+	return rc;
 }
 
 /**
@@ -2633,7 +2655,7 @@ static int smack_socket_getpeersec_stream(struct socket *sock,
 
 /**
  * smack_socket_getpeersec_dgram - pull in packet label
- * @sock: the socket
+ * @sock: the peer socket
  * @skb: packet data
  * @secid: pointer to where to put the secid of the packet
  *
@@ -2644,41 +2666,39 @@ static int smack_socket_getpeersec_dgram(struct socket *sock,
 
 {
 	struct netlbl_lsm_secattr secattr;
-	struct sock *sk;
+	struct socket_smack *sp;
 	char smack[SMK_LABELLEN];
-	int family = PF_INET;
-	u32 s;
+	int family = PF_UNSPEC;
+	u32 s = 0;	/* 0 is the invalid secid */
 	int rc;
 
-	/*
-	 * Only works for families with packets.
-	 */
-	if (sock != NULL) {
-		sk = sock->sk;
-		if (sk->sk_family != PF_INET && sk->sk_family != PF_INET6)
-			return 0;
-		family = sk->sk_family;
+	if (skb != NULL) {
+		if (skb->protocol == htons(ETH_P_IP))
+			family = PF_INET;
+		else if (skb->protocol == htons(ETH_P_IPV6))
+			family = PF_INET6;
 	}
-	/*
-	 * Translate what netlabel gave us.
-	 */
-	netlbl_secattr_init(&secattr);
-	rc = netlbl_skbuff_getattr(skb, family, &secattr);
-	if (rc == 0)
-		smack_from_secattr(&secattr, smack);
-	netlbl_secattr_destroy(&secattr);
-
-	/*
-	 * Give up if we couldn't get anything
-	 */
-	if (rc != 0)
-		return rc;
+	if (family == PF_UNSPEC && sock != NULL)
+		family = sock->sk->sk_family;
 
-	s = smack_to_secid(smack);
+	if (family == PF_UNIX) {
+		sp = sock->sk->sk_security;
+		s = smack_to_secid(sp->smk_out);
+	} else if (family == PF_INET || family == PF_INET6) {
+		/*
+		 * Translate what netlabel gave us.
+		 */
+		netlbl_secattr_init(&secattr);
+		rc = netlbl_skbuff_getattr(skb, family, &secattr);
+		if (rc == 0) {
+			smack_from_secattr(&secattr, smack);
+			s = smack_to_secid(smack);
+		}
+		netlbl_secattr_destroy(&secattr);
+	}
+	*secid = s;
 	if (s == 0)
 		return -EINVAL;
-
-	*secid = s;
 	return 0;
 }
 

