Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756922Ab2IQRiV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 13:38:21 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:49693 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754774Ab2IQRiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 13:38:04 -0400
X-IronPort-AV: E=Sophos;i="4.80,437,1344211200"; 
   d="dts'?dtsi'?scan'208";a="14587634"
Date: Mon, 17 Sep 2012 18:37:08 +0100
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
        "arnd@arndb.de" <arnd@arndb.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: [PATCH v5 00/17] Introduce Xen support on ARM (based on 3.6-rc5)
Message-ID: <alpine.DEB.2.02.1209171215490.29232@kaball.uk.xensource.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_004_alpineDEB202120914114515029232kaballukxensourcecom_"
Content-ID: <alpine.DEB.2.02.1209171215491.29232@kaball.uk.xensource.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_004_alpineDEB202120914114515029232kaballukxensourcecom_
Content-Type: text/plain; charset="US-ASCII"
Content-ID: <alpine.DEB.2.02.1209171215492.29232@kaball.uk.xensource.com>

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



The patch series has been rebased on Konrad's stable/for-linus-3.7
branch.

Arnd, Russell, what do you think about this series? If you are OK with
it, to whom should I submit it?



Changes in v5:
- rebase on Konrad's stable/for-linus-3.7;
- add a comment about the size of the grant table memory region in the
  device tree documentation;
- add a comment about the required presence of a GIC node in the device
  tree documentation;
- specify that the described properties are part of a top-level
  "hypervisor" node in the device tree documentation;
- specify #address-cells and #size-cells for the device tree example;
- make XEN_DOM0 depend on XEN;
- avoid "select XEN_DOM0" in XEN.


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

Stefano Stabellini (17):
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

 Documentation/devicetree/bindings/arm/xen.txt |   25 ++++
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
 drivers/xen/Makefile                          |   13 ++-
 drivers/xen/events.c                          |   17 ++-
 include/xen/events.h                          |    2 +
 include/xen/interface/features.h              |    3 +
 include/xen/interface/io/protocols.h          |    3 +
 include/xen/interface/memory.h                |   12 +-
 include/xen/interface/physdev.h               |    2 +-
 include/xen/interface/version.h               |    2 +-
 include/xen/xen.h                             |    2 +-
 32 files changed, 712 insertions(+), 17 deletions(-)


A branch based on 3.6-rc5 and Konrad's stable/for-linus-3.7 is available
here:

git://xenbits.xen.org/people/sstabellini/linux-pvhvm.git 3.6-rc5-arm-5


Cheers,

Stefano
--_004_alpineDEB202120914114515029232kaballukxensourcecom_
Content-Type: text/plain; name="vexpress-v2m-rs1.dtsi"
Content-Transfer-Encoding: BASE64
Content-ID: <alpine.DEB.2.02.1209141210430.29232@kaball.uk.xensource.com>
Content-Description: vexpress-v2m-rs1.dtsi
Content-Disposition: attachment; filename="vexpress-v2m-rs1.dtsi"; size=4677;
	creation-date="Fri, 14 Sep 2012 11:13:42 GMT";
	modification-date="Fri, 14 Sep 2012 11:13:42 GMT"

