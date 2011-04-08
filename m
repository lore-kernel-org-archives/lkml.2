Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932281Ab1DHPZP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 11:25:15 -0400
Received: from am1ehsobe006.messaging.microsoft.com ([213.199.154.209]:41337
	"EHLO AM1EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932230Ab1DHPZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 11:25:13 -0400
X-Greylist: delayed 907 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 Apr 2011 11:25:13 EDT
X-SpamScore: -21
X-BigFish: VPS-21(zz146fK1432N98dKzz1202hzz15d4Rz32i637h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LJCA4K-01-8S6-02
X-M-MSG: 
Date: Fri, 8 Apr 2011 17:09:55 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Alan Stern <stern@rowland.harvard.edu>
CC: Greg Kroah-Hartman <gregkh@suse.de>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        "Xu, Andiry" <Andiry.Xu@amd.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>
Subject: Re: [PATCH v4] USB host: Fix lockdep warning in AMD PLL quirk
Message-ID: <20110408150955.GD23633@amd.com>
References: <1302272804-3309-1-git-send-email-joerg.roedel@amd.com>
 <Pine.LNX.4.44L0.1104081041270.1992-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1104081041270.1992-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 08, 2011 at 10:52:59AM -0400, Alan Stern wrote:
> On Fri, 8 Apr 2011, Joerg Roedel wrote:
> > -	amd_chipset.probe_count++;
> >  	/* probe only once */
> > -	if (amd_chipset.probe_count > 1) {
> > +	if (amd_chipset.probe_count > 0) {
> 
> You need to increment probe_count here.

Argh, right.

> 
> >  		spin_unlock_irqrestore(&amd_lock, flags);
> >  		return amd_chipset.probe_result;
> >  	}
> > +	info = amd_chipset;
> 
> What's the point of this line?  You're just going to write over all the 
> data in info anyway, so it doesn't matter what amd_chipset contains.  A 
> memset would work just as well.

info is on-stack and needs to be initialized somehow because the
following code does not touch the whole data structure.

> 
> > @@ -284,8 +310,10 @@ EXPORT_SYMBOL_GPL(usb_amd_quirk_pll_enable);
> >  
> >  void usb_amd_dev_put(void)
> >  {
> > +	struct pci_dev *nb, *smbus;
> >  	unsigned long flags;
> >  
> > +
> 
> Why add an extra blank line?

Left-over from editing.

> 
> >  	spin_lock_irqsave(&amd_lock, flags);
> >  
> >  	amd_chipset.probe_count--;
> > @@ -294,20 +322,23 @@ void usb_amd_dev_put(void)
> >  		return;
> >  	}
> >  
> > -	if (amd_chipset.nb_dev) {
> > -		pci_dev_put(amd_chipset.nb_dev);
> > -		amd_chipset.nb_dev = NULL;
> > -	}
> > -	if (amd_chipset.smbus_dev) {
> > -		pci_dev_put(amd_chipset.smbus_dev);
> > -		amd_chipset.smbus_dev = NULL;
> > -	}
> > +	/* save them to pci_dev_put outside of spinlock */
> > +	nb    = amd_chipset.nb_dev;
> > +	smbus = amd_chipset.smbus_dev;
> > +
> > +	amd_chipset.nb_dev = NULL;
> > +	amd_chipset.smbus_dev = NULL;
> >  	amd_chipset.nb_type = 0;
> >  	amd_chipset.sb_type = 0;
> >  	amd_chipset.isoc_reqs = 0;
> >  	amd_chipset.probe_result = 0;
> 
> You could use memset instead.  However, in reality it shouldn't be
> necessary to set any of these things to 0.

Well, I left this code as it was before because this is meant as a fix
and I tried to keep it small. For a fix it is already really big...
But that can certainly be changed in a follow-on patch.

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

