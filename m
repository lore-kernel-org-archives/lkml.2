Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697Ab1H3UlX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 16:41:23 -0400
Received: from smtp.ispras.ru ([83.149.198.202]:54792 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756670Ab1H3UlW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 16:41:22 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Oren Weil <oren.jer.weil@intel.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, ldv-project@ispras.ru
Subject: [PATCH] staging: mei: unlock dev->device_lock mutex on error path in mei_open()
Date: Wed, 31 Aug 2011 00:41:14 +0400
Message-Id: <1314736874-5220-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mei_open() acquires dev->device_lock mutex and try to allocate mei_cl,
but if the allocation fails it goes to return statement. As a result
dev->device_lock left locked.

The patch fixes goto to unlock dev->device_lock mutex on this path.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/staging/mei/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/mei/main.c b/drivers/staging/mei/main.c
index de8825f..3c9931b 100644
--- a/drivers/staging/mei/main.c
+++ b/drivers/staging/mei/main.c
@@ -402,7 +402,7 @@ static int mei_open(struct inode *inode, struct file *file)
 	err = -ENOMEM;
 	cl = mei_cl_allocate(dev);
 	if (!cl)
-		goto out;
+		goto out_unlock;
 
 	err = -ENODEV;
 	if (dev->mei_state != MEI_ENABLED) {
-- 
1.7.4.1

