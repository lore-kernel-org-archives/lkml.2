Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932904Ab2DKSM0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 14:12:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18564 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932860Ab2DKSMU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 14:12:20 -0400
Message-ID: <4F85B908.4070404@redhat.com>
Date: Wed, 11 Apr 2012 14:02:00 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: =?UTF-8?B?UsOpbWkgRGVuaXMtQ291cm1vbnQ=?= <remi@remlab.net>
CC: mchehab@infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFC] [PATCH] v4l2: use unsigned rather than enums in ioctl()
 structs
References: <1333648371-24812-1-git-send-email-remi@remlab.net>
In-Reply-To: <1333648371-24812-1-git-send-email-remi@remlab.net>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 05-04-2012 14:52, Rémi Denis-Courmont escreveu:
> With an enumeration, the compiler assumes that the integer value is one
> allowed by the underlying enumeration type. With optimization enabled
> this can result in byte code that is unable to cope with other values.
> For instance, GCC can compile a switch() block using a "jump table" to
> avoid repetitive conditional branching.
> 
> This can be a problem both from user to kernel and kernel to user.
> 
> * Evil user space can pass error values to the kernel via system
> calls. There are no sane ways to protect the kernel: the compiler may
> optimize away range checks if it deems that all legitimate values are
> within the range.
> 
> * The kernel can break the user space binary interface whenever a new
> value is added to an existing enumeration. A newer kernel can then
> return an enumerated value that was not allowed by older kernel headers
> against which the user program was compiled. In principles, V4L2 user
> space needs to be recompiled whenever videodev2.h has updated enums...
> (This an obvious problem with V4L2_QUERYCTRL.)
> 
> Fortunately, the Linux ABI disables short-enums on all platforms. Even
> the Linux variant of the ARM AAPCS contradicts the standard ARM AAPCS
> in doing so.


Using unsigned instead of enum is not a good idea, from API POV, as unsigned
has different sizes on 32 bits and 64 bits. Yet, using enum was really a very
bad idea, and, on all new stuff, we're not accepting any new enum field.

That's said, a patch like that were proposed in the past. See:
	http://www.spinics.net/lists/vfl/msg25686.html

Alan said there [1] that:
	"Its a fundamental change to a public structure from enum to u32. I think you
	 are right but this change seems too late by several years."

I also didn't like it, because of the same reasons.

[1] http://www.spinics.net/lists/vfl/msg25687.html

I don't think anything has changed since then that would make it easier
to apply a change like that.

Well, eventually, a compat code at the v4l2-ioctl.c might be written to translate
a call if the enum size is different than the integer size.

Regards,
Mauro

