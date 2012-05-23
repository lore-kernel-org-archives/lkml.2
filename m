Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028Ab2EWIqA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 04:46:00 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:40010 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451Ab2EWIp4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 04:45:56 -0400
MIME-Version: 1.0
In-Reply-To: <1337671292-15583-5-git-send-email-ming.m.lin@intel.com>
References: <1337671292-15583-1-git-send-email-ming.m.lin@intel.com>
	<1337671292-15583-5-git-send-email-ming.m.lin@intel.com>
Date: Wed, 23 May 2012 16:45:55 +0800
X-Google-Sender-Auth: 0bUjVbMWmEZa78ZPSCy_uStjViM
Message-ID: <CAF1ivSZaNw6nsBbF8OGbWNjA_uKK__u0rM4mLdVN7zK3bMFVTg@mail.gmail.com>
Subject: Re: [RFC PATCH v3 4/4] [SCSI] sd: change to auto suspend mode
From: Lin Ming <ming.m.lin@intel.com>
To: Jens Axboe <axboe@kernel.dk>, Alan Stern <stern@rowland.harvard.edu>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-scsi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2012 at 3:21 PM, Lin Ming <ming.m.lin@intel.com> wrote:
> Uses block layer runtime pm helper functions in scsi_runtime_suspend/resume.
> Remove scsi_autopm_* from sd open/release/remove path.

Hi Alan,

You mentioned that this patch needs some fixing.
Could you point that out?

Thanks,
Lin Ming

>
> Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> ---
>  drivers/scsi/scsi_pm.c    |   27 ++++++++++++++++++++-------
>  drivers/scsi/scsi_sysfs.c |    2 ++
>  drivers/scsi/sd.c         |   10 +---------
>  3 files changed, 23 insertions(+), 16 deletions(-)
>
> diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
> index c467064..302a157 100644
> --- a/drivers/scsi/scsi_pm.c
> +++ b/drivers/scsi/scsi_pm.c
> @@ -139,10 +139,16 @@ static int scsi_runtime_suspend(struct device *dev)
>
>        dev_dbg(dev, "scsi_runtime_suspend\n");
>        if (scsi_is_sdev_device(dev)) {
> +               struct scsi_device *sdev = to_scsi_device(dev);
> +               struct request_queue *q = sdev->request_queue;
> +
> +               err = blk_pre_runtime_suspend(q);
> +               if (err)
> +                       return err;
> +
>                err = scsi_dev_type_suspend(dev, PMSG_AUTO_SUSPEND);
> -               if (err == -EAGAIN)
> -                       pm_schedule_suspend(dev, jiffies_to_msecs(
> -                               round_jiffies_up_relative(HZ/10)));
> +
> +               blk_post_runtime_suspend(q, err);
>        }
>
>        /* Insert hooks here for targets, hosts, and transport classes */
> @@ -155,8 +161,14 @@ static int scsi_runtime_resume(struct device *dev)
>        int err = 0;
>
>        dev_dbg(dev, "scsi_runtime_resume\n");
> -       if (scsi_is_sdev_device(dev))
> +       if (scsi_is_sdev_device(dev)) {
> +               struct scsi_device *sdev = to_scsi_device(dev);
> +               struct request_queue *q = sdev->request_queue;
> +
> +               blk_pre_runtime_resume(q);
>                err = scsi_dev_type_resume(dev);
> +               blk_post_runtime_resume(q, err);
> +       }
>
>        /* Insert hooks here for targets, hosts, and transport classes */
>
> @@ -171,9 +183,10 @@ static int scsi_runtime_idle(struct device *dev)
>
>        /* Insert hooks here for targets, hosts, and transport classes */
>
> -       if (scsi_is_sdev_device(dev))
> -               err = pm_schedule_suspend(dev, 100);
> -       else
> +       if (scsi_is_sdev_device(dev)) {
> +               pm_runtime_mark_last_busy(dev);
> +               err = pm_request_autosuspend(dev);
> +       } else
>                err = pm_runtime_suspend(dev);
>        return err;
>  }
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index 04c2a27..1e8975f 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -895,6 +895,8 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
>         */
>        scsi_autopm_get_device(sdev);
>
> +       blk_pm_runtime_init(rq, &sdev->sdev_gendev);
> +
>        error = device_add(&sdev->sdev_gendev);
>        if (error) {
>                sdev_printk(KERN_INFO, sdev,
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 1205a8b..09e5ffe 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -966,10 +966,6 @@ static int sd_open(struct block_device *bdev, fmode_t mode)
>
>        sdev = sdkp->device;
>
> -       retval = scsi_autopm_get_device(sdev);
> -       if (retval)
> -               goto error_autopm;
> -
>        /*
>         * If the device is in error recovery, wait until it is done.
>         * If the device is offline, then disallow any access to it.
> @@ -1014,8 +1010,6 @@ static int sd_open(struct block_device *bdev, fmode_t mode)
>        return 0;
>
>  error_out:
> -       scsi_autopm_put_device(sdev);
> -error_autopm:
>        scsi_disk_put(sdkp);
>        return retval;
>  }
> @@ -1050,7 +1044,6 @@ static int sd_release(struct gendisk *disk, fmode_t mode)
>         * XXX is followed by a "rmmod sd_mod"?
>         */
>
> -       scsi_autopm_put_device(sdev);
>        scsi_disk_put(sdkp);
>        return 0;
>  }
> @@ -2631,7 +2624,7 @@ static void sd_probe_async(void *data, async_cookie_t cookie)
>
>        sd_printk(KERN_NOTICE, sdkp, "Attached SCSI %sdisk\n",
>                  sdp->removable ? "removable " : "");
> -       scsi_autopm_put_device(sdp);
> +       pm_runtime_put_sync_autosuspend(&sdp->sdev_gendev);
>        put_device(&sdkp->dev);
>  }
>
> @@ -2755,7 +2748,6 @@ static int sd_remove(struct device *dev)
>        struct scsi_disk *sdkp;
>
>        sdkp = dev_get_drvdata(dev);
> -       scsi_autopm_get_device(sdkp->device);
>
>        async_synchronize_full();
>        blk_queue_prep_rq(sdkp->device->request_queue, scsi_prep_fn);
> --
> 1.7.2.5
