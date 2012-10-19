Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030371Ab2JSDJ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 23:09:29 -0400
Received: from mail.kernel.org ([198.145.19.201]:51846 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757505Ab2JSCsU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 22:48:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [ 05/76] nfsd4: dont pin clientids to pseudoflavors
Date: Thu, 18 Oct 2012 19:46:29 -0700
Message-Id: <20121019024350.943985390@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121019024350.087156547@linuxfoundation.org>
References: <20121019024350.087156547@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "J. Bruce Fields" <bfields@redhat.com>

commit 68eb35081e297b37db49d854cda144c6a3397699 upstream.

I added cr_flavor to the data compared in same_creds without any
justification, in d5497fc693a446ce9100fcf4117c3f795ddfd0d2 "nfsd4: move
rq_flavor into svc_cred".

Recent client changes then started making

	mount -osec=krb5 server:/export /mnt/
	echo "hello" >/mnt/TMP
	umount /mnt/
	mount -osec=krb5i server:/export /mnt/
	echo "hello" >/mnt/TMP

to fail due to a clid_inuse on the second open.

Mounting sequentially like this with different flavors probably isn't
that common outside artificial tests.  Also, the real bug here may be
that the server isn't just destroying the former clientid in this case
(because it isn't good enough at recognizing when the old state is
gone).  But it prompted some discussion and a look back at the spec, and
I think the check was probably wrong.  Fix and document.

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfsd/nfs4state.c |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -1223,10 +1223,26 @@ static bool groups_equal(struct group_in
 	return true;
 }
 
+/*
+ * RFC 3530 language requires clid_inuse be returned when the
+ * "principal" associated with a requests differs from that previously
+ * used.  We use uid, gid's, and gss principal string as our best
+ * approximation.  We also don't want to allow non-gss use of a client
+ * established using gss: in theory cr_principal should catch that
+ * change, but in practice cr_principal can be null even in the gss case
+ * since gssd doesn't always pass down a principal string.
+ */
+static bool is_gss_cred(struct svc_cred *cr)
+{
+	/* Is cr_flavor one of the gss "pseudoflavors"?: */
+	return (cr->cr_flavor > RPC_AUTH_MAXFLAVOR);
+}
+
+
 static bool
 same_creds(struct svc_cred *cr1, struct svc_cred *cr2)
 {
-	if ((cr1->cr_flavor != cr2->cr_flavor)
+	if ((is_gss_cred(cr1) != is_gss_cred(cr2))
 		|| (cr1->cr_uid != cr2->cr_uid)
 		|| (cr1->cr_gid != cr2->cr_gid)
 		|| !groups_equal(cr1->cr_group_info, cr2->cr_group_info))


