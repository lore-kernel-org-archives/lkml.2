Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933111Ab2JYAcq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 20:32:46 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:45292 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753836Ab2JYAco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 20:32:44 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Simon Haggett <simon.haggett@realvnc.com>
Cc: Li Yang-R58472 <r58472@freescale.com>, "balbi@ti.com" <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] usb: gadget: Don't attempt to dequeue requests for a disabled USB endpoint on Freescale hardware
Date: Thu, 25 Oct 2012 02:33:34 +0200
Message-ID: <270227469.pLqYTv1WEV@avalon>
User-Agent: KMail/4.9.2 (Linux/3.5.7-gentoo; KDE/4.9.2; x86_64; ; )
In-Reply-To: <508532DF.7050809@realvnc.com>
References: <1350667166-3559-1-git-send-email-simon.haggett@realvnc.com> <1535820.NU10ADjvOZ@avalon> <508532DF.7050809@realvnc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Simon,

On Monday 22 October 2012 12:49:51 Simon Haggett wrote:
> On 22/10/12 11:47, Laurent Pinchart wrote:
> > On Monday 22 October 2012 03:33:19 Li Yang-R58472 wrote:
> >> On Saturday, October 20, 2012 1:37 AM Felipe Balbi wrote:
> >>> On Fri, Oct 19, 2012 at 06:19:26PM +0100, Simon Haggett wrote:
> >>>> Some gadget drivers may attempt to dequeue requests for an endpoint
> >>>> that has already been disabled. For example, in the UVC gadget driver,
> >>>> uvc_function_set_alt() will call usb_ep_disable() when alt setting 0
> >>>> is selected. When the userspace application subsequently issues the
> >>>> VIDIOC_STREAMOFF ioctl, uvc_video_enable() invokes usb_ep_dequeue() to
> >>> 
> >>> ensure that all requests have been cancelled.
> >>> 
> >>> bug is on uvc gadget, then. Laurent ?
> > 
> > We've discussed this topic a couple of months before. I believe that's not
> > a bug.
> > 
> > http://68.183.106.108/lists/linux-usb/msg68869.html
> > 
> >>> Also, fsl should be removed from the tree, I'm trying to persuade iMX
> >>> folks to use drivers/usb/chipidea instead.
> >> 
> >> Besides the iMX usage, the driver is also being used by many Freescale
> >> PowerPC/Coldfire SoCs.  I agree that it's ideal to move to a common
> >> driver.
> >> But it is a large task to make the chipidea driver works for all the
> >> hardware that fsl_udc had supported and been tested on.
> >> 
> >>>> For the Freescale High Speed Dual-Role USB controller,
> >>>> fsl_ep_dequeue() provides the implementation of usb_ep_dequeue(). If
> >>>> this is called for a disabled endpoint, a kernel oops will occur when
> >>> 
> >>> the ep->ep.desc field is dereferenced (by ep_index()).
> >>> 
> >>>> fsl_ep_disable() sets this field to NULL, as well as deleting all
> >>>> pending requests for the endpoint.
> >>>> 
> >>>> This patch adds an additional check to fsl_ep_dequeue() to ensure that
> >>>> the endpoint has not already been disabled before attempting to dequeue
> >>> 
> >>> requests.
> >>> 
> >>>> Signed-off-by: Simon Haggett <simon.haggett@realvnc.com>
> >>>> ---
> >>>> 
> >>>>   drivers/usb/gadget/fsl_udc_core.c |    5 ++++-
> >>>>   1 files changed, 4 insertions(+), 1 deletions(-)
> >>>> 
> >>>> diff --git a/drivers/usb/gadget/fsl_udc_core.c
> >>>> b/drivers/usb/gadget/fsl_udc_core.c
> >>>> index 6ae70cb..acd513b 100644
> >>>> --- a/drivers/usb/gadget/fsl_udc_core.c
> >>>> +++ b/drivers/usb/gadget/fsl_udc_core.c
> >>>> @@ -955,7 +955,10 @@ static int fsl_ep_dequeue(struct usb_ep *_ep,
> >>> 
> >>> struct usb_request *_req)
> >>> 
> >>>>   	int ep_num, stopped, ret = 0;
> >>>>   	u32 epctrl;
> >>>> 
> >>>> -	if (!_ep || !_req)
> >>>> +	/* Ensure that the ep and request are valid, and the ep is not
> >>>> +	 * disabled
> >>>> +	 */
> >>>> +	if (!_ep || !_req || !ep->ep.desc)
> >>>> 
> >>>>   		return -EINVAL;
> > 
> > Shouldn't that last check be done with a lock taken ?
> 
> I had presumed a lock wasn't necessary because ep->ep.desc is only set
> to NULL by fsl_ep_disable() which, since it is called by
> usb_ep_disable(), should only be invoked when no other task is using the
> endpoint (according to include/linux/usb/gadget.h). Furthermore, the
> chipidea UDC driver does check the equivalent of this field is not NULL
> without taking a lock (ep_dequeue() in drivers/usb/chipidea/udc.c).
> 
> However, it is possible that I'm misunderstanding something here, so
> apologies if I am.

I might be wrong as well :-) I just wanted to point out something that 
appeared to me as a possible issue.

> >>>>   	spin_lock_irqsave(&ep->udc->lock, flags);

-- 
Regards,

Laurent Pinchart

