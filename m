Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608Ab1B1QsG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 11:48:06 -0500
Received: from kroah.org ([198.145.64.141]:48018 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755399Ab1B1QhY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 11:37:24 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Feb 28 08:24:08 2011
Message-Id: <20110228162408.297899325@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Mon, 28 Feb 2011 08:22:47 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Steven Whitehouse <swhiteho@redhat.com>,
        maximilian attems <max@stro.at>
Subject: [26/68] GFS2: Fix bmap allocation corner-case bug
In-Reply-To: <20110228163502.GA27221@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

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


