Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933493Ab2JWWQ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 18:16:28 -0400
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:56793 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933154Ab2JWWQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 18:16:25 -0400
Subject: Re: [PATCH 17/23] cx23885: Replace memcpy with struct assignment
From: Andy Walls <awalls@md.metrocast.net>
To: Ezequiel Garcia <elezegarcia@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        Julia.Lawall@lip6.fr, kernel-janitors@vger.kernel.org,
        Peter Senna Tschudin <peter.senna@gmail.com>
Date: Tue, 23 Oct 2012 18:16:13 -0400
In-Reply-To: <1351022246-8201-17-git-send-email-elezegarcia@gmail.com>
References: <1351022246-8201-1-git-send-email-elezegarcia@gmail.com>
	 <1351022246-8201-17-git-send-email-elezegarcia@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1351030575.2459.21.camel@palomino.walls.org>
Mime-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.431,0.0.0000
 definitions=2012-10-23_07:2012-10-23,2012-10-23,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 suspectscore=2
 phishscore=0 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=6.0.2-1203120001 definitions=main-1210230289
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-23 at 16:57 -0300, Ezequiel Garcia wrote:
> This kind of memcpy() is error-prone. Its replacement with a struct
> assignment is prefered because it's type-safe and much easier to read.
> 
> Found by coccinelle. Hand patched and reviewed.
> Tested by compilation only.
> 
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> identifier struct_name;
> struct struct_name to;
> struct struct_name from;
> expression E;
> @@
> -memcpy(&(to), &(from), E);
> +to = from;
> // </smpl>
> 
> Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
> Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>

This patch looks OK to me.  You forgot to CC: Steven Toth and/or Devin
Heitmueller (I can't remember who did the VBI work.)

For cx23885-video.c:
Reviewed-by: Andy Walls <awalls@md.metrocast.net>

For cx23885-ir.c:
Signed-off-by: Andy Walls <awalls@md.metrocast.net>


> ---
>  drivers/media/pci/cx23885/cx23885-video.c |    3 +--
>  drivers/media/pci/cx23885/cx23888-ir.c    |    6 ++----
>  2 files changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/media/pci/cx23885/cx23885-video.c b/drivers/media/pci/cx23885/cx23885-video.c
> index 1a21926..62be144 100644
> --- a/drivers/media/pci/cx23885/cx23885-video.c
> +++ b/drivers/media/pci/cx23885/cx23885-video.c
> @@ -1818,8 +1818,7 @@ int cx23885_video_register(struct cx23885_dev *dev)
>  	spin_lock_init(&dev->slock);
>  
>  	/* Initialize VBI template */
> -	memcpy(&cx23885_vbi_template, &cx23885_video_template,
> -		sizeof(cx23885_vbi_template));
> +	cx23885_vbi_template = cx23885_video_template;
>  	strcpy(cx23885_vbi_template.name, "cx23885-vbi");
>  
>  	dev->tvnorm = cx23885_video_template.current_norm;
> diff --git a/drivers/media/pci/cx23885/cx23888-ir.c b/drivers/media/pci/cx23885/cx23888-ir.c
> index c2bc39c..e448146 100644
> --- a/drivers/media/pci/cx23885/cx23888-ir.c
> +++ b/drivers/media/pci/cx23885/cx23888-ir.c
> @@ -1236,13 +1236,11 @@ int cx23888_ir_probe(struct cx23885_dev *dev)
>  		cx23888_ir_write4(dev, CX23888_IR_IRQEN_REG, 0);
>  
>  		mutex_init(&state->rx_params_lock);
> -		memcpy(&default_params, &default_rx_params,
> -		       sizeof(struct v4l2_subdev_ir_parameters));
> +		default_params = default_rx_params;
>  		v4l2_subdev_call(sd, ir, rx_s_parameters, &default_params);
>  
>  		mutex_init(&state->tx_params_lock);
> -		memcpy(&default_params, &default_tx_params,
> -		       sizeof(struct v4l2_subdev_ir_parameters));
> +		default_params = default_tx_params;
>  		v4l2_subdev_call(sd, ir, tx_s_parameters, &default_params);
>  	} else {
>  		kfifo_free(&state->rx_kfifo);


