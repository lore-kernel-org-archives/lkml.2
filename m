Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592Ab2EHJQk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 05:16:40 -0400
Received: from mga03.intel.com ([143.182.124.21]:56407 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751119Ab2EHJQh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 05:16:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="140242159"
From: "Hao, Xudong" <xudong.hao@intel.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: Avi Kivity <avi@redhat.com>, Xudong Hao <xudong.hao@linux.intel.com>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Zhang, Xiantao" <xiantao.zhang@intel.com>
Subject: RE: [PATCH] kvm: Enable device LTR/OBFF capibility before doing
 guest device assignment
Thread-Topic: [PATCH] kvm: Enable device LTR/OBFF capibility before doing
 guest device assignment
Thread-Index: AQHNK523sQykSXPAVU2m3kyfnWAfgJa98vXAgAAJMQCAAaFgIA==
Date: Tue, 8 May 2012 09:16:30 +0000
Message-ID: <403610A45A2B5242BD291EDAE8B37D300FDBDAB9@SHSMSX102.ccr.corp.intel.com>
References: <20120506152405.GA14009@hp-xd.sh.intel.com>
	 <4FA699F6.9010605@redhat.com>
	 <403610A45A2B5242BD291EDAE8B37D300FDAE9B6@SHSMSX102.ccr.corp.intel.com>
 <1336407384.12477.65.camel@bling.home>
In-Reply-To: <1336407384.12477.65.camel@bling.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q489Gj04024601

> -----Original Message-----
> From: Alex Williamson [mailto:alex.williamson@redhat.com]
> Sent: Tuesday, May 08, 2012 12:16 AM
> To: Hao, Xudong
> Cc: Avi Kivity; Xudong Hao; mtosatti@redhat.com; kvm@vger.kernel.org;
> linux-kernel@vger.kernel.org; Zhang, Xiantao
> Subject: RE: [PATCH] kvm: Enable device LTR/OBFF capibility before doing guest
> device assignment
> 
> On Mon, 2012-05-07 at 07:58 +0000, Hao, Xudong wrote:
> > > -----Original Message-----
> > > From: Avi Kivity [mailto:avi@redhat.com]
> > > Sent: Sunday, May 06, 2012 11:34 PM
> > > To: Xudong Hao
> > > Cc: mtosatti@redhat.com; kvm@vger.kernel.org;
> linux-kernel@vger.kernel.org;
> > > Zhang, Xiantao; Hao, Xudong; Alex Williamson
> > > Subject: Re: [PATCH] kvm: Enable device LTR/OBFF capibility before doing
> guest
> > > device assignment
> > >
> > > On 05/06/2012 06:24 PM, Xudong Hao wrote:
> > > > Enable device LTR/OBFF capibility before do device assignment, so that
> guest
> > > can benefit from them.
> > >
> > > cc += Alex
> > >
> > > > @@ -166,6 +166,10 @@ int kvm_assign_device(struct kvm *kvm,
> > > >     if (pdev == NULL)
> > > >         return -ENODEV;
> > > >
> > > > +   /* Enable some device capibility before do device assignment,
> > > > +    * so that guest can benefit from them.
> > > > +    */
> > > > +   kvm_iommu_enable_dev_caps(pdev);
> > > >     r = iommu_attach_device(domain, &pdev->dev);
> > >
> > > Suppose we fail here.  Do we need to disable_dev_caps()?
> > >
> 
> If kvm_assign_device() fails we'll try to restore the state we saved in
> kvm_vm_ioctl_assign_device(), so ltr/obff should be brought back to
> initial state.
> 
Right, more clear.

> > I don't think so. When a device will be assigned to guest, it's be
> > owned by a pci-stub driver, attach_device fail here do not affect
> > everything. If host want to use it, host device driver has its own
> > enable/disable dev_caps.
> 
> Why is device assignment unique here?  If there's a default value that's
> known to be safe, why doesn't pci_enable_device set it for everyone?
> Host drivers can fine tune the value later if they want.
> 
> > > >     if (r) {
> > > >         printk(KERN_ERR "assign device %x:%x:%x.%x failed",
> > > > @@ -228,6 +232,7 @@ int kvm_deassign_device(struct kvm *kvm,
> > > >         PCI_SLOT(assigned_dev->host_devfn),
> > > >         PCI_FUNC(assigned_dev->host_devfn));
> > > >
> > > > +   kvm_iommu_disable_dev_caps(pdev);
> > > >     return 0;
> > > >  }
> > > >
> > > > @@ -351,3 +356,30 @@ int kvm_iommu_unmap_guest(struct kvm *kvm)
> > > >     iommu_domain_free(domain);
> > > >     return 0;
> > > >  }
> > > > +
> > > > +static void kvm_iommu_enable_dev_caps(struct pci_dev *pdev)
> > > > +{
> > > > +   /* set default value */
> > > > +   unsigned long type = PCI_EXP_OBFF_SIGNAL_ALWAYS;
> > > > +   int snoop_lat_ns = 1024, nosnoop_lat_ns = 1024;
> > >
> > > Where does this magic number come from?
> > >
> > The number is the max value that register support, set it as default
> > here, we did not have any device here, and we do not know what's the
> > proper value, so it set a default value firstly.
> 
> The register is composed of latency scale and latency value fields.
> 1024 is simply the largest value the latency value can hold (+1).  The
> scale field allows latencies up to 34,326,183,936ns to be specified, so
> please explain how 1024 is a universal default.
> 

Since each platform will have its own max supported latency, I think the best way is setting the value to 0 because we have such a device now.

> > > > +
> > > > +   /* LTR(Latency tolerance reporting) allows devices to send
> > > > +    * messages to the root complex indicating their latency
> > > > +    * tolerance for snooped & unsnooped memory transactions.
> > > > +    */
> > > > +   pci_enable_ltr(pdev);
> > > > +   pci_set_ltr(pdev, snoop_lat_ns, nosnoop_lat_ns);
> > > > +
> > > > +   /* OBFF (optimized buffer flush/fill), where supported,
> > > > +    * can help improve energy efficiency by giving devices
> > > > +    * information about when interrupts and other activity
> > > > +    * will have a reduced power impact.
> > > > +    */
> > > > +   pci_enable_obff(pdev, type);
> > > > +}
> > > > +
> > > > +static void kvm_iommu_disable_dev_caps(struct pci_dev *pdev)
> > > > +{
> > > > +   pci_disble_obff(pdev);
> > > > +   pci_disble_ltr(pdev);
> > > > +}
> > >
> > > Do we need to communicate something about these capabilities to the
> guest?
> > >
> >
> > I guess you means that here host don't know if guest want to enable them,
> right?
> > The ltr/obff new feature are supposed to enabled by guest if platform and
> device supported.
> 
> It looks like ltr is a two part mechanism, the capability and enable
> lives in the pci express capability, but the tuning registers live in
> extended capability space.  The guest doesn't yet have access to the
> latter since we don't have an express chipset.  The capability and
> enable are read-only to the guest currently, same for obff.  Thanks,
> 
> Alex

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
