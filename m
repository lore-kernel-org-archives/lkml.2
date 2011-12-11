Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209Ab1LKSiV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 13:38:21 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60990 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091Ab1LKSiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 13:38:19 -0500
Message-ID: <4EE4F896.3080406@gmail.com>
Date: Sun, 11 Dec 2011 19:38:14 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: Ming Lei <ming.lei@canonical.com>
CC: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [RFC PATCH v1 6/7] media: video: introduce face detection driver
 module
References: <1322838172-11149-1-git-send-email-ming.lei@canonical.com> <1322838172-11149-7-git-send-email-ming.lei@canonical.com>
In-Reply-To: <1322838172-11149-7-git-send-email-ming.lei@canonical.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ming,

On 12/02/2011 04:02 PM, Ming Lei wrote:
> This patch introduces one driver for face detection purpose.
> 
> The driver is responsible for all v4l2 stuff, buffer management
> and other general things, and doesn't touch face detection hardware
> directly. Several interfaces are exported to low level drivers
> (such as the coming omap4 FD driver)which will communicate with
> face detection hw module.
> 
> So the driver will make driving face detection hw modules more
> easy.
> 
> TODO:
> 	- implement FD setting interfaces with v4l2 controls or
> 	ext controls
> 
> Signed-off-by: Ming Lei <ming.lei@canonical.com>
> ---
...
> +static int vidioc_g_fd_result(struct file *file, void *priv,
> +					struct v4l2_fd_result *f)
> +{
> +	struct fdif_dev *dev = video_drvdata(file);
> +	unsigned long flags;
> +	struct v4l2_fdif_result *tmp;
> +	struct v4l2_fdif_result *fr = NULL;
> +	unsigned int cnt = 0;
> +	int ret = -EINVAL;
> +
> +	spin_lock_irqsave(&dev->lock, flags);
> +	list_for_each_entry(tmp, &dev->fdif_dq.complete, list)
> +		if (tmp->index == f->buf_index) {
> +			fr = tmp;
> +			list_del(&tmp->list);
> +			break;
> +		}
> +	spin_unlock_irqrestore(&dev->lock, flags);
> +
> +	if (fr) {
> +		ret = 0;
> +		cnt = min(f->face_cnt, fr->face_cnt);
> +		if (cnt)
> +			memcpy(f->fd, fr->faces,
> +				sizeof(struct v4l2_fd_detection) * cnt);
> +		f->face_cnt = cnt;
> +		kfree(fr->faces);
> +		kfree(fr);

struct v4l2_fdif_result is allocated in HW driver at the time when FD result
is read out and it is freed in generic module here. Not sure if it is a good
practice to split memory management like this. Also IMHO it would be much
better to pre-allocate memory for FD output data, according to maximum number
of detected faces per frame. It could be more reliable than allocating memory
in interrupt context per each frame.


> +	}
> +	return ret;
> +}

--
Regards,
Sylwester
