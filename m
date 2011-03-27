Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449Ab1C0IAl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 04:00:41 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58528 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079Ab1C0IAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 04:00:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=mqKCKXeggrX0xLsFG2TXAwy9jArI88OqtCET+zQOv1Jy5b7xUIZx/roZlS/6jkN04S
         ooQJx7//FaganyW4H1jGcLSs7SXyF13lqXkR8RKS8FJIJooRAqiwqkq88NJ7eilV5wO+
         Qg4deQ3XfnspUkiJ7sAhIoJIqK2BM5GS8sIy0=
MIME-Version: 1.0
Date: Sun, 27 Mar 2011 16:00:39 +0800
Message-ID: <AANLkTikKNOPi1ALD0vWiwPKDzUJSseuis63qYJKYkj6=@mail.gmail.com>
Subject: [PATCH] uio: fix allocating minor id for uio device
From: Hillf Danton <dhillf@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The number of uio devices that could be used should be less than
UIO_MAX_DEVICES by design,
and this work guards any cases in which id more than UIO_MAX_DEVICES
is utilized.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/drivers/uio/uio.c	2011-01-05 08:50:20.000000000 +0800
+++ b/drivers/uio/uio.c	2011-03-27 15:05:26.000000000 +0800
@@ -381,7 +381,13 @@ static int uio_get_minor(struct uio_devi
 			retval = -ENOMEM;
 		goto exit;
 	}
-	idev->minor = id & MAX_ID_MASK;
+	if (id < UIO_MAX_DEVICES)
+		idev->minor = id;
+	else {
+		printk(KERN_ERR "uio: too many uio devices\n");
+		retval = -EINVAL;
+		idr_remove(&uio_idr, id);
+	}
 exit:
 	mutex_unlock(&minor_lock);
 	return retval;
