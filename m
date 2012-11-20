Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157Ab2KTKlA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 05:41:00 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:55798 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786Ab2KTKk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 05:40:59 -0500
Date: Tue, 20 Nov 2012 11:40:53 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Mel Gorman <mgorman@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH 00/27] Latest numa/core release, v16
Message-ID: <20121120104053.GA15302@gmail.com>
References: <1353291284-2998-1-git-send-email-mingo@kernel.org>
 <20121119162909.GL8218@suse.de>
 <20121119191339.GA11701@gmail.com>
 <20121119211804.GM8218@suse.de>
 <20121119223604.GA13470@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121119223604.GA13470@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


btw., mind sending me a fuller/longer profile than the one 
you've sent before? In particular does your system have any 
vsyscall emulation page fault overhead?

If yes, does the patch below change anything for you?

Thanks,

	Ingo

---------------->
Subject: x86/vsyscall: Add Kconfig option to use native vsyscalls, switch to it
From: Ingo Molnar <mingo@kernel.org>

Apparently there's still plenty of systems out there triggering
the vsyscall emulation page faults - causing hard to track down
performance regressions on page fault intense workloads...

Some people seem to have run into that with threading-intense
Java workloads.

So until there's a better solution to this, add a Kconfig switch
to make the vsyscall mode configurable and turn native vsyscall
support back on by default.

Distributions whose libraries and applications use the vDSO and never
access the vsyscall page can change the config option to off.

Note, I don't think we want to expose the "none" option via a Kconfig
switch - it breaks the ABI. So it's "native" versus "emulate", with
"none" being available as a kernel boot option, for the super paranoid.

For more background, see these upstream commits:

  3ae36655b97a x86-64: Rework vsyscall emulation and add vsyscall= parameter
  5cec93c216db x86-64: Emulate legacy vsyscalls

Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/Kconfig              |   21 +++++++++++++++++++++
 arch/x86/kernel/vsyscall_64.c |    8 +++++++-
 2 files changed, 28 insertions(+), 1 deletion(-)

Index: linux/arch/x86/Kconfig
===================================================================
--- linux.orig/arch/x86/Kconfig
+++ linux/arch/x86/Kconfig
@@ -2234,6 +2234,27 @@ config X86_X32
 	  elf32_x86_64 support enabled to compile a kernel with this
 	  option set.
 
+config X86_VSYSCALL_COMPAT
+	bool "vsyscall compatibility"
+	default y
+	help
+	  vsyscalls, as global executable pages, can be a security hole
+	  escallation helper by exposing an easy shell code target with
+	  a predictable address.
+
+	  Many versions of glibc rely on the vsyscall page though, so it
+	  cannot be eliminated unconditionally. If you disable this
+	  option these systems will still work but might incur the overhead
+	  of vsyscall emulation page faults.
+
+	  The vsyscall=none, vsyscall=emulate, vsyscall=native kernel boot
+	  option can be used to override this mode as well.
+
+	  Keeping this option enabled leaves the vsyscall page enabled,
+	  i.e. vsyscall=native. Disabling this option means vsyscall=emulate.
+
+	  If unsure, say Y.
+
 config COMPAT
 	def_bool y
 	depends on IA32_EMULATION || X86_X32
Index: linux/arch/x86/kernel/vsyscall_64.c
===================================================================
--- linux.orig/arch/x86/kernel/vsyscall_64.c
+++ linux/arch/x86/kernel/vsyscall_64.c
@@ -56,7 +56,13 @@
 DEFINE_VVAR(int, vgetcpu_mode);
 DEFINE_VVAR(struct vsyscall_gtod_data, vsyscall_gtod_data);
 
-static enum { EMULATE, NATIVE, NONE } vsyscall_mode = EMULATE;
+static enum { EMULATE, NATIVE, NONE } vsyscall_mode =
+#ifdef CONFIG_X86_VSYSCALL_COMPAT
+	NATIVE
+#else
+	EMULATE
+#endif
+;
 
 static int __init vsyscall_setup(char *str)
 {

