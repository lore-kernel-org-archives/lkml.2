Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415Ab3AHWdO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 17:33:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7613 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754097Ab3AHWdM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 17:33:12 -0500
Date: Tue, 8 Jan 2013 17:32:29 -0500
From: Rik van Riel <riel@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: aquini@redhat.com, walken@google.com, eric.dumazet@gmail.com,
        lwoodman@redhat.com, jeremy@goop.org,
        Jan Beulich <JBeulich@novell.com>, knoel@redhat.com,
        chegu_vinod@hp.com, raghavendra.kt@linux.vnet.ibm.com,
        mingo@redhat.com
Subject: [DEBUG PATCH 5/5] x86,smp: add debugging code to track spinlock
 delay value
Message-ID: <20130108173229.784f74bc@annuminas.surriel.com>
In-Reply-To: <20130108172632.1126898a@annuminas.surriel.com>
References: <20130108172632.1126898a@annuminas.surriel.com>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>

This code prints out the maximum spinlock delay value and the
backtrace that pushed it that far.

On systems with serial consoles, the act of printing can cause
the spinlock delay value to explode. It can be useful as a
debugging tool, but is too verbose to merge upstream in this form.

Not-signed-off-by: Rik van Riel <riel@redhat.com>
Not-signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
---
 arch/x86/kernel/smp.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index 1877890..d80aee7 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -147,6 +147,8 @@ static DEFINE_PER_CPU(struct delay_entry [1 << DELAY_HASH_SHIFT], spinlock_delay
 	},
 };
 
+static DEFINE_PER_CPU(u32, maxdelay);
+
 void ticket_spin_lock_wait(arch_spinlock_t *lock, struct __raw_tickets inc)
 {
 	__ticket_t head = inc.head, ticket = inc.tail;
@@ -192,6 +194,12 @@ void ticket_spin_lock_wait(arch_spinlock_t *lock, struct __raw_tickets inc)
 	}
 	ent->hash = hash;
 	ent->delay = delay;
+
+	if (__this_cpu_read(maxdelay) * 4 < delay * 3) {
+		pr_err("cpu %d lock %p delay %d\n", smp_processor_id(), lock, delay>>DELAY_SHIFT);
+		__this_cpu_write(maxdelay, delay);
+		WARN_ON(1);
+	}
 }
 
 /*
