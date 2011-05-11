Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755815Ab1EKUyY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 16:54:24 -0400
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:41311 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755664Ab1EKUyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 16:54:22 -0400
Date: Wed, 11 May 2011 23:54:09 +0300
From: Felipe Balbi <balbi@ti.com>
To: Tanya Brokhman <tlinder@codeaurora.org>
Cc: balbi@ti.com, greg@kroah.com, linux-usb@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, ablay@codeaurora.org,
        "'Maya Erez'" <merez@codeaurora.org>,
        "'open list'" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v9 5/7] usb: Add streams support to the gadget framework
Message-ID: <20110511205404.GZ2505@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1304853414-10234-1-git-send-email-tlinder@codeaurora.org>
 <1304853414-10234-6-git-send-email-tlinder@codeaurora.org>
 <20110509092555.GF1254@legolas.emea.dhcp.ti.com>
 <000a01cc0fdf$7fa623e0$7ef26ba0$@org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000a01cc0fdf$7fa623e0$7ef26ba0$@org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, May 11, 2011 at 04:29:44PM +0300, Tanya Brokhman wrote:
> Hi Felipe
> 
> > > @@ -129,6 +132,22 @@ ep_matches (
> > >  	}
> > >
> > >  	/*
> > > +	 * Get the number of required streams from the EP companion
> > > +	 * descriptor and see if the EP matches it
> > > +	 */
> > > +	if (usb_endpoint_xfer_bulk(desc)) {
> > > +		if (ep_comp) {
> > > +			num_req_streams = ep_comp->bmAttributes & 0x1f;
> > > +			if (num_req_streams > ep->max_streams)
> > > +				return 0;
> > 
> > We would like the gadget drivers to all with all controllers, this
> > would
> > likely be better to ask from controller driver for N streams but work
> > if
> > we get less ? Something like:
> > 
> > struct usb_gadget_ops {
> > 	...
> > 	request_stream(struct usb_gadget *g, int max_streams);
> > };
> > 
> > if (usb_endpoint_xfer_bulk(desc)) {
> > 	if (ep_comp) {
> > 		num_req_streams = usb_gadget_request_streams(gadget,
> > 			ep_comp->bmAttributes & 0x1f);
> > 
> > 		/* now patch ep_comp descriptor */
> > 		ep_comp->bmAttributes = num_req_streams;
> > 	}
> > }
> > 
> > this way, different function drivers can request for a different number
> > of streams and controller driver is required to keep track of total
> > number of streams, and number of "busy" streams.
> > 
> 
> I'm not sure I understand what you meant by the above..
> When choosing this approach we thought of the following design:
> Each controller knows how many streams it supports for each endpoint and
> inits the ep->max_streams filed accordingly. Each gadget driver declares the
> number of streams it wishes to operate with using the comp_desc and if the
> endpoint can support the requested number of streams - it's allocated for
> that gadget driver. If no matching endpoint is found - it's up to the gadget
> driver to decide what to do next. One approach could be to try and configure
> the endpoint with less streams. For example in UAS if configuring the
> endpoint with streams>0 fails, we fall  back to HS mode where no streams are
> required.
> 
> Does this address your concerns? Perhaps this is what you meant...

Ok, I understand what you meant now.

> > Another approach would be to require function drivers to request the
> > streams during bind by themselves and only give this layer correct
> > descriptors, which allow you to make those arguments const.
> 
> Actually, during bind we still don't know the connection speed so the number
> of streams can't be determined at that point. For example: when UAS gadget
> driver operates in HS mode the number of streams is 0, when in SS > 0. I
> think this is the right place for streams configuration.

true, didn't think it that way ;-)

-- 
balbi
