Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751410Ab1JMAIq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 20:08:46 -0400
Received: from claw.goop.org ([74.207.240.146]:47050 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750784Ab1JMAIp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 20:08:45 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "David S. Miller" <davem@davemloft.net>,
        David Daney <david.daney@cavium.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Jan Glauber <jang@linux.vnet.ibm.com>, Jason Baron <jbaron@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH RFC V4 00/10] jump-label: allow early jump_label_enable()
Date: Wed, 12 Oct 2011 17:08:31 -0700
Message-Id: <cover.1318464169.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.6.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

[ Change from V3: Move jump_label_init() much earlier, so that the
  jump_label mechanism will be reliabily initialized before use. ]

While trying to use the jump-label stuff for my PV ticketlock changes,
I had some problems using jump labels early in the kernel's lifetime
(pre-SMP).

The basic problem is that even if I enable a jump_label_key, the
jump_label_init() initializer ends up nopping out all the code sites.

This series enables early use of jump labels by making
jump_label_init() respect already-enabled keys.

To do this, I've dropped arch_jump_label_poke_text_early() and
replaced it with arch_jump_label_transform(), allowing it to either
insert an optimal nop, or leave the jump in place.

Part of this series makes sure that stop_machine() is safe to call
in an early pre-SMP environment, by making it just call the function
with interrupts disabled.

git://github.com/jsgf/linux-xen upstream/jump-label-noearly

Jeremy Fitzhardinge (10):
  jump_label: use proper atomic_t initializer
  stop_machine: make stop_machine safe and efficient to call early
  jump_label: if a key has already been initialized, don't nop it out
  x86/jump_label: drop arch_jump_label_text_poke_early()
  sparc/jump_label: drop arch_jump_label_text_poke_early()
  jump_label: add arch_jump_label_transform_static() to optimise
    non-live code updates
  s390/jump-label: add arch_jump_label_transform_static()
  x86/jump_label: add arch_jump_label_transform_static()
  x86/jump_label: use GENERIC_NOP5_ATOMIC instead of jmp5 +0
  jump-label: initialize jump-label subsystem much earlier

 arch/s390/kernel/jump_label.c     |   51 ++++++++++++++++++++++--------------
 arch/sparc/kernel/jump_label.c    |    8 ------
 arch/x86/include/asm/jump_label.h |    3 +-
 arch/x86/kernel/jump_label.c      |   20 ++++++++++----
 include/linux/jump_label.h        |   23 ++++++++++------
 init/main.c                       |    1 +
 kernel/jump_label.c               |   37 +++++++++++++++-----------
 kernel/stop_machine.c             |   22 ++++++++++++++++
 8 files changed, 105 insertions(+), 60 deletions(-)

-- 
1.7.6.4

