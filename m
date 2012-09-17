Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744Ab2IQIFQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 04:05:16 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:58755 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754492Ab2IQIFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 04:05:13 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: mchehab@infradead.org
Cc: leonidsbox@gmail.com, peter.senna@gmail.com, thomas@m3y3r.de,
        hans.verkuil@cisco.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] cx25821: fix error return code and clean up
Date: Mon, 17 Sep 2012 10:04:56 +0200
Message-Id: <1347869098-2236-1-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.7.11.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Senna Tschudin <peter.senna@gmail.com>

The function cx25821_sram_channel_setup_upstream_audio always return zero,
so the return value is not saved any more.

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
 drivers/media/pci/cx25821/cx25821-audio-upstream.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/media/pci/cx25821/cx25821-audio-upstream.c b/drivers/media/pci/cx25821/cx25821-audio-upstream.c
index 8b2a999..49a28ae 100644
--- a/drivers/media/pci/cx25821/cx25821-audio-upstream.c
+++ b/drivers/media/pci/cx25821/cx25821-audio-upstream.c
@@ -700,7 +700,6 @@ fail_irq:
 int cx25821_audio_upstream_init(struct cx25821_dev *dev, int channel_select)
 {
 	struct sram_channel *sram_ch;
-	int retval = 0;
 	int err = 0;
 	int str_length = 0;
 
@@ -735,8 +734,10 @@ int cx25821_audio_upstream_init(struct cx25821_dev *dev, int channel_select)
 		dev->_audiofilename = kmemdup(dev->input_audiofilename,
 					      str_length + 1, GFP_KERNEL);
 
-		if (!dev->_audiofilename)
+		if (!dev->_audiofilename) {
+			err = -ENOMEM;
 			goto error;
+		}
 
 		/* Default if filename is empty string */
 		if (strcmp(dev->input_audiofilename, "") == 0)
@@ -746,12 +747,14 @@ int cx25821_audio_upstream_init(struct cx25821_dev *dev, int channel_select)
 		dev->_audiofilename = kmemdup(_defaultAudioName,
 					      str_length + 1, GFP_KERNEL);
 
-		if (!dev->_audiofilename)
+		if (!dev->_audiofilename) {
+			err = -ENOMEM;
 			goto error;
+		}
 	}
 
-	retval = cx25821_sram_channel_setup_upstream_audio(dev, sram_ch,
-							_line_size, 0);
+	cx25821_sram_channel_setup_upstream_audio(dev, sram_ch,
+						  _line_size, 0);
 
 	dev->audio_upstream_riscbuf_size =
 		AUDIO_RISC_DMA_BUF_SIZE * NUM_AUDIO_PROGS +
@@ -759,9 +762,9 @@ int cx25821_audio_upstream_init(struct cx25821_dev *dev, int channel_select)
 	dev->audio_upstream_databuf_size = AUDIO_DATA_BUF_SZ * NUM_AUDIO_PROGS;
 
 	/* Allocating buffers and prepare RISC program */
-	retval = cx25821_audio_upstream_buffer_prepare(dev, sram_ch,
+	err = cx25821_audio_upstream_buffer_prepare(dev, sram_ch,
 							_line_size);
-	if (retval < 0) {
+	if (err < 0) {
 		pr_err("%s: Failed to set up Audio upstream buffers!\n",
 			dev->name);
 		goto error;
-- 
1.7.11.4

