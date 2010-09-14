Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755379Ab0INTzm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 15:55:42 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:65308 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755138Ab0INTz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 15:55:27 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 12/18] tlclk: remove big kernel lock
Date: Tue, 14 Sep 2010 21:55:18 +0200
Message-Id: <1284494124-7384-3-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1284493213-7263-1-git-send-email-arnd@arndb.de>
References: <1284493213-7263-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:0QgeZRRAZZtuyeP1VUAgoqVxSW07RxKihOXzqwj9Qi7
 So5FxhOeStO1le32vbsmn5tmQRFbmI6vBBbK1qcXdn7nbFK4NQ
 nZikXS/2iHUjK+oQdQPnRbYymqN8t4saRXnK2mFykKh9zLXJBX
 dNYFZDeoGeh83yyPOfnbwV1Le9uRJe7k1lZ5JDyD1nXOgPZX3l
 ZaokLOkf1ANe4cPi/8IfQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver already has a global mutex, so let's just
use that in the open function instead of the BKL.
It may not even be needed there, but this patch should
have the smallest impact.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Mark Gross <mark.gross@intel.com>
---
 drivers/char/tlclk.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/char/tlclk.c b/drivers/char/tlclk.c
index 80ea6bc..e32cbf0 100644
--- a/drivers/char/tlclk.c
+++ b/drivers/char/tlclk.c
@@ -37,7 +37,7 @@
 #include <linux/ioport.h>
 #include <linux/interrupt.h>
 #include <linux/spinlock.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/timer.h>
 #include <linux/sysfs.h>
 #include <linux/device.h>
@@ -206,7 +206,7 @@ static int tlclk_open(struct inode *inode, struct file *filp)
 {
 	int result;
 
-	lock_kernel();
+	mutex_lock(&tlclk_mutex);
 	if (test_and_set_bit(0, &useflags)) {
 		result = -EBUSY;
 		/* this legacy device is always one per system and it doesn't
@@ -229,7 +229,7 @@ static int tlclk_open(struct inode *inode, struct file *filp)
 		inb(TLCLK_REG6);	/* Clear interrupt events */
 
 out:
-	unlock_kernel();
+	mutex_unlock(&tlclk_mutex);
 	return result;
 }
 
-- 
1.7.1

