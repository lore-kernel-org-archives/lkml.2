Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756243Ab2INLOV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 07:14:21 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:52782 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753731Ab2INLNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 07:13:45 -0400
X-IronPort-AV: E=Sophos;i="4.80,422,1344211200"; 
   d="dts'?dtsi'?scan'208";a="14543401"
Date: Fri, 14 Sep 2012 12:12:59 +0100
From: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Ian Campbell <Ian.Campbell@citrix.com>, "Tim (Xen.org)" <tim@xen.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: [PATCH v4 00/24] Introduce Xen support on ARM (based on 3.6-rc5)
Message-ID: <alpine.DEB.2.02.1209141145150.29232@kaball.uk.xensource.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_004_alpineDEB20212081616185504850kaballukxensourcecom_"
Content-ID: <alpine.DEB.2.02.1209141145151.29232@kaball.uk.xensource.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_004_alpineDEB20212081616185504850kaballukxensourcecom_
Content-Type: text/plain; charset="US-ASCII"
Content-ID: <alpine.DEB.2.02.1209141145152.29232@kaball.uk.xensource.com>

Hi all,
this patch series implements Xen support for ARMv7 with virtualization
extensions.  It allows a Linux guest to boot as dom0 and
as domU on Xen on ARM. PV console, disk and network frontends and
backends are all working correctly.

