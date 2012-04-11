Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934107Ab2DKXwB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 19:52:01 -0400
Received: from mail.windriver.com ([147.11.1.11]:39417 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934062Ab2DKXvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 19:51:54 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, davem@davemloft.net,
        tony@bakeyournoodle.com, mmarek@suse.cz, lacombar@gmail.com,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH 0/5] RFC: strip 15,000 lines from a typical autoconf.h
Date: Wed, 11 Apr 2012 19:50:52 -0400
Message-Id: <1334188257-3449-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some linux-next builds were showing thousands of repeated warnings like:

 linux/netdevice.h:964:1: warning: "__enabled_CONFIG_FCOE" is not defined [-Wundef]

An example is at:  http://kisskb.ellerman.id.au/kisskb/buildresult/6091752/

TonyB proposed a fix, and DaveM indicated IS_ENABLED should be fixed
instead.  [ https://lkml.org/lkml/2012/3/15/612 ]

This got me looking at IS_ENABLED, and I realized that to support using
this thing in C code, it was bloating our autoconf.h header file by
about 15,000 lines.  Ouch.  And it still doesn't have all the possible
lines in it, otherwise we'd not see warnings like the above.

If we limit its use to just CPP #if ... directives, we can unwind the
bloat and get down to less than ~1k of lines.

Fortunately IS_ENABLED is fairly new, and of the ~300 instances, only
a handful are actually in C code, so it is easy to unwind those.

The other downside of C users, I thought while unwinding the above users,
is that the use of IS_ENABLED on Kconfig bools in C if (...) conditionals
can give the misleading impression that the two code paths will exist in
the binary, and that the path is chosen at runtime (which it is not).

Commits 1 --> 4 are just largely unwind, so if you are going to just
look at one, please skip to commit #5 and read the commit log there,
as it has more details on how this bloat all came about.

I want to test this more, but I also wanted to get some initial
feedback in case I'm completely barking up the wrong tree here.

Commit ce1744f4ed20ca8 seems to endorse C users of IS_ENABLED, and
it went through Linus and Andrew, so I'm not sure scrapping C users
as a solution will be universally agreeable...

Thanks,
Paul
---

Paul Gortmaker (5):
  Revert "mm: replace PAGE_MIGRATION with IS_ENABLED(CONFIG_MIGRATION)"
  ARM: remove C users of IS_ENABLED on THUMB2_KERNEL
  drivers/net: remove IS_ENABLED usage from wiznet drivers
  Revert "kconfig: fix __enabled_ macros definition for invisible and
    un-selected symbols"
  kconfig: limit IS_ENABLED & similar to CPP usage

 arch/arm/include/asm/opcodes.h      |    6 ++++
 arch/arm/kernel/ftrace.c            |    9 +-----
 arch/arm/kernel/insn.c              |    9 +++---
 arch/arm/kernel/kprobes.c           |   34 ++++++++++++------------
 arch/arm/kernel/patch.c             |   28 ++++++++++---------
 drivers/net/ethernet/wiznet/w5100.c |    9 ++++--
 drivers/net/ethernet/wiznet/w5300.c |   18 ++++++++----
 include/linux/kconfig.h             |    8 +++---
 include/linux/migrate.h             |    2 +
 mm/mprotect.c                       |    2 +-
 mm/rmap.c                           |    7 ++---
 scripts/kconfig/confdata.c          |   49 +++++++++-------------------------
 12 files changed, 86 insertions(+), 95 deletions(-)

-- 
1.7.9.1

