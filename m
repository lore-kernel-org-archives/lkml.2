Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314Ab0KDKNz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 06:13:55 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45042 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754379Ab0KDKNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 06:13:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=uz07Xm/DO3DcFXwxM95XMYyhKqnytbGa6nIoeS7ju8zokiiZjsVUDu5ZSLgsKXo7p3
         1JYCR5spr/L9/08/tLX9HrwNXAJ+IjA3pts22yCklYJVDPdv9eHrvgY4wJnHPEt2ZWiV
         DNY/nuHVxJ2eU10/S98uHtDsnQqmFL5cBHTEI=
Subject: [PATCH] irq: better struct irqaction layout
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Nov 2010 11:13:48 +0100
Message-ID: <1288865628.2659.69.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We currently use kmalloc-96 slab for struct irqaction allocations on
64bit arches.

This is unfortunate because of possible false sharing and two cache
lines accesses.

Move 'name' and 'dir' fields at the end of the structure, and force a
suitable alignement.

Hot path fields now use one cache line on x86_64.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 include/linux/interrupt.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 79d0c4f..55e0d42 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -114,15 +114,15 @@ typedef irqreturn_t (*irq_handler_t)(int, void *);
 struct irqaction {
 	irq_handler_t handler;
 	unsigned long flags;
-	const char *name;
 	void *dev_id;
 	struct irqaction *next;
 	int irq;
-	struct proc_dir_entry *dir;
 	irq_handler_t thread_fn;
 	struct task_struct *thread;
 	unsigned long thread_flags;
-};
+	const char *name;
+	struct proc_dir_entry *dir;
+} ____cacheline_internodealigned_in_smp;
 
 extern irqreturn_t no_action(int cpl, void *dev_id);
 


