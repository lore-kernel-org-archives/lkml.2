Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757398Ab1LGQSv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 11:18:51 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33304 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757210Ab1LGQSq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 11:18:46 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Dec  7 08:08:27 2011
Message-Id: <20111207160827.697962982@clark.kroah.org>
User-Agent: quilt/0.50-23.1
Date: Wed, 07 Dec 2011 08:07:22 -0800
From: Greg KH <gregkh@suse.de>
To: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Cc: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <alan@lxorguk.ukuu.org.uk>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>
Subject: [62/80] perf/x86: Fix PEBS instruction unwind
In-Reply-To: <20111207161256.GA7736@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <a.p.zijlstra@chello.nl>

commit 57d1c0c03c6b48b2b96870d831b9ce6b917f53ac upstream.

Masami spotted that we always try to decode the instruction stream as
64bit instructions when running a 64bit kernel, this doesn't work for
ia32-compat proglets.

Use TIF_IA32 to detect if we need to use the 32bit instruction
decoder.

Reported-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/cpu/perf_event_intel_ds.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -508,6 +508,7 @@ static int intel_pmu_pebs_fixup_ip(struc
 	unsigned long from = cpuc->lbr_entries[0].from;
 	unsigned long old_to, to = cpuc->lbr_entries[0].to;
 	unsigned long ip = regs->ip;
+	int is_64bit = 0;
 
 	/*
 	 * We don't need to fixup if the PEBS assist is fault like
@@ -559,7 +560,10 @@ static int intel_pmu_pebs_fixup_ip(struc
 		} else
 			kaddr = (void *)to;
 
-		kernel_insn_init(&insn, kaddr);
+#ifdef CONFIG_X86_64
+		is_64bit = kernel_ip(to) || !test_thread_flag(TIF_IA32);
+#endif
+		insn_init(&insn, kaddr, is_64bit);
 		insn_get_length(&insn);
 		to += insn.length;
 	} while (to < ip);


