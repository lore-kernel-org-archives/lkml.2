Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754321Ab1C1PHk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 11:07:40 -0400
Received: from DMZ-MAILSEC-SCANNER-7.MIT.EDU ([18.7.68.36]:64521 "EHLO
	dmz-mailsec-scanner-7.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753347Ab1C1PHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 11:07:38 -0400
X-AuditID: 12074424-b7cacae000003d70-7e-4d90a418a311
From: Andy Lutomirski <luto@MIT.EDU>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH 5/6] x86-64: Omit frame pointers on vread_tsc
Date: Mon, 28 Mar 2011 11:06:45 -0400
Message-Id: <d9d16ed0f0ac93ab3a9cdb6aac92538d6327d66c.1301324270.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <cover.1301324270.git.luto@mit.edu>
References: <cover.1301324270.git.luto@mit.edu>
In-Reply-To: <cover.1301324270.git.luto@mit.edu>
References: <cover.1301324270.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAIsWRmVeSWpSXmKPExsUixG6noiuxZIKvwf9tUhZ9V46yW7Sunc9u
	cXnXHDaLzZumMlv82PCY1YHVY+esu+wem1Z1snm8O3eO3ePctT5mj8+b5AJYo7hsUlJzMstS
	i/TtErgyzs+byViwk71i33ezBsZ2ti5GTg4JAROJztaljBC2mMSFe+uB4lwcQgL7GCVWH7zM
	DpIQEtjAKDHnSAhE4hmTRNeUCUwgCTYBFYmOpQ+AbA4OEQEhiaV360BqmAUmMUq8nNEL1iws
	YCvR1HiaFcRmEVCV6JvTwQJi8woESZz78gTIZgfaLCfRHAgS5RQwkOg8fZUFZKKQgL7Ex3P2
	OIQnMAosYGRYxSibklulm5uYmVOcmqxbnJyYl5dapGuul5tZopeaUrqJERyQLio7GJsPKR1i
	FOBgVOLh/RPe7yvEmlhWXJl7iFGSg0lJlPfZogm+QnxJ+SmVGYnFGfFFpTmpxYcYJTiYlUR4
	DzUC5XhTEiurUovyYVLSHCxK4rzzJNV9hQTSE0tSs1NTC1KLYLIyHBxKErxJi4EaBYtS01Mr
	0jJzShDSTBycIMN5gIaD1fAWFyTmFmemQ+RPMSpKifMuBkkIgCQySvPgemEJ4xWjONArwryT
	QKp4gMkGrvsV0GAmoMGBSmCDSxIRUlINjLN/fDf6pttQ0ykvzxmzTfjCh8s5/gvcpnDdSewv
	iFqSGXXuymb9rj+Scyz0LgR76XvtK2ENr3xzkddcmHuGfJq5keGv071cT1UUOyyE9A6IXV0g
	8iz3k8qEKdeiFgaFftCTnh3fWmD3eHHE+sbmp5fb5KfOmCyRt2cqS39wSOfzReE397ZdVmIp
	zkg01GIuKk4EAHlv5hfzAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vread_tsc is short and hot, and it's userspace code so the usual
reasons to keep frame pointers around don't apply.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
---

It might be nicer to move vread_tsc into a separate file and change
the options directly.

 arch/x86/kernel/tsc.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index a159fba..1aea4a6 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -764,6 +764,8 @@ static cycle_t read_tsc(struct clocksource *cs)
 }
 
 #ifdef CONFIG_X86_64
+#pragma GCC push_options
+#pragma GCC optimize ("omit-frame-pointer")
 static cycle_t __vsyscall_fn vread_tsc(void)
 {
 	cycle_t ret;
@@ -807,6 +809,7 @@ static cycle_t __vsyscall_fn vread_tsc(void)
 	asm volatile ("");
 	return last;
 }
+#pragma GCC pop_options
 #endif
 
 static void resume_tsc(struct clocksource *cs)
-- 
1.7.4

