Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932496Ab1KOVc3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 16:32:29 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:37720 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932408Ab1KOVcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 16:32:25 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, rjw@sisk.pl, tglx@linutronix.de,
        x86@kernel.org, hpa@zytor.com, len.brown@intel.com,
        joseph.cihula@intel.com, linux-pm@lists.linux-foundation.org,
        tboot-devel@lists.sourceforge.net, linux-acpi@vger.kernel.org,
        liang.tang@oracle.com
Cc: xen-devel@lists.xensource.com
Subject: [PATCH] ACPI cleanup's and enablement for Xen ACPI S3 [v3]
Date: Tue, 15 Nov 2011 16:31:04 -0500
Message-Id: <1321392671-9128-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.1
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090205.4EC2DA45.0057,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Attached is an [v3] set of patches to enable S3 to work with the Xen hypervisor.

Changes since v2: [https://lkml.org/lkml/2011/9/29/408]
 - Moved tboot_sleep out to the osl.c code.
 - Dropped some patches.
since the RFC posting [http://comments.gmane.org/gmane.linux.acpi.devel/50701]:
 - Per review comments added: __unused__ attribute, support for PM1A/B if more than 16-bit,
   copyright/license.
 - Added support for PHYSDEVOP_restore_msi_ext call.

The first two patches can be considered independently as cleanup - they move
the tboot_sleep out of the ACPI code and move it in the OS part. That is
the OSPM code changes required.

The more complex ones are in the ACPI x86 code. I was not sure how to
post the patches so I grouped in the "functionality" parts.

1). Use the acpi_os_prepare_sleep to register a variant of it. The reason
    for the need for this is explained in more details below. The patches are:

 [PATCH 1/7] x86, acpi, tboot: Have a ACPI os prepare sleep instead
 [PATCH 2/7] tboot: Add return values for tboot_sleep
 [PATCH 3/7] xen/acpi/sleep: Enable ACPI sleep via the

2). Expand x86_msi_ops. Every time we resume, we end up calling write_msi_irq
    to resume the MSI vectors. But when using Xen, we would write the MSI
    vectors using the other x86_msi_ops - hence we expand the x86_msi_ops
    indirection mechanism to take resume in account. The paches are:

 [PATCH 4/7] x86: Expand the x86_msi_ops to have a restore MSIs.
 [PATCH 5/7] xen/pci: Utilize the restore_msi_irqs hook.
3). Make acpi_suspend_lowlevel be a function pointer instead of a function.
    Details of why we want to omit the lowlevel values is explained below.
    Originally I was thinking that perhaps doing it via a registration
    function would be better? But not sure what folks leanings are
    in this case. The patches are:

 [PATCH 6/7] x86/acpi/sleep: Provide registration for
 [PATCH 7/7] xen/acpi/sleep: Register to the acpi_suspend_lowlevel a

Details of what I said in the first postings:

The Xen ACPI S3 functionality requires help from the Linux kernel. The Linux
kernel does the ACPI "stuff" and tells the hypervisor to do the low-level
stuff (such as program the IOAPIC, setup vectors, etc). Naturally do it correctly
the Xen hypervisor must be programmed with correct values that are extracted
as part of parsing the ACPI.

The ACPI code used during suspend is mostly all in hwsleep.c and there is one
particular case where 'hwsleep.c' is calling in the tboot.c code. This is replaced
by making the call go through the OS part of the ACPI code. The reason for
doing this is two fold: 1) cleanup, 2) for Xen case, it needs to make a hypercall
so that the hypervisor can write the PM1A/PM1B bits.

The major difficulties we hit was with 'acpi_suspend_lowlevel' - which tweaks
a lot of lowlevel values and some of them are not properly handled by Xen.
Liang Tang has figured which ones of them we trip over (read below) - and he
suggested that perhaps we can provide a registration mechanism to abstract
this away. The reason for all of this is that Linux does not talk to the
BIOS directly - instead it simply walks through the necessary ACPI methods
and then issues hypercall to Xen which then further completes the remaining
suspend steps.

So the attached patches do exactly that - there are two entry points
in the ACPI.

 1). For S3: acpi_suspend_lowlevel -> .. lots of code -> acpi_enter_sleep_state
 2). For S1/S4/S5: acpi_enter_sleep_state

The first naive idea was of abstracting away in the 'acpi_enter_sleep_state'
function the tboot_sleep code so that we can use it too. And low-behold - it
worked splendidly for powering off (S5 I believe)

For S3 that did not work - during suspend the hypervisor tripped over when
saving cr8. During resume it tripped over at restoring the cr3, cr8, idt,
and gdt values.

When I posted the RFC, the feedback I got was to use a higher upper
interface to make the call to the hypervisor. Instead of doing it at the
lower pv-ops case for cr3, cr8, idt, gdt, etc. The code is much nicer
this way, I've to say.

Anyhow, please take a look!

The patches are also located at

git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git devel/acpi-s3.v5

Konrad Rzeszutek Wilk (5):
      tboot: Add return values for tboot_sleep
      xen/acpi/sleep: Enable ACPI sleep via the acpi_os_prepare_sleep_register
      x86: Expand the x86_msi_ops to have a restore MSIs.
      x86/acpi/sleep: Provide registration for acpi_suspend_lowlevel
      xen/acpi/sleep: Register to the acpi_suspend_lowlevel a callback.

Tang Liang (2):
      x86, acpi, tboot: Have a ACPI os prepare sleep instead of calling tboot_sleep.
      xen/pci: Utilize the restore_msi_irqs hook.

 arch/x86/include/asm/acpi.h     |    2 +-
 arch/x86/include/asm/pci.h      |    9 +++++
 arch/x86/include/asm/x86_init.h |    1 +
 arch/x86/kernel/acpi/boot.c     |    2 +
 arch/x86/kernel/acpi/sleep.c    |    4 +-
 arch/x86/kernel/acpi/sleep.h    |    2 +
 arch/x86/kernel/tboot.c         |   18 ++++++++--
 arch/x86/kernel/x86_init.c      |    1 +
 arch/x86/pci/xen.c              |   27 ++++++++++++++
 arch/x86/xen/enlighten.c        |    3 ++
 drivers/acpi/acpica/hwsleep.c   |    7 ++--
 drivers/acpi/osl.c              |   19 ++++++++++
 drivers/acpi/sleep.c            |    2 +
 drivers/pci/msi.c               |   29 ++++++++++++++-
 drivers/xen/Makefile            |    2 +-
 drivers/xen/acpi.c              |   62 ++++++++++++++++++++++++++++++++
 include/acpi/acpiosxf.h         |    6 +++
 include/linux/tboot.h           |    3 --
 include/xen/acpi.h              |   74 +++++++++++++++++++++++++++++++++++++++
 include/xen/interface/physdev.h |    7 ++++
 20 files changed, 265 insertions(+), 15 deletions(-)
