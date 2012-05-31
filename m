Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757844Ab2EaCRR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 22:17:17 -0400
Received: from mga14.intel.com ([143.182.124.37]:17327 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757700Ab2EaCRP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 22:17:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="106114109"
From: "Hao, Xudong" <xudong.hao@intel.com>
To: Don Dutile <ddutile@redhat.com>, Xudong Hao <xudong.hao@linux.intel.com>
CC: "bhelgaas@google.com" <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "avi@redhat.com" <avi@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Zhang, Xiantao" <xiantao.zhang@intel.com>
Subject: RE: [PATCH 1/1] Enable LTR/OBFF before device is used by driver
Thread-Topic: [PATCH 1/1] Enable LTR/OBFF before device is used by driver
Thread-Index: AQHNMXuKirBV1mWKHkas/cdRQgQrOpbiFScAgAEq0tA=
Date: Thu, 31 May 2012 02:17:12 +0000
Message-ID: <403610A45A2B5242BD291EDAE8B37D300FDCBB73@SHSMSX102.ccr.corp.intel.com>
References: <20120514024816.GA15371@hp-xd.sh.intel.com>
 <4FC6471A.5090208@redhat.com>
In-Reply-To: <4FC6471A.5090208@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Don Dutile [mailto:ddutile@redhat.com]
> Sent: Thursday, May 31, 2012 12:13 AM
> To: Xudong Hao
> Cc: bhelgaas@google.com; linux-pci@vger.kernel.org;
> linux-kernel@vger.kernel.org; kvm@vger.kernel.org; avi@redhat.com;
> alex.williamson@redhat.com; Zhang, Xiantao; Hao, Xudong
> Subject: Re: [PATCH 1/1] Enable LTR/OBFF before device is used by driver
> 
> While you are making the other recommended fixes, could
> you add/create a pci_obff_supported() function, like the pci_ltr_supported()
> function, and more importantly, add it to the pci_disable_obff() function?
> The latter does not check that DEVCAP2 is supported, and thus, could be
> writing to non-existent (potentially private) cap space (i.e., a V1 CAP device,
> which do exist in the marketplace).
> 
> The [enable,disable]_ltr functions do a good job of doing pci_ltr_supported()
> checks, but the obff enable,disable functions should have similar calls.
> 

Yeah, it's a good suggestion, I'll add pci_obff_supported() function.

> 
> On 05/13/2012 10:48 PM, Xudong Hao wrote:
> > Enable LTR(Latency tolerance reporting) and OBFF(optimized buffer flush/fill)
> in
> >   pci_enable_device(), so that they are enabled before the device is used by
> driver.
> >
> > Signed-off-by: Xudong Hao<xudong.hao@intel.com>
> >
> > ---
> >   drivers/pci/pci.c |   29 +++++++++++++++++++++++++++++
> >   1 files changed, 29 insertions(+), 0 deletions(-)
> >
> > diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> > index 111569c..2369883 100644
> > --- a/drivers/pci/pci.c
> > +++ b/drivers/pci/pci.c
> > @@ -1134,6 +1134,31 @@ int pci_load_and_free_saved_state(struct
> pci_dev *dev,
> >   }
> >   EXPORT_SYMBOL_GPL(pci_load_and_free_saved_state);
> >
> > +static void pci_enable_dev_caps(struct pci_dev *dev)
> > +{
> > +       /* set default value */
> > +       unsigned long type = PCI_EXP_OBFF_SIGNAL_ALWAYS;
> > +
> > +       /* LTR(Latency tolerance reporting) allows devices to send
> > +        * messages to the root complex indicating their latency
> > +        * tolerance for snooped&  unsnooped memory transactions.
> > +        */
> > +       pci_enable_ltr(dev);
> > +
> > +       /* OBFF (optimized buffer flush/fill), where supported,
> > +        * can help improve energy efficiency by giving devices
> > +        * information about when interrupts and other activity
> > +        * will have a reduced power impact.
> > +        */
> > +       pci_enable_obff(dev, type);
> > +}
> > +
> > +static void pci_disable_dev_caps(struct pci_dev *dev)
> > +{
> > +       pci_disable_obff(dev);
> > +       pci_disable_ltr(dev);
> > +}
> > +
> >   static int do_pci_enable_device(struct pci_dev *dev, int bars)
> >   {
> >          int err;
> > @@ -1146,6 +1171,9 @@ static int do_pci_enable_device(struct pci_dev
> *dev, int bars)
> >                  return err;
> >          pci_fixup_device(pci_fixup_enable, dev);
> >
> > +       /* Enable some device capibility before it's used by driver. */
> > +       pci_enable_dev_caps(dev);
> > +
> >          return 0;
> >   }
> >
> > @@ -1361,6 +1389,7 @@ static void do_pci_disable_device(struct pci_dev
> *dev)
> >          }
> >
> >          pcibios_disable_device(dev);
> > +       pci_disable_dev_caps(dev);
> >   }
> >
> >   /**
> > --
> > 1.6.0.rc1
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

