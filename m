Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513Ab2IHOCI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 10:02:08 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:45141 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809Ab2IHOCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 10:02:06 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: kernel-janitors@vger.kernel.org, wharms@bfs.de, Julia.Lawall@lip6.fr,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] drivers/media/pci/cx25821/cx25821-video-upstream-ch2.c: fix error return code
Date: Sat,  8 Sep 2012 16:01:58 +0200
Message-Id: <1347112918-7738-1-git-send-email-peter.senna@gmail.com>
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
walter harms <wharms@bfs.de>, thanks for the tip. Please take a look carefully to check if I got your suggestion correctly. It was tested by compilation only.

 drivers/media/pci/cx25821/cx25821-video-upstream-ch2.c |   30 ++++++-----------
 1 file changed, 12 insertions(+), 18 deletions(-)

diff --git a/drivers/media/pci/cx25821/cx25821-video-upstream-ch2.c b/drivers/media/pci/cx25821/cx25821-video-upstream-ch2.c
index c8c94fb..b663dac 100644
--- a/drivers/media/pci/cx25821/cx25821-video-upstream-ch2.c
+++ b/drivers/media/pci/cx25821/cx25821-video-upstream-ch2.c
@@ -704,11 +704,9 @@ int cx25821_vidupstream_init_ch2(struct cx25821_dev *dev, int channel_select,
 {
 	struct sram_channel *sram_ch;
 	u32 tmp;
-	int retval = 0;
 	int err = 0;
 	int data_frame_size = 0;
 	int risc_buffer_size = 0;
-	int str_length = 0;
 
 	if (dev->_is_running_ch2) {
 		pr_info("Video Channel is still running so return!\n");
@@ -744,20 +742,16 @@ int cx25821_vidupstream_init_ch2(struct cx25821_dev *dev, int channel_select,
 	risc_buffer_size = dev->_isNTSC_ch2 ?
 		NTSC_RISC_BUF_SIZE : PAL_RISC_BUF_SIZE;
 
-	if (dev->input_filename_ch2) {
-		str_length = strlen(dev->input_filename_ch2);
-		dev->_filename_ch2 = kmemdup(dev->input_filename_ch2,
-					     str_length + 1, GFP_KERNEL);
-
-		if (!dev->_filename_ch2)
-			goto error;
-	} else {
-		str_length = strlen(dev->_defaultname_ch2);
-		dev->_filename_ch2 = kmemdup(dev->_defaultname_ch2,
-					     str_length + 1, GFP_KERNEL);
+	if (dev->input_filename_ch2)
+		dev->_filename_ch2 = kstrdup(dev->input_filename_ch2,
+								GFP_KERNEL);
+	else
+		dev->_filename_ch2 = kstrdup(dev->_defaultname_ch2,
+								GFP_KERNEL);
 
-		if (!dev->_filename_ch2)
-			goto error;
+	if (!dev->_filename_ch2) {
+		err = -ENOENT;
+		goto error;
 	}
 
 	/* Default if filename is empty string */
@@ -773,7 +767,7 @@ int cx25821_vidupstream_init_ch2(struct cx25821_dev *dev, int channel_select,
 		}
 	}
 
-	retval = cx25821_sram_channel_setup_upstream(dev, sram_ch,
+	err = cx25821_sram_channel_setup_upstream(dev, sram_ch,
 						dev->_line_size_ch2, 0);
 
 	/* setup fifo + format */
@@ -783,9 +777,9 @@ int cx25821_vidupstream_init_ch2(struct cx25821_dev *dev, int channel_select,
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

