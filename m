Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841Ab0KPU1e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 15:27:34 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:6771 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444Ab0KPU1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 15:27:32 -0500
X-PGP-Universal: processed;
	by hqnvupgp04.nvidia.com on Tue, 16 Nov 2010 12:27:32 -0800
From: achew@nvidia.com
To: zhangtianfei@leadcoretech.com, hverkuil@xs4all.nl, pawel@osciak.com
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Chew <achew@nvidia.com>
Subject: [PATCH 1/1] videobuf: Initialize lists in videobuf_buffer.
Date: Tue, 16 Nov 2010 12:24:43 -0800
Message-Id: <1289939083-27209-1-git-send-email-achew@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
X-OriginalArrivalTime: 16 Nov 2010 20:27:27.0948 (UTC) FILETIME=[AFCD48C0:01CB85CC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Chew <achew@nvidia.com>

There are two struct list_head's in struct videobuf_buffer.
Prior to this fix, all we did for initialization of struct videobuf_buffer
was to zero out its memory.  This does not properly initialize this struct's
two list_head members.

This patch immediately calls INIT_LIST_HEAD on both lists after the kzalloc,
so that the two lists are initialized properly.

Signed-off-by: Andrew Chew <achew@nvidia.com>
---
I thought I'd submit a patch for this anyway.  Without this, the existing
camera host drivers will spew an ugly warning on every videobuf allocation,
which gets annoying really fast.

 drivers/media/video/videobuf-dma-contig.c |    2 ++
 drivers/media/video/videobuf-dma-sg.c     |    2 ++
 drivers/media/video/videobuf-vmalloc.c    |    2 ++
 3 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/videobuf-dma-contig.c b/drivers/media/video/videobuf-dma-contig.c
index c969111..f7e0f86 100644
--- a/drivers/media/video/videobuf-dma-contig.c
+++ b/drivers/media/video/videobuf-dma-contig.c
@@ -193,6 +193,8 @@ static struct videobuf_buffer *__videobuf_alloc_vb(size_t size)
 	if (vb) {
 		mem = vb->priv = ((char *)vb) + size;
 		mem->magic = MAGIC_DC_MEM;
+		INIT_LIST_HEAD(&vb->stream);
+		INIT_LIST_HEAD(&vb->queue);
 	}
 
 	return vb;
diff --git a/drivers/media/video/videobuf-dma-sg.c b/drivers/media/video/videobuf-dma-sg.c
index 20f227e..5af3217 100644
--- a/drivers/media/video/videobuf-dma-sg.c
+++ b/drivers/media/video/videobuf-dma-sg.c
@@ -430,6 +430,8 @@ static struct videobuf_buffer *__videobuf_alloc_vb(size_t size)
 
 	mem = vb->priv = ((char *)vb) + size;
 	mem->magic = MAGIC_SG_MEM;
+	INIT_LIST_HEAD(&vb->stream);
+	INIT_LIST_HEAD(&vb->queue);
 
 	videobuf_dma_init(&mem->dma);
 
diff --git a/drivers/media/video/videobuf-vmalloc.c b/drivers/media/video/videobuf-vmalloc.c
index df14258..8babedd 100644
--- a/drivers/media/video/videobuf-vmalloc.c
+++ b/drivers/media/video/videobuf-vmalloc.c
@@ -146,6 +146,8 @@ static struct videobuf_buffer *__videobuf_alloc_vb(size_t size)
 
 	mem = vb->priv = ((char *)vb) + size;
 	mem->magic = MAGIC_VMAL_MEM;
+	INIT_LIST_HEAD(&vb->stream);
+	INIT_LIST_HEAD(&vb->queue);
 
 	dprintk(1, "%s: allocated at %p(%ld+%ld) & %p(%ld)\n",
 		__func__, vb, (long)sizeof(*vb), (long)size - sizeof(*vb),
-- 
1.7.0.4

