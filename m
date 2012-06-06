Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756777Ab2FFQRu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 12:17:50 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:12328 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754073Ab2FFQRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 12:17:46 -0400
Subject: Re: [PATCH] Disable Bus Master on PCI device shutdown
From: Khalid Aziz <khalid.aziz@hp.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org, bhelgaas@google.com,
        linux-pci@vger.kernel.org
In-Reply-To: <20120606135009.GB1517@srcf.ucam.org>
References: <20120427190033.GA17588@ldl.usa.hp.com>
	 <20120606135009.GB1517@srcf.ucam.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Jun 2012 10:17:43 -0600
Message-ID: <1338999463.25761.630.camel@lyra>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-06 at 14:50 +0100, Matthew Garrett wrote:
> On Fri, Apr 27, 2012 at 01:00:33PM -0600, Khalid Aziz wrote:
> > Disable Bus Master bit on the device in
> > pci_device_shutdown() to ensure PCI devices do not continue
> > to DMA data after shutdown. This can cause memory
> > corruption in case of a kexec where the current kernel
> > shuts down and transfers control to a new kernel while a
> > PCI device continues to DMA to memory that does not belong
> > to it any more in the new kernel.
> 
> This protects against the case where a piece of hardware is continuing 
> to DMA even after the driver shutdown method has been called? I'm not 
> convinced this is safe. Some Broadcom parts will crash if busmastering 
> is disabled while they're still performing DMA, and they'll then hang 
> the bus if reenabled. There's also the risk that the hardware will start 
> DMAing again if it's reenabled after being shut down. It seems like 
> you're covering over the case where the driver didn't correctly quiesce 
> the hardware, but you risk triggering other bugs instead.

Hi Matthew,

That is a good piece of information. I see your concern and agree with
it. My take is shutdown method for the drivers will end all active I/O
and clear the I/O queue. This should take care of any DMA caused by an
I/O request originating in the kernel. For devices like NIC, a DMA can
be triggered by an incoming packet and I am trying to stop that by
disabling Bus Master bit. This is the issue that was reported on kexec
mailing list in July of last year and it involved qla driver. I observed
similar problem with kexec on ia64 many years ago and had written a
patch to disable Bus Master bit on kexec. This patch was in ia64 tree
for some time before it was removed. HP shipped kernels with this patch
for many years and those kernels have been in deployment in field for
some 7+ years with no problems.

So it seems we do have a real problem. I understand there are devices
with quirks related to Bus Master bit and it really helps to know about
those. I have found disabling Bus Master bit has worked very well for
all of the systems I have deployed kernels with this patch on but I have
not come even close to having tried all PCI devices out there. I am open
to other suggestions on how to solve this problem and make kexec
reliable.

Thanks Matthew! I appreciate the feedback.

-- 
Khalid
====================================================================
Khalid Aziz                                         Unix Systems Lab
(970)898-9214                                        Hewlett-Packard
khalid.aziz@hp.com                                  Fort Collins, CO


