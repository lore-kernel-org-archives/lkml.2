Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757283Ab0LIU6Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 15:58:24 -0500
Received: from mga11.intel.com ([192.55.52.93]:17234 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753708Ab0LIU6W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 15:58:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,322,1288594800"; 
   d="scan'208";a="634847872"
Date: Thu, 9 Dec 2010 12:58:20 -0800
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Luben Tuikov <ltuikov@yahoo.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH 2/4] [USB] UASP: Add MaxNumStreams module parameter
Message-ID: <20101209205820.GA6014@xanatos>
References: <531583.43961.qm@web31816.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <531583.43961.qm@web31816.mail.mud.yahoo.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 08, 2010 at 03:55:27PM -0800, Luben Tuikov wrote:
> Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>
> ---
>  The long story is that we see some host controllers misreport their
>  PSA as they solved 2^v = streams, instead of 2^(v+1) = streams. Thus
>  They report that they support 32 streams when in fact they support 16.
>  When the device attempts to return status for stream > 15, the host
>  says ACK(NumP=0), the device goes in flow control, blah, blah, this
>  module parameter allows you to set a max cap on the number of streams
>  the driver will ask XHCI HCD to allocate.

If this is an issue with a host then the work-around should be in the
xHCI driver instead.  It should be based on the vendor/device ID of the
offending host instead of being a module parameter in the UAS driver.
The only people who benefit from this patch are the people "in the know"
about which hosts are buggy, not normal Linux users.

Streams could be used for things other than UAS in the future, so the
fix should really be in the xHCI host controller driver.  And please put
the information about the host bug in the commit message, so your
private comments don't get lost in the bowels of the linux-usb mailing
list.

In the future, please Cc me on any patches that involve xHCI, or bulk
streams in general.  I'm not an enemy; I frankly don't care which UAS
driver gets in the kernel, I just want one good, well documented driver,
and for the xHCI driver to be as good as possible.

Sarah Sharp


>  drivers/usb/storage/uasp.c |   21 ++++++++++++++++++++-
>  1 files changed, 20 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/usb/storage/uasp.c b/drivers/usb/storage/uasp.c
> index 3b10efd..e5a26e9 100644
> --- a/drivers/usb/storage/uasp.c
> +++ b/drivers/usb/storage/uasp.c
> @@ -30,6 +30,19 @@
>  #include <scsi/scsi_host.h>
>  #include <scsi/scsi_tcq.h>
>  
> +int MaxNumStreams = -1;
> +
> +module_param(MaxNumStreams, int, 0444);
> +MODULE_PARM_DESC(MaxNumStreams, "\n"
> +	"\tSome host controllers and/or devices report a larger number of\n"
> +	"\tstreams that they in fact support. This parameter allows you\n"
> +	"\tto limit the number of streams this driver will request the XHCI\n"
> +	"\tHCD to allocate. If set to -1, the default value, then this driver\n"
> +	"\twill use the value reported by the attached device. Else the\n"
> +	"\tnumber of streams will be limited to the minimum reported by the\n"
> +	"\tattached device and this value. Valid values are -1, default,\n"
> +	"\tand 1 to 0xFFEF.");
> +
>  /* Information unit types
>   */
>  #define IU_CMD   1
> @@ -938,6 +951,8 @@ static int uasp_ep_conf(struct uasp_tport_info *tpinfo)
>  					 tpinfo->eps[3]->desc.bEndpointAddress);
>  
>  	if (udev->speed == USB_SPEED_SUPER) {
> +		int max_streams;
> +
>  		for (i = 1; i < 4; i++) {
>  			if (tpinfo->max_streams == 0)
>  				tpinfo->max_streams = USB_SS_MAX_STREAMS(tpinfo->eps[i]->ss_ep_comp.bmAttributes);
> @@ -952,9 +967,13 @@ static int uasp_ep_conf(struct uasp_tport_info *tpinfo)
>  		}
>  		
>  		tpinfo->use_streams = 1;
> +		if (1 <= MaxNumStreams && MaxNumStreams <= 0xFFEF)
> +			max_streams = min(MaxNumStreams, tpinfo->max_streams);
> +		else
> +			max_streams = tpinfo->max_streams;
>  		tpinfo->num_streams = usb_alloc_streams(iface,
>  							&tpinfo->eps[1], 3,
> -							tpinfo->max_streams,
> +							max_streams,
>  							GFP_KERNEL);
>  		if (tpinfo->num_streams <= 0) {
>  			dev_err(&udev->dev,
> -- 
> 1.7.0.1
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
