Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899Ab0F3OBJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 10:01:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16676 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753299Ab0F3OBF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 10:01:05 -0400
Subject: Re: [PATCH V2] VFIO driver: Non-privileged user level PCI drivers
From: Alex Williamson <alex.williamson@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Tom Lyon <pugs@cisco.com>, randy.dunlap@oracle.com,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org, chrisw@sous-sol.org,
       joro@8bytes.org, hjk@linutronix.de, avi@redhat.com, gregkh@suse.de,
       aafabbri@cisco.com, scofeldm@cisco.com
In-Reply-To: <20100630133639.GB4226@redhat.com>
References: <4c0eb470.1HMjondO00NIvFM6%pugs@cisco.com>
	 <1277878452.3164.26.camel@x201>  <20100630133639.GB4226@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 30 Jun 2010 08:00:26 -0600
Message-ID: <1277906426.3164.40.camel@x201>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-30 at 16:36 +0300, Michael S. Tsirkin wrote:
> On Wed, Jun 30, 2010 at 12:14:12AM -0600, Alex Williamson wrote:
> > On Tue, 2010-06-08 at 14:21 -0700, Tom Lyon wrote:
> > > The VFIO "driver" is used to allow privileged AND non-privileged processes to 
> > > implement user-level device drivers for any well-behaved PCI, PCI-X, and PCIe
> > > devices.
> > 
> > Hi Tom,
> > 
> > I found a few bugs.  Patch below.  The first chunk clears the
> > pci_config_map on close, otherwise we end up passing virtualized state
> > from one user to the next.  The second is an off by one in the basic
> > perms.  Finally, vfio_bar_fixup() needs an overhaul.  It wasn't setting
> > the lower bits right and is allowing virtual writes of bits that aren't
> > aligned to the size.  This section probably needs another pass or two of
> > refinement.  Thanks,
> > 
> > Alex
> > 
> 
> I still don't see why are we sticking all this emulation in kernel.  It
> is far from performance hotpath and can easily be emulated in userspace.
> qemu does this, you can lift code from there if you like.
> Maybe we need to protect the BARs from being manipulated by userspace,
> but that should be all. No need for tables.

The benefit I see so far is that it removes duplicate code.  Should
every user of this interface try to extract qemu's PCI config space
emulation and jury rig it into their code base?  Tom is already
providing access to more capability bits than the kvm device assignment
code.  If the kernel community will accept it, I think it saves vfio
usperspace writers some hassle and provides a better environment by
having emulation in a single, well tested, hopefully well used place.
Thanks,

Alex

