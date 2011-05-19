Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933564Ab1ESQdm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 12:33:42 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:33379 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933481Ab1ESQdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 12:33:40 -0400
Date: Thu, 19 May 2011 12:33:21 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: dkiper@net-space.pl, kevin.tian@intel.com, tinnycloud@hotmail.com,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [GIT PULL] (xen) stable/irq stable/p2m.bugfixes stable/e820.bugfixes
 stable/mmu.bugfixes
Message-ID: <20110519163321.GC13186@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090209.4DD5465D.0039:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Linus,

Please pull these four branches:

  git pull git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/irq stable/p2m.bugfixes stable/e820.bugfixes stable/mmu.bugfixes

Which has ..um.. bug-fixes.

#stable/irq is based of v2.6.39-rc7 (693d92a1bbc9e42681c42ed190bd42b636ca876f)
which has one patch that cleans up the way event channels are funneled into the
right IRQ handler in Linux. The way we do the things right is pretty horrid.
In the Xen hypervisor, GSI, vectors, or virtual vectors are all funneled in their
respective event channels. On the Linux side we have to de-multiplex this
and let the right IRQ handler handle it. Except that we were overloading the
chip functions that dealt with GSI and vectors (MSI/MSI-X) causing us to have to
do some extra hack^H^H^H fancy unmasking/masking. All this is now going away.
The IRQ ACKing might be slower now, but it is much easier to understand.

#stable/p2m.bugfixes is based off v2.6.39-rc1 (0ce790e7d736cedc563e1fb4e998babf5a4dbc3d)
During save and restore we did not remember the PFN to MFN entries that were
created for the E820 PCI holes. Hence during restore we would forget them
and crash.

#stable/e820.bugfixes is based off v2.6.39-rc7 (693d92a1bbc9e42681c42ed190bd42b636ca876f)
.. has two fixes for the patches that went in 2.6.39. We were mishandling
the E820 parsing under certain conditions - workaround existed so they weren't
being pushed for 2.6.39.

#stable/mmu.bugfixes is based off v2.6.39-rc7 (693d92a1bbc9e42681c42ed190bd42b636ca876f)
.. fixes a nasty race condition. This particular bug started manifesting
itself when git commit 831d52bc153971b70e64eccfbed2b232394f22f8
("x86, mm: avoid possible bogus tlb entries by clearing prev mm_cpumask after") was
introduced.

The diff stat:

 arch/x86/xen/mmu.c   |    2 +-
 arch/x86/xen/p2m.c   |   30 ++++++++++++-
 arch/x86/xen/setup.c |    6 ++-
 drivers/xen/events.c |  113 ++++++++++++++++++++++++++++++++------------------
 4 files changed, 107 insertions(+), 44 deletions(-)

and the full log:

Daniel Kiper (1):
      xen/setup: Fix for incorrect xen_extra_mem_start initialization under 32-bit

Konrad Rzeszutek Wilk (2):
      xen/setup: Ignore E820_UNUSABLE when setting 1-1 mappings.
      xen/p2m: Create entries in the P2M_MFN trees's to track 1-1 mappings

Stefano Stabellini (1):
      xen: do not clear and mask evtchns in __xen_evtchn_do_upcall

Tian, Kevin (1):
      xen mmu: fix a race window causing leave_mm BUG()

