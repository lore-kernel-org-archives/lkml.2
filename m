Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414Ab1IBQgd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 12:36:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51383 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753195Ab1IBQg3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 12:36:29 -0400
Date: Fri, 2 Sep 2011 09:35:50 -0700
From: Greg KH <gregkh@suse.de>
To: Olaf Hering <olaf@aepfle.de>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Subject: Re: [PATCH] Staging: hv: vmbus: Show the modalias in
 /sys/bus/vmbus/devices/*/
Message-ID: <20110902163550.GA5508@suse.de>
References: <20110902162556.GA25073@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110902162556.GA25073@aepfle.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 02, 2011 at 06:25:56PM +0200, Olaf Hering wrote:
> Show a modalias file in /sys/bus/vmbus/devices/*/
> Add a helper function to print the same content in modalias and uevent.
> 
> Signed-off-by: Olaf Hering <olaf@aepfle.de>

Nice idea, thanks for this, one minor nit below:

> ---
>  drivers/staging/hv/vmbus_drv.c |   21 ++++++++++++++++-----
>  1 file changed, 16 insertions(+), 5 deletions(-)
> 
> --- a/drivers/staging/hv/vmbus_drv.c
> +++ b/drivers/staging/hv/vmbus_drv.c
> @@ -93,6 +93,14 @@ static void get_channel_info(struct hv_d
>  		debug_info.outbound.bytes_avail_towrite;
>  }
>  
> +#define VMBUS_ALIAS_LEN ((sizeof((struct hv_vmbus_device_id *)0)->guid) * 2)
> +static void print_alias_name(struct hv_device *hv_dev, char *alias_name)
> +{
> +	int i;
> +	for (i = 0; i < VMBUS_ALIAS_LEN; i += 2)
> +		sprintf(&alias_name[i], "%02x", hv_dev->dev_type.b[i/2]);
> +}
> +
>  /*
>   * vmbus_show_device_attr - Show the device attribute in sysfs.
>   *
> @@ -105,6 +113,7 @@ static ssize_t vmbus_show_device_attr(st
>  {
>  	struct hv_device *hv_dev = device_to_hv_device(dev);
>  	struct hv_device_info device_info;
> +	char alias_name[VMBUS_ALIAS_LEN + 1];

Is that too big to put on the stack?  64 bytes, right?  Hm, maybe not.

Wait, hv_device_info is huge, that should be dynamic in the first place.
Olaf, not your issue, but KY, want to fix that up?

thanks,

greg k-h
