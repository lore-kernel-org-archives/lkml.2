Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932610Ab2FGRnu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 13:43:50 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:41046 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932414Ab2FGRns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 13:43:48 -0400
Subject: Re: [PATCH] Disable Bus Master on PCI device shutdown
From: Khalid Aziz <khalid.aziz@hp.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
        bhelgaas@google.com, linux-pci@vger.kernel.org
In-Reply-To: <20120606200946.GA11946@srcf.ucam.org>
References: <20120427190033.GA17588@ldl.usa.hp.com>
	 <20120606135009.GB1517@srcf.ucam.org> <1338999463.25761.630.camel@lyra>
	 <20120606162703.GA6779@srcf.ucam.org> <1339003956.25761.667.camel@lyra>
	 <20120606174202.GA8750@srcf.ucam.org> <1339006060.25761.689.camel@lyra>
	 <87obowxm5s.fsf@xmission.com>  <20120606200946.GA11946@srcf.ucam.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Jun 2012 11:43:44 -0600
Message-ID: <1339091024.25761.896.camel@lyra>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-06 at 21:09 +0100, Matthew Garrett wrote:
> On Wed, Jun 06, 2012 at 12:42:07PM -0700, Eric W. Biederman wrote:
> 
> > pci_device_shutdown calls drv->shutdown before calling
> > pci_device_disable.  Which means that only devices that have trouble
> > with this bit being flipped while DMA is ongoing and don't bother
> > to stop their own DMA will have a problem.
> 
> drv->shutdown should already be quiescing the hardware. If it isn't, it 
> should be. If it is, what does this patch fix? Many drivers 
> call pci_enable_device() early enough that they clearly expect the 
> hardware to be quiescent when they do so, so this really does seem to 
> simply handle the kexec case without handling any other cases that could 
> be similarly problematic.                               
> 

I agree drv->shutdown should quiesce the hardware (although anecdotal
evidence suggests that is not happening), so turning Bus Master bit off
is an additional safety measure. As Alan pointed out, doing that can be
fraught with danger. Clearing Bus Master bit seems like the right thing
to do, but due to buggy hardware/firmware it can cause problems,
although those problems happen at predictable times and thus become
easier to diagnose.

I am considering other options. Andi mentioned command line option which
does allow for some control instead of blindly clearing Bus Master bit
on all system. I am also wondering if clearing Bus Master bit on just
the PCI bridges is an option. If Bus Master bit is clear on a bridge, it
is not supposed to allow DMA transactions through it. That can prevent
random memory corruption by broken devices and also not upset the
devices that do not like their Bus Master bit cleared. Any opinions on
this option?

I have also acquired a broadcom NIC that is causing what looks like
random DMAs into kernel memory on a kexec, although this is with a
kernel that does not have the Bus Master reset patch. I will run some
experiments on this NIC and see what I can figure out.

====================================================================
Khalid Aziz                                         Unix Systems Lab
(970)898-9214                                        Hewlett-Packard
khalid.aziz@hp.com                                  Fort Collins, CO

