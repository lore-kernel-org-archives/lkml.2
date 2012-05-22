Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756784Ab2EVOFZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 10:05:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14575 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754737Ab2EVOFY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 10:05:24 -0400
Date: Tue, 22 May 2012 17:05:20 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: x86@kernel.org, kvm@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        gleb@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCHv5 0/5] apic: eoi optimization support
Message-ID: <cover.1337695416.git.mst@redhat.com>
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

The patches are against a merge of kvm.git (for apic announce bits) and
tip.git master. The last patch in the series, supplying the host
part, also depends on the ISR optimization patch that I sent previously:
changes to optimization would require reworking this last patch
in the series.

The rest of the patchset has not changed since v2.

Thanks,
MST

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

Michael S. Tsirkin (5):
  kvm_para: guest side for eoi avoidance
  x86/bitops: note on __test_and_clear_bit atomicity
  kvm: eoi msi documentation
  kvm: only sync when attention bits set
  kvm: host side for eoi optimization

 Documentation/virtual/kvm/msr.txt |   32 +++++++++
 arch/x86/include/asm/bitops.h     |   13 +++-
 arch/x86/include/asm/kvm_host.h   |   12 +++
 arch/x86/include/asm/kvm_para.h   |    7 ++
 arch/x86/kernel/kvm.c             |   51 +++++++++++++-
 arch/x86/kvm/cpuid.c              |    1 +
 arch/x86/kvm/lapic.c              |  135 +++++++++++++++++++++++++++++++++++-
 arch/x86/kvm/lapic.h              |    2 +
 arch/x86/kvm/trace.h              |   34 +++++++++
 arch/x86/kvm/x86.c                |    8 ++-
 10 files changed, 285 insertions(+), 10 deletions(-)

-- 
MST
