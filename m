Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742Ab0ISPcI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 11:32:08 -0400
Received: from daytona.panasas.com ([67.152.220.89]:36050 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754329Ab0ISPcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 11:32:07 -0400
Message-ID: <4C962CF3.9000601@panasas.com>
Date: Sun, 19 Sep 2010 17:32:03 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100720 Fedora/3.0.6-1.fc12 Thunderbird/3.0.6
MIME-Version: 1.0
To: Vasiliy Kulikov <segooon@gmail.com>
CC: kernel-janitors@vger.kernel.org, Benny Halevy <bhalevy@panasas.com>,
        "James E.J. Bottomley" <James.Bottomley@suse.de>,
        Tejun Heo <tj@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        osd-dev@open-osd.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/14] scsi: osd: fix device_register() error handling
References: <1284900907-24621-1-git-send-email-segooon@gmail.com>
In-Reply-To: <1284900907-24621-1-git-send-email-segooon@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Sep 2010 15:32:06.0369 (UTC) FILETIME=[D0F56D10:01CB580F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2010 02:55 PM, Vasiliy Kulikov wrote:
> If device_register() fails then call put_device().
> See comment to device_register.
> 
> Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
> ---
>  compile tested.
> 
>  drivers/scsi/osd/osd_uld.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/osd/osd_uld.c b/drivers/scsi/osd/osd_uld.c
> index cefb2c0..3e0edc2 100644
> --- a/drivers/scsi/osd/osd_uld.c
> +++ b/drivers/scsi/osd/osd_uld.c
> @@ -474,7 +474,7 @@ static int osd_probe(struct device *dev)
>  	error = device_register(&oud->class_dev);
>  	if (error) {
>  		OSD_ERR("device_register failed => %d\n", error);
> -		goto err_put_cdev;
> +		goto err_put_device;
>  	}
>  
>  	get_device(&oud->class_dev);
> @@ -482,6 +482,8 @@ static int osd_probe(struct device *dev)
>  	OSD_INFO("osd_probe %s\n", disk->disk_name);
>  	return 0;
>  
> +err_put_device:
> +	put_device(&oud->class_dev);

I'm not sure we can do this here. We might need to disregard the
comment at device_register. Because this put_ will try to call the
registered __release which will try to free the oud structure which
has the ->class_dev embedded, and now we have a double free.

But I will add a fat comment if all agree.

I'm assuming that if the device_register has failed then we are not
yet on any exposed system lists. (proof of we don't need to call
device_unregister). Since we don't yet let anyone see this device
we can go head and free it regardless of it's initialized ref-count
== 1. The motivation here is to tear down the device without any
possible users. Is that guaranteed? From my code audit it is.

>  err_put_cdev:
>  	cdev_del(&oud->cdev);
>  err_put_disk:

And I think device_register has a very bad API side effect with this put.
If you are going to monitor all places that do not call put_device. Why
not go to all places that do, and remove them and fix device_register.
Do a majority vote. What is done more? put_device called or not called.

Thanks
Boaz
