Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760581Ab2IGNrR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 09:47:17 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:37451 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754660Ab2IGNrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 09:47:15 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org
Subject: [PATCH] drivers/media/pci/cx25821/cx25821-video-upstream-ch2.c: fix error return code
Date: Fri,  7 Sep 2012 15:46:55 +0200
Message-Id: <1347025615-11811-1-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.7.11.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Senna Tschudin <peter.senna@gmail.com>

Convert a nonnegative error return code to a negative one, as returned
elsewhere in the function.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
(
if@p1 (\(ret < 0\|ret != 0\))
 { ... return ret; }
|
ret@p1 = 0
)
... when != ret = e1
    when != &ret
*if(...)
{
  ... when != ret = e2
      when forall
 return ret;
}

// </smpl>

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>

---
 drivers/media/pci/cx25821/cx25821-video-upstream-ch2.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/../linux-next/drivers/media/pci/cx25821/cx25821-video-upstream-ch2.c b/drivers/media/pci/cx25821/cx25821-video-upstream-ch2.c
index c8c94fb..273df94 100644
--- a/../linux-next/drivers/media/pci/cx25821/cx25821-video-upstream-ch2.c
+++ b/drivers/media/pci/cx25821/cx25821-video-upstream-ch2.c
@@ -704,7 +704,6 @@ int cx25821_vidupstream_init_ch2(struct cx25821_dev *dev, int channel_select,
 {
 	struct sram_channel *sram_ch;
 	u32 tmp;
-	int retval = 0;
 	int err = 0;
 	int data_frame_size = 0;
 	int risc_buffer_size = 0;
@@ -749,15 +748,19 @@ int cx25821_vidupstream_init_ch2(struct cx25821_dev *dev, int channel_select,
 		dev->_filename_ch2 = kmemdup(dev->input_filename_ch2,
 					     str_length + 1, GFP_KERNEL);
 
-		if (!dev->_filename_ch2)
+		if (!dev->_filename_ch2) {
+			err = -ENOENT;
 			goto error;
+		}
 	} else {
 		str_length = strlen(dev->_defaultname_ch2);
 		dev->_filename_ch2 = kmemdup(dev->_defaultname_ch2,
 					     str_length + 1, GFP_KERNEL);
 
-		if (!dev->_filename_ch2)
+		if (!dev->_filename_ch2) {
+			err = -ENOENT;
 			goto error;
+		}
 	}
 
 	/* Default if filename is empty string */
@@ -773,7 +776,7 @@ int cx25821_vidupstream_init_ch2(struct cx25821_dev *dev, int channel_select,
 		}
 	}
 
-	retval = cx25821_sram_channel_setup_upstream(dev, sram_ch,
+	err = cx25821_sram_channel_setup_upstream(dev, sram_ch,
 						dev->_line_size_ch2, 0);
 
 	/* setup fifo + format */
@@ -783,9 +786,9 @@ int cx25821_vidupstream_init_ch2(struct cx25821_dev *dev, int channel_select,
 	dev->upstream_databuf_size_ch2 = data_frame_size * 2;
 
 	/* Allocating buffers and prepare RISC program */
-	retval = cx25821_upstream_buffer_prepare_ch2(dev, sram_ch,
+	err = cx25821_upstream_buffer_prepare_ch2(dev, sram_ch,
 						dev->_line_size_ch2);
-	if (retval < 0) {
+	if (err < 0) {
 		pr_err("%s: Failed to set up Video upstream buffers!\n",
 		       dev->name);
 		goto error;

