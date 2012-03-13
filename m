Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758510Ab2CMBDS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 21:03:18 -0400
Received: from mail.windriver.com ([147.11.1.11]:47486 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758453Ab2CMAWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:22:08 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, "J. Bruce Fields" <bfields@redhat.com>,
        Neil Brown <neilb@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 053/196] nfsd: fix auth_domain reference leak on nlm operations
Date: Mon, 12 Mar 2012 20:19:26 -0400
Message-Id: <1331598109-31424-8-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "J. Bruce Fields" <bfields@redhat.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 954032d2527f2fce7355ba70709b5e143d6b686f upstream.

This was noticed by users who performed more than 2^32 lock operations
and hence made this counter overflow (eventually leading to
use-after-free's).  Setting rq_client to NULL here means that it won't
later get auth_domain_put() when it should be.

Appears to have been introduced in 2.5.42 by "[PATCH] kNFSd: Move auth
domain lookup into svcauth" which moved most of the rq_client handling
to common svcauth code, but left behind this one line.

Cc: Neil Brown <neilb@suse.de>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/nfsd/lockd.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/nfsd/lockd.c b/fs/nfsd/lockd.c
index 0c6d816..7c831a2 100644
--- a/fs/nfsd/lockd.c
+++ b/fs/nfsd/lockd.c
@@ -38,7 +38,6 @@ nlm_fopen(struct svc_rqst *rqstp, struct nfs_fh *f, struct file **filp)
 	exp_readlock();
 	nfserr = nfsd_open(rqstp, &fh, S_IFREG, NFSD_MAY_LOCK, filp);
 	fh_put(&fh);
-	rqstp->rq_client = NULL;
 	exp_readunlock();
  	/* We return nlm error codes as nlm doesn't know
 	 * about nfsd, but nfsd does know about nlm..
-- 
1.7.9.3

