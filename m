Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996Ab2IZIwu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 04:52:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32338 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755679Ab2IZIwH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 04:52:07 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Eric Sandeen <sandeen@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 26/27] GFS2: fix s_writers.counter imbalance in gfs2_ail_empty_gl
Date: Wed, 26 Sep 2012 09:25:47 +0100
Message-Id: <1348647948-3219-27-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1348647948-3219-1-git-send-email-swhiteho@redhat.com>
References: <1348647948-3219-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Sandeen <sandeen@redhat.com>

gfs2_ail_empty_gl() contains an "inline version" of gfs2_trans_begin(),
so it needs an explicit sb_start_intwrite() as well, to balance the
sb_end_intwrite() which will be called by gfs2_trans_end().

With this, xfstest 068 passes on lock_nolock local gfs2.
Without it, we reach a writer count of -1 and get stuck.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
index 4bdcf37..32cc4fd 100644
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -94,6 +94,7 @@ static void gfs2_ail_empty_gl(struct gfs2_glock *gl)
 	/* A shortened, inline version of gfs2_trans_begin() */
 	tr.tr_reserved = 1 + gfs2_struct2blk(sdp, tr.tr_revokes, sizeof(u64));
 	tr.tr_ip = (unsigned long)__builtin_return_address(0);
+	sb_start_intwrite(sdp->sd_vfs);
 	gfs2_log_reserve(sdp, tr.tr_reserved);
 	BUG_ON(current->journal_info);
 	current->journal_info = &tr;
-- 
1.7.4

