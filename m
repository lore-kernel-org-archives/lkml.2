Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932453Ab1DYUZY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:25:24 -0400
Received: from 1wt.eu ([62.212.114.60]:34503 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932382Ab1DYUZO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:25:14 -0400
Message-Id: <20110425200239.641255119@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:05:05 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Neil Brown <neilb@suse.de>, "J. Bruce Fields" <bfields@redhat.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 153/173] nfsd: fix auth_domain reference leak on nlm operations
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

------------------

From: J. Bruce Fields <bfields@redhat.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfsd/lockd.c |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/nfsd/lockd.c
+++ b/fs/nfsd/lockd.c
@@ -44,7 +44,6 @@ nlm_fopen(struct svc_rqst *rqstp, struct
 	exp_readlock();
 	nfserr = nfsd_open(rqstp, &fh, S_IFREG, NFSD_MAY_LOCK, filp);
 	fh_put(&fh);
-	rqstp->rq_client = NULL;
 	exp_readunlock();
  	/* We return nlm error codes as nlm doesn't know
 	 * about nfsd, but nfsd does know about nlm..


