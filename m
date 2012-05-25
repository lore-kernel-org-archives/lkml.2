Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122Ab2EYV4w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 17:56:52 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:51339 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753260Ab2EYV4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 17:56:49 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: jbeulich@suse.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, axboe@kernel.dk
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, stable@kernel.org
Subject: [PATCH 1/2] xen/blkback: Copy id field when doing BLKIF_DISCARD.
Date: Fri, 25 May 2012 17:50:02 -0400
Message-Id: <1337982603-15692-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1337982603-15692-1-git-send-email-konrad.wilk@oracle.com>
References: <1337982603-15692-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We weren't copying the id field so when we sent the response
back to the frontend (especially with a 64-bit host and 32-bit
guest), we ended up using a random value. This lead to the
frontend crashing as it would try to pass to __blk_end_request_all
a NULL 'struct request' (b/c it would use the 'id' to find the
proper 'struct request' in its shadow array) and end up crashing:

BUG: unable to handle kernel NULL pointer dereference at 000000e4
IP: [<c0646d4c>] __blk_end_request_all+0xc/0x40
.. snip..
EIP is at __blk_end_request_all+0xc/0x40
.. snip..
 [<ed95db72>] blkif_interrupt+0x172/0x330 [xen_blkfront]

This fixes the bug by passing in the proper id for the response.

Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=824641
CC: stable@kernel.org
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/block/xen-blkback/common.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/block/xen-blkback/common.h b/drivers/block/xen-blkback/common.h
index 773cf27..9ad3b5e 100644
--- a/drivers/block/xen-blkback/common.h
+++ b/drivers/block/xen-blkback/common.h
@@ -257,6 +257,7 @@ static inline void blkif_get_x86_32_req(struct blkif_request *dst,
 		break;
 	case BLKIF_OP_DISCARD:
 		dst->u.discard.flag = src->u.discard.flag;
+		dst->u.discard.id = src->u.discard.id;
 		dst->u.discard.sector_number = src->u.discard.sector_number;
 		dst->u.discard.nr_sectors = src->u.discard.nr_sectors;
 		break;
@@ -287,6 +288,7 @@ static inline void blkif_get_x86_64_req(struct blkif_request *dst,
 		break;
 	case BLKIF_OP_DISCARD:
 		dst->u.discard.flag = src->u.discard.flag;
+		dst->u.discard.id = src->u.discard.id;
 		dst->u.discard.sector_number = src->u.discard.sector_number;
 		dst->u.discard.nr_sectors = src->u.discard.nr_sectors;
 		break;
-- 
1.7.7.6

