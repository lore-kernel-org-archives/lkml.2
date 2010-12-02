Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757199Ab0LBEUo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 23:20:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63665 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757176Ab0LBEUn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 23:20:43 -0500
Message-ID: <4CF71E98.9030007@redhat.com>
Date: Thu, 02 Dec 2010 02:20:40 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100827 Red Hat/3.1.3-1.el6 Lightning/1.0b2 Thunderbird/3.1.3
MIME-Version: 1.0
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] [media] Don't export format_by_forcc on two different drivers
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drivers should append their name on exported symbols, to avoid
conflicts with allyesconfig:

drivers/staging/built-in.o: In function `format_by_fourcc':
/home/v4l/work_trees/linus/drivers/staging/cx25821/cx25821-video.c:96: multiple definition of `format_by_fourcc'
drivers/media/built-in.o:/home/v4l/work_trees/linus/drivers/media/common/saa7146_video.c:88: first defined here

Let's rename both occurences with a small shellscript:

for i in drivers/staging/cx25821/*.[ch]; do sed s,format_by_fourcc,cx25821_format_by_fourcc,g <$i >a && mv a $i; done
for i in drivers/media/common/saa7146*.[ch]; do sed s,format_by_fourcc,saa7146_format_by_fourcc,g <$i >a && mv a $i; done
for i in include/media/saa7146*.[ch]; do sed s,format_by_fourcc,saa7146_format_by_fourcc,g <$i >a && mv a $i; done

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/common/saa7146_hlp.c b/drivers/media/common/saa7146_hlp.c
index 05bde9c..1d1d8d2 100644
--- a/drivers/media/common/saa7146_hlp.c
+++ b/drivers/media/common/saa7146_hlp.c
@@ -558,7 +558,7 @@ static void saa7146_set_window(struct saa7146_dev *dev, int width, int height, e
 static void saa7146_set_position(struct saa7146_dev *dev, int w_x, int w_y, int w_height, enum v4l2_field field, u32 pixelformat)
 {
 	struct saa7146_vv *vv = dev->vv_data;
-	struct saa7146_format *sfmt = format_by_fourcc(dev, pixelformat);
+	struct saa7146_format *sfmt = saa7146_format_by_fourcc(dev, pixelformat);
 
 	int b_depth = vv->ov_fmt->depth;
 	int b_bpl = vv->ov_fb.fmt.bytesperline;
@@ -702,7 +702,7 @@ static int calculate_video_dma_grab_packed(struct saa7146_dev* dev, struct saa71
 	struct saa7146_vv *vv = dev->vv_data;
 	struct saa7146_video_dma vdma1;
 
-	struct saa7146_format *sfmt = format_by_fourcc(dev,buf->fmt->pixelformat);
+	struct saa7146_format *sfmt = saa7146_format_by_fourcc(dev,buf->fmt->pixelformat);
 
 	int width = buf->fmt->width;
 	int height = buf->fmt->height;
@@ -827,7 +827,7 @@ static int calculate_video_dma_grab_planar(struct saa7146_dev* dev, struct saa71
 	struct saa7146_video_dma vdma2;
 	struct saa7146_video_dma vdma3;
 
-	struct saa7146_format *sfmt = format_by_fourcc(dev,buf->fmt->pixelformat);
+	struct saa7146_format *sfmt = saa7146_format_by_fourcc(dev,buf->fmt->pixelformat);
 
 	int width = buf->fmt->width;
 	int height = buf->fmt->height;
@@ -994,7 +994,7 @@ static void program_capture_engine(struct saa7146_dev *dev, int planar)
 
 void saa7146_set_capture(struct saa7146_dev *dev, struct saa7146_buf *buf, struct saa7146_buf *next)
 {
-	struct saa7146_format *sfmt = format_by_fourcc(dev,buf->fmt->pixelformat);
+	struct saa7146_format *sfmt = saa7146_format_by_fourcc(dev,buf->fmt->pixelformat);
 	struct saa7146_vv *vv = dev->vv_data;
 	u32 vdma1_prot_addr;
 
diff --git a/drivers/media/common/saa7146_video.c b/drivers/media/common/saa7146_video.c
index 741c573..d246910 100644
--- a/drivers/media/common/saa7146_video.c
+++ b/drivers/media/common/saa7146_video.c
@@ -84,7 +84,7 @@ static struct saa7146_format formats[] = {
 
 static int NUM_FORMATS = sizeof(formats)/sizeof(struct saa7146_format);
 
-struct saa7146_format* format_by_fourcc(struct saa7146_dev *dev, int fourcc)
+struct saa7146_format* saa7146_format_by_fourcc(struct saa7146_dev *dev, int fourcc)
 {
 	int i, j = NUM_FORMATS;
 
@@ -266,7 +266,7 @@ static int saa7146_pgtable_build(struct saa7146_dev *dev, struct saa7146_buf *bu
 	struct videobuf_dmabuf *dma=videobuf_to_dma(&buf->vb);
 	struct scatterlist *list = dma->sglist;
 	int length = dma->sglen;
-	struct saa7146_format *sfmt = format_by_fourcc(dev,buf->fmt->pixelformat);
+	struct saa7146_format *sfmt = saa7146_format_by_fourcc(dev,buf->fmt->pixelformat);
 
 	DEB_EE(("dev:%p, buf:%p, sg_len:%d\n",dev,buf,length));
 
@@ -408,7 +408,7 @@ static int video_begin(struct saa7146_fh *fh)
 		}
 	}
 
-	fmt = format_by_fourcc(dev,fh->video_fmt.pixelformat);
+	fmt = saa7146_format_by_fourcc(dev,fh->video_fmt.pixelformat);
 	/* we need to have a valid format set here */
 	BUG_ON(NULL == fmt);
 
