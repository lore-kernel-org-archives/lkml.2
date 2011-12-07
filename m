Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757456Ab1LGQTR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 11:19:17 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33379 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932084Ab1LGQTG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 11:19:06 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Dec  7 08:08:28 2011
Message-Id: <20111207160828.168239914@clark.kroah.org>
User-Agent: quilt/0.50-23.1
Date: Wed, 07 Dec 2011 08:07:28 -0800
From: Greg KH <gregkh@suse.de>
To: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        stable@kernel.org
Cc: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <alan@lxorguk.ukuu.org.uk>,
        "Fred Isaman , Trond Myklebust" <iisaman@netapp.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [68/80] NFS: Prevent 3.0 from crashing if it receives a partial layout
In-Reply-To: <20111207161256.GA7736@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

This is a backport of critical parts of
commit 7c24d9489f "NFSv4.1: File layout only supports whole file layouts"

It prevents the file layout driver from (incorrectly) using
partial layouts, but ignores the part of the referenced commmit that
relies on additional machinery to change the LAYOUTGET request
based on layout driver.

Signed-off-by: Fred Isaman <iisaman@netapp.com>
Acked-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfs/nfs4filelayout.c |    8 ++++++++
 fs/nfs/pnfs.c           |    3 ++-
 2 files changed, 10 insertions(+), 1 deletion(-)

--- a/fs/nfs/nfs4filelayout.c
+++ b/fs/nfs/nfs4filelayout.c
@@ -428,6 +428,14 @@ filelayout_check_layout(struct pnfs_layo
 
 	dprintk("--> %s\n", __func__);
 
+	/* FIXME: remove this check when layout segment support is added */
+	if (lgr->range.offset != 0 ||
+	    lgr->range.length != NFS4_MAX_UINT64) {
+		dprintk("%s Only whole file layouts supported. Use MDS i/o\n",
+			__func__);
+		goto out;
+	}
+
 	if (fl->pattern_offset > lgr->range.offset) {
 		dprintk("%s pattern_offset %lld too large\n",
 				__func__, fl->pattern_offset);
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -980,7 +980,8 @@ pnfs_update_layout(struct inode *ino,
 		arg.offset -= pg_offset;
 		arg.length += pg_offset;
 	}
-	arg.length = PAGE_CACHE_ALIGN(arg.length);
+	if (arg.length != NFS4_MAX_UINT64)
+		arg.length = PAGE_CACHE_ALIGN(arg.length);
 
 	lseg = send_layoutget(lo, ctx, &arg, gfp_flags);
 	if (!lseg && first) {


