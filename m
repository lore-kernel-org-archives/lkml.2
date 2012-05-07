Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552Ab2EGH6Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 03:58:16 -0400
Received: from mga03.intel.com ([143.182.124.21]:30902 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755311Ab2EGH6O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 03:58:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="139700808"
From: "Hao, Xudong" <xudong.hao@intel.com>
To: Avi Kivity <avi@redhat.com>, Xudong Hao <xudong.hao@linux.intel.com>
CC: "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Zhang, Xiantao" <xiantao.zhang@intel.com>,
        Alex Williamson <Alex.Williamson@redhat.com>
Subject: RE: [PATCH] kvm: Enable device LTR/OBFF capibility before doing
 guest device assignment
Thread-Topic: [PATCH] kvm: Enable device LTR/OBFF capibility before doing
 guest device assignment
Thread-Index: AQHNK523sQykSXPAVU2m3kyfnWAfgJa98vXA
Date: Mon, 7 May 2012 07:58:09 +0000
Message-ID: <403610A45A2B5242BD291EDAE8B37D300FDAE9B6@SHSMSX102.ccr.corp.intel.com>
References: <20120506152405.GA14009@hp-xd.sh.intel.com>
 <4FA699F6.9010605@redhat.com>
In-Reply-To: <4FA699F6.9010605@redhat.com>
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
> From: Avi Kivity [mailto:avi@redhat.com]
> Sent: Sunday, May 06, 2012 11:34 PM
> To: Xudong Hao
> Cc: mtosatti@redhat.com; kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> Zhang, Xiantao; Hao, Xudong; Alex Williamson
> Subject: Re: [PATCH] kvm: Enable device LTR/OBFF capibility before doing guest
> device assignment
> 
> On 05/06/2012 06:24 PM, Xudong Hao wrote:
> > Enable device LTR/OBFF capibility before do device assignment, so that guest
> can benefit from them.
> 
> cc += Alex
> 
> > @@ -166,6 +166,10 @@ int kvm_assign_device(struct kvm *kvm,
> >     if (pdev == NULL)
> >         return -ENODEV;
> >
> > +   /* Enable some device capibility before do device assignment,
> > +    * so that guest can benefit from them.
> > +    */
> > +   kvm_iommu_enable_dev_caps(pdev);
> >     r = iommu_attach_device(domain, &pdev->dev);
> 
> Suppose we fail here.  Do we need to disable_dev_caps()?
> 
I don't think so. When a device will be assigned to guest, it's be owned by a pci-stub driver, attach_device fail here do not affect everything. If host want to use it, host device driver has its own enable/disable dev_caps.
 
> >     if (r) {
> >         printk(KERN_ERR "assign device %x:%x:%x.%x failed",
> > @@ -228,6 +232,7 @@ int kvm_deassign_device(struct kvm *kvm,
> >         PCI_SLOT(assigned_dev->host_devfn),
> >         PCI_FUNC(assigned_dev->host_devfn));
> >
> > +   kvm_iommu_disable_dev_caps(pdev);
> >     return 0;
> >  }
> >
> > @@ -351,3 +356,30 @@ int kvm_iommu_unmap_guest(struct kvm *kvm)
> >     iommu_domain_free(domain);
> >     return 0;
> >  }
> > +
> > +static void kvm_iommu_enable_dev_caps(struct pci_dev *pdev)
> > +{
> > +   /* set default value */
> > +   unsigned long type = PCI_EXP_OBFF_SIGNAL_ALWAYS;
> > +   int snoop_lat_ns = 1024, nosnoop_lat_ns = 1024;
> 
> Where does this magic number come from?
> 
The number is the max value that register support, set it as default here, we did not have any device here, and we do not know what's the proper value, so it set a default value firstly.


> > +
> > +   /* LTR(Latency tolerance reporting) allows devices to send
> > +    * messages to the root complex indicating their latency
> > +    * tolerance for snooped & unsnooped memory transactions.
> > +    */
> > +   pci_enable_ltr(pdev);
> > +   pci_set_ltr(pdev, snoop_lat_ns, nosnoop_lat_ns);
> > +
> > +   /* OBFF (optimized buffer flush/fill), where supported,
> > +    * can help improve energy efficiency by giving devices
> > +    * information about when interrupts and other activity
> > +    * will have a reduced power impact.
> > +    */
> > +   pci_enable_obff(pdev, type);
> > +}
> > +
> > +static void kvm_iommu_disable_dev_caps(struct pci_dev *pdev)
> > +{
> > +   pci_disble_obff(pdev);
> > +   pci_disble_ltr(pdev);
> > +}
> 
> Do we need to communicate something about these capabilities to the guest?
> 

I guess you means that here host don't know if guest want to enable them, right? 
The ltr/obff new feature are supposed to enabled by guest if platform and device supported.

> --
> error compiling committee.c: too many arguments to function

