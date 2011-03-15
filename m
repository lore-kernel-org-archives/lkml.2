Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322Ab1CODtr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 23:49:47 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:22904 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913Ab1CODtq (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 14 Mar 2011 23:49:46 -0400
Date: Mon, 14 Mar 2011 23:48:43 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: ian.campbell@citrix.com, tglx@linutronix.de,
        stefano.stabellini@eu.citrix.com, jeremy@goop.org, tj@kernel.org
Subject: [GIT PULL] (xen) stable/irq.rework, stable/pcifront-fixes, and
 stable/irq.cleanup for 2.6.39
Message-ID: <20110315034843.GB820@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt358.oracle.com [141.146.40.158]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4D7EE19F.0017,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Linus,

This pull request is a bit hairy - it requires one patch from tglr'x branch
(irq/for-xen), so to make it easier to visualize, I've put all of the
merges and pulls in for-2.6.39/irq.

Please pull these three branches:

  git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/irq.rework stable/pcifront-fixes stable/irq.cleanup

The last one (stable/irq.cleanup) depends on the first two branches, so a simple
'git pull <all branches>' won't work. One way it worked for me was to
do a single pull:

 1) git pull git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/irq.cleanup
	(since the stable/irq.cleanup has the two other branches in it and also the tglr'x pull).

or to do this in two stages:

 1) git pull git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/irq.rework stable/pcifront-fixes
	(which also gets tglr'x pull)
 2) git pull git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/irq.cleanup


Or you can take #for-2.6.39/e820 which has three merges for your convience.


I don't know which way you prefer - but the easiest was to do:

git pull git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/irq.cleanup

and that will get everything.


Back to the description.
#stable/irq.rework is based off v2.6.38-rc4 (100b33c8bd8a3235fd0b7948338d6cbb3db3c63d)

.. which expunges out of Xen IRQ code our home-grown IRQ allocator and
instead uses the generic one that Thomas Gleixner wrote for 2.6.38.
Thomas helped us in removing unnecessary code and align it to be in
sync with his changes for 2.6.39.

#stable/pcifront-fixes is based off v2.6.38-rc5 (85e2efbb1db9a18d218006706d6e4fbeb0216213)

removes some code that is to be deprecated and hardens the code in
case the backend is busted. Some cleanup is done.

#stable/irq.cleanup is based of #stable/pcifront-fixes (8448f0119a4309ef9626cf8e2dc5abb881e6dc2a)
and #stable/irq.rework (8054c3634cb3cb9d426c8ade934389213b857858)

This patchset is a major spring cleaning. Ian collapses and simplifies
much of the Xen IRQ code and all its different users. We need
to have it based of #stable/pcifront-fixes because some of the cleanups
done in that branch are further augmented here. The same goes for
the reason of basing it on top off #stable/irq.rework.

The diffstat:

 arch/x86/include/asm/xen/pci.h |    8 +-
 arch/x86/pci/xen.c             |  159 +++++++++++---------
 arch/x86/xen/time.c            |    4 +-
 drivers/pci/xen-pcifront.c     |   31 +++--
 drivers/xen/events.c           |  340 +++++++++++++++-------------------------
 include/linux/interrupt.h      |    3 +-
 include/xen/events.h           |    8 +-
 kernel/irq/manage.c            |   11 ++-
 kernel/irq/pm.c                |    3 -
 9 files changed, 257 insertions(+), 310 deletions(-)

And the shortlog:

Ian Campbell (19):
      xen: handled remapped IRQs when enabling a pcifront PCI device.
      xen:events: move find_unbound_irq inside CONFIG_PCI_MSI
      xen: events: add xen_allocate_irq_{dynamic, gsi} and xen_free_irq
      xen: events: allocate GSIs and dynamic IRQs from separate IRQ ranges.
      xen: events: do not free legacy IRQs
      xen: Fix compile error introduced by "switch to new irq_chip functions"
      xen/timer: Missing IRQF_NO_SUSPEND in timer code broke suspend.
      xen: pci: only define xen_initdom_setup_msi_irqs if CONFIG_XEN_DOM0
      xen: events: do not leak IRQ from xen_allocate_pirq_msi when no pirq available.
      xen: events: drop XEN_ALLOC_IRQ flag to xen_allocate_pirq_msi
      xen: events: return irq from xen_allocate_pirq_msi
      xen: pci: collapse apic_register_gsi_xen_hvm and xen_hvm_register_pirq
      xen: events: assume PHYSDEVOP_get_free_pirq exists
      xen: events: separate MSI PIRQ allocation from PIRQ binding to IRQ
      xen: events: refactor xen_create_msi_irq slightly
      xen: events: update pirq_to_irq in xen_create_msi_irq
      xen: events: push set_irq_msi down into xen_create_msi_irq
      xen: events: use xen_bind_pirq_msi_to_irq from xen_create_msi_irq
      xen: events: remove dom0 specific xen_create_msi_irq

Konrad Rzeszutek Wilk (8):
      xen-pcifront: Sanity check the MSI/MSI-X values
      pci/xen: Use xen_allocate_pirq_msi instead of xen_allocate_pirq
      pci/xen: Cleanup: convert int** to int[]
      pci/xen: When free-ing MSI-X/MSI irq->desc also use generic code.
      Merge branch 'irq/for-xen' of git://git.kernel.org/.../tip/linux-2.6-tip into HEAD
      xen/irq: Cleanup up the pirq_to_irq for DomU PV PCI passthrough guests as well.
      Merge branch 'stable/irq.rework' into stable/irq.cleanup
      Merge branch 'stable/pcifront-fixes' into stable/irq.cleanup

Tejun Heo (1):
      xen-pcifront: don't use flush_scheduled_work()

Thomas Gleixner (4):
      genirq: Add IRQF_FORCE_RESUME
      xen: Remove stale irq_chip.end
      xen: Switch to new irq_chip functions
      xen: Use IRQF_FORCE_RESUME

