Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518Ab0ISO1U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 10:27:20 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:47268 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753427Ab0ISO1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 10:27:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=KAGO7P8gfIAmk/TsXk3rSn61UksPhoBNEsB8M+kp7yrM4ALBaTojthVMHZh7GGwswB
         9C1rt+iK+6ugiG5gSGNB6EiwPxwq+VYhLYx3r/b5fZ6aFfhmQj2juW4w4NiYDmShDeTB
         xGH5YGrqIPPnqUVnpjqOG+QUuE4FIDLEjDfYk=
Date: Sun, 19 Sep 2010 16:26:53 +0200
From: Dan Carpenter <error27@gmail.com>
To: Vasiliy Kulikov <segooon@gmail.com>
Cc: kernel-janitors@vger.kernel.org, Boaz Harrosh <bharrosh@panasas.com>,
        Benny Halevy <bhalevy@panasas.com>,
        "James E.J. Bottomley" <James.Bottomley@suse.de>,
        Tejun Heo <tj@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        osd-dev@open-osd.org, linux-scsi@vger.kernel.org,
        cornelia.huck@de.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/14] scsi: osd: fix device_register() error handling
Message-ID: <20100919142653.GF6236@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Vasiliy Kulikov <segooon@gmail.com>,
	kernel-janitors@vger.kernel.org,
	Boaz Harrosh <bharrosh@panasas.com>,
	Benny Halevy <bhalevy@panasas.com>,
	"James E.J. Bottomley" <James.Bottomley@suse.de>,
	Tejun Heo <tj@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
	osd-dev@open-osd.org, linux-scsi@vger.kernel.org,
	cornelia.huck@de.ibm.com, linux-kernel@vger.kernel.org
References: <1284900907-24621-1-git-send-email-segooon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284900907-24621-1-git-send-email-segooon@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 19, 2010 at 04:55:07PM +0400, Vasiliy Kulikov wrote:
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

Hm...  So if device_register() fails then we should always call
device_put()?  It seems like a lot of existing code does that but I
hadn't realized until now that that is how it works.

Why can't the device_put() just be added inside the device_register() so
the unwinding works automatically?

Also if someone add some more stuff to the end of this function, will
the device_unregister() followed by a device_put() cause problems if we
unwind like this?

+err_free_something:
+	kfree(foo);
+	device_unregister(&oud->class_dev);
> +err_put_device:
> +	put_device(&oud->class_dev);
>  err_put_cdev:
>  	cdev_del(&oud->cdev);
>  err_put_disk:

If that's the case then the put_device() should be called infront of the
goto.

regards,
dan carpenter
