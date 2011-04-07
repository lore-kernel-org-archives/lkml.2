Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932390Ab1DGCVv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 22:21:51 -0400
Received: from ch1outboundpool.messaging.microsoft.com ([216.32.181.184]:51173
	"EHLO CH1EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932152Ab1DGCVt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 22:21:49 -0400
X-SpamScore: -27
X-BigFish: VPS-27(zzbb2cK9371O542M1432N98dK4015Lzz1202hzz8275bh8275dhz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LJ9FW5-01-1IB-02
X-M-MSG: 
x-mimeole: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] USB host: Fix lockdep warning in AMD PLL quirk
Date: Thu, 7 Apr 2011 10:21:34 +0800
Message-ID: <2DEEA3AB13739D45A22ADDB5086AEA0B01308243@sshaexmb1.amd.com>
In-Reply-To: <Pine.LNX.4.44L0.1104061110251.1907-100000@iolanthe.rowland.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] USB host: Fix lockdep warning in AMD PLL quirk
Thread-Index: Acv0bZTkc9BmU3n3QLSu/DYNGIU6mQAW2K1Q
References: <1302088878-25740-1-git-send-email-joerg.roedel@amd.com> <Pine.LNX.4.44L0.1104061110251.1907-100000@iolanthe.rowland.org>
From: "Xu, Andiry" <Andiry.Xu@amd.com>
To: Alan Stern <stern@rowland.harvard.edu>,
        "Roedel, Joerg" <Joerg.Roedel@amd.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable@kernel.org>
X-OriginalArrivalTime: 07 Apr 2011 02:21:37.0662 (UTC) FILETIME=[85DD11E0:01CBF4CA]
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Alan Stern [mailto:stern@rowland.harvard.edu]
> Sent: Wednesday, April 06, 2011 11:16 PM
> To: Roedel, Joerg
> Cc: Greg Kroah-Hartman; Sarah Sharp; Xu, Andiry;
linux-usb@vger.kernel.org;
> linux-kernel@vger.kernel.org; stable@kernel.org
> Subject: Re: [PATCH] USB host: Fix lockdep warning in AMD PLL quirk
> 
> On Wed, 6 Apr 2011, Joerg Roedel wrote:
> 
> > Booting 2.6.38 on my test machine produces a lockdep warning
> > from the usb_amd_find_chipset_info() function:
> >
> >  WARNING: at /data/lemmy/linux.trees.git/kernel/lockdep.c:2465
> lockdep_trace_alloc+0x95/0xc2()
> >  Hardware name: Snook
> >  Modules linked in:
> >  Pid: 959, comm: work_for_cpu Not tainted 2.6.39-rc2+ #22
> >  Call Trace:
> >   [<ffffffff8103c0d4>] warn_slowpath_common+0x80/0x98
> >   [<ffffffff812387e6>] ? T.492+0x24/0x26
> >   [<ffffffff8103c101>] warn_slowpath_null+0x15/0x17
> >   [<ffffffff81068667>] lockdep_trace_alloc+0x95/0xc2
> >   [<ffffffff810ed9ac>] slab_pre_alloc_hook+0x18/0x3b
> >   [<ffffffff810ef227>] kmem_cache_alloc_trace+0x25/0xba
> >   [<ffffffff812387e6>] T.492+0x24/0x26
> >   [<ffffffff81238816>] pci_get_subsys+0x2e/0x73
> >  sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda
tray
> >   [<ffffffff8123886c>] pci_get_device+0x11/0x13
> >   [<ffffffff814082a9>] usb_amd_find_chipset_info+0x3f/0x18a
> > ...
> >
> > It turns out that this function calls pci_get_device under a
spin_lock
> > with irqs disabled, but the pci_get_device function is only allowed
in
> > preemptible context.
> >
> > This patch fixes this by using temporary variables in the quirk
> > algorithm and commiting them later to the struct under the lock.
This
> > moves all pci_get_device() invocations out of the spin_lock and
fixes
> > the lockdep warning for me.
> >
> > Cc: stable@kernel.org
> > Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> > ---
> >  drivers/usb/host/pci-quirks.c |   67
+++++++++++++++++++++++-----------
> ------
> >  1 files changed, 38 insertions(+), 29 deletions(-)
> >
> > diff --git a/drivers/usb/host/pci-quirks.c b/drivers/usb/host/pci-
> quirks.c
> > index 1d586d4..d3e5cf3 100644
> > --- a/drivers/usb/host/pci-quirks.c
> > +++ b/drivers/usb/host/pci-quirks.c
> > @@ -84,64 +84,73 @@ int usb_amd_find_chipset_info(void)
> >  {
> >  	u8 rev = 0;
> >  	unsigned long flags;
> > +	struct pci_dev *nb_dev, *smbus_dev;
> > +	int nb_type, sb_type;
> >
> >  	spin_lock_irqsave(&amd_lock, flags);
> > -
> >  	amd_chipset.probe_count++;
> >  	/* probe only once */
> >  	if (amd_chipset.probe_count > 1) {
> >  		spin_unlock_irqrestore(&amd_lock, flags);
> >  		return amd_chipset.probe_result;
> >  	}
> 
> The counter really should be a bool: Has the chipset already been
> probed or not?  After all, nobody cares how many times this routine
was
> called.
> 

The probe routine increases probe_count counter to remember how many
hosts calls it. Every host that calls probe routine in initialization
will call usb_amd_dev_put() in *hci_stop() and decrease probe_count, so
the last caller can safely free the resources.

Thanks,
Andiry
 


