Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687Ab1LNDUN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 22:20:13 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:57650 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754441Ab1LNDUK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 22:20:10 -0500
MIME-Version: 1.0
In-Reply-To: <1323832681-7177-3-git-send-email-ming.m.lin@intel.com>
References: <1323832681-7177-1-git-send-email-ming.m.lin@intel.com>
	<1323832681-7177-3-git-send-email-ming.m.lin@intel.com>
Date: Wed, 14 Dec 2011 11:20:09 +0800
X-Google-Sender-Auth: gPrzAqpFfFKfwmqHDxSH0khuwzA
Message-ID: <CAF1ivSa=AZXr93a+i2VXn9_O-8-ozmPOcFOm9HAMQRd7faC5Cg@mail.gmail.com>
Subject: Re: [PATCH 2/3] [SCSI]: runtime resume parent for child's system-resume
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
> [Patch description from Alan Stern]
>
> If a child device was runtime-suspended when a system suspend began,
> then there will be nothing to prevent its parent from
> runtime-suspending as soon as it is woken up during the system resume.
> Then when the time comes to resume the child, the resume will fail
> because the parent is already back at low power.
>
> On the other hand, there are some devices which should remain at low
> power across an entire suspend-resume cycle.  The details depend on the
> device and the platform.
>
> This suggests that the PM core is not the right place to solve the
> problem.  One possible solution is for the subsystem or device driver
> to call pm_runtime_get_sync(dev->parent) at the start of the
> system-resume procedure and pm_runtime_put_sync(dev->parent) at the
> end.
>
> Signed-off-by: Lin Ming <ming.m.lin@intel.com>

Hi Alan,

May I add your SOB?

Thanks,
Lin Ming

> ---
>  drivers/scsi/scsi_pm.c |   11 ++++++++++-
>  1 files changed, 10 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
> index a633076..bf8bf79 100644
> --- a/drivers/scsi/scsi_pm.c
> +++ b/drivers/scsi/scsi_pm.c
> @@ -72,8 +72,17 @@ static int scsi_bus_resume_common(struct device *dev)
>  {
>        int err = 0;
>
> -       if (scsi_is_sdev_device(dev))
> +       if (scsi_is_sdev_device(dev)) {
> +               /*
> +                * Parent device may have runtime suspended as soon as
> +                * it is woken up during the system resume.
> +                *
> +                * Resume it on behalf of child.
> +                */
> +               pm_runtime_get_sync(dev->parent);
>                err = scsi_dev_type_resume(dev);
> +               pm_runtime_put_sync(dev->parent);
> +       }
>
>        if (err == 0) {
>                pm_runtime_disable(dev);
> --
> 1.7.2.5
>
> --
