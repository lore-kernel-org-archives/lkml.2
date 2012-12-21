Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688Ab2LUXwZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 18:52:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58827 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752356Ab2LUXwL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 18:52:11 -0500
Date: Fri, 21 Dec 2012 18:51:15 -0500
From: Rik van Riel <riel@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: aquini@redhat.com, walken@google.com, lwoodman@redhat.com, jeremy@goop.org,
        Jan Beulich <JBeulich@novell.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [RFC PATCH 2/3] x86,smp: proportional backoff for ticket spinlocks
Message-ID: <20121221185115.1858ffc5@annuminas.surriel.com>
In-Reply-To: <20121221184940.103c31ad@annuminas.surriel.com>
References: <20121221184940.103c31ad@annuminas.surriel.com>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: x86,smp: proportional backoff for ticket spinlocks

Simple fixed value proportional backoff for ticket spinlocks.
By pounding on the cacheline with the spin lock less often,
bus traffic is reduced. In cases of a data structure with
embedded spinlock, the lock holder has a better chance of
making progress.

Signed-off-by: Rik van Riel <riel@redhat.com>
---
 arch/x86/kernel/smp.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index 20da354..4e44840 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -118,9 +118,11 @@ static bool smp_no_nmi_ipi = false;
 void ticket_spin_lock_wait(arch_spinlock_t *lock, struct __raw_tickets inc)
 {
 	for (;;) {
-		cpu_relax();
-		inc.head = ACCESS_ONCE(lock->tickets.head);
+		int loops = 50 * (__ticket_t)(inc.tail - inc.head);
+		while (loops--)
+			cpu_relax();
 
+		inc.head = ACCESS_ONCE(lock->tickets.head);
 		if (inc.head == inc.tail)
 			break;
 	}

