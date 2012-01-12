Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096Ab2ALXXY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 18:23:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32306 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756037Ab2ALXXQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 18:23:16 -0500
Date: Fri, 13 Jan 2012 01:25:20 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCHv3 0/2] kvm: set irq affinity for assigned devices
Message-ID: <cover.1326410553.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To forward an interrupt to a vcpu that runs on
a host cpu different from the current one,
we need an ipi which likely will cost us as much
as delivering the interrupt directly to that cpu would.
    
So it seems to make sense to set irq affinity hint to point there, irq
balancer can then take this into accound and balance interrupts
accordingly.

This is what this patchset does.
Note: it might make sense to optimize the gsi lookups
here for the msi case, using rcu, the way we did for eventfd.
But that's a subject for another patch.

Testing shows that with irqbalance running this performs basically the
same as manual numa pinning.

This patch applies to 3.2 or linux-next.

Changes from v1:
	Address comments by Alex Williamson and Marcelo Tosatti:
	- Fold in v2 patch from 20111017170440.GA8894@redhat.com:
	fix affinity for lowest priority setups,
	- Disable automatic affinity for round robin setups.
	- Fix compiler warnings.
	- Fix a checkpatch warning.
	- Clear hint before free irq for MSI/INTx.

Michael S. Tsirkin (2):
  kvm: pass host irq number to set irq calls
  kvm: set affinity hint for assigned device msi

 arch/x86/kvm/i8254.c     |    4 ++--
 arch/x86/kvm/lapic.c     |    2 +-
 arch/x86/kvm/x86.c       |    2 +-
 include/linux/kvm_host.h |    7 ++++---
 virt/kvm/assigned-dev.c  |   14 +++++++++-----
 virt/kvm/eventfd.c       |    7 ++++---
 virt/kvm/ioapic.c        |    2 +-
 virt/kvm/ioapic.h        |    2 +-
 virt/kvm/irq_comm.c      |   43 ++++++++++++++++++++++++++++++++++---------
 9 files changed, 57 insertions(+), 26 deletions(-)

-- 
1.7.8.2.325.g247f9
