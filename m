Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932724Ab1LEWPt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 17:15:49 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64210 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932377Ab1LEWPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 17:15:47 -0500
Message-ID: <4EDD428B.9010800@gmail.com>
Date: Mon, 05 Dec 2011 23:15:39 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: Ming Lei <ming.lei@canonical.com>
CC: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [RFC PATCH v1 5/7] media: v4l2: introduce two IOCTLs for face
 detection
References: <1322838172-11149-1-git-send-email-ming.lei@canonical.com> <1322838172-11149-6-git-send-email-ming.lei@canonical.com>
In-Reply-To: <1322838172-11149-6-git-send-email-ming.lei@canonical.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2011 04:02 PM, Ming Lei wrote:
> This patch introduces two new IOCTLs and related data
> structure defination which will be used by the coming
> face detection video device.
> 
> The two IOCTLs and related data structure are used by
> user space application to retrieve the results of face
> detection. They can be called after one v4l2_buffer
> has been ioctl(VIDIOC_DQBUF) and before it will be
> ioctl(VIDIOC_QBUF).
> 
> The utility fdif[1] is useing the two IOCTLs to find
> faces deteced in raw images or video streams.
> 
> [1],http://kernel.ubuntu.com/git?p=ming/fdif.git;a=shortlog;h=refs/heads/v4l2-fdif
> 
> Signed-off-by: Ming Lei <ming.lei@canonical.com>
> ---
>  drivers/media/video/v4l2-ioctl.c |   38 ++++++++++++++++++++
>  include/linux/videodev2.h        |   70 ++++++++++++++++++++++++++++++++++++++
>  include/media/v4l2-ioctl.h       |    6 +++
>  3 files changed, 114 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
> index e1da8fc..fc6266f 100644
> --- a/drivers/media/video/v4l2-ioctl.c
> +++ b/drivers/media/video/v4l2-ioctl.c
> @@ -2140,6 +2140,30 @@ static long __video_do_ioctl(struct file *file,
>  		dbgarg(cmd, "index=%d", b->index);
>  		break;
>  	}
> +	case VIDIOC_G_FD_RESULT:
> +	{
> +		struct v4l2_fd_result *fr = arg;
> +
> +		if (!ops->vidioc_g_fd_result)
> +			break;
> +
> +		ret = ops->vidioc_g_fd_result(file, fh, fr);
> +
> +		dbgarg(cmd, "index=%d", fr->buf_index);
> +		break;
> +	}
> +	case VIDIOC_G_FD_COUNT:
> +	{
> +		struct v4l2_fd_count *fc = arg;
> +
> +		if (!ops->vidioc_g_fd_count)
> +			break;
> +
> +		ret = ops->vidioc_g_fd_count(file, fh, fc);
> +
> +		dbgarg(cmd, "index=%d", fc->buf_index);
> +		break;
> +	}
>  	default:
>  		if (!ops->vidioc_default)
>  			break;
> @@ -2234,6 +2258,20 @@ static int check_array_args(unsigned int cmd, void *parg, size_t *array_size,
>  		}
>  		break;
>  	}
> +
> +	case VIDIOC_G_FD_RESULT: {
> +		struct v4l2_fd_result *fr = parg;
> +
> +		if (fr->face_cnt != 0) {
> +			*user_ptr = (void __user *)fr->fd;
> +			*kernel_ptr = (void *)&fr->fd;
> +			*array_size = sizeof(struct v4l2_fd_detection)
> +				    * fr->face_cnt;
> +			ret = 1;
> +		}
> +		break;
> +
> +	}
>  	}
>  
>  	return ret;
> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> index 4b752d5..073eb4d 100644
> --- a/include/linux/videodev2.h
> +++ b/include/linux/videodev2.h
> @@ -2160,6 +2160,74 @@ struct v4l2_create_buffers {
>  	__u32			reserved[8];
>  };
>  
> +/**
> + * struct v4l2_obj_detection
> + * @buf_index:	entry, index of v4l2_buffer for face detection
> + * @centerx:	return, position in x direction of detected object
> + * @centery:	return, position in y direction of detected object
> + * @angle:	return, angle of detected object
> + * 		0 deg ~ 359 deg, vertical is 0 deg, clockwise
> + * @sizex:	return, size in x direction of detected object
> + * @sizey:	return, size in y direction of detected object
> + * @confidence:	return, confidence level of detection result
> + * 		0: the heighest level, 9: the lowest level

Hmm, not a good idea to align a public interface to the capabilities
of a single hardware implementation. min/max confidence could be queried with
relevant controls and here we could remove the line implying range.

> + * @reserved:	future extensions
> + */
> +struct v4l2_obj_detection {
> +	__u16		centerx;
> +	__u16		centery;
> +	__u16		angle;
> +	__u16		sizex;
> +	__u16		sizey;

How about using struct v4l2_rect in place of centerx/centery, sizex/sizey ?
After all it describes a rectangle. We could also use struct v4l2_frmsize_discrete
for size but there seems to be missing en equivalent for position, e.g.

struct v4l2_position {
	__s32 x;
	__s32 y;
};

> +	__u16		confidence;
> +	__u32		reserved[4];
> +};
> +
> +#define V4L2_FD_HAS_LEFT_EYE	0x1
> +#define V4L2_FD_HAS_RIGHT_EYE	0x2
> +#define V4L2_FD_HAS_MOUTH	0x4
> +#define V4L2_FD_HAS_FACE	0x8
> +
> +/**
> + * struct v4l2_fd_detection - VIDIOC_G_FD_RESULT argument
> + * @flag:	return, describe which objects are detected
> + * @left_eye:	return, left_eye position if detected
> + * @right_eye:	return, right_eye position if detected
> + * @mouth_eye:	return, mouth_eye position if detected

mouth_eye ? ;)

> + * @face:	return, face position if detected
> + */
> +struct v4l2_fd_detection {
> +	__u32	flag;
> +	struct v4l2_obj_detection	left_eye;
> +	struct v4l2_obj_detection	right_eye;
> +	struct v4l2_obj_detection	mouth;
> +	struct v4l2_obj_detection	face;

I would do this differently, i.e. put "flag" inside struct v4l2_obj_detection
and then struct v4l2_fd_detection would be simply an array of
struct v4l2_obj_detection, i.e.

struct v4l2_fd_detection {
	unsigned int count;
	struct v4l2_obj_detection [V4L2_MAX_FD_OBJECT_NUM];
};

This might be more flexible, e.g. if in the future some hardware supports
detecting wrinkles, we could easily add that by just defining a new flag:
V4L2_FD_HAS_WRINKLES, etc.


--

Regards,
Sylwester
