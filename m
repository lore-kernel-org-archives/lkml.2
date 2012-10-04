Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751570Ab2JDJhh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 05:37:37 -0400
Received: from ams-iport-1.cisco.com ([144.254.224.140]:46800 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718Ab2JDJhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 05:37:36 -0400
X-IronPort-AV: E=Sophos;i="4.80,533,1344211200"; 
   d="scan'208";a="144758263"
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Prabhakar <prabhakar.csengg@gmail.com>
Subject: Re: [PATCH v2] media: davinci: vpif: Add return code check at vb2_queue_init()
Date: Thu, 4 Oct 2012 11:37:20 +0200
User-Agent: KMail/1.13.7 (Linux/3.5-0.slh.1-aptosid-amd64; KDE/4.8.4; x86_64; ; )
Cc: LMML <linux-media@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
References: <1349342998-31804-1-git-send-email-prabhakar.lad@ti.com>
In-Reply-To: <1349342998-31804-1-git-send-email-prabhakar.lad@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201210041137.20910.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 4 October 2012 11:29:57 Prabhakar wrote:
> From: Lad, Prabhakar <prabhakar.lad@ti.com>
> 
> from commit with id 896f38f582730a19eb49677105b4fe4c0270b82e
> it's mandatory to check the return code of vb2_queue_init().
> 
> Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
> Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
>  Changes for v2:
>  1: Added vb2_dma_contig_cleanup_ctx() on failure of
>     vb2_queue_init() to avoid memory leak, pointed by Hans.
> 
>  drivers/media/platform/davinci/vpif_capture.c |    9 +++++++--
>  drivers/media/platform/davinci/vpif_display.c |    9 +++++++--
>  2 files changed, 14 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
> index 83b80ba..cabd5a2 100644
> --- a/drivers/media/platform/davinci/vpif_capture.c
> +++ b/drivers/media/platform/davinci/vpif_capture.c
> @@ -976,6 +976,7 @@ static int vpif_reqbufs(struct file *file, void *priv,
>  	struct common_obj *common;
>  	u8 index = 0;
>  	struct vb2_queue *q;
> +	int ret;
>  
>  	vpif_dbg(2, debug, "vpif_reqbufs\n");
>  
> @@ -1015,8 +1016,12 @@ static int vpif_reqbufs(struct file *file, void *priv,
>  	q->mem_ops = &vb2_dma_contig_memops;
>  	q->buf_struct_size = sizeof(struct vpif_cap_buffer);
>  
> -	vb2_queue_init(q);
> -
> +	ret = vb2_queue_init(q);
> +	if (ret) {
> +		vpif_err("vpif_capture: vb2_queue_init() failed\n");
> +		vb2_dma_contig_cleanup_ctx(common->alloc_ctx);
> +		return ret;
> +	}
>  	/* Set io allowed member of file handle to TRUE */
>  	fh->io_allowed[index] = 1;
>  	/* Increment io usrs member of channel object to 1 */
> diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
> index ae8329d..7f20ca5 100644
> --- a/drivers/media/platform/davinci/vpif_display.c
> +++ b/drivers/media/platform/davinci/vpif_display.c
> @@ -936,6 +936,7 @@ static int vpif_reqbufs(struct file *file, void *priv,
>  	enum v4l2_field field;
>  	struct vb2_queue *q;
>  	u8 index = 0;
> +	int ret;
>  
>  	/* This file handle has not initialized the channel,
>  	   It is not allowed to do settings */
> @@ -981,8 +982,12 @@ static int vpif_reqbufs(struct file *file, void *priv,
>  	q->mem_ops = &vb2_dma_contig_memops;
>  	q->buf_struct_size = sizeof(struct vpif_disp_buffer);
>  
> -	vb2_queue_init(q);
> -
> +	ret = vb2_queue_init(q);
> +	if (ret) {
> +		vpif_err("vpif_display: vb2_queue_init() failed\n");
> +		vb2_dma_contig_cleanup_ctx(common->alloc_ctx);
> +		return ret;
> +	}
>  	/* Set io allowed member of file handle to TRUE */
>  	fh->io_allowed[index] = 1;
>  	/* Increment io usrs member of channel object to 1 */
> 
