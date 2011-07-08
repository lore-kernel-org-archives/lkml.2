Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917Ab1GHFET (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 01:04:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42332 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754827Ab1GHFER (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 01:04:17 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Jul  7 17:16:59 2011
Message-Id: <20110708001659.672639189@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 07 Jul 2011 17:16:43 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [071/107] NFSv4: Fix a readdir regression
In-Reply-To: <20110708001740.GA14031@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit ee7b75fc4f3ae49e1f25bf56219bb5de3c29afaf upstream.

Commit 7ebb9315 (NFS: use secinfo when crossing mountpoints) introduces
a regression when decoding an NFSv4 readdir entry that sets the
rdattr_error field.
By treating the resulting value as if it is a decoding error, the current
code may cause us to skip valid readdir entries.

Reported-by: Andy Adamson <andros@netapp.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfs/nfs4xdr.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/fs/nfs/nfs4xdr.c
+++ b/fs/nfs/nfs4xdr.c
@@ -3030,7 +3030,7 @@ out_overflow:
 	return -EIO;
 }
 
-static int decode_attr_error(struct xdr_stream *xdr, uint32_t *bitmap)
+static int decode_attr_error(struct xdr_stream *xdr, uint32_t *bitmap, int32_t *res)
 {
 	__be32 *p;
 
@@ -3041,7 +3041,7 @@ static int decode_attr_error(struct xdr_
 		if (unlikely(!p))
 			goto out_overflow;
 		bitmap[0] &= ~FATTR4_WORD0_RDATTR_ERROR;
-		return -be32_to_cpup(p);
+		*res = -be32_to_cpup(p);
 	}
 	return 0;
 out_overflow:
@@ -4002,6 +4002,7 @@ static int decode_getfattr_attrs(struct
 	int status;
 	umode_t fmode = 0;
 	uint32_t type;
+	int32_t err;
 
 	status = decode_attr_type(xdr, bitmap, &type);
 	if (status < 0)
@@ -4027,13 +4028,12 @@ static int decode_getfattr_attrs(struct
 		goto xdr_error;
 	fattr->valid |= status;
 
-	status = decode_attr_error(xdr, bitmap);
-	if (status == -NFS4ERR_WRONGSEC) {
-		nfs_fixup_secinfo_attributes(fattr, fh);
-		status = 0;
-	}
+	err = 0;
+	status = decode_attr_error(xdr, bitmap, &err);
 	if (status < 0)
 		goto xdr_error;
+	if (err == -NFS4ERR_WRONGSEC)
+		nfs_fixup_secinfo_attributes(fattr, fh);
 
 	status = decode_attr_filehandle(xdr, bitmap, fh);
 	if (status < 0)


