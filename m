Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756408Ab2EPQDJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 12:03:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46425 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754328Ab2EPQDH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 12:03:07 -0400
Date: Wed, 16 May 2012 19:03:05 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: x86@kernel.org, kvm@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        gleb@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCHv5 0/4] apic: core part for eoi optimization support
Message-ID: <cover.1337184153.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo, please cosider the following patches for tip.git and for
3.5.

This patchset includes just the core bits for the eoi optimization.
Please note that even though I numbered it PATCHv5 to stress this is the
latest version, in fact there are absolutely no changes in the patches
included here since v1.  the only change is that I split out kvm bits
out to a separate patch.

Avi indicated the preferred merging path is to merge core bits throug
tip.git and the kvm bits through kvm. So I'd like it for it to be merged
in tip and merged for 3.5: this will make sure APIs for kvm are in
place, minor fixes included here will also be helpful.  Also in my
testing this gives a tiny speedup on some benchmarks, these will get
wider testing this way.  The kvm parts, posted separately, will be
subsequently merged through kvm.git: they reduce the # of exits by about
half, details are in the kvm patchset which was posted separately.

---

I'm looking at reducing the interrupt overhead for virtualized guests:
some workloads spend a large part of their time processing interrupts.
This patchset supplies infrastructure to reduce the IRQ ack overhead on
x86: the idea is to add an eoi_write callback that we can then optimize
without touching other apic functionality.

The main user weill be kvm: on kvm, an EOI write from the guest causes an
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


Michael S. Tsirkin (4):
  apic: fix typo EIO_ACK -> EOI_ACK and document
  apic: use symbolic APIC_EOI_ACK
  x86: add apic->eoi_write callback
  x86: eoi micro-optimization

 arch/x86/include/asm/apic.h            |   22 +++++++++++++++++++---
 arch/x86/include/asm/apicdef.h         |    2 +-
 arch/x86/kernel/apic/apic_flat_64.c    |    2 ++
 arch/x86/kernel/apic/apic_noop.c       |    1 +
 arch/x86/kernel/apic/apic_numachip.c   |    1 +
 arch/x86/kernel/apic/bigsmp_32.c       |    1 +
 arch/x86/kernel/apic/es7000_32.c       |    2 ++
 arch/x86/kernel/apic/numaq_32.c        |    1 +
 arch/x86/kernel/apic/probe_32.c        |    1 +
 arch/x86/kernel/apic/summit_32.c       |    1 +
 arch/x86/kernel/apic/x2apic_cluster.c  |    1 +
 arch/x86/kernel/apic/x2apic_phys.c     |    1 +
 arch/x86/kernel/apic/x2apic_uv_x.c     |    1 +
 arch/x86/platform/visws/visws_quirks.c |    2 +-
 14 files changed, 34 insertions(+), 5 deletions(-)

-- 
MST
