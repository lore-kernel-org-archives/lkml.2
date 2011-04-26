Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756666Ab1DZGcY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 02:32:24 -0400
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:3873 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495Ab1DZGcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 02:32:22 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: [PATCH] usbvision: remove (broken) image format conversion
Date: Tue, 26 Apr 2011 08:32:11 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.38-tschai; KDE/4.6.1; x86_64; ; )
Cc: Joerg Heckenbach <joerg@heckenbach-aw.de>,
        Dwaine Garden <dwainegarden@rogers.com>, linux-media@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>
References: <201104252323.20420.linux@rainbow-software.org>
In-Reply-To: <201104252323.20420.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104260832.11150.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, April 25, 2011 23:23:17 Ondrej Zary wrote:
> The YVU420 and YUV422P formats are broken and cause kernel panic on use.
> (YVU420 does not work and sometimes causes "unable to handle paging request"
> panic, YUV422P always causes "NULL pointer dereference").
> 
> As V4L2 spec says that drivers shouldn't do any in-kernel image format
> conversion, remove it completely (except YUYV).

What really should happen is that the conversion is moved to libv4lconvert.
I've never had the time to tackle that, but it would improve this driver a
lot.

Would you perhaps be interested in doing that work?

> The removal also reveals an off-by-one bug in enum_fmt ioctl - it misses the
> last format, so this patch fixes it too.

Good. But why are the GREY/RGB formats also removed? Are those broken as well?

Regards,

	Hans

