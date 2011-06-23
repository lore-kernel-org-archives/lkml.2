Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934074Ab1FWRvR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:51:17 -0400
Received: from mail.windriver.com ([147.11.1.11]:35405 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933718Ab1FWRiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:38:14 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Alexander van Heukelum <heukelum@fastmail.fm>,
        Ingo Molnar <mingo@elte.hu>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 207/247] x86, binutils, xen: Fix another wrong size directive
Date: Thu, 23 Jun 2011 13:34:35 -0400
Message-Id: <1308850515-15242-148-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander van Heukelum <heukelum@fastmail.fm>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 371c394af27ab7d1e58a66bc19d9f1f3ac1f67b4 upstream.

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/x86/kernel/entry_64.S |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 0697ff1..a50b6cd 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1268,7 +1268,7 @@ ENTRY(xen_do_hypervisor_callback)   # do_hypervisor_callback(struct *pt_regs)
 	decl PER_CPU_VAR(irq_count)
 	jmp  error_exit
 	CFI_ENDPROC
-END(do_hypervisor_callback)
+END(xen_do_hypervisor_callback)
 
 /*
  * Hypervisor uses this for application faults while it executes.
-- 
1.7.4.4

