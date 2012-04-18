Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477Ab2DROJQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 10:09:16 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:40559 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753306Ab2DROJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 10:09:12 -0400
Message-ID: <1334758148.4410.51.camel@dabdike>
Subject: Re: [PATCH for 3.4] virtio-scsi: fix TMF use-after-free
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Hu Tao <hutao@cn.fujitsu.com>
Date: Wed, 18 Apr 2012 18:09:08 +0400
In-Reply-To: <1334756761-12312-1-git-send-email-pbonzini@redhat.com>
References: <1334756761-12312-1-git-send-email-pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-04-18 at 15:46 +0200, Paolo Bonzini wrote:
> Fix a race in TMF path, where cmd may have been already freed
> by virtscsi_complete_free after waking up from the completion.

There's no may about this; the command will be freed long before the
completion waiter is awoken.  The description could be clearer.

The problem is a use after free in virtscsi_tmf because the
virtio_scsi_command is freed before the completion returns.

The fix is to make callers specifying a completion responsible for
freeing the command in all cases.

James

> Cc: James Bottomley <JBottomley@parallels.com>
> Cc: linux-scsi@vger.kernel.org
> Signed-off-by: Hu Tao <hutao@cn.fujitsu.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  drivers/scsi/virtio_scsi.c |   24 +++++++++++++-----------
>  1 file changed, 13 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
> index efccd72..1b38431 100644
> --- a/drivers/scsi/virtio_scsi.c
> +++ b/drivers/scsi/virtio_scsi.c
> @@ -175,7 +175,8 @@ static void virtscsi_complete_free(void *buf)
>  
>  	if (cmd->comp)
>  		complete_all(cmd->comp);
> -	mempool_free(cmd, virtscsi_cmd_pool);
> +	else
> +		mempool_free(cmd, virtscsi_cmd_pool);
>  }
>  
>  static void virtscsi_ctrl_done(struct virtqueue *vq)
> @@ -311,21 +312,22 @@ out:
>  static int virtscsi_tmf(struct virtio_scsi *vscsi, struct virtio_scsi_cmd *cmd)
>  {
>  	DECLARE_COMPLETION_ONSTACK(comp);
> -	int ret;
> +	int ret = FAILED;
>  
>  	cmd->comp = &comp;
> -	ret = virtscsi_kick_cmd(vscsi, vscsi->ctrl_vq, cmd,
> -			       sizeof cmd->req.tmf, sizeof cmd->resp.tmf,
> -			       GFP_NOIO);
> -	if (ret < 0)
> -		return FAILED;
> +	if (virtscsi_kick_cmd(vscsi, vscsi->ctrl_vq, cmd,
> +			      sizeof cmd->req.tmf, sizeof cmd->resp.tmf,
> +			      GFP_NOIO) < 0)
> +		goto out;
>  
>  	wait_for_completion(&comp);
> -	if (cmd->resp.tmf.response != VIRTIO_SCSI_S_OK &&
> -	    cmd->resp.tmf.response != VIRTIO_SCSI_S_FUNCTION_SUCCEEDED)
> -		return FAILED;
> +	if (cmd->resp.tmf.response == VIRTIO_SCSI_S_OK ||
> +	    cmd->resp.tmf.response == VIRTIO_SCSI_S_FUNCTION_SUCCEEDED)
> +		ret = SUCCESS;
>  
> -	return SUCCESS;
> +out:
> +	mempool_free(cmd, virtscsi_cmd_pool);
> +	return ret;
>  }
>  
>  static int virtscsi_device_reset(struct scsi_cmnd *sc)


