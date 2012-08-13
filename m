Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068Ab2HMVFd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 17:05:33 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:58516 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752880Ab2HMVFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 17:05:31 -0400
From: Denis Efremov <yefremov.denis@gmail.com>
To: Neil Brown <neilb@suse.de>
Cc: Denis Efremov <yefremov.denis@gmail.com>, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@ispras.ru
Subject: [PATCH] md/linear: rcu_dereference outside read-lock section
Date: Tue, 14 Aug 2012 01:08:12 +0400
Message-Id: <1344892092-13686-1-git-send-email-yefremov.denis@gmail.com>
X-Mailer: git-send-email 1.7.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to the comment in linear_stop function
rcu_dereference in linear_start and linear_stop functions
occurs under reconfig_mutex. The patch represents this
agreement in code and prevents lockdep complaint.

Found by Linux Driver Verification project (linuxtesting.org)

Signed-off-by: Denis Efremov <yefremov.denis@gmail.com>
---
 drivers/md/linear.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/md/linear.c b/drivers/md/linear.c
index fa211d8..093f3e4 100644
--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -244,7 +244,8 @@ static int linear_add(struct mddev *mddev, struct md_rdev *rdev)
 	if (!newconf)
 		return -ENOMEM;
 
-	oldconf = rcu_dereference(mddev->private);
+	oldconf = rcu_dereference_protected(mddev->private,
+					    lockdep_is_held(&mddev->reconfig_mutex));
 	mddev->raid_disks++;
 	rcu_assign_pointer(mddev->private, newconf);
 	md_set_array_sectors(mddev, linear_size(mddev, 0, 0));
@@ -256,7 +257,9 @@ static int linear_add(struct mddev *mddev, struct md_rdev *rdev)
 
 static int linear_stop (struct mddev *mddev)
 {
-	struct linear_conf *conf = mddev->private;
+	struct linear_conf *conf =
+		rcu_dereference_protected(mddev->private,
+					  lockdep_is_held(&mddev->reconfig_mutex));
 
 	/*
 	 * We do not require rcu protection here since
-- 
1.7.7

