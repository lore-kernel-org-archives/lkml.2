Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932322Ab1DZVOc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:14:32 -0400
Received: from mga11.intel.com ([192.55.52.93]:60444 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932290Ab1DZVO3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:14:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,270,1301900400"; 
   d="scan'208";a="684327267"
From: Andi Kleen <andi@firstfloor.org>
References: <20110426212.641772347@firstfloor.org>
In-Reply-To: <20110426212.641772347@firstfloor.org>
To: bfields@redhat.com, neilb@suse.de, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [46/106] nfsd: fix auth_domain reference leak on nlm operations
Message-Id: <20110426211326.28FA63E1886@tassilo.jf.intel.com>
Date: Tue, 26 Apr 2011 14:13:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 fs/nfsd/lockd.c |    1 -
 1 file changed, 1 deletion(-)

Index: linux-2.6.35.y/fs/nfsd/lockd.c
===================================================================
--- linux-2.6.35.y.orig/fs/nfsd/lockd.c
+++ linux-2.6.35.y/fs/nfsd/lockd.c
@@ -38,7 +38,6 @@ nlm_fopen(struct svc_rqst *rqstp, struct
 	exp_readlock();
 	nfserr = nfsd_open(rqstp, &fh, S_IFREG, NFSD_MAY_LOCK, filp);
 	fh_put(&fh);
-	rqstp->rq_client = NULL;
 	exp_readunlock();
  	/* We return nlm error codes as nlm doesn't know
 	 * about nfsd, but nfsd does know about nlm..
