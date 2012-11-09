Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752509Ab2KIHtA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 02:49:00 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:53836 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751346Ab2KIHs5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 02:48:57 -0500
X-IronPort-AV: E=Sophos;i="4.80,743,1344182400"; 
   d="scan'208";a="6167116"
Message-ID: <509CAC3F.9050607@cn.fujitsu.com>
Date: Fri, 09 Nov 2012 15:09:51 +0800
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Reply-To: gaowanlong@cn.fujitsu.com
Organization: Fujitsu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
CC: target-devel <target-devel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Bottomley <JBottomley@Parallels.com>,
        Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org
Subject: Re: [PATCH] virtio-scsi: Fix incorrect lock release order in virtscsi_kick_cmd
References: <1352442592-2162-1-git-send-email-nab@linux-iscsi.org>
In-Reply-To: <1352442592-2162-1-git-send-email-nab@linux-iscsi.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/09 15:09:48,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/09 15:09:52,
	Serialize complete at 2012/11/09 15:09:52
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2012 02:29 PM, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> This patch fixes a regression bug in virtscsi_kick_cmd() that relinquishes
> the acquired spinlocks in the incorrect order using the wrong spin_unlock
> macros, namely releasing vq->vq_lock before tgt->tgt_lock while invoking
> the calls to virtio_ring.c:virtqueue_add_buf() and friends.
> 
> This bug was originally introduced in v3.5-rc7 code with:
> 
> commit 2bd37f0fde99cbf8b78fb55f1128e8c3a63cf1da
> Author: Paolo Bonzini <pbonzini@redhat.com>
> Date:   Wed Jun 13 16:56:34 2012 +0200
> 
>     [SCSI] virtio-scsi: split scatterlist per target
> 
> Go ahead and make sure that vq->vq_lock is relinquished w/ spin_unlock
> first, then release tgt->tgt_lock w/ spin_unlock_irqrestore.

Did you hit any error? I don't think this order is wrong.

Thanks,
Wanlong Gao

> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: James Bottomley <JBottomley@Parallels.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: stable@vger.kernel.org
> Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> ---
>  drivers/scsi/virtio_scsi.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
> index 595af1a..b2abb8a 100644
> --- a/drivers/scsi/virtio_scsi.c
> +++ b/drivers/scsi/virtio_scsi.c
> @@ -417,11 +417,11 @@ static int virtscsi_kick_cmd(struct virtio_scsi_target_state *tgt,
>  
>  	spin_lock(&vq->vq_lock);
>  	ret = virtqueue_add_buf(vq->vq, tgt->sg, out_num, in_num, cmd, gfp);
> -	spin_unlock(&tgt->tgt_lock);
> +	spin_unlock(&vq->vq_lock);
>  	if (ret >= 0)
>  		ret = virtqueue_kick_prepare(vq->vq);
>  
> -	spin_unlock_irqrestore(&vq->vq_lock, flags);
> +	spin_unlock_irqrestore(&tgt->tgt_lock, flags);
>  
>  	if (ret > 0)
>  		virtqueue_notify(vq->vq);
> 

