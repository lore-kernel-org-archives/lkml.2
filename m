Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756930Ab1ETATs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 20:19:48 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:46843 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934482Ab1ETALW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 20:11:22 -0400
X-Sasl-enc: +GmsX+9BeSzFyjgeHBBp4m8L1EZy+pSBvfXmHXWQDvR1 1305850281
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Hillf Danton <dhillf@gmail.com>, "Hans J. Koch" <hjk@hansjkoch.de>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 10/44] uio: fix allocating minor id for uio device
Date: Thu, 19 May 2011 17:10:28 -0700
Message-Id: <1305850262-9575-10-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.4.2
In-Reply-To: <1305850262-9575-1-git-send-email-gregkh@suse.de>
References: <20110520000821.GA9367@kroah.com>
 <1305850262-9575-1-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hillf Danton <dhillf@gmail.com>

The number of uio devices that could be used should be less than
UIO_MAX_DEVICES by design, and this work guards any cases in which id
more than UIO_MAX_DEVICES is utilized.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
Signed-off-by: Hans J. Koch <hjk@hansjkoch.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/uio/uio.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index 10a029b..d2efe82 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -381,7 +381,13 @@ static int uio_get_minor(struct uio_device *idev)
 			retval = -ENOMEM;
 		goto exit;
 	}
-	idev->minor = id & MAX_ID_MASK;
+	if (id < UIO_MAX_DEVICES) {
+		idev->minor = id;
+	} else {
+		dev_err(idev->dev, "too many uio devices\n");
+		retval = -EINVAL;
+		idr_remove(&uio_idr, id);
+	}
 exit:
 	mutex_unlock(&minor_lock);
 	return retval;
-- 
1.7.4.2

