Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756296Ab0FHUOT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 16:14:19 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:53323 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756114Ab0FHUOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 16:14:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=xrex0qfKM1VaVBPxTiFLKwavZNbxYWHgaXKNSjRpnoQqaKqhSlItgs4OFOELgVhsTX
         lHEC1SLk0PY/MS288/Z3uZxpqxNOsx7U60EU6kAD1kYHL+0UxtbAUTSFVBZ/4A9yfA6y
         iKCetpT4qeCVZM2GGacjD4olhrbxppk43Qt10=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       Roland McGrath <roland@redhat.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Vegard Nossum <vegard.nossum@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 2/2] x86: Unify save_stack_address() and save_stack_address_nosched()
Date: Tue,  8 Jun 2010 22:13:43 +0200
Message-Id: <1276028023-23122-3-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1276028023-23122-1-git-send-regression-fweisbec@gmail.com>
References: <1276028023-23122-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

Cleanup. Factor the common code in save_stack_address() and
save_stack_address_nosched().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
LKML-Reference: <20100603193243.GA31534@redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/x86/kernel/stacktrace.c |   24 ++++++++++--------------
 1 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/stacktrace.c b/arch/x86/kernel/stacktrace.c
index abc321d..b53c525 100644
--- a/arch/x86/kernel/stacktrace.c
+++ b/arch/x86/kernel/stacktrace.c
@@ -23,13 +23,16 @@ static int save_stack_stack(void *data, char *name)
 	return 0;
 }
 
-static void save_stack_address(void *data, unsigned long addr, int reliable)
+static void
+__save_stack_address(void *data, unsigned long addr, bool reliable, bool nosched)
 {
 	struct stack_trace *trace = data;
 #ifdef CONFIG_FRAME_POINTER
 	if (!reliable)
 		return;
 #endif
+	if (nosched && in_sched_functions(addr))
+		return;
 	if (trace->skip > 0) {
 		trace->skip--;
 		return;
@@ -38,22 +41,15 @@ static void save_stack_address(void *data, unsigned long addr, int reliable)
 		trace->entries[trace->nr_entries++] = addr;
 }
 
+static void save_stack_address(void *data, unsigned long addr, int reliable)
+{
+	return __save_stack_address(data, addr, reliable, false);
+}
+
 static void
 save_stack_address_nosched(void *data, unsigned long addr, int reliable)
 {
-	struct stack_trace *trace = data;
-#ifdef CONFIG_FRAME_POINTER
-	if (!reliable)
-		return;
-#endif
-	if (in_sched_functions(addr))
-		return;
-	if (trace->skip > 0) {
-		trace->skip--;
-		return;
-	}
-	if (trace->nr_entries < trace->max_entries)
-		trace->entries[trace->nr_entries++] = addr;
+	return __save_stack_address(data, addr, reliable, true);
 }
 
 static const struct stacktrace_ops save_stack_ops = {
-- 
1.6.2.3