LyoNCiAqIEFSTSBMdGQuIFZlcnNhdGlsZSBFeHByZXNzDQogKg0KICogTW90aGVyYm9hcmQgRXhw
cmVzcyB1QVRYDQogKiBWMk0tUDENCiAqDQogKiBIQkktMDE5MEQNCiAqDQogKiBSUzEgbWVtb3J5
IG1hcCAoIkFSTSBDb3J0ZXgtQSBTZXJpZXMgbWVtb3J5IG1hcCIgaW4gdGhlIGJvYXJkJ3MNCiAq
IFRlY2huaWNhbCBSZWZlcmVuY2UgTWFudWFsKQ0KICoNCiAqIFdBUk5JTkchIFRoZSBoYXJkd2Fy
ZSBkZXNjcmliZWQgaW4gdGhpcyBmaWxlIGlzIGluZGVwZW5kZW50IGZyb20gdGhlDQogKiBvcmln
aW5hbCB2YXJpYW50ICh2ZXhwcmVzcy12Mm0uZHRzaSksIGJ1dCB0aGVyZSBpcyBhIHN0cm9uZw0K
ICogY29ycmVzcG9uZGVuY2UgYmV0d2VlbiB0aGUgdHdvIGNvbmZpZ3VyYXRpb25zLg0KICoNCiAq
IFRBS0UgQ0FSRSBXSEVOIE1BSU5UQUlOSU5HIFRISVMgRklMRSBUTyBQUk9QQUdBVEUgQU5ZIFJF
TEVWQU5UDQogKiBDSEFOR0VTIFRPIHZleHByZXNzLXYybS5kdHNpIQ0KICovDQoNCi8gew0KCWFs
aWFzZXMgew0KCQlhcm0sdjJtX3RpbWVyID0gJnYybV90aW1lcjAxOw0KCX07DQoNCgltb3RoZXJi
b2FyZCB7DQoJCWNvbXBhdGlibGUgPSAic2ltcGxlLWJ1cyI7DQoJCWFybSx2Mm0tbWVtb3J5LW1h
cCA9ICJyczEiOw0KCQkjYWRkcmVzcy1jZWxscyA9IDwyPjsgLyogU01CIGNoaXBzZWxlY3QgbnVt
YmVyIGFuZCBvZmZzZXQgKi8NCgkJI3NpemUtY2VsbHMgPSA8MT47DQoJCSNpbnRlcnJ1cHQtY2Vs
bHMgPSA8MT47DQoNCgkJZmxhc2hAMCwwMDAwMDAwMCB7DQoJCQljb21wYXRpYmxlID0gImFybSx2
ZXhwcmVzcy1mbGFzaCIsICJjZmktZmxhc2giOw0KCQkJcmVnID0gPDAgMHgwMDAwMDAwMCAweDA0
MDAwMDAwPiwNCgkJCSAgICAgIDw0IDB4MDAwMDAwMDAgMHgwNDAwMDAwMD47DQoJCQliYW5rLXdp
ZHRoID0gPDQ+Ow0KCQl9Ow0KDQoJCXBzcmFtQDEsMDAwMDAwMDAgew0KCQkJY29tcGF0aWJsZSA9
ICJhcm0sdmV4cHJlc3MtcHNyYW0iLCAibXRkLXJhbSI7DQoJCQlyZWcgPSA8MSAweDAwMDAwMDAw
IDB4MDIwMDAwMDA+Ow0KCQkJYmFuay13aWR0aCA9IDw0PjsNCgkJfTsNCg0KCQl2cmFtQDIsMDAw
MDAwMDAgew0KCQkJY29tcGF0aWJsZSA9ICJhcm0sdmV4cHJlc3MtdnJhbSI7DQoJCQlyZWcgPSA8
MiAweDAwMDAwMDAwIDB4MDA4MDAwMDA+Ow0KCQl9Ow0KDQoJCWV0aGVybmV0QDIsMDIwMDAwMDAg
ew0KCQkJY29tcGF0aWJsZSA9ICJzbXNjLGxhbjkxYzExMSI7DQoJCQlyZWcgPSA8MiAweDAyMDAw
MDAwIDB4MTAwMDA+Ow0KCQkJaW50ZXJydXB0cyA9IDwxNT47DQoJCX07DQoNCgkJdXNiQDIsMDMw
MDAwMDAgew0KCQkJY29tcGF0aWJsZSA9ICJueHAsdXNiLWlzcDE3NjEiOw0KCQkJcmVnID0gPDIg
MHgwMzAwMDAwMCAweDIwMDAwPjsNCgkJCWludGVycnVwdHMgPSA8MTY+Ow0KCQkJcG9ydDEtb3Rn
Ow0KCQl9Ow0KDQoJCWlvZnBnYUAzLDAwMDAwMDAwIHsNCgkJCWNvbXBhdGlibGUgPSAiYXJtLGFt
YmEtYnVzIiwgInNpbXBsZS1idXMiOw0KCQkJI2FkZHJlc3MtY2VsbHMgPSA8MT47DQoJCQkjc2l6
ZS1jZWxscyA9IDwxPjsNCgkJCXJhbmdlcyA9IDwwIDMgMCAweDIwMDAwMD47DQoNCgkJCXN5c3Jl
Z0AwMTAwMDAgew0KCQkJCWNvbXBhdGlibGUgPSAiYXJtLHZleHByZXNzLXN5c3JlZyI7DQoJCQkJ
cmVnID0gPDB4MDEwMDAwIDB4MTAwMD47DQoJCQl9Ow0KDQoJCQlzeXNjdGxAMDIwMDAwIHsNCgkJ
CQljb21wYXRpYmxlID0gImFybSxzcDgxMCIsICJhcm0scHJpbWVjZWxsIjsNCgkJCQlyZWcgPSA8
MHgwMjAwMDAgMHgxMDAwPjsNCgkJCX07DQoNCgkJCS8qIFBDSS1FIEkyQyBidXMgKi8NCgkJCXYy
bV9pMmNfcGNpZTogaTJjQDAzMDAwMCB7DQoJCQkJY29tcGF0aWJsZSA9ICJhcm0sdmVyc2F0aWxl
LWkyYyI7DQoJCQkJcmVnID0gPDB4MDMwMDAwIDB4MTAwMD47DQoNCgkJCQkjYWRkcmVzcy1jZWxs
cyA9IDwxPjsNCgkJCQkjc2l6ZS1jZWxscyA9IDwwPjsNCg0KCQkJCXBjaWUtc3dpdGNoQDYwIHsN
CgkJCQkJY29tcGF0aWJsZSA9ICJpZHQsODlocGVzMzJoOCI7DQoJCQkJCXJlZyA9IDwweDYwPjsN
CgkJCQl9Ow0KCQkJfTsNCg0KCQkJYWFjaUAwNDAwMDAgew0KCQkJCWNvbXBhdGlibGUgPSAiYXJt
LHBsMDQxIiwgImFybSxwcmltZWNlbGwiOw0KCQkJCXJlZyA9IDwweDA0MDAwMCAweDEwMDA+Ow0K
CQkJCWludGVycnVwdHMgPSA8MTE+Ow0KCQkJfTsNCg0KCQkJbW1jaUAwNTAwMDAgew0KCQkJCWNv
bXBhdGlibGUgPSAiYXJtLHBsMTgwIiwgImFybSxwcmltZWNlbGwiOw0KCQkJCXJlZyA9IDwweDA1
MDAwMCAweDEwMDA+Ow0KCQkJCWludGVycnVwdHMgPSA8OSAxMD47DQoJCQl9Ow0KDQoJCQlrbWlA
MDYwMDAwIHsNCgkJCQljb21wYXRpYmxlID0gImFybSxwbDA1MCIsICJhcm0scHJpbWVjZWxsIjsN
CgkJCQlyZWcgPSA8MHgwNjAwMDAgMHgxMDAwPjsNCgkJCQlpbnRlcnJ1cHRzID0gPDEyPjsNCgkJ
CX07DQoNCgkJCWttaUAwNzAwMDAgew0KCQkJCWNvbXBhdGlibGUgPSAiYXJtLHBsMDUwIiwgImFy
bSxwcmltZWNlbGwiOw0KCQkJCXJlZyA9IDwweDA3MDAwMCAweDEwMDA+Ow0KCQkJCWludGVycnVw
dHMgPSA8MTM+Ow0KCQkJfTsNCg0KCQkJdjJtX3NlcmlhbDA6IHVhcnRAMDkwMDAwIHsNCgkJCQlj
b21wYXRpYmxlID0gImFybSxwbDAxMSIsICJhcm0scHJpbWVjZWxsIjsNCgkJCQlyZWcgPSA8MHgw
OTAwMDAgMHgxMDAwPjsNCgkJCQlpbnRlcnJ1cHRzID0gPDU+Ow0KCQkJfTsNCg0KCQkJdjJtX3Nl
cmlhbDE6IHVhcnRAMGEwMDAwIHsNCgkJCQljb21wYXRpYmxlID0gImFybSxwbDAxMSIsICJhcm0s
cHJpbWVjZWxsIjsNCgkJCQlyZWcgPSA8MHgwYTAwMDAgMHgxMDAwPjsNCgkJCQlpbnRlcnJ1cHRz
ID0gPDY+Ow0KCQkJfTsNCg0KCQkJdjJtX3NlcmlhbDI6IHVhcnRAMGIwMDAwIHsNCgkJCQljb21w
YXRpYmxlID0gImFybSxwbDAxMSIsICJhcm0scHJpbWVjZWxsIjsNCgkJCQlyZWcgPSA8MHgwYjAw
MDAgMHgxMDAwPjsNCgkJCQlpbnRlcnJ1cHRzID0gPDc+Ow0KCQkJfTsNCg0KCQkJdjJtX3Nlcmlh
bDM6IHVhcnRAMGMwMDAwIHsNCgkJCQljb21wYXRpYmxlID0gImFybSxwbDAxMSIsICJhcm0scHJp
bWVjZWxsIjsNCgkJCQlyZWcgPSA8MHgwYzAwMDAgMHgxMDAwPjsNCgkJCQlpbnRlcnJ1cHRzID0g
PDg+Ow0KCQkJfTsNCg0KCQkJd2R0QDBmMDAwMCB7DQoJCQkJY29tcGF0aWJsZSA9ICJhcm0sc3A4
MDUiLCAiYXJtLHByaW1lY2VsbCI7DQoJCQkJcmVnID0gPDB4MGYwMDAwIDB4MTAwMD47DQoJCQkJ
aW50ZXJydXB0cyA9IDwwPjsNCgkJCX07DQoNCgkJCXYybV90aW1lcjAxOiB0aW1lckAxMTAwMDAg
ew0KCQkJCWNvbXBhdGlibGUgPSAiYXJtLHNwODA0IiwgImFybSxwcmltZWNlbGwiOw0KCQkJCXJl
ZyA9IDwweDExMDAwMCAweDEwMDA+Ow0KCQkJCWludGVycnVwdHMgPSA8Mj47DQoJCQl9Ow0KDQoJ
CQl2Mm1fdGltZXIyMzogdGltZXJAMTIwMDAwIHsNCgkJCQljb21wYXRpYmxlID0gImFybSxzcDgw
NCIsICJhcm0scHJpbWVjZWxsIjsNCgkJCQlyZWcgPSA8MHgxMjAwMDAgMHgxMDAwPjsNCgkJCQlp
bnRlcnJ1cHRzID0gPDM+Ow0KCQkJfTsNCg0KCQkJLyogRFZJIEkyQyBidXMgKi8NCgkJCXYybV9p
MmNfZHZpOiBpMmNAMTYwMDAwIHsNCgkJCQljb21wYXRpYmxlID0gImFybSx2ZXJzYXRpbGUtaTJj
IjsNCgkJCQlyZWcgPSA8MHgxNjAwMDAgMHgxMDAwPjsNCg0KCQkJCSNhZGRyZXNzLWNlbGxzID0g
PDE+Ow0KCQkJCSNzaXplLWNlbGxzID0gPDA+Ow0KDQoJCQkJZHZpLXRyYW5zbWl0dGVyQDM5IHsN
CgkJCQkJY29tcGF0aWJsZSA9ICJzaWwsc2lpOTAyMi10cGkiLCAic2lsLHNpaTkwMjIiOw0KCQkJ
CQlyZWcgPSA8MHgzOT47DQoJCQkJfTsNCg0KCQkJCWR2aS10cmFuc21pdHRlckA2MCB7DQoJCQkJ
CWNvbXBhdGlibGUgPSAic2lsLHNpaTkwMjItY3BpIiwgInNpbCxzaWk5MDIyIjsNCgkJCQkJcmVn
ID0gPDB4NjA+Ow0KCQkJCX07DQoJCQl9Ow0KDQoJCQlydGNAMTcwMDAwIHsNCgkJCQljb21wYXRp
YmxlID0gImFybSxwbDAzMSIsICJhcm0scHJpbWVjZWxsIjsNCgkJCQlyZWcgPSA8MHgxNzAwMDAg
MHgxMDAwPjsNCgkJCQlpbnRlcnJ1cHRzID0gPDQ+Ow0KCQkJfTsNCg0KCQkJY29tcGFjdC1mbGFz
aEAxYTAwMDAgew0KCQkJCWNvbXBhdGlibGUgPSAiYXJtLHZleHByZXNzLWNmIiwgImF0YS1nZW5l
cmljIjsNCgkJCQlyZWcgPSA8MHgxYTAwMDAgMHgxMDANCgkJCQkgICAgICAgMHgxYTAxMDAgMHhm
MDA+Ow0KCQkJCXJlZy1zaGlmdCA9IDwyPjsNCgkJCX07DQoNCgkJCWNsY2RAMWYwMDAwIHsNCgkJ
CQljb21wYXRpYmxlID0gImFybSxwbDExMSIsICJhcm0scHJpbWVjZWxsIjsNCgkJCQlyZWcgPSA8
MHgxZjAwMDAgMHgxMDAwPjsNCgkJCQlpbnRlcnJ1cHRzID0gPDE0PjsNCgkJCX07DQoJCX07DQoN
CgkJdjJtX2ZpeGVkXzN2MzogZml4ZWRyZWd1bGF0b3JAMCB7DQoJCQljb21wYXRpYmxlID0gInJl
Z3VsYXRvci1maXhlZCI7DQoJCQlyZWd1bGF0b3ItbmFtZSA9ICIzVjMiOw0KCQkJcmVndWxhdG9y
LW1pbi1taWNyb3ZvbHQgPSA8MzMwMDAwMD47DQoJCQlyZWd1bGF0b3ItbWF4LW1pY3Jvdm9sdCA9
IDwzMzAwMDAwPjsNCgkJCXJlZ3VsYXRvci1hbHdheXMtb247DQoJCX07DQoJfTsNCn07DQo=

