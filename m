Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732Ab0FCTeL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 15:34:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35978 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753010Ab0FCTeJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 15:34:09 -0400
Date: Thu, 3 Jun 2010 21:32:39 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>,
       Vegard Nossum <vegard.nossum@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] x86: make save_stack_address() !CONFIG_FRAME_POINTER
	friendly
Message-ID: <20100603193239.GA31530@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If CONFIG_FRAME_POINTER=n, print_context_stack() shouldn't neglect the
non-reliable addresses on stack, this is all we have if dump_trace(bp)
is called with the wrong or zero bp.

For example, /proc/pid/stack doesn't work if CONFIG_FRAME_POINTER=n.

This patch obviously has no effect if CONFIG_FRAME_POINTER=y, otherwise
it reverts 1650743c "x86: don't save unreliable stack trace entries".

Also, remove the unnecessary type-cast.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 arch/x86/kernel/stacktrace.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- 34-rc1/arch/x86/kernel/stacktrace.c~SAVE_STACK_WO_FP	2010-06-03 18:43:27.000000000 +0200
+++ 34-rc1/arch/x86/kernel/stacktrace.c	2010-06-03 21:29:52.000000000 +0200
@@ -26,8 +26,10 @@ static int save_stack_stack(void *data, 
 static void save_stack_address(void *data, unsigned long addr, int reliable)
 {
 	struct stack_trace *trace = data;
+#ifdef CONFIG_FRAME_POINTER
 	if (!reliable)
 		return;
+#endif
 	if (trace->skip > 0) {
 		trace->skip--;
 		return;
@@ -39,9 +41,11 @@ static void save_stack_address(void *dat
 static void
 save_stack_address_nosched(void *data, unsigned long addr, int reliable)
 {
-	struct stack_trace *trace = (struct stack_trace *)data;
+	struct stack_trace *trace = data;
+#ifdef CONFIG_FRAME_POINTER
 	if (!reliable)
 		return;
+#endif
 	if (in_sched_functions(addr))
 		return;
 	if (trace->skip > 0) {

