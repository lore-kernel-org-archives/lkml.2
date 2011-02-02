Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308Ab1BBBCt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 20:02:49 -0500
Received: from mga09.intel.com ([134.134.136.24]:58186 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753141Ab1BBAoA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:44:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="703028388"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: ebiederm@xmission.com, serge@hallyn.com, davem@davemloft.net,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [54/139] scm: Capture the full credentials of the scm sender.
Message-Id: <20110202004410.590CD3E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:44:10 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
Upstream commit 257b5358b32f17e0603b6ff57b13610b0e02348f

Start capturing not only the userspace pid, uid and gid values of the
sending process but also the struct pid and struct cred of the sending
process as well.

This is in preparation for properly supporting SCM_CREDENTIALS for
sockets that have different uid and/or pid namespaces at the different
ends.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Acked-by: Serge E. Hallyn <serge@hallyn.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

Index: linux-2.6.35.y/include/net/scm.h
===================================================================
--- linux-2.6.35.y.orig/include/net/scm.h
+++ linux-2.6.35.y/include/net/scm.h
@@ -19,6 +19,8 @@ struct scm_fp_list {
 };
 
 struct scm_cookie {
+	struct pid		*pid;		/* Skb credentials */
+	const struct cred	*cred;
 	struct ucred		creds;		/* Skb credentials	*/
 	struct scm_fp_list	*fp;		/* Passed files		*/
 #ifdef CONFIG_SECURITY_NETWORK
@@ -42,8 +44,27 @@ static __inline__ void unix_get_peersec_
 { }
 #endif /* CONFIG_SECURITY_NETWORK */
 
+static __inline__ void scm_set_cred(struct scm_cookie *scm,
+				    struct pid *pid, const struct cred *cred)
+{
+	scm->pid  = get_pid(pid);
+	scm->cred = get_cred(cred);
+	cred_to_ucred(pid, cred, &scm->creds);
+}
+
+static __inline__ void scm_destroy_cred(struct scm_cookie *scm)
+{
+	put_pid(scm->pid);
+	scm->pid  = NULL;
+
+	if (scm->cred)
+		put_cred(scm->cred);
+	scm->cred = NULL;
+}
+
 static __inline__ void scm_destroy(struct scm_cookie *scm)
 {
+	scm_destroy_cred(scm);
 	if (scm && scm->fp)
 		__scm_destroy(scm);
 }
@@ -51,10 +72,7 @@ static __inline__ void scm_destroy(struc
 static __inline__ int scm_send(struct socket *sock, struct msghdr *msg,
 			       struct scm_cookie *scm)
 {
-	struct task_struct *p = current;
-	scm->creds.uid = current_uid();
-	scm->creds.gid = current_gid();
-	scm->creds.pid = task_tgid_vnr(p);
+	scm_set_cred(scm, task_tgid(current), current_cred());
 	scm->fp = NULL;
 	unix_get_peersec_dgram(sock, scm);
 	if (msg->msg_controllen <= 0)
@@ -96,6 +114,8 @@ static __inline__ void scm_recv(struct s
 	if (test_bit(SOCK_PASSCRED, &sock->flags))
 		put_cmsg(msg, SOL_SOCKET, SCM_CREDENTIALS, sizeof(scm->creds), &scm->creds);
 
+	scm_destroy_cred(scm);
+
 	scm_passec(sock, msg, scm);
 
 	if (!scm->fp)
Index: linux-2.6.35.y/net/core/scm.c
===================================================================
--- linux-2.6.35.y.orig/net/core/scm.c
+++ linux-2.6.35.y/net/core/scm.c
@@ -170,6 +170,30 @@ int __scm_send(struct socket *sock, stru
 			err = scm_check_creds(&p->creds);
 			if (err)
 				goto error;
+
+			if (pid_vnr(p->pid) != p->creds.pid) {
+				struct pid *pid;
+				err = -ESRCH;
+				pid = find_get_pid(p->creds.pid);
+				if (!pid)
+					goto error;
+				put_pid(p->pid);
+				p->pid = pid;
+			}
+
+			if ((p->cred->euid != p->creds.uid) ||
+				(p->cred->egid != p->creds.gid)) {
+				struct cred *cred;
+				err = -ENOMEM;
+				cred = prepare_creds();
+				if (!cred)
+					goto error;
+
+				cred->uid = cred->euid = p->creds.uid;
+				cred->gid = cred->egid = p->creds.uid;
+				put_cred(p->cred);
+				p->cred = cred;
+			}
 			break;
 		default:
 			goto error;
