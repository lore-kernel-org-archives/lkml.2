Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932872Ab2AXCsm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 21:48:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50642 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932840Ab2AXCsi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 21:48:38 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 23 18:39:34 2012
Message-Id: <20120124023934.532008617@clark.kroah.org>
User-Agent: quilt/0.50-11.1
Date: Mon, 23 Jan 2012 18:35:39 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org, xfs@oss.sgi.com,
        bpm@sgi.com
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Dave Chinner <dchinner@redhat.com>
Subject: [119/129] xfs: fix endian conversion issue in discard code
In-Reply-To: <20120124024041.GA18422@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------
Content-Length: 1239
Lines: 39

From: Dave Chinner <dchinner@redhat.com>

commit b1c770c273a4787069306fc82aab245e9ac72e9d upstream

When finding the longest extent in an AG, we read the value directly
out of the AGF buffer without endian conversion. This will give an
incorrect length, resulting in FITRIM operations potentially not
trimming everything that it should.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ben Myers <bpm@sgi.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/xfs/xfs_discard.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -68,7 +68,7 @@ xfs_trim_extents(
 	 * Look up the longest btree in the AGF and start with it.
 	 */
 	error = xfs_alloc_lookup_le(cur, 0,
-				    XFS_BUF_TO_AGF(agbp)->agf_longest, &i);
+			    be32_to_cpu(XFS_BUF_TO_AGF(agbp)->agf_longest), &i);
 	if (error)
 		goto out_del_cursor;
 
@@ -84,7 +84,7 @@ xfs_trim_extents(
 		if (error)
 			goto out_del_cursor;
 		XFS_WANT_CORRUPTED_GOTO(i == 1, out_del_cursor);
-		ASSERT(flen <= XFS_BUF_TO_AGF(agbp)->agf_longest);
+		ASSERT(flen <= be32_to_cpu(XFS_BUF_TO_AGF(agbp)->agf_longest));
 
 		/*
 		 * Too small?  Give up.