> 
> Signed-off-by: Rémi Denis-Courmont <remi@remlab.net>
> ---
>  include/linux/videodev2.h |   42 +++++++++++++++++++++---------------------
>  1 file changed, 21 insertions(+), 21 deletions(-)
> 
> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> index c9c9a46..df3b8f0 100644
> --- a/include/linux/videodev2.h
> +++ b/include/linux/videodev2.h
> @@ -292,10 +292,10 @@ struct v4l2_pix_format {
>  	__u32         		width;
>  	__u32			height;
>  	__u32			pixelformat;
> -	enum v4l2_field  	field;
> +	unsigned		field;
>  	__u32            	bytesperline;	/* for padding, zero if unused */
>  	__u32          		sizeimage;
> -	enum v4l2_colorspace	colorspace;
> +	unsigned		colorspace;
>  	__u32			priv;		/* private data, depends on pixelformat */
>  };
>  
> @@ -432,7 +432,7 @@ struct v4l2_pix_format {
>   */
>  struct v4l2_fmtdesc {
>  	__u32		    index;             /* Format number      */
> -	enum v4l2_buf_type  type;              /* buffer type        */
> +	unsigned	    type;              /* buffer type        */
>  	__u32               flags;
>  	__u8		    description[32];   /* Description string */
>  	__u32		    pixelformat;       /* Format fourcc      */
> @@ -573,8 +573,8 @@ struct v4l2_jpegcompression {
>   */
>  struct v4l2_requestbuffers {
>  	__u32			count;
> -	enum v4l2_buf_type      type;
> -	enum v4l2_memory        memory;
> +	unsigned		type;
> +	unsigned		memory;
>  	__u32			reserved[2];
>  };
>  
> @@ -636,16 +636,16 @@ struct v4l2_plane {
>   */
>  struct v4l2_buffer {
>  	__u32			index;
> -	enum v4l2_buf_type      type;
> +	unsigned		type;
>  	__u32			bytesused;
>  	__u32			flags;
> -	enum v4l2_field		field;
> +	unsigned		field;
>  	struct timeval		timestamp;
>  	struct v4l2_timecode	timecode;
>  	__u32			sequence;
>  
>  	/* memory location */
> -	enum v4l2_memory        memory;
> +	unsigned		memory;
>  	union {
>  		__u32           offset;
>  		unsigned long   userptr;
> @@ -708,7 +708,7 @@ struct v4l2_clip {
>  
>  struct v4l2_window {
>  	struct v4l2_rect        w;
> -	enum v4l2_field  	field;
> +	unsigned		field;
>  	__u32			chromakey;
>  	struct v4l2_clip	__user *clips;
>  	__u32			clipcount;
> @@ -745,14 +745,14 @@ struct v4l2_outputparm {
>   *	I N P U T   I M A G E   C R O P P I N G
>   */
>  struct v4l2_cropcap {
> -	enum v4l2_buf_type      type;
> +	unsigned		type;
>  	struct v4l2_rect        bounds;
>  	struct v4l2_rect        defrect;
>  	struct v4l2_fract       pixelaspect;
>  };
>  
>  struct v4l2_crop {
> -	enum v4l2_buf_type      type;
> +	unsigned		type;
>  	struct v4l2_rect        c;
>  };
>  
> @@ -1156,7 +1156,7 @@ enum v4l2_ctrl_type {
>  /*  Used in the VIDIOC_QUERYCTRL ioctl for querying controls */
>  struct v4l2_queryctrl {
>  	__u32		     id;
> -	enum v4l2_ctrl_type  type;
> +	unsigned	     type;
>  	__u8		     name[32];	/* Whatever */
>  	__s32		     minimum;	/* Note signedness */
>  	__s32		     maximum;
> @@ -1788,7 +1788,7 @@ enum v4l2_jpeg_chroma_subsampling {
>  struct v4l2_tuner {
>  	__u32                   index;
>  	__u8			name[32];
> -	enum v4l2_tuner_type    type;
> +	unsigned		type;
>  	__u32			capability;
>  	__u32			rangelow;
>  	__u32			rangehigh;
> @@ -1838,14 +1838,14 @@ struct v4l2_modulator {
>  
>  struct v4l2_frequency {
>  	__u32		      tuner;
> -	enum v4l2_tuner_type  type;
> +	unsigned	      type;
>  	__u32		      frequency;
>  	__u32		      reserved[8];
>  };
>  
>  struct v4l2_hw_freq_seek {
>  	__u32		      tuner;
> -	enum v4l2_tuner_type  type;
> +	unsigned	      type;
>  	__u32		      seek_upward;
>  	__u32		      wrap_around;
>  	__u32		      spacing;
> @@ -2056,7 +2056,7 @@ struct v4l2_sliced_vbi_cap {
>  				 (equals frame lines 313-336 for 625 line video
>  				  standards, 263-286 for 525 line standards) */
>  	__u16   service_lines[2][24];
> -	enum v4l2_buf_type type;
> +	unsigned type;
>  	__u32   reserved[3];    /* must be 0 */
>  };
>  
> @@ -2146,8 +2146,8 @@ struct v4l2_pix_format_mplane {
>  	__u32				width;
>  	__u32				height;
>  	__u32				pixelformat;
> -	enum v4l2_field			field;
> -	enum v4l2_colorspace		colorspace;
> +	unsigned			field;
> +	unsigned			colorspace;
>  
>  	struct v4l2_plane_pix_format	plane_fmt[VIDEO_MAX_PLANES];
>  	__u8				num_planes;
> @@ -2165,7 +2165,7 @@ struct v4l2_pix_format_mplane {
>   * @raw_data:	placeholder for future extensions and custom formats
>   */
>  struct v4l2_format {
> -	enum v4l2_buf_type type;
> +	unsigned type;
>  	union {
>  		struct v4l2_pix_format		pix;     /* V4L2_BUF_TYPE_VIDEO_CAPTURE */
>  		struct v4l2_pix_format_mplane	pix_mp;  /* V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE */
> @@ -2179,7 +2179,7 @@ struct v4l2_format {
>  /*	Stream type-dependent parameters
>   */
>  struct v4l2_streamparm {
> -	enum v4l2_buf_type type;
> +	unsigned type;
>  	union {
>  		struct v4l2_captureparm	capture;
>  		struct v4l2_outputparm	output;
> @@ -2299,7 +2299,7 @@ struct v4l2_dbg_chip_ident {
>  struct v4l2_create_buffers {
>  	__u32			index;
>  	__u32			count;
> -	enum v4l2_memory        memory;
> +	unsigned		memory;
>  	struct v4l2_format	format;
>  	__u32			reserved[8];
>  };

