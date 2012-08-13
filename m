Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756Ab2HMUTi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 16:19:38 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:51628 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429Ab2HMUTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 16:19:36 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <netdev@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, <containers@lists.linux-foundation.org>,
        David Miller <davem@davemloft.net>, Serge Hallyn <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Date: Mon, 13 Aug 2012 13:18:15 -0700
Message-Id: <1344889115-21610-1-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <87ehnav9n5.fsf@xmission.com>
References: <87ehnav9n5.fsf@xmission.com>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1967UtmLxgN8XbgQ7JX+ALhMAZtxa/dILI=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0023]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;<netdev@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH 01/21] userns: Convert net/core/scm.c to use kuids and kgids
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

With the existence of kuid_t and kgid_t we can take this further
and remove the usage of struct cred altogether, ensuring we
don't get cache line misses from reference counts.   For now
however start simply and do a straight forward conversion
I can be certain is correct.

In cred_to_ucred use from_kuid_munged and from_kgid_munged
as these values are going directly to userspace and we want to use
the userspace safe values not -1 when reporting a value that does not
map.  The earlier conversion that used from_kuid was buggy in that
respect.  Oops.

Cc: Eric Dumazet <eric.dumazet@gmail.com>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 net/core/scm.c  |   31 +++++++++++++++++++++++--------
 net/core/sock.c |    4 ++--
 2 files changed, 25 insertions(+), 10 deletions(-)

diff --git a/net/core/scm.c b/net/core/scm.c
index 8f6ccfd..5472ae7 100644
--- a/net/core/scm.c
+++ b/net/core/scm.c
@@ -45,12 +45,17 @@
 static __inline__ int scm_check_creds(struct ucred *creds)
 {
 	const struct cred *cred = current_cred();
+	kuid_t uid = make_kuid(cred->user_ns, creds->uid);
+	kgid_t gid = make_kgid(cred->user_ns, creds->gid);
+
+	if (!uid_valid(uid) || !gid_valid(gid))
+		return -EINVAL;
 
 	if ((creds->pid == task_tgid_vnr(current) || capable(CAP_SYS_ADMIN)) &&
-	    ((creds->uid == cred->uid   || creds->uid == cred->euid ||
-	      creds->uid == cred->suid) || capable(CAP_SETUID)) &&
-	    ((creds->gid == cred->gid   || creds->gid == cred->egid ||
-	      creds->gid == cred->sgid) || capable(CAP_SETGID))) {
+	    ((uid_eq(uid, cred->uid)   || uid_eq(uid, cred->euid) ||
+	      uid_eq(uid, cred->suid)) || capable(CAP_SETUID)) &&
+	    ((gid_eq(gid, cred->gid)   || gid_eq(gid, cred->egid) ||
+	      gid_eq(gid, cred->sgid)) || capable(CAP_SETGID))) {
 	       return 0;
 	}
 	return -EPERM;
@@ -149,6 +154,9 @@ int __scm_send(struct socket *sock, struct msghdr *msg, struct scm_cookie *p)
 				goto error;
 			break;
 		case SCM_CREDENTIALS:
+		{
+			kuid_t uid;
+			kgid_t gid;
 			if (cmsg->cmsg_len != CMSG_LEN(sizeof(struct ucred)))
 				goto error;
 			memcpy(&p->creds, CMSG_DATA(cmsg), sizeof(struct ucred));
@@ -166,22 +174,29 @@ int __scm_send(struct socket *sock, struct msghdr *msg, struct scm_cookie *p)
 				p->pid = pid;
 			}
 
+			err = -EINVAL;
+			uid = make_kuid(current_user_ns(), p->creds.uid);
+			gid = make_kgid(current_user_ns(), p->creds.gid);
+			if (!uid_valid(uid) || !gid_valid(gid))
+				goto error;
+
 			if (!p->cred ||
-			    (p->cred->euid != p->creds.uid) ||
-			    (p->cred->egid != p->creds.gid)) {
+			    !uid_eq(p->cred->euid, uid) ||
+			    !gid_eq(p->cred->egid, gid)) {
 				struct cred *cred;
 				err = -ENOMEM;
 				cred = prepare_creds();
 				if (!cred)
 					goto error;
 
-				cred->uid = cred->euid = p->creds.uid;
-				cred->gid = cred->egid = p->creds.gid;
+				cred->uid = cred->euid = uid;
+				cred->gid = cred->egid = gid;
 				if (p->cred)
 					put_cred(p->cred);
 				p->cred = cred;
 			}
 			break;
+		}
 		default:
 			goto error;
 		}
diff --git a/net/core/sock.c b/net/core/sock.c
index 6b654b3..9c7fe4f 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -868,8 +868,8 @@ void cred_to_ucred(struct pid *pid, const struct cred *cred,
 	if (cred) {
 		struct user_namespace *current_ns = current_user_ns();
 
-		ucred->uid = from_kuid(current_ns, cred->euid);
-		ucred->gid = from_kgid(current_ns, cred->egid);
+		ucred->uid = from_kuid_munged(current_ns, cred->euid);
+		ucred->gid = from_kgid_munged(current_ns, cred->egid);
 	}
 }
 EXPORT_SYMBOL_GPL(cred_to_ucred);
-- 
1.7.5.4

