Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537Ab1F3SjO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 14:39:14 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:45941 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752205Ab1F3SjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 14:39:12 -0400
Date: Thu, 30 Jun 2011 11:39:12 -0700 (PDT)
From: William Gulland <wgulland@vmware.com>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: greg@kroah.com, linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        balbi@ti.com, ablay@codeaurora.org, Amit Blay <ablay@qualcomm.com>,
        open list <linux-kernel@vger.kernel.org>,
        Tatyana Brokhman <tlinder@codeaurora.org>
Message-ID: <22486791.51.1309459148983.JavaMail.wgulland@wgulland-win7>
In-Reply-To: <20110630174538.GA7979@xanatos>
Subject: Re: [PATCH/RFC 5/5] usb: Add support for streams alloc/dealloc to
 devio.c
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.113.61.162]
X-Mailer: Zimbra 7.1.1_GA_3204 (Zimbra Desktop/2.0.1_10659_Windows)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I haven't had a chance to really look into this yet, but we use usbfs and will want to use streams from userspace (from a VM we've connected a USB3 device to).

William

----- Original Message -----
From: "Sarah Sharp" <sarah.a.sharp@linux.intel.com>
To: "Tatyana Brokhman" <tlinder@codeaurora.org>
Cc: greg@kroah.com, linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org, balbi@ti.com, ablay@codeaurora.org, "Amit Blay" <ablay@qualcomm.com>, "open list" <linux-kernel@vger.kernel.org>
Sent: Thursday, June 30, 2011 10:45:38 AM
Subject: Re: [PATCH/RFC 5/5] usb: Add support for streams alloc/dealloc to devio.c

On Thu, Jun 16, 2011 at 04:31:07PM +0300, Tatyana Brokhman wrote:
> Allow user space applications such as LIBUSB, to request
> streams alloc/dealloc from HCD that implements XHCI.

Hi Tatyana,

Will this patch be used to create a userspace UAS driver, or are you
envisioning other ways userspace might use streams?  I ask because I
can't think of another usage of streams in currently available devices.

This patch is good to have, but I can't imagine that you'll get good
performance if you're trying to create a userspace UAS device.  After
all, usbfs does some fairly stupid things, performance wise, like using
kmalloc to allocate its URB buffers instead of usb_alloc_coherent, which
may cause the userspace buffer to be copied twice if the kmalloc memory
is not DMA'able.

usbfs probably could be changed to pin the user pages and the scatter
gather URB interface to try and avoid even one copy, but that's a
performance enhancement I haven't had time to play around with.  :)

> Signed-off-by: Amit Blay <ablay@qualcomm.com>
> Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>
> 
> ---
>  drivers/usb/core/devio.c     |  128 +++++++++++++++++++++++++++++++++++++++++-
>  include/linux/usbdevice_fs.h |    5 ++
>  2 files changed, 132 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
> index 37518df..7e73e35 100644
> --- a/drivers/usb/core/devio.c
> +++ b/drivers/usb/core/devio.c
> @@ -943,6 +943,115 @@ static int proc_clearhalt(struct dev_state *ps, void __user *arg)
>  	return usb_clear_halt(ps->dev, pipe);
>  }
>  
> +static int proc_allocstreams(struct dev_state *ps, void __user *arg)

It looks like userspace doesn't have a way to specify the number of
streams USBFS needs to allocate.  Not all userspace applications are
going to want to use all available streams (especially if the device
advertises the max of 65533).

You probably also need a way to communicate back to userspace how many
streams were actually allocated.  The program could choose to free
streams if it doesn't get the amount it expected.  (Also, it needs to
know how many streams are available, so it can set the stream ID.)

> +{
> +	unsigned int ep_map;
> +	int ret;
> +	int intf_num;
> +	struct usb_interface *intf = NULL;
> +	const int max_eps = 32;
> +	int max_streams = 0;
> +	struct usb_host_endpoint *eps[max_eps];
> +	int num_eps = 0;
> +	int i;
> +	unsigned int ep;
> +
> +	if (get_user(ep_map, (unsigned int __user *)arg))
> +		return -EFAULT;
> +
> +	for (i = 0; i < max_eps; i++) {
> +		if (ep_map & (0x1 << i)) {
> +			/* Convert from i to ep address */
> +			if (i < 16) /* IN EP */
> +				ep = i | USB_ENDPOINT_DIR_MASK;
> +			else /* OUT EP */
> +				ep = (i - 16);
> +
> +			intf_num = findintfep(ps->dev, ep);
> +			if (intf_num < 0)
> +				return intf_num;
> +			ret = checkintf(ps, intf_num);
> +			if (ret)
> +				return ret;
> +			intf = usb_ifnum_to_if(ps->dev, intf_num);
> +			if (!intf)
> +				return -ENOENT;
> +
> +			if (ep & USB_ENDPOINT_DIR_MASK)
> +				eps[num_eps] = ps->dev->ep_in[ep &
> +					USB_ENDPOINT_NUMBER_MASK];
> +			else
> +				eps[num_eps] = ps->dev->ep_out[ep &
> +					USB_ENDPOINT_NUMBER_MASK];
> +
> +			if (!max_streams)
> +				max_streams = USB_SS_MAX_STREAMS(
> +					eps[num_eps]->ss_ep_comp.bmAttributes);
> +

So you're just taking the max_streams from the first endpoint that has
streams?  What if other endpoints have varying numbers of max streams?
(A well-designed device probably wouldn't, but the spec doesn't disallow
it.)

All this checking is a bit redundant anyway.  The xHCI driver already
loops over the endpoints that you give it, checking for the minimum
number of reported maximum streams.  It will also make sure that isn't
more than the host controller supports.  So you might as well just ask
for the maximum possible number of streams (65533).

> +			num_eps++;
> +		}
> +	}
> +
> +	if (!intf || !max_streams)
> +		return -ENOENT;
> +
> +	ret = usb_alloc_streams(intf, eps, num_eps, max_streams, GFP_KERNEL);
> +	if (ret > 0)
> +		return 0;
> +	return ret;
> +}
> +


What if you have endpoints on an interface that don't support streams?
It looks like you're passing the xHCI driver all endpoints on a
particular interface.  The call to usb_alloc_streams() will fail if any
of those endpoints don't support streams.

So it seems like you also need a way for userspace to specify which
endpoints get streams, and which endpoints have streams freed.  I will
have to check, but I think the call to usb_free_streams() will fail if
any of the endpoints don't actually have streams enabled.

Sarah Sharp
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
