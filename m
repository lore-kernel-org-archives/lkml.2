Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934388Ab0EZUv4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 16:51:56 -0400
Received: from cantor.suse.de ([195.135.220.2]:56497 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933334Ab0EZUvx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 16:51:53 -0400
Date: Wed, 26 May 2010 13:51:34 -0700
From: Greg KH <gregkh@suse.de>
To: Haiyang Zhang <haiyangz@microsoft.com>
Cc: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       "'devel@driverdev.osuosl.org'" <devel@driverdev.osuosl.org>,
       "'virtualization@lists.osdl.org'" <virtualization@lists.osdl.org>,
       Hank Janssen <hjanssen@microsoft.com>
Subject: Re: [PATCH 1/1] staging: hv: Fix race condition on IC channel
 initialization (modified)
Message-ID: <20100526205134.GC7343@suse.de>
References: <1FB5E1D5CA062146B38059374562DF7266B8C4AC@TK5EX14MBXC128.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1FB5E1D5CA062146B38059374562DF7266B8C4AC@TK5EX14MBXC128.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 26, 2010 at 04:54:39PM +0000, Haiyang Zhang wrote:
> From: Haiyang Zhang <haiyangz@microsoft.com>
> 
> Subject: [PATCH] staging: hv: Fix race condition on IC channel initialization
> There is a possible race condition when hv_utils starts to load immediately
> after hv_vmbus is loading - null pointer error could happen.
> This patch added an event waiting to ensure all channels are ready before
> vmbus_init() returns. So another module won't have any uninitialized channel.
> 
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
> 
> ---
>  drivers/staging/hv/channel_mgmt.c  |   23 +++++++++++++----------
>  drivers/staging/hv/vmbus_drv.c     |   10 ++++++++++
>  drivers/staging/hv/vmbus_private.h |    1 +
>  3 files changed, 24 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/staging/hv/channel_mgmt.c b/drivers/staging/hv/channel_mgmt.c
> index 3f53b4d..f99db1b 100644
> --- a/drivers/staging/hv/channel_mgmt.c
> +++ b/drivers/staging/hv/channel_mgmt.c
> @@ -305,6 +305,7 @@ static void VmbusChannelProcessOffer(void *context)
>  	int ret;
>  	int cnt;
>  	unsigned long flags;
> +	static atomic_t ic_channel_initcnt = ATOMIC_INIT(0);

Why is this an atomic_t?

>  	DPRINT_ENTER(VMBUS);
>  
> @@ -373,22 +374,24 @@ static void VmbusChannelProcessOffer(void *context)
>  		 * can cleanup properly
>  		 */
>  		newChannel->State = CHANNEL_OPEN_STATE;
> -		cnt = 0;
>  
> -		while (cnt != MAX_MSG_TYPES) {
> +		/* Open IC channels */
> +		for (cnt = 0; cnt < MAX_MSG_TYPES; cnt++) {
>  			if (memcmp(&newChannel->OfferMsg.Offer.InterfaceType,
>  				   &hv_cb_utils[cnt].data,
> -				   sizeof(struct hv_guid)) == 0) {
> +				   sizeof(struct hv_guid)) == 0 &&
> +			    VmbusChannelOpen(newChannel, 2 * PAGE_SIZE,
> +					     2 * PAGE_SIZE, NULL, 0,
> +					     hv_cb_utils[cnt].callback,
> +					     newChannel) == 0) {
> +				hv_cb_utils[cnt].channel = newChannel;
> +				mb();

What is the mb() call for?  Why is it necessary?  (hint, if you need it,
something else is really wrong...)

Something wierd happened with your indentation here, it doesn't line up
properly.  That call to VmbusChannelOpen() needs to go in a full tab,
not 4 spaces.

Please always run your patch through the checkpatch.pl script before
sending it to me.


>  				DPRINT_INFO(VMBUS, "%s",
>  					    hv_cb_utils[cnt].log_msg);
> -
> -				if (VmbusChannelOpen(newChannel, 2 * PAGE_SIZE,
> -						    2 * PAGE_SIZE, NULL, 0,
> -						    hv_cb_utils[cnt].callback,
> -						    newChannel) == 0)
> -					hv_cb_utils[cnt].channel = newChannel;
> +				if (atomic_inc_return(&ic_channel_initcnt) ==
> +				   MAX_MSG_TYPES)
> +					osd_WaitEventSet(ic_channel_ready);
>  			}
> -			cnt++;
>  		}
>  	}
>  	DPRINT_EXIT(VMBUS);
> diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
> index c21731a..3ae8981 100644
> --- a/drivers/staging/hv/vmbus_drv.c
> +++ b/drivers/staging/hv/vmbus_drv.c
> @@ -989,6 +989,8 @@ static struct dmi_system_id __initdata microsoft_hv_dmi_table[] = {
>  };
>  MODULE_DEVICE_TABLE(dmi, microsoft_hv_dmi_table);
>  
> +struct osd_waitevent *ic_channel_ready;

What's with the "ic_" naming scheme here?  It should be "hv_" right?

> +
>  static int __init vmbus_init(void)
>  {
>  	int ret = 0;
> @@ -1003,8 +1005,16 @@ static int __init vmbus_init(void)
>  	if (!dmi_check_system(microsoft_hv_dmi_table))
>  		return -ENODEV;
>  
> +	ic_channel_ready = osd_WaitEventCreate();
> +	if (ic_channel_ready == NULL)
> +		return -ENOMEM;
> +
>  	ret = vmbus_bus_init(VmbusInitialize);

As you are using this "ic_channel_ready variable only within the
vmbus_bus_init() call, why not just make it local to there?  Then
there's no need to do the create/init/wait/free sequence outside the
init call.

The init call should just do all of this for us, right?

thanks,

greg k-h
