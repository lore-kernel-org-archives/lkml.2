Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760085Ab0I0Tak (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 15:30:40 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47658 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755885Ab0I0Taj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 15:30:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version;
        b=mS1Get6YIfXUrc3lrzaPzihULeAily2yxpXmuzLvcdtjraguPqQ8TnESTnYdRYLIcC
         0aeqGQHEePTf5f5JE18y3SWRsrfu8fShm7h7/Ouet0if0ESTEeUD/Iuj71t7nxyTFcnf
         9AhZTEzaoY4gFm72y36HW1AxjtSPbtAgoNYEg=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC PATCH] x86: Barf when faults happen in NMI
Date: Mon, 27 Sep 2010 21:30:33 +0200
Message-Id: <1285615833-5324-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In x86, faults exit by executing the iret instruction, which then
reenables NMIs if we faulted in NMI context. Then if a fault
happens in NMI, another NMI can nest after the fault exits.

But we don't yet support nested NMIs because we have only one NMI
stack. To prevent that, trigger a bug when a fault happens in NMI
context.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
---

I first thought about putting it in the vmalloc fault path only.
But then I saw more occasions for the kernel to fault (kmemcheck
or so), and so I thought it should be better put in the all in one
path. But I suspect you won't like that conditional in the big
x86 fault path.


 arch/x86/mm/fault.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 4c4508e..80c997e 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -955,6 +955,8 @@ do_page_fault(struct pt_regs *regs, unsigned long error_code)
 	int write;
 	int fault;
 
+	BUG_ON(in_nmi());
+
 	tsk = current;
 	mm = tsk->mm;
 
-- 
1.6.2.3

