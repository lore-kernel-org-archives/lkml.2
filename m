Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751957Ab1GYKGM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 06:06:12 -0400
Received: from DMZ-MAILSEC-SCANNER-8.MIT.EDU ([18.7.68.37]:43110 "EHLO
	dmz-mailsec-scanner-8.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751808Ab1GYKGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 06:06:08 -0400
X-AuditID: 12074425-b7bcaae000000a1b-6a-4e2d3fe83d1a
From: Andy Lutomirski <luto@MIT.EDU>
To: Ingo Molnar <mingo@elte.hu>
Cc: x86 <x86@kernel.org>, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@MIT.EDU>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>, Avi Kivity <avi@redhat.com>
Subject: [PATCH 3.1?] x86: Remove useless stts/clts pair in __switch_to
Date: Mon, 25 Jul 2011 06:05:47 -0400
Message-Id: <38f1d91a44c243a91e441a947fed4b076dcd4ca1.1311587947.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <CAObL_7EuFXbuxpz2bzKuEReyDHo+mBxDyJSf_rjBKpdnUmEzLQ@mail.gmail.com>
References: <CAObL_7EuFXbuxpz2bzKuEReyDHo+mBxDyJSf_rjBKpdnUmEzLQ@mail.gmail.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAIsWRmVeSWpSXmKPExsUixG6nrvvCXtfPYMYrDYu+K0fZLWZd47XY
	cuczm8XlXXPYLLZcama1eNT3lt3ix4bHrA7sHrfa/jB77Jx1l91j8wotj02rOtk8Tsz4zeLx
	ft9VNo/Pm+QC2KO4bFJSczLLUov07RK4Mibtespa8Faq4s/hV4wNjH9Fuxg5OSQETCTa31xj
	hbDFJC7cW8/WxcjFISSwj1Fi9asXUM4GRom+TV+hnGdMEh9/NjOCtLAJqEh0LH3ABGKLCMhL
	7Dn2hRWkiFngGaPEiW9tbCAJYQF3iS+v37KA2CwCqhLHDixgB7F5BYIkbn/9C7VbTuLI5edA
	gzg4OAUCJVbOswYJCwkESEzcN51lAiPfAkaGVYyyKblVurmJmTnFqcm6xcmJeXmpRboWermZ
	JXqpKaWbGMEB6aK6g3HCIaVDjAIcjEo8vJr2On5CrIllxZW5hxglOZiURHkdbHX9hPiS8lMq
	MxKLM+KLSnNSiw8xSnAwK4nw3p4DVM6bklhZlVqUD5OS5mBREucN8f7vKySQnliSmp2aWpBa
	BJOV4eBQkuBNB0aekGBRanpqRVpmTglCmomDE2Q4D9Dwh3ZANbzFBYm5xZnpEPlTjIpS4rz6
	IM0CIImM0jy4XljCeMUoDvSKMG8cSBUPMNnAdb8CGswENNhRGGxwSSJCSqqBccGCbzJhwonN
	hqn72316D1nNOKJe6izrWL7YdanverGwC9bONR2bSv2a3s6V/rf3bZXtbJ7rz22uR3OZHQw+
	6bWG/7pvyswnn1s7S97sUmHNZbpvGh8Wryeynnn3/oSTyUlh71M690xleBWaHN6du4nN/MDE
	14uVzRnYd5ifOZaqtazkqeNlJZbijERDLeai4kQABPctH/MCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An stts/clts pair takes over 70 ns by itself on Sandy Bridge, and
when other things are going on it's apparently even worse.  This
saves 10% on context switches between threads that both use extended
state.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arjan van de Ven <arjan@infradead.org>, 
Cc: Avi Kivity <avi@redhat.com>
---

This is not as well tested as it should be (especially on 32-bit, where
I haven't actually tried compiling it), but I think this might be 3.1
material so I want to get it out for review before it's even more
unjustifiably late :)

Argument for inclusion in 3.1 (after a bit more testing):
 - It's dead simple.
 - It's a 10% speedup on context switching under the right conditions [1]
 - It's unlikely to slow any workload down, since it doesn't add any work
   anywwhere.

Argument against:
 - It's late.

[1] https://gitorious.org/linux-test-utils/linux-clock-tests/blobs/master/context_switch_latency.c

 arch/x86/include/asm/i387.h  |   10 ++++++++++
 arch/x86/kernel/process_32.c |   10 ++++------
 arch/x86/kernel/process_64.c |    7 +++----
 3 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
index c9e09ea..9d2d08b 100644
--- a/arch/x86/include/asm/i387.h
+++ b/arch/x86/include/asm/i387.h
@@ -295,6 +295,16 @@ static inline void __unlazy_fpu(struct task_struct *tsk)
 		tsk->fpu_counter = 0;
 }
 
+static inline void __unlazy_fpu_clts(struct task_struct *tsk)
+{
+	if (task_thread_info(tsk)->status & TS_USEDFPU) {
+		__save_init_fpu(tsk);
+	} else {
+		tsk->fpu_counter = 0;
+		clts();
+	}
+}
+
 static inline void __clear_fpu(struct task_struct *tsk)
 {
 	if (task_thread_info(tsk)->status & TS_USEDFPU) {
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index a3d0dc5..c707741 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -304,7 +304,10 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	 */
 	preload_fpu = tsk_used_math(next_p) && next_p->fpu_counter > 5;
 
-	__unlazy_fpu(prev_p);
+	if (preload_fpu)
+		__unlazy_fpu_clts(prev_p);
+	else
+		__unlazy_fpu(prev_p);
 
 	/* we're going to use this soon, after a few expensive things */
 	if (preload_fpu)
@@ -348,11 +351,6 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 		     task_thread_info(next_p)->flags & _TIF_WORK_CTXSW_NEXT))
 		__switch_to_xtra(prev_p, next_p, tss);
 
-	/* If we're going to preload the fpu context, make sure clts
-	   is run while we're batching the cpu state updates. */
-	if (preload_fpu)
-		clts();
-
 	/*
 	 * Leave lazy mode, flushing any hypercalls made here.
 	 * This must be done before restoring TLS segments so
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index b1f3f53..272bddd 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -419,11 +419,10 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	load_TLS(next, cpu);
 
 	/* Must be after DS reload */
-	__unlazy_fpu(prev_p);
-
-	/* Make sure cpu is ready for new context */
 	if (preload_fpu)
-		clts();
+		__unlazy_fpu_clts(prev_p);
+	else
+		__unlazy_fpu(prev_p);
 
 	/*
 	 * Leave lazy mode, flushing any hypercalls made here.
-- 
1.7.6

