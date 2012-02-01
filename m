Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757258Ab2BAVre (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:47:34 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:52374 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755383Ab2BAVIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:08:49 -0500
X-Sasl-enc: An05Yg/J+V2T9RdFrqP62mAiBJVeyUDvkL7WYtjIHEAp 1328130528
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Feb  1 12:57:38 2012
Message-Id: <20120201205738.890000901@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Wed, 01 Feb 2012 12:55:56 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org, xfs@oss.sgi.com,
        bpm@sgi.com
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Dave Chinner <dchinner@redhat.com>,
        Christoph Hellwig <hch@lst.de>
Subject: [16/65] xfs: fix endian conversion issue in discard code
In-Reply-To: <20120201210236.GA25966@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Dave Chinner <dchinner@redhat.com>

commit b1c770c273a4787069306fc82aab245e9ac72e9d upstream

When finding the longest extent in an AG, we read the value directly
out of the AGF buffer without endian conversion. This will give an
incorrect length, resulting in FITRIM operations potentially not
trimming everything that it should.

Note, for 3.0-stable this has been modified to apply to
fs/xfs/linux-2.6/xfs_discard.c instead of fs/xfs/xfs_discard.c.  -bpm

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ben Myers <bpm@sgi.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/xfs/linux-2.6/xfs_discard.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/xfs/linux-2.6/xfs_discard.c
+++ b/fs/xfs/linux-2.6/xfs_discard.c
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


