Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933449Ab2KEWub (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 17:50:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48833 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933360Ab2KEWuZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 17:50:25 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: mingo@kernel.org, tglx@linutronix.de, acme@ghostprotocols.net,
        bp@alien8.de, namhyung@gmail.com
cc: dhowells@redhat.com, torvalds@linux-foundation.org, paulus@samba.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: tools, perf: Fix up for x86 UAPI disintegration
Date: Mon, 05 Nov 2012 22:49:51 +0000
Message-ID: <15094.1352155791@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

I've posted a revised version of my perf patches to my UAPI disintegration GIT
tree.  If you look here:

	http://git.infradead.org/users/dhowells/linux-headers.git/shortlog/refs/tags/uapi-perf-x86-20121105

you can see the result.

To construct this, I did the following:

 (1) Created a branch (perf-uapi) at v3.7-rc4.

 (2) Merged tipbot's perf/core branch into that.

 (3) Added a patch to export asm/svm.h, asm/vmx.h and asm/perf_regs.h from the
     x86 arch so that the disintegration scripts will deal with them.

     This is at the x86-bits tag.

 (4) Added a patch to manually export and disintegrate linux/hw_breakpoint.h.

 (5) Rebased and updated a pair of patches to make the tools Makefile use a
     defined function to handle descent into tools directories.

 (6) Rebased and updated the patch to fix perf for x86.

     This is at the perf-uapi-20121105 tag.

 (7) Re-disintegrated the x86 UAPI on top of the x86-bits tag to make sure
     that the headers exported in (3) get processed.

     This is on the disintegrate-x86 branch at tag disintegrate-x86-20121105.

 (8) Merged the disintegrate-x86 branch in to the working branch.

     This is at the uapi-perf-x86-20121105 branch.

perf builds successfully as:

	make O=~+/foo tools/perf
	make O=~+/foo -C tools perf
	make O=~+/foo -C tools/perf

at points (6) and (8).

It doesn't seem that I can post the patches, given there is a pair of merge
commits in the series.  If it is desirable, then I can drop the top merge
commit and post the patches.  For information, attached is a pull request for
the patches between the two merge commits.

David
---
The following changes since commit 4adf23e40d6e93169358b4dc5d616b921b6e1982:

  Merge remote-tracking branch 'tipbot/perf/core' into perf-uapi (2012-11-05 14:09:06 +0000)

are available in the git repository at:


  git://git.infradead.org/users/dhowells/linux-headers.git tags/perf-uapi-20121105

for you to fetch changes up to 628f74ef1d92f7bfb6e0739d72c740a17a6048c0:

  perf: Make perf build for x86 with UAPI disintegration applied (2012-11-05 21:16:51 +0000)

----------------------------------------------------------------
perf fixes 2012-11-05

----------------------------------------------------------------
David Howells (5):
      x86: Export asm/{svm.h,vmx.h,perf_regs.h}
      UAPI: Export and disintegrate linux/hw_breakpoint.h
      tools: Define a Makefile function to do subdir processing
      tools: Honour the O= flag when tool build called from a higher Makefile
      perf: Make perf build for x86 with UAPI disintegration applied

 Makefile                                |  6 ++++--
 arch/x86/include/asm/Kbuild             |  3 +++
 include/linux/hw_breakpoint.h           | 31 +------------------------------
 include/uapi/linux/Kbuild               |  1 +
 include/uapi/linux/hw_breakpoint.h      | 30 ++++++++++++++++++++++++++++++
 tools/Makefile                          | 24 ++++++++++++------------
 tools/perf/Makefile                     | 26 +++++++++++++++++++++++++-
 tools/perf/arch/x86/include/perf_regs.h |  2 +-
 tools/perf/builtin-kvm.c                |  6 +++---
 tools/perf/builtin-test.c               |  2 +-
 tools/perf/perf.h                       | 16 +++-------------
 tools/perf/util/evsel.c                 |  4 ++--
 tools/perf/util/evsel.h                 |  2 +-
 tools/perf/util/header.h                |  2 +-
 tools/perf/util/parse-events-test.c     |  2 +-
 tools/perf/util/parse-events.c          |  2 +-
 tools/perf/util/parse-events.h          |  2 +-
 tools/perf/util/pmu.h                   |  2 +-
 tools/perf/util/session.h               |  2 +-
 tools/scripts/Makefile.include          | 23 ++++++++++++++++++++---
 20 files changed, 113 insertions(+), 75 deletions(-)
 create mode 100644 include/uapi/linux/hw_breakpoint.h