--_004_alpineDEB202120914114515029232kaballukxensourcecom_
Content-Type: text/plain; name="vexpress-v2p-ca15-tc1.dts"
Content-Transfer-Encoding: BASE64
Content-ID: <alpine.DEB.2.02.1209141210431.29232@kaball.uk.xensource.com>
Content-Description: vexpress-v2p-ca15-tc1.dts
Content-Disposition: attachment; filename="vexpress-v2p-ca15-tc1.dts";
	size=3264; creation-date="Fri, 14 Sep 2012 11:13:42 GMT";
	modification-date="Fri, 14 Sep 2012 11:13:42 GMT"

LyoNCiAqIEFSTSBMdGQuIFZlcnNhdGlsZSBFeHByZXNzDQogKg0KICogQ29yZVRpbGUgRXhwcmVz
cyBBMTV4MiAodmVyc2lvbiB3aXRoIFRlc3QgQ2hpcCAxKQ0KICogQ29ydGV4LUExNSBNUENvcmUg
KFYyUC1DQTE1KQ0KICoNCiAqIEhCSS0wMjM3QQ0KICovDQoNCi9kdHMtdjEvOw0KDQovIHsNCglt
b2RlbCA9ICJWMlAtQ0ExNSI7DQoJYXJtLGhiaSA9IDwweDIzNz47DQoJY29tcGF0aWJsZSA9ICJh
cm0sdmV4cHJlc3MsdjJwLWNhMTUsdGMxIiwgImFybSx2ZXhwcmVzcyx2MnAtY2ExNSIsICJhcm0s
dmV4cHJlc3MiOw0KCWludGVycnVwdC1wYXJlbnQgPSA8JmdpYz47DQoJI2FkZHJlc3MtY2VsbHMg
PSA8Mj47DQoJI3NpemUtY2VsbHMgPSA8Mj47DQoNCgljaG9zZW4gew0KICAgICAgICAgICAgICAg
ICBib290YXJncyA9ICJkb20wX21lbT0xMjhNIjsNCiAgICAgICAgICAgICAgICAgeGVuLGRvbTAt
Ym9vdGFyZ3MgPSAiZWFybHlwcmludGsgY29uc29sZT10dHlBTUExIHJvb3Q9L2Rldi9tbWNibGsw
IGRlYnVnIHJ3IjsNCgl9Ow0KDQoJYWxpYXNlcyB7DQoJCXNlcmlhbDAgPSAmdjJtX3NlcmlhbDA7
DQoJCXNlcmlhbDEgPSAmdjJtX3NlcmlhbDE7DQoJCXNlcmlhbDIgPSAmdjJtX3NlcmlhbDI7DQoJ
CXNlcmlhbDMgPSAmdjJtX3NlcmlhbDM7DQoJCWkyYzAgPSAmdjJtX2kyY19kdmk7DQoJCWkyYzEg
PSAmdjJtX2kyY19wY2llOw0KCX07DQoNCgljcHVzIHsNCgkJI2FkZHJlc3MtY2VsbHMgPSA8MT47
DQoJCSNzaXplLWNlbGxzID0gPDA+Ow0KDQoJCWNwdUAwIHsNCgkJCWRldmljZV90eXBlID0gImNw
dSI7DQoJCQljb21wYXRpYmxlID0gImFybSxjb3J0ZXgtYTE1IjsNCgkJCXJlZyA9IDwwPjsNCgkJ
fTsNCgl9Ow0KDQoJbWVtb3J5QDgwMDAwMDAwIHsNCgkJZGV2aWNlX3R5cGUgPSAibWVtb3J5IjsN
CgkJcmVnID0gPDAgMHg4MDAwMDAwMCAwIDB4ODAwMDAwMDA+Ow0KCX07DQoNCglnaWM6IGludGVy
cnVwdC1jb250cm9sbGVyQDJjMDAxMDAwIHsNCgkJY29tcGF0aWJsZSA9ICJhcm0sY29ydGV4LWEx
NS1naWMiLCAiYXJtLGNvcnRleC1hOS1naWMiOw0KCQkjaW50ZXJydXB0LWNlbGxzID0gPDM+Ow0K
CQkjYWRkcmVzcy1jZWxscyA9IDwwPjsNCgkJaW50ZXJydXB0LWNvbnRyb2xsZXI7DQoJCXJlZyA9
IDwwIDB4MmMwMDEwMDAgMCAweDEwMDA+LA0KCQkgICAgICA8MCAweDJjMDAyMDAwIDAgMHgxMDAw
PiwNCgkJICAgICAgPDAgMHgyYzAwNDAwMCAwIDB4MjAwMD4sDQoJCSAgICAgIDwwIDB4MmMwMDYw
MDAgMCAweDIwMDA+Ow0KCQlpbnRlcnJ1cHRzID0gPDEgOSAweGYwND47DQoJfTsNCg0KCXRpbWVy
IHsNCgkJY29tcGF0aWJsZSA9ICJhcm0sYXJtdjctdGltZXIiOw0KCQlpbnRlcnJ1cHRzID0gPDEg
MTMgMHhmMDg+LA0KCQkJICAgICA8MSAxNCAweGYwOD4sDQoJCQkgICAgIDwxIDExIDB4ZjA4PiwN
CgkJCSAgICAgPDEgMTAgMHhmMDg+Ow0KCX07DQoNCglwbXUgew0KCQljb21wYXRpYmxlID0gImFy
bSxjb3J0ZXgtYTE1LXBtdSIsICJhcm0sY29ydGV4LWE5LXBtdSI7DQoJCWludGVycnVwdHMgPSA8
MCA2OCA0PiwNCgkJCSAgICAgPDAgNjkgND47DQoJfTsNCg0KCWh5cGVydmlzb3Igew0KCQljb21w
YXRpYmxlID0gInhlbix4ZW4tNC4yIiwgInhlbix4ZW4iOw0KCQlyZWcgPSA8MCAweGIwMDAwMDAw
IDAgMHgyMDAwMD47DQoJCWludGVycnVwdHMgPSA8MSAxNSAweGYwOD47DQoJfTsNCg0KCW1vdGhl
cmJvYXJkIHsNCgkJcmFuZ2VzID0gPDAgMCAwIDB4MDgwMDAwMDAgMHgwNDAwMDAwMD4sDQoJCQkg
PDEgMCAwIDB4MTQwMDAwMDAgMHgwNDAwMDAwMD4sDQoJCQkgPDIgMCAwIDB4MTgwMDAwMDAgMHgw
NDAwMDAwMD4sDQoJCQkgPDMgMCAwIDB4MWMwMDAwMDAgMHgwNDAwMDAwMD4sDQoJCQkgPDQgMCAw
IDB4MGMwMDAwMDAgMHgwNDAwMDAwMD4sDQoJCQkgPDUgMCAwIDB4MTAwMDAwMDAgMHgwNDAwMDAw
MD47DQoNCgkJaW50ZXJydXB0LW1hcC1tYXNrID0gPDAgMCA2Mz47DQoJCWludGVycnVwdC1tYXAg
PSA8MCAwICAwICZnaWMgMCAgMCA0PiwNCgkJCQk8MCAwICAxICZnaWMgMCAgMSA0PiwNCgkJCQk8
MCAwICAyICZnaWMgMCAgMiA0PiwNCgkJCQk8MCAwICAzICZnaWMgMCAgMyA0PiwNCgkJCQk8MCAw
ICA0ICZnaWMgMCAgNCA0PiwNCgkJCQk8MCAwICA1ICZnaWMgMCAgNSA0PiwNCgkJCQk8MCAwICA2
ICZnaWMgMCAgNiA0PiwNCgkJCQk8MCAwICA3ICZnaWMgMCAgNyA0PiwNCgkJCQk8MCAwICA4ICZn
aWMgMCAgOCA0PiwNCgkJCQk8MCAwICA5ICZnaWMgMCAgOSA0PiwNCgkJCQk8MCAwIDEwICZnaWMg
MCAxMCA0PiwNCgkJCQk8MCAwIDExICZnaWMgMCAxMSA0PiwNCgkJCQk8MCAwIDEyICZnaWMgMCAx
MiA0PiwNCgkJCQk8MCAwIDEzICZnaWMgMCAxMyA0PiwNCgkJCQk8MCAwIDE0ICZnaWMgMCAxNCA0
PiwNCgkJCQk8MCAwIDE1ICZnaWMgMCAxNSA0PiwNCgkJCQk8MCAwIDE2ICZnaWMgMCAxNiA0PiwN
CgkJCQk8MCAwIDE3ICZnaWMgMCAxNyA0PiwNCgkJCQk8MCAwIDE4ICZnaWMgMCAxOCA0PiwNCgkJ
CQk8MCAwIDE5ICZnaWMgMCAxOSA0PiwNCgkJCQk8MCAwIDIwICZnaWMgMCAyMCA0PiwNCgkJCQk8
MCAwIDIxICZnaWMgMCAyMSA0PiwNCgkJCQk8MCAwIDIyICZnaWMgMCAyMiA0PiwNCgkJCQk8MCAw
IDIzICZnaWMgMCAyMyA0PiwNCgkJCQk8MCAwIDI0ICZnaWMgMCAyNCA0PiwNCgkJCQk8MCAwIDI1
ICZnaWMgMCAyNSA0PiwNCgkJCQk8MCAwIDI2ICZnaWMgMCAyNiA0PiwNCgkJCQk8MCAwIDI3ICZn
aWMgMCAyNyA0PiwNCgkJCQk8MCAwIDI4ICZnaWMgMCAyOCA0PiwNCgkJCQk8MCAwIDI5ICZnaWMg
MCAyOSA0PiwNCgkJCQk8MCAwIDMwICZnaWMgMCAzMCA0PiwNCgkJCQk8MCAwIDMxICZnaWMgMCAz
MSA0PiwNCgkJCQk8MCAwIDMyICZnaWMgMCAzMiA0PiwNCgkJCQk8MCAwIDMzICZnaWMgMCAzMyA0
PiwNCgkJCQk8MCAwIDM0ICZnaWMgMCAzNCA0PiwNCgkJCQk8MCAwIDM1ICZnaWMgMCAzNSA0PiwN
CgkJCQk8MCAwIDM2ICZnaWMgMCAzNiA0PiwNCgkJCQk8MCAwIDM3ICZnaWMgMCAzNyA0PiwNCgkJ
CQk8MCAwIDM4ICZnaWMgMCAzOCA0PiwNCgkJCQk8MCAwIDM5ICZnaWMgMCAzOSA0PiwNCgkJCQk8
MCAwIDQwICZnaWMgMCA0MCA0PiwNCgkJCQk8MCAwIDQxICZnaWMgMCA0MSA0PiwNCgkJCQk8MCAw
IDQyICZnaWMgMCA0MiA0PjsNCgl9Ow0KfTsNCg0KL2luY2x1ZGUvICJ2ZXhwcmVzcy12Mm0tcnMx
LmR0c2kiDQo=

