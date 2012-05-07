Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757292Ab2EGQQ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 12:16:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21763 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756347Ab2EGQQ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 12:16:27 -0400
Message-ID: <1336407384.12477.65.camel@bling.home>
Subject: RE: [PATCH] kvm: Enable device LTR/OBFF capibility before doing
 guest device assignment
From: Alex Williamson <alex.williamson@redhat.com>
To: "Hao, Xudong" <xudong.hao@intel.com>
Cc: Avi Kivity <avi@redhat.com>, Xudong Hao <xudong.hao@linux.intel.com>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Zhang, Xiantao" <xiantao.zhang@intel.com>
Date: Mon, 07 May 2012 10:16:24 -0600
In-Reply-To: <403610A45A2B5242BD291EDAE8B37D300FDAE9B6@SHSMSX102.ccr.corp.intel.com>
References: <20120506152405.GA14009@hp-xd.sh.intel.com>
	 <4FA699F6.9010605@redhat.com>
	 <403610A45A2B5242BD291EDAE8B37D300FDAE9B6@SHSMSX102.ccr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-05-07 at 07:58 +0000, Hao, Xudong wrote:
> > -----Original Message-----
> > From: Avi Kivity [mailto:avi@redhat.com]
> > Sent: Sunday, May 06, 2012 11:34 PM
> > To: Xudong Hao
> > Cc: mtosatti@redhat.com; kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> > Zhang, Xiantao; Hao, Xudong; Alex Williamson
> > Subject: Re: [PATCH] kvm: Enable device LTR/OBFF capibility before doing guest
> > device assignment
> > 
> > On 05/06/2012 06:24 PM, Xudong Hao wrote:
> > > Enable device LTR/OBFF capibility before do device assignment, so that guest
> > can benefit from them.
> > 
> > cc += Alex
> > 
> > > @@ -166,6 +166,10 @@ int kvm_assign_device(struct kvm *kvm,
> > >     if (pdev == NULL)
> > >         return -ENODEV;
> > >
> > > +   /* Enable some device capibility before do device assignment,
> > > +    * so that guest can benefit from them.
> > > +    */
> > > +   kvm_iommu_enable_dev_caps(pdev);
> > >     r = iommu_attach_device(domain, &pdev->dev);
> > 
> > Suppose we fail here.  Do we need to disable_dev_caps()?
> > 

If kvm_assign_device() fails we'll try to restore the state we saved in
kvm_vm_ioctl_assign_device(), so ltr/obff should be brought back to
initial state.

> I don't think so. When a device will be assigned to guest, it's be
> owned by a pci-stub driver, attach_device fail here do not affect
> everything. If host want to use it, host device driver has its own
> enable/disable dev_caps.

Why is device assignment unique here?  If there's a default value that's
known to be safe, why doesn't pci_enable_device set it for everyone?
Host drivers can fine tune the value later if they want.

> > >     if (r) {
> > >         printk(KERN_ERR "assign device %x:%x:%x.%x failed",
> > > @@ -228,6 +232,7 @@ int kvm_deassign_device(struct kvm *kvm,
> > >         PCI_SLOT(assigned_dev->host_devfn),
> > >         PCI_FUNC(assigned_dev->host_devfn));
> > >
> > > +   kvm_iommu_disable_dev_caps(pdev);
> > >     return 0;
> > >  }
> > >
> > > @@ -351,3 +356,30 @@ int kvm_iommu_unmap_guest(struct kvm *kvm)
> > >     iommu_domain_free(domain);
> > >     return 0;
> > >  }
> > > +
> > > +static void kvm_iommu_enable_dev_caps(struct pci_dev *pdev)
> > > +{
> > > +   /* set default value */
> > > +   unsigned long type = PCI_EXP_OBFF_SIGNAL_ALWAYS;
> > > +   int snoop_lat_ns = 1024, nosnoop_lat_ns = 1024;
> > 
> > Where does this magic number come from?
> > 
> The number is the max value that register support, set it as default
> here, we did not have any device here, and we do not know what's the
> proper value, so it set a default value firstly.

The register is composed of latency scale and latency value fields.
1024 is simply the largest value the latency value can hold (+1).  The
scale field allows latencies up to 34,326,183,936ns to be specified, so
please explain how 1024 is a universal default.

> > > +
> > > +   /* LTR(Latency tolerance reporting) allows devices to send
> > > +    * messages to the root complex indicating their latency
> > > +    * tolerance for snooped & unsnooped memory transactions.
> > > +    */
> > > +   pci_enable_ltr(pdev);
> > > +   pci_set_ltr(pdev, snoop_lat_ns, nosnoop_lat_ns);
> > > +
> > > +   /* OBFF (optimized buffer flush/fill), where supported,
> > > +    * can help improve energy efficiency by giving devices
> > > +    * information about when interrupts and other activity
> > > +    * will have a reduced power impact.
> > > +    */
> > > +   pci_enable_obff(pdev, type);
> > > +}
> > > +
> > > +static void kvm_iommu_disable_dev_caps(struct pci_dev *pdev)
> > > +{
> > > +   pci_disble_obff(pdev);
> > > +   pci_disble_ltr(pdev);
> > > +}
> > 
> > Do we need to communicate something about these capabilities to the guest?
> > 
> 
> I guess you means that here host don't know if guest want to enable them, right? 
> The ltr/obff new feature are supposed to enabled by guest if platform and device supported.

It looks like ltr is a two part mechanism, the capability and enable
lives in the pci express capability, but the tuning registers live in
extended capability space.  The guest doesn't yet have access to the
latter since we don't have an express chipset.  The capability and
enable are read-only to the guest currently, same for obff.  Thanks,

Alex

