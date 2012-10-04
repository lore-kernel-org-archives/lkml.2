Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755677Ab2JDXpr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 19:45:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64907 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753382Ab2JDXpq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 19:45:46 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: torvalds@osdl.org
cc: dhowells@redhat.com, arnd@arndb.de, hpa@zytor.com, catalin.marinas@arm.com,
        davem@davemloft.net, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] UAPI disintegration fixes
Date: Fri, 05 Oct 2012 00:45:35 +0100
Message-ID: <20389.1349394335@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Could you pull this branch please?

There are three main parts:

 (1) I found I needed some more fixups in the wake of testing Arm64 (some
     asm/unistd.h files had weird guards that caused problems - mostly in
     arches for which I don't have a compiler) and some __KERNEL__ splitting
     needed to take place in Arm64.

 (2) I found that c6x was missing some __KERNEL__ guards in its asm/signal.h.
     Mark Salter pointed me at a tree with a patch to remove that file
     entirely and use the asm-generic variant instead.

 (3) Lastly, m68k turned out to have a header installation problem due to it
     lacking a kvm_para.h file.

     The conditional installation bits for linux/kvm_para.h, linux/kvm.h and
     linux/a.out.h weren't very well specified - and didn't work if an arch
     didn't have the asm/ version of that file, but there *was* an
     asm-generic/ version.

     It seems the "ifneq $((wildcard ...),)" for each of those three headers
     in include/kernel/Kbuild is invoked twice during header installation, and
     the second time it matches on the just installed asm-generic/kvm_para.h
     file and thus incorrectly installs linux/kvm_para.h as well.

     Most arches actually have an asm/kvm_para.h, so this wasn't detectable in
     those.

David
---
The following changes since commit 612a9aab56a93533e76e3ad91642db7033e03b69:

  Merge branch 'drm-next' of git://people.freedesktop.org/~airlied/linux (2012-10-03 23:29:23 -0700)

are available in the git repository at:


  git://git.infradead.org/users/dhowells/linux-headers.git uapi-prep

for you to fetch changes up to f3dfd599af993385b40fc7a1c947afc12729bc4d:

  UAPI: Fix conditional header installation handling (notably kvm_para.h on m68k) (2012-10-04 18:16:47 +0100)

----------------------------------------------------------------
(from the branch description for uapi-prep local branch)

clone of "master"
----------------------------------------------------------------
David Howells (4):
      UAPI: Fix the guards on various asm/unistd.h files
      UAPI: Split compound conditionals containing __KERNEL__ in Arm64
      Merge remote-tracking branch 'c6x/for-linux-next' into uapi-prep
      UAPI: Fix conditional header installation handling (notably kvm_para.h on m68k)

Mark Salter (2):
      c6x: make dsk6455 the default config
      c6x: remove c6x signal.h

 arch/arm64/include/asm/hwcap.h      |  4 +++-
 arch/arm64/include/asm/stat.h       |  4 +++-
 arch/arm64/include/asm/unistd.h     |  8 +++-----
 arch/arm64/include/asm/unistd32.h   |  4 ----
 arch/c6x/Makefile                   |  2 ++
 arch/c6x/include/asm/Kbuild         |  1 +
 arch/c6x/include/asm/signal.h       | 17 -----------------
 arch/c6x/include/asm/unistd.h       |  4 ----
 arch/hexagon/include/asm/unistd.h   |  5 -----
 arch/openrisc/include/asm/unistd.h  |  5 -----
 arch/score/include/asm/unistd.h     |  5 -----
 arch/tile/include/asm/unistd.h      |  5 -----
 arch/unicore32/include/asm/unistd.h |  4 ----
 include/asm-generic/unistd.h        |  4 ----
 include/linux/Kbuild                |  9 +++------
 15 files changed, 15 insertions(+), 66 deletions(-)
 delete mode 100644 arch/c6x/include/asm/signal.h
