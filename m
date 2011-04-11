Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976Ab1DKQiG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 12:38:06 -0400
Received: from am1ehsobe006.messaging.microsoft.com ([213.199.154.209]:41389
	"EHLO AM1EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753311Ab1DKQiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 12:38:04 -0400
X-SpamScore: -24
X-BigFish: VPS-24(zz1432N98dK179dNzz1202hzz15d4Rz32i637h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LJHY60-01-CIA-02
X-M-MSG: 
Date: Mon, 11 Apr 2011 18:37:11 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Alan Stern <stern@rowland.harvard.edu>
CC: Borislav Petkov <bp@alien8.de>, Greg Kroah-Hartman <gregkh@suse.de>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        "Xu, Andiry" <Andiry.Xu@amd.com>, USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5] USB host: Fix lockdep warning in AMD PLL quirk
Message-ID: <20110411163711.GA20607@amd.com>
References: <20110411161647.GK23633@amd.com>
 <Pine.LNX.4.44L0.1104111221000.1975-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1104111221000.1975-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 11, 2011 at 12:25:07PM -0400, Alan Stern wrote:
> On Mon, 11 Apr 2011, Roedel, Joerg wrote:
> 
> > > > +commit:
> > > > +
> > > > +	spin_lock_irqsave(&amd_lock, flags);
> > > > +	if (amd_chipset.probe_count > 0) {
> > > > +		/* race - someone else was faster - drop devices */
> > > > +
> > > > +		/* Mark that we where here */
> > > > +		amd_chipset.probe_count++;
> > > 
> > > This line should be moved above the "if" statement, since you always 
> > > want to increment the count.
> > 
> > No, probe_count can't be incremented here because the probe is not
> > finished yet.
> 
> I don't follow you.  Sure it is finished; this is the "commit" part of 
> the probe.

Nevermind, I thought you were refering to the spin-locked part at the
beginning of the function.

> >  If another thread jumps in after the lock is released and
> > detects probe_count > 0 while the probe hasn't happened the quirk will
> > fail. So we need to make sure that amd_chipset.probe_count does not
> > become > 0 before the probe is finished.
> 
> I meant the increment should be done before the "if" statement but
> after the spin_lock_irqsave().  That way nobody else can jump in at the
> wrong time.

In the real commit case the 

	amd_chipset = info;

line will overwrite the increment if the probe is done before the
if-statement. So incrementing amd_chipset.probe_count directly only
matters for the case where we detected a race.

> > > > +		ret = amd_chipset.probe_result;
> > > > +
> > > > +		spin_unlock_irqrestore(&amd_lock, flags);
> > > > +
> > > > +		if (info.nb_dev)
> > > > +			pci_dev_put(info.nb_dev);
> > > > +		if (info.smbus_dev)
> > > > +			pci_dev_put(info.smbus_dev);
> > > > +
> > > > +	} else {
> > > > +		/* no race - commit the result */
> > > > +		info.probe_count++;
> > > 
> > > This isn't right, because info.probe_count was initialized to 0.  Maybe 
> > > amd_chipset.probe_count should be made into a separate variable, not a 
> > > part of the structure, like amd_lock.
> > 
> > The purpose of the struct is structuring of data. In theory all of its
> > members could be turned into global variables. The amd_lock is different
> > because it does not only protect the struct but also access to the
> > hardware while the quirk is applied/unapplied.
> 
> Do it however you prefer.  But as it stands now, the patch is wrong.

Hmm, I see how it can be done differently, but no real bug.

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

