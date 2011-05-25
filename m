Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622Ab1EYKB3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 06:01:29 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:49376 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051Ab1EYKB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 06:01:27 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6356"; a="93314334"
From: "Tanya Brokhman" <tlinder@codeaurora.org>
To: <balbi@ti.com>
Cc: "'Alan Stern'" <stern@rowland.harvard.edu>,
        "'Sarah Sharp'" <sarah.a.sharp@linux.intel.com>, <greg@kroah.com>,
        <linux-usb@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>,
        <ablay@codeaurora.org>, "'open list'" <linux-kernel@vger.kernel.org>
References: <011d01cc19ff$616055c0$24210140$@org> <Pine.LNX.4.44L0.1105241012080.1913-100000@iolanthe.rowland.org> <013201cc1a96$bdda7910$398f6b30$@org> <20110525092124.GI14556@legolas.emea.dhcp.ti.com> <015801cc1abd$ca534e20$5ef9ea60$@org> <20110525092743.GK14556@legolas.emea.dhcp.ti.com> <018e01cc1ac0$2b09b040$811d10c0$@org> <20110525094902.GM14556@legolas.emea.dhcp.ti.com>
In-Reply-To: <20110525094902.GM14556@legolas.emea.dhcp.ti.com>
Subject: RE: [PATCH v12 7/8] usb: Adding SuperSpeed support to dummy_hcd
Date: Wed, 25 May 2011 13:03:00 +0300
Message-ID: <01a601cc1ac2$f0041a00$d00c4e00$@org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcwawPj4hlhX+V4sQyKMt7cMSbkRVAAAIsYQ
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

> >
> > No, I'm afraid we're talking about different things here.
> > As far as dummy_hcd is concerned:
> > Dummy_hcd has a new module parameter that should be set to true if
> the
> > developer wishes the gadget driver to be connected to a SS root hub.
> > Since at the moment most of the gadget drivers woun't work at SS
> > connection (lack of SS descriptors) the default of this parameter is
> > true and thus the connected gadget driver will be enumerated over a
> HS
> > root hub. Users don't have to remember t set anything in order to be
> > able to work with dummy_hcd and the existing gadget drivers just as
> they did up until now.
> >
> > We did add a new feature flag (CONFIG_USB_GADGET_SUPERSPEED) that is
> > set during compilation. If that flag is defined, then (and only
> then!)
> > will the
> > driver->speed be set to SS by composite_bind. Please keep in mind the
> 
> and that's the only thing I'm asking you to remove :-)

You want to remove the following change from in composite.c:

@@ -1386,6 +1604,9 @@ int usb_composite_probe(struct usb_composite_driver
*driver,
 		driver->iProduct = driver->name;
 	composite_driver.function =  (char *) driver->name;
 	composite_driver.driver.name = driver->name;
+#ifdef CONFIG_USB_GADGET_SUPERSPEED
+	composite_driver.speed = USB_SPEED_SUPER; #endif /* 
+CONFIG_USB_GADGET_SUPERSPEED */
 	composite = driver;
 	composite_gadget_bind = bind;

Right? I'm sorry, but I really don't understand why... :( Removing it is the
same as not defining CONFIG_USB_GADGET_SUPERSPEED.
And if we do remove it: suppose you do have a SS gadget driver you wish to
test now with dummy_hcd. For example the f_uasp we released. In order to be
able to do so, you'll have to add the above manually in your repository.
Otherwise even if the dummy_hcd module parameter is_super_speed=true - the
gadget will enumerate over HS root hub since the driver speed will remain
HS.


> 
> we should be to compile dummy_hcd in SuperSpeed and still have high-
> speed gadget drivers :-)

But this is the case right now. Or do you mean that you want to load (not
compile) the dummy_hcd with is_super_speed=1 and still be able to enumerate
HS gadgets?

> > following:
> > 1. if CONFIG_USB_GADGET_SUPERSPEED=true, existing gadget drivers are
> > still functional with dummy_hcd since as I already mentioned, they
> > will be enumerated through HS root hub and thus the gadget.speed will
> be set to HS.
> > This is true for all gadget drivers, including the once that don't
> > define SS descriptors.
> 
> only due the module parameter, right ?

Due to the module parameter default value being FALSE, yes.


Best regards,
Tanya Brokhman
Consultant for Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum






