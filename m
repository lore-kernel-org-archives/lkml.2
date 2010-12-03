Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119Ab0LCXhj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 18:37:39 -0500
Received: from fmmailgate02.web.de ([217.72.192.227]:44053 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753671Ab0LCXhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 18:37:37 -0500
From: Jan Kiszka <jan.kiszka@web.de>
To: Thomas Gleixner <tglx@linutronix.de>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        Tom Lyon <pugs@cisco.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 0/5] KVM&genirq: Enable adaptive IRQ sharing for passed-through devices
Date: Sat,  4 Dec 2010 00:37:26 +0100
Message-Id: <cover.1291419444.git.jan.kiszka@web.de>
X-Mailer: git-send-email 1.7.1
X-Provags-ID: V01U2FsdGVkX19nXzKtwTs6FXNfRb+o0Enf5yqBm9Va6ISBe6fO
	fPfjIsvz3e96TiAmTkDNqP55yfltAG6iMdsbPVFYuFRMYSHZd9
	PfcF/ENHo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Besides 3 cleanup patches, this series consists of two major changes.
The first introduces an interrupt sharing notifier to the genirq
subsystem. It fires when an interrupt line is about to be use by more
than one driver or the last but one user called free_irq.

The second major change makes use of this interface in KVM's PCI pass-
through subsystem. KVM has to keep the interrupt source disabled while
calling into the guest to handle the event. This can be done at device
or line level. The former is required to share the interrupt line, the
latter is an order of magnitude faster (see patch 3 for details).

Beside pass-through support of KVM, further users of the IRQ notifier
could become VFIO (not yet mainline) and uio_pci_generic which have to
resolve the same conflict.

Jan Kiszka (5):
  genirq: Pass descriptor to __free_irq
  genirq: Introduce interrupt sharing notifier
  KVM: Split up MSI-X assigned device IRQ handler
  KVM: Clean up unneeded void pointer casts
  KVM: Allow host IRQ sharing for passed-through PCI 2.3 devices

 Documentation/kvm/api.txt |   25 +++
 arch/x86/kvm/x86.c        |    1 +
 include/linux/interrupt.h |   21 +++
 include/linux/irqdesc.h   |    9 +
 include/linux/kvm.h       |    6 +
 include/linux/kvm_host.h  |    4 +
 kernel/irq/irqdesc.c      |    6 +
 kernel/irq/manage.c       |  174 ++++++++++++++++++--
 virt/kvm/assigned-dev.c   |  420 +++++++++++++++++++++++++++++++++++++++------
 9 files changed, 606 insertions(+), 60 deletions(-)

