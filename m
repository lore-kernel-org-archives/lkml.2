Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713Ab0LLLWv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 06:22:51 -0500
Received: from fmmailgate01.web.de ([217.72.192.221]:36305 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518Ab0LLLWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 06:22:49 -0500
From: Jan Kiszka <jan.kiszka@web.de>
To: Thomas Gleixner <tglx@linutronix.de>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        Tom Lyon <pugs@cisco.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH v2 0/4] KVM & genirq: Enable adaptive IRQ sharing for passed-through devices
Date: Sun, 12 Dec 2010 12:22:40 +0100
Message-Id: <cover.1292152963.git.jan.kiszka@web.de>
X-Mailer: git-send-email 1.7.1
X-Provags-ID: V01U2FsdGVkX19+DJkBxYsXZ+qp48FPm6D+sw4wYjLm7hHzTEKJ
	1EJqhdaIKlagFQzF1HQiVtviYnIrQQLzFk5qZKRGPxa4wKxS8T
	rfSi5dkm0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Second try to allow adaptive interrupt handlers according to the line's
current sharing situation. This one converts the explicit notifier
interface into several extension of existing genirq APIs:

 - introduce a interrupt status word that can be read by interrupt
   handlers to obtain the current line sharing state
 - introduce IRQF_ADAPTIVE: handlers registered with this flag will be
   informed about an upcoming line sharing by calling the interrupt
   handler itself (instead of a notifier callback)
 - introduce IRQF_COND_ONESHOT: IRQF_ONESHOT semantics if the line is
   not shared, standard semantics otherwise (removes the need to
   re-register handlers to switch between IRQF_SHARED and IRQF_ONESHOT)

The result may look simpler on first glance than v1, but it comes with
more subtle race scenarios IMO. I thought them through, hopefully
catching all, but I would appreciate any skeptical review.

I also tried to replace line-level disabling from the interrupt handler
with signaling genirq to keep the line masked on handler return.
However, I finally dropped this idea as it turns out to be very hard (if
not impossible) to properly synchronize the generic tail (in genirq)
with the driver that may want to re-enable the line at the same time
(depending on the driver's internal state). But if anyone sees a
magically simple way to achieve this, I'm still all ears.

Finally, the last patch in this series makes use of the new interface
for KVM's PCI pass-through subsystem. KVM has to keep the interrupt
source disabled while calling into the guest to handle the event. This
can be done at device or line level. The former is required to share the
interrupt line, the latter is an order of magnitude faster.

Beside pass-through support of KVM, further users of this new interface
could become VFIO (not yet mainline) and uio_pci_generic which have to
resolve the same conflict.

Note: The KVM patch depends on
http://thread.gmane.org/gmane.comp.emulators.kvm.devel/64515

Jan Kiszka (4):
  genirq: Introduce driver-readable IRQ status word
  genirq: Inform handler about line sharing state
  genirq: Add support for IRQF_COND_ONESHOT
  KVM: Allow host IRQ sharing for passed-through PCI 2.3 devices

 Documentation/kvm/api.txt |   27 ++++
 arch/x86/kvm/x86.c        |    1 +
 include/linux/interrupt.h |   15 ++
 include/linux/irq.h       |    2 +
 include/linux/irqdesc.h   |    2 +
 include/linux/kvm.h       |    6 +
 include/linux/kvm_host.h  |   10 ++-
 kernel/irq/irqdesc.c      |    2 +
 kernel/irq/manage.c       |   74 ++++++++++-
 virt/kvm/assigned-dev.c   |  336 ++++++++++++++++++++++++++++++++++++++++-----
 10 files changed, 437 insertions(+), 38 deletions(-)

