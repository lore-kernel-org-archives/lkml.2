Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005Ab1DYUXw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:23:52 -0400
Received: from 1wt.eu ([62.212.114.60]:33826 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756242Ab1DYUXt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:23:49 -0400
Message-Id: <20110425200235.074681712@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:03:20 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: NeilBrown <neilb@suse.de>, "J. Bruce Fields" <bfields@redhat.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 048/173] nfsd: correctly handle return value from nfsd_map_name_to_*
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

------------------

From: NeilBrown <neilb@suse.de>

commit 47c85291d3dd1a51501555000b90f8e281a0458e upstream.

These functions return an nfs status, not a host_err.  So don't
try to convert  before returning.

This is a regression introduced by
3c726023402a2f3b28f49b9d90ebf9e71151157d; I fixed up two of the callers,
but missed these two.

Reported-by: Herbert Poetzl <herbert@13thfloor.at>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfsd/nfs4xdr.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -323,8 +323,8 @@ nfsd4_decode_fattr(struct nfsd4_compound
 		READ_BUF(dummy32);
 		len += (XDR_QUADLEN(dummy32) << 2);
 		READMEM(buf, dummy32);
-		if ((host_err = nfsd_map_name_to_uid(argp->rqstp, buf, dummy32, &iattr->ia_uid)))
-			goto out_nfserr;
+		if ((status = nfsd_map_name_to_uid(argp->rqstp, buf, dummy32, &iattr->ia_uid)))
+			return status;
 		iattr->ia_valid |= ATTR_UID;
 	}
 	if (bmval[1] & FATTR4_WORD1_OWNER_GROUP) {
@@ -334,8 +334,8 @@ nfsd4_decode_fattr(struct nfsd4_compound
 		READ_BUF(dummy32);
 		len += (XDR_QUADLEN(dummy32) << 2);
 		READMEM(buf, dummy32);
-		if ((host_err = nfsd_map_name_to_gid(argp->rqstp, buf, dummy32, &iattr->ia_gid)))
-			goto out_nfserr;
+		if ((status = nfsd_map_name_to_gid(argp->rqstp, buf, dummy32, &iattr->ia_gid)))
+			return status;
 		iattr->ia_valid |= ATTR_GID;
 	}
 	if (bmval[1] & FATTR4_WORD1_TIME_ACCESS_SET) {


