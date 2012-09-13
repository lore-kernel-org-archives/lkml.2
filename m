Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926Ab2IMPFv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 11:05:51 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:47583 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492Ab2IMPFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 11:05:49 -0400
Message-ID: <5051F648.8030003@suse.cz>
Date: Thu, 13 Sep 2012 17:05:44 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Slaby <jirislaby@gmail.com>
Subject: input_to_handler: unable to handle kernel NULL pointer dereference
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

-next commit "Input: Send events one packet at a time" seems like broke
the input layer:
BUG: unable to handle kernel NULL pointer dereference at      (null)
IP: [<          (null)>]           (null)
PGD 0
Oops: 0010 [#1] SMP
Modules linked in:
CPU 0
Pid: 0, comm: swapper/0 Not tainted 3.6.0-rc5-next-20120912_64+ #44
Bochs Bochs
RIP: 0010:[<0000000000000000>]  [<          (null)>]           (null)
RSP: 0018:ffff880049603c70  EFLAGS: 00010086
RAX: 0000000000000000 RBX: 0000000000000002 RCX: 0000000000000045
RDX: 0000000000000004 RSI: 0000000000000004 RDI: ffff880047bff918
RBP: ffff880049603cb8 R08: 00000000000000c5 R09: ffff880047400000
R10: 000000000000001d R11: 00000000000000c5 R12: ffffffff81a36c00
R13: ffff8800465c6d50 R14: ffff8800465c6d50 R15: ffff8800465c6d48
FS:  0000000000000000(0000) GS:ffff880049600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001a0b000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper/0 (pid: 0, threadinfo ffffffff81a00000, task
ffffffff81a13420)
Stack:
 ffffffff81473df2 ffffffff8109c4de ffff880047bff918 ffff880049611200
 ffff8800465c6d40 ffff880047bff918 ffff880046a2ae68 0000000000000002
 ffff880046a2b328 ffff880049603d08 ffffffff81475ea9 ffffffff810965c5
Call Trace:
 <IRQ>
 [<ffffffff81473df2>] ? input_to_handler+0xc2/0xe0
 [<ffffffff8109c4de>] ? enqueue_task_fair+0xfe/0x180
 [<ffffffff81475ea9>] input_pass_values.part.14+0x159/0x160
 [<ffffffff810965c5>] ? check_preempt_curr+0x75/0xa0
 [<ffffffff81476f03>] input_handle_event+0x113/0x520
 [<ffffffff81477402>] input_event+0x52/0x70
 [<ffffffff810989ed>] ? default_wake_function+0xd/0x10
 [<ffffffff8147d657>] atkbd_interrupt+0x297/0x6b0
 [<ffffffff81094bb5>] ? __wake_up_common+0x55/0x90
 [<ffffffff81470e6d>] serio_interrupt+0x4d/0xa0
 [<ffffffff814721ba>] i8042_interrupt+0x1ba/0x3a0
 [<ffffffff810d4902>] ? rcu_process_callbacks+0x3c2/0x4e0
 [<ffffffff8109df97>] ? run_rebalance_domains+0x47/0x160
 [<ffffffff810ce243>] handle_irq_event_percpu+0x43/0x160
 [<ffffffff8109a647>] ? sched_clock_tick+0x57/0xa0
 [<ffffffff810ce39c>] handle_irq_event+0x3c/0x60
 [<ffffffff810d0aaf>] handle_edge_irq+0x6f/0x110
 [<ffffffff8103a52d>] handle_irq+0x1d/0x30




If I do this, everything works:
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -112,9 +112,12 @@ static unsigned int input_to_handler(struct
input_handle *handle,
        if (!count)
                return 0;

+       WARN_ONCE(!handler->events && !handler->event, "%s: %s",
+                       handle->name, handler->name);
+
        if (handler->events)
                handler->events(handle, vals, count);
-       else
+       else if (handler->event)
                for (v = vals; v != end; v++)
                        handler->event(handle, v->type, v->code, v->value);


PS sysrq is the driver causing this.

regards,
-- 
js
suse labs
