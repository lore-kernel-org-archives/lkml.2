Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570Ab2FCH15 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 03:27:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12106 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751239Ab2FCH14 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 03:27:56 -0400
Date: Sun, 3 Jun 2012 10:27:44 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: x86@kernel.org, kvm@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        gleb@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCHv6 0/8] kvm: eoi optimization support
Message-ID: <cover.1338474301.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm looking at reducing the interrupt overhead for virtualized guests:
some workloads spend a large part of their time processing interrupts.

On kvm, an EOI write from the guest causes an expensive exit to host; we
avoid this using shared memory.

The patches work fine on my boxes. See individual patches
for perf tests. You need to patch qemu to whitelist the kvm feature.
qemu patch was sent separately.

The patches are against Linus's master and apply to kvm.git
cleanly.  The last patch in the series, supplying the host
part, also depends on the ISR optimization patch that I
have for convenience included in the series (patch 2),
I also included a documentation patch (patch 1) - it is
here since it clarifies patch 2.  This revision does not yet address
Thomas's idea of reworking the APIC page handling.  Changes to this
optimization would require reworking this last patch in the series.

The rest of the patchset has not changed since v2.

Thanks,
MST

Changes from v5:
	Clear PV EOI when we cancel interrupts.
		Pointed out by Gleb.
	Always set ISR cache when we inject an interrupt.
		Suggested by Ronen Hod.

Changes from v4:
	Turn off PV EOI on each exit. Turn it back on when safe.
		Suggested by Avi.
	Address bug with nested interrupts pointed out by Marcelo.

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

Michael S. Tsirkin (8):
  kvm: document lapic regs field
  kvm: optimize ISR lookups
  kvm_para: guest side for eoi avoidance
  x86/bitops: note on __test_and_clear_bit atomicity
  kvm: eoi msi documentation
  kvm: only sync when attention bits set
  kvm: rearrange injection cancelling code
  kvm: host side for eoi optimization

 Documentation/virtual/kvm/msr.txt |   32 ++++++
 arch/x86/include/asm/bitops.h     |   13 ++-
 arch/x86/include/asm/kvm_host.h   |   12 +++
 arch/x86/include/asm/kvm_para.h   |    7 ++
 arch/x86/kernel/kvm.c             |   51 ++++++++++-
 arch/x86/kvm/cpuid.c              |    1 +
 arch/x86/kvm/lapic.c              |  188 +++++++++++++++++++++++++++++++++++-
 arch/x86/kvm/lapic.h              |   11 ++
 arch/x86/kvm/trace.h              |   34 +++++++
 arch/x86/kvm/x86.c                |   20 +++-
 10 files changed, 353 insertions(+), 16 deletions(-)

-- 
MST
