Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756404Ab2KZRCP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:02:15 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47183 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755582Ab2KZRCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:02:11 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "J. Bruce Fields" <bfields@redhat.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 039/270] nfsd4: don't pin clientids to pseudoflavors
Date: Mon, 26 Nov 2012 14:55:29 -0200
Message-Id: <1353949160-26803-40-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 fs/nfsd/nfs4state.c |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index be324aa..02ac082 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -1215,10 +1215,26 @@ static bool groups_equal(struct group_info *g1, struct group_info *g2)
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
-- 
1.7.9.5

