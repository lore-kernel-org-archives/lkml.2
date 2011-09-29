Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757804Ab1I2UUe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 16:20:34 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:45041 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757416Ab1I2US3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 16:18:29 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, rjw@sisk.pl, tglx@linutronix.de,
        hpa@zytor.com, x86@kernel.org, len.brown@intel.com,
        joseph.cihula@intel.com, shane.wang@intel.com,
        xen-devel@lists.xensource.com, linux-pm@lists.linux-foundation.org,
        tboot-devel@lists.sourceforge.net, linux-acpi@vger.kernel.org,
        liang.tang@oracle.com, ke.yu@intel.com, kevin.tian@intel.com,
        jeremy@goop.org
Subject: [PATCH v2] ACPI S3 to work under Xen. 
Date: Thu, 29 Sep 2011 16:16:46 -0400
Message-Id: <1317327414-24072-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.4.1
X-Source-IP: ucsinet24.oracle.com [156.151.31.67]
X-CT-RefId: str=0001.0A090209.4E84D243.0109,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Attached is an [v2] set of patches to enable S3 to work with the Xen hypervisor.

Changes since the RFC posting [http://comments.gmane.org/gmane.linux.acpi.devel/50701] by
Liang Tang:
 - Per review comments added: __unused__ attribute, support for PM1A/B if more than 16-bit,
   copyright/license.
 - Added support for PHYSDEVOP_restore_msi_ext call.

The relationship that Xen has with Linux kernel is symbiotic. The Linux
kernel does the ACPI "stuff" and tells the hypervisor to do the low-level
stuff (such as program the IOAPIC, setup vectors, etc). The realm of
ACPI S3 is more complex as we need to save the CPU state (and Intel TXT
values - which the hypervisor has to do).

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

When I posted the RFC, the feedback I got was to use a higher upper interface
to make the call to the hypervisor. Instead of doing it at the lower pv-ops
case for cr3, cr8, idt, gdt, etc. The code I've to say - is much nicer than
doing it via pv-ops.

Anyhow, please take a look!

Konrad Rzeszutek Wilk (5):
      x86: Expand the x86_msi_ops to have a restore MSIs.
      x86, acpi, tboot: Have a ACPI sleep override instead of calling tboot_sleep.
      xen: Utilize the restore_msi_irqs hook.
      xen/acpi/sleep: Enable ACPI sleep via the __acpi_override_sleep
      xen/acpi/sleep: Register to the acpi_suspend_lowlevel a callback.

Liang Tang (2):
      x86/acpi/sleep: Provide registration for acpi_suspend_lowlevel.
      xen/pci:use hypercall PHYSDEVOP_restore_msi_ext to restore MSI/MSI-X vectors

Yu Ke (1):
      xen/acpi: Domain0 acpi parser related platform hypercall


 arch/ia64/include/asm/xen/interface.h |    1 +
 arch/x86/include/asm/acpi.h           |    6 +-
 arch/x86/include/asm/pci.h            |    9 +
 arch/x86/include/asm/x86_init.h       |    1 +
 arch/x86/include/asm/xen/hypercall.h  |    8 +
 arch/x86/include/asm/xen/interface.h  |    1 +
 arch/x86/kernel/acpi/boot.c           |    6 +
 arch/x86/kernel/acpi/sleep.c          |    4 +-
 arch/x86/kernel/acpi/sleep.h          |    2 +
 arch/x86/kernel/tboot.c               |   14 +-
 arch/x86/kernel/x86_init.c            |    1 +
 arch/x86/pci/xen.c                    |   29 +++
 arch/x86/xen/enlighten.c              |    3 +
 drivers/acpi/acpica/hwsleep.c         |   12 +-
 drivers/acpi/sleep.c                  |    2 +
 drivers/pci/msi.c                     |   29 +++-
 drivers/xen/Makefile                  |    2 +-
 drivers/xen/acpi.c                    |   65 +++++++
 include/linux/tboot.h                 |    3 +-
 include/xen/acpi.h                    |   70 +++++++
 include/xen/interface/physdev.h       |   15 ++
 include/xen/interface/platform.h      |  320 +++++++++++++++++++++++++++++++++
 include/xen/interface/xen.h           |    1 +
 23 files changed, 591 insertions(+), 13 deletions(-)

