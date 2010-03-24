Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756719Ab0CXSVy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 14:21:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38603 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753119Ab0CXSVw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 14:21:52 -0400
Message-ID: <4BAA582E.3060801@redhat.com>
Date: Wed, 24 Mar 2010 15:21:34 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: akpm@linux-foundation.org, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org, shu.lin@conexant.com,
       hiep.huynh@conexant.com,
       Linux Media Mailing List <linux-media@vger.kernel.org>,
       Palash Bandyopadhyay <palash.bandyopadhyay@conexant.com>
Subject: Re: mmotm 2010-03-23-15-34 uploaded (staging vs. media)
References: <201003232301.o2NN1bms031050@imap1.linux-foundation.org> <4BAA449F.1060506@oracle.com>
In-Reply-To: <4BAA449F.1060506@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randy,

Randy Dunlap wrote:
> On 03/23/10 15:34, akpm@linux-foundation.org wrote:
>> The mm-of-the-moment snapshot 2010-03-23-15-34 has been uploaded to
>>
>>    http://userweb.kernel.org/~akpm/mmotm/
>>
>> and will soon be available at
>>
>>    git://zen-kernel.org/kernel/mmotm.git
> 
> 
> drivers/staging/cx25821/cx25821-video.c:89:struct cx25821_fmt *format_by_fourcc(unsigned int fourcc)
> (not static)
> 
> conflicts with (has the same non-static name as)
> 
> drivers/media/common/saa7146_video.c:87:struct saa7146_format* format_by_fourcc(struct saa7146_dev *dev, int fourcc)
> 
> 
> so when both of these drivers are built into the kernel image:
> 
> (.text+0x6360): multiple definition of `format_by_fourcc'

The cx25821 driver is capable of simultaneously handling 8 video inputs at the same time,
and 4 video outputs. However, the way it does is by duplicating exactly the same code
8 times, for input, and 4 times, for the output.

Due to that, several symbols that should normally be internal to the driver's code are
exported (see the huge exports list at drivers/staging/cx25821/cx25821-video.h).

The proper fix is to remove all those duplicated code, adding one parameter into the
board struct, with the number of the video input or output.

While this won't happen, I'll add a patch at the tree, renaming its symbols to contain
cx28521 with this small script:

cat drivers/staging/cx25821/cx25821-video.h|perl -ne 'if (m/extern.* ([^\s\*]+)\(/) { $n=$1; print "s/([^\d\w_\.])$1/\\1cx25821_$1/g;\n" if (!($n =~ m/cx25821/)); }' >changes; for i in drivers/staging/cx25821/*.[ch]; do sed -r -f changes $i >a && mv a $i; done

Cheers,
Mauro

---

As reference, those are the only differences between each cx25821-video[0-7].c:

--- drivers/staging/cx25821/cx25821-video1.c	2010-01-28 19:23:33.000000000 -0200
+++ drivers/staging/cx25821/cx25821-video2.c	2010-01-28 19:23:33.000000000 -0200
@@ -30,7 +30,7 @@ static void buffer_queue(struct videobuf
 	struct cx25821_buffer *prev;
 	struct cx25821_fh *fh = vq->priv_data;
 	struct cx25821_dev *dev = fh->dev;
-	struct cx25821_dmaqueue *q = &dev->vidq[SRAM_CH01];
+	struct cx25821_dmaqueue *q = &dev->vidq[SRAM_CH02];
 
 	/* add jump to stopper */
 	buf->risc.jmp[0] = cpu_to_le32(RISC_JUMP | RISC_IRQ1 | RISC_CNT_INC);
@@ -48,7 +48,7 @@ static void buffer_queue(struct videobuf
 	} else if (list_empty(&q->active)) {
 		list_add_tail(&buf->vb.queue, &q->active);
 		cx25821_start_video_dma(dev, q, buf,
-					&dev->sram_channels[SRAM_CH01]);
+					&dev->sram_channels[SRAM_CH02]);
 		buf->vb.state = VIDEOBUF_ACTIVE;
 		buf->count = q->count++;
 		mod_timer(&q->timeout, jiffies + BUFFER_TIMEOUT);
@@ -120,7 +120,7 @@ static int video_open(struct file *file)
 	else
 		fh->height = 480;
 
-	dev->channel_opened = SRAM_CH01;
+	dev->channel_opened = SRAM_CH02;
 	pix_format =
 	    (dev->pixel_formats[dev->channel_opened] ==
 	     PIXEL_FRMT_411) ? V4L2_PIX_FMT_Y41P : V4L2_PIX_FMT_YUYV;
@@ -147,7 +147,7 @@ static ssize_t video_read(struct file *f
 
 	switch (fh->type) {
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
-		if (res_locked(fh->dev, RESOURCE_VIDEO1))
+		if (res_locked(fh->dev, RESOURCE_VIDEO2))
 			return -EBUSY;
 
 		return videobuf_read_one(&fh->vidq, data, count, ppos,
@@ -165,7 +165,7 @@ static unsigned int video_poll(struct fi
 	struct cx25821_fh *fh = file->private_data;
 	struct cx25821_buffer *buf;
 
-	if (res_check(fh, RESOURCE_VIDEO1)) {
+	if (res_check(fh, RESOURCE_VIDEO2)) {
 		/* streaming capture */
 		if (list_empty(&fh->vidq.stream))
 			return POLLERR;
@@ -183,7 +183,7 @@ static unsigned int video_poll(struct fi
 		if (buf->vb.state == VIDEOBUF_DONE) {
 			struct cx25821_dev *dev = fh->dev;
 
-			if (dev && dev->use_cif_resolution[SRAM_CH01]) {
+			if (dev && dev->use_cif_resolution[SRAM_CH02]) {
 				u8 cam_id = *((char *)buf->vb.baddr + 3);
 				memcpy((char *)buf->vb.baddr,
 				       (char *)buf->vb.baddr + (fh->width * 2),
@@ -204,12 +204,12 @@ static int video_release(struct file *fi
 	struct cx25821_dev *dev = fh->dev;
 
 	//stop the risc engine and fifo
-	cx_write(channel1->dma_ctl, 0);	/* FIFO and RISC disable */
+	cx_write(channel2->dma_ctl, 0);	/* FIFO and RISC disable */
 
 	/* stop video capture */
-	if (res_check(fh, RESOURCE_VIDEO1)) {
+	if (res_check(fh, RESOURCE_VIDEO2)) {
 		videobuf_queue_cancel(&fh->vidq);
-		res_free(dev, fh, RESOURCE_VIDEO1);
+		res_free(dev, fh, RESOURCE_VIDEO2);
 	}
 
 	if (fh->vidq.read_buf) {
@@ -239,7 +239,7 @@ static int vidioc_streamon(struct file *
 		return -EINVAL;
 	}
 
-	if (unlikely(!res_get(dev, fh, get_resource(fh, RESOURCE_VIDEO1)))) {
+	if (unlikely(!res_get(dev, fh, get_resource(fh, RESOURCE_VIDEO2)))) {
 		return -EBUSY;
 	}
 
@@ -257,7 +257,7 @@ static int vidioc_streamoff(struct file 
 	if (i != fh->type)
 		return -EINVAL;
 
-	res = get_resource(fh, RESOURCE_VIDEO1);
+	res = get_resource(fh, RESOURCE_VIDEO2);
 	err = videobuf_streamoff(get_queue(fh));
 	if (err < 0)
 		return err;
@@ -304,16 +304,16 @@ static int vidioc_s_fmt_vid_cap(struct f
 	else
 		return -EINVAL;
 
-	cx25821_set_pixel_format(dev, SRAM_CH01, pix_format);
+	cx25821_set_pixel_format(dev, SRAM_CH02, pix_format);
 
 	// check if cif resolution
 	if (fh->width == 320 || fh->width == 352) {
-		dev->use_cif_resolution[SRAM_CH01] = 1;
+		dev->use_cif_resolution[SRAM_CH02] = 1;
 	} else {
-		dev->use_cif_resolution[SRAM_CH01] = 0;
+		dev->use_cif_resolution[SRAM_CH02] = 0;
 	}
-	dev->cif_width[SRAM_CH01] = fh->width;
-	medusa_set_resolution(dev, fh->width, SRAM_CH01);
+	dev->cif_width[SRAM_CH02] = fh->width;
+	medusa_set_resolution(dev, fh->width, SRAM_CH02);
 
 	dprintk(2, "%s() width=%d height=%d field=%d\n", __func__, fh->width,
 		fh->height, fh->vidq.field);
@@ -330,7 +330,7 @@ static int vidioc_dqbuf(struct file *fil
 
 	ret_val = videobuf_dqbuf(get_queue(fh), p, file->f_flags & O_NONBLOCK);
 
-	p->sequence = dev->vidq[SRAM_CH01].count;
+	p->sequence = dev->vidq[SRAM_CH02].count;
 
 	return ret_val;
 }
@@ -340,15 +340,17 @@ static int vidioc_log_status(struct file
 	struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
 	char name[32 + 2];
 
-	struct sram_channel *sram_ch = &dev->sram_channels[SRAM_CH01];
+	struct sram_channel *sram_ch = &dev->sram_channels[SRAM_CH02];
 	u32 tmp = 0;
 
 	snprintf(name, sizeof(name), "%s/2", dev->name);
 	printk(KERN_INFO "%s/2: ============  START LOG STATUS  ============\n",
 	       dev->name);
+
 	cx25821_call_all(dev, core, log_status);
+
 	tmp = cx_read(sram_ch->dma_ctl);
-	printk(KERN_INFO "Video input 1 is %s\n",
+	printk(KERN_INFO "Video input 2 is %s\n",
 	       (tmp & 0x11) ? "streaming" : "stopped");
 	printk(KERN_INFO "%s/2: =============  END LOG STATUS  =============\n",
 	       dev->name);
@@ -368,10 +370,10 @@ static int vidioc_s_ctrl(struct file *fi
 			return err;
 	}
 
-	return cx25821_set_control(dev, ctl, SRAM_CH01);
+	return cx25821_set_control(dev, ctl, SRAM_CH02);
 }
 
-//exported stuff
+// exported stuff
 static const struct v4l2_file_operations video_fops = {
 	.owner = THIS_MODULE,
 	.open = video_open,
@@ -425,7 +427,7 @@ static const struct v4l2_ioctl_ops video
 #endif
 };
 
-struct video_device cx25821_video_template1 = {
+struct video_device cx25821_video_template2 = {
 	.name = "cx25821-video",
 	.fops = &video_fops,
 	.ioctl_ops = &video_ioctl_ops,

-- 

Cheers,
Mauro
