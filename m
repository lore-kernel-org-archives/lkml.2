Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260Ab1H2V4M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 17:56:12 -0400
Received: from moh1-ve2.go2.pl ([193.17.41.132]:34602 "EHLO moh1-ve2.go2.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753945Ab1H2V4J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 17:56:09 -0400
X-Greylist: delayed 5882 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Aug 2011 17:56:09 EDT
Message-ID: <4E5C0AF1.3090606@o2.pl>
Date: Mon, 29 Aug 2011 23:56:01 +0200
From: Maciej Szmigiero <mhej@o2.pl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110715 Thunderbird/5.0
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [V4L2]decrement struct v4l2_device refcount on device unregister
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-O2-Trust: 2, 65
X-O2-SPF: neutral
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit bedf8bcf6b4f90a6e31add3721a2e71877289381 introduced reference counting
for struct v4l2_device.

In v4l2_device_register() a call to kref_init() initializes reference count to 1,
but in v4l2_device_unregister() there is no corresponding decrement.

End result is that reference count never reaches zero and v4l2_device_release()
is never called, not even on videodev module unload.

Fix this by adding reference counter decrement to v4l2_device_unregister().

Resending due to spurious newlines around the patch in previous message.

Signed-off-by: Maciej Szmigiero <mhej@o2.pl>

diff --git a/drivers/media/video/v4l2-device.c b/drivers/media/video/v4l2-device.c
index c72856c..eb39af9 100644
--- a/drivers/media/video/v4l2-device.c
+++ b/drivers/media/video/v4l2-device.c
@@ -131,6 +131,8 @@ void v4l2_device_unregister(struct v4l2_device *v4l2_dev)
 		}
 #endif
 	}
+
+	v4l2_device_put(v4l2_dev);
 }
 EXPORT_SYMBOL_GPL(v4l2_device_unregister);

