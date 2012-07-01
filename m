Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913Ab2GAS2f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 14:28:35 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46906 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755825Ab2GASQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 14:16:24 -0400
Message-Id: <20120701172009.229156155@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 01 Jul 2012 18:20:24 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Hans de Goede <hdegoede@redhat.com>,
        Antonio Ospite <ospite@studenti.unina.it>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [ 18/48] [media] gspca-core: Fix buffers staying in queued state after a
 stream_off
In-Reply-To: <20120701172006.535271340@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit af05ef01e9cde84620c6855a8d8ab9c8a1db9009 upstream.

This fixes a regression introduced by commit f7059ea and should be
backported to all supported stable kernels which have this commit.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Tested-by: Antonio Ospite <ospite@studenti.unina.it>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/media/video/gspca/gspca.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/media/video/gspca/gspca.c
+++ b/drivers/media/video/gspca/gspca.c
@@ -1697,7 +1697,7 @@
 				enum v4l2_buf_type buf_type)
 {
 	struct gspca_dev *gspca_dev = priv;
-	int ret;
+	int i, ret;
 
 	if (buf_type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
@@ -1728,6 +1728,8 @@
 	wake_up_interruptible(&gspca_dev->wq);
 
 	/* empty the transfer queues */
+	for (i = 0; i < gspca_dev->nframes; i++)
+		gspca_dev->frame[i].v4l2_buf.flags &= ~BUF_ALL_FLAGS;
 	atomic_set(&gspca_dev->fr_q, 0);
 	atomic_set(&gspca_dev->fr_i, 0);
 	gspca_dev->fr_o = 0;


