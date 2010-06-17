Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932807Ab0FQI4U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 04:56:20 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:33583 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932663Ab0FQI4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 04:56:18 -0400
From: Tao Ma <tao.ma@oracle.com>
To: xfs@oss.sgi.com
Cc: linux-kernel@vger.kernel.org, Tao Ma <tao.ma@oracle.com>,
       Dave Chinner <david@fromorbit.com>, Alex Elder <aelder@sgi.com>,
       Christoph Hellwig <hch@lst.de>, Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH v2] xfs: Make fiemap works with sparse file.
Date: Thu, 17 Jun 2010 16:53:19 +0800
Message-Id: <1276764799-4837-1-git-send-email-tao.ma@oracle.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <20100614122912.GD6590@dastard>
References: <20100614122912.GD6590@dastard>
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090202.4C19E316.0040:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,
On 06/14/2010 08:29 PM, Dave Chinner wrote:
> I just had a thought - if you want to avoid holes being reported to
> fiemap, then add a BMV_IF_NO_HOLES flag to xfs_getbmap() and skip
> holes in the mappin gloop when this flag is set. That will make
> fiemap fill in the full number of extents without hacking the
> extent count...
Here is the updated one. I have used BVM_IF_NO_HOLES in xfs_getbmap
to skip increasing index 'cur_ext'. It is a bit ugly, see my commit
log. I guess maybe we can add another flag in xfs_bmapi so that it
don't even give us the holes?

Regards,
Tao

>From cee1765ffd3e2b003b837666b4620b5107ed9ddd Mon Sep 17 00:00:00 2001
From: Tao Ma <tao.ma@oracle.com>
Date: Thu, 17 Jun 2010 16:14:22 +0800
Subject: [PATCH v3] xfs: Make fiemap works with sparse file.

In xfs_vn_fiemap, we set bvm_count to fi_extent_max + 1 and want
to return fi_extent_max extents, but actually it won't work for
a sparse file. The reason is that in xfs_getbmap we will
calculate holes and set it in 'out', while out is malloced by
bmv_count(fi_extent_max+1) which didn't consider holes. So in the
worst case, if 'out' vector looks like
[hole, extent, hole, extent, hole, ... hole, extent, hole],
we will only return half of fi_extent_max extents.

This patch add a new parameter BMV_IF_NO_HOLES for bvm_iflags.
So with this flags, we don't use our 'out' in xfs_getbmap for
a hole. The solution is a bit ugly by just don't increasing
index of 'out' vector. I felt that it is not easy to skip it
at the very beginning since we have the complicated check and
some function like xfs_getbmapx_fix_eof_hole to adjust 'out'.

Cc: Dave Chinner <david@fromorbit.com>
Cc: Alex Elder <aelder@sgi.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/xfs/linux-2.6/xfs_iops.c |    2 +-
 fs/xfs/xfs_bmap.c           |   14 +++++++++++++-
 fs/xfs/xfs_fs.h             |    4 +++-
 3 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_iops.c b/fs/xfs/linux-2.6/xfs_iops.c
index 9c8019c..505d5c0 100644
--- a/fs/xfs/linux-2.6/xfs_iops.c
+++ b/fs/xfs/linux-2.6/xfs_iops.c
@@ -677,7 +677,7 @@ xfs_vn_fiemap(
 					fieinfo->fi_extents_max + 1;
 	bm.bmv_count = min_t(__s32, bm.bmv_count,
 			     (PAGE_SIZE * 16 / sizeof(struct getbmapx)));
-	bm.bmv_iflags = BMV_IF_PREALLOC;
+	bm.bmv_iflags = BMV_IF_PREALLOC | BMV_IF_NO_HOLES;
 	if (fieinfo->fi_flags & FIEMAP_FLAG_XATTR)
 		bm.bmv_iflags |= BMV_IF_ATTRFORK;
 	if (!(fieinfo->fi_flags & FIEMAP_FLAG_SYNC))
diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index 99587de..d49107d 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -5744,12 +5744,24 @@ xfs_getbmap(
 					map[i].br_startblock))
 				goto out_free_map;
 
-			nexleft--;
 			bmv->bmv_offset =
 				out[cur_ext].bmv_offset +
 				out[cur_ext].bmv_length;
 			bmv->bmv_length =
 				max_t(__int64_t, 0, bmvend - bmv->bmv_offset);
+
+			/*
+			 * In case we don't want to return the hole,
+			 * don't increase cur_ext so that we can reuse
+			 * it in the next loop.
+			 */
+			if ((iflags & BMV_IF_NO_HOLES) &&
+			    out[cur_ext].bmv_block == -1LL) {
+				memset(&out[cur_ext], 0, sizeof(out[cur_ext]));
+				continue;
+			}
+
+			nexleft--;
 			bmv->bmv_entries++;
 			cur_ext++;
 		}
diff --git a/fs/xfs/xfs_fs.h b/fs/xfs/xfs_fs.h
index 7cf7220..87c2e9d 100644
--- a/fs/xfs/xfs_fs.h
+++ b/fs/xfs/xfs_fs.h
@@ -114,8 +114,10 @@ struct getbmapx {
 #define BMV_IF_NO_DMAPI_READ	0x2	/* Do not generate DMAPI read event  */
 #define BMV_IF_PREALLOC		0x4	/* rtn status BMV_OF_PREALLOC if req */
 #define BMV_IF_DELALLOC		0x8	/* rtn status BMV_OF_DELALLOC if req */
+#define BMV_IF_NO_HOLES		0x10	/* Do not return holes */
 #define BMV_IF_VALID	\
-	(BMV_IF_ATTRFORK|BMV_IF_NO_DMAPI_READ|BMV_IF_PREALLOC|BMV_IF_DELALLOC)
+	(BMV_IF_ATTRFORK|BMV_IF_NO_DMAPI_READ|BMV_IF_PREALLOC|	\
+	 BMV_IF_DELALLOC|BMV_IF_NO_HOLES)
 
 /*	bmv_oflags values - returned for each non-header segment */
 #define BMV_OF_PREALLOC		0x1	/* segment = unwritten pre-allocation */
-- 
1.5.5

