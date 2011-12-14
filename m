Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757957Ab1LNSpF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 13:45:05 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:45356 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967Ab1LNSpC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 13:45:02 -0500
MIME-Version: 1.0
In-Reply-To: <1323832681-7177-4-git-send-email-ming.m.lin@intel.com>
References: <1323832681-7177-1-git-send-email-ming.m.lin@intel.com>
	<1323832681-7177-4-git-send-email-ming.m.lin@intel.com>
Date: Thu, 15 Dec 2011 02:45:01 +0800
X-Google-Sender-Auth: kb81UDoYSRsPgsD6lnh3EV7kdtM
Message-ID: <CAF1ivSbt6a=CNqXJ9byrDmTHdhygBKSbr6Pxf+Cwwpa6B++BZw@mail.gmail.com>
Subject: Re: [PATCH 3/3] ata: update ata port's runtime status during system resume
From: Lin Ming <ming.m.lin@intel.com>
To: Jeff Garzik <jgarzik@pobox.com>,
        James Bottomley <JBottomley@parallels.com>,
        Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 11:18 AM, Lin Ming <ming.m.lin@intel.com> wrote:
> The ata port is brought back to full power state during system resume.
> So its runtime PM status will have to be updated to reflect
> the actual post-system sleep status.
>
> This also fixes below warning during system suspend/resume.
>
> WARNING: at /work/linux/drivers/ata/libata-eh.c:4034
> ata_scsi_port_error_handler+0x89/0x557()
>
> 4034         WARN_ON(!(ap->pflags & ATA_PFLAG_SUSPENDED));
>
> Signed-off-by: Lin Ming <ming.m.lin@intel.com>

Hi Alan,

Would you like to Ack this one also?

Thanks,
Lin Ming

> ---
>  drivers/ata/libata-core.c |   18 ++++++++++++++++--
>  1 files changed, 16 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index 15a3d4d..8996758 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -5298,7 +5298,7 @@ static int ata_port_suspend(struct device *dev)
>        return ata_port_suspend_common(dev);
>  }
>
> -static int ata_port_resume(struct device *dev)
> +static int ata_port_resume_common(struct device *dev)
>  {
>        struct ata_port *ap = to_ata_port(dev);
>        int rc;
> @@ -5308,6 +5308,20 @@ static int ata_port_resume(struct device *dev)
>        return rc;
>  }
>
> +static int ata_port_resume(struct device *dev)
> +{
> +       int rc;
> +
> +       rc = ata_port_resume_common(dev);
> +       if (!rc) {
> +               pm_runtime_disable(dev);
> +               pm_runtime_set_active(dev);
> +               pm_runtime_enable(dev);
> +       }
> +
> +       return rc;
> +}
> +
>  static int ata_port_runtime_idle(struct device *dev)
>  {
>        return pm_runtime_suspend(dev);
> @@ -5318,7 +5332,7 @@ static const struct dev_pm_ops ata_port_pm_ops = {
>        .resume = ata_port_resume,
>
>        .runtime_suspend = ata_port_suspend_common,
> -       .runtime_resume = ata_port_resume,
> +       .runtime_resume = ata_port_resume_common,
>        .runtime_idle = ata_port_runtime_idle,
>  };
>
> --
> 1.7.2.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ide" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
