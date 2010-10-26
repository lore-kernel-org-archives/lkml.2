Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758889Ab0JZCxj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 22:53:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44140 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757241Ab0JZCxh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 22:53:37 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 05/43] MN10300: Prevent cnt32_to_63() from being preempted
 in sched_clock()
To: linux-am33-list@redhat.com
From: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org
Date: Tue, 26 Oct 2010 03:53:28 +0100
Message-ID: <20101026025328.23512.99934.stgit@warthog.procyon.org.uk>
In-Reply-To: <20101026025301.23512.24525.stgit@warthog.procyon.org.uk>
References: <20101026025301.23512.24525.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.15-97-g9680-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prevent cnt32_to_63() from being preempted in sched_clock() because it may
read its internal counter, get preempted, get delayed for more than the half
period of the 'TSC' and then write the internal counter, thus corrupting it.

Whilst some callers of sched_clock() have interrupts disabled or hold
spinlocks, not all do, and so preemption must be held here.

Note that sched_clock() is called from lockdep, but that shouldn't be a problem
because although preempt_disable() calls into lockdep, lockdep has a recursion
counter to deal with this.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/mn10300/kernel/time.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)


diff --git a/arch/mn10300/kernel/time.c b/arch/mn10300/kernel/time.c
index 8f7f6d2..0b5c856 100644
--- a/arch/mn10300/kernel/time.c
+++ b/arch/mn10300/kernel/time.c
@@ -54,6 +54,9 @@ unsigned long long sched_clock(void)
 	unsigned long tsc, tmp;
 	unsigned product[3]; /* 96-bit intermediate value */
 
+	/* cnt32_to_63() is not safe with preemption */
+	preempt_disable();
+
 	/* read the TSC value
 	 */
 	tsc = 0 - get_cycles(); /* get_cycles() counts down */
@@ -64,6 +67,8 @@ unsigned long long sched_clock(void)
 	 */
 	tsc64.ll = cnt32_to_63(tsc) & 0x7fffffffffffffffULL;
 
+	preempt_enable();
+
 	/* scale the 64-bit TSC value to a nanosecond value via a 96-bit
 	 * intermediate
 	 */

