Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762351Ab2KAVhq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 17:37:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47926 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762332Ab2KAVhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 17:37:40 -0400
Date: Thu, 1 Nov 2012 14:37:18 -0700
From: tip-bot for Sankara Muthukrishnan <sankara.m@gmail.com>
Message-ID: <tip-f3de44edf376d18773febca6a37800c042bada7d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rostedt@goodmis.org, sankara.m@gmail.com, sankara.m@ni.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        sankara.m@gmail.com, rostedt@goodmis.org, sankara.m@ni.com,
        tglx@linutronix.de
In-Reply-To: <CAFQPvXeVZ858WFYimEU5uvLNxLDd6bJMmqWihFmbCf3ntokz0A@mail.gmail.com>
References: <CAFQPvXeVZ858WFYimEU5uvLNxLDd6bJMmqWihFmbCf3ntokz0A@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] irq: Set CPU affinity right on thread creation
Git-Commit-ID: f3de44edf376d18773febca6a37800c042bada7d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 01 Nov 2012 14:37:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f3de44edf376d18773febca6a37800c042bada7d
Gitweb:     http://git.kernel.org/tip/f3de44edf376d18773febca6a37800c042bada7d
Author:     Sankara Muthukrishnan <sankara.m@gmail.com>
AuthorDate: Wed, 31 Oct 2012 15:41:23 -0500
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 1 Nov 2012 12:11:31 +0100

irq: Set CPU affinity right on thread creation

As irq_thread_check_affinity is called ONLY inside the while loop in
the irq thread, the core affinity is set only when an interrupt
occurs. This patch sets the core affinity right after the irq thread
is created and before it waits for interrupts. In real-tiime targets
that do not typically change the core affinity of irqs during
run-time, this patch will save additional latency of an irq thread in
setting the core affinity during the first interrupt occurrence for
that irq.

Signed-off-by: Sankara S Muthukrishnan <sankara.m@ni.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/CAFQPvXeVZ858WFYimEU5uvLNxLDd6bJMmqWihFmbCf3ntokz0A@mail.gmail.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/manage.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index d06a396..1cbd572 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -849,6 +849,8 @@ static int irq_thread(void *data)
 	init_task_work(&on_exit_work, irq_thread_dtor);
 	task_work_add(current, &on_exit_work, false);
 
+	irq_thread_check_affinity(desc, action);
+
 	while (!irq_wait_for_interrupt(action)) {
 		irqreturn_t action_ret;
 
