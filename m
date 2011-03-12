Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752567Ab1CLIE7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 03:04:59 -0500
Received: from hera.kernel.org ([140.211.167.34]:60744 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751711Ab1CLIE5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 03:04:57 -0500
Date: Sat, 12 Mar 2011 08:04:00 GMT
From: tip-bot for Alexander van Heukelum <heukelum@fastmail.fm>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, heukelum@fastmail.fm, jeremy@goop.org,
        akpm@linux-foundation.org, jbeulich@novell.com,
        kees.cook@canonical.com, tglx@linutronix.de, mingo@elte.hu,
        hjl.tools@gmail.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, heukelum@fastmail.fm, jeremy@goop.org,
        akpm@linux-foundation.org, jbeulich@novell.com,
        kees.cook@canonical.com, tglx@linutronix.de, hjl.tools@gmail.com,
        mingo@elte.hu
In-Reply-To: <1299877178-26063-1-git-send-email-heukelum@fastmail.fm>
References: <1299877178-26063-1-git-send-email-heukelum@fastmail.fm>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86, binutils, xen: Fix another wrong size directive
Message-ID: <tip-371c394af27ab7d1e58a66bc19d9f1f3ac1f67b4@git.kernel.org>
Git-Commit-ID: 371c394af27ab7d1e58a66bc19d9f1f3ac1f67b4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 12 Mar 2011 08:04:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  371c394af27ab7d1e58a66bc19d9f1f3ac1f67b4
Gitweb:     http://git.kernel.org/tip/371c394af27ab7d1e58a66bc19d9f1f3ac1f67b4
Author:     Alexander van Heukelum <heukelum@fastmail.fm>
AuthorDate: Fri, 11 Mar 2011 21:59:38 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 12 Mar 2011 09:02:29 +0100

x86, binutils, xen: Fix another wrong size directive

The latest binutils (2.21.0.20110302/Ubuntu) breaks the build
yet another time, under CONFIG_XEN=y due to a .size directive that
refers to a slightly differently named (hence, to the now very
strict and unforgiving assembler, non-existent) symbol.

[ mingo:

   This unnecessary build breakage caused by new binutils
   version 2.21 gets escallated back several kernel releases spanning
   several years of Linux history, affecting over 130,000 upstream
   kernel commits (!), on CONFIG_XEN=y 64-bit kernels (i.e. essentially
   affecting all major Linux distro kernel configs).

   Git annotate tells us that this slight debug symbol code mismatch
   bug has been introduced in 2008 in commit 3d75e1b8:

     3d75e1b8        (Jeremy Fitzhardinge    2008-07-08 15:06:49 -0700 1231) ENTRY(xen_do_hypervisor_callback)   # do_hypervisor_callback(struct *pt_regs)

   The 'bug' is just a slight assymetry in ENTRY()/END()
   debug-symbols sequences, with lots of assembly code between the
   ENTRY() and the END():

     ENTRY(xen_do_hypervisor_callback)   # do_hypervisor_callback(struct *pt_regs)
       ...
     END(do_hypervisor_callback)

   Human reviewers almost never catch such small mismatches, and binutils
   never even warned about it either.

   This new binutils version thus breaks the Xen build on all upstream kernels
   since v2.6.27, out of the blue.

   This makes a straightforward Git bisection of all 64-bit Xen-enabled kernels
   impossible on such binutils, for a bisection window of over hundred
   thousand historic commits. (!)

   This is a major fail on the side of binutils and binutils needs to turn
   this show-stopper build failure into a warning ASAP. ]

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Jan Beulich <jbeulich@novell.com>
Cc: H.J. Lu <hjl.tools@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Kees Cook <kees.cook@canonical.com>
LKML-Reference: <1299877178-26063-1-git-send-email-heukelum@fastmail.fm>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/entry_64.S |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index aed1ffb..bbd5c80 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1248,7 +1248,7 @@ ENTRY(xen_do_hypervisor_callback)   # do_hypervisor_callback(struct *pt_regs)
 	decl PER_CPU_VAR(irq_count)
 	jmp  error_exit
 	CFI_ENDPROC
-END(do_hypervisor_callback)
+END(xen_do_hypervisor_callback)
 
 /*
  * Hypervisor uses this for application faults while it executes.
