Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756762Ab1GLXiK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 19:38:10 -0400
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:58731 "EHLO
	mail" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753709Ab1GLXho (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 19:37:44 -0400
From: Serge Hallyn <serge@hallyn.com>
To: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Cc: dhowells@redhat.com, ebiederm@xmission.com,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>
Subject: [RFC PATCH 10/14] net/core/scm.c: target capable() calls to user_ns owning the net_ns
Date: Tue, 12 Jul 2011 23:30:48 +0000
Message-Id: <1310513452-13397-11-git-send-email-serge@hallyn.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1310513452-13397-1-git-send-email-serge@hallyn.com>
References: <1310513452-13397-1-git-send-email-serge@hallyn.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Serge E. Hallyn <serge.hallyn@canonical.com>

The uid/gid comparisons don't have to be pulled out.  This just seemed
more easily proved correct.

Signed-off-by: Serge E. Hallyn <serge.hallyn@canonical.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
---
 net/core/scm.c |   41 ++++++++++++++++++++++++++++++++++-------
 1 files changed, 34 insertions(+), 7 deletions(-)

diff --git a/net/core/scm.c b/net/core/scm.c
index 4c1ef02..21b5d0b 100644
--- a/net/core/scm.c
+++ b/net/core/scm.c
@@ -43,17 +43,44 @@
  *	setu(g)id.
  */
 
-static __inline__ int scm_check_creds(struct ucred *creds)
+static __inline__ bool uidequiv(struct cred *src, struct ucred *tgt,
+			       struct user_namespace *ns)
+{
+	if (src->user_ns != ns)
+		goto check_capable;
+	if (src->uid == tgt->uid || src->euid == tgt->uid ||
+	    src->suid == tgt->uid)
+		return true;
+check_capable:
+	if (ns_capable(ns, CAP_SETUID))
+		return true;
+	return false;
+}
+
+static __inline__ bool gidequiv(struct cred *src, struct ucred *tgt,
+			       struct user_namespace *ns)
+{
+	if (src->user_ns != ns)
+		goto check_capable;
+	if (src->gid == tgt->gid || src->egid == tgt->gid ||
+	    src->sgid == tgt->gid)
+		return true;
+check_capable:
+	if (ns_capable(ns, CAP_SETGID))
+		return true;
+	return false;
+}
+
+static __inline__ int scm_check_creds(struct ucred *creds, struct socket *sock)
 {
 	const struct cred *cred = current_cred();
+	struct user_namespace *ns = sock_net(sock->sk)->user_ns;
 
-	if ((creds->pid == task_tgid_vnr(current) || capable(CAP_SYS_ADMIN)) &&
-	    ((creds->uid == cred->uid   || creds->uid == cred->euid ||
-	      creds->uid == cred->suid) || capable(CAP_SETUID)) &&
-	    ((creds->gid == cred->gid   || creds->gid == cred->egid ||
-	      creds->gid == cred->sgid) || capable(CAP_SETGID))) {
+	if ((creds->pid == task_tgid_vnr(current) || ns_capable(ns, CAP_SYS_ADMIN)) &&
+	     uidequiv(cred, creds, ns) && gidequiv(cred, creds, ns)) {
 	       return 0;
 	}
+
 	return -EPERM;
 }
 
@@ -169,7 +196,7 @@ int __scm_send(struct socket *sock, struct msghdr *msg, struct scm_cookie *p)
 			if (cmsg->cmsg_len != CMSG_LEN(sizeof(struct ucred)))
 				goto error;
 			memcpy(&p->creds, CMSG_DATA(cmsg), sizeof(struct ucred));
-			err = scm_check_creds(&p->creds);
+			err = scm_check_creds(&p->creds, sock);
 			if (err)
 				goto error;
 
-- 
1.7.4.1

