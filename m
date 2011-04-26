Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693Ab1DZI7c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 04:59:32 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:24846 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752533Ab1DZI73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 04:59:29 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6327"; a="87644231"
From: "Tanya Brokhman" <tlinder@codeaurora.org>
To: "'Sarah Sharp'" <sarah.a.sharp@linux.intel.com>
Cc: <gregkh@suse.de>, <linux-arm-msm@vger.kernel.org>, <ablay@codeaurora.org>,
        <balbi@ti.com>,
        "'open list:USB GADGET/PERIPH...'" <linux-usb@vger.kernel.org>,
        "'open list'" <linux-kernel@vger.kernel.org>,
        "'Matthew Wilcox'" <matthew.r.wilcox@intel.com>
References: <1302788176-27972-1-git-send-email-tlinder@codeaurora.org> <20110418193722.GB7194@xanatos>
In-Reply-To: <20110418193722.GB7194@xanatos>
Subject: RE: [RFC/PATCH v3 2/5] uas: MS UAS Gadget driver - Infrastructure
Date: Tue, 26 Apr 2011 12:00:46 +0300
Message-ID: <003601cc03f0$70a1d470$51e57d50$@org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Acv+AAUlts58O9/pQHOyfe36luFNpwF60vUg
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sarah

> On Thu, Apr 14, 2011 at 04:36:15PM +0300, Tatyana Brokhman wrote:
> > This patch implements the infrastructure for the UAS gadget driver.
> > The UAS gadget driver registers as a second configuration of the MS
> > gadet driver.
> >
> > A new module parameter was added to the mass_storage module:
> > bool use_uasp. (default = 0)
> > If this parameter is set to true, the mass_storage module will
> register
> > with the UAS configuration as the devices first configuration and
> > operate according to the UAS protocol.
> 
> I'm a bit confused by this statement.  Do you mean the UAS alternate
> interface setting, rather than the UAS configuration?  I thought that
> UAS devices would have one configuration with two alternate interface
> settings: a bulk-only-transport interface, and a UAS interface.
> 
> Wasn't there a requirement in the USB-IF UAS compliance test that UAS
> devices have the UAS alternate interface setting as the second
> alternate
> interface setting, to make sure OSes without UAS support would still be
> able to operate with the device?  Is that what you're doing in these
> patches?

Our idea was that UAS supporting devices register with 2 configurations (not
a second alternate setting to the MS interface). Upon enumeration the host
will choose the operational mode/protocol (BOT/UAS) by choosing the
configuration it wishes to operate in. As a first development phase it was
easier for us to register only 1 configuration and that's why we added the
module parameter. We're now working on removing this hack and registering 2
configurations the host can choose from. From what I saw in the host side
implementation the host always prefers the first configuration so right now
we set the UAS config from user-space via sysfs.

I looked into USB-IF UAS compliance test document and you're right. There is
something that mentions "Configuration Descriptor shall report B NUM
INTERFACES > 0". Unfortunately in our version of the file this is the only
reference I found for this demand so I need to look into that and get more
details.
In the meanwhile: will this work with the existing UAS driver
implementation? How will I be able to "force" the host to choose the UAS
protocol? I can compile just cdc_ncm but I prefer to have my host support
both UAS and BOT and be able to choose. As mentioned before, at the moment I
achieved that by manually setting the device configuration to UAS from user
space.


> 
> The other comment I saw was that you chose to run a thread per LUN:
> 
> > + * Several kernel threads are created as part of the init sequence:
> > + * - UASP main thread
> > + * - A thread for each of the existing LUNs
> > + * The UASP main thread handles all of the generic commands/task
> > + * management requests and routes LUN specific requests to be
> handled by
> > + * the appropriate LUNs task.
> > + * The approach of "task per LUN" was chosen due to the UAS protocol
> > + * enhancement over the BOT protocol. The main retouch of the UAS
> > + * protocol of the BOT protocol is the fact that independent
> commands can
> > + * be performed in parallel. For example a READ command for two
> different
> > + * LUNS. Thus in order to implement this concurrency a separate
> thread is
> > + * needed for each of the existing LUNS.
> > + * As long as the LUN threads are alive they keep an open reference
> to the
> > + * backing file. This prevents the unmounting of the backing file's
> > + * underlying file system and cause problems during system shutdown.
> 
> Why not a thread per SCSI command TAG (i.e. per stream ID)?  I think
> that most USB storage devices only have one LUN.  You would get better
> performance if you could, say, kick off several READ commands for the
> same LUN when you receive two separate SCSI commands on different
> stream
> IDs.

I wasn't aware of the "one LUN" issue. I'm afraid that creating a thread per
SCSI command won't be that efficient because we will spend too much CPU on
1. creating/killing the thread
2. context switch between the threads
Perhaps the better solution will be the combination of the two approaches:
create X threads that will handle the received SCSI commands. 
This way X can be a maximum between number of LUNS and some max_threads_val
we decide on. 
How does this sound?


Best regards,
Tanya Brokhman
Consultant for Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum




