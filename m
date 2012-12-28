Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495Ab2L1TRX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:17:23 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54961 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754384Ab2L1TRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:17:09 -0500
Message-Id: <20121228190402.100166257@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:06:16 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Ashish Sangwan <a.sangwan@samsung.com>, Jan Kara <jack@suse.cz>
Subject: [ 166/173] udf: fix memory leak while allocating blocks during write
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <namjae.jeon@samsung.com>

commit 2fb7d99d0de3fd8ae869f35ab682581d8455887a upstream.

Need to brelse the buffer_head stored in cur_epos and next_epos.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/udf/inode.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -744,6 +744,8 @@ static struct buffer_head *inode_getblk(
 				goal, err);
 		if (!newblocknum) {
 			brelse(prev_epos.bh);
+			brelse(cur_epos.bh);
+			brelse(next_epos.bh);
 			*err = -ENOSPC;
 			return NULL;
 		}
@@ -774,6 +776,8 @@ static struct buffer_head *inode_getblk(
 	udf_update_extents(inode, laarr, startnum, endnum, &prev_epos);
 
 	brelse(prev_epos.bh);
+	brelse(cur_epos.bh);
+	brelse(next_epos.bh);
 
 	newblock = udf_get_pblock(inode->i_sb, newblocknum,
 				iinfo->i_location.partitionReferenceNum, 0);


