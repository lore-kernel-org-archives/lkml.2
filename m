Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932896Ab2EOOfu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 10:35:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17883 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757166Ab2EOOfs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 10:35:48 -0400
Date: Tue, 15 May 2012 17:35:44 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: x86@kernel.org, kvm@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        gleb@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCHv3 0/8] apic: eoi optimization support
Message-ID: <cover.1337091955.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm looking at reducing the interrupt overhead for virtualized guests:
some workloads spend a large part of their time processing interrupts.
This patchset supplies infrastructure to reduce the IRQ ack overhead on
x86: the idea is to add an eoi_write callback that we can then optimize
without touching other apic functionality.

The main user is kvm: on kvm, an EOI write from the guest causes an
expensive exit to host; we can avoid this using shared memory as the
last patches in the series demonstrate.

But I also wrote a micro-optimized version for the regular x2apic: this
shaves off a branch and about 9 instructions from EOI when x2apic is
used, and a comment in ack_APIC_irq implies that someone counted
instructions there, at some point.

That's patch 4 in the series - if someone's unhappy with
this patch specifically this patch can be dropped
as nothing else in the series depends on it.

Also included in the patchset are a couple of trivial macro fixes.

The patches work fine on my boxes. See individual patches
for perf tests. You need to patch qemu to whitelist the kvm feature.
qemu patch will be sent as a reply to this mail.

The patches are against 3.4-rc7 - let me know if
I need to rebase.

Please review, and consider for linux 3.5.

Thanks,
MST

Changes from v2:
	Kill guest with GP on an illegal MSR value
	Add documentation

Changes from v1:
	Add host side patch to series
	Remove kvm-specific __test_and_clear_bit, document
	that x86 one does what we want already
	Clear msr on cpu unplug

Michael S. Tsirkin (8):
  apic: fix typo EIO_ACK -> EOI_ACK and document
  apic: use symbolic APIC_EOI_ACK
  x86: add apic->eoi_write callback
  x86: eoi micro-optimization
  kvm_para: guest side for eoi avoidance
  x86/bitops: note on __test_and_clear_bit atomicity
  kvm: host side for eoi optimization
  kvm: eoi msi documentation

 Documentation/virtual/kvm/msr.txt      |   32 +++++++++
 arch/x86/include/asm/apic.h            |   22 ++++++-
 arch/x86/include/asm/apicdef.h         |    2 +-
 arch/x86/include/asm/bitops.h          |   13 +++-
 arch/x86/include/asm/kvm_host.h        |    6 ++
 arch/x86/include/asm/kvm_para.h        |    2 +
 arch/x86/kernel/apic/apic_flat_64.c    |    2 +
 arch/x86/kernel/apic/apic_noop.c       |    1 +
 arch/x86/kernel/apic/apic_numachip.c   |    1 +
 arch/x86/kernel/apic/bigsmp_32.c       |    1 +
 arch/x86/kernel/apic/es7000_32.c       |    2 +
 arch/x86/kernel/apic/numaq_32.c        |    1 +
 arch/x86/kernel/apic/probe_32.c        |    1 +
 arch/x86/kernel/apic/summit_32.c       |    1 +
 arch/x86/kernel/apic/x2apic_cluster.c  |    1 +
 arch/x86/kernel/apic/x2apic_phys.c     |    1 +
 arch/x86/kernel/apic/x2apic_uv_x.c     |    1 +
 arch/x86/kernel/kvm.c                  |   50 ++++++++++++++-
 arch/x86/kvm/cpuid.c                   |    1 +
 arch/x86/kvm/irq.c                     |    2 +-
 arch/x86/kvm/lapic.c                   |  110 ++++++++++++++++++++++++++++++--
 arch/x86/kvm/lapic.h                   |    2 +
 arch/x86/kvm/trace.h                   |   34 ++++++++++
 arch/x86/kvm/x86.c                     |    8 ++-
 arch/x86/platform/visws/visws_quirks.c |    2 +-
 25 files changed, 282 insertions(+), 17 deletions(-)

-- 
MST
