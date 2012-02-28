Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964994Ab2B1BIM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 20:08:12 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:46792 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964933Ab2B1BIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 20:08:07 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.216.42 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
MIME-Version: 1.0
Message-Id: <20120228010215.616509657@linuxfoundation.org>
User-Agent: quilt/0.51-17.1
Date: Mon, 27 Feb 2012 17:03:11 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Joerg Desch <vvd.joede@googlemail.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [ 68/73] [media] hdpvr: fix race conditon during start of streaming
In-Reply-To: <20120228010246.GA24299@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Janne Grunau <j@jannau.net>

commit afa159538af61f1a65d48927f4e949fe514fb4fc upstream.

status has to be set to STREAMING before the streaming worker is
queued. hdpvr_transmit_buffers() will exit immediately otherwise.

Reported-by: Joerg Desch <vvd.joede@googlemail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/video/hdpvr/hdpvr-video.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/media/video/hdpvr/hdpvr-video.c
+++ b/drivers/media/video/hdpvr/hdpvr-video.c
@@ -284,12 +284,13 @@ static int hdpvr_start_streaming(struct
 
 		hdpvr_config_call(dev, CTRL_START_STREAMING_VALUE, 0x00);
 
+		dev->status = STATUS_STREAMING;
+
 		INIT_WORK(&dev->worker, hdpvr_transmit_buffers);
 		queue_work(dev->workqueue, &dev->worker);
 
 		v4l2_dbg(MSG_BUFFER, hdpvr_debug, &dev->v4l2_dev,
 			 "streaming started\n");
-		dev->status = STATUS_STREAMING;
 
 		return 0;
 	}


