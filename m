Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129Ab1EWJO5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 05:14:57 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:31189 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436Ab1EWJOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 05:14:55 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6354"; a="92952489"
From: "Tanya Brokhman" <tlinder@codeaurora.org>
To: <balbi@ti.com>
Cc: <greg@kroah.com>, <linux-usb@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>, <ablay@codeaurora.org>,
        "'open list'" <linux-kernel@vger.kernel.org>,
        "'Sarah Sharp'" <sarah.a.sharp@linux.intel.com>
References: <1306132882-9668-1-git-send-email-tlinder@codeaurora.org> <1306132882-9668-8-git-send-email-tlinder@codeaurora.org> <20110523070556.GJ3095@legolas.emea.dhcp.ti.com> <00a301cc1919$f0e1fa00$d2a5ee00$@org> <20110523072142.GK3095@legolas.emea.dhcp.ti.com> <00cc01cc1922$0fb4ee80$2f1ecb80$@org> <20110523083208.GM3095@legolas.emea.dhcp.ti.com>
In-Reply-To: <20110523083208.GM3095@legolas.emea.dhcp.ti.com>
Subject: RE: [PATCH v12 7/8] usb: Adding SuperSpeed support to dummy_hcd
Date: Mon, 23 May 2011 12:16:40 +0300
Message-ID: <00e401cc192a$2211bb50$663531f0$@org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcwZI+rBur97YRclR8OQyqnCvPAGwQAASmFw
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi 

> > > >
> > > > You mean I don't need the module parameter? IMO it's the best way
> > > > to enable HS connection. If driver->speed=USB_SPEED_SUPER than
> > > > dummy_hcd will try to enumerate the device on the SS root hub and
> > > > if the gadget didn't provide SS descriptors - it will fail. Just
> > > > as it happened before. Finding out from
> > >
> > > then it should hand the device over to the hs_hcd ;-) Meaning it
> > > would disconnect the device, switch to hs_hcd and reconnect :-)
> >
> > Yes this will be the best solution :) But as I said, the enumeration
> > occurs not in dummy_hcd thus I'm not sure how dummy_hcd can find out
> > that it failed
> 
> take a look at xhci-ring.c for an example :-)
> 
> see that it check whether the attached device is a USB3.0 device or
> USB2.0/1.1 device and chooses hcd or shared_hcd accordingly.
> 

I ran some more tests with xhci and I think (or hope :) ) I figured this
out:
When connecting a gadget driver that is marked as SS device (the flag
CONFIG_USB_GADGET_IS_SUPER_SPEED = true) to a SS port over SS cable - 
the enumeration fails if that gadget driver doesn't provide SS descriptors. 
BUT: if I connect the same device via HS cable to SS port - the enumeration
is successful. I think that this is the case where xhci-ring handles the
device over to the HS hcd :) (By the way, I think that in xhci the
shared_hcd is SS and the main_hcd is HS)

In conclusion it seems to me that the device speed is determined by 2
things:
1. the cable used
2. whether the device HW supports SS protocol. In our scenario it can since
SS support is enabled in our udc. (We haven't released it yet.)
So when a HS device is connected to a SS port, the xHCI checks it's speed
and if necessary handles it over to the SS root hub. But this is done prior
to the enumeration phase so if the device speed is SS but it has no SS
descriptors - the enumeration will fail. The enumeration itself occurs not
in xhci but in hub.c so the xhci isn't aware of the fact that it failed and
doesn't handle this.

Since in dummy_hcd all of this is much simpler I think that the device speed
should be determined by driver->speed and "which type of cable the
connection was made over - SS or HS". The "cable type" is exactly what the
module parameter is.

My familiarity with the Linux host isn't as good as I would like it to be
(still working on that) so I might be wrong with my conclusions...

Best regards,
Tanya Brokhman
Consultant for Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum




