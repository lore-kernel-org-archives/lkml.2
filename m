Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488Ab2BEHhJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 02:37:09 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:54317 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458Ab2BEHhH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 02:37:07 -0500
MIME-Version: 1.0
In-Reply-To: <1328158649-4137-5-git-send-email-vinholikatti@gmail.com>
References: <1328158649-4137-1-git-send-email-vinholikatti@gmail.com>
	<1328158649-4137-5-git-send-email-vinholikatti@gmail.com>
Date: Sun, 5 Feb 2012 16:37:05 +0900
Message-ID: <CAKYAXd9k5i2_SuD8YSJeG25CBpK0b4jQGJstc-Ef1jD20cph1Q@mail.gmail.com>
Subject: Re: [PATCH 4/4] [SCSI] ufshcd: SCSI error handling
From: Namjae Jeon <linkinjeon@gmail.com>
To: Vinayak Holikatti <vinholikatti@gmail.com>
Cc: James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@linaro.org,
        linux-samsung-soc@vger.kernel.org, saugata.das@linaro.org,
        arnd@arndb.de, venkat@linaro.org, girish.shivananjappa@linaro.org,
        vishak.g@samsung.com, k.rajesh@samsung.com, yejin.moon@samsung.com,
        Santosh Yaraganavi <santoshsy@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +
> +/**
> + * ufshcd_abort - abort a specific command
> + * @cmd: SCSI command pointer
> + *
> + * Returns 0 on success, non-zero value on failure
> + */
> +static int ufshcd_abort(struct scsi_cmnd *cmd)
> +{
> +       struct Scsi_Host *host;
> +       struct ufs_hba *hba;
> +       unsigned long flags;
> +       unsigned int tag;
> +       unsigned int pos;
> +       int err;
> +
> +       host = cmd->device->host;
> +       hba = (struct ufs_hba *) host->hostdata;
> +       tag = cmd->request->tag;
> +
> +       spin_lock_irqsave(host->host_lock, flags);
> +       pos = (1 << tag);
> +
> +       /* check if command is still pending */
> +       if (!(hba->outstanding_reqs & pos)) {
> +               err = -1;
> +               spin_unlock_irqrestore(host->host_lock, flags);
> +               goto out;
> +       }
> +
> +       err = ufshcd_issue_tm_cmd(hba, &hba->lrb[tag], UFS_ABORT_TASK);
Hi.
You called spin_lock_irqsave in ufshcd_issue_tm_cmd() without
spin_unlock_irqrestore.

> +       if (!err) {
> +               spin_lock_irqsave(host->host_lock, flags);
This case is same also.
Thanks.
> +               scsi_dma_unmap(cmd);
> +
> +               /* clear the respective UTRLCLR bit */
> +               writel(~pos,
> +                       (UFSHCD_MMIO_BASE +
> +                        REG_UTP_TRANSFER_REQ_LIST_CLEAR));
> +               hba->outstanding_reqs &= ~pos;
> +               hba->lrb[tag].cmd = NULL;
> +               spin_unlock_irqrestore(host->host_lock, flags);
> +       }
> +out:
> +       return err;
> +}
> +
