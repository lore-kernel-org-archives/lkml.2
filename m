Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761623Ab0J2SpB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 14:45:01 -0400
Received: from mail.windriver.com ([147.11.1.11]:58553 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761588Ab0J2Sok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 14:44:40 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
        Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 4/7] kdb: Fix early debugging crash regression
Date: Fri, 29 Oct 2010 13:43:38 -0500
Message-Id: <1288377821-24520-5-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1288377821-24520-1-git-send-email-jason.wessel@windriver.com>
References: <1288377821-24520-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 29 Oct 2010 18:43:51.0050 (UTC) FILETIME=[3ACE6EA0:01CB7799]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kdb_current legally be equal to NULL in the early boot of the x86
arch.  The problem pcan be observed by booting with the kernel arguments:

    earlyprintk=vga ekgdboc=kbd kgdbwait

The kdb shell will oops on entry and recursively fault because it
cannot get past the final stage of shell initialization.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 kernel/debug/kdb/kdb_main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
index 9755ac0..37755d6 100644
--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -1127,7 +1127,7 @@ static int kdb_local(kdb_reason_t reason, int error, struct pt_regs *regs,
 		/* special case below */
 	} else {
 		kdb_printf("\nEntering kdb (current=0x%p, pid %d) ",
-			   kdb_current, kdb_current->pid);
+			   kdb_current, kdb_current ? kdb_current->pid : 0);
 #if defined(CONFIG_SMP)
 		kdb_printf("on processor %d ", raw_smp_processor_id());
 #endif
-- 
1.6.3.3

