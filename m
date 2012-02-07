Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757205Ab2BGXIK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 18:08:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55847 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757154Ab2BGXII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 18:08:08 -0500
Subject: Re: [BUG] Multiple definition of pcibios_max_latency
From: Myron Stowe <mstowe@redhat.com>
To: Mike Rapoport <mike@compulab.co.il>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "myron.stowe" <myron.stowe@redhat.com>
In-Reply-To: <20120207085838.GB889@n2100.arm.linux.org.uk>
References: <20120204125904.GU889@n2100.arm.linux.org.uk>
	 <1328551157.2264.11.camel@zim.stowe>
	 <20120207085838.GB889@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 07 Feb 2012 15:26:44 -0700
Message-ID: <1328653604.2404.16.camel@zim.stowe>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-02-07 at 08:58 +0000, Russell King - ARM Linux wrote:
> On Mon, Feb 06, 2012 at 10:59:17AM -0700, Myron Stowe wrote:
> > On Sat, 2012-02-04 at 12:59 +0000, Russell King - ARM Linux wrote:
> > > While building my test PXA configuration, I came across:
> > > 
> > > drivers/built-in.o:(.data+0x230): multiple definition of `pcibios_max_latency'
> > > arch/arm/common/built-in.o:(.data+0x40c): first defined here
> > > make[1]: *** [vmlinux.o] Error 1
> > > 
> > > This was introduced by:
> > > 
> > > commit 96c5590058d7fded14f43af2ab521436cecf3125
> > > Author: Myron Stowe <mstowe@redhat.com>
> > > Date:   Fri Oct 28 15:48:38 2011 -0600
> > > 
> > >     PCI: Pull PCI 'latency timer' setup up into the core
> > > 
> > >     The 'latency timer' of PCI devices, both Type 0 and Type 1,
> > >     is setup in architecture-specific code [see: 'pcibios_set_master()'].
> > >     There are two approaches being taken by all the architectures - check
> > >     if the 'latency timer' is currently set between 16 and 255 and if not
> > >     bring it within bounds, or, do nothing (and then there is the
> > >     gratuitously different PA-RISC implementation).
> > > 
> > >     There is nothing architecture-specific about PCI's 'latency timer' so
> > >     this patch pulls its setup functionality up into the PCI core by
> > >     creating a generic 'pcibios_set_master()' function using the '__weak'
> > >     attribute which can be used by all architectures as a default which,
> > >     if necessary, can then be over-ridden by architecture-specific code.
> > > 
> > >     No functional change.
> > > 
> > >     Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
> > >     Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
> > > 
> > > which moved the handling of pcibios_set_master() into core code for
> > > everyone but ARM:
> > > 
> > >  arch/blackfin/include/asm/pci.h         |    4 ----
> > >  arch/frv/mb93090-mb00/pci-frv.c         |    6 ------
> > >  arch/frv/mb93090-mb00/pci-frv.h         |    2 --
> > >  arch/h8300/include/asm/pci.h            |    5 -----
> > >  arch/mips/pci/pci.c                     |    6 ------
> > >  arch/mn10300/unit-asb2305/pci-asb2305.c |    6 ------
> > >  arch/mn10300/unit-asb2305/pci-asb2305.h |    2 --
> > >  arch/sh/drivers/pci/pci.c               |    6 ------
> > >  arch/x86/include/asm/pci_x86.h          |    2 --
> > >  arch/x86/pci/i386.c                     |    6 ------
> > >  drivers/pci/pci.c                       |   29 +++++++++++++++++++++++++++++
> > >  include/linux/pci.h                     |    3 +++
> > >  12 files changed, 32 insertions(+), 45 deletions(-)
> > > 
> > > I think the right solution is to delete the (now duplicate) definition 
> > > of pcibios_max_latency in arch/arm/common/it8152.c.  Please comment.
> > 
> > Yes, that commit is the culprit.  I was concerned about ARM in general
> > when I posted this series as I do not have a compile environment for it,
> > nor am I at all familiar with ARM to know if I had covered all the
> > possible variations (i.e. 8152 vs other, non 8152 types).
> > 
> > Will deleting the 'pcibios_max_latency' definition in
> > arch/arm/common/it8152.c be the correct solution for all ARM variations
> > (I don't want to try and fix one while breaking others)?
> > 
> > I'll wait for your response/guidance and if this is the correct action
> > generate a patch right away.
> 
> Well, we never get two PCI host bridges built into the same kernel, so
> if you have an it8152 then you don't have anything of the others.
> 
> However, this is not my code, I don't know the platform, and I don't
> know why it was added as part of this support in the first place.  That's
> why Mike is on the CC list.

Mike:

Are you seeing the same failure as Russell, and if so, could you try the
following patch and see if it fixes the build?


linux-arm-kernel:

Any testing, with respect to what Russell encountered, of the various
ARM variations/configurations would be much appreciated.  Please provide
feedback as to the specific ARM variation/configuration, if it is
currently encountering the build issue that Russell is, and if the
attached patch fixes the build.


ARM/PCI: Remove ARM's duplicate definition of 'pcibios_max_latency'

From: Myron Stowe <mstowe@redhat.com>

The patch series to re-factor PCI's 'latency timer' setup (re:
http://marc.info/?l=linux-kernel&m=131983853831049&w=2) forgot to
remove the ARM specific definition of 'pcibios_max_latency' once such
had been moved into the pci core resulting in ARM related compile
errors -
  drivers/built-in.o:(.data+0x230): multiple definition of
  `pcibios_max_latency'
  arch/arm/common/built-in.o:(.data+0x40c): first defined here
  make[1]: *** [vmlinux.o] Error 1

In the series, patch 2/16 (commit 168c8619fd8) converted the ARM
specific version of 'pcibios_set_master()' to a non-inlined version.
This was done in preperation for hosting it up into PCI's core, which
was done in patch 10/16 (commit 96c5590058d) of the series (and
where the removal of ARM's 'pcibios_max_latency' was overlooked).

Reported-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
---

 arch/arm/common/it8152.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)


diff --git a/arch/arm/common/it8152.c b/arch/arm/common/it8152.c
index d1bcd7b..fb1f1cf 100644
--- a/arch/arm/common/it8152.c
+++ b/arch/arm/common/it8152.c
@@ -320,13 +320,6 @@ err0:
 	return -EBUSY;
 }
 
-/*
- * If we set up a device for bus mastering, we need to check the latency
- * timer as we don't have even crappy BIOSes to set it properly.
- * The implementation is from arch/i386/pci/i386.c
- */
-unsigned int pcibios_max_latency = 255;
-
 /* ITE bridge requires setting latency timer to avoid early bus access
    termination by PCI bus master devices
 */



