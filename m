Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637Ab0D1Olj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 10:41:39 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:50026 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875Ab0D1Oli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 10:41:38 -0400
From: Tao Ma <tao.ma@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Tao Ma <tao.ma@oracle.com>, xfs@oss.sgi.com,
       Christoph Hellwig <hch@lst.de>, Eric Sandeen <sandeen@redhat.com>,
       Alex Elder <aelder@sgi.com>
Subject: [PATCH v3] XFS: Let the broken fiemap work in query mode.
Date: Wed, 28 Apr 2010 22:39:09 +0800
Message-Id: <1272465549-6503-1-git-send-email-tao.ma@oracle.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <20100428113359.GB27769@infradead.org>
References: <20100428113359.GB27769@infradead.org>
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090209.4BD8490E.0171:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, Apr 28, 2010 at 11:00:25AM +0800, Tao Ma wrote:
>> -	bm.bmv_count = fieinfo->fi_extents_max + 1;
>> +	bm.bmv_count = !fieinfo->fi_extents_max ? MAXEXTNUM :
>> +					fieinfo->fi_extents_max + 1;
>> +	bm.bmv_count = MIN(bm.bmv_count,
>> +			   (__s32)(PAGE_SIZE * 16 / sizeof(struct getbmapx)));
>
> I would use min_t here instead of the case, but otherwise the patch
> looks good to me
>
>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Ok, here comes the v3. Thanks for the review.

Regards,
Tao

>From c735bccfbb925841545dcb1853fa8ffb3f3c8785 Mon Sep 17 00:00:00 2001
From: Tao Ma <tao.ma@oracle.com>
Date: Wed, 28 Apr 2010 21:57:32 +0800
Subject: [PATCH v3] XFS: Let the broken fiemap work in query mode.

According to Documentation/filesystems/fiemap.txt, If fm_extent_count
is zero, then the fm_extents[] array is ignored (no extents will be
returned), and the fm_mapped_extents count will hold the number of
extents needed.

But as the commit 97db39a1f6f69e906e98118392400de5217aa33a has changed
bmv_count to the caller's input buffer, this number query function can't
work any more. As this commit is written to change bmv_count from
MAXEXTNUM because of ENOMEM.

This patch just try to  set bm.bmv.count to something sane.
Thanks to Dave Chinner <david@fromorbit.com> for the suggestion.

Cc: Eric Sandeen <sandeen@redhat.com>
Cc: Alex Elder <aelder@sgi.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/xfs/linux-2.6/xfs_iops.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_iops.c b/fs/xfs/linux-2.6/xfs_iops.c
index 2259460..68531fc 100644
--- a/fs/xfs/linux-2.6/xfs_iops.c
+++ b/fs/xfs/linux-2.6/xfs_iops.c
@@ -662,7 +662,10 @@ xfs_vn_fiemap(
 		bm.bmv_length = BTOBB(length);
 
 	/* We add one because in getbmap world count includes the header */
-	bm.bmv_count = fieinfo->fi_extents_max + 1;
+	bm.bmv_count = !fieinfo->fi_extents_max ? MAXEXTNUM :
+					fieinfo->fi_extents_max + 1;
+	bm.bmv_count = min_t(__s32, bm.bmv_count,
+			     (PAGE_SIZE * 16 / sizeof(struct getbmapx)));
 	bm.bmv_iflags = BMV_IF_PREALLOC;
 	if (fieinfo->fi_flags & FIEMAP_FLAG_XATTR)
 		bm.bmv_iflags |= BMV_IF_ATTRFORK;
-- 
1.6.3.3.334.g916e1.dirty

