Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757997Ab2IDXmU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 19:42:20 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:46209 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753070Ab2IDXmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 19:42:18 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6825"; a="232863155"
Message-ID: <504691D9.4060603@codeaurora.org>
Date: Tue, 04 Sep 2012 16:42:17 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:15.0) Gecko/20120824 Thunderbird/15.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Shawn Guo <shawn.guo@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] kernel/sys.c: call disable_nonboot_cpus in kernel_restart
References: <1346682298-13958-1-git-send-email-shawn.guo@linaro.org> <20120904153624.d4aaed4e.akpm@linux-foundation.org>
In-Reply-To: <20120904153624.d4aaed4e.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/12 15:36, Andrew Morton wrote:
> On Mon,  3 Sep 2012 22:24:58 +0800
> Shawn Guo <shawn.guo@linaro.org> wrote:
>
>> Like kernel_power_off calls disable_nonboot_cpus, we may want to have
>> kernel_restart call disable_nonboot_cpus as well.  Doing so can help
>> the machines that require boot cpu be the last alive cpu during reboot
>> to survive with kernel restart.
> That does sound logical.  But the changelog is very vague and fluffy. 
> Does this patch actually fix any known problem on any known machine?
>

Not to hijack this thread but I have a similar problem that would be
partially solved by patch. Basically reboot races with cpu_up and causes
a BUG_ON to hit in stop machine. So this patch would fix my problem
except for in the case where restart is called from panic (i.e.
emergency restart).

https://lkml.org/lkml/2012/8/22/3

Here's the commit text:

Nothing stops a process from hotplugging in a CPU concurrently
with a sys_reboot() call. In such a situation we could have
ipi_cpu_stop() mark a cpu as 'offline' and _cpu_up() ignore the
fact that the CPU is not really offline and call the
CPU_UP_PREPARE notifier. When this happens stop_machine code will
complain that the cpu thread already exists and BUG_ON().

CPU0                      CPU1

sys_reboot()
 kernel_restart()
  machine_restart()
   machine_shutdown()
    smp_send_stop()
    ...                   ipi_cpu_stop()
                           set_cpu_online(1, false)
                            local_irq_disable()
                             while(1)
    <PREEMPT>
cpu_up()
 _cpu_up()
   if (!cpu_online(1))
    __cpu_notify(CPU_UP_PREPARE...)
cpu_stop_cpu_callback()
  BUG_ON(stopper->thread)

This is easily reproducible by hotplugging in and out in a tight
loop while also rebooting.

Since the CPU is not really offline and hasn't gone through the
proper steps to be marked as such, let's mark the CPU as inactive.
This is just as easily testable as online and avoids any possibility
of _cpu_up() trying to bring the CPU back online when it never was
offline to begin with.


-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