--_004_alpineDEB202120914114515029232kaballukxensourcecom_
Content-Type: text/plain; name="vexpress-virt.dts"
Content-Transfer-Encoding: BASE64
Content-ID: <alpine.DEB.2.02.1209141210432.29232@kaball.uk.xensource.com>
Content-Description: vexpress-virt.dts
Content-Disposition: attachment; filename="vexpress-virt.dts"; size=2729;
	creation-date="Fri, 14 Sep 2012 11:13:42 GMT";
	modification-date="Fri, 14 Sep 2012 11:13:42 GMT"

LyoNCiAqIEFSTSBMdGQuIFZlcnNhdGlsZSBFeHByZXNzDQogKg0KICogQVJNIEVudmVsb3BlIE1v
ZGVsIHY3QSAoc2luZ2xlIENQVSkuDQogKi8NCg0KL2R0cy12MS87DQoNCi9pbmNsdWRlLyAic2tl
bGV0b24uZHRzaSINCg0KLyB7DQoJbW9kZWwgPSAiVjJQLUFFTXY3QSI7DQoJY29tcGF0aWJsZSA9
ICJhcm0sdmV4cHJlc3MsdjJwLWFlbSx2N2EiLCAiYXJtLHZleHByZXNzLHYycC1hZW0iLCAiYXJt
LHZleHByZXNzIjsNCglpbnRlcnJ1cHQtcGFyZW50ID0gPCZnaWM+Ow0KDQogICAgICAgIGNob3Nl
biB7DQogICAgICAgICAgICAgICAgYm9vdGFyZ3MgPSAiZWFybHlwcmludGsgZGVidWcgbG9nbGV2
ZWw9OSBjb25zb2xlPWh2YzAgcm9vdD0vZGV2L3h2ZGEgaW5pdD0vc2Jpbi9pbml0IjsNCiAgICAg
ICAgfTsNCg0KCWNwdXMgew0KCQkjYWRkcmVzcy1jZWxscyA9IDwxPjsNCgkJI3NpemUtY2VsbHMg
PSA8MD47DQoNCgkJY3B1QDAgew0KCQkJZGV2aWNlX3R5cGUgPSAiY3B1IjsNCgkJCWNvbXBhdGli
bGUgPSAiYXJtLGNvcnRleC1hMTUiOw0KCQkJcmVnID0gPDA+Ow0KCQl9Ow0KCX07DQoNCgltZW1v
cnkgew0KCQlkZXZpY2VfdHlwZSA9ICJtZW1vcnkiOw0KCQlyZWcgPSA8MHg4MDAwMDAwMCAweDA4
MDAwMDAwPjsNCgl9Ow0KDQoJZ2ljOiBpbnRlcnJ1cHQtY29udHJvbGxlckAyYzAwMTAwMCB7DQoJ
CWNvbXBhdGlibGUgPSAiYXJtLGNvcnRleC1hOS1naWMiOw0KCQkjaW50ZXJydXB0LWNlbGxzID0g
PDM+Ow0KCQkjYWRkcmVzcy1jZWxscyA9IDwwPjsNCgkJaW50ZXJydXB0LWNvbnRyb2xsZXI7DQoJ
CXJlZyA9IDwweDJjMDAxMDAwIDB4MTAwMD4sDQoJCSAgICAgIDwweDJjMDAyMDAwIDB4MTAwPjsN
Cgl9Ow0KDQoJdGltZXIgew0KCQljb21wYXRpYmxlID0gImFybSxhcm12Ny10aW1lciI7DQoJCWlu
dGVycnVwdHMgPSA8MSAxMyAweGYwOD4sDQoJCQkgICAgIDwxIDE0IDB4ZjA4PiwNCgkJCSAgICAg
PDEgMTEgMHhmMDg+LA0KCQkJICAgICA8MSAxMCAweGYwOD47DQoJfTsNCg0KCWh5cGVydmlzb3Ig
ew0KCQljb21wYXRpYmxlID0gInhlbix4ZW4tNC4yIiwgInhlbix4ZW4iOw0KCQlyZWcgPSA8MHhi
MDAwMDAwMCAweDIwMDAwPjsNCgkJaW50ZXJydXB0cyA9IDwxIDE1IDB4ZjA4PjsNCgl9Ow0KDQoJ
bW90aGVyYm9hcmQgew0KCQlhcm0sdjJtLW1lbW9yeS1tYXAgPSAicnMxIjsNCgkJcmFuZ2VzID0g
PDAgMCAweDA4MDAwMDAwIDB4MDQwMDAwMDA+LA0KCQkJIDwxIDAgMHgxNDAwMDAwMCAweDA0MDAw
MDAwPiwNCgkJCSA8MiAwIDB4MTgwMDAwMDAgMHgwNDAwMDAwMD4sDQoJCQkgPDMgMCAweDFjMDAw
MDAwIDB4MDQwMDAwMDA+LA0KCQkJIDw0IDAgMHgwYzAwMDAwMCAweDA0MDAwMDAwPiwNCgkJCSA8
NSAwIDB4MTAwMDAwMDAgMHgwNDAwMDAwMD47DQoNCgkJaW50ZXJydXB0LW1hcC1tYXNrID0gPDAg
MCA2Mz47DQoJCWludGVycnVwdC1tYXAgPSA8MCAwICAwICZnaWMgMCAgMCA0PiwNCgkJCQk8MCAw
ICAxICZnaWMgMCAgMSA0PiwNCgkJCQk8MCAwICAyICZnaWMgMCAgMiA0PiwNCgkJCQk8MCAwICAz
ICZnaWMgMCAgMyA0PiwNCgkJCQk8MCAwICA0ICZnaWMgMCAgNCA0PiwNCgkJCQk8MCAwICA1ICZn
aWMgMCAgNSA0PiwNCgkJCQk8MCAwICA2ICZnaWMgMCAgNiA0PiwNCgkJCQk8MCAwICA3ICZnaWMg
MCAgNyA0PiwNCgkJCQk8MCAwICA4ICZnaWMgMCAgOCA0PiwNCgkJCQk8MCAwICA5ICZnaWMgMCAg
OSA0PiwNCgkJCQk8MCAwIDEwICZnaWMgMCAxMCA0PiwNCgkJCQk8MCAwIDExICZnaWMgMCAxMSA0
PiwNCgkJCQk8MCAwIDEyICZnaWMgMCAxMiA0PiwNCgkJCQk8MCAwIDEzICZnaWMgMCAxMyA0PiwN
CgkJCQk8MCAwIDE0ICZnaWMgMCAxNCA0PiwNCgkJCQk8MCAwIDE1ICZnaWMgMCAxNSA0PiwNCgkJ
CQk8MCAwIDE2ICZnaWMgMCAxNiA0PiwNCgkJCQk8MCAwIDE3ICZnaWMgMCAxNyA0PiwNCgkJCQk8
MCAwIDE4ICZnaWMgMCAxOCA0PiwNCgkJCQk8MCAwIDE5ICZnaWMgMCAxOSA0PiwNCgkJCQk8MCAw
IDIwICZnaWMgMCAyMCA0PiwNCgkJCQk8MCAwIDIxICZnaWMgMCAyMSA0PiwNCgkJCQk8MCAwIDIy
ICZnaWMgMCAyMiA0PiwNCgkJCQk8MCAwIDIzICZnaWMgMCAyMyA0PiwNCgkJCQk8MCAwIDI0ICZn
aWMgMCAyNCA0PiwNCgkJCQk8MCAwIDI1ICZnaWMgMCAyNSA0PiwNCgkJCQk8MCAwIDI2ICZnaWMg
MCAyNiA0PiwNCgkJCQk8MCAwIDI3ICZnaWMgMCAyNyA0PiwNCgkJCQk8MCAwIDI4ICZnaWMgMCAy
OCA0PiwNCgkJCQk8MCAwIDI5ICZnaWMgMCAyOSA0PiwNCgkJCQk8MCAwIDMwICZnaWMgMCAzMCA0
PiwNCgkJCQk8MCAwIDMxICZnaWMgMCAzMSA0PiwNCgkJCQk8MCAwIDMyICZnaWMgMCAzMiA0PiwN
CgkJCQk8MCAwIDMzICZnaWMgMCAzMyA0PiwNCgkJCQk8MCAwIDM0ICZnaWMgMCAzNCA0PiwNCgkJ
CQk8MCAwIDM1ICZnaWMgMCAzNSA0PiwNCgkJCQk8MCAwIDM2ICZnaWMgMCAzNiA0PiwNCgkJCQk8
MCAwIDM3ICZnaWMgMCAzNyA0PiwNCgkJCQk8MCAwIDM4ICZnaWMgMCAzOCA0PiwNCgkJCQk8MCAw
IDM5ICZnaWMgMCAzOSA0PiwNCgkJCQk8MCAwIDQwICZnaWMgMCA0MCA0PiwNCgkJCQk8MCAwIDQx
ICZnaWMgMCA0MSA0PiwNCgkJCQk8MCAwIDQyICZnaWMgMCA0MiA0PjsNCgl9Ow0KfTsNCg0KLyog
L2luY2x1ZGUvICJ2ZXhwcmVzcy12Mm0tcnMxLXJ0c20uZHRzaSIgKi8NCg==

--_004_alpineDEB202120914114515029232kaballukxensourcecom_--
