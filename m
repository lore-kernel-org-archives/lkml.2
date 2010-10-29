Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933653Ab0J2NU3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 09:20:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7749 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756580Ab0J2NU1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 09:20:27 -0400
From: Lukas Czerner <lczerner@redhat.com>
To: tytso@mit.edu
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
        sandeen@redhat.com, adilger@dilger.ca, lczerner@redhat.com
Subject: [PATCH] ext4: Fix lazyinit hang after removing request
Date: Fri, 29 Oct 2010 15:20:20 +0200
Message-Id: <1288358420-11643-1-git-send-email-lczerner@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the request has been removed from the list and no other request
has been issued, we will end up with next wakeup scheduled to
MAX_JIFFY_OFFSET which is bad. So check for that.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/super.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 0348ce0..29c3078 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2740,7 +2740,8 @@ cont_thread:
 		if (freezing(current))
 			refrigerator();
 
-		if (time_after_eq(jiffies, next_wakeup)) {
+		if ((time_after_eq(jiffies, next_wakeup)) ||
+		    (MAX_JIFFY_OFFSET == next_wakeup)) {
 			cond_resched();
 			continue;
 		}
-- 
1.7.2.3

