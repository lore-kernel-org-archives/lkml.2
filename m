Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933536Ab2KZRK0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:10:26 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47790 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933488Ab2KZRKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:10:19 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 167/270] NLM: nlm_lookup_file() may return NLMv4-specific error codes
Date: Mon, 26 Nov 2012 14:57:37 -0200
Message-Id: <1353949160-26803-168-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit cd0b16c1c3cda12dbed1f8de8f1a9b0591990724 upstream.

If the filehandle is stale, or open access is denied for some reason,
nlm_fopen() may return one of the NLMv4-specific error codes nlm4_stale_fh
or nlm4_failed. These get passed right through nlm_lookup_file(),
and so when nlmsvc_retrieve_args() calls the latter, it needs to filter
the result through the cast_status() machinery.

Failure to do so, will trigger the BUG_ON() in encode_nlm_stat...

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Reported-by: Larry McVoy <lm@bitmover.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 fs/lockd/clntxdr.c |    2 +-
 fs/lockd/svcproc.c |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/lockd/clntxdr.c b/fs/lockd/clntxdr.c
index d269ada..982d267 100644
--- a/fs/lockd/clntxdr.c
+++ b/fs/lockd/clntxdr.c
@@ -223,7 +223,7 @@ static void encode_nlm_stat(struct xdr_stream *xdr,
 {
 	__be32 *p;
 
-	BUG_ON(be32_to_cpu(stat) > NLM_LCK_DENIED_GRACE_PERIOD);
+	WARN_ON_ONCE(be32_to_cpu(stat) > NLM_LCK_DENIED_GRACE_PERIOD);
 	p = xdr_reserve_space(xdr, 4);
 	*p = stat;
 }
diff --git a/fs/lockd/svcproc.c b/fs/lockd/svcproc.c
index d27aab1..d413af3 100644
--- a/fs/lockd/svcproc.c
+++ b/fs/lockd/svcproc.c
@@ -67,7 +67,8 @@ nlmsvc_retrieve_args(struct svc_rqst *rqstp, struct nlm_args *argp,
 
 	/* Obtain file pointer. Not used by FREE_ALL call. */
 	if (filp != NULL) {
-		if ((error = nlm_lookup_file(rqstp, &file, &lock->fh)) != 0)
+		error = cast_status(nlm_lookup_file(rqstp, &file, &lock->fh));
+		if (error != 0)
 			goto no_locks;
 		*filp = file;
 
-- 
1.7.9.5

