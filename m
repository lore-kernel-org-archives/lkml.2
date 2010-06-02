Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758155Ab0FBNV4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 09:21:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28162 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753207Ab0FBNVz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 09:21:55 -0400
Date: Wed, 2 Jun 2010 16:17:19 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: Avi Kivity <avi@redhat.com>, Tom Lyon <pugs@cisco.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org, chrisw@sous-sol.org,
       hjk@linutronix.de, gregkh@suse.de, aafabbri@cisco.com,
       scofeldm@cisco.com
Subject: Re: [PATCH] VFIO driver: Non-privileged user level PCI drivers
Message-ID: <20100602131719.GA29930@redhat.com>
References: <20100602095312.GA25335@redhat.com> <20100602101940.GG964@8bytes.org> <20100602102144.GD29023@redhat.com> <20100602103516.GI964@8bytes.org> <20100602103828.GF29023@redhat.com> <20100602111224.GA11033@8bytes.org> <20100602112100.GA29697@redhat.com> <20100602121927.GA11162@8bytes.org> <4C064DA7.6060504@redhat.com> <20100602125049.GB11162@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100602125049.GB11162@8bytes.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 02, 2010 at 02:50:50PM +0200, Joerg Roedel wrote:
> On Wed, Jun 02, 2010 at 03:25:11PM +0300, Avi Kivity wrote:
> > On 06/02/2010 03:19 PM, Joerg Roedel wrote:
> >>
> >>> Yes.  so you do:
> >>> iommu = open
> >>> ioctl(dev1, BIND, iommu)
> >>> ioctl(dev2, BIND, iommu)
> >>> ioctl(dev3, BIND, iommu)
> >>> ioctl(dev4, BIND, iommu)
> >>>
> >>> No need to add a SHARE ioctl.
> >>>      
> >> In my proposal this looks like:
> >>
> >>
> >> dev1 = open();
> >> ioctl(dev2, SHARE, dev1);
> >> ioctl(dev3, SHARE, dev1);
> >> ioctl(dev4, SHARE, dev1);
> >>
> >> So we actually save an ioctl.
> >>    
> >
> > The problem with this is that it is assymetric, dev1 is treated  
> > differently from dev[234].  It's an unintuitive API.
> 
> Its by far more unintuitive that a process needs to explicitly bind a
> device to an iommu domain before it can do anything with it.

The reason it is more intuitive is because it is harder to get it
wrong. If you swap iommu and device in the call, you get BADF
so you know you made a mistake. We can even make it work
both ways if we wanted to. With ioctl(dev1, BIND, dev2)
it breaks silently.


> If its
> required anyway the binding can happen implicitly. We could allow to do
> a nop 'ioctl(dev1, SHARE, dev1)' to remove the asymmetry.

And then when we assign meaning to it we find that half the apps
are broken because they did not call this ioctl.

> Note that this way of handling userspace iommu mappings is also a lot
> simpler for most use-cases outside of KVM. If a developer wants to write
> a userspace driver all it needs to do is:
> 
> dev = open();
> ioctl(dev, MAP, ...);
> /* use device with mappings */
> close(dev);
> 
> Which is much easier than the need to create a domain explicitly.
> 
> 	Joerg

This simple scenario ignores all the real-life corner cases.
For example, with an explicit iommu open and bind application
can naturally detect that:
- we have run out of iommu domains
- iommu is unsupported
- iommu is in use by another, incompatible device
- device is in bad state
because each is a separate operation, so it is easy to produce meaningful
errors.

Another interesting thing that a separate iommu device supports is when
application A controls the iommu and application B
controls the device. This might be good to e.g. improve security
(B is run by root, A is unpriveledged and passes commands to/from B
 over a pipe).

This is not possible when same fd is used for iommu and device.

-- 
MST
