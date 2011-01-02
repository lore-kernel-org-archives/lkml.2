Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080Ab1ABHXu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:23:50 -0500
Received: from mail.windriver.com ([147.11.1.11]:35801 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753966Ab1ABHXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:23:44 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Dan Rosenberg <drosenberg@vsecurity.com>,
        Dan Rosenberg <dan.j.rosenberg@gmail.com>,
        Thomas Winischhofer <thomas@winischhofer.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 133/260] drivers/video/sis/sis_main.c: prevent reading uninitialized stack memory
Date: Sun,  2 Jan 2011 02:17:09 -0500
Message-Id: <1293952756-15010-134-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:22:36.0009 (UTC) FILETIME=[D43BE590:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Rosenberg <drosenberg@vsecurity.com>

commit fd02db9de73faebc51240619c7c7f99bee9f65c7 upstream.

The FBIOGET_VBLANK device ioctl allows unprivileged users to read 16 bytes
of uninitialized stack memory, because the "reserved" member of the
fb_vblank struct declared on the stack is not altered or zeroed before
being copied back to the user.  This patch takes care of it.

Signed-off-by: Dan Rosenberg <dan.j.rosenberg@gmail.com>
Cc: Thomas Winischhofer <thomas@winischhofer.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/video/sis/sis_main.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/video/sis/sis_main.c b/drivers/video/sis/sis_main.c
index a531a0f..900b3a0 100644
--- a/drivers/video/sis/sis_main.c
+++ b/drivers/video/sis/sis_main.c
@@ -1701,6 +1701,9 @@ static int	sisfb_ioctl(struct fb_info *info, unsigned int cmd,
 		break;
 
 	   case FBIOGET_VBLANK:
+
+		memset(&sisvbblank, 0, sizeof(struct fb_vblank));
+
 		sisvbblank.count = 0;
 		sisvbblank.flags = sisfb_setupvbblankflags(ivideo, &sisvbblank.vcount, &sisvbblank.hcount);
 
-- 
1.7.3.3

