Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751643Ab2ETF1q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 01:27:46 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63632 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984Ab2ETF1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 01:27:43 -0400
Date: Sun, 20 May 2012 13:27:31 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Christophe Huriaux <c.huriaux@gmail.com>
Cc: Uwe =?utf-8?Q?Kleine-K=EF=BF=BDnig?= 
	<u.kleine-koenig@pengutronix.de>,
        linux-rt-users@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] genirq: don't sync irq thread if current happen to be the
 very irq thread
Message-ID: <20120520052731.GA3864@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <CAEOomG9NEoQKqp=pMx0NpzGaFpHBimALwhemnZL4F-8g7XURkA@mail.gmail.com>
 <20120509174931.GB31844@pengutronix.de>
 <CAEOomG9FZD9TEQZZKhCrNrq8SNXi3otWB2mDX69i3tWh5YQenw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAEOomG9FZD9TEQZZKhCrNrq8SNXi3otWB2mDX69i3tWh5YQenw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2012 at 03:17:17PM +0200, Christophe Huriaux wrote:
> 2012/5/9 Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>:
> > If you enable CONFIG_KALLSYMS you get a more usable backtrace.
> > Alternatively you can use
> >
> > ? ? ? ?$CROSS_COMPILE-addr2line -e vmlinux 0xc000e90c
> >
> > to get the file and line that resulted in the code at that address.
> >
> 
>   Thanks, I was wondering which config option would enable that. The
> complete backtrace is much more usable :

Actually I don't think this is a -rt issue, you could also trigger this
warning with vanilla if you boot your kernel with 'threadirqs'.

Could you pleaes try the follow patch?

Thanks,
Yong

---
From: Yong Zhang <yong.zhang@windriver.com>
Date: Sun, 20 May 2012 12:56:46 +0800
Subject: [PATCH] genirq: don't sync irq thread if current happen to be the very irq thread

Christophe reported against -rt:
BUG: scheduling while atomic: irq/37-s3c-mci/253/0x00000102
Modules linked in:
[<c000e9fc>] (unwind_backtrace+0x0/0x12c) from [<c029b82c>] (__schedule+0x58/0x2c0)
[<c029b82c>] (__schedule+0x58/0x2c0) from [<c029bc10>] (schedule+0x8c/0xb0)
[<c029bc10>] (schedule+0x8c/0xb0) from [<c0055614>] (synchronize_irq+0xbc/0xd8)
[<c0055614>] (synchronize_irq+0xbc/0xd8) from [<c01db6b0>] (pio_tasklet+0x34/0x11c)
[<c01db6b0>] (pio_tasklet+0x34/0x11c) from [<c0024914>] (__tasklet_action+0x68/0x80)
[<c0024914>] (__tasklet_action+0x68/0x80) from [<c0024ca4>] (__do_softirq+0x88/0x130)
[<c0024ca4>] (__do_softirq+0x88/0x130) from [<c0024ef0>] (do_softirq+0x48/0x54)
[<c0024ef0>] (do_softirq+0x48/0x54) from [<c0025048>] (local_bh_enable+0x8c/0xc0)
[<c0025048>] (local_bh_enable+0x8c/0xc0) from [<c0054678>] (irq_forced_thread_fn+0x4c/0x54)
[<c0054678>] (irq_forced_thread_fn+0x4c/0x54) from [<c0054454>] (irq_thread+0xa0/0x1c0)
[<c0054454>] (irq_thread+0xa0/0x1c0) from [<c0038628>] (kthread+0x84/0x8c)
[<c0038628>] (kthread+0x84/0x8c) from [<c000a100>] (kernel_thread_exit+0x0/0x8)

Whe looking at this issue, I find that there is a typical deadlock
scenario with forced treaded irq,

irq_forced_thread_fn()
  local_bh_enable();
    do_softirq();
      disable_irq();
        synchronize_irq();
          wait_event();
          /*DEAD*/

Cure it by unsync if current happen to be the very irq thread.

Reported-by: Christophe Huriaux <c.huriaux@gmail.com>
Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/manage.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 89a3ea8..d5b96e7 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -41,6 +41,7 @@ early_param("threadirqs", setup_forced_irqthreads);
 void synchronize_irq(unsigned int irq)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
+	struct irqaction *action = desc->action;
 	bool inprogress;
 
 	if (!desc)
@@ -67,7 +68,15 @@ void synchronize_irq(unsigned int irq)
 	/*
 	 * We made sure that no hardirq handler is running. Now verify
 	 * that no threaded handlers are active.
+	 * But for theaded irq, we don't sync if current happens to be
+	 * the irq thread; otherwise we could deadlock.
 	 */
+	while (action) {
+		if (action->thread && action->thread == current)
+			return;
+		action = action->next;
+	}
+
 	wait_event(desc->wait_for_threads, !atomic_read(&desc->threads_active));
 }
 EXPORT_SYMBOL(synchronize_irq);
-- 
1.7.1

