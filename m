Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753758Ab2GWOhu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 10:37:50 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:55482 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753504Ab2GWOhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 10:37:47 -0400
Message-ID: <500D615C.1080605@mvista.com>
Date: Mon, 23 Jul 2012 18:36:12 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Aaron Lu <aaron.lu@amd.com>
CC: Jeff Garzik <jgarzik@pobox.com>, Alan Stern <stern@rowland.harvard.edu>,
        Lin Ming <minggr@gmail.com>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>
Subject: Re: [PATCH 4/5] scsi: pm: use runtime resume callback if available
References: <1343026180-22236-1-git-send-email-aaron.lu@amd.com> <1343026180-22236-5-git-send-email-aaron.lu@amd.com>
In-Reply-To: <1343026180-22236-5-git-send-email-aaron.lu@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 07/23/2012 10:49 AM, Aaron Lu wrote:

> When runtime resume a scsi device, if the device's driver has
> implemented runtime resume callback, use that instead of the resume
> callback.

> sr driver needs this to properly do different things for system resume
> and runtime resume.

> Signed-off-by: Aaron Lu <aaron.lu@amd.com>
> ---
>  drivers/scsi/scsi_pm.c | 14 +++++++++-----
>  drivers/scsi/sr.c      | 21 +++++++++++++++++++++
>  2 files changed, 30 insertions(+), 5 deletions(-)

> diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
> index d4201de..19bba47 100644
> --- a/drivers/scsi/scsi_pm.c
> +++ b/drivers/scsi/scsi_pm.c
> @@ -34,14 +34,18 @@ static int scsi_dev_type_suspend(struct device *dev, pm_message_t msg)
>  	return err;
>  }
>  
> -static int scsi_dev_type_resume(struct device *dev)
> +static int scsi_dev_type_resume(struct device *dev, bool runtime)
>  {
>  	struct device_driver *drv;
>  	int err = 0;
> +	int (*resume)(struct device *);
>  
>  	drv = dev->driver;
> -	if (drv && drv->resume)
> -		err = drv->resume(dev);
> +	if (runtime && drv && drv->pm && drv->pm->runtime_resume)
> +		resume = drv->pm->runtime_resume;
> +	else
> +		resume = drv ? drv->resume : NULL;

   Call thru NULL pointer below will cause kernel oops. Is it your intention?

> +	err = resume(dev);

WBR, Sergei

