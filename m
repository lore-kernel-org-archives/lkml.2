Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649Ab1CQIbr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 04:31:47 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57010 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751961Ab1CQIbp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 04:31:45 -0400
Date: Thu, 17 Mar 2011 09:31:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Eric Valette <eric.valette@free.fr>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Typo in linux-2.6.38/arch/x86/kernel/entry_32.S
Message-ID: <20110317083133.GC26190@elte.hu>
References: <4D80B7EE.40706@Free.fr>
 <20110316195210.GA14675@home.goodmis.org>
 <4D8118F7.5060107@free.fr>
 <1300306954.16880.51.camel@gandalf.stny.rr.com>
 <4D811E5A.7080201@free.fr>
 <1300308282.16880.57.camel@gandalf.stny.rr.com>
 <4D812349.1050501@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D812349.1050501@free.fr>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Eric Valette <eric.valette@free.fr> wrote:

> I guess its binutils git of the 2011/03/02
> 
> As far as I'm concerned I only found one occurence on one machine
> although I compiled tree 2.6.38 kernels for different machines.
> because its under the CONFIG_KVM_GUEST flag

Unofortunately there's also a CONFIG_XEN=y build breakage caused by this new 
binutils behavior, going back from v2.6.38 to v2.6.27-rc1 and breaking 
bisection builds for over 130,000 commits covering an almost 3 years window of 
kernel history.

GAS allowed such debug symbol mismatches for over a decade and never reported 
anything. It's nice that binutils now checks for this condition (we need more 
automation in this area) and the most helpful would be for the assembler to 
report the mismatch via a new *warning* - and by also ignore the symbol in 
question.

Instead this harmless condition was escallated into an unnecessary, 
retroactive, show-stopping build failure, which is an exceedingly lame and 
harmful. Tools should be permissive, and they should help not hinder 
development.

The kernel side fix is upstream already and i've attached it below. That 
obviously does not help bisecting testers who will trigger the build failure 
after the first bisection step ...

Thanks,

	Ingo

----------------->
>From 371c394af27ab7d1e58a66bc19d9f1f3ac1f67b4 Mon Sep 17 00:00:00 2001
From: Alexander van Heukelum <heukelum@fastmail.fm>
Date: Fri, 11 Mar 2011 21:59:38 +0100
Subject: [PATCH] x86, binutils, xen: Fix another wrong size directive

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
