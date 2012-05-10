Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932286Ab2EJL1l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 07:27:41 -0400
Received: from ams-iport-2.cisco.com ([144.254.224.141]:15388 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531Ab2EJL1i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 07:27:38 -0400
X-Greylist: delayed 590 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 May 2012 07:27:36 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av8EAIijq0+Q/khL/2dsb2JhbAA6CrEhghiBB4IMAQEBBAECDwEHDVIQCxguKC8GExsDBIdsC5p7oB6LDQ+GGgSIMIsfgi6JWIR/gWmCaw
X-IronPort-AV: E=Sophos;i="4.75,564,1330905600"; 
   d="scan'208";a="72876922"
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH v3 1/1] v4l2: use __u32 rather than enums in ioctl() structs
Date: Thu, 10 May 2012 13:17:16 +0200
User-Agent: KMail/1.13.7 (Linux/3.3-0.slh.4-aptosid-amd64; KDE/4.7.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        mchehab@redhat.com, remi@remlab.net, laurent.pinchart@ideasonboard.com
References: <1336629727-11111-1-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1336629727-11111-1-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201205101317.16101.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 10 May 2012 08:02:07 Sakari Ailus wrote:
> V4L2 uses the enum type in IOCTL arguments in IOCTLs that were defined until
> the use of enum was considered less than ideal. Recently Rémi Denis-Courmont
> brought up the issue by proposing a patch to convert the enums to unsigned:
> 
> <URL:http://www.spinics.net/lists/linux-media/msg46167.html>
> 
> This sparked a long discussion where another solution to the issue was
> proposed: two sets of IOCTL structures, one with __u32 and the other with
> enums, and conversion code between the two:
> 
> <URL:http://www.spinics.net/lists/linux-media/msg47168.html>
> 
> Both approaches implement a complete solution that resolves the problem. The
> first one is simple but requires assuming enums and __u32 are the same in
> size (so we won't break the ABI) while the second one is more complex and
> less clean but does not require making that assumption.
> 
> The issue boils down to whether enums are fundamentally different from __u32
> or not, and can the former be substituted by the latter. During the
> discussion it was concluded that the __u32 has the same size as enums on all
> archs Linux is supported: it has not been shown that replacing those enums
> in IOCTL arguments would break neither source or binary compatibility. If no
> such reason is found, just replacing the enums with __u32s is the way to go.
> 
> This is what this patch does. This patch is slightly different from Remi's
> first RFC (link above): it uses __u32 instead of unsigned and also changes
> the arguments of VIDIOC_G_PRIORITY and VIDIOC_S_PRIORITY.
> 
> Signed-off-by: Rémi Denis-Courmont <remi@remlab.net>
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
> The DocBook documentation with this patch applied is available here:
> 
> <URL:http://www.retiisi.org.uk/v4l2/tmp/media_api4/>
> 
> Changes since v2:
> 
> - Added comments to struct fields (and IOCTLs) that the now-u32 fields
>   refer to an enum.
> 
> Changes since v1:
> 
> - Fixes according to comments by Hans Verkuil:
>   - Update documentation
>   - Also remove enums in compat32 code
> 
>  Documentation/DocBook/media/v4l/io.xml             |   12 ++--
>  .../DocBook/media/v4l/vidioc-create-bufs.xml       |   10 ++-
>  Documentation/DocBook/media/v4l/vidioc-cropcap.xml |    4 +-
>  .../DocBook/media/v4l/vidioc-enum-fmt.xml          |    4 +-
>  Documentation/DocBook/media/v4l/vidioc-g-crop.xml  |    4 +-
>  Documentation/DocBook/media/v4l/vidioc-g-fmt.xml   |    2 +-
>  .../DocBook/media/v4l/vidioc-g-frequency.xml       |    6 +-
>  Documentation/DocBook/media/v4l/vidioc-g-parm.xml  |    5 +-
>  .../DocBook/media/v4l/vidioc-g-sliced-vbi-cap.xml  |    2 +-
>  Documentation/DocBook/media/v4l/vidioc-g-tuner.xml |    2 +-
>  .../DocBook/media/v4l/vidioc-queryctrl.xml         |    2 +-
>  Documentation/DocBook/media/v4l/vidioc-reqbufs.xml |    7 +-
>  .../DocBook/media/v4l/vidioc-s-hw-freq-seek.xml    |    5 +-
>  drivers/media/video/v4l2-compat-ioctl32.c          |   12 ++--
>  include/linux/videodev2.h                          |   64 ++++++++++----------
>  15 files changed, 75 insertions(+), 66 deletions(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/io.xml b/Documentation/DocBook/media/v4l/io.xml
> index b815929..fd6aca2 100644
> --- a/Documentation/DocBook/media/v4l/io.xml
> +++ b/Documentation/DocBook/media/v4l/io.xml
> @@ -543,12 +543,13 @@ and can range from zero to the number of buffers allocated
>  with the &VIDIOC-REQBUFS; ioctl (&v4l2-requestbuffers; <structfield>count</structfield>) minus one.</entry>
>  	  </row>
>  	  <row>
> -	    <entry>&v4l2-buf-type;</entry>
> +	    <entry>__u32</entry>
>  	    <entry><structfield>type</structfield></entry>
>  	    <entry></entry>
>  	    <entry>Type of the buffer, same as &v4l2-format;
>  <structfield>type</structfield> or &v4l2-requestbuffers;
> -<structfield>type</structfield>, set by the application.</entry>
> +<structfield>type</structfield>, set by the application. See <xref
> +linkend="v4l2-buf-type" /></entry>
>  	  </row>
>  	  <row>
>  	    <entry>__u32</entry>
> @@ -568,7 +569,7 @@ refers to an input stream, applications when an output stream.</entry>
>  linkend="buffer-flags" />.</entry>
>  	  </row>
>  	  <row>
> -	    <entry>&v4l2-field;</entry>
> +	    <entry>__u32</entry>
>  	    <entry><structfield>field</structfield></entry>
>  	    <entry></entry>
>  	    <entry>Indicates the field order of the image in the
> @@ -630,11 +631,12 @@ bandwidth. These devices identify by not enumerating any video
>  standards, see <xref linkend="standard" />.</para></entry>
>  	  </row>
>  	  <row>
> -	    <entry>&v4l2-memory;</entry>
> +	    <entry>__u32</entry>
>  	    <entry><structfield>memory</structfield></entry>
>  	    <entry></entry>
>  	    <entry>This field must be set by applications and/or drivers
> -in accordance with the selected I/O method.</entry>
> +in accordance with the selected I/O method. See <xref linkend="v4l2-memory"
> +	    /></entry>
>  	  </row>
>  	  <row>
>  	    <entry>union</entry>
> diff --git a/Documentation/DocBook/media/v4l/vidioc-create-bufs.xml b/Documentation/DocBook/media/v4l/vidioc-create-bufs.xml
> index 73ae8a6..184cdfc 100644
> --- a/Documentation/DocBook/media/v4l/vidioc-create-bufs.xml
> +++ b/Documentation/DocBook/media/v4l/vidioc-create-bufs.xml
> @@ -94,16 +94,18 @@ information.</para>
>  	    <entry>The number of buffers requested or granted.</entry>
>  	  </row>
>  	  <row>
> -	    <entry>&v4l2-memory;</entry>
> +	    <entry>__u32</entry>
>  	    <entry><structfield>memory</structfield></entry>
>  	    <entry>Applications set this field to
>  <constant>V4L2_MEMORY_MMAP</constant> or
> -<constant>V4L2_MEMORY_USERPTR</constant>.</entry>
> +<constant>V4L2_MEMORY_USERPTR</constant>. See <xref linkend="v4l2-memory"
> +/></entry>
>  	  </row>
>  	  <row>
> -	    <entry>&v4l2-format;</entry>
> +	    <entry>__u32</entry>
>  	    <entry><structfield>format</structfield></entry>
> -	    <entry>Filled in by the application, preserved by the driver.</entry>
> +	    <entry>Filled in by the application, preserved by the driver.
> +	    See <xref linkend="v4l2-format" />.</entry>
>  	  </row>
>  	  <row>
>  	    <entry>__u32</entry>
> diff --git a/Documentation/DocBook/media/v4l/vidioc-cropcap.xml b/Documentation/DocBook/media/v4l/vidioc-cropcap.xml
> index b4f2f25..f1bac2c 100644
> --- a/Documentation/DocBook/media/v4l/vidioc-cropcap.xml
> +++ b/Documentation/DocBook/media/v4l/vidioc-cropcap.xml
> @@ -65,7 +65,7 @@ output.</para>
>  	&cs-str;
>  	<tbody valign="top">
>  	  <row>
> -	    <entry>&v4l2-buf-type;</entry>
> +	    <entry>__u32</entry>
>  	    <entry><structfield>type</structfield></entry>
>  	    <entry>Type of the data stream, set by the application.
>  Only these types are valid here:
> @@ -73,7 +73,7 @@ Only these types are valid here:
>  <constant>V4L2_BUF_TYPE_VIDEO_OUTPUT</constant>,
>  <constant>V4L2_BUF_TYPE_VIDEO_OVERLAY</constant>, and custom (driver
>  defined) types with code <constant>V4L2_BUF_TYPE_PRIVATE</constant>
> -and higher.</entry>
> +and higher. See <xref linkend="v4l2-buf-type" />.</entry>
>  	  </row>
>  	  <row>
>  	    <entry>struct <link linkend="v4l2-rect-crop">v4l2_rect</link></entry>
> diff --git a/Documentation/DocBook/media/v4l/vidioc-enum-fmt.xml b/Documentation/DocBook/media/v4l/vidioc-enum-fmt.xml
> index 347d142..81ebe48 100644
> --- a/Documentation/DocBook/media/v4l/vidioc-enum-fmt.xml
> +++ b/Documentation/DocBook/media/v4l/vidioc-enum-fmt.xml
> @@ -71,7 +71,7 @@ the application. This is in no way related to the <structfield>
>  pixelformat</structfield> field.</entry>
>  	  </row>
>  	  <row>
> -	    <entry>&v4l2-buf-type;</entry>
> +	    <entry>__u32</entry>
>  	    <entry><structfield>type</structfield></entry>
>  	    <entry>Type of the data stream, set by the application.
>  Only these types are valid here:
> @@ -81,7 +81,7 @@ Only these types are valid here:
>  <constant>V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE</constant>,
>  <constant>V4L2_BUF_TYPE_VIDEO_OVERLAY</constant>, and custom (driver
>  defined) types with code <constant>V4L2_BUF_TYPE_PRIVATE</constant>
> -and higher.</entry>
> +and higher. See <xref linkend="v4l2-buf-type" />.</entry>
>  	  </row>
>  	  <row>
>  	    <entry>__u32</entry>
> diff --git a/Documentation/DocBook/media/v4l/vidioc-g-crop.xml b/Documentation/DocBook/media/v4l/vidioc-g-crop.xml
> index 01a5064..c4ff3b1 100644
> --- a/Documentation/DocBook/media/v4l/vidioc-g-crop.xml
> +++ b/Documentation/DocBook/media/v4l/vidioc-g-crop.xml
> @@ -100,14 +100,14 @@ changed and <constant>VIDIOC_S_CROP</constant> returns the
>  	&cs-str;
>  	<tbody valign="top">
>  	  <row>
> -	    <entry>&v4l2-buf-type;</entry>
> +	    <entry>__u32</entry>
>  	    <entry><structfield>type</structfield></entry>
>  	    <entry>Type of the data stream, set by the application.
>  Only these types are valid here: <constant>V4L2_BUF_TYPE_VIDEO_CAPTURE</constant>,
>  <constant>V4L2_BUF_TYPE_VIDEO_OUTPUT</constant>,
>  <constant>V4L2_BUF_TYPE_VIDEO_OVERLAY</constant>, and custom (driver
>  defined) types with code <constant>V4L2_BUF_TYPE_PRIVATE</constant>
> -and higher.</entry>
> +and higher. See <xref linkend="v4l2-buf-type" />.</entry>
>  	  </row>
>  	  <row>
>  	    <entry>&v4l2-rect;</entry>
> diff --git a/Documentation/DocBook/media/v4l/vidioc-g-fmt.xml b/Documentation/DocBook/media/v4l/vidioc-g-fmt.xml
> index 17fbda1..52acff1 100644
> --- a/Documentation/DocBook/media/v4l/vidioc-g-fmt.xml
> +++ b/Documentation/DocBook/media/v4l/vidioc-g-fmt.xml
> @@ -116,7 +116,7 @@ this ioctl.</para>
>  	<colspec colname="c4" />
>  	<tbody valign="top">
>  	  <row>
> -	    <entry>&v4l2-buf-type;</entry>
> +	    <entry>__u32</entry>
>  	    <entry><structfield>type</structfield></entry>
>  	    <entry></entry>
>  	    <entry>Type of the data stream, see <xref
> diff --git a/Documentation/DocBook/media/v4l/vidioc-g-frequency.xml b/Documentation/DocBook/media/v4l/vidioc-g-frequency.xml
> index 66e9a52..69c178a 100644
> --- a/Documentation/DocBook/media/v4l/vidioc-g-frequency.xml
> +++ b/Documentation/DocBook/media/v4l/vidioc-g-frequency.xml
> @@ -95,14 +95,14 @@ the &v4l2-output; <structfield>modulator</structfield> field and the
>  &v4l2-modulator; <structfield>index</structfield> field.</entry>
>  	  </row>
>  	  <row>
> -	    <entry>&v4l2-tuner-type;</entry>
> +	    <entry>__u32</entry>
>  	    <entry><structfield>type</structfield></entry>
>  	    <entry>The tuner type. This is the same value as in the
> -&v4l2-tuner; <structfield>type</structfield> field. The type must be set
> +&v4l2-tuner; <structfield>type</structfield> field. See The type must be set
>  to <constant>V4L2_TUNER_RADIO</constant> for <filename>/dev/radioX</filename>
>  device nodes, and to <constant>V4L2_TUNER_ANALOG_TV</constant>
>  for all others. The field is not applicable to modulators, &ie; ignored
> -by drivers.</entry>
> +by drivers. See <xref linkend="v4l2-tuner-type" /></entry>
>  	  </row>
>  	  <row>
>  	    <entry>__u32</entry>
> diff --git a/Documentation/DocBook/media/v4l/vidioc-g-parm.xml b/Documentation/DocBook/media/v4l/vidioc-g-parm.xml
> index 19b1d85..f83d2cd 100644
> --- a/Documentation/DocBook/media/v4l/vidioc-g-parm.xml
> +++ b/Documentation/DocBook/media/v4l/vidioc-g-parm.xml
> @@ -75,11 +75,12 @@ devices.</para>
>  	&cs-ustr;
>  	<tbody valign="top">
>  	  <row>
> -	    <entry>&v4l2-buf-type;</entry>
> +	    <entry>__u32</entry>
>  	    <entry><structfield>type</structfield></entry>
>  	    <entry></entry>
>  	    <entry>The buffer (stream) type, same as &v4l2-format;
> -<structfield>type</structfield>, set by the application.</entry>
> +<structfield>type</structfield>, set by the application. See <xref
> +	    linkend="v4l2-buf-type" /></entry>
>  	  </row>
>  	  <row>
>  	    <entry>union</entry>
> diff --git a/Documentation/DocBook/media/v4l/vidioc-g-sliced-vbi-cap.xml b/Documentation/DocBook/media/v4l/vidioc-g-sliced-vbi-cap.xml
> index 71741da..bd015d1 100644
> --- a/Documentation/DocBook/media/v4l/vidioc-g-sliced-vbi-cap.xml
> +++ b/Documentation/DocBook/media/v4l/vidioc-g-sliced-vbi-cap.xml
> @@ -148,7 +148,7 @@ using the &VIDIOC-S-FMT; ioctl as described in <xref
>  <structfield>service_lines</structfield>[1][0] to zero.</entry>
>  	  </row>
>  	  <row>
> -	    <entry>&v4l2-buf-type;</entry>
> +	    <entry>__u32</entry>
>  	    <entry><structfield>type</structfield></entry>
>  	    <entry>Type of the data stream, see <xref
>  		  linkend="v4l2-buf-type" />. Should be
> diff --git a/Documentation/DocBook/media/v4l/vidioc-g-tuner.xml b/Documentation/DocBook/media/v4l/vidioc-g-tuner.xml
> index 91ec2fb..62a1aa2 100644
> --- a/Documentation/DocBook/media/v4l/vidioc-g-tuner.xml
> +++ b/Documentation/DocBook/media/v4l/vidioc-g-tuner.xml
> @@ -107,7 +107,7 @@ user.<!-- FIXME Video inputs already have a name, the purpose of this
>  field is not quite clear.--></para></entry>
>  	  </row>
>  	  <row>
> -	    <entry>&v4l2-tuner-type;</entry>
> +	    <entry>__u32</entry>
>  	    <entry><structfield>type</structfield></entry>
>  	    <entry spanname="hspan">Type of the tuner, see <xref
>  		linkend="v4l2-tuner-type" />.</entry>
> diff --git a/Documentation/DocBook/media/v4l/vidioc-queryctrl.xml b/Documentation/DocBook/media/v4l/vidioc-queryctrl.xml
> index 505f020..e6645b9 100644
> --- a/Documentation/DocBook/media/v4l/vidioc-queryctrl.xml
> +++ b/Documentation/DocBook/media/v4l/vidioc-queryctrl.xml
> @@ -127,7 +127,7 @@ the first control with a higher ID. Drivers which do not support this
>  flag yet always return an &EINVAL;.</entry>
>  	  </row>
>  	  <row>
> -	    <entry>&v4l2-ctrl-type;</entry>
> +	    <entry>__u32</entry>
>  	    <entry><structfield>type</structfield></entry>
>  	    <entry>Type of control, see <xref
>  		linkend="v4l2-ctrl-type" />.</entry>
> diff --git a/Documentation/DocBook/media/v4l/vidioc-reqbufs.xml b/Documentation/DocBook/media/v4l/vidioc-reqbufs.xml
> index 7be4b1d..d7c9505 100644
> --- a/Documentation/DocBook/media/v4l/vidioc-reqbufs.xml
> +++ b/Documentation/DocBook/media/v4l/vidioc-reqbufs.xml
> @@ -92,18 +92,19 @@ streamoff.--></para>
>  	    <entry>The number of buffers requested or granted.</entry>
>  	  </row>
>  	  <row>
> -	    <entry>&v4l2-buf-type;</entry>
> +	    <entry>__u32</entry>
>  	    <entry><structfield>type</structfield></entry>
>  	    <entry>Type of the stream or buffers, this is the same
>  as the &v4l2-format; <structfield>type</structfield> field. See <xref
>  		linkend="v4l2-buf-type" /> for valid values.</entry>
>  	  </row>
>  	  <row>
> -	    <entry>&v4l2-memory;</entry>
> +	    <entry>__u32</entry>
>  	    <entry><structfield>memory</structfield></entry>
>  	    <entry>Applications set this field to
>  <constant>V4L2_MEMORY_MMAP</constant> or
> -<constant>V4L2_MEMORY_USERPTR</constant>.</entry>
> +<constant>V4L2_MEMORY_USERPTR</constant>. See <xref linkend="v4l2-memory"
> +/>.</entry>
>  	  </row>
>  	  <row>
>  	    <entry>__u32</entry>
> diff --git a/Documentation/DocBook/media/v4l/vidioc-s-hw-freq-seek.xml b/Documentation/DocBook/media/v4l/vidioc-s-hw-freq-seek.xml
> index 18b1a82..407dfce 100644
> --- a/Documentation/DocBook/media/v4l/vidioc-s-hw-freq-seek.xml
> +++ b/Documentation/DocBook/media/v4l/vidioc-s-hw-freq-seek.xml
> @@ -73,10 +73,11 @@ same value as in the &v4l2-input; <structfield>tuner</structfield>
>  field and the &v4l2-tuner; <structfield>index</structfield> field.</entry>
>  	  </row>
>  	  <row>
> -	    <entry>&v4l2-tuner-type;</entry>
> +	    <entry>__u32</entry>
>  	    <entry><structfield>type</structfield></entry>
>  	    <entry>The tuner type. This is the same value as in the
> -&v4l2-tuner; <structfield>type</structfield> field.</entry>
> +&v4l2-tuner; <structfield>type</structfield> field. See <xref
> +	    linkend="v4l2-tuner-type" /></entry>
>  	  </row>
>  	  <row>
>  	    <entry>__u32</entry>
> diff --git a/drivers/media/video/v4l2-compat-ioctl32.c b/drivers/media/video/v4l2-compat-ioctl32.c
> index 2829d25..89ae433 100644
> --- a/drivers/media/video/v4l2-compat-ioctl32.c
> +++ b/drivers/media/video/v4l2-compat-ioctl32.c
> @@ -37,7 +37,7 @@ struct v4l2_clip32 {
>  
>  struct v4l2_window32 {
>  	struct v4l2_rect        w;
> -	enum v4l2_field  	field;
> +	__u32		  	field;	/* enum v4l2_field */
>  	__u32			chromakey;
>  	compat_caddr_t		clips; /* actually struct v4l2_clip32 * */
>  	__u32			clipcount;
> @@ -147,7 +147,7 @@ static inline int put_v4l2_sliced_vbi_format(struct v4l2_sliced_vbi_format *kp,
>  }
>  
>  struct v4l2_format32 {
> -	enum v4l2_buf_type type;
> +	__u32	type;	/* enum v4l2_buf_type */
>  	union {
>  		struct v4l2_pix_format	pix;
>  		struct v4l2_pix_format_mplane	pix_mp;
> @@ -170,7 +170,7 @@ struct v4l2_format32 {
>  struct v4l2_create_buffers32 {
>  	__u32			index;
>  	__u32			count;
> -	enum v4l2_memory        memory;
> +	__u32			memory;	/* enum v4l2_memory */
>  	struct v4l2_format32	format;
>  	__u32			reserved[8];
>  };
> @@ -311,16 +311,16 @@ struct v4l2_plane32 {
>  
>  struct v4l2_buffer32 {
>  	__u32			index;
> -	enum v4l2_buf_type      type;
> +	__u32			type;	/* enum v4l2_buf_type */
>  	__u32			bytesused;
>  	__u32			flags;
> -	enum v4l2_field		field;
> +	__u32			field;	/* enum v4l2_field */
>  	struct compat_timeval	timestamp;
>  	struct v4l2_timecode	timecode;
>  	__u32			sequence;
>  
>  	/* memory location */
> -	enum v4l2_memory        memory;
> +	__u32			memory;	/* enum v4l2_memory */
>  	union {
>  		__u32           offset;
>  		compat_long_t   userptr;
> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> index 5a09ac3..ace8ac0 100644
> --- a/include/linux/videodev2.h
> +++ b/include/linux/videodev2.h
> @@ -292,10 +292,10 @@ struct v4l2_pix_format {
>  	__u32         		width;
>  	__u32			height;
>  	__u32			pixelformat;
> -	enum v4l2_field  	field;
> +	__u32			field;		/* enum v4l2_field */
>  	__u32            	bytesperline;	/* for padding, zero if unused */
>  	__u32          		sizeimage;
> -	enum v4l2_colorspace	colorspace;
> +	__u32			colorspace;	/* enum v4l2_colorspace */
>  	__u32			priv;		/* private data, depends on pixelformat */
>  };
>  
> @@ -432,7 +432,7 @@ struct v4l2_pix_format {
>   */
>  struct v4l2_fmtdesc {
>  	__u32		    index;             /* Format number      */
> -	enum v4l2_buf_type  type;              /* buffer type        */
> +	__u32		    type;              /* enum v4l2_buf_type */
>  	__u32               flags;
>  	__u8		    description[32];   /* Description string */
>  	__u32		    pixelformat;       /* Format fourcc      */
> @@ -573,8 +573,8 @@ struct v4l2_jpegcompression {
>   */
>  struct v4l2_requestbuffers {
>  	__u32			count;
> -	enum v4l2_buf_type      type;
> -	enum v4l2_memory        memory;
> +	__u32			type;		/* enum v4l2_buf_type */
> +	__u32			memory;		/* enum v4l2_memory */
>  	__u32			reserved[2];
>  };
>  
> @@ -610,15 +610,17 @@ struct v4l2_plane {
>  /**
>   * struct v4l2_buffer - video buffer info
>   * @index:	id number of the buffer
> - * @type:	buffer type (type == *_MPLANE for multiplanar buffers)
> + * @type:	enum v4l2_buf_type; buffer type (type == *_MPLANE for
> + *		multiplanar buffers);
>   * @bytesused:	number of bytes occupied by data in the buffer (payload);
>   *		unused (set to 0) for multiplanar buffers
>   * @flags:	buffer informational flags
> - * @field:	field order of the image in the buffer
> + * @field:	enum v4l2_field; field order of the image in the buffer
>   * @timestamp:	frame timestamp
>   * @timecode:	frame timecode
>   * @sequence:	sequence count of this frame
> - * @memory:	the method, in which the actual video data is passed
> + * @memory:	enum v4l2_memory; the method, in which the actual video data is
> + *		passed
>   * @offset:	for non-multiplanar buffers with memory == V4L2_MEMORY_MMAP;
>   *		offset from the start of the device memory for this plane,
>   *		(or a "cookie" that should be passed to mmap() as offset)
> @@ -636,16 +638,16 @@ struct v4l2_plane {
>   */
>  struct v4l2_buffer {
>  	__u32			index;
> -	enum v4l2_buf_type      type;
> +	__u32			type;
>  	__u32			bytesused;
>  	__u32			flags;
> -	enum v4l2_field		field;
> +	__u32			field;
>  	struct timeval		timestamp;
>  	struct v4l2_timecode	timecode;
>  	__u32			sequence;
>  
>  	/* memory location */
> -	enum v4l2_memory        memory;
> +	__u32			memory;
>  	union {
>  		__u32           offset;
>  		unsigned long   userptr;
> @@ -708,7 +710,7 @@ struct v4l2_clip {
>  
>  struct v4l2_window {
>  	struct v4l2_rect        w;
> -	enum v4l2_field  	field;
> +	__u32			field;	 /* enum v4l2_field */
>  	__u32			chromakey;
>  	struct v4l2_clip	__user *clips;
>  	__u32			clipcount;
> @@ -745,14 +747,14 @@ struct v4l2_outputparm {
>   *	I N P U T   I M A G E   C R O P P I N G
>   */
>  struct v4l2_cropcap {
> -	enum v4l2_buf_type      type;
> +	__u32			type;	/* enum v4l2_buf_type */
>  	struct v4l2_rect        bounds;
>  	struct v4l2_rect        defrect;
>  	struct v4l2_fract       pixelaspect;
>  };
>  
>  struct v4l2_crop {
> -	enum v4l2_buf_type      type;
> +	__u32			type;	/* enum v4l2_buf_type */
>  	struct v4l2_rect        c;
>  };
>  
> @@ -1040,7 +1042,7 @@ struct v4l2_input {
>  	__u8	     name[32];		/*  Label */
>  	__u32	     type;		/*  Type of input */
>  	__u32	     audioset;		/*  Associated audios (bitfield) */
> -	__u32        tuner;             /*  Associated tuner */
> +	__u32        tuner;             /*  enum v4l2_tuner_type */
>  	v4l2_std_id  std;
>  	__u32	     status;
>  	__u32	     capabilities;
> @@ -1157,7 +1159,7 @@ enum v4l2_ctrl_type {
>  /*  Used in the VIDIOC_QUERYCTRL ioctl for querying controls */
>  struct v4l2_queryctrl {
>  	__u32		     id;
> -	enum v4l2_ctrl_type  type;
> +	__u32		     type;	/* enum v4l2_ctrl_type */
>  	__u8		     name[32];	/* Whatever */
>  	__s32		     minimum;	/* Note signedness */
>  	__s32		     maximum;
> @@ -1792,7 +1794,7 @@ enum v4l2_jpeg_chroma_subsampling {
>  struct v4l2_tuner {
>  	__u32                   index;
>  	__u8			name[32];
> -	enum v4l2_tuner_type    type;
> +	__u32			type;	/* enum v4l2_tuner_type */
>  	__u32			capability;
>  	__u32			rangelow;
>  	__u32			rangehigh;
> @@ -1842,14 +1844,14 @@ struct v4l2_modulator {
>  
>  struct v4l2_frequency {
>  	__u32		      tuner;
> -	enum v4l2_tuner_type  type;
> +	__u32		      type;	/* enum v4l2_tuner_type */
>  	__u32		      frequency;
>  	__u32		      reserved[8];
>  };
>  
>  struct v4l2_hw_freq_seek {
>  	__u32		      tuner;
> -	enum v4l2_tuner_type  type;
> +	__u32		      type;	/* enum v4l2_tuner_type */
>  	__u32		      seek_upward;
>  	__u32		      wrap_around;
>  	__u32		      spacing;
> @@ -2060,7 +2062,7 @@ struct v4l2_sliced_vbi_cap {
>  				 (equals frame lines 313-336 for 625 line video
>  				  standards, 263-286 for 525 line standards) */
>  	__u16   service_lines[2][24];
> -	enum v4l2_buf_type type;
> +	__u32	type;		/* enum v4l2_buf_type */
>  	__u32   reserved[3];    /* must be 0 */
>  };
>  
> @@ -2141,8 +2143,8 @@ struct v4l2_plane_pix_format {
>   * @width:		image width in pixels
>   * @height:		image height in pixels
>   * @pixelformat:	little endian four character code (fourcc)
> - * @field:		field order (for interlaced video)
> - * @colorspace:		supplemental to pixelformat
> + * @field:		enum v4l2_field; field order (for interlaced video)
> + * @colorspace:		enum v4l2_colorspace; supplemental to pixelformat
>   * @plane_fmt:		per-plane information
>   * @num_planes:		number of planes for this format
>   */
> @@ -2150,8 +2152,8 @@ struct v4l2_pix_format_mplane {
>  	__u32				width;
>  	__u32				height;
>  	__u32				pixelformat;
> -	enum v4l2_field			field;
> -	enum v4l2_colorspace		colorspace;
> +	__u32				field;
> +	__u32				colorspace;
>  
>  	struct v4l2_plane_pix_format	plane_fmt[VIDEO_MAX_PLANES];
>  	__u8				num_planes;
> @@ -2160,7 +2162,7 @@ struct v4l2_pix_format_mplane {
>  
>  /**
>   * struct v4l2_format - stream data format
> - * @type:	type of the data stream
> + * @type:	enum v4l2_buf_type; type of the data stream
>   * @pix:	definition of an image format
>   * @pix_mp:	definition of a multiplanar image format
>   * @win:	definition of an overlaid image
> @@ -2169,7 +2171,7 @@ struct v4l2_pix_format_mplane {
>   * @raw_data:	placeholder for future extensions and custom formats
>   */
>  struct v4l2_format {
> -	enum v4l2_buf_type type;
> +	__u32	 type;
>  	union {
>  		struct v4l2_pix_format		pix;     /* V4L2_BUF_TYPE_VIDEO_CAPTURE */
>  		struct v4l2_pix_format_mplane	pix_mp;  /* V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE */
> @@ -2183,7 +2185,7 @@ struct v4l2_format {
>  /*	Stream type-dependent parameters
>   */
>  struct v4l2_streamparm {
> -	enum v4l2_buf_type type;
> +	__u32	 type;			/* enum v4l2_buf_type */
>  	union {
>  		struct v4l2_captureparm	capture;
>  		struct v4l2_outputparm	output;
> @@ -2296,14 +2298,14 @@ struct v4l2_dbg_chip_ident {
>   * @index:	on return, index of the first created buffer
>   * @count:	entry: number of requested buffers,
>   *		return: number of created buffers
> - * @memory:	buffer memory type
> + * @memory:	enum v4l2_memory; buffer memory type
>   * @format:	frame format, for which buffers are requested
>   * @reserved:	future extensions
>   */
>  struct v4l2_create_buffers {
>  	__u32			index;
>  	__u32			count;
> -	enum v4l2_memory        memory;
> +	__u32			memory;
>  	struct v4l2_format	format;
>  	__u32			reserved[8];
>  };
> @@ -2360,8 +2362,8 @@ struct v4l2_create_buffers {
>  #define VIDIOC_TRY_FMT      	_IOWR('V', 64, struct v4l2_format)
>  #define VIDIOC_ENUMAUDIO	_IOWR('V', 65, struct v4l2_audio)
>  #define VIDIOC_ENUMAUDOUT	_IOWR('V', 66, struct v4l2_audioout)
> -#define VIDIOC_G_PRIORITY        _IOR('V', 67, enum v4l2_priority)
> -#define VIDIOC_S_PRIORITY        _IOW('V', 68, enum v4l2_priority)
> +#define VIDIOC_G_PRIORITY	 _IOR('V', 67, __u32) /* enum v4l2_priority */
> +#define VIDIOC_S_PRIORITY	 _IOW('V', 68, __u32) /* enum v4l2_priority */
>  #define VIDIOC_G_SLICED_VBI_CAP _IOWR('V', 69, struct v4l2_sliced_vbi_cap)
>  #define VIDIOC_LOG_STATUS         _IO('V', 70)
>  #define VIDIOC_G_EXT_CTRLS	_IOWR('V', 71, struct v4l2_ext_controls)
> 
