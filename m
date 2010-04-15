Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020Ab0DONhy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 09:37:54 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:47611 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238Ab0DONhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 09:37:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=BahN2mVFYPOXZjsNWSq7bbaVsSZD9keIIUtTzAupNuJdKOHUtxxcNaCma8GDo8LsPL
         LR7Bf9+8VuhanMvRld2iXTYikODb37V5RB37WnPx7RE5qrtwcdpO31OTT+BDsRac983D
         mZ4NqKfw1tV7HQ8mbmPtbFCmZhyb5D26tMNDE=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Peter Zijlstra <peterz@infradead.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH] lockdep: Fix redundant_hardirqs_on incremented with irqs enabled
Date: Thu, 15 Apr 2010 15:37:50 +0200
Message-Id: <1271338670-4537-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <20100415200414.1ef705c8.sfr@canb.auug.org.au>
References: <20100415200414.1ef705c8.sfr@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a path restore the flags while irqs are already enabled, we
update the per cpu var redundant_hardirqs_on in a racy fashion
and debug_atomic_inc() warns about this situation.

In this particular case, we need to explictly disable the irqs before
updating this stat var in order to update it safely.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: David Miller <davem@davemloft.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 kernel/lockdep.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 78325f8..65d4336 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -2298,7 +2298,11 @@ void trace_hardirqs_on_caller(unsigned long ip)
 		return;
 
 	if (unlikely(curr->hardirqs_enabled)) {
+		unsigned long flags;
+
+		raw_local_irq_save(flags);
 		debug_atomic_inc(redundant_hardirqs_on);
+		raw_local_irq_restore(flags);
 		return;
 	}
 	/* we'll do an OFF -> ON transition: */
-- 
1.6.2.3

