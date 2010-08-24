Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098Ab0HXEYX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 00:24:23 -0400
Received: from kroah.org ([198.145.64.141]:56432 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751585Ab0HXEYU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 00:24:20 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Dan Carpenter <error27@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 5/6] synclink: add mutex_unlock() on error path
Date: Mon, 23 Aug 2010 21:24:05 -0700
Message-Id: <1282623846-17050-5-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20100824040508.GC16749@kroah.com>
References: <20100824040508.GC16749@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <error27@gmail.com>

There is a path which still holds its mutex here.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Acked-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/synclink_gt.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/char/synclink_gt.c b/drivers/char/synclink_gt.c
index fef80cf..e63b830 100644
--- a/drivers/char/synclink_gt.c
+++ b/drivers/char/synclink_gt.c
@@ -691,8 +691,10 @@ static int open(struct tty_struct *tty, struct file *filp)
 	if (info->port.count == 1) {
 		/* 1st open on this device, init hardware */
 		retval = startup(info);
-		if (retval < 0)
+		if (retval < 0) {
+			mutex_unlock(&info->port.mutex);
 			goto cleanup;
+		}
 	}
 	mutex_unlock(&info->port.mutex);
 	retval = block_til_ready(tty, filp, info);
-- 
1.7.2

