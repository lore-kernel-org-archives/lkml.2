Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756931Ab2AEMQ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 07:16:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755248Ab2AEMQ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 07:16:27 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 09/16] GFS2: O_(D)SYNC support for fallocate
Date: Thu,  5 Jan 2012 11:51:55 +0000
Message-Id: <1325764322-10807-10-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1325764322-10807-1-git-send-email-swhiteho@redhat.com>
References: <1325764322-10807-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add sync of metadata after fallocate for O_SYNC files to ensure that we
meet expectations for everything being on disk in this case.
Unfortunately, the offset and len parameters are modified during the
course of the fallocate function, so I've had to add a couple of new
variables to call generic_write_sync() at the end.

I know that potentially this will sync data as well within the range,
but I think that is a fairly harmless side-effect overall, since we
would not normally expect there to be any dirty data within the range in
question.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Benjamin Marzinski <bmarzins@redhat.com>

diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index 6336bc6..9b6c6ac 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -752,6 +752,8 @@ static long gfs2_fallocate(struct file *file, int mode, loff_t offset,
 	loff_t bytes, max_bytes;
 	struct gfs2_alloc *al;
 	int error;
+	const loff_t pos = offset;
+	const loff_t count = len;
 	loff_t bsize_mask = ~((loff_t)sdp->sd_sb.sb_bsize - 1);
 	loff_t next = (offset + len - 1) >> sdp->sd_sb.sb_bsize_shift;
 	loff_t max_chunk_size = UINT_MAX & bsize_mask;
@@ -834,6 +836,9 @@ retry:
 		gfs2_quota_unlock(ip);
 		gfs2_alloc_put(ip);
 	}
+
+	if (error == 0)
+		error = generic_write_sync(file, pos, count);
 	goto out_unlock;
 
 out_trans_fail:
-- 
1.7.4

