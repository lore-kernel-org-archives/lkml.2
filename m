Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757559Ab0JRRjD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 13:39:03 -0400
Received: from mail.perches.com ([173.55.12.10]:3006 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757535Ab0JRRjC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 13:39:02 -0400
Subject: Re: [PATCH 1/3] drivers/staging/cx25821: Use kstrdup
From: Joe Perches <joe@perches.com>
To: Julia Lawall <julia@diku.dk>
Cc: walter harms <wharms@bfs.de>, devel@driverdev.osuosl.org, gregkh@suse.de,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.1010181421240.25099@ask.diku.dk>
References: <1287341311-11161-1-git-send-email-julia@diku.dk>
	 <1287341311-11161-2-git-send-email-julia@diku.dk> <4CBBF407.7060705@bfs.de>
	 <Pine.LNX.4.64.1010181019370.22530@ask.diku.dk> <4CBC12EC.60109@bfs.de>
	 <Pine.LNX.4.64.1010181421240.25099@ask.diku.dk>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Oct 2010 10:38:59 -0700
Message-ID: <1287423539.20968.115.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Perhaps it's more readable code to recheck the
field name flag and introduce a temporary
char *fname so the slightly unusual reuse of
	field = kstrdup(field, GFP)
becomes
	field = kstrdup(fname, GFP)

---
 drivers/staging/cx25821/cx25821-audio-upstream.c   |   34 +++---------
 .../staging/cx25821/cx25821-video-upstream-ch2.c   |   55 +++++++-------------
 drivers/staging/cx25821/cx25821-video-upstream.c   |   53 +++++++------------
 3 files changed, 47 insertions(+), 95 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-audio-upstream.c b/drivers/staging/cx25821/cx25821-audio-upstream.c
index 27087db..180840f 100644
--- a/drivers/staging/cx25821/cx25821-audio-upstream.c
+++ b/drivers/staging/cx25821/cx25821-audio-upstream.c
@@ -723,8 +723,6 @@ int cx25821_audio_upstream_init(struct cx25821_dev *dev, int channel_select)
 {
 	struct sram_channel *sram_ch;
 	int retval = 0;
-	int err = 0;
-	int str_length = 0;
 
 	if (dev->_audio_is_running) {
 		printk(KERN_WARNING "Audio Channel is still running so return!\n");
@@ -752,28 +750,14 @@ int cx25821_audio_upstream_init(struct cx25821_dev *dev, int channel_select)
 	dev->_audio_lines_count = LINES_PER_AUDIO_BUFFER;
 	_line_size = AUDIO_LINE_SIZE;
 
-	if (dev->input_audiofilename) {
-		str_length = strlen(dev->input_audiofilename);
-		dev->_audiofilename = kmalloc(str_length + 1, GFP_KERNEL);
-
-		if (!dev->_audiofilename)
-			goto error;
-
-		memcpy(dev->_audiofilename, dev->input_audiofilename,
-		       str_length + 1);
-
-		/* Default if filename is empty string */
-		if (strcmp(dev->input_audiofilename, "") == 0)
-			dev->_audiofilename = "/root/audioGOOD.wav";
-
-	} else {
-		str_length = strlen(_defaultAudioName);
-		dev->_audiofilename = kmalloc(str_length + 1, GFP_KERNEL);
-
-		if (!dev->_audiofilename)
-			goto error;
-
-		memcpy(dev->_audiofilename, _defaultAudioName, str_length + 1);
+	if (!dev->input_audiofilename || *dev->input_audiofilename == 0)
+		dev->_audiofilename = _defaultAudioName;
+	else
+		dev->_audiofilename = dev->input_audiofilename;
+	dev->_audiofilename = kstrdup(dev->_audiofilename, GFP_KERNEL);
+	if (!dev->_audiofilename) {
+		retval = -ENOMEM;
+		goto error;
 	}
 
 	retval =
@@ -802,5 +786,5 @@ int cx25821_audio_upstream_init(struct cx25821_dev *dev, int channel_select)
 error:
 	cx25821_dev_unregister(dev);
 
-	return err;
+	return retval;
 }
diff --git a/drivers/staging/cx25821/cx25821-video-upstream-ch2.c b/drivers/staging/cx25821/cx25821-video-upstream-ch2.c
index d12dbb5..fa7cd70 100644
--- a/drivers/staging/cx25821/cx25821-video-upstream-ch2.c
+++ b/drivers/staging/cx25821/cx25821-video-upstream-ch2.c
@@ -747,10 +747,9 @@ int cx25821_vidupstream_init_ch2(struct cx25821_dev *dev, int channel_select,
 	struct sram_channel *sram_ch;
 	u32 tmp;
 	int retval = 0;
-	int err = 0;
 	int data_frame_size = 0;
 	int risc_buffer_size = 0;
-	int str_length = 0;
+	char *fname;
 
 	if (dev->_is_running_ch2) {
 		printk("Video Channel is still running so return!\n");
@@ -788,39 +787,23 @@ int cx25821_vidupstream_init_ch2(struct cx25821_dev *dev, int channel_select,
 	risc_buffer_size =
 	    dev->_isNTSC_ch2 ? NTSC_RISC_BUF_SIZE : PAL_RISC_BUF_SIZE;
 
-	if (dev->input_filename_ch2) {
-		str_length = strlen(dev->input_filename_ch2);
-		dev->_filename_ch2 = kmalloc(str_length + 1, GFP_KERNEL);
-
-		if (!dev->_filename_ch2)
-			goto error;
-
-		memcpy(dev->_filename_ch2, dev->input_filename_ch2,
-		       str_length + 1);
-	} else {
-		str_length = strlen(dev->_defaultname_ch2);
-		dev->_filename_ch2 = kmalloc(str_length + 1, GFP_KERNEL);
-
-		if (!dev->_filename_ch2)
-			goto error;
-
-		memcpy(dev->_filename_ch2, dev->_defaultname_ch2,
-		       str_length + 1);
-	}
-
-       /* Default if filename is empty string */
-	if (strcmp(dev->input_filename_ch2, "") == 0) {
-		if (dev->_isNTSC_ch2) {
-			dev->_filename_ch2 =
-			    (dev->_pixel_format_ch2 ==
-			     PIXEL_FRMT_411) ? "/root/vid411.yuv" :
-			    "/root/vidtest.yuv";
-		} else {
-			dev->_filename_ch2 =
-			    (dev->_pixel_format_ch2 ==
-			     PIXEL_FRMT_411) ? "/root/pal411.yuv" :
-			    "/root/pal422.yuv";
-		}
+	if (dev->input_filename_ch2 && *dev->input_filename_ch2)
+		fname = dev->input_filename_ch2;
+	else if (dev->input_filename_ch2) {
+		/* Default if filename is empty string */
+		if (dev->_isNTSC_ch2)
+			fname = (dev->_pixel_format_ch2 == PIXEL_FRMT_411) ?
+				"/root/vid411.yuv" : "/root/vidtest.yuv";
+		else
+			fname = (dev->_pixel_format_ch2 == PIXEL_FRMT_411) ?
+				"/root/pal411.yuv" : "/root/pal422.yuv";
+	} else
+		fname = dev->_defaultname_ch2;
+
+	dev->_filename_ch2 = kstrdup(fname, GFP_KERNEL);
+	if (!dev->_filename_ch2) {
+		retval = -ENOMEM;
+		goto error;
 	}
 
 	retval =
@@ -851,5 +834,5 @@ int cx25821_vidupstream_init_ch2(struct cx25821_dev *dev, int channel_select,
       error:
 	cx25821_dev_unregister(dev);
 
-	return err;
+	return retval;
 }
diff --git a/drivers/staging/cx25821/cx25821-video-upstream.c b/drivers/staging/cx25821/cx25821-video-upstream.c
index 756a820..d51c6c1 100644
--- a/drivers/staging/cx25821/cx25821-video-upstream.c
+++ b/drivers/staging/cx25821/cx25821-video-upstream.c
@@ -800,10 +800,9 @@ int cx25821_vidupstream_init_ch1(struct cx25821_dev *dev, int channel_select,
 	struct sram_channel *sram_ch;
 	u32 tmp;
 	int retval = 0;
-	int err = 0;
 	int data_frame_size = 0;
 	int risc_buffer_size = 0;
-	int str_length = 0;
+	char *fname;
 
 	if (dev->_is_running) {
 		printk(KERN_INFO "Video Channel is still running so return!\n");
@@ -840,37 +839,23 @@ int cx25821_vidupstream_init_ch1(struct cx25821_dev *dev, int channel_select,
 	risc_buffer_size =
 	    dev->_isNTSC ? NTSC_RISC_BUF_SIZE : PAL_RISC_BUF_SIZE;
 
-	if (dev->input_filename) {
-		str_length = strlen(dev->input_filename);
-		dev->_filename = kmalloc(str_length + 1, GFP_KERNEL);
-
-		if (!dev->_filename)
-			goto error;
-
-		memcpy(dev->_filename, dev->input_filename, str_length + 1);
-	} else {
-		str_length = strlen(dev->_defaultname);
-		dev->_filename = kmalloc(str_length + 1, GFP_KERNEL);
-
-		if (!dev->_filename)
-			goto error;
-
-		memcpy(dev->_filename, dev->_defaultname, str_length + 1);
-	}
-
-	/* Default if filename is empty string */
-	if (strcmp(dev->input_filename, "") == 0) {
-		if (dev->_isNTSC) {
-			dev->_filename =
-			    (dev->_pixel_format ==
-			     PIXEL_FRMT_411) ? "/root/vid411.yuv" :
-			    "/root/vidtest.yuv";
-		} else {
-			dev->_filename =
-			    (dev->_pixel_format ==
-			     PIXEL_FRMT_411) ? "/root/pal411.yuv" :
-			    "/root/pal422.yuv";
-		}
+	if (dev->input_filename && *dev->input_filename)
+		fname = dev->input_filename;
+	else if (dev->input_filename) {
+		/* Default if filename is empty string */
+		if (dev->_isNTSC)
+			fname = (dev->_pixel_format == PIXEL_FRMT_411) ?
+				"/root/vid411.yuv" : "/root/vidtest.yuv";
+		else
+			fname = (dev->_pixel_format == PIXEL_FRMT_411) ?
+				"/root/pal411.yuv" : "/root/pal422.yuv";
+	} else
+		fname = dev->_defaultname;
+
+	dev->_filename = kstrdup(fname, GFP_KERNEL);
+	if (!dev->_filename) {
+		retval = -ENOMEM;
+		goto error;
 	}
 
 	dev->_is_running = 0;
@@ -908,5 +893,5 @@ int cx25821_vidupstream_init_ch1(struct cx25821_dev *dev, int channel_select,
 error:
 	cx25821_dev_unregister(dev);
 
-	return err;
+	return retval;
 }


