Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422838Ab2JDPYG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 11:24:06 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:51442 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422691Ab2JDPYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 11:24:03 -0400
Date: Thu, 4 Oct 2012 11:12:33 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com
Subject: [GIT PULL] (xen) stable/for-linus-3.7-arm-tag
Message-ID: <20121004151233.GA11426@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XsQoSWH+UP9D9v3l"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XsQoSWH+UP9D9v3l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hey Linus,

Please git pull the following tag:

  git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/for-linus-3.7-arm-tag

which has the initial support for booting a Linux Xen guest under the
ARM (specifically ARMv7 with virtualized extensions).

The details of how to use/what it provides/etc are in the next paragraph.

There are going to be two merge conflicts. The first is in the
drivers/xen/Makefile and the resolution is to make dbgp.o be built on
 dom0-$(CONFIG_USB_SUPPORT) += dbpg.o

option.

The second is that the arch/arm/mach-vexpress/Makefile.boot has been squashed
in arch/arm/boot/dts/Makefile, so the addition of xenvm-4.2.dtb should be
done in the newfile.

For your convenience, I've created a branch titled 'linux-next-resolution' where
you can see how I resolved it.
http://git.kernel.org/?p=linux/kernel/git/konrad/xen.git;a=commitdiff;h=a7d7e57e1a0cae65f600306fe2fdf03b17582c22

The Xen-unstable hypervisor (so will be 4.3 in a ~6 months), supports ARMv7 platforms.

The goal in implementing this architecture is to exploit the hardware as much as
possible. That means use as little as possible of PV operations (so no PV MMU)
- and use existing PV drivers for I/Os (network, block, console, etc). This is
similar to how PVHVM guests operate in X86 platform nowadays - except that on
ARM there is no need for QEMU. The end result is that we share a lot of the
generic Xen drivers and infrastructure.

Details on how to compile/boot/etc are available at this Wiki:
  http://wiki.xen.org/wiki/Xen_ARMv7_with_Virtualization_Extensions

and this blog has links to a technical discussion/presentations on the
overall architecture:
 http://blog.xen.org/index.php/2012/09/21/xensummit-sessions-new-pvh-virtualisation-mode-for-arm-cortex-a15arm-servers-and-x86/

 Documentation/devicetree/bindings/arm/xen.txt |   25 ++++
 MAINTAINERS                                   |    7 +
 arch/arm/Kconfig                              |   10 ++
 arch/arm/Makefile                             |    1 +
 arch/arm/boot/dts/Makefile                    |    3 +-
 arch/arm/boot/dts/xenvm-4.2.dts               |   68 ++++++++++
 arch/arm/include/asm/hypervisor.h             |    6 +
 arch/arm/include/asm/sync_bitops.h            |   27 ++++
 arch/arm/include/asm/xen/events.h             |   18 +++
 arch/arm/include/asm/xen/hypercall.h          |   69 ++++++++++
 arch/arm/include/asm/xen/hypervisor.h         |   19 +++
 arch/arm/include/asm/xen/interface.h          |   73 +++++++++++
 arch/arm/include/asm/xen/page.h               |   82 ++++++++++++
 arch/arm/mach-vexpress/v2m.c                  |    1 +
 arch/arm/xen/Makefile                         |    1 +
 arch/arm/xen/enlighten.c                      |  168 +++++++++++++++++++++++++
 arch/arm/xen/grant-table.c                    |   53 ++++++++
 arch/arm/xen/hypercall.S                      |  106 ++++++++++++++++
 arch/ia64/include/asm/xen/interface.h         |    1 +
 arch/x86/include/asm/xen/interface.h          |    1 +
 arch/x86/xen/enlighten.c                      |    1 +
 arch/x86/xen/irq.c                            |    1 +
 arch/x86/xen/xen-ops.h                        |    1 -
 drivers/block/xen-blkback/blkback.c           |    1 +
 drivers/net/xen-netback/netback.c             |    1 +
 drivers/net/xen-netfront.c                    |    1 +
 drivers/xen/Makefile                          |   14 ++-
 drivers/xen/events.c                          |   14 ++-
 include/xen/events.h                          |    2 +
 include/xen/interface/features.h              |    3 +
 include/xen/interface/io/protocols.h          |    3 +
 include/xen/interface/memory.h                |   12 +-
 include/xen/interface/physdev.h               |    2 +-
 include/xen/interface/version.h               |    2 +-
 include/xen/xen.h                             |    4 +-
 35 files changed, 783 insertions(+), 18 deletions(-)

Stefano Stabellini (21):
      arm: initial Xen support
      xen/arm: hypercalls
      xen/arm: page.h definitions
      xen/arm: sync_bitops
      xen/arm: empty implementation of grant_table arch specific functions
      docs: Xen ARM DT bindings
      xen/arm: Xen detection and shared_info page mapping
      xen/arm: Introduce xen_ulong_t for unsigned long
      xen: do not compile manage, balloon, pci, acpi, pcpu and cpu_hotplug on ARM
      xen/arm: introduce CONFIG_XEN on ARM
      xen/arm: get privilege status
      xen/arm: initialize grant_table on ARM
      xen/arm: receive Xen events on ARM
      xen/arm: implement alloc/free_xenballooned_pages with alloc_pages/kfree
      xen/arm: compile blkfront and blkback
      xen/arm: compile netback
      MAINTAINERS: add myself as Xen ARM maintainer
      arm: introduce a DTS for Xen unprivileged virtual machines
      xen/Makefile: fix dom-y build
      xen: mark xen_init_IRQ __init
      xen/xen_initial_domain: check that xen_start_info is initialized


--XsQoSWH+UP9D9v3l
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAEBAgAGBQJQbadcAAoJEFjIrFwIi8fJ6PEH/35SFdRP7xX9ZECDhfLOIETy
268/+J8/reJde+gWnGfetpCpiTF7LwkXkNDJeFTzj9h6d5uHaZA6OY4Er6Q9eRU5
BMUxE1ZM4TkRKTDe7H//Ua/cpZdH8O6140kOrfzG0H+HDjqpcRBetCw4r7U2gnuL
hLZ+YNkbqoj5z38ooeN6vtQfUE3YutUcnEWKyG0k1yzhNrJQ7XaKO7pMNX8Ze/BC
DzcmQZda6bScyJVxddXlieqOMmrVO8QFtvQXNiFiFOBB082G72t5Vtdvg5xnVE48
jPf/nyxHTwnGxrX1Lzom6NqobSH88FeaGhj/V+eHd8zQ9sEWZHtQoZTufoAb6As=
=zrWt
-----END PGP SIGNATURE-----

--XsQoSWH+UP9D9v3l--
