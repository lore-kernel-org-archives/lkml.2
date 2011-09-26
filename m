Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752079Ab1IZSSM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 14:18:12 -0400
Received: from claw.goop.org ([74.207.240.146]:32910 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751916Ab1IZSSL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 14:18:11 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
        Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 0/3] x86/microcode: support for microcode update in Xen dom0
Date: Mon, 26 Sep 2011 11:17:59 -0700
Message-Id: <cover.1317060617.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.6.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Hi all,

I'm proposing this for the next merge window v3.2.

I originally posted this early this year, and it prompted a debate
about what the "proper" way that Linux should do microcode updates,
with the general concensus being "earlier", ideally in the bootloader
(or in the case of Xen, as the hypervisor boots before starting any
domains).  However, as far as I know there has been no progress along
those lines.

I would like to therefore merge this so that a Linux kernel booting as
dom0 under Xen can update the microcode in the same manner as a kernel
booting natively.  When we work out how boot-time microcode updates
can be done, then we'll look at modifying Xen accordingly.  In the
meantime, we should have a functional parity.

The only change to this code from the previous posting is some patch
restructuring so that regardless of how the platform.h ABI header gets
merged (since there are some other pending branches containing it), it
will be identical and cause no merge headaches.

>From original posting:

This series adds a new "Xen" microcode update type, in addition to
Intel and AMD.

The Xen hypervisor is responsible for performing the actual microcode
update (since only it knows what physical CPUs are in the system and
has sufficient privilege to access them), but it requires the dom0
kernel to provide the actual microcode update data.

Xen update mechanism is uniform independent of the CPU type, but the
driver must know where to find the data file, which depends on the CPU
type.  And since the update hypercall updates all CPUs, we only need
to execute it once on any CPU - but for simplicity it just runs it only
on (V)CPU 0.

Thanks,
	J

Jeremy Fitzhardinge (2):
  xen: add dom0_op hypercall
  xen: add CPU microcode update driver

Yu Ke (1):
  xen/acpi: Domain0 acpi parser related platform hypercall

 arch/ia64/include/asm/xen/interface.h |    1 +
 arch/x86/include/asm/microcode.h      |    9 +
 arch/x86/include/asm/xen/hypercall.h  |    8 +
 arch/x86/include/asm/xen/interface.h  |    1 +
 arch/x86/kernel/Makefile              |    1 +
 arch/x86/kernel/microcode_core.c      |    5 +-
 arch/x86/kernel/microcode_xen.c       |  198 ++++++++++++++++++++
 arch/x86/xen/Kconfig                  |    4 +
 include/xen/interface/platform.h      |  320 +++++++++++++++++++++++++++++++++
 include/xen/interface/xen.h           |    1 +
 10 files changed, 547 insertions(+), 1 deletions(-)
 create mode 100644 arch/x86/kernel/microcode_xen.c
 create mode 100644 include/xen/interface/platform.h

-- 
1.7.6.2

