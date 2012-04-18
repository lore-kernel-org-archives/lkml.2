Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930Ab2DROB7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 10:01:59 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:44002 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065Ab2DROB5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 10:01:57 -0400
MIME-Version: 1.0
In-Reply-To: <1334756761-12312-1-git-send-email-pbonzini@redhat.com>
References: <1334756761-12312-1-git-send-email-pbonzini@redhat.com>
Date: Wed, 18 Apr 2012 22:01:57 +0800
Message-ID: <CAEH94LjBG8R5Jr=Foqg1a9Zw4GUBth7S1ZvbXvQoisWm8McGFA@mail.gmail.com>
Subject: Re: [PATCH for 3.4] virtio-scsi: fix TMF use-after-free
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, James Bottomley <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, Hu Tao <hutao@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2012 at 9:46 PM, Paolo Bonzini <pbonzini@redhat.com> wrote:
> Fix a race in TMF path, where cmd may have been already freed
> by virtscsi_complete_free after waking up from the completion.
>
> Cc: James Bottomley <JBottomley@parallels.com>
> Cc: linux-scsi@vger.kernel.org
> Signed-off-by: Hu Tao <hutao@cn.fujitsu.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  drivers/scsi/virtio_scsi.c |   24 +++++++++++++-----------
>  1 file changed, 13 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
> index efccd72..1b38431 100644
> --- a/drivers/scsi/virtio_scsi.c
> +++ b/drivers/scsi/virtio_scsi.c
> @@ -175,7 +175,8 @@ static void virtscsi_complete_free(void *buf)
>
>        if (cmd->comp)
>                complete_all(cmd->comp);
> -       mempool_free(cmd, virtscsi_cmd_pool);
> +       else
> +               mempool_free(cmd, virtscsi_cmd_pool);
good catch
>  }
>
>  static void virtscsi_ctrl_done(struct virtqueue *vq)
> @@ -311,21 +312,22 @@ out:
>  static int virtscsi_tmf(struct virtio_scsi *vscsi, struct virtio_scsi_cmd *cmd)
>  {
>        DECLARE_COMPLETION_ONSTACK(comp);
> -       int ret;
> +       int ret = FAILED;
>
>        cmd->comp = &comp;
> -       ret = virtscsi_kick_cmd(vscsi, vscsi->ctrl_vq, cmd,
> -                              sizeof cmd->req.tmf, sizeof cmd->resp.tmf,
> -                              GFP_NOIO);
> -       if (ret < 0)
> -               return FAILED;
> +       if (virtscsi_kick_cmd(vscsi, vscsi->ctrl_vq, cmd,
> +                             sizeof cmd->req.tmf, sizeof cmd->resp.tmf,
> +                             GFP_NOIO) < 0)
> +               goto out;
>
>        wait_for_completion(&comp);
> -       if (cmd->resp.tmf.response != VIRTIO_SCSI_S_OK &&
> -           cmd->resp.tmf.response != VIRTIO_SCSI_S_FUNCTION_SUCCEEDED)
> -               return FAILED;
> +       if (cmd->resp.tmf.response == VIRTIO_SCSI_S_OK ||
> +           cmd->resp.tmf.response == VIRTIO_SCSI_S_FUNCTION_SUCCEEDED)
> +               ret = SUCCESS;
>
> -       return SUCCESS;
> +out:
> +       mempool_free(cmd, virtscsi_cmd_pool);
> +       return ret;
>  }
>
>  static int virtscsi_device_reset(struct scsi_cmnd *sc)
> --
> 1.7.9.3

Reviewed-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Regards,

Zhi Yong Wu
