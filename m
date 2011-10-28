Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755779Ab1J1U2N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 16:28:13 -0400
Received: from mailc.microsoft.com ([131.107.115.214]:27312 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497Ab1J1U2M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 16:28:12 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <gregkh@suse.de>
CC: Jiri Kosina <jkosina@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        "ohering@suse.com" <ohering@suse.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: RE: [PATCH 1/1] Staging: hv: Move the mouse driver out of staging
Thread-Topic: [PATCH 1/1] Staging: hv: Move the mouse driver out of staging
Thread-Index: AQHMk/Yfbv94uVs6kUmFh5QHJPmlm5WSkYKA//+MPrCAAIjtgP//i45Q
Date: Fri, 28 Oct 2011 20:28:11 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0481AA53219@TK5EX14MBXC122.redmond.corp.microsoft.com>
References: <1319645321-9770-1-git-send-email-kys@microsoft.com>
 <alpine.LNX.2.00.1110282026360.3541@pobox.suse.cz>
 <6E21E5352C11B742B20C142EB499E0481AA531D4@TK5EX14MBXC122.redmond.corp.microsoft.com>
 <20111028200315.GA30918@suse.de>
In-Reply-To: <20111028200315.GA30918@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.34]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:gregkh@suse.de]
> Sent: Friday, October 28, 2011 4:03 PM
> To: KY Srinivasan
> Cc: Jiri Kosina; linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> virtualization@lists.osdl.org; ohering@suse.com; Dmitry Torokhov
> Subject: Re: [PATCH 1/1] Staging: hv: Move the mouse driver out of staging
> 
> On Fri, Oct 28, 2011 at 07:50:59PM +0000, KY Srinivasan wrote:
> > > >  obj-$(CONFIG_HID_WACOM)		+= hid-wacom.o
> > > >  obj-$(CONFIG_HID_WALTOP)	+= hid-waltop.o
> > > >  obj-$(CONFIG_HID_WIIMOTE)	+= hid-wiimote.o
> > > > +obj-$(CONFIG_HYPERV_MOUSE)	+= hv_mouse.o
> > >
> > > I'd prefer a bit to follow the current naming of the drivers in
> > > drivers/hid directory ... all the device-specific (vendor-specific)
> > > drivers currently are called hid-<vendor> or similar.
> > >
> > > We could talk about changing this naming scheme, but before we reach any
> > > conclusion on this, I'd prefer this to stay for all drivers if possible.
> >
> > Do you want the driver module to conform to the naming scheme you have?
> > Greg, in the past has resisted changing driver names, but I have no objection
> > to conforming to the naming convention you have.
> 
> I recommend following the proper naming scheme.  As this driver is
> auto-loaded when the virtual hardware is seen, the name really doesn't
> matter at all.
> 
> So, how about 'hid-hyperv' or 'hid-hv'?

I will go with hid-hv  if there are no objections.
> 
> > > > +	switch (hid_msg->header.type) {
> > > > +	case SYNTH_HID_PROTOCOL_RESPONSE:
> > > > +		memcpy(&input_dev->protocol_resp, pipe_msg,
> > > > +		       pipe_msg->size + sizeof(struct pipe_prt_msg) -
> > > > +		       sizeof(unsigned char));
> > >
> > > Is there any guarantee anywhere that packet doesn't get corrupted (either
> > > maliciously or not)?
> > >
> > > Seems to me like we are taking it 'raw' in mousevsc_on_channel_callback()
> > > without any sanity checking.
> > >
> > > If not, second argument of this memcpy() could easily overflow, causing
> > > quite some memory corruption, right?
> > >
> > > Actually the question of sanity of the raw packet is much more general one
> > > throughout this driver. I am not very familiar with things in drivers/hv,
> > > hence the question.
> >
> > The guest cannot survive a malicious host; so I think it is safe to say that the
> > guest can assume the host is following the protocol.
> 
> That's not good for a very large number of reasons, not the least being
> that we have no idea how secure the hyperv hypervisor is, so making it
> so that there isn't an obvious hole into linux through it, would be a
> good idea.
> 
> And yes, I'd say the same thing if this was a KVM or Xen driver as well.
> Please be very defensive in this area of the code, especially as there
> are no performance issues here.

In the chain of trust, the hypervisor and the host are the foundations
as far as the guest is concerned, since both the hypervisor and the host
can affect the guest in ways that the guest has no obvious way to protect itself.
If the hypervisor/host have security holes, there is not much you can do in the guest
to deal with it. 
In this case, I can add checks but I am not sure how useful it is.

> 
> > > > +				return;
> > > > +			}
> > > > +			break;
> > > > +		}
> > > > +	} while (1);
> > >
> > > Again, not being familiar with 'hv' infrastructure at all, this inifite
> > > loop makes me to ask -- in what context does it run? Why do we need it?
> > >
> > > It seems to me that it's some kind of infinite loop for event-driven
> > > programming, which is not something we do in kernel (outside of kernel
> > > threads, perhaps, with very careful handling).
> >
> > This loop is invoked in a tasklet context. The agreed upon protocol between the
> > guest and the host is that the consumer of a ring buffer (in this case the guest)
> will
> > process all available data before returning. This permits signaling optimizations
> between
> > the producer and the consumer. For instance, if the consumer is still active as
> seen by the
> > producer (based on the read index seen by the producer), as the producer
> enqueues additional
> > data, the producer does not have to signal the consumer.
> 
> That's great, but again, be defensive and at least have a "time out"
> way to get out of this loop in case something goes wrong.  It will be
> triggered some day, by someone, I guarantee it.

I am not sure what you are recommending here Greg; the host mandates that
we exit this loop only when there is nothing more to be read; that exit path is in the
current code. If we exit this code for any other reason (such as based on a timeout)
we will not be awakened by the host when in fact there is data to be read.

Regards,

K. Y 