> 
> This allows the driver to work with mplayer without need to manually specify a
> format and also to work with VLC without causing kernel panic.
> 
> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
> 
> diff -up linux-2.6.39-rc2-/drivers/media/video/usbvision/usbvision-core.c linux-2.6.39-rc2/drivers/media/video/usbvision/usbvision-core.c
> --- linux-2.6.39-rc2-/drivers/media/video/usbvision/usbvision-core.c	2011-04-25 22:30:09.000000000 +0200
> +++ linux-2.6.39-rc2/drivers/media/video/usbvision/usbvision-core.c	2011-04-25 23:07:46.000000000 +0200
> @@ -586,9 +586,8 @@ static enum parse_state usbvision_parse_
>  	int len;
>  	int i;
>  	unsigned char yuyv[4] = { 180, 128, 10, 128 }; /* YUV components */
> -	unsigned char rv, gv, bv;	/* RGB components */
> -	int clipmask_index, bytes_per_pixel;
> -	int stretch_bytes, clipmask_add;
> +	int bytes_per_pixel;
> +	int stretch_bytes;
>  
>  	frame  = usbvision->cur_frame;
>  	f = frame->data + (frame->v4l2_linesize * frame->curline);
> @@ -605,78 +604,16 @@ static enum parse_state usbvision_parse_
>  
>  	bytes_per_pixel = frame->v4l2_format.bytes_per_pixel;
>  	stretch_bytes = (usbvision->stretch_width - 1) * bytes_per_pixel;
> -	clipmask_index = frame->curline * MAX_FRAME_WIDTH;
> -	clipmask_add = usbvision->stretch_width;
>  
>  	for (i = 0; i < frame->frmwidth; i += (2 * usbvision->stretch_width)) {
>  		scratch_get(usbvision, &yuyv[0], 4);
>  
> -		if (frame->v4l2_format.format == V4L2_PIX_FMT_YUYV) {
> -			*f++ = yuyv[0]; /* Y */
> -			*f++ = yuyv[3]; /* U */
> -		} else {
> -			YUV_TO_RGB_BY_THE_BOOK(yuyv[0], yuyv[1], yuyv[3], rv, gv, bv);
> -			switch (frame->v4l2_format.format) {
> -			case V4L2_PIX_FMT_RGB565:
> -				*f++ = (0x1F & rv) |
> -					(0xE0 & (gv << 5));
> -				*f++ = (0x07 & (gv >> 3)) |
> -					(0xF8 &  bv);
> -				break;
> -			case V4L2_PIX_FMT_RGB24:
> -				*f++ = rv;
> -				*f++ = gv;
> -				*f++ = bv;
> -				break;
> -			case V4L2_PIX_FMT_RGB32:
> -				*f++ = rv;
> -				*f++ = gv;
> -				*f++ = bv;
> -				f++;
> -				break;
> -			case V4L2_PIX_FMT_RGB555:
> -				*f++ = (0x1F & rv) |
> -					(0xE0 & (gv << 5));
> -				*f++ = (0x03 & (gv >> 3)) |
> -					(0x7C & (bv << 2));
> -				break;
> -			}
> -		}
> -		clipmask_index += clipmask_add;
> +		*f++ = yuyv[0]; /* Y */
> +		*f++ = yuyv[3]; /* U */
>  		f += stretch_bytes;
>  
> -		if (frame->v4l2_format.format == V4L2_PIX_FMT_YUYV) {
> -			*f++ = yuyv[2]; /* Y */
> -			*f++ = yuyv[1]; /* V */
> -		} else {
> -			YUV_TO_RGB_BY_THE_BOOK(yuyv[2], yuyv[1], yuyv[3], rv, gv, bv);
> -			switch (frame->v4l2_format.format) {
> -			case V4L2_PIX_FMT_RGB565:
> -				*f++ = (0x1F & rv) |
> -					(0xE0 & (gv << 5));
> -				*f++ = (0x07 & (gv >> 3)) |
> -					(0xF8 &  bv);
> -				break;
> -			case V4L2_PIX_FMT_RGB24:
> -				*f++ = rv;
> -				*f++ = gv;
> -				*f++ = bv;
> -				break;
> -			case V4L2_PIX_FMT_RGB32:
> -				*f++ = rv;
> -				*f++ = gv;
> -				*f++ = bv;
> -				f++;
> -				break;
> -			case V4L2_PIX_FMT_RGB555:
> -				*f++ = (0x1F & rv) |
> -					(0xE0 & (gv << 5));
> -				*f++ = (0x03 & (gv >> 3)) |
> -					(0x7C & (bv << 2));
> -				break;
> -			}
> -		}
> -		clipmask_index += clipmask_add;
> +		*f++ = yuyv[2]; /* Y */
> +		*f++ = yuyv[1]; /* V */
>  		f += stretch_bytes;
>  	}
>  
> @@ -794,30 +731,20 @@ static enum parse_state usbvision_parse_
>  	unsigned char strip_data[USBVISION_STRIP_LEN_MAX];
>  	unsigned char strip_header[USBVISION_STRIP_HEADER_LEN];
>  	int idx, idx_end, strip_len, strip_ptr, startblock_pos, block_pos, block_type_pos;
> -	int clipmask_index, bytes_per_pixel, rc;
> +	int bytes_per_pixel, rc;
>  	int image_size;
> -	unsigned char rv, gv, bv;
>  	static unsigned char *Y, *U, *V;
>  
>  	frame = usbvision->cur_frame;
>  	image_size = frame->frmwidth * frame->frmheight;
> -	if ((frame->v4l2_format.format == V4L2_PIX_FMT_YUV422P) ||
> -	    (frame->v4l2_format.format == V4L2_PIX_FMT_YVU420)) {       /* this is a planar format */
> -		/* ... v4l2_linesize not used here. */
> -		f = frame->data + (frame->width * frame->curline);
> -	} else
> -		f = frame->data + (frame->v4l2_linesize * frame->curline);
> -
> -	if (frame->v4l2_format.format == V4L2_PIX_FMT_YUYV) { /* initialise u and v pointers */
> -		/* get base of u and b planes add halfoffset */
> -		u = frame->data
> -			+ image_size
> -			+ (frame->frmwidth >> 1) * frame->curline;
> -		v = u + (image_size >> 1);
> -	} else if (frame->v4l2_format.format == V4L2_PIX_FMT_YVU420) {
> -		v = frame->data + image_size + ((frame->curline * (frame->width)) >> 2);
> -		u = v + (image_size >> 2);
> -	}
> +	f = frame->data + (frame->v4l2_linesize * frame->curline);
> +
> +	/* initialise u and v pointers */
> +	/* get base of u and b planes add halfoffset */
> +	u = frame->data
> +		+ image_size
> +		+ (frame->frmwidth >> 1) * frame->curline;
> +	v = u + (image_size >> 1);
>  
>  	if (frame->curline == 0)
>  		usbvision_adjust_compression(usbvision);
> @@ -862,7 +789,6 @@ static enum parse_state usbvision_parse_
>  	}
>  
>  	bytes_per_pixel = frame->v4l2_format.bytes_per_pixel;
> -	clipmask_index = frame->curline * MAX_FRAME_WIDTH;
>  
>  	scratch_get(usbvision, strip_data, strip_len);
>  
> @@ -888,61 +814,10 @@ static enum parse_state usbvision_parse_
>  		usbvision->strip_len_errors++;
>  
>  	for (idx = 0; idx < idx_end; idx++) {
> -		if (frame->v4l2_format.format == V4L2_PIX_FMT_YUYV) {
> -			*f++ = Y[idx];
> -			*f++ = idx & 0x01 ? U[idx / 2] : V[idx / 2];
> -		} else if (frame->v4l2_format.format == V4L2_PIX_FMT_YUV422P) {
> -			*f++ = Y[idx];
> -			if (idx & 0x01)
> -				*u++ = U[idx >> 1];
> -			else
> -				*v++ = V[idx >> 1];
> -		} else if (frame->v4l2_format.format == V4L2_PIX_FMT_YVU420) {
> -			*f++ = Y[idx];
> -			if (!((idx & 0x01) | (frame->curline & 0x01))) {
> -				/* only need do this for 1 in 4 pixels */
> -				/* intraframe buffer is YUV420 format */
> -				*u++ = U[idx >> 1];
> -				*v++ = V[idx >> 1];
> -			}
> -		} else {
> -			YUV_TO_RGB_BY_THE_BOOK(Y[idx], U[idx / 2], V[idx / 2], rv, gv, bv);
> -			switch (frame->v4l2_format.format) {
> -			case V4L2_PIX_FMT_GREY:
> -				*f++ = Y[idx];
> -				break;
> -			case V4L2_PIX_FMT_RGB555:
> -				*f++ = (0x1F & rv) |
> -					(0xE0 & (gv << 5));
> -				*f++ = (0x03 & (gv >> 3)) |
> -					(0x7C & (bv << 2));
> -				break;
> -			case V4L2_PIX_FMT_RGB565:
> -				*f++ = (0x1F & rv) |
> -					(0xE0 & (gv << 5));
> -				*f++ = (0x07 & (gv >> 3)) |
> -					(0xF8 & bv);
> -				break;
> -			case V4L2_PIX_FMT_RGB24:
> -				*f++ = rv;
> -				*f++ = gv;
> -				*f++ = bv;
> -				break;
> -			case V4L2_PIX_FMT_RGB32:
> -				*f++ = rv;
> -				*f++ = gv;
> -				*f++ = bv;
> -				f++;
> -				break;
> -			}
> -		}
> -		clipmask_index++;
> +		*f++ = Y[idx];
> +		*f++ = idx & 0x01 ? U[idx / 2] : V[idx / 2];
>  	}
> -	/* Deal with non-integer no. of bytes for YUV420P */
> -	if (frame->v4l2_format.format != V4L2_PIX_FMT_YVU420)
> -		*pcopylen += frame->v4l2_linesize;
> -	else
> -		*pcopylen += frame->curline & 0x01 ? frame->v4l2_linesize : frame->v4l2_linesize << 1;
> +	*pcopylen += frame->v4l2_linesize;
>  
>  	frame->curline += 1;
>  
> @@ -975,11 +850,8 @@ static enum parse_state usbvision_parse_
>  	const int y_step[] = { 0, 0, 0, 2 }, y_step_size = 4;
>  	const int uv_step[] = { 0, 0, 0, 4 }, uv_step_size = 4;
>  	unsigned char y[2], u, v;	/* YUV components */
> -	int y_, u_, v_, vb, uvg, ur;
> -	int r_, g_, b_;			/* RGB components */
> -	unsigned char g;
> -	int clipmask_even_index, clipmask_odd_index, bytes_per_pixel;
> -	int clipmask_add, stretch_bytes;
> +	int bytes_per_pixel;
> +	int stretch_bytes;
>  
>  	frame  = usbvision->cur_frame;
>  	f_even = frame->data + (frame->v4l2_linesize * frame->curline);
> @@ -990,9 +862,6 @@ static enum parse_state usbvision_parse_
>  	/* I need two lines to decode the color */
>  	bytes_per_pixel = frame->v4l2_format.bytes_per_pixel;
>  	stretch_bytes = (usbvision->stretch_width - 1) * bytes_per_pixel;
> -	clipmask_even_index = frame->curline * MAX_FRAME_WIDTH;
> -	clipmask_odd_index  = clipmask_even_index + MAX_FRAME_WIDTH;
> -	clipmask_add = usbvision->stretch_width;
>  	pixel_per_line = frame->isoc_header.frame_width;
>  
>  	if (scratch_len(usbvision) < (int)pixel_per_line * 3) {
> @@ -1019,185 +888,22 @@ static enum parse_state usbvision_parse_
>  			scratch_get_extra(usbvision, &u, &u_ptr, 1);
>  			scratch_get_extra(usbvision, &v, &v_ptr, 1);
>  
> -			/* I don't use the YUV_TO_RGB macro for better performance */
> -			v_ = v - 128;
> -			u_ = u - 128;
> -			vb = 132252 * v_;
> -			uvg = -53281 * u_ - 25625 * v_;
> -			ur = 104595 * u_;
> -
> -			if (frame->v4l2_format.format == V4L2_PIX_FMT_YUYV) {
> -				*f_even++ = y[0];
> -				*f_even++ = v;
> -			} else {
> -				y_ = 76284 * (y[0] - 16);
> -
> -				b_ = (y_ + vb) >> 16;
> -				g_ = (y_ + uvg) >> 16;
> -				r_ = (y_ + ur) >> 16;
> -
> -				switch (frame->v4l2_format.format) {
> -				case V4L2_PIX_FMT_RGB565:
> -					g = LIMIT_RGB(g_);
> -					*f_even++ =
> -						(0x1F & LIMIT_RGB(r_)) |
> -						(0xE0 & (g << 5));
> -					*f_even++ =
> -						(0x07 & (g >> 3)) |
> -						(0xF8 &  LIMIT_RGB(b_));
> -					break;
> -				case V4L2_PIX_FMT_RGB24:
> -					*f_even++ = LIMIT_RGB(r_);
> -					*f_even++ = LIMIT_RGB(g_);
> -					*f_even++ = LIMIT_RGB(b_);
> -					break;
> -				case V4L2_PIX_FMT_RGB32:
> -					*f_even++ = LIMIT_RGB(r_);
> -					*f_even++ = LIMIT_RGB(g_);
> -					*f_even++ = LIMIT_RGB(b_);
> -					f_even++;
> -					break;
> -				case V4L2_PIX_FMT_RGB555:
> -					g = LIMIT_RGB(g_);
> -					*f_even++ = (0x1F & LIMIT_RGB(r_)) |
> -						(0xE0 & (g << 5));
> -					*f_even++ = (0x03 & (g >> 3)) |
> -						(0x7C & (LIMIT_RGB(b_) << 2));
> -					break;
> -				}
> -			}
> -			clipmask_even_index += clipmask_add;
> +			*f_even++ = y[0];
> +			*f_even++ = v;
>  			f_even += stretch_bytes;
>  
> -			if (frame->v4l2_format.format == V4L2_PIX_FMT_YUYV) {
> -				*f_even++ = y[1];
> -				*f_even++ = u;
> -			} else {
> -				y_ = 76284 * (y[1] - 16);
> -
> -				b_ = (y_ + vb) >> 16;
> -				g_ = (y_ + uvg) >> 16;
> -				r_ = (y_ + ur) >> 16;
> -
> -				switch (frame->v4l2_format.format) {
> -				case V4L2_PIX_FMT_RGB565:
> -					g = LIMIT_RGB(g_);
> -					*f_even++ =
> -						(0x1F & LIMIT_RGB(r_)) |
> -						(0xE0 & (g << 5));
> -					*f_even++ =
> -						(0x07 & (g >> 3)) |
> -						(0xF8 &  LIMIT_RGB(b_));
> -					break;
> -				case V4L2_PIX_FMT_RGB24:
> -					*f_even++ = LIMIT_RGB(r_);
> -					*f_even++ = LIMIT_RGB(g_);
> -					*f_even++ = LIMIT_RGB(b_);
> -					break;
> -				case V4L2_PIX_FMT_RGB32:
> -					*f_even++ = LIMIT_RGB(r_);
> -					*f_even++ = LIMIT_RGB(g_);
> -					*f_even++ = LIMIT_RGB(b_);
> -					f_even++;
> -					break;
> -				case V4L2_PIX_FMT_RGB555:
> -					g = LIMIT_RGB(g_);
> -					*f_even++ = (0x1F & LIMIT_RGB(r_)) |
> -						(0xE0 & (g << 5));
> -					*f_even++ = (0x03 & (g >> 3)) |
> -						(0x7C & (LIMIT_RGB(b_) << 2));
> -					break;
> -				}
> -			}
> -			clipmask_even_index += clipmask_add;
> +			*f_even++ = y[1];
> +			*f_even++ = u;
>  			f_even += stretch_bytes;
>  
>  			scratch_get_extra(usbvision, &y[0], &y_ptr, 2);
>  
> -			if (frame->v4l2_format.format == V4L2_PIX_FMT_YUYV) {
> -				*f_odd++ = y[0];
> -				*f_odd++ = v;
> -			} else {
> -				y_ = 76284 * (y[0] - 16);
> -
> -				b_ = (y_ + vb) >> 16;
> -				g_ = (y_ + uvg) >> 16;
> -				r_ = (y_ + ur) >> 16;
> -
> -				switch (frame->v4l2_format.format) {
> -				case V4L2_PIX_FMT_RGB565:
> -					g = LIMIT_RGB(g_);
> -					*f_odd++ =
> -						(0x1F & LIMIT_RGB(r_)) |
> -						(0xE0 & (g << 5));
> -					*f_odd++ =
> -						(0x07 & (g >> 3)) |
> -						(0xF8 &  LIMIT_RGB(b_));
> -					break;
> -				case V4L2_PIX_FMT_RGB24:
> -					*f_odd++ = LIMIT_RGB(r_);
> -					*f_odd++ = LIMIT_RGB(g_);
> -					*f_odd++ = LIMIT_RGB(b_);
> -					break;
> -				case V4L2_PIX_FMT_RGB32:
> -					*f_odd++ = LIMIT_RGB(r_);
> -					*f_odd++ = LIMIT_RGB(g_);
> -					*f_odd++ = LIMIT_RGB(b_);
> -					f_odd++;
> -					break;
> -				case V4L2_PIX_FMT_RGB555:
> -					g = LIMIT_RGB(g_);
> -					*f_odd++ = (0x1F & LIMIT_RGB(r_)) |
> -						(0xE0 & (g << 5));
> -					*f_odd++ = (0x03 & (g >> 3)) |
> -						(0x7C & (LIMIT_RGB(b_) << 2));
> -					break;
> -				}
> -			}
> -			clipmask_odd_index += clipmask_add;
> +			*f_odd++ = y[0];
> +			*f_odd++ = v;
>  			f_odd += stretch_bytes;
>  
> -			if (frame->v4l2_format.format == V4L2_PIX_FMT_YUYV) {
> -				*f_odd++ = y[1];
> -				*f_odd++ = u;
> -			} else {
> -				y_ = 76284 * (y[1] - 16);
> -
> -				b_ = (y_ + vb) >> 16;
> -				g_ = (y_ + uvg) >> 16;
> -				r_ = (y_ + ur) >> 16;
> -
> -				switch (frame->v4l2_format.format) {
> -				case V4L2_PIX_FMT_RGB565:
> -					g = LIMIT_RGB(g_);
> -					*f_odd++ =
> -						(0x1F & LIMIT_RGB(r_)) |
> -						(0xE0 & (g << 5));
> -					*f_odd++ =
> -						(0x07 & (g >> 3)) |
> -						(0xF8 &  LIMIT_RGB(b_));
> -					break;
> -				case V4L2_PIX_FMT_RGB24:
> -					*f_odd++ = LIMIT_RGB(r_);
> -					*f_odd++ = LIMIT_RGB(g_);
> -					*f_odd++ = LIMIT_RGB(b_);
> -					break;
> -				case V4L2_PIX_FMT_RGB32:
> -					*f_odd++ = LIMIT_RGB(r_);
> -					*f_odd++ = LIMIT_RGB(g_);
> -					*f_odd++ = LIMIT_RGB(b_);
> -					f_odd++;
> -					break;
> -				case V4L2_PIX_FMT_RGB555:
> -					g = LIMIT_RGB(g_);
> -					*f_odd++ = (0x1F & LIMIT_RGB(r_)) |
> -						(0xE0 & (g << 5));
> -					*f_odd++ = (0x03 & (g >> 3)) |
> -						(0x7C & (LIMIT_RGB(b_) << 2));
> -					break;
> -				}
> -			}
> -			clipmask_odd_index += clipmask_add;
> +			*f_odd++ = y[1];
> +			*f_odd++ = u;
>  			f_odd += stretch_bytes;
>  		}
>  
> diff -up linux-2.6.39-rc2-/drivers/media/video/usbvision/usbvision.h linux-2.6.39-rc2/drivers/media/video/usbvision/usbvision.h
> --- linux-2.6.39-rc2-/drivers/media/video/usbvision/usbvision.h	2011-04-25 22:30:09.000000000 +0200
> +++ linux-2.6.39-rc2/drivers/media/video/usbvision/usbvision.h	2011-04-25 22:57:49.000000000 +0200
> @@ -165,48 +165,6 @@ enum {
>  	{ if ((v) < (mi)) (v) = (mi); else if ((v) > (ma)) (v) = (ma); }
>  
>  /*
> - * We use macros to do YUV -> RGB conversion because this is
> - * very important for speed and totally unimportant for size.
> - *
> - * YUV -> RGB Conversion
> - * ---------------------
> - *
> - * B = 1.164*(Y-16)		    + 2.018*(V-128)
> - * G = 1.164*(Y-16) - 0.813*(U-128) - 0.391*(V-128)
> - * R = 1.164*(Y-16) + 1.596*(U-128)
> - *
> - * If you fancy integer arithmetics (as you should), hear this:
> - *
> - * 65536*B = 76284*(Y-16)		  + 132252*(V-128)
> - * 65536*G = 76284*(Y-16) -  53281*(U-128) -  25625*(V-128)
> - * 65536*R = 76284*(Y-16) + 104595*(U-128)
> - *
> - * Make sure the output values are within [0..255] range.
> - */
> -#define LIMIT_RGB(x) (((x) < 0) ? 0 : (((x) > 255) ? 255 : (x)))
> -#define YUV_TO_RGB_BY_THE_BOOK(my, mu, mv, mr, mg, mb) { \
> -	int mm_y, mm_yc, mm_u, mm_v, mm_r, mm_g, mm_b; \
> -	mm_y = (my) - 16; \
> -	mm_u = (mu) - 128; \
> -	mm_v = (mv) - 128; \
> -	mm_yc = mm_y * 76284; \
> -	mm_b = (mm_yc + 132252 * mm_v) >> 16; \
> -	mm_g = (mm_yc - 53281 * mm_u - 25625 * mm_v) >> 16; \
> -	mm_r = (mm_yc + 104595 * mm_u) >> 16; \
> -	mb = LIMIT_RGB(mm_b); \
> -	mg = LIMIT_RGB(mm_g); \
> -	mr = LIMIT_RGB(mm_r); \
> -}
> -
> -/* Debugging aid */
> -#define USBVISION_SAY_AND_WAIT(what) { \
> -	wait_queue_head_t wq; \
> -	init_waitqueue_head(&wq); \
> -	printk(KERN_INFO "Say: %s\n", what); \
> -	interruptible_sleep_on_timeout(&wq, HZ * 3); \
> -}
> -
> -/*
>   * This macro checks if usbvision is still operational. The 'usbvision'
>   * pointer must be valid, usbvision->dev must be valid, we are not
>   * removing the device and the device has not erred on us.
> diff -up linux-2.6.39-rc2-/drivers/media/video/usbvision/usbvision-video.c linux-2.6.39-rc2/drivers/media/video/usbvision/usbvision-video.c
> --- linux-2.6.39-rc2-/drivers/media/video/usbvision/usbvision-video.c	2011-04-25 22:30:09.000000000 +0200
> +++ linux-2.6.39-rc2/drivers/media/video/usbvision/usbvision-video.c	2011-04-25 22:57:21.000000000 +0200
> @@ -112,14 +112,7 @@ USBVISION_DRIVER_VERSION_PATCHLEVEL)
>  static int usbvision_nr;
>  
>  static struct usbvision_v4l2_format_st usbvision_v4l2_format[] = {
> -	{ 1, 1,  8, V4L2_PIX_FMT_GREY    , "GREY" },
> -	{ 1, 2, 16, V4L2_PIX_FMT_RGB565  , "RGB565" },
> -	{ 1, 3, 24, V4L2_PIX_FMT_RGB24   , "RGB24" },
> -	{ 1, 4, 32, V4L2_PIX_FMT_RGB32   , "RGB32" },
> -	{ 1, 2, 16, V4L2_PIX_FMT_RGB555  , "RGB555" },
>  	{ 1, 2, 16, V4L2_PIX_FMT_YUYV    , "YUV422" },
> -	{ 1, 2, 12, V4L2_PIX_FMT_YVU420  , "YUV420P" }, /* 1.5 ! */
> -	{ 1, 2, 16, V4L2_PIX_FMT_YUV422P , "YUV422P" }
>  };
>  
>  /* Function prototypes */
> @@ -888,7 +881,7 @@ static int vidioc_streamoff(struct file
>  static int vidioc_enum_fmt_vid_cap(struct file *file, void  *priv,
>  					struct v4l2_fmtdesc *vfd)
>  {
> -	if (vfd->index >= USBVISION_SUPPORTED_PALETTES - 1)
> +	if (vfd->index > USBVISION_SUPPORTED_PALETTES - 1)
>  		return -EINVAL;
>  	strcpy(vfd->description, usbvision_v4l2_format[vfd->index].desc);
>  	vfd->pixelformat = usbvision_v4l2_format[vfd->index].format;
> @@ -1454,7 +1447,7 @@ static void usbvision_configure_video(st
>  		return;
>  
>  	model = usbvision->dev_model;
> -	usbvision->palette = usbvision_v4l2_format[2]; /* V4L2_PIX_FMT_RGB24; */
> +	usbvision->palette = usbvision_v4l2_format[0];
>  
>  	if (usbvision_device_data[usbvision->dev_model].vin_reg2_override) {
>  		usbvision->vin_reg2_preset =
> @@ -1659,13 +1652,6 @@ static int __init usbvision_init(void)
>  	PDEBUG(DBG_PROBE, "PROBE   debugging is enabled [video]");
>  	PDEBUG(DBG_MMAP, "MMAP    debugging is enabled [video]");
>  
> -	/* disable planar mode support unless compression enabled */
> -	if (isoc_mode != ISOC_MODE_COMPRESS) {
> -		/* FIXME : not the right way to set supported flag */
> -		usbvision_v4l2_format[6].supported = 0; /* V4L2_PIX_FMT_YVU420 */
> -		usbvision_v4l2_format[7].supported = 0; /* V4L2_PIX_FMT_YUV422P */
> -	}
> -
>  	err_code = usb_register(&usbvision_driver);
>  
>  	if (err_code == 0) {
> 
> 
> 
