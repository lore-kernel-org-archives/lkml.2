Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964925Ab1C3Voj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:44:39 -0400
Received: from mga09.intel.com ([134.134.136.24]:61735 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964835Ab1C3VHs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:07:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="727133351"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: neilb@suse.de, bfields@redhat.com, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [126/275] nfsd: correctly handle return value from nfsd_map_name_to_*
Message-Id: <20110330210606.5D2763E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:06:06 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 fs/nfsd/nfs4xdr.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6.35.y/fs/nfsd/nfs4xdr.c
===================================================================
--- linux-2.6.35.y.orig/fs/nfsd/nfs4xdr.c	2011-03-29 22:51:17.639271825 -0700
+++ linux-2.6.35.y/fs/nfsd/nfs4xdr.c	2011-03-29 23:54:22.675422220 -0700
@@ -316,8 +316,8 @@
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
@@ -327,8 +327,8 @@
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
