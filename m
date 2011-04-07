Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155Ab1DGMwM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 08:52:12 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:58799 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886Ab1DGMwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 08:52:10 -0400
X-SpamScore: -21
X-BigFish: VPS-21(zzbb2cK1432N98dKzz1202hzz15d4Rz32i637h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LJA92S-01-9YJ-02
X-M-MSG: 
Date: Thu, 7 Apr 2011 14:52:02 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: "Xu, Andiry" <Andiry.Xu@amd.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>, "He, Alex" <Alex.He@amd.com>
Subject: Re: [PATCH] USB host: Fix lockdep warning in AMD PLL quirk
Message-ID: <20110407125202.GW23633@amd.com>
References: <Pine.LNX.4.44L0.1104061110251.1907-100000@iolanthe.rowland.org>
 <1302164789-31887-1-git-send-email-joerg.roedel@amd.com>
 <2DEEA3AB13739D45A22ADDB5086AEA0B013084C4@sshaexmb1.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <2DEEA3AB13739D45A22ADDB5086AEA0B013084C4@sshaexmb1.amd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 07, 2011 at 05:58:14AM -0400, Xu, Andiry wrote:
> > +     spin_lock_irqsave(&amd_lock, flags);
> > +     if (amd_chipset.probe_count > 0) {
> > +             /* race - someone else was faster - drop devices */
> > +             if (info.nb_dev)
> > +                     pci_dev_put(info.nb_dev);
> > +             if (info.smbus_dev)
> > +                     pci_dev_put(info.smbus_dev);
> 
> You need to increase info.probe_count here and set
> amd_chipset.probe_count with it, because it's decreased during every
> host controller stop routine.

Right, the correct return value needs to be set too. I'll fix it.

> > +     } else {
> > +             /* no race - commit the result */
> > +             info.probe_count++;
> > +             amd_chipset = info;
> > +     }
> >       spin_unlock_irqrestore(&amd_lock, flags);
> > -     return amd_chipset.probe_result;
> > +
> > +     return ret;
> >  }
> >  EXPORT_SYMBOL_GPL(usb_amd_find_chipset_info);
> >
> > --
> > 1.7.1
> 
> The original design target is to probe the chipset only once, so other
> host controllers will not probe the chipset again. This patch allows
> multiple threads to probe the chipset at the same time, and only one
> thread is doing the valid work. It may add unnecessary cost.

Not necessarily. With this patch more than one thread could do the valid
work at the same time. With the old code the other threads would
have spent this time spinning on the lock. So I don't think there is
much additional cost introduced with this patch. And as a plus, it fixes
a bug :-)
I'll send a fixed version soon.

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

