Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692Ab2BDM7S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Feb 2012 07:59:18 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:35765 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144Ab2BDM7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Feb 2012 07:59:17 -0500
Date: Sat, 4 Feb 2012 12:59:04 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Myron Stowe <mstowe@redhat.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Mike Rapoport <mike@compulab.co.il>
Subject: [BUG] Multiple definition of pcibios_max_latency
Message-ID: <20120204125904.GU889@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While building my test PXA configuration, I came across:

drivers/built-in.o:(.data+0x230): multiple definition of `pcibios_max_latency'
arch/arm/common/built-in.o:(.data+0x40c): first defined here
make[1]: *** [vmlinux.o] Error 1

This was introduced by:

commit 96c5590058d7fded14f43af2ab521436cecf3125
Author: Myron Stowe <mstowe@redhat.com>
Date:   Fri Oct 28 15:48:38 2011 -0600

    PCI: Pull PCI 'latency timer' setup up into the core

    The 'latency timer' of PCI devices, both Type 0 and Type 1,
    is setup in architecture-specific code [see: 'pcibios_set_master()'].
    There are two approaches being taken by all the architectures - check
    if the 'latency timer' is currently set between 16 and 255 and if not
    bring it within bounds, or, do nothing (and then there is the
    gratuitously different PA-RISC implementation).

    There is nothing architecture-specific about PCI's 'latency timer' so
    this patch pulls its setup functionality up into the PCI core by
    creating a generic 'pcibios_set_master()' function using the '__weak'
    attribute which can be used by all architectures as a default which,
    if necessary, can then be over-ridden by architecture-specific code.

    No functional change.

    Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>

which moved the handling of pcibios_set_master() into core code for
everyone but ARM:

 arch/blackfin/include/asm/pci.h         |    4 ----
 arch/frv/mb93090-mb00/pci-frv.c         |    6 ------
 arch/frv/mb93090-mb00/pci-frv.h         |    2 --
 arch/h8300/include/asm/pci.h            |    5 -----
 arch/mips/pci/pci.c                     |    6 ------
 arch/mn10300/unit-asb2305/pci-asb2305.c |    6 ------
 arch/mn10300/unit-asb2305/pci-asb2305.h |    2 --
 arch/sh/drivers/pci/pci.c               |    6 ------
 arch/x86/include/asm/pci_x86.h          |    2 --
 arch/x86/pci/i386.c                     |    6 ------
 drivers/pci/pci.c                       |   29 +++++++++++++++++++++++++++++
 include/linux/pci.h                     |    3 +++
 12 files changed, 32 insertions(+), 45 deletions(-)

I think the right solution is to delete the (now duplicate) definition 
of pcibios_max_latency in arch/arm/common/it8152.c.  Please comment.
