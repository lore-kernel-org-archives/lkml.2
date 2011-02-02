Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753273Ab1BBAoG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:44:06 -0500
Received: from mga03.intel.com ([143.182.124.21]:11107 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753196Ab1BBAoB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:44:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="382960552"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: ebiederm@xmission.com, xemul@openvz.org, davem@davemloft.net,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [55/139] af_unix: Allow credentials to work across user and pid namespaces.
Message-Id: <20110202004411.638DD3E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:44:11 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
Upstream commit 7361c36c5224519b258219fe3d0e8abc865d8134

In unix_skb_parms store pointers to struct pid and struct cred instead
of raw uid, gid, and pid values, then translate the credentials on
reception into values that are meaningful in the receiving processes
namespaces.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Acked-by: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

Index: linux-2.6.35.y/include/net/af_unix.h
===================================================================
--- linux-2.6.35.y.orig/include/net/af_unix.h
+++ linux-2.6.35.y/include/net/af_unix.h
@@ -23,7 +23,8 @@ struct unix_address {
 };
 
 struct unix_skb_parms {
-	struct ucred		creds;		/* Skb credentials	*/
+	struct pid		*pid;		/* Skb credentials	*/
+	const struct cred	*cred;
 	struct scm_fp_list	*fp;		/* Passed files		*/
 #ifdef CONFIG_SECURITY_NETWORK
 	u32			secid;		/* Security ID		*/
@@ -31,7 +32,6 @@ struct unix_skb_parms {
 };
 
 #define UNIXCB(skb) 	(*(struct unix_skb_parms *)&((skb)->cb))
-#define UNIXCREDS(skb)	(&UNIXCB((skb)).creds)
 #define UNIXSID(skb)	(&UNIXCB((skb)).secid)
 
 #define unix_state_lock(s)	spin_lock(&unix_sk(s)->lock)
Index: linux-2.6.35.y/net/unix/af_unix.c
===================================================================
--- linux-2.6.35.y.orig/net/unix/af_unix.c
+++ linux-2.6.35.y/net/unix/af_unix.c
@@ -1306,18 +1306,20 @@ static void unix_detach_fds(struct scm_c
 	int i;
 
 	scm->fp = UNIXCB(skb).fp;
-	skb->destructor = sock_wfree;
 	UNIXCB(skb).fp = NULL;
 
 	for (i = scm->fp->count-1; i >= 0; i--)
 		unix_notinflight(scm->fp->fp[i]);
 }
 
-static void unix_destruct_fds(struct sk_buff *skb)
+static void unix_destruct_scm(struct sk_buff *skb)
 {
 	struct scm_cookie scm;
 	memset(&scm, 0, sizeof(scm));
-	unix_detach_fds(&scm, skb);
+	scm.pid  = UNIXCB(skb).pid;
+	scm.cred = UNIXCB(skb).cred;
+	if (UNIXCB(skb).fp)
+		unix_detach_fds(&scm, skb);
 
 	/* Alas, it calls VFS */
 	/* So fscking what? fput() had been SMP-safe since the last Summer */
@@ -1340,10 +1342,22 @@ static int unix_attach_fds(struct scm_co
 
 	for (i = scm->fp->count-1; i >= 0; i--)
 		unix_inflight(scm->fp->fp[i]);
-	skb->destructor = unix_destruct_fds;
 	return 0;
 }
 
+static int unix_scm_to_skb(struct scm_cookie *scm, struct sk_buff *skb, bool send_fds)
+{
+	int err = 0;
+	UNIXCB(skb).pid  = get_pid(scm->pid);
+	UNIXCB(skb).cred = get_cred(scm->cred);
+	UNIXCB(skb).fp = NULL;
+	if (scm->fp && send_fds)
+		err = unix_attach_fds(scm, skb);
+
+	skb->destructor = unix_destruct_scm;
+	return err;
+}
+
 /*
  *	Send AF_UNIX data.
  */
@@ -1400,12 +1414,9 @@ static int unix_dgram_sendmsg(struct kio
 	if (skb == NULL)
 		goto out;
 
-	memcpy(UNIXCREDS(skb), &siocb->scm->creds, sizeof(struct ucred));
-	if (siocb->scm->fp) {
-		err = unix_attach_fds(siocb->scm, skb);
-		if (err)
-			goto out_free;
-	}
+	err = unix_scm_to_skb(siocb->scm, skb, true);
+	if (err)
+		goto out_free;
 	unix_get_secdata(siocb->scm, skb);
 
 	skb_reset_transport_header(skb);
@@ -1575,16 +1586,14 @@ static int unix_stream_sendmsg(struct ki
 		 */
 		size = min_t(int, size, skb_tailroom(skb));
 
-		memcpy(UNIXCREDS(skb), &siocb->scm->creds, sizeof(struct ucred));
+
 		/* Only send the fds in the first buffer */
-		if (siocb->scm->fp && !fds_sent) {
-			err = unix_attach_fds(siocb->scm, skb);
-			if (err) {
-				kfree_skb(skb);
-				goto out_err;
-			}
-			fds_sent = true;
+		err = unix_scm_to_skb(siocb->scm, skb, !fds_sent);
+		if (err) {
+			kfree_skb(skb);
+			goto out_err;
 		}
+		fds_sent = true;
 
 		err = memcpy_fromiovec(skb_put(skb, size), msg->msg_iov, size);
 		if (err) {
@@ -1701,7 +1710,7 @@ static int unix_dgram_recvmsg(struct kio
 		siocb->scm = &tmp_scm;
 		memset(&tmp_scm, 0, sizeof(tmp_scm));
 	}
-	siocb->scm->creds = *UNIXCREDS(skb);
+	scm_set_cred(siocb->scm, UNIXCB(skb).pid, UNIXCB(skb).cred);
 	unix_set_secdata(siocb->scm, skb);
 
 	if (!(flags & MSG_PEEK)) {
@@ -1850,14 +1859,14 @@ static int unix_stream_recvmsg(struct ki
 
 		if (check_creds) {
 			/* Never glue messages from different writers */
-			if (memcmp(UNIXCREDS(skb), &siocb->scm->creds,
-				   sizeof(siocb->scm->creds)) != 0) {
+			if ((UNIXCB(skb).pid  != siocb->scm->pid) ||
+			    (UNIXCB(skb).cred != siocb->scm->cred)) {
 				skb_queue_head(&sk->sk_receive_queue, skb);
 				break;
 			}
 		} else {
 			/* Copy credentials */
-			siocb->scm->creds = *UNIXCREDS(skb);
+			scm_set_cred(siocb->scm, UNIXCB(skb).pid, UNIXCB(skb).cred);
 			check_creds = 1;
 		}
 
