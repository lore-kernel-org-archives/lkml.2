Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755806Ab0IBPqo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 11:46:44 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:62983 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755268Ab0IBPqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 11:46:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=jmD3nCfSyLdBIWZSBsQs6L6bwxm01j92oQ9P2ZBkgam2IG0e25TxH8/glFIZ49nhAz
         1q1//wPktblN9KdNozv70UHjwTvOa4xn5TA5iyqgy5GthqsRTzfMxHTyJ5ceqjenJKyE
         PLLs7iEWNT9ulQ1IAzanLPao+9o59HTypxfGY=
From: Namhyung Kim <namhyung@gmail.com>
To: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 00/24] ptrace cleanups
Date: Fri,  3 Sep 2010 00:46:07 +0900
Message-Id: <1283442391-23612-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patchset tries to cleanup architecture independent/dependent part of
ptrace syscall. Specifically it changes prototype of sys_ptrace() to have
its arguments @addr and @data to be unsigned long. Since user space API of
ptrace() declares them as void pointers, and most of archs consider them
unsigned already in their arch_ptrace(), it would be no harmful to change
them from (signed) long into unsigned long, IMHO.

ptrace() code accesses user area using above arguments frequently, changing
them enables to drop unnecessary __force markup when casting them to __user
pointers because sparse allows it only in case of unsigned long. And some
duplicated/misused castings can be grouped into one place in favor of new
variables to cleanup code further. This was suggested by Arnd Bergmann and
comment from Christoph Hellwig was also helpful.

Although I couldn't test all archs, I hope it will not break anything.

Any comments would be appreciated.
Thanks.


* Changes from v1:
  combine all arch signature changes into a single patch
  retain uses of get/put_user()
  rebased on top of 2.6.36-rc3

---
Namhyung Kim (24):
  ptrace: change signature of sys_ptrace() and friends
  ptrace: cleanup ptrace_request()
  ptrace: change signature of arch_ptrace()
  ptrace: cleanup arch_ptrace() on x86
  ptrace: cleanup arch_ptrace() on ARM
  ptrace: cleanup arch_ptrace() on avr32
  ptrace: cleanup arch_ptrace() and friends on Blackfin
  ptrace: cleanup arch_ptrace() on cris
  ptrace: cleanup arch_ptrace() on frv
  ptrace: cleanup arch_ptrace() on h8300
  ptrace: cleanup arch_ptrace() on m32r
  ptrace: cleanup arch_ptrace() on m68k
  ptrace: cleanup arch_ptrace() on m68knommu
  ptrace: cleanup arch_ptrace() on microblaze
  ptrace: cleanup arch_ptrace() on MIPS
  ptrace: cleanup arch_ptrace() on mn10300
  ptrace: cleanup arch_ptrace() on parisc
  ptrace: cleanup arch_ptrace() on powerpc
  ptrace: cleanup arch_ptrace() on score
  ptrace: cleanup arch_ptrace() on sh
  ptrace: cleanup arch_ptrace() on sparc
  ptrace: cleanup arch_ptrace() on tile
  ptrace: cleanup arch_ptrace() on um
  ptrace: cleanup arch_ptrace() on xtensa

 arch/alpha/kernel/ptrace.c         |    7 ++--
 arch/arm/kernel/ptrace.c           |   28 ++++++++-------
 arch/avr32/kernel/ptrace.c         |   11 +++---
 arch/blackfin/kernel/ptrace.c      |   16 +++++----
 arch/cris/arch-v10/kernel/ptrace.c |   20 +++++-----
 arch/cris/arch-v32/kernel/ptrace.c |   16 ++++----
 arch/frv/kernel/ptrace.c           |   32 ++++++++---------
 arch/h8300/kernel/ptrace.c         |   33 +++++++++---------
 arch/ia64/kernel/ptrace.c          |    3 +-
 arch/m32r/kernel/ptrace.c          |   11 +++---
 arch/m68k/kernel/ptrace.c          |   51 ++++++++++++++-------------
 arch/m68knommu/kernel/ptrace.c     |   63 ++++++++++++++++------------------
 arch/microblaze/kernel/ptrace.c    |    5 ++-
 arch/mips/kernel/ptrace.c          |   25 +++++++------
 arch/mn10300/kernel/ptrace.c       |   20 +++++-----
 arch/parisc/kernel/ptrace.c        |   13 ++++---
 arch/powerpc/kernel/ptrace.c       |   66 ++++++++++++++++++-----------------
 arch/s390/kernel/ptrace.c          |    3 +-
 arch/score/kernel/ptrace.c         |    7 ++--
 arch/sh/kernel/ptrace_32.c         |   45 +++++++++++++-----------
 arch/sh/kernel/ptrace_64.c         |   25 +++++++++-----
 arch/sparc/kernel/ptrace_32.c      |   57 ++++++++++++-------------------
 arch/sparc/kernel/ptrace_64.c      |   15 ++++----
 arch/tile/kernel/ptrace.c          |   11 +++---
 arch/um/kernel/ptrace.c            |   23 ++++++------
 arch/um/sys-i386/ptrace.c          |    4 +-
 arch/um/sys-x86_64/ptrace.c        |   11 +++---
 arch/x86/kernel/ptrace.c           |   20 +++++------
 arch/xtensa/kernel/ptrace.c        |   14 ++++---
 include/linux/ptrace.h             |   12 ++++--
 include/linux/syscalls.h           |    3 +-
 kernel/ptrace.c                    |   29 +++++++++------
 32 files changed, 360 insertions(+), 339 deletions(-)

--
1.7.2.2

