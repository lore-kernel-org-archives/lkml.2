Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759271Ab0I0NOT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 09:14:19 -0400
Received: from mtagate4.de.ibm.com ([195.212.17.164]:43839 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759147Ab0I0NOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 09:14:16 -0400
Date: Mon, 27 Sep 2010 15:14:14 +0200
From: Christof Schmitt <christof.schmitt@de.ibm.com>
To: Vasiliy Kulikov <segooon@gmail.com>
Cc: kernel-janitors@vger.kernel.org, Swen Schillig <swen@vnet.ibm.com>,
        linux390@de.ibm.com, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        James Bottomley <James.Bottomley@suse.de>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/14] s390: scsi: fix error path
Message-ID: <20100927131413.GA8473@schmichrtp.mainz.de.ibm.com>
References: <1284900877-24201-1-git-send-email-segooon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284900877-24201-1-git-send-email-segooon@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 19, 2010 at 04:54:36PM +0400, Vasiliy Kulikov wrote:
> zfcp_unit_add() doesn't free all allocated resources in error case.
> 
> Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>

Where do you see a problem? The memory management for the unit 
device has to be done the way the current code does:

After dev_set_name, the struct has to be deleted through put_device
that calls the release functions and also frees the memory allocated
for the device name.

When the memory is freed through the release function, an additional
call to kfree is wrong, the release function already calls kfree.
device_unregister calls the put_device, so this also frees the memory
through the release function.

The only thing i found wrong is that zfcp_unit_release calls
put_device on the port, and this could be done before get_device was
called on the port. I will prepare a patch to move the get_device.

> ---
>  I cannot compile this driver, so it is not tested at all.
> 
>  drivers/s390/scsi/zfcp_unit.c |   28 +++++++++++++++++-----------
>  1 files changed, 17 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/s390/scsi/zfcp_unit.c b/drivers/s390/scsi/zfcp_unit.c
> index 1119c53..8eb4046 100644
> --- a/drivers/s390/scsi/zfcp_unit.c
> +++ b/drivers/s390/scsi/zfcp_unit.c
> @@ -119,6 +119,7 @@ static void zfcp_unit_release(struct device *dev)
>  int zfcp_unit_add(struct zfcp_port *port, u64 fcp_lun)
>  {
>  	struct zfcp_unit *unit;
> +	int err;
> 
>  	unit = zfcp_unit_find(port, fcp_lun);
>  	if (unit) {
> @@ -136,21 +137,20 @@ int zfcp_unit_add(struct zfcp_port *port, u64 fcp_lun)
>  	unit->dev.release = zfcp_unit_release;
>  	INIT_WORK(&unit->scsi_work, zfcp_unit_scsi_scan_work);
> 
> -	if (dev_set_name(&unit->dev, "0x%016llx",
> -			 (unsigned long long) fcp_lun)) {
> -		kfree(unit);
> -		return -ENOMEM;
> -	}
> +	err = dev_set_name(&unit->dev, "0x%016llx",
> +			 (unsigned long long) fcp_lun);
> +	if (err)
> +		goto err_free;
> 
> -	if (device_register(&unit->dev)) {
> +	err = device_register(&unit->dev);
> +	if (err) {
>  		put_device(&unit->dev);
> -		return -ENOMEM;
> +		goto err_free;
>  	}
> 
> -	if (sysfs_create_group(&unit->dev.kobj, &zfcp_sysfs_unit_attrs)) {
> -		device_unregister(&unit->dev);
> -		return -EINVAL;
> -	}
> +	err = sysfs_create_group(&unit->dev.kobj, &zfcp_sysfs_unit_attrs);
> +	if (err)
> +		goto err_unreg;
> 
>  	get_device(&port->dev);
> 
> @@ -161,6 +161,12 @@ int zfcp_unit_add(struct zfcp_port *port, u64 fcp_lun)
>  	zfcp_unit_scsi_scan(unit);
> 
>  	return 0;
> +
> +err_unreg:
> +	device_unregister(&unit->dev);
> +err_free:
> +	kfree(unit);
> +	return err;
>  }
> 
>  /**
> -- 
> 1.7.0.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-s390" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
