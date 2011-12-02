Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885Ab1LBXtq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 18:49:46 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:36602 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884Ab1LBXtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 18:49:39 -0500
X-Authority-Analysis: v=2.0 cv=dOUkaZlb c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=GF5m4V3ccQkA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=ueNQj3qIAkRO5doWYREA:9 a=MZEq2DXj14rIVkerGIQA:7 a=QEXdDO2ut3YA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: [RT] sysrq Z: sleeping function called from invalid context
From: Steven Rostedt <rostedt@goodmis.org>
To: frank.rowand@am.sony.com
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
In-Reply-To: <4ED95A5F.7030309@am.sony.com>
References: <4ED95A5F.7030309@am.sony.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 02 Dec 2011 18:49:35 -0500
Message-ID: <1322869775.30977.61.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-12-02 at 15:08 -0800, Frank Rowand wrote:
> Hi Steve,
> 
> I get a "sleeping function called from invalid context" when I invoke sysrq Z.
> 
> I get this both with CONFIG_MAGIC_SYSRQ_FORCE_PRINTK enabled and disabled.

Patient:  Hey doctor, it hurts when I do this

Doctor:  Don't do that.


> 
> 3.0.12-rt29
> ARM Pandaboard
> 
> I have not tried this on 3.2-rc4-rt5.
> 
> [  900.963226] SysRq : Dump ftrace buffer
> [  900.967163] Dumping ftrace buffer:
> [  900.970733] BUG: sleeping function called from invalid context at kernel/rtmutex.c:645
> [  900.985137] in_atomic(): 0, irqs_disabled(): 128, pid: 563, name: irq/106-OMAP UA
> [  900.992980] 2 locks held by irq/106-OMAP UA/563:
> [  900.997833]  #0:  (&port_lock_key){+.+...}, at: [<c02d8b14>] serial_omap_irq+0x4c/0x7dc
> [  901.006286]  #1:  (sysrq_key_table_lock){+.+...}, at: [<c02c13a0>] __handle_sysrq+0x20/0x18c
> [  901.015167] irq event stamp: 45345
> [  901.018737] hardirqs last  enabled at (45344): [<c0482f68>] _raw_spin_unlock_irq+0x24/0x4c
> [  901.027435] hardirqs last disabled at (45345): [<c00fb854>] ftrace_dump+0x14/0x23c
> [  901.035400] softirqs last  enabled at (0): [<c009dca8>] copy_process+0x364/0xf84
> [  901.043182] softirqs last disabled at (0): [<  (null)>]   (null)
> [  901.049499] [<c00681b8>] (unwind_backtrace+0x0/0xf0) from [<c04824d0>] (rt_spin_lock+0x24/0x5c)
> [  901.058654] [<c04824d0>] (rt_spin_lock+0x24/0x5c) from [<c00f3b34>] (read_buffer_lock+0x4c/0x6c)
> [  901.067871] [<c00f3b34>] (read_buffer_lock+0x4c/0x6c) from [<c00f5908>] (ring_buffer_empty_cpu+0x50/0x7c)

Grumble. I really don't want to make the read_buffer_lock a real spin
lock. I'll have to see what else is called when its held. I you could
try to make it into a raw_spin_lock() if you want and see if it causes
any more issues.

I guess the other question is, what disabled interrupts?

Oh, it's in the lockdep splat above :-p

It's the ftrace_dump code that disables interrupts.

Oh! looking into the ring_buffer code, could you add this:
(totally untested)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 2467714..2ffbb9d 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1045,7 +1045,7 @@ static inline int ok_to_lock(void)
 	if (in_nmi())
 		return 0;
 #ifdef CONFIG_PREEMPT_RT_FULL
-	if (in_atomic())
+	if (in_atomic() || irqs_disabled())
 		return 0;
 #endif
 	return 1;


> [  901.077911] [<c00f5908>] (ring_buffer_empty_cpu+0x50/0x7c) from [<c00fa3cc>] (trace_empty+0x58/0xd8)
> [  901.087524] [<c00fa3cc>] (trace_empty+0x58/0xd8) from [<c00fb9f8>] (ftrace_dump+0x1b8/0x23c)
> [  901.096374] [<c00fb9f8>] (ftrace_dump+0x1b8/0x23c) from [<c02c1428>] (__handle_sysrq+0xa8/0x18c)
> [  901.105621] [<c02c1428>] (__handle_sysrq+0xa8/0x18c) from [<c02d90cc>] (serial_omap_irq+0x604/0x7dc)
> [  901.115203] [<c02d90cc>] (serial_omap_irq+0x604/0x7dc) from [<c00eb934>] (irq_forced_thread_fn+0x20/0x40)
> [  901.125244] [<c00eb934>] (irq_forced_thread_fn+0x20/0x40) from [<c00eb7dc>] (irq_thread+0x144/0x1e4)
> [  901.134887] [<c00eb7dc>] (irq_thread+0x144/0x1e4) from [<c00c094c>] (kthread+0x7c/0x84)
> [  901.143310] [<c00c094c>] (kthread+0x7c/0x84) from [<c0061e30>] (kernel_thread_exit+0x0/0x8)
> [  901.152496]    (ftrace buffer empty)
> 
> -Frank


