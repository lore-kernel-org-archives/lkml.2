Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755009Ab1JWGjN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 02:39:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40050 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752660Ab1JWGeH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 02:34:07 -0400
X-Mailbox-Line: From gregkh@pistachio.kroah.org Sun Oct 23 08:25:40 2011
Message-Id: <20111023062540.075577077@pistachio.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Sun, 23 Oct 2011 08:24:46 +0200
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: stable-review@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, greg@kroah.com,
        Christoph Hellwig <hch@lst.de>
Subject: [18/27] xfs: do not update xa_last_pushed_lsn for locked items
In-Reply-To: <20111023062833.GA8126@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Christoph Hellwig <hch@infradead.org>

commit bc6e588a8971aa74c02e42db4d6e0248679f3738 upstream

If an item was locked we should not update xa_last_pushed_lsn and thus skip
it when restarting the AIL scan as we need to be able to lock and write it
out as soon as possible.  Otherwise heavy lock contention might starve AIL
pushing too easily, especially given the larger backoff once we moved
xa_last_pushed_lsn all the way to the target lsn.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reported-by: Stefan Priebe <s.priebe@profihost.ag>
Tested-by: Stefan Priebe <s.priebe@profihost.ag>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/xfs/xfs_trans_ail.c |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -491,7 +491,6 @@ xfs_ail_worker(
 
 		case XFS_ITEM_LOCKED:
 			XFS_STATS_INC(xs_push_ail_locked);
-			ailp->xa_last_pushed_lsn = lsn;
 			stuck++;
 			break;
 


