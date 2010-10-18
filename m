Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908Ab0JRUnp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 16:43:45 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:41165 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910Ab0JRUnn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 16:43:43 -0400
Date: Mon, 18 Oct 2010 22:43:40 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Joe Perches <joe@perches.com>
Cc: walter harms <wharms@bfs.de>, devel@driverdev.osuosl.org, gregkh@suse.de,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] drivers/staging/cx25821: Use kstrdup
In-Reply-To: <1287423539.20968.115.camel@Joe-Laptop>
Message-ID: <Pine.LNX.4.64.1010182243260.22877@ask.diku.dk>
References: <1287341311-11161-1-git-send-email-julia@diku.dk> 
 <1287341311-11161-2-git-send-email-julia@diku.dk> <4CBBF407.7060705@bfs.de>
  <Pine.LNX.4.64.1010181019370.22530@ask.diku.dk> <4CBC12EC.60109@bfs.de> 
 <Pine.LNX.4.64.1010181421240.25099@ask.diku.dk> <1287423539.20968.115.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From nobody Sun Oct 17 20:14:32 CEST 2010
From: Julia Lawall <julia@diku.dk>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org,linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] drivers/staging/cx25821: Use kstrdup

Rewrite the initialization of a dev field.  In the original code, in each
case there was a kmalloc followed by a memcpy, as illustrated by the
semantic patch below.  In the case that the provided string was the empty
string, the allocated memory was then overwritten with a constant string,
causing a memory leak.  Finally, there was no provision for returning
-ENOMEM in case of failure of the memory allocation.  Indeed, the return
value in an error case was err, a variable that was never initialized to
anything other than 0.

The following patch rewrites the above code to first select a string based
on various conditions, and then to copy it into a newly allocated memory
region, using kstrdup.  This decreases subtantially the code size
and removes the memory leak.  The instruction for getting the length of the
string and the associated variable declaration are also deleted.

The patch also drops err, changes the return value to retval, which in each
file was already initialized elsewhere to an error code, and initializes
retval to -ENOMEM when kstrdup fails.

The semantic patch that motivated this transformation is:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression a,flag,len;
expression arg,e1,e2;
statement S;
@@

  len = strlen(arg)
  ... when != len = e1
      when != arg = e2
  a =
-  \(kmalloc\|kzalloc\)(len+1,flag)
+  kstrdup(arg,flag)
  <... when != a
  if (a == NULL || ...) S
  ...>
- memcpy(a,arg,len+1);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
This patch makes quite a lot of changes and is only compile tested.
As compared to the previous version, the local variable filename is readded
and the nested ifs in the second and third file are reorganized.

 drivers/staging/cx25821/cx25821-audio-upstream.c     |   35 +++--------
 drivers/staging/cx25821/cx25821-video-upstream-ch2.c |   58 +++++++------------
 drivers/staging/cx25821/cx25821-video-upstream.c     |   55 +++++++-----------
 3 files changed, 54 insertions(+), 94 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-audio-upstream.c b/drivers/staging/cx25821/cx25821-audio-upstream.c
index 27087db..252aa49 100644
--- a/drivers/staging/cx25821/cx25821-audio-upstream.c
+++ b/drivers/staging/cx25821/cx25821-audio-upstream.c
@@ -723,8 +723,7 @@ int cx25821_audio_upstream_init(struct cx25821_dev *dev, int channel_select)
 {
 	struct sram_channel *sram_ch;
 	int retval = 0;
-	int err = 0;
-	int str_length = 0;
+	char *filename;
 
 	if (dev->_audio_is_running) {
 		printk(KERN_WARNING "Audio Channel is still running so return!\n");
@@ -752,28 +751,14 @@ int cx25821_audio_upstream_init(struct cx25821_dev *dev, int channel_select)
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
+		filename = _defaultAudioName;
+	else
+		filename = dev->input_audiofilename;
+	dev->_audiofilename = kstrdup(filename, GFP_KERNEL);
+	if (!dev->_audiofilename) {
+		retval = -ENOMEM;
+		goto error;
 	}
 
 	retval =
@@ -802,5 +787,5 @@ int cx25821_audio_upstream_init(struct cx25821_dev *dev, int channel_select)
 error:
 	cx25821_dev_unregister(dev);
 
-	return err;
+	return retval;
 }
diff --git a/drivers/staging/cx25821/cx25821-video-upstream-ch2.c b/drivers/staging/cx25821/cx25821-video-upstream-ch2.c
index d12dbb5..3d276c1 100644
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
+	char *filename;
 
 	if (dev->_is_running_ch2) {
 		printk("Video Channel is still running so return!\n");
@@ -788,39 +787,26 @@ int cx25821_vidupstream_init_ch2(struct cx25821_dev *dev, int channel_select,
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
+	if (dev->input_filename_ch2 && *dev->input_filename_ch2 == 0) {
+		/* Default if filename is empty string */
+		if (dev->_isNTSC_ch2)
+			filename =
+				(dev->_pixel_format_ch2 == PIXEL_FRMT_411) ?
+				"/root/vid411.yuv" :
+				"/root/vidtest.yuv";
+		else
+			filename =
+				(dev->_pixel_format_ch2 == PIXEL_FRMT_411) ?
+				"/root/pal411.yuv" :
+				"/root/pal422.yuv";
+	} else if (dev->input_filename_ch2)
+		filename = dev->input_filename_ch2;
+	else
+		filename = dev->_defaultname_ch2;
+	dev->_filename_ch2 = kstrdup(filename, GFP_KERNEL);
+	if (!dev->_filename_ch2) {
+		retval = -ENOMEM;
+		goto error;
 	}
 
 	retval =
@@ -851,5 +837,5 @@ int cx25821_vidupstream_init_ch2(struct cx25821_dev *dev, int channel_select,
       error:
 	cx25821_dev_unregister(dev);
 
-	return err;
+	return retval;
 }
diff --git a/drivers/staging/cx25821/cx25821-video-upstream.c b/drivers/staging/cx25821/cx25821-video-upstream.c
index 756a820..465c2b2 100644
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
+	char *filename;
 
 	if (dev->_is_running) {
 		printk(KERN_INFO "Video Channel is still running so return!\n");
@@ -840,37 +839,27 @@ int cx25821_vidupstream_init_ch1(struct cx25821_dev *dev, int channel_select,
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
+	if (dev->input_filename && *dev->input_filename == 0) {
+		/* Default if filename is empty string */
+		if (dev->_isNTSC)
+			filename =
+				(dev->_pixel_format == PIXEL_FRMT_411) ?
+				"/root/vid411.yuv" :
+				"/root/vidtest.yuv";
+		else
+			filename =
+				(dev->_pixel_format == PIXEL_FRMT_411) ?
+				"/root/pal411.yuv" :
+				"/root/pal422.yuv";
+	} else if (dev->input_filename)
+		filename = dev->input_filename;
+	else
+		filename = dev->_defaultname;
 
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
+	dev->_filename = kstrdup(filename, GFP_KERNEL);
+	if (!dev->_filename) {
+		retval = -ENOMEM;
+		goto error;
 	}
 
 	dev->_is_running = 0;
@@ -908,5 +897,5 @@ int cx25821_vidupstream_init_ch1(struct cx25821_dev *dev, int channel_select,
 error:
 	cx25821_dev_unregister(dev);
 
-	return err;
+	return retval;
 }
