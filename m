Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756043Ab1FPPGu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 11:06:50 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:57391 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755748Ab1FPPGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 11:06:48 -0400
Date: Thu, 16 Jun 2011 11:06:47 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tatyana Brokhman <tlinder@codeaurora.org>
cc: greg@kroah.com, <linux-usb@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>, <balbi@ti.com>,
        <ablay@codeaurora.org>, open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH/RFC 2/5] usb:dummy_hcd: connect/disconnect test support
In-Reply-To: <1308231068-24038-3-git-send-email-tlinder@codeaurora.org>
Message-ID: <Pine.LNX.4.44L0.1106161101300.2204-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Jun 2011, Tatyana Brokhman wrote:

> This implementation adds a new proprietary device control requests (to be
> handled by the dummy_hcd) that initiates a connect/disconnect sequence.
> The bRequest value of the new control request is 0x52.
> It is used by the user-space Unit testing application.

This is not a bad idea.  On the other hand, it is slightly peculiar -- 
it you're testing with real UDC hardware, you would do the 
disconnect/reconnect sequence by hand (unplug and replug the USB 
cable), not in software.

> Signed-off-by: Tatyana Linder <tlinder@codeaurora.org>
> 
> ---
>  drivers/usb/gadget/dummy_hcd.c |   48 ++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 48 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/usb/gadget/dummy_hcd.c b/drivers/usb/gadget/dummy_hcd.c
> index 74b7655..7d0a6fe 100644
> --- a/drivers/usb/gadget/dummy_hcd.c
> +++ b/drivers/usb/gadget/dummy_hcd.c
> @@ -179,6 +179,7 @@ struct dummy_hcd {
>  	unsigned			active:1;
>  	unsigned			old_active:1;
>  	unsigned			resuming:1;
> +	struct work_struct		conn_disc_work;
>  };
>  
>  struct dummy {
> @@ -1362,6 +1363,43 @@ static struct dummy_ep *find_endpoint (struct dummy *dum, u8 address)
>  #define Ep_Request	(USB_TYPE_STANDARD | USB_RECIP_ENDPOINT)
>  #define Ep_InRequest	(Ep_Request | USB_DIR_IN)
>  
> +/**
> + * dummy_hcd_conn_disc_work() - performs a disconnect/connect sequence.
> + * @data: pointer to the sceduled work_struct

Spelling error.

> + */
> +static void dummy_hcd_conn_disc_work(struct work_struct *data)
> +{
> +	struct dummy_hcd *dum_hcd =
> +		container_of(data, struct dummy_hcd, conn_disc_work);
> +	int ret_val;
> +
> +	if (!dum_hcd->dum->driver) {
> +		dev_err(dummy_dev(dum_hcd),
> +			"dummy_hcd_conn_disc_work called without connected "
> +			"device\n");
> +		return;
> +	}
> +
> +	dev_info(dummy_dev(dum_hcd), "disconnecting device...\n");
> +	ret_val = dummy_pullup(&dum_hcd->dum->gadget, 0);
> +	if (ret_val) {
> +		dev_err(dummy_dev(dum_hcd), "dummy_hcd_conn_disc_work:"
> +					    " couldn't disconnect device:"
> +					    " ret_val=%d\n",
> +				ret_val);
> +		return;
> +	}
> +
> +	dev_info(dummy_dev(dum_hcd), "re-connecting device...\n");
> +	/* We have to let the hub task to update the device disconnect state */
> +	msleep_interruptible(1000);

These two lines should come before the "re-connecting" message.

> +	ret_val = dummy_pullup(&dum_hcd->dum->gadget, 1);
> +	if (ret_val)
> +		dev_err(dummy_dev(dum_hcd), "dummy_hcd_conn_disc_work:"
> +					    " couldn't re-connect device:"
> +					    " ret_val=%d\n",
> +				ret_val);
> +}
>  
>  /**
>   * handle_control_request() - handles all control transfers
> @@ -1534,6 +1572,10 @@ static int handle_control_request(struct dummy_hcd *dum_hcd, struct urb *urb,
>  			*status = 0;
>  		}
>  		break;
> +	case 0x52:	/* UT: Connect/disconnect the device */

Please define a symbolic constant for this.  Also, nobody is going to 
know what "UT:" is supposed to mean.

The rest is okay.

Alan Stern

