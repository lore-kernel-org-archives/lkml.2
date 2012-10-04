Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030250Ab2JDIwJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 04:52:09 -0400
Received: from ams-iport-1.cisco.com ([144.254.224.140]:54558 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965535Ab2JDIwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 04:52:07 -0400
X-IronPort-AV: E=Sophos;i="4.80,533,1344211200"; 
   d="scan'208";a="144756028"
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Prabhakar <prabhakar.csengg@gmail.com>
Subject: Re: [PATCH] media: davinci: vpif: Add return code check at vb2_queue_init()
Date: Thu, 4 Oct 2012 10:51:51 +0200
User-Agent: KMail/1.13.7 (Linux/3.5-0.slh.1-aptosid-amd64; KDE/4.8.4; x86_64; ; )
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LMML <linux-media@vger.kernel.org>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        VGER <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
References: <1349271749-24426-1-git-send-email-prabhakar.lad@ti.com>
In-Reply-To: <1349271749-24426-1-git-send-email-prabhakar.lad@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201210041051.51656.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Prabhakar,

I think this introduces a memory leak, see my comments below.

On Wed 3 October 2012 15:42:29 Prabhakar wrote:
> From: Lad, Prabhakar <prabhakar.lad@ti.com>
> 
> from commit with id 896f38f582730a19eb49677105b4fe4c0270b82e
> it's mandatory to check the return code of vb2_queue_init().
> 
> Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
> Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/platform/davinci/vpif_capture.c |    8 ++++++--
>  drivers/media/platform/davinci/vpif_display.c |    8 ++++++--
>  2 files changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
> index 83b80ba..3521725 100644
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
> @@ -1015,8 +1016,11 @@ static int vpif_reqbufs(struct file *file, void *priv,
>  	q->mem_ops = &vb2_dma_contig_memops;
>  	q->buf_struct_size = sizeof(struct vpif_cap_buffer);
>  
> -	vb2_queue_init(q);
> -
> +	ret = vb2_queue_init(q);
> +	if (ret) {
> +		vpif_err("vpif_capture: vb2_queue_init() failed\n");

I think you need to call vb2_dma_contig_cleanup_ctx(common->alloc_ctx); here
to prevent a memory leak.

> +		return ret;
> +	}
>  	/* Set io allowed member of file handle to TRUE */
>  	fh->io_allowed[index] = 1;
>  	/* Increment io usrs member of channel object to 1 */
> diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
> index ae8329d..84cee9d 100644
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
> @@ -981,8 +982,11 @@ static int vpif_reqbufs(struct file *file, void *priv,
>  	q->mem_ops = &vb2_dma_contig_memops;
>  	q->buf_struct_size = sizeof(struct vpif_disp_buffer);
>  
> -	vb2_queue_init(q);
> -
> +	ret = vb2_queue_init(q);
> +	if (ret) {
> +		vpif_err("vpif_display: vb2_queue_init() failed\n");

Ditto.

> +		return ret;
> +	}
>  	/* Set io allowed member of file handle to TRUE */
>  	fh->io_allowed[index] = 1;
>  	/* Increment io usrs member of channel object to 1 */
> 

Regards,

	Hans
