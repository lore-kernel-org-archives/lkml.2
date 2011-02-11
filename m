Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799Ab1BKMZE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 07:25:04 -0500
Received: from ni.piap.pl ([195.187.100.4]:49009 "EHLO ni.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754006Ab1BKMZB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 07:25:01 -0500
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: Ben Collins <bcollins@bluecherry.net>, linux-kernel@vger.kernel.org
References: <m3sjvurd2f.fsf@t19.piap.pl>
Date: Fri, 11 Feb 2011 13:25:00 +0100
In-Reply-To: <m3sjvurd2f.fsf@t19.piap.pl> ("Krzysztof =?utf-8?Q?Ha=C5=82as?=
 =?utf-8?Q?a=22's?= message of
	"Fri, 11 Feb 2011 13:05:44 +0100")
MIME-Version: 1.0
Message-ID: <m3hbcarc6b.fsf@t19.piap.pl>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Subject: [PATCH 2/7] Solo6x10: Build MPEG4 headers on the fly.
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE,
	 bases: 20101209 #4187514, check: 20110211 clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will make them maintainable. Also, it now works on big-endian systems.

This is the slow path (done every 1+ second, per channel) so I guess
there is no need to cache the results.

I have removed CBR-related bits from the MPEG4 VOL header since we can't
do CBR (at least yet).

Signed-off-by: Krzysztof Hałasa <khalasa@piap.pl>

diff --git a/drivers/staging/solo6x10/solo6010-registers.h b/drivers/staging/solo6x10/solo6010-registers.h
index d39d3c6..a1dad57 100644
--- a/drivers/staging/solo6x10/solo6010-registers.h
+++ b/drivers/staging/solo6x10/solo6010-registers.h
@@ -402,46 +402,6 @@
 #define	  SOLO_DCT_INTERVAL(n)			((n)<<16)
 
 #define SOLO_VE_STATE(n)			(0x0640+((n)*4))
-struct videnc_status {
-	union {
-		u32 status0;
-		struct {
-			u32 mp4_enc_code_size:20, sad_motion:1, vid_motion:1,
-			    vop_type:2, video_channel:5, source_field_idx:1,
-			    interlace:1, progressive:1;
-		} status0_st;
-	};
-	union {
-		u32 status1;
-		struct {
-			u32 vsize:8, hsize:8, last_queue:4, foo1:8, scale:4;
-		} status1_st;
-	};
-	union {
-		u32 status4;
-		struct {
-			u32 jpeg_code_size:20, interval:10, foo1:2;
-		} status4_st;
-	};
-	union {
-		u32 status9;
-		struct {
-			u32 channel:5, foo1:27;
-		} status9_st;
-	};
-	union {
-		u32 status10;
-		struct {
-			u32 mp4_code_size:20, foo:12;
-		} status10_st;
-	};
-	union {
-		u32 status11;
-		struct {
-			u32 last_queue:8, foo1:24;
-		} status11_st;
-	};
-};
 
 #define SOLO_VE_JPEG_QP_TBL			0x0670
 #define SOLO_VE_JPEG_QP_CH_L			0x0674
diff --git a/drivers/staging/solo6x10/solo6010-v4l2-enc.c b/drivers/staging/solo6x10/solo6010-v4l2-enc.c
index 2b3d30b..47f6e04 100644
--- a/drivers/staging/solo6x10/solo6010-v4l2-enc.c
+++ b/drivers/staging/solo6x10/solo6010-v4l2-enc.c
@@ -50,28 +50,6 @@ struct solo_enc_fh {
 	struct p2m_desc		desc[SOLO_NR_P2M_DESC];
 };
 
-static unsigned char vid_vop_header[] = {
-	0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, 0x20,
-	0x02, 0x48, 0x05, 0xc0, 0x00, 0x40, 0x00, 0x40,
-	0x00, 0x40, 0x00, 0x80, 0x00, 0x97, 0x53, 0x04,
-	0x1f, 0x4c, 0x58, 0x10, 0x78, 0x51, 0x18, 0x3f,
-};
-
-/*
- * Things we can change around:
- *
- * byte  10,        4-bits 01111000                   aspect
- * bytes 21,22,23  16-bits 000x1111 11111111 1111x000 fps/res
- * bytes 23,24,25  15-bits 00000n11 11111111 11111x00 interval
- * bytes 25,26,27  13-bits 00000x11 11111111 111x0000 width
- * bytes 27,28,29  13-bits 000x1111 11111111 1x000000 height
- * byte  29         1-bit  0x100000                   interlace
- */
-
-/* For aspect */
-#define XVID_PAR_43_PAL		2
-#define XVID_PAR_43_NTSC	3
-
 static const u32 solo_user_ctrls[] = {
 	V4L2_CID_BRIGHTNESS,
 	V4L2_CID_CONTRAST,
@@ -106,30 +84,6 @@ static const u32 *solo_ctrl_classes[] = {
 	NULL
 };
 
-struct vop_header {
-	/* VD_IDX0 */
-	u32 size:20, sync_start:1, page_stop:1, vop_type:2, channel:4,
-		nop0:1, source_fl:1, interlace:1, progressive:1;
-
-	/* VD_IDX1 */
-	u32 vsize:8, hsize:8, frame_interop:1, nop1:7, win_id:4, scale:4;
-
-	/* VD_IDX2 */
-	u32 base_addr:16, nop2:15, hoff:1;
-
-	/* VD_IDX3 - User set macros */
-	u32 sy:12, sx:12, nop3:1, hzoom:1, read_interop:1, write_interlace:1,
-		scale_mode:4;
-
-	/* VD_IDX4 - User set macros continued */
-	u32 write_page:8, nop4:24;
-
-	/* VD_IDX5 */
-	u32 next_code_addr;
-
-	u32 end_nops[10];
-} __attribute__((packed));
-
 static int solo_is_motion_on(struct solo_enc_dev *solo_enc)
 {
 	struct solo6010_dev *solo_dev = solo_enc->solo_dev;
@@ -483,13 +437,121 @@ static int solo_fill_jpeg(struct solo_enc_fh *fh, struct solo_enc_buf *enc_buf,
 				   enc_buf->jpeg_off, size);
 }
 
+static inline int vop_interlaced(__le32 *vh)
+{
+	return (__le32_to_cpu(vh[0]) >> 30) & 1;
+}
+
+static inline u32 vop_size(__le32 *vh)
+{
+	return __le32_to_cpu(vh[0]) & 0xFFFFF;
+}
+
+static inline u8 vop_hsize(__le32 *vh)
+{
+	return (__le32_to_cpu(vh[1]) >> 8) & 0xFF;
+}
+
+static inline u8 vop_vsize(__le32 *vh)
+{
+	return __le32_to_cpu(vh[1]) & 0xFF;
+}
+
+/* must be called with *bits % 8 = 0 */
+static void write_bytes(u8 **out, unsigned *bits, const u8 *src, unsigned count)
+{
+	memcpy(*out, src, count);
+	*out += count;
+	*bits += count * 8;
+}
+
+static void write_bits(u8 **out, unsigned *bits, u32 value, unsigned count)
+{
+
+	value <<= 32 - count; // shift to the right
+
+	while (count--) {
+		**out <<= 1;
+		**out |= !!(value & (1 << 31)); /* MSB */
+		value <<= 1;
+		if (++(*bits) % 8 == 0)
+			(*out)++;
+	}
+}
+
+static void write_mpeg4_end(u8 **out, unsigned *bits)
+{
+	write_bits(out, bits, 0, 1);
+	/* align on 32-bit boundary */
+	if (*bits % 32)
+		write_bits(out, bits, 0xFFFFFFFF, 32 - *bits % 32);
+}
+
+static void mpeg4_write_vol(u8 **out, struct solo6010_dev *solo_dev,
+			    __le32 *vh, unsigned fps, unsigned interval)
+{
+	static const u8 hdr[] = {
+		0, 0, 1, 0x00 /* video_object_start_code */,
+		0, 0, 1, 0x20 /* video_object_layer_start_code */
+	};
+	unsigned bits = 0;
+	unsigned width = vop_hsize(vh) << 4;
+	unsigned height = vop_vsize(vh) << 4;
+	unsigned interlaced = vop_interlaced(vh);
+
+	write_bytes(out, &bits, hdr, sizeof(hdr));
+	write_bits(out, &bits,    0,  1); /* random_accessible_vol */
+	write_bits(out, &bits, 0x04,  8); /* video_object_type_indication: main */
+	write_bits(out, &bits,    1,  1); /* is_object_layer_identifier */
+	write_bits(out, &bits,    2,  4); /* video_object_layer_verid: table V2-39 */
+	write_bits(out, &bits,    0,  3); /* video_object_layer_priority */
+	if (solo_dev->video_type == SOLO_VO_FMT_TYPE_NTSC)
+		write_bits(out, &bits,  3,  4); /* aspect_ratio_info, assuming 4:3 */
+	else
+		write_bits(out, &bits,  2,  4);
+	write_bits(out, &bits,    1,  1); /* vol_control_parameters */
+	write_bits(out, &bits,    1,  2); /* chroma_format: 4:2:0 */
+	write_bits(out, &bits,    1,  1); /* low_delay */
+	write_bits(out, &bits,    0,  1); /* vbv_parameters */
+	write_bits(out, &bits,    0,  2); /* video_object_layer_shape: rectangular */
+	write_bits(out, &bits,    1,  1); /* marker_bit */
+	write_bits(out, &bits,  fps, 16); /* vop_time_increment_resolution */
+	write_bits(out, &bits,    1,  1); /* marker_bit */
+	write_bits(out, &bits,    1,  1); /* fixed_vop_rate */
+	write_bits(out, &bits, interval, 15); /* fixed_vop_time_increment */
+	write_bits(out, &bits,    1,  1); /* marker_bit */
+	write_bits(out, &bits, width, 13); /* video_object_layer_width */
+	write_bits(out, &bits,    1,  1); /* marker_bit */
+	write_bits(out, &bits, height, 13); /* video_object_layer_height */
+	write_bits(out, &bits,    1,  1); /* marker_bit */
+	write_bits(out, &bits, interlaced, 1); /* interlaced */
+	write_bits(out, &bits,    1,  1); /* obmc_disable */
+	write_bits(out, &bits,    0,  2); /* sprite_enable */
+	write_bits(out, &bits,    0,  1); /* not_8_bit */
+	write_bits(out, &bits,    1,  0); /* quant_type */
+	write_bits(out, &bits,    0,  1); /* load_intra_quant_mat */
+	write_bits(out, &bits,    0,  1); /* load_nonintra_quant_mat */
+	write_bits(out, &bits,    0,  1); /* quarter_sample */
+	write_bits(out, &bits,    1,  1); /* complexity_estimation_disable */
+	write_bits(out, &bits,    1,  1); /* resync_marker_disable */
+	write_bits(out, &bits,    0,  1); /* data_partitioned */
+	write_bits(out, &bits,    0,  1); /* newpred_enable */
+	write_bits(out, &bits,    0,  1); /* reduced_resolution_vop_enable */
+	write_bits(out, &bits,    0,  1); /* scalability */
+	write_mpeg4_end(out, &bits);
+}
+
 static int solo_fill_mpeg(struct solo_enc_fh *fh, struct solo_enc_buf *enc_buf,
 			  struct videobuf_buffer *vb,
 			  struct videobuf_dmabuf *vbuf)
 {
 	struct solo_enc_dev *solo_enc = fh->enc;
 	struct solo6010_dev *solo_dev = solo_enc->solo_dev;
-	struct vop_header vh;
+
+#define VH_WORDS 16
+#define MAX_VOL_HEADER_LENGTH 64
+
+	__le32 vh[VH_WORDS];
 	int ret;
 	int frame_size, frame_off;
 	int skip = 0;
@@ -498,50 +560,27 @@ static int solo_fill_mpeg(struct solo_enc_fh *fh, struct solo_enc_buf *enc_buf,
 		return -EINVAL;
 
 	/* First get the hardware vop header (not real mpeg) */
-	ret = enc_get_mpeg_dma(solo_dev, &vh, enc_buf->off, sizeof(vh));
+	ret = enc_get_mpeg_dma(solo_dev, vh, enc_buf->off, sizeof(vh));
 	if (WARN_ON_ONCE(ret))
 		return ret;
 
-	if (WARN_ON_ONCE(vh.size > enc_buf->size))
+	if (WARN_ON_ONCE(vop_size(vh) > enc_buf->size))
 		return -EINVAL;
 
-	vb->width = vh.hsize << 4;
-	vb->height = vh.vsize << 4;
-	vb->size = vh.size;
+	vb->width = vop_hsize(vh) << 4;
+	vb->height = vop_vsize(vh) << 4;
+	vb->size = vop_size(vh);
 
 	/* If this is a key frame, add extra m4v header */
 	if (!enc_buf->vop) {
-		u16 fps = solo_dev->fps * 1000;
-		u16 interval = solo_enc->interval * 1000;
-		u8 p[sizeof(vid_vop_header)];
-
-		memcpy(p, vid_vop_header, sizeof(p));
-
-		if (solo_dev->video_type == SOLO_VO_FMT_TYPE_NTSC)
-			p[10] |= ((XVID_PAR_43_NTSC << 3) & 0x78);
-		else
-			p[10] |= ((XVID_PAR_43_PAL << 3) & 0x78);
-
-		/* Frame rate and interval */
-		p[22] = fps >> 4;
-		p[23] = ((fps << 4) & 0xf0) | 0x0c | ((interval >> 13) & 0x3);
-		p[24] = (interval >> 5) & 0xff;
-		p[25] = ((interval << 3) & 0xf8) | 0x04;
-
-		/* Width and height */
-		p[26] = (vb->width >> 3) & 0xff;
-		p[27] = ((vb->height >> 9) & 0x0f) | 0x10;
-		p[28] = (vb->height >> 1) & 0xff;
-
-		/* Interlace */
-		if (vh.interlace)
-			p[29] |= 0x20;
-
-		enc_write_sg(vbuf->sglist, p, sizeof(p));
+		u8 header[MAX_VOL_HEADER_LENGTH], *out = header;
 
+		mpeg4_write_vol(&out, solo_dev, vh, solo_dev->fps * 1000,
+				solo_enc->interval * 1000);
+		skip = out - header;
+		enc_write_sg(vbuf->sglist, header, skip);
 		/* Adjust the dma buffer past this header */
-		vb->size += sizeof(vid_vop_header);
-		skip = sizeof(vid_vop_header);
+		vb->size += skip;
 	}
 
 	/* Now get the actual mpeg payload */
@@ -704,7 +743,6 @@ void solo_motion_isr(struct solo6010_dev *solo_dev)
 void solo_enc_v4l2_isr(struct solo6010_dev *solo_dev)
 {
 	struct solo_enc_buf *enc_buf;
-	struct videnc_status vstatus;
 	u32 mpeg_current, mpeg_next, mpeg_size;
 	u32 jpeg_current, jpeg_next, jpeg_size;
 	u32 reg_mpeg_size;
@@ -714,12 +752,9 @@ void solo_enc_v4l2_isr(struct solo6010_dev *solo_dev)
 
 	solo_reg_write(solo_dev, SOLO_IRQ_STAT, SOLO_IRQ_ENCODER);
 
-	vstatus.status11 = solo_reg_read(solo_dev, SOLO_VE_STATE(11));
-	cur_q = (vstatus.status11_st.last_queue + 1) % MP4_QS;
+	cur_q = ((solo_reg_read(solo_dev, SOLO_VE_STATE(11)) & 0xF) + 1) % MP4_QS;
 
-	vstatus.status0 = solo_reg_read(solo_dev, SOLO_VE_STATE(0));
-	reg_mpeg_size = (vstatus.status0_st.mp4_enc_code_size + 64 + 32) &
-			(~31);
+	reg_mpeg_size = ((solo_reg_read(solo_dev, SOLO_VE_STATE(0)) & 0xFFFFF) + 64 + 32) & ~31;
 
 	while (solo_dev->enc_idx != cur_q) {
 		mpeg_current = solo_reg_read(solo_dev,

-- 
Krzysztof Halasa

Research Institute for Automation and Measurements
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
