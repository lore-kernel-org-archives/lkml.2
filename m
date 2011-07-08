Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890Ab1GHFEQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 01:04:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42324 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754827Ab1GHFEO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 01:04:14 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Jul  7 17:16:59 2011
Message-Id: <20110708001659.570406119@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 07 Jul 2011 17:16:42 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Andy Adamson <andros@netapp.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [070/107] NFSv4.1: allow zero fh array in filelayout decode layout
In-Reply-To: <20110708001740.GA14031@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Andy Adamson <andros@netapp.com>

commit cec765cf5891c7fc3d905832b481bfb6fd55825d upstream.

Signed-off-by: Andy Adamson <andros@netapp.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfs/nfs4filelayout.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/fs/nfs/nfs4filelayout.c
+++ b/fs/nfs/nfs4filelayout.c
@@ -554,13 +554,18 @@ filelayout_decode_layout(struct pnfs_lay
 		__func__, nfl_util, fl->num_fh, fl->first_stripe_index,
 		fl->pattern_offset);
 
-	if (!fl->num_fh)
+	/* Note that a zero value for num_fh is legal for STRIPE_SPARSE.
+	 * Futher checking is done in filelayout_check_layout */
+	if (fl->num_fh < 0 || fl->num_fh >
+	    max(NFS4_PNFS_MAX_STRIPE_CNT, NFS4_PNFS_MAX_MULTI_CNT))
 		goto out_err;
 
-	fl->fh_array = kzalloc(fl->num_fh * sizeof(struct nfs_fh *),
-			       gfp_flags);
-	if (!fl->fh_array)
-		goto out_err;
+	if (fl->num_fh > 0) {
+		fl->fh_array = kzalloc(fl->num_fh * sizeof(struct nfs_fh *),
+				       gfp_flags);
+		if (!fl->fh_array)
+			goto out_err;
+	}
 
 	for (i = 0; i < fl->num_fh; i++) {
 		/* Do we want to use a mempool here? */


