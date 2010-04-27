Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055Ab0D0GVF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 02:21:05 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:45744 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202Ab0D0GVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 02:21:01 -0400
From: Tao Ma <tao.ma@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Tao Ma <tao.ma@oracle.com>, xfs@oss.sgi.com,
       Eric Sandeen <sandeen@redhat.com>, Christoph Hellwig <hch@lst.de>,
       Alex Elder <aelder@sgi.com>
Subject: [PATCH] XFS: Let the broken fiemap work in query mode.
Date: Tue, 27 Apr 2010 14:17:45 +0800
Message-Id: <1272349065-16383-1-git-send-email-tao.ma@oracle.com>
X-Mailer: git-send-email 1.6.3.3
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090207.4BD6823B.0097:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to Documentation/filesystems/fiemap.txt, If fm_extent_count
is zero, then the fm_extents[] array is ignored (no extents will be
returned), and the fm_mapped_extents count will hold the number of
extents needed.

But as the commit 97db39a1f6f69e906e98118392400de5217aa33a has changed
bmv_count to the caller's input buffer, this number query function can't
work any more. As this commit is written to change bmv_count from
MAXEXTNUM because of ENOMEM, we can't find a really suitable number to
set bmv_count now in xfs_vn_fiemap. Since we really have no idea of how
much extents the file has, a big number may cause ENOMEM, while a small
one will mask the real extent no.

So this patch try to resolve this problem by adding a temporary getbmapx
in xfs_getbmap. If the caller didn't give bmv_count, we don't allocate
the "out" either. Instead, every time we want to use 'out', use '&tmp'
instead.

I know this solution is a bit ugly, but I can't find a way to resolve
this issue while not changing the codes too much. So any good suggestion
is welcomed.

Cc: Eric Sandeen <sandeen@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Alex Elder <aelder@sgi.com>
Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/xfs/xfs_bmap.c |   47 +++++++++++++++++++++++++++++------------------
 1 files changed, 29 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index 98251cd..654d9cf 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -5557,13 +5557,14 @@ xfs_getbmap(
 	int			nexleft;	/* # of user extents left */
 	int			subnex;		/* # of bmapi's can do */
 	int			nmap;		/* number of map entries */
-	struct getbmapx		*out;		/* output structure */
+	struct getbmapx		*out = NULL;	/* output structure */
 	int			whichfork;	/* data or attr fork */
 	int			prealloced;	/* this is a file with
 						 * preallocated data space */
 	int			iflags;		/* interface flags */
 	int			bmapi_flags;	/* flags for xfs_bmapi */
 	int			cur_ext = 0;
+	struct getbmapx		tmp, *bmap;
 
 	mp = ip->i_mount;
 	iflags = bmv->bmv_iflags;
@@ -5635,16 +5636,20 @@ xfs_getbmap(
 	}
 
 	nex = bmv->bmv_count - 1;
-	if (nex <= 0)
+	if (nex < 0)
 		return XFS_ERROR(EINVAL);
 	bmvend = bmv->bmv_offset + bmv->bmv_length;
 
 
 	if (bmv->bmv_count > ULONG_MAX / sizeof(struct getbmapx))
 		return XFS_ERROR(ENOMEM);
-	out = kmem_zalloc(bmv->bmv_count * sizeof(struct getbmapx), KM_MAYFAIL);
-	if (!out)
-		return XFS_ERROR(ENOMEM);
+	if (nex) {
+		out = kmem_zalloc(bmv->bmv_count * sizeof(struct getbmapx),
+				  KM_MAYFAIL);
+		if (!out)
+			return XFS_ERROR(ENOMEM);
+	} else
+		nex = MAXEXTNUM;
 
 	xfs_ilock(ip, XFS_IOLOCK_SHARED);
 	if (whichfork == XFS_DATA_FORK && !(iflags & BMV_IF_DELALLOC)) {
@@ -5700,35 +5705,37 @@ xfs_getbmap(
 		ASSERT(nmap <= subnex);
 
 		for (i = 0; i < nmap && nexleft && bmv->bmv_length; i++) {
-			out[cur_ext].bmv_oflags = 0;
+			if (out)
+				bmap = &out[cur_ext];
+			else
+				bmap = &tmp;
+			bmap->bmv_oflags = 0;
 			if (map[i].br_state == XFS_EXT_UNWRITTEN)
-				out[cur_ext].bmv_oflags |= BMV_OF_PREALLOC;
+				bmap->bmv_oflags |= BMV_OF_PREALLOC;
 			else if (map[i].br_startblock == DELAYSTARTBLOCK)
-				out[cur_ext].bmv_oflags |= BMV_OF_DELALLOC;
-			out[cur_ext].bmv_offset =
+				bmap->bmv_oflags |= BMV_OF_DELALLOC;
+			bmap->bmv_offset =
 				XFS_FSB_TO_BB(mp, map[i].br_startoff);
-			out[cur_ext].bmv_length =
+			bmap->bmv_length =
 				XFS_FSB_TO_BB(mp, map[i].br_blockcount);
-			out[cur_ext].bmv_unused1 = 0;
-			out[cur_ext].bmv_unused2 = 0;
+			bmap->bmv_unused1 = 0;
+			bmap->bmv_unused2 = 0;
 			ASSERT(((iflags & BMV_IF_DELALLOC) != 0) ||
 			      (map[i].br_startblock != DELAYSTARTBLOCK));
                         if (map[i].br_startblock == HOLESTARTBLOCK &&
 			    whichfork == XFS_ATTR_FORK) {
 				/* came to the end of attribute fork */
-				out[cur_ext].bmv_oflags |= BMV_OF_LAST;
+				bmap->bmv_oflags |= BMV_OF_LAST;
 				goto out_free_map;
 			}
 
-			if (!xfs_getbmapx_fix_eof_hole(ip, &out[cur_ext],
+			if (!xfs_getbmapx_fix_eof_hole(ip, bmap,
 					prealloced, bmvend,
 					map[i].br_startblock))
 				goto out_free_map;
 
 			nexleft--;
-			bmv->bmv_offset =
-				out[cur_ext].bmv_offset +
-				out[cur_ext].bmv_length;
+			bmv->bmv_offset = bmap->bmv_offset + bmap->bmv_length;
 			bmv->bmv_length =
 				max_t(__int64_t, 0, bmvend - bmv->bmv_offset);
 			bmv->bmv_entries++;
@@ -5746,8 +5753,12 @@ xfs_getbmap(
 	for (i = 0; i < cur_ext; i++) {
 		int full = 0;	/* user array is full */
 
+		if (out)
+			bmap = &out[i];
+		else
+			bmap = &tmp;
 		/* format results & advance arg */
-		error = formatter(&arg, &out[i], &full);
+		error = formatter(&arg, bmap, &full);
 		if (error || full)
 			break;
 	}
-- 
1.6.3.3.334.g916e1.dirty

