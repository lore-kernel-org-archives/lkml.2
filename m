Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757777Ab1DZR0I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 13:26:08 -0400
Received: from mga02.intel.com ([134.134.136.20]:19417 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754000Ab1DZR0H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 13:26:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,269,1301900400"; 
   d="scan'208";a="738670456"
Date: Tue, 26 Apr 2011 10:25:59 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Tanya Brokhman <tlinder@codeaurora.org>
Cc: gregkh@suse.de, linux-arm-msm@vger.kernel.org, ablay@codeaurora.org,
        balbi@ti.com,
        "'open list:USB GADGET/PERIPH...'" <linux-usb@vger.kernel.org>,
        "'open list'" <linux-kernel@vger.kernel.org>,
        "'Matthew Wilcox'" <matthew.r.wilcox@intel.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC/PATCH v3 2/5] uas: MS UAS Gadget driver - Infrastructure
Message-ID: <20110426172559.GA5405@xanatos>
References: <1302788176-27972-1-git-send-email-tlinder@codeaurora.org>
 <20110418193722.GB7194@xanatos>
 <003601cc03f0$70a1d470$51e57d50$@org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <003601cc03f0$70a1d470$51e57d50$@org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 12:00:46PM +0300, Tanya Brokhman wrote:
> Our idea was that UAS supporting devices register with 2 configurations (not
> a second alternate setting to the MS interface). Upon enumeration the host
> will choose the operational mode/protocol (BOT/UAS) by choosing the
> configuration it wishes to operate in. As a first development phase it was
> easier for us to register only 1 configuration and that's why we added the
> module parameter. We're now working on removing this hack and registering 2
> configurations the host can choose from. From what I saw in the host side
> implementation the host always prefers the first configuration so right now
> we set the UAS config from user-space via sysfs.
> 
> I looked into USB-IF UAS compliance test document and you're right. There is
> something that mentions "Configuration Descriptor shall report B NUM
> INTERFACES > 0". Unfortunately in our version of the file this is the only
> reference I found for this demand so I need to look into that and get more
> details.

Ok, I'll double check with the people I know from the compliance team.
I remember the requirement from the discussion of the UAS compliance
test on the USB-IF website.  Do you have access to the UAS workgroup?

> In the meanwhile: will this work with the existing UAS driver
> implementation? How will I be able to "force" the host to choose the UAS
> protocol? I can compile just cdc_ncm but I prefer to have my host support
> both UAS and BOT and be able to choose. As mentioned before, at the moment I
> achieved that by manually setting the device configuration to UAS from user
> space.

Unfortunately, Linux will choose the first configuration and bind
whatever driver that matches that configuration to the device.  So if
the BOT configuration is configuration 1, then the BOT driver will be
loaded.  Same with alternate interface settings.  Alternate interface 0
will always be chosen first during enumeration.

We need a way to switch the UAS device from the BOT driver to the UAS
driver, but I'm not sure how to do that.  I think Alan might have had
some ideas?

> > Why not a thread per SCSI command TAG (i.e. per stream ID)?  I think
> > that most USB storage devices only have one LUN.  You would get better
> > performance if you could, say, kick off several READ commands for the
> > same LUN when you receive two separate SCSI commands on different
> > stream
> > IDs.
> 
> I wasn't aware of the "one LUN" issue. I'm afraid that creating a thread per
> SCSI command won't be that efficient because we will spend too much CPU on
> 1. creating/killing the thread
> 2. context switch between the threads
> Perhaps the better solution will be the combination of the two approaches:
> create X threads that will handle the received SCSI commands. 
> This way X can be a maximum between number of LUNS and some max_threads_val
> we decide on. 
> How does this sound?

Sure, that sounds like the right direction.  You can choose how many
threads you want to support (X), and then set the bMaxStreams value in
the descriptor to that value.  That way the host will only queue X
number of SCSI commands, and use X number of stream IDs, and each thread
can handle one SCSI command.  Or if you want each thread to be able to
handle C number of commands, you could set bMaxStreams value to C*X.

Right now the UAS driver attempts to allocate 65536 streams (which
translates to allowing the SCSI core to submit up to 65536 commands
asynchronously), but the xHCI driver will only let it allocate the
minimum number of streams that each of the three endpoints advertise.
Probably the UAS driver needs to update the .can_queue value for the
SCSI host after looking at the device descriptors.  I'm not sure if that
means the SCSI core can submit up to .can_queue commands for each LUN,
or up to .can_queue commands for all LUNs.

Sarah Sahrp
