Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756719Ab1DYUYA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:24:00 -0400
Received: from 1wt.eu ([62.212.114.60]:33854 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756242Ab1DYUXz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:23:55 -0400
Message-Id: <20110425200234.901841857@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:03:16 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Steven Whitehouse <swhiteho@redhat.com>, maximilian attems <max@stro.at>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 044/173] GFS2: Fix bmap allocation corner-case bug
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Steven Whitehouse <swhiteho@redhat.com>

commit 07ccb7bf2c928fef4fea2cda69ba2e23479578db upstream.

This patch solves a corner case during allocation which occurs if both
metadata (indirect) and data blocks are required but there is an
obstacle in the filesystem (e.g. a resource group header or another
allocated block) such that when the allocation is requested only
enough blocks for the metadata are returned.

By changing the exit condition of this loop, we ensure that a
minimum of one data block will always be returned.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Cc: maximilian attems <max@stro.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/gfs2/bmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -541,7 +541,7 @@ static int gfs2_bmap_alloc(struct inode
 				*ptr++ = cpu_to_be64(bn++);
 			break;
 		}
-	} while (state != ALLOC_DATA);
+	} while ((state != ALLOC_DATA) || !dblock);
 
 	ip->i_height = height;
 	gfs2_add_inode_blocks(&ip->i_inode, alloced);


