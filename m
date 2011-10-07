Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965456Ab1JGLkm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 07:40:42 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52879 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965416Ab1JGLkl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 07:40:41 -0400
Subject: Re: [PATCH 07/12] perf_events: add LBR software filter support for
 Intel X86
From: Peter Zijlstra <peterz@infradead.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Stephane Eranian <eranian@google.com>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, acme@redhat.com,
        ming.m.lin@intel.com, robert.richter@amd.com, ravitillo@lbl.gov
Date: Fri, 07 Oct 2011 13:40:22 +0200
In-Reply-To: <4E8EE1B6.1030907@hitachi.com>
References: <1317912555-9559-1-git-send-email-eranian@google.com>
	 <1317912555-9559-8-git-send-email-eranian@google.com>
	 <20111006153229.GJ14482@one.firstfloor.org>
	 <CABPqkBSNejhZ_ciyLTUFAybBqqGB-8QzVrPj8OTbAhQ_+mj4aw@mail.gmail.com>
	 <4E8EE1B6.1030907@hitachi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317987622.31132.15.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-10-07 at 20:25 +0900, Masami Hiramatsu wrote:
> Oops, I've thought existing code is only for kernel. Hmm, I guess
> this could cause a problem when running 32bit binary on x86-64.
> 
I queued below.
> 
---
Subject: perf, x86: Fix PEBS instruction unwind
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Fri Oct 07 13:36:40 CEST 2011

Masami spotted that we always try to decode the instruction stream as
64bit instructions when running a 64bit kernel, this doesn't work for
ia32-compat proglets.

Use TIF_IA32 to detect if we need to use the 32bit instruction
decoder.

Reported-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/x86/kernel/cpu/perf_event_intel_ds.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

Index: linux-2.6/arch/x86/kernel/cpu/perf_event_intel_ds.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -493,6 +493,7 @@ static int intel_pmu_pebs_fixup_ip(struc
 	unsigned long from = cpuc->lbr_entries[0].from;
 	unsigned long old_to, to = cpuc->lbr_entries[0].to;
 	unsigned long ip = regs->ip;
+	int is_64bit = 0;
 
 	/*
 	 * We don't need to fixup if the PEBS assist is fault like
@@ -544,7 +545,10 @@ static int intel_pmu_pebs_fixup_ip(struc
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

