Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757660Ab0JRSgg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 14:36:36 -0400
Received: from netrider.rowland.org ([192.131.102.5]:37266 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755416Ab0JRSgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 14:36:35 -0400
Date: Mon, 18 Oct 2010 14:36:32 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Tatyana Brokhman <tlinder@codeaurora.org>
cc: USB list <linux-usb@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC/PATCH v2 2/3] usb: dummy_hcd code simplification
In-Reply-To: <1287414267-26499-1-git-send-email-tlinder@codeaurora.org>
Message-ID: <Pine.LNX.4.44L0.1010181427211.28752-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Oct 2010, Tatyana Brokhman wrote:

> Take handling of the control requests out from dummy_timer to a different
> function.

This is basically okay but it has a few problems.

> 
> Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>
> ---
>  drivers/usb/gadget/dummy_hcd.c |  284 ++++++++++++++++++++++++----------------
>  1 files changed, 168 insertions(+), 116 deletions(-)
> 
> diff --git a/drivers/usb/gadget/dummy_hcd.c b/drivers/usb/gadget/dummy_hcd.c
> index dc65462..7640e06 100644
> --- a/drivers/usb/gadget/dummy_hcd.c
> +++ b/drivers/usb/gadget/dummy_hcd.c
> @@ -1195,6 +1195,173 @@ static struct dummy_ep *find_endpoint (struct dummy *dum, u8 address)
>  #define Ep_Request	(USB_TYPE_STANDARD | USB_RECIP_ENDPOINT)
>  #define Ep_InRequest	(Ep_Request | USB_DIR_IN)
>  
> +
> +/**
> + * This function handles all control transferes
> + *
> + * @param dum - pointer to dummy (the_controller)
> + * @param urb - the urb request to handle
> + * @param status - pointer to request handling status
> + * @param master - pointer to the dummy master this request was
> + *		 received for
> + */

The kerneldoc format is still wrong.  Please fix it.  What is all this
"@param" stuff?  And what is "master"?

> +static int handle_control_request(struct dummy *dum, struct urb *urb,
> +				  int *status)
> +{
> +	struct usb_ctrlrequest setup;
> +	struct dummy_ep		*ep2;
> +	int			ret_val = 1;
> +	unsigned	w_index;
> +	unsigned	w_value;
> +
> +	setup = *(struct usb_ctrlrequest *) urb->setup_packet;

You should pass the "setup" variable as a pointer instead of making it
a local variable.

> +	w_index = le16_to_cpu(setup.wIndex);
> +	w_value = le16_to_cpu(setup.wValue);
> +	switch (setup.bRequest) {
> +	case USB_REQ_SET_ADDRESS:
> +		if (setup.bRequestType != Dev_Request)
> +			break;
> +		dum->address = w_value;
> +		*status = 0;
> +		dev_dbg(udc_dev(dum), "set_address = %d\n",
> +				w_value);
> +		ret_val = 0;
> +		break;
> +	case USB_REQ_SET_FEATURE:
> +		if (setup.bRequestType == Dev_Request) {
> +			ret_val = 0;
> +			switch (w_value) {
> +			case USB_DEVICE_REMOTE_WAKEUP:
> +				break;
> +			case USB_DEVICE_B_HNP_ENABLE:
> +				dum->gadget.b_hnp_enable = 1;
> +				break;
> +			case USB_DEVICE_A_HNP_SUPPORT:
> +				dum->gadget.a_hnp_support = 1;
> +				break;
> +			case USB_DEVICE_A_ALT_HNP_SUPPORT:
> +				dum->gadget.a_alt_hnp_support = 1;
> +				break;
> +			case USB_DEVICE_U1_ENABLE:
> +				if (dum->gadget.speed == USB_SPEED_SUPER)
> +					w_value = USB_DEV_STAT_U1_ENABLED;
> +				else
> +					ret_val = -EOPNOTSUPP;
> +				break;
> +			case USB_DEVICE_U2_ENABLE:
> +				if (dum->gadget.speed == USB_SPEED_SUPER)
> +					w_value = USB_DEV_STAT_U2_ENABLED;
> +				else
> +					ret_val = -EOPNOTSUPP;
> +				break;
> +			case USB_DEVICE_LTM_ENABLE:
> +				if (dum->gadget.speed == USB_SPEED_SUPER)
> +					w_value = USB_DEV_STAT_LTM_ENABLED;
> +				else
> +					ret_val = -EOPNOTSUPP;
> +				break;

Where did these last three cases come from?  They aren't in the current
version of dummy-hcd.  The same is true for the cases under
USB_REQ_CLEAR_FEATURE.

Alan Stern

