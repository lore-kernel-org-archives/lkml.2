Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030322Ab2EPLpx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 07:45:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43544 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030260Ab2EPLpw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 07:45:52 -0400
Date: Wed, 16 May 2012 14:45:51 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: x86@kernel.org, kvm@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        gleb@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCHv4 0/5] apic: eoi optimization support
Message-ID: <cover.1337168687.git.mst@redhat.com>
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

Changes from v3:
	Address review comments by Marcelo:
		Multiple cosmetic changes eoi -> pv_eoi
		Added multiple comments
Changes from v2:
	Kill guest with GP on an illegal MSR value
	Add documentation

Changes from v1:
	Add host side patch to series
	Remove kvm-specific __test_and_clear_bit, document
	that x86 one does what we want already
	Clear msr on cpu unplug

Michael S. Tsirkin (5):
  kvm_para: guest side for eoi avoidance
  x86/bitops: note on __test_and_clear_bit atomicity
  kvm: host side for eoi optimization
  kvm: eoi msi documentation
  kvm: only sync when attention bits set

 Documentation/virtual/kvm/msr.txt |   32 +++++++++
 arch/x86/include/asm/bitops.h     |   13 +++-
 arch/x86/include/asm/kvm_host.h   |   12 +++
 arch/x86/include/asm/kvm_para.h   |    7 ++
 arch/x86/kernel/kvm.c             |   51 +++++++++++++-
 arch/x86/kvm/cpuid.c              |    1 +
 arch/x86/kvm/irq.c                |    2 +-
 arch/x86/kvm/lapic.c              |  137 +++++++++++++++++++++++++++++++++++--
 arch/x86/kvm/lapic.h              |    2 +
 arch/x86/kvm/trace.h              |   34 +++++++++
 arch/x86/kvm/x86.c                |    8 ++-
 11 files changed, 287 insertions(+), 12 deletions(-)

-- 
MST
