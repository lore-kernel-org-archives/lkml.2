Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758367Ab2IFP0E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 11:26:04 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:62287 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757839Ab2IFPYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 11:24:18 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: kernel-janitors@vger.kernel.org, Julia.Lawall@lip6.fr,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/14] drivers/media/pci/cx25821/cx25821-video-upstream.c: fix error return code
Date: Thu,  6 Sep 2012 17:23:56 +0200
Message-Id: <1346945041-26676-9-git-send-email-peter.senna@gmail.com>
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
 drivers/media/pci/cx25821/cx25821-video-upstream.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/media/pci/cx25821/cx25821-video-upstream.c b/drivers/media/pci/cx25821/cx25821-video-upstream.c
index 52c13e0..b41e57b 100644
--- a/drivers/media/pci/cx25821/cx25821-video-upstream.c
+++ b/drivers/media/pci/cx25821/cx25821-video-upstream.c
@@ -753,7 +753,6 @@ int cx25821_vidupstream_init_ch1(struct cx25821_dev *dev, int channel_select,
 {
 	struct sram_channel *sram_ch;
 	u32 tmp;
-	int retval = 0;
 	int err = 0;
 	int data_frame_size = 0;
 	int risc_buffer_size = 0;
@@ -796,15 +795,19 @@ int cx25821_vidupstream_init_ch1(struct cx25821_dev *dev, int channel_select,
 		dev->_filename = kmemdup(dev->input_filename, str_length + 1,
 					 GFP_KERNEL);
 
-		if (!dev->_filename)
+		if (!dev->_filename) {
+			err = -ENOENT;
 			goto error;
+		}
 	} else {
 		str_length = strlen(dev->_defaultname);
 		dev->_filename = kmemdup(dev->_defaultname, str_length + 1,
 					 GFP_KERNEL);
 
-		if (!dev->_filename)
+		if (!dev->_filename) {
+			err = -ENOENT;
 			goto error;
+		}
 	}
 
 	/* Default if filename is empty string */
@@ -828,7 +831,7 @@ int cx25821_vidupstream_init_ch1(struct cx25821_dev *dev, int channel_select,
 	dev->_line_size = (dev->_pixel_format == PIXEL_FRMT_422) ?
 		(WIDTH_D1 * 2) : (WIDTH_D1 * 3) / 2;
 
-	retval = cx25821_sram_channel_setup_upstream(dev, sram_ch,
+	err = cx25821_sram_channel_setup_upstream(dev, sram_ch,
 			dev->_line_size, 0);
 
 	/* setup fifo + format */
@@ -838,8 +841,8 @@ int cx25821_vidupstream_init_ch1(struct cx25821_dev *dev, int channel_select,
 	dev->upstream_databuf_size = data_frame_size * 2;
 
 	/* Allocating buffers and prepare RISC program */
-	retval = cx25821_upstream_buffer_prepare(dev, sram_ch, dev->_line_size);
-	if (retval < 0) {
+	err = cx25821_upstream_buffer_prepare(dev, sram_ch, dev->_line_size);
+	if (err < 0) {
 		pr_err("%s: Failed to set up Video upstream buffers!\n",
 		       dev->name);
 		goto error;

