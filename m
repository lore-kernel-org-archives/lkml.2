Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756892Ab2J1X2F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 19:28:05 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42115 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756532Ab2J1X2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 19:28:02 -0400
Message-Id: <20121028231553.676959201@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 28 Oct 2012 23:16:30 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Larry McVoy <lm@bitmover.com>, "J. Bruce Fields" <bfields@redhat.com>
Subject: [ 054/105] NLM: nlm_lookup_file() may return NLMv4-specific error codes
In-Reply-To: <20121028231536.970033833@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
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
index 3009a36..21171f0 100644
--- a/fs/lockd/svcproc.c
+++ b/fs/lockd/svcproc.c
@@ -68,7 +68,8 @@ nlmsvc_retrieve_args(struct svc_rqst *rqstp, struct nlm_args *argp,
 
 	/* Obtain file pointer. Not used by FREE_ALL call. */
 	if (filp != NULL) {
-		if ((error = nlm_lookup_file(rqstp, &file, &lock->fh)) != 0)
+		error = cast_status(nlm_lookup_file(rqstp, &file, &lock->fh));
+		if (error != 0)
 			goto no_locks;
 		*filp = file;
 


