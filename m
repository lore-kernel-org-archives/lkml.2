Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932868Ab2JVDrZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 23:47:25 -0400
Received: from co1ehsobe006.messaging.microsoft.com ([216.32.180.189]:34164
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932824Ab2JVDrY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 23:47:24 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -7
X-BigFish: VS-7(zz98dI9371I542M1432Izz1202h1d1ah1d2ahzz8275bhz2dh2a8h668h839h8e2h8e3h944hd25hf0ah107ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504hbe9i1155h)
From: Li Yang-R58472 <r58472@freescale.com>
To: "balbi@ti.com" <balbi@ti.com>, Simon Haggett <simon.haggett@realvnc.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: RE: [PATCH 1/1] usb: gadget: Don't attempt to dequeue requests for
 a disabled USB endpoint on Freescale hardware
Thread-Topic: [PATCH 1/1] usb: gadget: Don't attempt to dequeue requests for
 a disabled USB endpoint on Freescale hardware
Thread-Index: AQHNrh30WnHrKXDxaEa6VQcbRmVrJZfA5IqAgAPGudA=
Date: Mon, 22 Oct 2012 03:33:19 +0000
Message-ID: <94F013E7935FF44C83EBE7784D62AD3F094730DB@039-SN2MPN1-023.039d.mgd.msft.net>
References: <1350667166-3559-1-git-send-email-simon.haggett@realvnc.com>
 <20121019173718.GA2738@arwen.pp.htv.fi>
In-Reply-To: <20121019173718.GA2738@arwen.pp.htv.fi>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.193.20.78]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Felipe Balbi [mailto:balbi@ti.com]
> Sent: Saturday, October 20, 2012 1:37 AM
> To: Simon Haggett
> Cc: Li Yang-R58472; Felipe Balbi; Greg Kroah-Hartman; linux-
> usb@vger.kernel.org; linuxppc-dev@lists.ozlabs.org; linux-
> kernel@vger.kernel.org; Laurent Pinchart
> Subject: Re: [PATCH 1/1] usb: gadget: Don't attempt to dequeue requests
> for a disabled USB endpoint on Freescale hardware
> 
> Hi,
> 
> On Fri, Oct 19, 2012 at 06:19:26PM +0100, Simon Haggett wrote:
> > Some gadget drivers may attempt to dequeue requests for an endpoint
> > that has already been disabled. For example, in the UVC gadget driver,
> > uvc_function_set_alt() will call usb_ep_disable() when alt setting 0
> > is selected. When the userspace application subsequently issues the
> > VIDIOC_STREAMOFF ioctl, uvc_video_enable() invokes usb_ep_dequeue() to
> ensure that all requests have been cancelled.
> 
> bug is on uvc gadget, then. Laurent ?
> 
> Also, fsl should be removed from the tree, I'm trying to persuade iMX
> folks to use drivers/usb/chipidea instead.

Besides the iMX usage, the driver is also being used by many Freescale PowerPC/Coldfire SoCs.  I agree that it's ideal to move to a common driver.  But it is a large task to make the chipidea driver works for all the hardware that fsl_udc had supported and been tested on.

> 
> > For the Freescale High Speed Dual-Role USB controller,
> > fsl_ep_dequeue() provides the implementation of usb_ep_dequeue(). If
> > this is called for a disabled endpoint, a kernel oops will occur when
> the ep->ep.desc field is dereferenced (by ep_index()).
> > fsl_ep_disable() sets this field to NULL, as well as deleting all
> > pending requests for the endpoint.
> >
> > This patch adds an additional check to fsl_ep_dequeue() to ensure that
> > the endpoint has not already been disabled before attempting to dequeue
> requests.
> >
> > Signed-off-by: Simon Haggett <simon.haggett@realvnc.com>
> > ---
> >  drivers/usb/gadget/fsl_udc_core.c |    5 ++++-
> >  1 files changed, 4 insertions(+), 1 deletions(-)
> >
> > diff --git a/drivers/usb/gadget/fsl_udc_core.c
> > b/drivers/usb/gadget/fsl_udc_core.c
> > index 6ae70cb..acd513b 100644
> > --- a/drivers/usb/gadget/fsl_udc_core.c
> > +++ b/drivers/usb/gadget/fsl_udc_core.c
> > @@ -955,7 +955,10 @@ static int fsl_ep_dequeue(struct usb_ep *_ep,
> struct usb_request *_req)
> >  	int ep_num, stopped, ret = 0;
> >  	u32 epctrl;
> >
> > -	if (!_ep || !_req)
> > +	/* Ensure that the ep and request are valid, and the ep is not
> > +	 * disabled
> > +	 */
> > +	if (!_ep || !_req || !ep->ep.desc)
> >  		return -EINVAL;
> >
> >  	spin_lock_irqsave(&ep->udc->lock, flags);
> > --
> > 1.7.4.1
> >
> 
> --
> balbi

