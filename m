Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152Ab2GWI0e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 04:26:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19722 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754121Ab2GWI0a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 04:26:30 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Abhijith Das <adas@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 14/16] GFS2: kernel panic with small gfs2 filesystems - 1 RG
Date: Mon, 23 Jul 2012 09:01:04 +0100
Message-Id: <1343030466-3053-15-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1343030466-3053-1-git-send-email-swhiteho@redhat.com>
References: <1343030466-3053-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Abhijith Das <adas@redhat.com>

In the unlikely setup where there's only one resource group in the gfs2
filesystem, gfs2_rgrpd_get_next() returns a NULL rgd that is not dealt with
properly, causing a kernel NULL ptr dereference. This patch fixes this issue.

Signed-off-by: Abhi Das <adas@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index e53d0a1..fb70792 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -1276,6 +1276,7 @@ int gfs2_inplace_reserve(struct gfs2_inode *ip, u32 requested)
 			/* fall through */
 		case GLR_TRYFAILED:
 			rgd = gfs2_rgrpd_get_next(rgd);
+			rgd = rgd ? : begin; /* if NULL, wrap */
 			if (rgd != begin) /* If we didn't wrap */
 				break;
 
-- 
1.7.4

