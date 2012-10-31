Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760337Ab2JaUl0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 16:41:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41122 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754524Ab2JaUlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 16:41:24 -0400
MIME-Version: 1.0
Date: Wed, 31 Oct 2012 15:41:23 -0500
Message-ID: <CAFQPvXeVZ858WFYimEU5uvLNxLDd6bJMmqWihFmbCf3ntokz0A@mail.gmail.com>
Subject: [PATCH 1/1] irq: Set CPU affinity soon after irq thread is created
From: Sankara Muthukrishnan <sankara.m@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sankara S Muthukrishnan <sankara.m@ni.com>

As irq_thread_check_affinity is called ONLY inside the while loop in the
irq thread, the core affinity is set only when an interrupt occurs.
This patch sets the core affinity soon after the irq thread is created
and before it waits for interrupts. In real-tiime targets that do not
typically change the core affinity of irqs during run-time, this patch
will save additional latency of an irq thread in setting the core
affinity during the first interrupt occurrence for that irq.

Signed-off-by: Sankara S Muthukrishnan <sankara.m@ni.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
---
Hi Thomas,

As we discussed in the original thread
http://marc.info/?l=linux-kernel&m=134987001701683&w=2 , I am sending
this patch against the current mainline.

 kernel/irq/manage.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 4c69326..020b535 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -833,6 +833,8 @@ static int irq_thread(void *data)
 	init_task_work(&on_exit_work, irq_thread_dtor);
 	task_work_add(current, &on_exit_work, false);

+	irq_thread_check_affinity(desc, action);
+
 	while (!irq_wait_for_interrupt(action)) {
 		irqreturn_t action_ret;

-- 
1.7.11.4
