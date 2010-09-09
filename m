Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756204Ab0IITyw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 15:54:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:54462 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755615Ab0IITyu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 15:54:50 -0400
Date: Thu, 9 Sep 2010 19:54:22 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        sanagi.koki@jp.fujitsu.com, fweisbec@gmail.com, tglx@linutronix.de,
        laijs@cn.fujitsu.com, mingo@elte.hu
Reply-To: sanagi.koki@jp.fujitsu.com, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com, tglx@linutronix.de,
        laijs@cn.fujitsu.com, mingo@elte.hu
In-Reply-To: <20100908122557.GA5310@nowhere>
References: <20100908122557.GA5310@nowhere>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] irq: Fix circular headers dependency
Message-ID: <tip-3b8fad3e2f5f69bfd8e42d099ca8582fb2342edf@git.kernel.org>
Git-Commit-ID: 3b8fad3e2f5f69bfd8e42d099ca8582fb2342edf
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 09 Sep 2010 19:54:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3b8fad3e2f5f69bfd8e42d099ca8582fb2342edf
Gitweb:     http://git.kernel.org/tip/3b8fad3e2f5f69bfd8e42d099ca8582fb2342edf
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Wed, 8 Sep 2010 14:26:00 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 9 Sep 2010 21:28:58 +0200

irq: Fix circular headers dependency

asm-generic/hardirq.h needs asm/irq.h which might include
linux/interrupt.h as in the sparc 32 case. At this point
we need irq_cpustat generic definitions, but those are
included later in asm-generic/hardirq.h.

Then delay a bit the inclusion of irq.h from
asm-generic/hardirq.h, it doesn't need to be included early.

This fixes:

 include/linux/interrupt.h: In function '__raise_softirq_irqoff':
 include/linux/interrupt.h:414: error: implicit declaration of function 'local_softirq_pending'
 include/linux/interrupt.h:414: error: lvalue required as left operand of assignment

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Koki Sanagi <sanagi.koki@jp.fujitsu.com>
Cc: mathieu.desnoyers@efficios.com
Cc: rostedt@goodmis.org
Cc: nhorman@tuxdriver.com
Cc: scott.a.mcmillan@intel.com
Cc: eric.dumazet@gmail.com
Cc: kaneshige.kenji@jp.fujitsu.com
Cc: davem@davemloft.net
Cc: izumi.taku@jp.fujitsu.com
Cc: kosaki.motohiro@jp.fujitsu.com
LKML-Reference: <20100908122557.GA5310@nowhere>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/asm-generic/hardirq.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/asm-generic/hardirq.h b/include/asm-generic/hardirq.h
index 62f5908..04d0a97 100644
--- a/include/asm-generic/hardirq.h
+++ b/include/asm-generic/hardirq.h
@@ -3,13 +3,13 @@
 
 #include <linux/cache.h>
 #include <linux/threads.h>
-#include <linux/irq.h>
 
 typedef struct {
 	unsigned int __softirq_pending;
 } ____cacheline_aligned irq_cpustat_t;
 
 #include <linux/irq_cpustat.h>	/* Standard mappings for irq_cpustat_t above */
+#include <linux/irq.h>
 
 #ifndef ack_bad_irq
 static inline void ack_bad_irq(unsigned int irq)
