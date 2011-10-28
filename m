Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933280Ab1J1UDa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 16:03:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34846 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932387Ab1J1UD3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 16:03:29 -0400
Date: Fri, 28 Oct 2011 22:03:15 +0200
From: Greg KH <gregkh@suse.de>
To: KY Srinivasan <kys@microsoft.com>
Cc: Jiri Kosina <jkosina@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        "ohering@suse.com" <ohering@suse.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH 1/1] Staging: hv: Move the mouse driver out of staging
Message-ID: <20111028200315.GA30918@suse.de>
References: <1319645321-9770-1-git-send-email-kys@microsoft.com>
 <alpine.LNX.2.00.1110282026360.3541@pobox.suse.cz>
 <6E21E5352C11B742B20C142EB499E0481AA531D4@TK5EX14MBXC122.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6E21E5352C11B742B20C142EB499E0481AA531D4@TK5EX14MBXC122.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 28, 2011 at 07:50:59PM +0000, KY Srinivasan wrote:
> > >  obj-$(CONFIG_HID_WACOM)		+= hid-wacom.o
> > >  obj-$(CONFIG_HID_WALTOP)	+= hid-waltop.o
> > >  obj-$(CONFIG_HID_WIIMOTE)	+= hid-wiimote.o
> > > +obj-$(CONFIG_HYPERV_MOUSE)	+= hv_mouse.o
> > 
> > I'd prefer a bit to follow the current naming of the drivers in
> > drivers/hid directory ... all the device-specific (vendor-specific)
> > drivers currently are called hid-<vendor> or similar.
> > 
> > We could talk about changing this naming scheme, but before we reach any
> > conclusion on this, I'd prefer this to stay for all drivers if possible.
> 
> Do you want the driver module to conform to the naming scheme you have?
> Greg, in the past has resisted changing driver names, but I have no objection 
> to conforming to the naming convention you have.

I recommend following the proper naming scheme.  As this driver is
auto-loaded when the virtual hardware is seen, the name really doesn't
matter at all.

So, how about 'hid-hyperv' or 'hid-hv'?

> > > +	switch (hid_msg->header.type) {
> > > +	case SYNTH_HID_PROTOCOL_RESPONSE:
> > > +		memcpy(&input_dev->protocol_resp, pipe_msg,
> > > +		       pipe_msg->size + sizeof(struct pipe_prt_msg) -
> > > +		       sizeof(unsigned char));
> > 
> > Is there any guarantee anywhere that packet doesn't get corrupted (either
> > maliciously or not)?
> > 
> > Seems to me like we are taking it 'raw' in mousevsc_on_channel_callback()
> > without any sanity checking.
> > 
> > If not, second argument of this memcpy() could easily overflow, causing
> > quite some memory corruption, right?
> > 
> > Actually the question of sanity of the raw packet is much more general one
> > throughout this driver. I am not very familiar with things in drivers/hv,
> > hence the question.
> 
> The guest cannot survive a malicious host; so I think it is safe to say that the 
> guest can assume the host is following the protocol.

That's not good for a very large number of reasons, not the least being
that we have no idea how secure the hyperv hypervisor is, so making it
so that there isn't an obvious hole into linux through it, would be a
good idea.

And yes, I'd say the same thing if this was a KVM or Xen driver as well.
Please be very defensive in this area of the code, especially as there
are no performance issues here.

> > > +				return;
> > > +			}
> > > +			break;
> > > +		}
> > > +	} while (1);
> > 
> > Again, not being familiar with 'hv' infrastructure at all, this inifite
> > loop makes me to ask -- in what context does it run? Why do we need it?
> > 
> > It seems to me that it's some kind of infinite loop for event-driven
> > programming, which is not something we do in kernel (outside of kernel
> > threads, perhaps, with very careful handling).
> 
> This loop is invoked in a tasklet context. The agreed upon protocol between the
> guest and the host is that the consumer of a ring buffer (in this case the guest) will
> process all available data before returning. This permits signaling optimizations between
> the producer and the consumer. For instance, if the consumer is still active as seen by the 
> producer (based on the read index seen by the producer), as the producer enqueues additional
> data, the producer does not have to signal the consumer.

That's great, but again, be defensive and at least have a "time out"
way to get out of this loop in case something goes wrong.  It will be
triggered some day, by someone, I guarantee it.

thanks,

greg k-h
