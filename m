Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932436Ab1DMP6G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 11:58:06 -0400
Received: from kroah.org ([198.145.64.141]:54603 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932320Ab1DMP4D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 11:56:03 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Apr 13 08:51:50 2011
Message-Id: <20110413155150.087072247@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 13 Apr 2011 08:51:30 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Neil Brown <neilb@suse.de>, "J. Bruce Fields" <bfields@redhat.com>
Subject: [66/74] nfsd: fix auth_domain reference leak on nlm operations
In-Reply-To: <20110413155406.GA22568@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

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


