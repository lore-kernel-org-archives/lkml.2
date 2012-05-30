Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888Ab2E3L2r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 07:28:47 -0400
Received: from mga03.intel.com ([143.182.124.21]:32453 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751411Ab2E3L2p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 07:28:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="149436448"
From: "Hao, Xudong" <xudong.hao@intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>
CC: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "avi@redhat.com" <avi@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Zhang, Xiantao" <xiantao.zhang@intel.com>
Subject: RE: [PATCH 1/1] Enable LTR/OBFF before device is used by driver
Thread-Topic: [PATCH 1/1] Enable LTR/OBFF before device is used by driver
Thread-Index: AQHNMXuKirBV1mWKHkas/cdRQgQrOpbP0fMAgBI4e6A=
Date: Wed, 30 May 2012 11:28:33 +0000
Message-ID: <403610A45A2B5242BD291EDAE8B37D300FDCB508@SHSMSX102.ccr.corp.intel.com>
References: <20120514024816.GA15371@hp-xd.sh.intel.com>
 <CAErSpo6jE+3uzjrx9v+f=memXP6TpmHnOBcqW5bH1HJO_EQVuw@mail.gmail.com>
In-Reply-To: <CAErSpo6jE+3uzjrx9v+f=memXP6TpmHnOBcqW5bH1HJO_EQVuw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Bjorn Helgaas [mailto:bhelgaas@google.com]
> Sent: Saturday, May 19, 2012 9:20 AM
> To: Xudong Hao
> Cc: linux-pci@vger.kernel.org; linux-kernel@vger.kernel.org;
> kvm@vger.kernel.org; avi@redhat.com; alex.williamson@redhat.com; Zhang,
> Xiantao; Hao, Xudong
> Subject: Re: [PATCH 1/1] Enable LTR/OBFF before device is used by driver
> 
> On Sun, May 13, 2012 at 8:48 PM, Xudong Hao <xudong.hao@linux.intel.com>
> wrote:
> > Enable LTR(Latency tolerance reporting) and OBFF(optimized buffer flush/fill)
> in
> >  pci_enable_device(), so that they are enabled before the device is used by
> driver.
> 
> Please split this into two patches (one for LTR and another for OBFF)
> so they can be reverted individually if they cause trouble.  

OK.

> It would
> be nice if you bundled these together with your other "save/restore
> max Latency Value" patch so they were all together on the mailing
> list.
> 
Sure, I'll modify the save/restore patch and bundle them together.

> I read the LTR sections of the PCIe spec, but I can't figure out how
> it's supposed to work.  It says "power management policies ... can be
> implemented to consider Endpoint service requirements."  Does that
> mean there's some OS software that might be involved, or is this just
> a matter of software flipping the LTR-enable bit and the hardware
> doing everything else?  How confident can we be that enabling this is
> safe?
> 

Software only set the LTR-enable bit, then hardware/chipset/device do everything else. There are one thing that software can be involved: software can configure maximum latency tolerance.

> For OBFF, is there some OS piece not included here that tells a Root
> Complex that "now is a good time for Endpoints to do something," e.g.,
> the spec mentions an "operating system timer tick."  Is there some
> benefit to this patch without that piece?  I don't understand the big
> picture yet.
> 

As like LTR, OBFF do not need OS do additional changes, just set obff-enable bit.

> > Signed-off-by: Xudong Hao <xudong.hao@intel.com>
> >
> > ---
> >  drivers/pci/pci.c |   29 +++++++++++++++++++++++++++++
> >  1 files changed, 29 insertions(+), 0 deletions(-)
> >
> > diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> > index 111569c..2369883 100644
> > --- a/drivers/pci/pci.c
> > +++ b/drivers/pci/pci.c
> > @@ -1134,6 +1134,31 @@ int pci_load_and_free_saved_state(struct
> pci_dev *dev,
> >  }
> >  EXPORT_SYMBOL_GPL(pci_load_and_free_saved_state);
> >
> > +static void pci_enable_dev_caps(struct pci_dev *dev)
> > +{
> > +       /* set default value */
> > +       unsigned long type = PCI_EXP_OBFF_SIGNAL_ALWAYS;
> 
> There's only one use of this value, so skip the variable and just use
> PCI_EXP_OBFF_SIGNAL_ALWAYS in the call.
> 

Ok.

> The comment at pci_enable_obff() says PCI_OBFF_SIGNAL_L0 is the
> preferred type, so please explain why you're not using that.
> 

Yes, here it's better to set PCI_OBFF_SIGNAL_L0 by default.

> > +
> > +       /* LTR(Latency tolerance reporting) allows devices to send
> > +        * messages to the root complex indicating their latency
> > +        * tolerance for snooped & unsnooped memory transactions.
> > +        */
> 
> Follow Linux comment style, i.e.,
> 
>     /*
>      * LTR ...
>      */
> 

Will modify, Thanks.

> > +       pci_enable_ltr(dev);
> > +
> > +       /* OBFF (optimized buffer flush/fill), where supported,
> > +        * can help improve energy efficiency by giving devices
> > +        * information about when interrupts and other activity
> > +        * will have a reduced power impact.
> > +        */
> > +       pci_enable_obff(dev, type);
> > +}
> > +
> > +static void pci_disable_dev_caps(struct pci_dev *dev)
> > +{
> > +       pci_disable_obff(dev);
> > +       pci_disable_ltr(dev);
> > +}
> > +
> >  static int do_pci_enable_device(struct pci_dev *dev, int bars)
> >  {
> >        int err;
> > @@ -1146,6 +1171,9 @@ static int do_pci_enable_device(struct pci_dev
> *dev, int bars)
> >                return err;
> >        pci_fixup_device(pci_fixup_enable, dev);
> >
> > +       /* Enable some device capibility before it's used by driver. */
> > +       pci_enable_dev_caps(dev);
> 
> Why is this here?  It seems similar to what's already in
> pci_init_capabilities().  Is there a reason to do this in the
> pci_enable_device() path rather than in the pci_device_add() path?
> 

pci_enable_device is called by any pci driver including kvm driver, Considering such a case in kvm, when device is assigned to guest(the device will be reset), we want not host lose those advanced PM feature, so add it in pci_enable_device so that kvm driver call it.
 
> > +
> >        return 0;
> >  }
> >
> > @@ -1361,6 +1389,7 @@ static void do_pci_disable_device(struct pci_dev
> *dev)
> >        }
> >
> >        pcibios_disable_device(dev);
> > +       pci_disable_dev_caps(dev);
> >  }
> >
> >  /**
> > --
> > 1.6.0.rc1
> >
