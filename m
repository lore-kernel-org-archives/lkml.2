Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758050Ab1I2X0t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 19:26:49 -0400
Received: from claw.goop.org ([74.207.240.146]:43158 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752734Ab1I2X0s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 19:26:48 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "David S. Miller" <davem@davemloft.net>,
        David Daney <david.daney@cavium.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Jan Glauber <jang@linux.vnet.ibm.com>, Jason Baron <jbaron@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH RFC 0/8] jump-label: allow early jump_label_enable()
Date: Thu, 29 Sep 2011 16:26:30 -0700
Message-Id: <cover.1317338254.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.6.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Hi all,

While trying to use the jump-label stuff for my PV ticketlock changes,
I had some problems using jump labels early in the kernel's lifetime
(pre-SMP).

The basic problem is that even if I enable a jump_label_key, the
jump_label_init() initializer ends up nopping out all the code sites.

This series enables early use of jump labels by making
jump_label_init() respect already-enabled keys.

To do this, I've dropped arch_jump_label_poke_text_early() and
replaced it with arch_jump_label_transform_early(), which is the same
as the non-_early variant except that it expects to be operating in a
pre-SMP environment.

I've tested this on x86, but all the other architecture changes are
completely untested (not even breathed on by a compiler).

One big question which arises is whether the _early() function is
necessary at all.  All the stop_machine/mutex/etc stuff that
arch_jump_label_transform() ends up doing is redundant pre-SMP, but it
shouldn't hurt.  Maybe we can just drop the _early function?  It works
on x86, at least, because jump_label_enable() works, which uses the full
form.  And dropping it would reduce this to a very much smaller series.

Thanks,
	J

Jeremy Fitzhardinge (8):
  jump_label: use proper atomic_t initializer
  jump_label: if a key has already been initialized, don't nop it out
  x86/jump_label: add arch_jump_label_transform_early()
  sparc/jump_label: add arch_jump_label_transform_early()
  mips/jump_label: add arch_jump_label_transform_early()
  powerpc/jump_label: add arch_jump_label_transform_early()
  s390/jump-label: add arch_jump_label_transform_early()
  jump_label: drop default arch_jump_label_transform_early

 arch/mips/kernel/jump_label.c    |   21 +++++++++++++---
 arch/powerpc/kernel/jump_label.c |    6 ++++
 arch/s390/kernel/jump_label.c    |   49 +++++++++++++++++++++++--------------
 arch/sparc/kernel/jump_label.c   |   24 +++++++++++-------
 arch/x86/kernel/jump_label.c     |   20 +++++++++++----
 include/linux/jump_label.h       |    7 +++--
 kernel/jump_label.c              |   20 ++++++---------
 7 files changed, 94 insertions(+), 53 deletions(-)

-- 
1.7.6.2

