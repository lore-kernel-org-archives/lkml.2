Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062Ab1FTKUH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 06:20:07 -0400
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:35639 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753885Ab1FTKUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 06:20:04 -0400
Message-ID: <4DFF1ECD.8080305@ti.com>
Date: Mon, 20 Jun 2011 15:49:57 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC PATCH] ARM: smp: Fix the CPU hotplug race with scheduler.
References: <1308561839-18407-1-git-send-email-santosh.shilimkar@ti.com> <20110620095053.GA2082@n2100.arm.linux.org.uk>
In-Reply-To: <20110620095053.GA2082@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/20/2011 3:20 PM, Russell King - ARM Linux wrote:
> On Mon, Jun 20, 2011 at 02:53:59PM +0530, Santosh Shilimkar wrote:
>> The current ARM CPU hotplug code suffers from couple of race conditions
>> in CPU online path with scheduler.
>> The ARM CPU hotplug code doesn't wait for hot-plugged CPU to be marked
>> active as part of cpu_notify() by the CPU which brought it up before
>> enabling interrupts.
>
> Hmm, why not just move the set_cpu_online() call before notify_cpu_starting()
> and add the wait after the set_cpu_online() ?
I think that's what patch is doing. Do you mean, calling hotplug
notifier chain immediately after CPU marked as online. Something
like below.

	set_cpu_online(cpu, true);
	notify_cpu_starting(cpu);
         while (!cpumask_test_cpu(smp_processor_id(), cpu_active_mask))
                 cpu_relax();

         /*
          * Enable local interrupts.
          */
                 local_irq_enable();
         local_fiq_enable();


Regards
Santosh