@@ -460,7 +460,7 @@ static int video_end(struct saa7146_fh *fh, struct file *file)
 		return -EBUSY;
 	}
 
-	fmt = format_by_fourcc(dev,fh->video_fmt.pixelformat);
+	fmt = saa7146_format_by_fourcc(dev,fh->video_fmt.pixelformat);
 	/* we need to have a valid format set here */
 	BUG_ON(NULL == fmt);
 
@@ -536,7 +536,7 @@ static int vidioc_s_fbuf(struct file *file, void *fh, struct v4l2_framebuffer *f
 		return -EPERM;
 
 	/* check args */
-	fmt = format_by_fourcc(dev, fb->fmt.pixelformat);
+	fmt = saa7146_format_by_fourcc(dev, fb->fmt.pixelformat);
 	if (NULL == fmt)
 		return -EINVAL;
 
@@ -760,7 +760,7 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *fh, struct v4l2_forma
 
 	DEB_EE(("V4L2_BUF_TYPE_VIDEO_CAPTURE: dev:%p, fh:%p\n", dev, fh));
 
-	fmt = format_by_fourcc(dev, f->fmt.pix.pixelformat);
+	fmt = saa7146_format_by_fourcc(dev, f->fmt.pix.pixelformat);
 	if (NULL == fmt)
 		return -EINVAL;
 
@@ -1264,7 +1264,7 @@ static int buffer_prepare(struct videobuf_queue *q,
 		buf->fmt       = &fh->video_fmt;
 		buf->vb.field  = fh->video_fmt.field;
 
-		sfmt = format_by_fourcc(dev,buf->fmt->pixelformat);
+		sfmt = saa7146_format_by_fourcc(dev,buf->fmt->pixelformat);
 
 		release_all_pagetables(dev, buf);
 		if( 0 != IS_PLANAR(sfmt->trans)) {
@@ -1378,7 +1378,7 @@ static int video_open(struct saa7146_dev *dev, struct file *file)
 	fh->video_fmt.pixelformat = V4L2_PIX_FMT_BGR24;
 	fh->video_fmt.bytesperline = 0;
 	fh->video_fmt.field = V4L2_FIELD_ANY;
-	sfmt = format_by_fourcc(dev,fh->video_fmt.pixelformat);
+	sfmt = saa7146_format_by_fourcc(dev,fh->video_fmt.pixelformat);
 	fh->video_fmt.sizeimage = (fh->video_fmt.width * fh->video_fmt.height * sfmt->depth)/8;
 
 	videobuf_queue_sg_init(&fh->video_q, &video_qops,
diff --git a/drivers/staging/cx25821/cx25821-video.c b/drivers/staging/cx25821/cx25821-video.c
index e7f1d57..5238930 100644
--- a/drivers/staging/cx25821/cx25821-video.c
+++ b/drivers/staging/cx25821/cx25821-video.c
@@ -92,7 +92,7 @@ int cx25821_get_format_size(void)
 	return ARRAY_SIZE(formats);
 }
 
-struct cx25821_fmt *format_by_fourcc(unsigned int fourcc)
+struct cx25821_fmt *cx25821_format_by_fourcc(unsigned int fourcc)
 {
 	unsigned int i;
 
@@ -848,7 +848,7 @@ static int video_open(struct file *file)
        pix_format =
 	   (dev->channels[ch_id].pixel_formats ==
 	    PIXEL_FRMT_411) ? V4L2_PIX_FMT_Y41P : V4L2_PIX_FMT_YUYV;
-       fh->fmt = format_by_fourcc(pix_format);
+       fh->fmt = cx25821_format_by_fourcc(pix_format);
 
        v4l2_prio_open(&dev->channels[ch_id].prio, &fh->prio);
 
@@ -1010,7 +1010,7 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
        if (0 != err)
 	       return err;
 
-       fh->fmt = format_by_fourcc(f->fmt.pix.pixelformat);
+       fh->fmt = cx25821_format_by_fourcc(f->fmt.pix.pixelformat);
        fh->vidq.field = f->fmt.pix.field;
 
        /* check if width and height is valid based on set standard */
@@ -1119,7 +1119,7 @@ int cx25821_vidioc_try_fmt_vid_cap(struct file *file, void *priv, struct v4l2_fo
 	enum v4l2_field field;
 	unsigned int maxw, maxh;
 
-	fmt = format_by_fourcc(f->fmt.pix.pixelformat);
+	fmt = cx25821_format_by_fourcc(f->fmt.pix.pixelformat);
 	if (NULL == fmt)
 		return -EINVAL;
 
diff --git a/drivers/staging/cx25821/cx25821-video.h b/drivers/staging/cx25821/cx25821-video.h
index cc6034b..a2415d3 100644
--- a/drivers/staging/cx25821/cx25821-video.h
+++ b/drivers/staging/cx25821/cx25821-video.h
@@ -87,7 +87,7 @@ extern unsigned int vid_limit;
 
 #define FORMAT_FLAGS_PACKED       0x01
 extern struct cx25821_fmt formats[];
-extern struct cx25821_fmt *format_by_fourcc(unsigned int fourcc);
+extern struct cx25821_fmt *cx25821_format_by_fourcc(unsigned int fourcc);
 extern struct cx25821_data timeout_data[MAX_VID_CHANNEL_NUM];
 
 extern void cx25821_dump_video_queue(struct cx25821_dev *dev,
diff --git a/include/media/saa7146.h b/include/media/saa7146.h
index 7a9f76e..ac7ce00 100644
--- a/include/media/saa7146.h
+++ b/include/media/saa7146.h
@@ -161,7 +161,7 @@ extern struct list_head saa7146_devices;
 extern struct mutex saa7146_devices_lock;
 int saa7146_register_extension(struct saa7146_extension*);
 int saa7146_unregister_extension(struct saa7146_extension*);
-struct saa7146_format* format_by_fourcc(struct saa7146_dev *dev, int fourcc);
+struct saa7146_format* saa7146_format_by_fourcc(struct saa7146_dev *dev, int fourcc);
 int saa7146_pgtable_alloc(struct pci_dev *pci, struct saa7146_pgtable *pt);
 void saa7146_pgtable_free(struct pci_dev *pci, struct saa7146_pgtable *pt);
 int saa7146_pgtable_build_single(struct pci_dev *pci, struct saa7146_pgtable *pt, struct scatterlist *list, int length );
-- 
1.7.1

