Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757246Ab2ASWlv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 17:41:51 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38452 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756699Ab2ASWlr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 17:41:47 -0500
Date: Thu, 19 Jan 2012 14:41:03 -0800
Message-Id: <201201192241.q0JMf3uq003538@tazenda.hos.anvin.org>
From: "H. Peter Anvin" <hpa@zytor.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] perf fixes for v3.3-rc1
Cc: Ben Hutchings <ben@decadent.org.uk>, Dave Jones <davej@redhat.com>,
        David Daney <david.daney@cavium.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ulrich Drepper <drepper@gmail.com>,
        WANG Cong <xiyou.wangcong@gmail.com>, stable@kernel.org.#.3.0+,
        stable@vger.kernel.org.#.3.2, yrl.pp-manager.tt@hitachi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit 805a6af8dba5dfdd35ec35dc52ec0122400b2610:

  Linux 3.2 (2012-01-04 15:55:44 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-urgent-for-linus

The head of this tree is 6eadf1075c6f923fece419e38cf05bff559aefcd.

David Daney (1):
      recordmcount: Fix handling of elf64 big-endian objects.

Ingo Molnar (1):
      Merge branch 'tip/perf/urgent-2' of git://git.kernel.org/.../rostedt/linux-trace into perf/urgent

Steven Rostedt (1):
      tracepoints/module: Fix disabling tracepoints with taint CRAP or OOT

Ulrich Drepper (1):
      x86/kprobes: Fix typo transferred from Intel manual

xiyou.wangcong@gmail.com (1):
      x86/kprobes: Add arch/x86/tools/insn_sanity to .gitignore

 arch/x86/.gitignore             |    1 +
 arch/x86/lib/x86-opcode-map.txt |    4 +++-
 kernel/tracepoint.c             |    7 ++++---
 scripts/recordmcount.h          |    2 +-
 4 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/x86/.gitignore b/arch/x86/.gitignore
index 0280790..7cab8c0 100644
--- a/arch/x86/.gitignore
+++ b/arch/x86/.gitignore
@@ -1,3 +1,4 @@
 boot/compressed/vmlinux
 tools/test_get_len
+tools/insn_sanity
 
diff --git a/arch/x86/lib/x86-opcode-map.txt b/arch/x86/lib/x86-opcode-map.txt
index a793da5..8641bbb 100644
--- a/arch/x86/lib/x86-opcode-map.txt
+++ b/arch/x86/lib/x86-opcode-map.txt
@@ -210,7 +210,9 @@ ab: STOS/W/D/Q Yv,rAX
 ac: LODS/B AL,Xb
 ad: LODS/W/D/Q rAX,Xv
 ae: SCAS/B AL,Yb
-af: SCAS/W/D/Q rAX,Xv
+# Note: The May 2011 Intel manual shows Xv for the second parameter of the
+# next instruction but Yv is correct
+af: SCAS/W/D/Q rAX,Yv
 # 0xb0 - 0xbf
 b0: MOV AL/R8L,Ib
 b1: MOV CL/R9L,Ib
diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index db110b8..f1539de 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -634,10 +634,11 @@ static int tracepoint_module_coming(struct module *mod)
 	int ret = 0;
 
 	/*
-	 * We skip modules that tain the kernel, especially those with different
-	 * module header (for forced load), to make sure we don't cause a crash.
+	 * We skip modules that taint the kernel, especially those with different
+	 * module headers (for forced load), to make sure we don't cause a crash.
+	 * Staging and out-of-tree GPL modules are fine.
 	 */
-	if (mod->taints)
+	if (mod->taints & ~((1 << TAINT_OOT_MODULE) | (1 << TAINT_CRAP)))
 		return 0;
 	mutex_lock(&tracepoints_mutex);
 	tp_mod = kmalloc(sizeof(struct tp_module), GFP_KERNEL);
diff --git a/scripts/recordmcount.h b/scripts/recordmcount.h
index f40a6af6..54e35c1 100644
--- a/scripts/recordmcount.h
+++ b/scripts/recordmcount.h
@@ -462,7 +462,7 @@ __has_rel_mcount(Elf_Shdr const *const relhdr,  /* is SHT_REL or SHT_RELA */
 		succeed_file();
 	}
 	if (w(txthdr->sh_type) != SHT_PROGBITS ||
-	    !(w(txthdr->sh_flags) & SHF_EXECINSTR))
+	    !(_w(txthdr->sh_flags) & SHF_EXECINSTR))
 		return NULL;
 	return txtname;
 }
