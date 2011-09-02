Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877Ab1IBUyj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 16:54:39 -0400
Received: from mailb.microsoft.com ([131.107.115.215]:34798 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755552Ab1IBUyj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 16:54:39 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <greg@kroah.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: RE: Hyper-V TODO file
Thread-Topic: Hyper-V TODO file
Thread-Index: AQHMaOYedebhsNSnAEe3RY7o1REvPJU5b4mAgAEL7sCAAH1ZgP//mijA
Date: Fri, 2 Sep 2011 20:54:37 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E048081C7981@TK5EX14MBXC126.redmond.corp.microsoft.com>
References: <1314829011-28922-1-git-send-email-kys@microsoft.com>
 <20110901202733.GA15185@kroah.com> <20110901203031.GB15185@kroah.com>
 <6E21E5352C11B742B20C142EB499E048081C595A@TK5EX14MBXC126.redmond.corp.microsoft.com>
 <20110902195807.GA2339@kroah.com>
In-Reply-To: <20110902195807.GA2339@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.22]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:greg@kroah.com]
> Sent: Friday, September 02, 2011 3:58 PM
> To: KY Srinivasan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org
> Subject: Re: Hyper-V TODO file
> 
> On Fri, Sep 02, 2011 at 07:47:12PM +0000, KY Srinivasan wrote:
> >
> >
> > > -----Original Message-----
> > > From: Greg KH [mailto:greg@kroah.com]
> > > Sent: Thursday, September 01, 2011 4:31 PM
> > > To: KY Srinivasan
> > > Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> > > devel@linuxdriverproject.org; virtualization@lists.osdl.org
> > > Subject: Re: Hyper-V TODO file
> > >
> > > On Thu, Sep 01, 2011 at 01:27:33PM -0700, Greg KH wrote:
> > > > On Wed, Aug 31, 2011 at 03:16:51PM -0700, K. Y. Srinivasan wrote:
> > > > > 2) With your help, we have fixed all of the issues related to these drivers
> > > > > conforming to the Linux Device Driver model. One of the TODO work
> items is
> > > > > "audit the vmbus to verify it is working properly with the driver model".
> > > >
> > > > I have a few comments about this, I'll respond in another email.
> > >
> > > Ok, it looks a _lot_ better, but I have a few minor nits, and one larger
> > > one:
> > >
> > > - rename the vmbus_child_* functions to vmbus_* as there's no need to
> > >   think of "children" here.
> > >
> > > - vmbus_onoffer comment is incorrect.  You handle offers from lots of
> > >   other types.  Or if not, am I reading the code incorrectly?
> > >
> > > - the static hv_cb_utils array needs to go away.  In the hv_utils.c
> > >   util_probe() call, properly register the channel callback, and the
> > >   same goes for the util_remove() call, unregister things there.
> > >   Note, you can use the driver_data field to determine exactly which
> > >   callback needs to be registered to make things easy.  Something like
> > >   the following (pseudo code only):
> > >
> > > static const struct hv_vmbus_device_id id_table[] = {
> > > 	/* Shutdown guid */
> > > 	{ VMBUS_DEVICE(0x31, 0x60, 0x0B, 0X0E, 0x13, 0x52, 0x34, 0x49,
> > > 		       0x81, 0x8B, 0x38, 0XD9, 0x0C, 0xED, 0x39, 0xDB),
> > > 	  .driver_data = &shutdown_onchannelcallback },
> > > 	....
> > > };
> > >
> > > util_probe(struct hv_device *dev, const struct hv_vmbus_device_id *id)
> > >  [ Yes, you will have to change the probe callback signature, but that's fine. ]
> >
> > Greg, I think if I understand you correctly, the id parameter to the probe
> function
> > would be pointing to relevant entry in the hv_vmbus_device_id array.
> 
> Yes, just like it does for USB, PCI, etc.
> 
> > Since the driver can handle multiple ids (guids), we need to either in
> > the driver specific probe function or in the bus specific probe
> > function,  figure out which of the many devices the driver supports is
> > being probed. I have couple of implementation options and would
> > appreciate your preference:
> >
> > 1) Do the guid parsing at the vmbus level parsing function. If I go
> > this route, the driver specific probe function would get an extra
> > parameter as you have described in pseudo code.
> 
> Yes, that's the proper way to do this, as your match function already
> found the proper id structure, so you have the pointer, just pass it to
> the probe function callback.
> 
> > 2) Do the guid parsing in the util probe function. In this case, we
> > don't need to change the signature for the probe function as all the
> > id information is available in the (util) driver.
> 
> Yes, but you end up doing the matching all over again in the util
> driver, which isn't nice and ripe for duplication and bugs.
> 
> > I personally would prefer the second approach since it does not affect
> > other drivers (no need to change the signature for the probe
> > function). Let me know how you want me to proceed here.
> 
> As you only have 3 probe functions, it's not a big deal to change them
> all :)

Ok; will do. I am glad I checked with you!

Regards,

K. Y

