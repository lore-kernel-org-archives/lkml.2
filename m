Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625Ab1DZSlA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 14:41:00 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:59130 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752134Ab1DZSk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 14:40:59 -0400
Date: Tue, 26 Apr 2011 14:40:58 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
cc: Tanya Brokhman <tlinder@codeaurora.org>, <gregkh@suse.de>,
        <linux-arm-msm@vger.kernel.org>, <ablay@codeaurora.org>,
        <balbi@ti.com>, USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        "'Matthew Wilcox'" <matthew.r.wilcox@intel.com>
Subject: Re: [RFC/PATCH v3 2/5] uas: MS UAS Gadget driver - Infrastructure
In-Reply-To: <20110426172559.GA5405@xanatos>
Message-ID: <Pine.LNX.4.44L0.1104261423250.2035-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Apr 2011, Sarah Sharp wrote:

> On Tue, Apr 26, 2011 at 12:00:46PM +0300, Tanya Brokhman wrote:
> > Our idea was that UAS supporting devices register with 2 configurations (not
> > a second alternate setting to the MS interface). Upon enumeration the host
> > will choose the operational mode/protocol (BOT/UAS) by choosing the
> > configuration it wishes to operate in. As a first development phase it was
> > easier for us to register only 1 configuration and that's why we added the
> > module parameter. We're now working on removing this hack and registering 2
> > configurations the host can choose from. From what I saw in the host side
> > implementation the host always prefers the first configuration so right now
> > we set the UAS config from user-space via sysfs.
> > 
> > I looked into USB-IF UAS compliance test document and you're right. There is
> > something that mentions "Configuration Descriptor shall report B NUM
> > INTERFACES > 0". Unfortunately in our version of the file this is the only
> > reference I found for this demand so I need to look into that and get more
> > details.
> 
> Ok, I'll double check with the people I know from the compliance team.
> I remember the requirement from the discussion of the UAS compliance
> test on the USB-IF website.  Do you have access to the UAS workgroup?

For what it's worth, my old copy of the UAS spec (working draft Rev. 2) 
says nothing about this one way or another.  Evidently it was thought 
that vendors would implement dual-protocol support any way they wanted.

> > In the meanwhile: will this work with the existing UAS driver
> > implementation? How will I be able to "force" the host to choose the UAS
> > protocol? I can compile just cdc_ncm but I prefer to have my host support
> > both UAS and BOT and be able to choose. As mentioned before, at the moment I
> > achieved that by manually setting the device configuration to UAS from user
> > space.
> 
> Unfortunately, Linux will choose the first configuration and bind
> whatever driver that matches that configuration to the device.  So if
> the BOT configuration is configuration 1, then the BOT driver will be
> loaded.  Same with alternate interface settings.  Alternate interface 0
> will always be chosen first during enumeration.

The part about configurations is right, but the part about altsettings
is wrong.  The USB core does not choose altsettings; drivers do.  The
driver that binds to an interface will select whichever altsetting it
wants.

> We need a way to switch the UAS device from the BOT driver to the UAS
> driver, but I'm not sure how to do that.  I think Alan might have had
> some ideas?

One can always unbind usb-storage from an interface and bind uas to
that interface by hand, using sysfs.  At the moment there doesn't 
appear to be any mechanism for doing this automatically.  For example, 
usb-storage _could_ choose not to bind to an interface if there's a UAS 
altsetting -- but currently it doesn't take that into account.

Which reminds me...  Fallbacks are always a good idea.  If usb-storage 
did decide not to bind to combined BOT/UAS devices, we should have a 
mechanism for overriding this choice (i.e., forcing usb-storage to bind 
regardless).

Likewise, Sarah, you should consider adding a mechanism to xhci-hcd for 
forcing individual root-hub ports not to run at SuperSpeed (rather like 
the "companion" attribute file in ehci-hcd, although I'm sure you can 
come up with a better name).

> > > Why not a thread per SCSI command TAG (i.e. per stream ID)?  I think
> > > that most USB storage devices only have one LUN.  You would get better
> > > performance if you could, say, kick off several READ commands for the
> > > same LUN when you receive two separate SCSI commands on different
> > > stream
> > > IDs.
> > 
> > I wasn't aware of the "one LUN" issue. I'm afraid that creating a thread per
> > SCSI command won't be that efficient because we will spend too much CPU on
> > 1. creating/killing the thread
> > 2. context switch between the threads
> > Perhaps the better solution will be the combination of the two approaches:
> > create X threads that will handle the received SCSI commands. 
> > This way X can be a maximum between number of LUNS and some max_threads_val
> > we decide on. 
> > How does this sound?
> 
> Sure, that sounds like the right direction.  You can choose how many
> threads you want to support (X), and then set the bMaxStreams value in
> the descriptor to that value.  That way the host will only queue X
> number of SCSI commands, and use X number of stream IDs, and each thread
> can handle one SCSI command.  Or if you want each thread to be able to
> handle C number of commands, you could set bMaxStreams value to C*X.
> 
> Right now the UAS driver attempts to allocate 65536 streams (which
> translates to allowing the SCSI core to submit up to 65536 commands
> asynchronously), but the xHCI driver will only let it allocate the
> minimum number of streams that each of the three endpoints advertise.
> Probably the UAS driver needs to update the .can_queue value for the
> SCSI host after looking at the device descriptors.  I'm not sure if that
> means the SCSI core can submit up to .can_queue commands for each LUN,
> or up to .can_queue commands for all LUNs.

For all LUNs.

Since Tanya is writing the gadget driver, she gets to decide how many 
streams it will support (limited by the device controller hardware).  
In this setting I would use one thread per stream, since a thread can't 
have more than one VFS read or write request outstanding at any time.

Except that, as Christoph has mentioned a few times, it would be better 
to abandon this driver design entirely and use the SCSI Target 
framework instead.  Then presumably threads would not be an issue.

Alan Stern