It has been tested on a Versatile Express Cortex A15 emulator, using the
latest Xen ARM developement branch
(git://xenbits.xen.org/people/ianc/xen-unstable.git arm-for-4.3) plus
the "ARM hypercall ABI: 64 bit ready" patch series
(http://marc.info/?l=xen-devel&m=134426267205408), and a simple ad-hoc
tool to build guest domains (marc.info/?l=xen-devel&m=134089788016546).

The patch marked with [HACK] has been dropped from this series, however
you can find it here:
http://marc.info/?l=linux-kernel&m=134513277823527&w=2.

I am also attaching to this email the dts'es that I am currently using
for dom0 and domU: vexpress-v2p-ca15-tc1.dts (that includes
vexpress-v2m-rs1-rtsm.dtsi) is the dts used for dom0 and it is passed to
Linux by Xen, while vexpress-virt.dts is the dts used for other domUs
and it is appended in binary form to the guest kernel image. I am not
sure where they are supposed to live yet, so I am just attaching them
here so that people can actually try out this series if they want to.

Comments are very welcome!



Patch #21 "arm/v2m: initialize arch_timers even if v2m_timer is not
present" touches generic ARM code and still needs to be acked/reviewed.

Arnd, Russell, what do you think about this series? If you are OK with
it, to whom should I submit it?



Changes in v4:
- rebase on 3.6-rc5;
- devicetree: "xen,xen" should be last as it is less specific;
- devicetree: use 2 address-cells and 2 size-cells in the reg property;
- do not xs_reset_watches on dom0;
- compile drivers/xen/pcpu.c only on x86;
- use "+=" instead of ":=" for dom0- targets;
- add a patch to update the MAINTAINERS file.


Changes in v3:
- move patches that have been picked up by Konrad at the end of the
  series;
- improve comments;
- add a doc to describe the Xen Device Tree format;
- do not use xen_ulong_t for multicalls and apic_physbase;
- add a patch at the end of the series to use the new __HVC macro;
- add missing pvclock-abi.h include to ia64 header files;
- do not use an anonymous union in struct xen_add_to_physmap.


Changes in v2:
- fix up many comments and commit messages;
- remove the early_printk patches: rely on the emulated serial for now;
- remove the xen_guest_init patch: without any PV early_printk, we don't
  need any early call to xen_guest_init, we can rely on core_initcall
  alone;
- define an HYPERCALL macro for 5 arguments hypercall wrappers, even if
  at the moment is unused;
- use ldm instead of pop in the hypercall wrappers;
- return -ENOSYS rather than -1 from the unimplemented grant_table
  functions;
- remove the pvclock ifdef in the Xen headers;
- remove include linux/types.h from xen/interface/xen.h;
- replace pr_info with pr_debug in xen_guest_init;
- add a new patch to introduce xen_ulong_t and use it top replace all
  the occurences of unsigned long in the public Xen interface;
- explicitely size all the pointers to 64 bit on ARM, so that the
  hypercall ABI is "64 bit ready";
- clean up xenbus_init;
- make pci.o depend on CONFIG_PCI and acpi.o depend on CONFIG_ACPI;
- mark Xen guest support on ARM as EXPERIMENTAL;
- introduce GRANT_TABLE_PHYSADDR;
- remove unneeded initialization of boot_max_nr_grant_frames;
- add a new patch to clear IRQ_NOAUTOEN and IRQ_NOREQUEST in events.c;
- return -EINVAL from xen_remap_domain_mfn_range if
  auto_translated_physmap;
- retain binary compatibility in xen_add_to_physmap: use a union to
  introduce foreign_domid.


Shortlog and diffstat:

Stefano Stabellini (24):
      arm: initial Xen support
      xen/arm: hypercalls
      xen/arm: page.h definitions
      xen/arm: sync_bitops
      xen/arm: empty implementation of grant_table arch specific functions
      docs: Xen ARM DT bindings
      xen/arm: Xen detection and shared_info page mapping
      xen/arm: Introduce xen_pfn_t for pfn and mfn types
      xen/arm: Introduce xen_ulong_t for unsigned long
      xen/arm: compile and run xenbus
      xen: do not compile manage, balloon, pci, acpi, pcpu and cpu_hotplug on ARM
      xen/arm: introduce CONFIG_XEN on ARM
      xen/arm: get privilege status
      xen/arm: initialize grant_table on ARM
      xen/arm: receive Xen events on ARM
      xen: clear IRQ_NOAUTOEN and IRQ_NOREQUEST
      xen/arm: implement alloc/free_xenballooned_pages with alloc_pages/kfree
      xen: allow privcmd for HVM guests
      xen/arm: compile blkfront and blkback
      xen/arm: compile netback
      arm/v2m: initialize arch_timers even if v2m_timer is not present
      xen: missing includes
      xen: update xen_add_to_physmap interface
      MAINTAINERS: add myself as Xen ARM maintainer

 Documentation/devicetree/bindings/arm/xen.txt |   22 ++++
 MAINTAINERS                                   |    7 +
 arch/arm/Kconfig                              |   10 ++
 arch/arm/Makefile                             |    1 +
 arch/arm/include/asm/hypervisor.h             |    6 +
 arch/arm/include/asm/sync_bitops.h            |   27 ++++
 arch/arm/include/asm/xen/events.h             |   18 +++
 arch/arm/include/asm/xen/hypercall.h          |   69 ++++++++++
 arch/arm/include/asm/xen/hypervisor.h         |   19 +++
 arch/arm/include/asm/xen/interface.h          |   73 +++++++++++
 arch/arm/include/asm/xen/page.h               |   82 ++++++++++++
 arch/arm/mach-vexpress/v2m.c                  |   11 +-
 arch/arm/xen/Makefile                         |    1 +
 arch/arm/xen/enlighten.c                      |  168 +++++++++++++++++++++++++
 arch/arm/xen/grant-table.c                    |   53 ++++++++
 arch/arm/xen/hypercall.S                      |  106 ++++++++++++++++
 arch/ia64/include/asm/xen/interface.h         |    8 +-
 arch/x86/include/asm/xen/interface.h          |    8 ++
 arch/x86/xen/enlighten.c                      |    1 +
 arch/x86/xen/irq.c                            |    1 +
 arch/x86/xen/mmu.c                            |    3 +
 arch/x86/xen/xen-ops.h                        |    1 -
 drivers/block/xen-blkback/blkback.c           |    1 +
 drivers/net/xen-netback/netback.c             |    1 +
 drivers/net/xen-netfront.c                    |    1 +
 drivers/tty/hvc/hvc_xen.c                     |    2 +
 drivers/xen/Makefile                          |   13 ++-
 drivers/xen/events.c                          |   18 +++-
 drivers/xen/grant-table.c                     |    1 +
 drivers/xen/privcmd.c                         |    4 -
 drivers/xen/xenbus/xenbus_comms.c             |    2 +-
 drivers/xen/xenbus/xenbus_probe.c             |   62 +++++++---
 drivers/xen/xenbus/xenbus_probe_frontend.c    |    1 +
 drivers/xen/xenbus/xenbus_xs.c                |    3 +-
 include/xen/events.h                          |    2 +
 include/xen/interface/features.h              |    3 +
 include/xen/interface/grant_table.h           |    4 +-
 include/xen/interface/io/protocols.h          |    3 +
 include/xen/interface/memory.h                |   21 ++--
 include/xen/interface/physdev.h               |    2 +-
 include/xen/interface/platform.h              |    4 +-
 include/xen/interface/version.h               |    2 +-
 include/xen/interface/xen.h                   |    7 +-
 include/xen/privcmd.h                         |    3 +-
 include/xen/xen.h                             |    2 +-
 45 files changed, 796 insertions(+), 61 deletions(-)



A branch based on 3.6-rc5 is available here:

git://xenbits.xen.org/people/sstabellini/linux-pvhvm.git 3.6-rc5-arm-4


Cheers,

Stefano
--_004_alpineDEB20212081616185504850kaballukxensourcecom_
Content-Type: text/plain; charset="US-ASCII"; name="vexpress-v2m-rs1.dtsi"
Content-Transfer-Encoding: BASE64
Content-ID: <alpine.DEB.2.02.1209141210430.29232@kaball.uk.xensource.com>
Content-Description: 
Content-Disposition: attachment; filename="vexpress-v2m-rs1.dtsi"

LyoNCiAqIEFSTSBMdGQuIFZlcnNhdGlsZSBFeHByZXNzDQogKg0KICogTW90
aGVyYm9hcmQgRXhwcmVzcyB1QVRYDQogKiBWMk0tUDENCiAqDQogKiBIQkkt
MDE5MEQNCiAqDQogKiBSUzEgbWVtb3J5IG1hcCAoIkFSTSBDb3J0ZXgtQSBT
ZXJpZXMgbWVtb3J5IG1hcCIgaW4gdGhlIGJvYXJkJ3MNCiAqIFRlY2huaWNh
bCBSZWZlcmVuY2UgTWFudWFsKQ0KICoNCiAqIFdBUk5JTkchIFRoZSBoYXJk
d2FyZSBkZXNjcmliZWQgaW4gdGhpcyBmaWxlIGlzIGluZGVwZW5kZW50IGZy
b20gdGhlDQogKiBvcmlnaW5hbCB2YXJpYW50ICh2ZXhwcmVzcy12Mm0uZHRz
aSksIGJ1dCB0aGVyZSBpcyBhIHN0cm9uZw0KICogY29ycmVzcG9uZGVuY2Ug
YmV0d2VlbiB0aGUgdHdvIGNvbmZpZ3VyYXRpb25zLg0KICoNCiAqIFRBS0Ug
Q0FSRSBXSEVOIE1BSU5UQUlOSU5HIFRISVMgRklMRSBUTyBQUk9QQUdBVEUg
QU5ZIFJFTEVWQU5UDQogKiBDSEFOR0VTIFRPIHZleHByZXNzLXYybS5kdHNp
IQ0KICovDQoNCi8gew0KCWFsaWFzZXMgew0KCQlhcm0sdjJtX3RpbWVyID0g
JnYybV90aW1lcjAxOw0KCX07DQoNCgltb3RoZXJib2FyZCB7DQoJCWNvbXBh
dGlibGUgPSAic2ltcGxlLWJ1cyI7DQoJCWFybSx2Mm0tbWVtb3J5LW1hcCA9
ICJyczEiOw0KCQkjYWRkcmVzcy1jZWxscyA9IDwyPjsgLyogU01CIGNoaXBz
ZWxlY3QgbnVtYmVyIGFuZCBvZmZzZXQgKi8NCgkJI3NpemUtY2VsbHMgPSA8
MT47DQoJCSNpbnRlcnJ1cHQtY2VsbHMgPSA8MT47DQoNCgkJZmxhc2hAMCww
MDAwMDAwMCB7DQoJCQljb21wYXRpYmxlID0gImFybSx2ZXhwcmVzcy1mbGFz
aCIsICJjZmktZmxhc2giOw0KCQkJcmVnID0gPDAgMHgwMDAwMDAwMCAweDA0
MDAwMDAwPiwNCgkJCSAgICAgIDw0IDB4MDAwMDAwMDAgMHgwNDAwMDAwMD47
DQoJCQliYW5rLXdpZHRoID0gPDQ+Ow0KCQl9Ow0KDQoJCXBzcmFtQDEsMDAw
MDAwMDAgew0KCQkJY29tcGF0aWJsZSA9ICJhcm0sdmV4cHJlc3MtcHNyYW0i
LCAibXRkLXJhbSI7DQoJCQlyZWcgPSA8MSAweDAwMDAwMDAwIDB4MDIwMDAw
MDA+Ow0KCQkJYmFuay13aWR0aCA9IDw0PjsNCgkJfTsNCg0KCQl2cmFtQDIs
MDAwMDAwMDAgew0KCQkJY29tcGF0aWJsZSA9ICJhcm0sdmV4cHJlc3MtdnJh
bSI7DQoJCQlyZWcgPSA8MiAweDAwMDAwMDAwIDB4MDA4MDAwMDA+Ow0KCQl9
Ow0KDQoJCWV0aGVybmV0QDIsMDIwMDAwMDAgew0KCQkJY29tcGF0aWJsZSA9
ICJzbXNjLGxhbjkxYzExMSI7DQoJCQlyZWcgPSA8MiAweDAyMDAwMDAwIDB4
MTAwMDA+Ow0KCQkJaW50ZXJydXB0cyA9IDwxNT47DQoJCX07DQoNCgkJdXNi
QDIsMDMwMDAwMDAgew0KCQkJY29tcGF0aWJsZSA9ICJueHAsdXNiLWlzcDE3
NjEiOw0KCQkJcmVnID0gPDIgMHgwMzAwMDAwMCAweDIwMDAwPjsNCgkJCWlu
dGVycnVwdHMgPSA8MTY+Ow0KCQkJcG9ydDEtb3RnOw0KCQl9Ow0KDQoJCWlv
ZnBnYUAzLDAwMDAwMDAwIHsNCgkJCWNvbXBhdGlibGUgPSAiYXJtLGFtYmEt
YnVzIiwgInNpbXBsZS1idXMiOw0KCQkJI2FkZHJlc3MtY2VsbHMgPSA8MT47
DQoJCQkjc2l6ZS1jZWxscyA9IDwxPjsNCgkJCXJhbmdlcyA9IDwwIDMgMCAw
eDIwMDAwMD47DQoNCgkJCXN5c3JlZ0AwMTAwMDAgew0KCQkJCWNvbXBhdGli
bGUgPSAiYXJtLHZleHByZXNzLXN5c3JlZyI7DQoJCQkJcmVnID0gPDB4MDEw
MDAwIDB4MTAwMD47DQoJCQl9Ow0KDQoJCQlzeXNjdGxAMDIwMDAwIHsNCgkJ
CQljb21wYXRpYmxlID0gImFybSxzcDgxMCIsICJhcm0scHJpbWVjZWxsIjsN
CgkJCQlyZWcgPSA8MHgwMjAwMDAgMHgxMDAwPjsNCgkJCX07DQoNCgkJCS8q
IFBDSS1FIEkyQyBidXMgKi8NCgkJCXYybV9pMmNfcGNpZTogaTJjQDAzMDAw
MCB7DQoJCQkJY29tcGF0aWJsZSA9ICJhcm0sdmVyc2F0aWxlLWkyYyI7DQoJ
CQkJcmVnID0gPDB4MDMwMDAwIDB4MTAwMD47DQoNCgkJCQkjYWRkcmVzcy1j
ZWxscyA9IDwxPjsNCgkJCQkjc2l6ZS1jZWxscyA9IDwwPjsNCg0KCQkJCXBj
aWUtc3dpdGNoQDYwIHsNCgkJCQkJY29tcGF0aWJsZSA9ICJpZHQsODlocGVz
MzJoOCI7DQoJCQkJCXJlZyA9IDwweDYwPjsNCgkJCQl9Ow0KCQkJfTsNCg0K
CQkJYWFjaUAwNDAwMDAgew0KCQkJCWNvbXBhdGlibGUgPSAiYXJtLHBsMDQx
IiwgImFybSxwcmltZWNlbGwiOw0KCQkJCXJlZyA9IDwweDA0MDAwMCAweDEw
MDA+Ow0KCQkJCWludGVycnVwdHMgPSA8MTE+Ow0KCQkJfTsNCg0KCQkJbW1j
aUAwNTAwMDAgew0KCQkJCWNvbXBhdGlibGUgPSAiYXJtLHBsMTgwIiwgImFy
bSxwcmltZWNlbGwiOw0KCQkJCXJlZyA9IDwweDA1MDAwMCAweDEwMDA+Ow0K
CQkJCWludGVycnVwdHMgPSA8OSAxMD47DQoJCQl9Ow0KDQoJCQlrbWlAMDYw
MDAwIHsNCgkJCQljb21wYXRpYmxlID0gImFybSxwbDA1MCIsICJhcm0scHJp
bWVjZWxsIjsNCgkJCQlyZWcgPSA8MHgwNjAwMDAgMHgxMDAwPjsNCgkJCQlp
bnRlcnJ1cHRzID0gPDEyPjsNCgkJCX07DQoNCgkJCWttaUAwNzAwMDAgew0K
CQkJCWNvbXBhdGlibGUgPSAiYXJtLHBsMDUwIiwgImFybSxwcmltZWNlbGwi
Ow0KCQkJCXJlZyA9IDwweDA3MDAwMCAweDEwMDA+Ow0KCQkJCWludGVycnVw
dHMgPSA8MTM+Ow0KCQkJfTsNCg0KCQkJdjJtX3NlcmlhbDA6IHVhcnRAMDkw
MDAwIHsNCgkJCQljb21wYXRpYmxlID0gImFybSxwbDAxMSIsICJhcm0scHJp
bWVjZWxsIjsNCgkJCQlyZWcgPSA8MHgwOTAwMDAgMHgxMDAwPjsNCgkJCQlp
bnRlcnJ1cHRzID0gPDU+Ow0KCQkJfTsNCg0KCQkJdjJtX3NlcmlhbDE6IHVh
cnRAMGEwMDAwIHsNCgkJCQljb21wYXRpYmxlID0gImFybSxwbDAxMSIsICJh
cm0scHJpbWVjZWxsIjsNCgkJCQlyZWcgPSA8MHgwYTAwMDAgMHgxMDAwPjsN
CgkJCQlpbnRlcnJ1cHRzID0gPDY+Ow0KCQkJfTsNCg0KCQkJdjJtX3Nlcmlh
bDI6IHVhcnRAMGIwMDAwIHsNCgkJCQljb21wYXRpYmxlID0gImFybSxwbDAx
MSIsICJhcm0scHJpbWVjZWxsIjsNCgkJCQlyZWcgPSA8MHgwYjAwMDAgMHgx
MDAwPjsNCgkJCQlpbnRlcnJ1cHRzID0gPDc+Ow0KCQkJfTsNCg0KCQkJdjJt
X3NlcmlhbDM6IHVhcnRAMGMwMDAwIHsNCgkJCQljb21wYXRpYmxlID0gImFy
bSxwbDAxMSIsICJhcm0scHJpbWVjZWxsIjsNCgkJCQlyZWcgPSA8MHgwYzAw
MDAgMHgxMDAwPjsNCgkJCQlpbnRlcnJ1cHRzID0gPDg+Ow0KCQkJfTsNCg0K
CQkJd2R0QDBmMDAwMCB7DQoJCQkJY29tcGF0aWJsZSA9ICJhcm0sc3A4MDUi
LCAiYXJtLHByaW1lY2VsbCI7DQoJCQkJcmVnID0gPDB4MGYwMDAwIDB4MTAw
MD47DQoJCQkJaW50ZXJydXB0cyA9IDwwPjsNCgkJCX07DQoNCgkJCXYybV90
aW1lcjAxOiB0aW1lckAxMTAwMDAgew0KCQkJCWNvbXBhdGlibGUgPSAiYXJt
LHNwODA0IiwgImFybSxwcmltZWNlbGwiOw0KCQkJCXJlZyA9IDwweDExMDAw
MCAweDEwMDA+Ow0KCQkJCWludGVycnVwdHMgPSA8Mj47DQoJCQl9Ow0KDQoJ
CQl2Mm1fdGltZXIyMzogdGltZXJAMTIwMDAwIHsNCgkJCQljb21wYXRpYmxl
ID0gImFybSxzcDgwNCIsICJhcm0scHJpbWVjZWxsIjsNCgkJCQlyZWcgPSA8
MHgxMjAwMDAgMHgxMDAwPjsNCgkJCQlpbnRlcnJ1cHRzID0gPDM+Ow0KCQkJ
fTsNCg0KCQkJLyogRFZJIEkyQyBidXMgKi8NCgkJCXYybV9pMmNfZHZpOiBp
MmNAMTYwMDAwIHsNCgkJCQljb21wYXRpYmxlID0gImFybSx2ZXJzYXRpbGUt
aTJjIjsNCgkJCQlyZWcgPSA8MHgxNjAwMDAgMHgxMDAwPjsNCg0KCQkJCSNh
ZGRyZXNzLWNlbGxzID0gPDE+Ow0KCQkJCSNzaXplLWNlbGxzID0gPDA+Ow0K
DQoJCQkJZHZpLXRyYW5zbWl0dGVyQDM5IHsNCgkJCQkJY29tcGF0aWJsZSA9
ICJzaWwsc2lpOTAyMi10cGkiLCAic2lsLHNpaTkwMjIiOw0KCQkJCQlyZWcg
PSA8MHgzOT47DQoJCQkJfTsNCg0KCQkJCWR2aS10cmFuc21pdHRlckA2MCB7
DQoJCQkJCWNvbXBhdGlibGUgPSAic2lsLHNpaTkwMjItY3BpIiwgInNpbCxz
aWk5MDIyIjsNCgkJCQkJcmVnID0gPDB4NjA+Ow0KCQkJCX07DQoJCQl9Ow0K
DQoJCQlydGNAMTcwMDAwIHsNCgkJCQljb21wYXRpYmxlID0gImFybSxwbDAz
MSIsICJhcm0scHJpbWVjZWxsIjsNCgkJCQlyZWcgPSA8MHgxNzAwMDAgMHgx
MDAwPjsNCgkJCQlpbnRlcnJ1cHRzID0gPDQ+Ow0KCQkJfTsNCg0KCQkJY29t
cGFjdC1mbGFzaEAxYTAwMDAgew0KCQkJCWNvbXBhdGlibGUgPSAiYXJtLHZl
eHByZXNzLWNmIiwgImF0YS1nZW5lcmljIjsNCgkJCQlyZWcgPSA8MHgxYTAw
MDAgMHgxMDANCgkJCQkgICAgICAgMHgxYTAxMDAgMHhmMDA+Ow0KCQkJCXJl
Zy1zaGlmdCA9IDwyPjsNCgkJCX07DQoNCgkJCWNsY2RAMWYwMDAwIHsNCgkJ
CQljb21wYXRpYmxlID0gImFybSxwbDExMSIsICJhcm0scHJpbWVjZWxsIjsN
CgkJCQlyZWcgPSA8MHgxZjAwMDAgMHgxMDAwPjsNCgkJCQlpbnRlcnJ1cHRz
ID0gPDE0PjsNCgkJCX07DQoJCX07DQoNCgkJdjJtX2ZpeGVkXzN2MzogZml4
ZWRyZWd1bGF0b3JAMCB7DQoJCQljb21wYXRpYmxlID0gInJlZ3VsYXRvci1m
aXhlZCI7DQoJCQlyZWd1bGF0b3ItbmFtZSA9ICIzVjMiOw0KCQkJcmVndWxh
dG9yLW1pbi1taWNyb3ZvbHQgPSA8MzMwMDAwMD47DQoJCQlyZWd1bGF0b3It
bWF4LW1pY3Jvdm9sdCA9IDwzMzAwMDAwPjsNCgkJCXJlZ3VsYXRvci1hbHdh
eXMtb247DQoJCX07DQoJfTsNCn07DQo=

--_004_alpineDEB20212081616185504850kaballukxensourcecom_
Content-Type: text/plain; charset="US-ASCII"; name="vexpress-v2p-ca15-tc1.dts"
Content-Transfer-Encoding: BASE64
Content-ID: <alpine.DEB.2.02.1209141210431.29232@kaball.uk.xensource.com>
Content-Description: 
Content-Disposition: attachment; filename="vexpress-v2p-ca15-tc1.dts"

LyoNCiAqIEFSTSBMdGQuIFZlcnNhdGlsZSBFeHByZXNzDQogKg0KICogQ29y
ZVRpbGUgRXhwcmVzcyBBMTV4MiAodmVyc2lvbiB3aXRoIFRlc3QgQ2hpcCAx
KQ0KICogQ29ydGV4LUExNSBNUENvcmUgKFYyUC1DQTE1KQ0KICoNCiAqIEhC
SS0wMjM3QQ0KICovDQoNCi9kdHMtdjEvOw0KDQovIHsNCgltb2RlbCA9ICJW
MlAtQ0ExNSI7DQoJYXJtLGhiaSA9IDwweDIzNz47DQoJY29tcGF0aWJsZSA9
ICJhcm0sdmV4cHJlc3MsdjJwLWNhMTUsdGMxIiwgImFybSx2ZXhwcmVzcyx2
MnAtY2ExNSIsICJhcm0sdmV4cHJlc3MiOw0KCWludGVycnVwdC1wYXJlbnQg
PSA8JmdpYz47DQoJI2FkZHJlc3MtY2VsbHMgPSA8Mj47DQoJI3NpemUtY2Vs
bHMgPSA8Mj47DQoNCgljaG9zZW4gew0KICAgICAgICAgICAgICAgICBib290
YXJncyA9ICJkb20wX21lbT0xMjhNIjsNCiAgICAgICAgICAgICAgICAgeGVu
LGRvbTAtYm9vdGFyZ3MgPSAiZWFybHlwcmludGsgY29uc29sZT10dHlBTUEx
IHJvb3Q9L2Rldi9tbWNibGswIGRlYnVnIHJ3IjsNCgl9Ow0KDQoJYWxpYXNl
cyB7DQoJCXNlcmlhbDAgPSAmdjJtX3NlcmlhbDA7DQoJCXNlcmlhbDEgPSAm
djJtX3NlcmlhbDE7DQoJCXNlcmlhbDIgPSAmdjJtX3NlcmlhbDI7DQoJCXNl
cmlhbDMgPSAmdjJtX3NlcmlhbDM7DQoJCWkyYzAgPSAmdjJtX2kyY19kdmk7
DQoJCWkyYzEgPSAmdjJtX2kyY19wY2llOw0KCX07DQoNCgljcHVzIHsNCgkJ
I2FkZHJlc3MtY2VsbHMgPSA8MT47DQoJCSNzaXplLWNlbGxzID0gPDA+Ow0K
DQoJCWNwdUAwIHsNCgkJCWRldmljZV90eXBlID0gImNwdSI7DQoJCQljb21w
YXRpYmxlID0gImFybSxjb3J0ZXgtYTE1IjsNCgkJCXJlZyA9IDwwPjsNCgkJ
fTsNCgl9Ow0KDQoJbWVtb3J5QDgwMDAwMDAwIHsNCgkJZGV2aWNlX3R5cGUg
PSAibWVtb3J5IjsNCgkJcmVnID0gPDAgMHg4MDAwMDAwMCAwIDB4ODAwMDAw
MDA+Ow0KCX07DQoNCglnaWM6IGludGVycnVwdC1jb250cm9sbGVyQDJjMDAx
MDAwIHsNCgkJY29tcGF0aWJsZSA9ICJhcm0sY29ydGV4LWExNS1naWMiLCAi
YXJtLGNvcnRleC1hOS1naWMiOw0KCQkjaW50ZXJydXB0LWNlbGxzID0gPDM+
Ow0KCQkjYWRkcmVzcy1jZWxscyA9IDwwPjsNCgkJaW50ZXJydXB0LWNvbnRy
b2xsZXI7DQoJCXJlZyA9IDwwIDB4MmMwMDEwMDAgMCAweDEwMDA+LA0KCQkg
ICAgICA8MCAweDJjMDAyMDAwIDAgMHgxMDAwPiwNCgkJICAgICAgPDAgMHgy
YzAwNDAwMCAwIDB4MjAwMD4sDQoJCSAgICAgIDwwIDB4MmMwMDYwMDAgMCAw
eDIwMDA+Ow0KCQlpbnRlcnJ1cHRzID0gPDEgOSAweGYwND47DQoJfTsNCg0K
CXRpbWVyIHsNCgkJY29tcGF0aWJsZSA9ICJhcm0sYXJtdjctdGltZXIiOw0K
CQlpbnRlcnJ1cHRzID0gPDEgMTMgMHhmMDg+LA0KCQkJICAgICA8MSAxNCAw
eGYwOD4sDQoJCQkgICAgIDwxIDExIDB4ZjA4PiwNCgkJCSAgICAgPDEgMTAg
MHhmMDg+Ow0KCX07DQoNCglwbXUgew0KCQljb21wYXRpYmxlID0gImFybSxj
b3J0ZXgtYTE1LXBtdSIsICJhcm0sY29ydGV4LWE5LXBtdSI7DQoJCWludGVy
cnVwdHMgPSA8MCA2OCA0PiwNCgkJCSAgICAgPDAgNjkgND47DQoJfTsNCg0K
CWh5cGVydmlzb3Igew0KCQljb21wYXRpYmxlID0gInhlbix4ZW4tNC4yIiwg
Inhlbix4ZW4iOw0KCQlyZWcgPSA8MCAweGIwMDAwMDAwIDAgMHgyMDAwMD47
DQoJCWludGVycnVwdHMgPSA8MSAxNSAweGYwOD47DQoJfTsNCg0KCW1vdGhl
cmJvYXJkIHsNCgkJcmFuZ2VzID0gPDAgMCAwIDB4MDgwMDAwMDAgMHgwNDAw
MDAwMD4sDQoJCQkgPDEgMCAwIDB4MTQwMDAwMDAgMHgwNDAwMDAwMD4sDQoJ
CQkgPDIgMCAwIDB4MTgwMDAwMDAgMHgwNDAwMDAwMD4sDQoJCQkgPDMgMCAw
IDB4MWMwMDAwMDAgMHgwNDAwMDAwMD4sDQoJCQkgPDQgMCAwIDB4MGMwMDAw
MDAgMHgwNDAwMDAwMD4sDQoJCQkgPDUgMCAwIDB4MTAwMDAwMDAgMHgwNDAw
MDAwMD47DQoNCgkJaW50ZXJydXB0LW1hcC1tYXNrID0gPDAgMCA2Mz47DQoJ
CWludGVycnVwdC1tYXAgPSA8MCAwICAwICZnaWMgMCAgMCA0PiwNCgkJCQk8
MCAwICAxICZnaWMgMCAgMSA0PiwNCgkJCQk8MCAwICAyICZnaWMgMCAgMiA0
PiwNCgkJCQk8MCAwICAzICZnaWMgMCAgMyA0PiwNCgkJCQk8MCAwICA0ICZn
aWMgMCAgNCA0PiwNCgkJCQk8MCAwICA1ICZnaWMgMCAgNSA0PiwNCgkJCQk8
MCAwICA2ICZnaWMgMCAgNiA0PiwNCgkJCQk8MCAwICA3ICZnaWMgMCAgNyA0
PiwNCgkJCQk8MCAwICA4ICZnaWMgMCAgOCA0PiwNCgkJCQk8MCAwICA5ICZn
aWMgMCAgOSA0PiwNCgkJCQk8MCAwIDEwICZnaWMgMCAxMCA0PiwNCgkJCQk8
MCAwIDExICZnaWMgMCAxMSA0PiwNCgkJCQk8MCAwIDEyICZnaWMgMCAxMiA0
PiwNCgkJCQk8MCAwIDEzICZnaWMgMCAxMyA0PiwNCgkJCQk8MCAwIDE0ICZn
aWMgMCAxNCA0PiwNCgkJCQk8MCAwIDE1ICZnaWMgMCAxNSA0PiwNCgkJCQk8
MCAwIDE2ICZnaWMgMCAxNiA0PiwNCgkJCQk8MCAwIDE3ICZnaWMgMCAxNyA0
PiwNCgkJCQk8MCAwIDE4ICZnaWMgMCAxOCA0PiwNCgkJCQk8MCAwIDE5ICZn
aWMgMCAxOSA0PiwNCgkJCQk8MCAwIDIwICZnaWMgMCAyMCA0PiwNCgkJCQk8
MCAwIDIxICZnaWMgMCAyMSA0PiwNCgkJCQk8MCAwIDIyICZnaWMgMCAyMiA0
PiwNCgkJCQk8MCAwIDIzICZnaWMgMCAyMyA0PiwNCgkJCQk8MCAwIDI0ICZn
aWMgMCAyNCA0PiwNCgkJCQk8MCAwIDI1ICZnaWMgMCAyNSA0PiwNCgkJCQk8
MCAwIDI2ICZnaWMgMCAyNiA0PiwNCgkJCQk8MCAwIDI3ICZnaWMgMCAyNyA0
PiwNCgkJCQk8MCAwIDI4ICZnaWMgMCAyOCA0PiwNCgkJCQk8MCAwIDI5ICZn
aWMgMCAyOSA0PiwNCgkJCQk8MCAwIDMwICZnaWMgMCAzMCA0PiwNCgkJCQk8
MCAwIDMxICZnaWMgMCAzMSA0PiwNCgkJCQk8MCAwIDMyICZnaWMgMCAzMiA0
PiwNCgkJCQk8MCAwIDMzICZnaWMgMCAzMyA0PiwNCgkJCQk8MCAwIDM0ICZn
aWMgMCAzNCA0PiwNCgkJCQk8MCAwIDM1ICZnaWMgMCAzNSA0PiwNCgkJCQk8
MCAwIDM2ICZnaWMgMCAzNiA0PiwNCgkJCQk8MCAwIDM3ICZnaWMgMCAzNyA0
PiwNCgkJCQk8MCAwIDM4ICZnaWMgMCAzOCA0PiwNCgkJCQk8MCAwIDM5ICZn
aWMgMCAzOSA0PiwNCgkJCQk8MCAwIDQwICZnaWMgMCA0MCA0PiwNCgkJCQk8
MCAwIDQxICZnaWMgMCA0MSA0PiwNCgkJCQk8MCAwIDQyICZnaWMgMCA0MiA0
PjsNCgl9Ow0KfTsNCg0KL2luY2x1ZGUvICJ2ZXhwcmVzcy12Mm0tcnMxLmR0
c2kiDQo=

--_004_alpineDEB20212081616185504850kaballukxensourcecom_
Content-Type: text/plain; charset="US-ASCII"; name="vexpress-virt.dts"
Content-Transfer-Encoding: BASE64
Content-ID: <alpine.DEB.2.02.1209141210432.29232@kaball.uk.xensource.com>
Content-Description: 
Content-Disposition: attachment; filename="vexpress-virt.dts"

LyoNCiAqIEFSTSBMdGQuIFZlcnNhdGlsZSBFeHByZXNzDQogKg0KICogQVJN
IEVudmVsb3BlIE1vZGVsIHY3QSAoc2luZ2xlIENQVSkuDQogKi8NCg0KL2R0
cy12MS87DQoNCi9pbmNsdWRlLyAic2tlbGV0b24uZHRzaSINCg0KLyB7DQoJ
bW9kZWwgPSAiVjJQLUFFTXY3QSI7DQoJY29tcGF0aWJsZSA9ICJhcm0sdmV4
cHJlc3MsdjJwLWFlbSx2N2EiLCAiYXJtLHZleHByZXNzLHYycC1hZW0iLCAi
YXJtLHZleHByZXNzIjsNCglpbnRlcnJ1cHQtcGFyZW50ID0gPCZnaWM+Ow0K
DQogICAgICAgIGNob3NlbiB7DQogICAgICAgICAgICAgICAgYm9vdGFyZ3Mg
PSAiZWFybHlwcmludGsgZGVidWcgbG9nbGV2ZWw9OSBjb25zb2xlPWh2YzAg
cm9vdD0vZGV2L3h2ZGEgaW5pdD0vc2Jpbi9pbml0IjsNCiAgICAgICAgfTsN
Cg0KCWNwdXMgew0KCQkjYWRkcmVzcy1jZWxscyA9IDwxPjsNCgkJI3NpemUt
Y2VsbHMgPSA8MD47DQoNCgkJY3B1QDAgew0KCQkJZGV2aWNlX3R5cGUgPSAi
Y3B1IjsNCgkJCWNvbXBhdGlibGUgPSAiYXJtLGNvcnRleC1hMTUiOw0KCQkJ
cmVnID0gPDA+Ow0KCQl9Ow0KCX07DQoNCgltZW1vcnkgew0KCQlkZXZpY2Vf
dHlwZSA9ICJtZW1vcnkiOw0KCQlyZWcgPSA8MHg4MDAwMDAwMCAweDA4MDAw
MDAwPjsNCgl9Ow0KDQoJZ2ljOiBpbnRlcnJ1cHQtY29udHJvbGxlckAyYzAw
MTAwMCB7DQoJCWNvbXBhdGlibGUgPSAiYXJtLGNvcnRleC1hOS1naWMiOw0K
CQkjaW50ZXJydXB0LWNlbGxzID0gPDM+Ow0KCQkjYWRkcmVzcy1jZWxscyA9
IDwwPjsNCgkJaW50ZXJydXB0LWNvbnRyb2xsZXI7DQoJCXJlZyA9IDwweDJj
MDAxMDAwIDB4MTAwMD4sDQoJCSAgICAgIDwweDJjMDAyMDAwIDB4MTAwPjsN
Cgl9Ow0KDQoJdGltZXIgew0KCQljb21wYXRpYmxlID0gImFybSxhcm12Ny10
aW1lciI7DQoJCWludGVycnVwdHMgPSA8MSAxMyAweGYwOD4sDQoJCQkgICAg
IDwxIDE0IDB4ZjA4PiwNCgkJCSAgICAgPDEgMTEgMHhmMDg+LA0KCQkJICAg
ICA8MSAxMCAweGYwOD47DQoJfTsNCg0KCWh5cGVydmlzb3Igew0KCQljb21w
YXRpYmxlID0gInhlbix4ZW4tNC4yIiwgInhlbix4ZW4iOw0KCQlyZWcgPSA8
MHhiMDAwMDAwMCAweDIwMDAwPjsNCgkJaW50ZXJydXB0cyA9IDwxIDE1IDB4
ZjA4PjsNCgl9Ow0KDQoJbW90aGVyYm9hcmQgew0KCQlhcm0sdjJtLW1lbW9y
eS1tYXAgPSAicnMxIjsNCgkJcmFuZ2VzID0gPDAgMCAweDA4MDAwMDAwIDB4
MDQwMDAwMDA+LA0KCQkJIDwxIDAgMHgxNDAwMDAwMCAweDA0MDAwMDAwPiwN
CgkJCSA8MiAwIDB4MTgwMDAwMDAgMHgwNDAwMDAwMD4sDQoJCQkgPDMgMCAw
eDFjMDAwMDAwIDB4MDQwMDAwMDA+LA0KCQkJIDw0IDAgMHgwYzAwMDAwMCAw
eDA0MDAwMDAwPiwNCgkJCSA8NSAwIDB4MTAwMDAwMDAgMHgwNDAwMDAwMD47
DQoNCgkJaW50ZXJydXB0LW1hcC1tYXNrID0gPDAgMCA2Mz47DQoJCWludGVy
cnVwdC1tYXAgPSA8MCAwICAwICZnaWMgMCAgMCA0PiwNCgkJCQk8MCAwICAx
ICZnaWMgMCAgMSA0PiwNCgkJCQk8MCAwICAyICZnaWMgMCAgMiA0PiwNCgkJ
CQk8MCAwICAzICZnaWMgMCAgMyA0PiwNCgkJCQk8MCAwICA0ICZnaWMgMCAg
NCA0PiwNCgkJCQk8MCAwICA1ICZnaWMgMCAgNSA0PiwNCgkJCQk8MCAwICA2
ICZnaWMgMCAgNiA0PiwNCgkJCQk8MCAwICA3ICZnaWMgMCAgNyA0PiwNCgkJ
CQk8MCAwICA4ICZnaWMgMCAgOCA0PiwNCgkJCQk8MCAwICA5ICZnaWMgMCAg
OSA0PiwNCgkJCQk8MCAwIDEwICZnaWMgMCAxMCA0PiwNCgkJCQk8MCAwIDEx
ICZnaWMgMCAxMSA0PiwNCgkJCQk8MCAwIDEyICZnaWMgMCAxMiA0PiwNCgkJ
CQk8MCAwIDEzICZnaWMgMCAxMyA0PiwNCgkJCQk8MCAwIDE0ICZnaWMgMCAx
NCA0PiwNCgkJCQk8MCAwIDE1ICZnaWMgMCAxNSA0PiwNCgkJCQk8MCAwIDE2
ICZnaWMgMCAxNiA0PiwNCgkJCQk8MCAwIDE3ICZnaWMgMCAxNyA0PiwNCgkJ
CQk8MCAwIDE4ICZnaWMgMCAxOCA0PiwNCgkJCQk8MCAwIDE5ICZnaWMgMCAx
OSA0PiwNCgkJCQk8MCAwIDIwICZnaWMgMCAyMCA0PiwNCgkJCQk8MCAwIDIx
ICZnaWMgMCAyMSA0PiwNCgkJCQk8MCAwIDIyICZnaWMgMCAyMiA0PiwNCgkJ
CQk8MCAwIDIzICZnaWMgMCAyMyA0PiwNCgkJCQk8MCAwIDI0ICZnaWMgMCAy
NCA0PiwNCgkJCQk8MCAwIDI1ICZnaWMgMCAyNSA0PiwNCgkJCQk8MCAwIDI2
ICZnaWMgMCAyNiA0PiwNCgkJCQk8MCAwIDI3ICZnaWMgMCAyNyA0PiwNCgkJ
CQk8MCAwIDI4ICZnaWMgMCAyOCA0PiwNCgkJCQk8MCAwIDI5ICZnaWMgMCAy
OSA0PiwNCgkJCQk8MCAwIDMwICZnaWMgMCAzMCA0PiwNCgkJCQk8MCAwIDMx
ICZnaWMgMCAzMSA0PiwNCgkJCQk8MCAwIDMyICZnaWMgMCAzMiA0PiwNCgkJ
CQk8MCAwIDMzICZnaWMgMCAzMyA0PiwNCgkJCQk8MCAwIDM0ICZnaWMgMCAz
NCA0PiwNCgkJCQk8MCAwIDM1ICZnaWMgMCAzNSA0PiwNCgkJCQk8MCAwIDM2
ICZnaWMgMCAzNiA0PiwNCgkJCQk8MCAwIDM3ICZnaWMgMCAzNyA0PiwNCgkJ
CQk8MCAwIDM4ICZnaWMgMCAzOCA0PiwNCgkJCQk8MCAwIDM5ICZnaWMgMCAz
OSA0PiwNCgkJCQk8MCAwIDQwICZnaWMgMCA0MCA0PiwNCgkJCQk8MCAwIDQx
ICZnaWMgMCA0MSA0PiwNCgkJCQk8MCAwIDQyICZnaWMgMCA0MiA0PjsNCgl9
Ow0KfTsNCg0KLyogL2luY2x1ZGUvICJ2ZXhwcmVzcy12Mm0tcnMxLXJ0c20u
ZHRzaSIgKi8NCg==

--_004_alpineDEB20212081616185504850kaballukxensourcecom_--
