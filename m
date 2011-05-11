Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403Ab1EKPyb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 11:54:31 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:23335 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022Ab1EKPy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 11:54:28 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6342"; a="90762657"
From: "Tanya Brokhman" <tlinder@codeaurora.org>
To: <balbi@ti.com>
Cc: <greg@kroah.com>, <linux-usb@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>, <ablay@codeaurora.org>,
        "'Maya Erez'" <merez@codeaurora.org>,
        "'open list'" <linux-kernel@vger.kernel.org>
References: <1304853414-10234-1-git-send-email-tlinder@codeaurora.org> <1304853414-10234-6-git-send-email-tlinder@codeaurora.org> <20110509092555.GF1254@legolas.emea.dhcp.ti.com>
In-Reply-To: <20110509092555.GF1254@legolas.emea.dhcp.ti.com>
Subject: RE: [PATCH v9 5/7] usb: Add streams support to the gadget framework
Date: Wed, 11 May 2011 16:29:44 +0300
Message-ID: <000a01cc0fdf$7fa623e0$7ef26ba0$@org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcwOKxQRblPU21FVTEekdy+oay8p2wBshbzg
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe

> > @@ -129,6 +132,22 @@ ep_matches (
> >  	}
> >
> >  	/*
> > +	 * Get the number of required streams from the EP companion
> > +	 * descriptor and see if the EP matches it
> > +	 */
> > +	if (usb_endpoint_xfer_bulk(desc)) {
> > +		if (ep_comp) {
> > +			num_req_streams = ep_comp->bmAttributes & 0x1f;
> > +			if (num_req_streams > ep->max_streams)
> > +				return 0;
> 
> We would like the gadget drivers to all with all controllers, this
> would
> likely be better to ask from controller driver for N streams but work
> if
> we get less ? Something like:
> 
> struct usb_gadget_ops {
> 	...
> 	request_stream(struct usb_gadget *g, int max_streams);
> };
> 
> if (usb_endpoint_xfer_bulk(desc)) {
> 	if (ep_comp) {
> 		num_req_streams = usb_gadget_request_streams(gadget,
> 			ep_comp->bmAttributes & 0x1f);
> 
> 		/* now patch ep_comp descriptor */
> 		ep_comp->bmAttributes = num_req_streams;
> 	}
> }
> 
> this way, different function drivers can request for a different number
> of streams and controller driver is required to keep track of total
> number of streams, and number of "busy" streams.
> 

I'm not sure I understand what you meant by the above..
When choosing this approach we thought of the following design:
Each controller knows how many streams it supports for each endpoint and
inits the ep->max_streams filed accordingly. Each gadget driver declares the
number of streams it wishes to operate with using the comp_desc and if the
endpoint can support the requested number of streams - it's allocated for
that gadget driver. If no matching endpoint is found - it's up to the gadget
driver to decide what to do next. One approach could be to try and configure
the endpoint with less streams. For example in UAS if configuring the
endpoint with streams>0 fails, we fall  back to HS mode where no streams are
required.

Does this address your concerns? Perhaps this is what you meant...

> Another approach would be to require function drivers to request the
> streams during bind by themselves and only give this layer correct
> descriptors, which allow you to make those arguments const.

Actually, during bind we still don't know the connection speed so the number
of streams can't be determined at that point. For example: when UAS gadget
driver operates in HS mode the number of streams is 0, when in SS > 0. I
think this is the right place for streams configuration.


Best regards,
Tanya Brokhman
Consultant for Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum




