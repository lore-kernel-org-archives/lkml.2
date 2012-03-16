Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032770Ab2CPQZa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 12:25:30 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:40719 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031393Ab2CPQZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 12:25:28 -0400
From: santosh nayak <santoshprasadnayak@gmail.com>
To: mchehab@infradead.org
Cc: gregkh@linuxfoundation.org, khoroshilov@ispras.ru,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Santosh Nayak <santoshprasadnayak@gmail.com>
Subject: [PATCH] [media] staging: Return -EINTR in s2250_probe() if fails to get lock.
Date: Fri, 16 Mar 2012 21:53:58 +0530
Message-Id: <1331915038-11231-1-git-send-email-santoshprasadnayak@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Santosh Nayak <santoshprasadnayak@gmail.com>

In s2250_probe(), If locking attempt is interrupted by a signal then
it should return -EINTR after unregistering audio device and making free
the allocated memory.

At present, if locking is interrupted by signal it will display message
"initialized successfully" and return success.  This is wrong.

Signed-off-by: Santosh Nayak <santoshprasadnayak@gmail.com>
---
 drivers/staging/media/go7007/s2250-board.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/media/go7007/s2250-board.c b/drivers/staging/media/go7007/s2250-board.c
index 014d384..2823bbf 100644
--- a/drivers/staging/media/go7007/s2250-board.c
+++ b/drivers/staging/media/go7007/s2250-board.c
@@ -657,6 +657,10 @@ static int s2250_probe(struct i2c_client *client,
 			kfree(data);
 		}
 		mutex_unlock(&usb->i2c_lock);
+	} else {
+		i2c_unregister_device(audio);
+		kfree(state);
+		return -EINTR;
 	}
 
 	v4l2_info(sd, "initialized successfully\n");
-- 
1.7.4.4

