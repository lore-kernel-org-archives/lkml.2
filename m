Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933400Ab1KIApd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 19:45:33 -0500
Received: from smtp.microsoft.com ([131.107.115.214]:27717 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752587Ab1KIApc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 19:45:32 -0500
From: KY Srinivasan <kys@microsoft.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "joe@perches.com" <joe@perches.com>,
        "jkosina@suse.cz" <jkosina@suse.cz>
Subject: RE: [PATCH 1/1] Staging: hv: Move the mouse driver out of staging
Thread-Topic: [PATCH 1/1] Staging: hv: Move the mouse driver out of staging
Thread-Index: AQHMlb5tFmjUXJbXLkiQVEJ5ygNb75WeV3qAgAJF/pCAAN+mgIACQ0RA
Date: Wed, 9 Nov 2011 00:45:30 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0481AA69FD0@TK5EX14MBXC128.redmond.corp.microsoft.com>
References: <1319841316-29136-1-git-send-email-kys@microsoft.com>
 <20111105064739.GA31111@core.coreip.homeip.net>
 <6E21E5352C11B742B20C142EB499E0481AA68580@TK5EX14MBXC128.redmond.corp.microsoft.com>
 <20111107055109.GA21095@core.coreip.homeip.net>
In-Reply-To: <20111107055109.GA21095@core.coreip.homeip.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.79]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Dmitry Torokhov [mailto:dmitry.torokhov@gmail.com]
> Sent: Monday, November 07, 2011 12:51 AM
> To: KY Srinivasan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org; ohering@suse.com;
> joe@perches.com; jkosina@suse.cz
> Subject: Re: [PATCH 1/1] Staging: hv: Move the mouse driver out of staging
> 
> Hi K. Y,
> 
> On Mon, Nov 07, 2011 at 01:04:53AM +0000, KY Srinivasan wrote:
> >
> >
> > > -----Original Message-----
> > > From: Dmitry Torokhov [mailto:dmitry.torokhov@gmail.com]
> > > Sent: Saturday, November 05, 2011 2:48 AM
> > > To: KY Srinivasan
> > > Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> > > devel@linuxdriverproject.org; virtualization@lists.osdl.org;
> ohering@suse.com;
> > > joe@perches.com; jkosina@suse.cz
> > > Subject: Re: [PATCH 1/1] Staging: hv: Move the mouse driver out of staging
> > >
> > > Hi KY,
> >
> > Dimitry,
> >
> > Let me begin by thanking you for taking the time to review. I have incorporated
> > pretty much all your suggestions.
> 
> Thank you very much for considering my suggestions.

> 
> > >
> > > Instead of potentially ever-increasing buffer that you also allocate
> > > (and it looks like leaking on every callback invocation) can you just
> > > repeat the read if you know that there are more data and use single
> > > pre-allocated buffer?
> >
> > The ring-buffer protocol is such that we need to consume the full message.
> > Also, why do you say we are leaking memory?
> 
> Ah, OK, I see, we keep reading until read returns 0-sized reply and then
> we free the buffer... Never mind then.
> 
> > > > +
> > > > +	hid_dev->ll_driver = &mousevsc_ll_driver;
> > > > +	hid_dev->driver = &mousevsc_hid_driver;
> > >
> > > You are not really hid driver; you are more of a "provider" so why do
> > > you need to set hid_dev->driver in addition to hid_dev->ll_driver?
> > >
> > True, but hid_parse_report() expects that the driver field be set; so I
> > need to fake this.
> 
> If you supply .parse() method for your mousevsc_ll_driver structure and
> call hid_parse_report() from it then HID core will set the default
> driver and call parse at appropriate time.

Would it be ok if I were to make this change after Jiri accepts the driver out of staging?

> 
> >
> > > > +	hid_dev->bus = BUS_VIRTUAL;
> > > > +	hid_dev->vendor = input_dev->hid_dev_info.vendor;
> > > > +	hid_dev->product = input_dev->hid_dev_info.product;
> > > > +	hid_dev->version = input_dev->hid_dev_info.version;
> > > > +	input_dev->hid_device = hid_dev;
> > > > +
> > > > +	sprintf(hid_dev->name, "%s", "Microsoft Vmbus HID-compliant Mouse");
> > >
> > > strlcpy?
> > >
> > > > +
> > > > +	ret = hid_parse_report(hid_dev, input_dev->report_desc,
> > > > +				input_dev->report_desc_size);
> > > > +
> > > > +	if (ret) {
> > > > +		hid_err(hid_dev, "parse failed\n");
> > > > +		goto probe_err1;
> > > > +	}
> > > > +
> > > > +	ret = hid_hw_start(hid_dev, HID_CONNECT_HIDINPUT |
> > > HID_CONNECT_HIDDEV);
> > >
> > > Why do you need to call hid_hw_start instead of letting HID core figure
> > > it out for you?
> >
> > I am not a hid expert; but all  hid low level drivers appear to do this.
> > Initially, I was directly invoking hid_connect() directly and based on your
> > Input, I chose to use hid_hw_start() which all other drivers are using.
> 
> Note that the users of hid_hw_start() actually are not low level
> drivers, such as usbhid or bluetooth hidp, but higher-level drivers,
> such as hid-wacom, hid-a4tech, etc. Since your driver is a low-level
> driver (a provider so to speak) it should not call hid_hw_start() on its
> own but rather wait for the hid code to do it.
> 
> Still, I am not a HID expert either so I'll defer to Jiri here.

I look forward to Jiri's ruling here. On a different note, you had asked me to
make a couple of structures const structures that were statically initialized - the 
ack structure and the request structure. I am running into some issues doing that.
The low level ring buffer code uses  struct scatterlists and  for some reason the behavior 
of dynamically allocated structures (as well as stack variables) is different when it comes to
the following transformation: VA ->Page->VA. For dynamically allocated data this transformation
gives us the original VA; while for module global data, this transformation gives me a different VA.
And so, after I made the change you had recommended (making the two variables static variables),
the driver does not work and I have tracked this problem to the transformation noted earlier. Is this 
transformation not valid for static data? 

If it is ok with you, I will send the patch out with all the other cleanup that you had suggested.

Regards,

K. Y

