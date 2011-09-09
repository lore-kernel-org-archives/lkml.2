Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933693Ab1IIUr7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 16:47:59 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:60802 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759922Ab1IIUrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 16:47:32 -0400
X-Sasl-enc: pVJH+sWN9Zb0gkPvs5QZ/UrjDaJ5VxtVQwBGNrfcGTee 1315601251
Date: Fri, 9 Sep 2011 13:44:51 -0700
From: Greg KH <greg@kroah.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH 18/25] Staging: hv: storvsc: Eliminate the usage of ext
 field in struct  hv_device
Message-ID: <20110909204451.GH19127@kroah.com>
References: <1315491843-9513-1-git-send-email-kys@microsoft.com>
 <1315491876-9554-1-git-send-email-kys@microsoft.com>
 <1315491876-9554-18-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315491876-9554-18-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 08, 2011 at 07:24:29AM -0700, K. Y. Srinivasan wrote:
> Now, eliminate the usage of ext field in struct  hv_device for storvsc driver.
> We do this by registering pointer to struct storvsc_device as the driver
> specific data and eliminating the current usage of driver specific data to
> save and retrieve the pointer to struct Scsi_Host.
> Additionally, all access to the driver specific data is through
> the vmbus wrapper functions.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> ---
>  drivers/staging/hv/storvsc_drv.c |   24 +++++++++++++++---------
>  1 files changed, 15 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
> index 57c1035..98d47cd 100644
> --- a/drivers/staging/hv/storvsc_drv.c
> +++ b/drivers/staging/hv/storvsc_drv.c
> @@ -266,6 +266,7 @@ struct storvsc_device {
>  	bool	 destroy;
>  	bool	 drain_notify;
>  	atomic_t num_outstanding_req;
> +	struct Scsi_Host *host;

You are properly reference counting this pointer, right?

> @@ -306,7 +307,8 @@ static inline struct storvsc_device *get_out_stor_device(
>  {
>  	struct storvsc_device *stor_device;
>  
> -	stor_device = (struct storvsc_device *)device->ext;
> +	stor_device =
> +		(struct storvsc_device *)hv_get_drvdata(device);

Casting is not needed at all.

> @@ -1366,7 +1371,8 @@ static int storvsc_probe(struct hv_device *device,
>  	stor_device->destroy = false;
>  	init_waitqueue_head(&stor_device->waiting_to_drain);
>  	stor_device->device = device;
> -	device->ext = stor_device;
> +	stor_device->host = host;
> +	hv_set_drvdata(device, stor_device);

Lookie there, no reference count incremented, right?  Or did I miss it
somewhere else?

gotta love dynamic pointer lifetime rules...

greg k-h
