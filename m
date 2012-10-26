Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657Ab2JZAFe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 20:05:34 -0400
Received: from mail.kernel.org ([198.145.19.201]:52270 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752598Ab2JZAF3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 20:05:29 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Larry McVoy <lm@bitmover.com>, "J. Bruce Fields" <bfields@redhat.com>
Subject: [ 02/31] NLM: nlm_lookup_file() may return NLMv4-specific error codes
Date: Thu, 25 Oct 2012 17:04:09 -0700
Message-Id: <20121026000215.191461554@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121026000214.941721299@linuxfoundation.org>
References: <20121026000214.941721299@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/lockd/clntxdr.c |    2 +-
 fs/lockd/svcproc.c |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/fs/lockd/clntxdr.c
+++ b/fs/lockd/clntxdr.c
@@ -223,7 +223,7 @@ static void encode_nlm_stat(struct xdr_s
 {
 	__be32 *p;
 
-	BUG_ON(be32_to_cpu(stat) > NLM_LCK_DENIED_GRACE_PERIOD);
+	WARN_ON_ONCE(be32_to_cpu(stat) > NLM_LCK_DENIED_GRACE_PERIOD);
 	p = xdr_reserve_space(xdr, 4);
 	*p = stat;
 }
--- a/fs/lockd/svcproc.c
+++ b/fs/lockd/svcproc.c
@@ -67,7 +67,8 @@ nlmsvc_retrieve_args(struct svc_rqst *rq
 
 	/* Obtain file pointer. Not used by FREE_ALL call. */
 	if (filp != NULL) {
-		if ((error = nlm_lookup_file(rqstp, &file, &lock->fh)) != 0)
+		error = cast_status(nlm_lookup_file(rqstp, &file, &lock->fh));
+		if (error != 0)
 			goto no_locks;
 		*filp = file;
 


