Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752730Ab2H2HYG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 03:24:06 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:36951 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160Ab2H2HYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 03:24:05 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6818"; a="230605904"
Message-ID: <503DC392.4070904@codeaurora.org>
Date: Wed, 29 Aug 2012 00:24:02 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: linux-arm-kernel@lists.infradead.org
CC: linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH] ARM: smp: Fix cpu_up() racing with sys_reboot
References: <1345608229-5707-1-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1345608229-5707-1-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/21/2012 9:03 PM, Stephen Boyd wrote:
> Nothing stops a process from hotplugging in a CPU concurrently
> with a sys_reboot() call. In such a situation we could have
> ipi_cpu_stop() mark a cpu as 'offline' and _cpu_up() ignore the
> fact that the CPU is not really offline and call the
> CPU_UP_PREPARE notifier. When this happens stop_machine code will
> complain that the cpu thread already exists and BUG_ON().
>
> CPU0                      CPU1
>
> sys_reboot()
>  kernel_restart()
>   machine_restart()
>    machine_shutdown()
>     smp_send_stop()
>     ...                   ipi_cpu_stop()
>                            set_cpu_online(1, false)
>                             local_irq_disable()
>                              while(1)
>     <PREEMPT>
> cpu_up()
>  _cpu_up()
>    if (!cpu_online(1))
>     __cpu_notify(CPU_UP_PREPARE...)
>
> cpu_stop_cpu_callback()
>   BUG_ON(stopper->thread)
>
> This is easily reproducible by hotplugging in and out in a tight
> loop while also rebooting.
>
> Since the CPU is not really offline and hasn't gone through the
> proper steps to be marked as such, let's mark the CPU as inactive.
> This is just as easily testable as online and avoids any possibility
> of _cpu_up() trying to bring the CPU back online when it never was
> offline to begin with.
>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>
> Perhaps we can take the hotplug lock in the sys_reboot() case but I
> don't think that actually fixes everything. For example, in cases
> where machine_shutdown() is called from emergency_restart() we would
> have to take the hotplug lock which doesn't really seem feasible.

Any comments on this patch?

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

