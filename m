Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013Ab1KGFvR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 00:51:17 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43374 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483Ab1KGFvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 00:51:16 -0500
Date: Sun, 6 Nov 2011 21:51:09 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: KY Srinivasan <kys@microsoft.com>
Cc: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "joe@perches.com" <joe@perches.com>,
        "jkosina@suse.cz" <jkosina@suse.cz>
Subject: Re: [PATCH 1/1] Staging: hv: Move the mouse driver out of staging
Message-ID: <20111107055109.GA21095@core.coreip.homeip.net>
References: <1319841316-29136-1-git-send-email-kys@microsoft.com>
 <20111105064739.GA31111@core.coreip.homeip.net>
 <6E21E5352C11B742B20C142EB499E0481AA68580@TK5EX14MBXC128.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6E21E5352C11B742B20C142EB499E0481AA68580@TK5EX14MBXC128.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi K. Y,

On Mon, Nov 07, 2011 at 01:04:53AM +0000, KY Srinivasan wrote:
> 
> 
> > -----Original Message-----
> > From: Dmitry Torokhov [mailto:dmitry.torokhov@gmail.com]
> > Sent: Saturday, November 05, 2011 2:48 AM
> > To: KY Srinivasan
> > Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> > devel@linuxdriverproject.org; virtualization@lists.osdl.org; ohering@suse.com;
> > joe@perches.com; jkosina@suse.cz
> > Subject: Re: [PATCH 1/1] Staging: hv: Move the mouse driver out of staging
> > 
> > Hi KY,
> 
> Dimitry,
> 
> Let me begin by thanking you for taking the time to review. I have incorporated
> pretty much all your suggestions.

Thank you very much for considering my suggestions.

> > 
> > Instead of potentially ever-increasing buffer that you also allocate
> > (and it looks like leaking on every callback invocation) can you just
> > repeat the read if you know that there are more data and use single
> > pre-allocated buffer?
> 
> The ring-buffer protocol is such that we need to consume the full message.
> Also, why do you say we are leaking memory?

Ah, OK, I see, we keep reading until read returns 0-sized reply and then
we free the buffer... Never mind then.

> > > +
> > > +	hid_dev->ll_driver = &mousevsc_ll_driver;
> > > +	hid_dev->driver = &mousevsc_hid_driver;
> > 
> > You are not really hid driver; you are more of a "provider" so why do
> > you need to set hid_dev->driver in addition to hid_dev->ll_driver?
> > 
> True, but hid_parse_report() expects that the driver field be set; so I
> need to fake this.

If you supply .parse() method for your mousevsc_ll_driver structure and
call hid_parse_report() from it then HID core will set the default
driver and call parse at appropriate time.

>  
> > > +	hid_dev->bus = BUS_VIRTUAL;
> > > +	hid_dev->vendor = input_dev->hid_dev_info.vendor;
> > > +	hid_dev->product = input_dev->hid_dev_info.product;
> > > +	hid_dev->version = input_dev->hid_dev_info.version;
> > > +	input_dev->hid_device = hid_dev;
> > > +
> > > +	sprintf(hid_dev->name, "%s", "Microsoft Vmbus HID-compliant Mouse");
> > 
> > strlcpy?
> > 
> > > +
> > > +	ret = hid_parse_report(hid_dev, input_dev->report_desc,
> > > +				input_dev->report_desc_size);
> > > +
> > > +	if (ret) {
> > > +		hid_err(hid_dev, "parse failed\n");
> > > +		goto probe_err1;
> > > +	}
> > > +
> > > +	ret = hid_hw_start(hid_dev, HID_CONNECT_HIDINPUT |
> > HID_CONNECT_HIDDEV);
> > 
> > Why do you need to call hid_hw_start instead of letting HID core figure
> > it out for you?
> 
> I am not a hid expert; but all  hid low level drivers appear to do this.
> Initially, I was directly invoking hid_connect() directly and based on your
> Input, I chose to use hid_hw_start() which all other drivers are using.

Note that the users of hid_hw_start() actually are not low level
drivers, such as usbhid or bluetooth hidp, but higher-level drivers,
such as hid-wacom, hid-a4tech, etc. Since your driver is a low-level
driver (a provider so to speak) it should not call hid_hw_start() on its
own but rather wait for the hid code to do it.

Still, I am not a HID expert either so I'll defer to Jiri here.

Thanks.

-- 
Dmitry
