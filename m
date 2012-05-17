Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761517Ab2EQKK1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 06:10:27 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33430 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761498Ab2EQKK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 06:10:26 -0400
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Cc: ralf@linux-mips.org, david.daney@cavium.com
Subject: [PATCH 0/8] patchset focus on MIPS SMP woes
Date: Thu, 17 May 2012 18:10:02 +0800
Message-Id: <1337249410-7162-1-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yong Zhang <yong.zhang@windriver.com>

Since commit 5fbd036b [sched: Cleanup cpu_active madness] and
commit 2baab4e9 [sched: Fix select_fallback_rq() vs cpu_active/cpu_online],
it's more safe to put notify_cpu_starting() and set_cpu_online() with
irq disabled, otherwise we will have a typical race condition which
above two commits try to resolve:

      CPU1                            CPU2
__cpu_up();
   mp_ops->boot_secondary();
                              start_secondary();
                                ->init_secondary();
                                  local_irq_enable();
                              <IRQ>
                              do something;
                                    wake up softirqd;
                                    try_to_wake_up();
                                      select_fallback_rq();
                                      /* select wrong cpu */
   set_cpu_online();


This patchset fix the above issue as well as set_cpu_online is
called on the caller cpu.

BTW, I'm only running it on Cavium board because of limited source,
so if anyone is interested to test it on other board, that's great :)

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>

Yong Zhang (8):
  MIPS: Octeon: delay enable irq to ->smp_finish()
  MIPS: BMIPS: delay irq enable to ->smp_finish()
  MIPS: SMTC: delay irq enable to ->smp_finish()
  MIPS: Yosemite: delay irq enable to ->smp_finish()
  MIPS: call ->smp_finish() a little late
  MIPS: call set_cpu_online() on the uping cpu with irq disabled
  MIPS: smp: Warn on too early irq enable
  MIPS: sync-r4k: remove redundant irq operation

 arch/mips/cavium-octeon/smp.c       |    2 +-
 arch/mips/kernel/smp-bmips.c        |   14 +++++++-------
 arch/mips/kernel/smp.c              |   12 +++++++++---
 arch/mips/kernel/smtc.c             |    3 ++-
 arch/mips/kernel/sync-r4k.c         |    5 -----
 arch/mips/pmc-sierra/yosemite/smp.c |    2 +-
 6 files changed, 20 insertions(+), 18 deletions(-)

