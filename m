Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277Ab0JRMZM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 08:25:12 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:37652 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751839Ab0JRMZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 08:25:10 -0400
Date: Mon, 18 Oct 2010 14:25:04 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: walter harms <wharms@bfs.de>
Cc: kernel-janitors@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, gregkh@suse.de
Subject: Re: [PATCH 1/3] drivers/staging/cx25821: Use kstrdup
In-Reply-To: <4CBC12EC.60109@bfs.de>
Message-ID: <Pine.LNX.4.64.1010181421240.25099@ask.diku.dk>
References: <1287341311-11161-1-git-send-email-julia@diku.dk>
 <1287341311-11161-2-git-send-email-julia@diku.dk> <4CBBF407.7060705@bfs.de>
 <Pine.LNX.4.64.1010181019370.22530@ask.diku.dk> <4CBC12EC.60109@bfs.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
As compared to the previous version, this uses kstrdup and it stores the 
selected string in the same field in which it will ultimately allocate new 
memory and copy the selected string.

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
index d12dbb5..2a9c430 100644
--- a/drivers/staging/cx25821/cx25821-video-upstream-ch2.c
+++ b/drivers/staging/cx25821/cx25821-video-upstream-ch2.c
@@ -747,10 +747,8 @@ int cx25821_vidupstream_init_ch2(struct cx25821_dev *dev, int channel_select,
 	struct sram_channel *sram_ch;
 	u32 tmp;
 	int retval = 0;
-	int err = 0;
 	int data_frame_size = 0;
 	int risc_buffer_size = 0;
-	int str_length = 0;
 
 	if (dev->_is_running_ch2) {
 		printk("Video Channel is still running so return!\n");
@@ -789,38 +787,26 @@ int cx25821_vidupstream_init_ch2(struct cx25821_dev *dev, int channel_select,
 	    dev->_isNTSC_ch2 ? NTSC_RISC_BUF_SIZE : PAL_RISC_BUF_SIZE;
 
 	if (dev->input_filename_ch2) {
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
+		/* Default if filename is empty string */
+		if (*dev->input_filename_ch2 == 0) {
+			if (dev->_isNTSC_ch2)
+				dev->_filename_ch2 =
+					(dev->_pixel_format_ch2 ==
+					PIXEL_FRMT_411) ? "/root/vid411.yuv" :
+					"/root/vidtest.yuv";
+			else
+				dev->_filename_ch2 =
+					(dev->_pixel_format_ch2 ==
+					PIXEL_FRMT_411) ? "/root/pal411.yuv" :
+					"/root/pal422.yuv";
+		} else
+			dev->_filename_ch2 = dev->input_filename_ch2;
+	} else
+		dev->_filename_ch2 = dev->_defaultname_ch2;
+	dev->_filename_ch2 = kstrdup(dev->_filename_ch2, GFP_KERNEL);
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
index 756a820..58e67f2 100644
--- a/drivers/staging/cx25821/cx25821-video-upstream.c
+++ b/drivers/staging/cx25821/cx25821-video-upstream.c
@@ -800,10 +800,8 @@ int cx25821_vidupstream_init_ch1(struct cx25821_dev *dev, int channel_select,
 	struct sram_channel *sram_ch;
 	u32 tmp;
 	int retval = 0;
-	int err = 0;
 	int data_frame_size = 0;
 	int risc_buffer_size = 0;
-	int str_length = 0;
 
 	if (dev->_is_running) {
 		printk(KERN_INFO "Video Channel is still running so return!\n");
@@ -841,36 +839,27 @@ int cx25821_vidupstream_init_ch1(struct cx25821_dev *dev, int channel_select,
 	    dev->_isNTSC ? NTSC_RISC_BUF_SIZE : PAL_RISC_BUF_SIZE;
 
 	if (dev->input_filename) {
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
+		/* Default if filename is empty string */
+		if (*dev->input_filename == 0) {
+			if (dev->_isNTSC)
+				dev->_filename =
+					(dev->_pixel_format ==
+					PIXEL_FRMT_411) ? "/root/vid411.yuv" :
+					"/root/vidtest.yuv";
+			else
+				dev->_filename =
+					(dev->_pixel_format ==
+					PIXEL_FRMT_411) ? "/root/pal411.yuv" :
+					"/root/pal422.yuv";
+		} else
+			dev->_filename = dev->input_filename;
+	} else
+		dev->_filename = dev->_defaultname;
+
+	dev->_filename = kstrdup(dev->_filename, GFP_KERNEL);
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
