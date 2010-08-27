Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044Ab0H0Jmk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 05:42:40 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:42732 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753874Ab0H0Jmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 05:42:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=u85tieC7U/VmmG/g9riIZg4kaY3sWJQgd8snIjxBc6Vvb57s8WgmKBtsrp8M9VghcV
         5KXU2HTAfZNdvBw7YEP3nQSMJW8tsriAn0F2OEB/WQHCi2o/OvM2H/Bj4zjSRprOa1oO
         AniUNPPT3f8YK7arPSmhpureRkMs8DYxdoJ2Q=
From: Namhyung Kim <namhyung@gmail.com>
To: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org
Subject: [RFC PATCH 00/43] ptrace cleanups
Date: Fri, 27 Aug 2010 18:41:46 +0900
Message-Id: <1282902149-12991-1-git-send-email-namhyung@gmail.com>
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
Exceptional case will be "03/43 ptrace: change signature of arch_ptrace()"
commit since it changes prototype of arch_ptrace() in system header file.
It *will* break your build if it is applied alone, please use it with
your arch counterpart. The same goes vice versa, of course.

Any comments would be appreciated.
Thanks.


Namhyung Kim (43):
  ptrace: change signature of sys_ptrace() and friends
  ptrace: cleanup ptrace_request()
  ptrace: change signature of arch_ptrace()
  ptrace, x86: change signature of arch_ptrace()
  ptrace, x86: cleanup arch_ptrace()
  ptrace, alpha: change signature of arch_ptrace()
  ptrace, arm: change signature of arch_ptrace()
  ptrace, arm: cleanup arch_ptrace()
  ptrace, avr32: change signature of arch_ptrace()
  ptrace, avr32: cleanup arch_ptrace()
  ptrace, blackfin: change signature of arch_ptrace()
  ptrace, cris-v10: change signature of arch_ptrace()
  ptrace, cris-v32: change signature of arch_ptrace()
  ptrace, frv: change signature of arch_ptrace()
  ptrace, frv: cleanup arch_ptrace()
  ptrace, h8300: change signature of arch_ptrace()
  ptrace, h8300: cleanup arch_ptrace()
  ptrace, ia64: change signature of arch_ptrace()
  ptrace, m32r: change signature of arch_ptrace()
  ptrace, m32r: cleanup arch_ptrace()
  ptrace, m68k: change signature of arch_ptrace()
  ptrace, m68k: cleanup arch_ptrace()
  ptrace, m68knommu: change signature of arch_ptrace()
  ptrace, m68knommu: cleanup arch_ptrace()
  ptrace, microblaze: change signature of arch_ptrace()
  ptrace, mips: change signature of arch_ptrace()
  ptrace, mips: cleanup arch_ptrace()
  ptrace, mn10300: change signature of arch_ptrace()
  ptrace, mn10300: cleanup arch_ptrace()
  ptrace, parisc: change signature of arch_ptrace()
  ptrace, powerpc: change signature of arch_ptrace()
  ptrace, powerpc: cleanup arch_ptrace()
  ptrace, s390: change signature of arch_ptrace()
  ptrace, score: change signature of arch_ptrace()
  ptrace, sh: change signature of arch_ptrace()
  ptrace, sh: cleanup arch_ptrace()
  ptrace, sparc: change signature of arch_ptrace()
  ptrace, sparc: cleanup arch_ptrace()
  ptrace, tile: change signature of arch_ptrace()
  ptrace, um: change signature of arch_ptrace()
  ptrace, um: cleanup arch_ptrace()
  ptrace, xtensa: change signature of arch_ptrace()
  ptrace, xtensa: cleanup arch_ptrace()

 arch/alpha/kernel/ptrace.c         |    7 ++--
 arch/arm/kernel/ptrace.c           |   36 +++++++++++--------
 arch/avr32/kernel/ptrace.c         |   11 +++---
 arch/blackfin/kernel/ptrace.c      |   16 +++++----
 arch/cris/arch-v10/kernel/ptrace.c |   11 +++---
 arch/cris/arch-v32/kernel/ptrace.c |    7 ++--
 arch/frv/kernel/ptrace.c           |   32 ++++++++---------
 arch/h8300/kernel/ptrace.c         |   33 +++++++++--------
 arch/ia64/kernel/ptrace.c          |    3 +-
 arch/m32r/kernel/ptrace.c          |   11 +++---
 arch/m68k/kernel/ptrace.c          |   51 +++++++++++++-------------
 arch/m68knommu/kernel/ptrace.c     |   70 ++++++++++++++++++-----------------
 arch/microblaze/kernel/ptrace.c    |    7 ++--
 arch/mips/kernel/ptrace.c          |   26 +++++++------
 arch/mn10300/kernel/ptrace.c       |   20 +++++-----
 arch/parisc/kernel/ptrace.c        |   13 ++++---
 arch/powerpc/kernel/ptrace.c       |   70 +++++++++++++++++++----------------
 arch/s390/kernel/ptrace.c          |    3 +-
 arch/score/kernel/ptrace.c         |    7 ++--
 arch/sh/kernel/ptrace_32.c         |   51 ++++++++++++++------------
 arch/sh/kernel/ptrace_64.c         |   27 ++++++++------
 arch/sparc/kernel/ptrace_32.c      |   57 +++++++++++------------------
 arch/sparc/kernel/ptrace_64.c      |   15 ++++----
 arch/tile/kernel/ptrace.c          |   11 +++---
 arch/um/kernel/ptrace.c            |   26 +++++++-------
 arch/um/sys-i386/ptrace.c          |    4 +-
 arch/um/sys-x86_64/ptrace.c        |   11 +++---
 arch/x86/kernel/ptrace.c           |   23 +++++-------
 arch/xtensa/kernel/ptrace.c        |   14 ++++---
 include/linux/ptrace.h             |   12 ++++--
 include/linux/syscalls.h           |    3 +-
 kernel/ptrace.c                    |   29 +++++++++------
 32 files changed, 375 insertions(+), 342 deletions(-)

--
1.7.2.2

