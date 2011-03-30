Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965150Ab1C3VX1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:23:27 -0400
Received: from mga09.intel.com ([134.134.136.24]:9067 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965123Ab1C3VJ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:09:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="621238660"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: heukelum@fastmail.fm, ak@linux.intel.com, jeremy@goop.org,
        jbeulich@novell.com, hjl.tools@gmail.com,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        hpa@zytor.com, kees.cook@canonical.com, mingo@elte.hu, gregkh@suse.de,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [219/275] x86, binutils, xen: Fix another wrong size directive
Message-Id: <20110330210744.4705D3E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:07:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Alexander van Heukelum <heukelum@fastmail.fm>

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Jan Beulich <jbeulich@novell.com>
Cc: H.J. Lu <hjl.tools@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Kees Cook <kees.cook@canonical.com>
LKML-Reference: <1299877178-26063-1-git-send-email-heukelum@fastmail.fm>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/entry_64.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.35.y/arch/x86/kernel/entry_64.S
===================================================================
--- linux-2.6.35.y.orig/arch/x86/kernel/entry_64.S	2011-03-29 22:50:29.569501808 -0700
+++ linux-2.6.35.y/arch/x86/kernel/entry_64.S	2011-03-29 23:03:02.805228392 -0700
@@ -1268,7 +1268,7 @@
 	decl PER_CPU_VAR(irq_count)
 	jmp  error_exit
 	CFI_ENDPROC
-END(do_hypervisor_callback)
+END(xen_do_hypervisor_callback)
 
 /*
  * Hypervisor uses this for application faults while it executes.
