Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752980Ab1FTKsI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 06:48:08 -0400
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:59898 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752666Ab1FTKsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 06:48:05 -0400
Message-ID: <4DFF255E.5030308@ti.com>
Date: Mon, 20 Jun 2011 16:17:58 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH] ARM: smp: Fix the CPU hotplug race with scheduler.
References: <1308561839-18407-1-git-send-email-santosh.shilimkar@ti.com> <20110620095053.GA2082@n2100.arm.linux.org.uk> <20110620101438.GD2082@n2100.arm.linux.org.uk> <4DFF20B3.7010209@ti.com> <20110620104415.GF2082@n2100.arm.linux.org.uk>
In-Reply-To: <20110620104415.GF2082@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/20/2011 4:14 PM, Russell King - ARM Linux wrote:
> On Mon, Jun 20, 2011 at 03:58:03PM +0530, Santosh Shilimkar wrote:
>> No it doesn't work. I still get the crash. The important point
>> here is not to enable interrupts before CPU is marked
>> as online and active.
>
> What is the crash (in full please)?
>
> Do we know what interrupt is causing it?
Yes. It's because of interrupt and the CPU active-online
race.

Here is the chash log..
[   21.025451] CPU1: Booted secondary processor
[   21.025451] CPU1: Unknown IPI message 0x1
[   21.029113] Switched to NOHz mode on CPU #1
[   21.029174] BUG: spinlock lockup on CPU#1, swapper/0, c06220c4
[   21.029235] [<c0064704>] (unwind_backtrace+0x0/0xf4) from 
[<c028edc8>] (do_raw_spin_lock+0xd0/0x164)
[   21.029266] [<c028edc8>] (do_raw_spin_lock+0xd0/0x164) from 
[<c00cc3c4>] (tick_do_update_jiffies64+0x3c/0x118)
[   21.029296] [<c00cc3c4>] (tick_do_update_jiffies64+0x3c/0x118) from 
[<c00ccb04>] (tick_check_idle+0xb0/0x110)
[   21.029327] [<c00ccb04>] (tick_check_idle+0xb0/0x110) from 
[<c00a29cc>] (irq_enter+0x68/0x70)
[   21.029327] [<c00a29cc>] (irq_enter+0x68/0x70) from [<c00623c4>] 
(ipi_timer+0x24/0x40)
[   21.029357] [<c00623c4>] (ipi_timer+0x24/0x40) from [<c0051368>] 
(do_local_timer+0x54/0x70)
[   21.029388] [<c0051368>] (do_local_timer+0x54/0x70) from [<c048a09c>] 
(__irq_svc+0x3c/0x120)
[   21.029388] Exception stack(0xef87bf78 to 0xef87bfc0)
[   21.029388] bf60: 
    00000000 00026ec0
[   21.029418] bf80: c0622080 ffff7483 c0622080 ffff7483 ef87a000 
00000000 c0622080 411fc092
[   21.029418] bfa0: c063a4f0 00000000 00000001 ef87bfc0 c0482e08 
c0482b0c 60000113 ffffffff
[   21.029449] [<c048a09c>] (__irq_svc+0x3c/0x120) from [<c0482b0c>] 
(calibrate_delay+0x8c/0x1d4)
[   21.029479] [<c0482b0c>] (calibrate_delay+0x8c/0x1d4) from 
[<c0482e08>] (secondary_start_kernel+0x110/0x1ac)
[   21.029510] [<c0482e08>] (secondary_start_kernel+0x110/0x1ac) from 
[<c0070ee4>] (platform_cpu_die+0x34/0x54)
[   22.021362] CPU1: failed to come online
[   23.997955] CPU1: failed to come online
[   25.000122] BUG: spinlock lockup on CPU#0, kthreadd/663, efa27e64
[   25.006408] [<c0064704>] (unwind_backtrace+0x0/0xf4) from 
[<c028edc8>] (do_raw_spin_lock+0xd0/0x164)
[   25.015808] [<c028edc8>] (do_raw_spin_lock+0xd0/0x164) from 
[<c048985c>] (_raw_spin_lock_irqsave+0x4c/0x58)
[   25.025848] [<c048985c>] (_raw_spin_lock_irqsave+0x4c/0x58) from 
[<c008ba24>] (complete+0x1c/0x5c)
[   25.035095] [<c008ba24>] (complete+0x1c/0x5c) from [<c00baf78>] 
(kthread+0x68/0x90)
[   25.042968] [<c00baf78>] (kthread+0x68/0x90) from [<c005dfdc>] 
(kernel_thread_exit+0x0/0x8)


