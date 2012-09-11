Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757826Ab2IKSJA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 14:09:00 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:8751 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757388Ab2IKSI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 14:08:59 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6832"; a="235399107"
Message-ID: <504F7E3A.8020808@codeaurora.org>
Date: Tue, 11 Sep 2012 11:08:58 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: Fix deadlock scenario with smp_send_stop()
References: <1346878886-7159-1-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1346878886-7159-1-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/12 14:01, Stephen Boyd wrote:
> If one process calls sys_reboot and that process then stops other
> CPUs while those CPUs are within a spin_lock() region we can
> potentially encounter a deadlock scenario like below.
>
> CPU 0                   CPU 1
> -----                   -----
>                         spin_lock(my_lock)
> smp_send_stop()
>  send_IPI               handle_IPI()
>                          disable_preemption/irqs
>                           while(1);
>  <PREEMPT>
> spin_lock(my_lock) <--- Waits forever
>
> We shouldn't attempt to run any other tasks after we send a stop
> IPI to a CPU so disable preemption so that the reboot task runs to
> completion.
>
> Reported-by: Sundarajan Srinivasan <sundaraj@codeaurora.com>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>
> Unfortunately this won't fix the other problem I mentioned two weeks
> ago where smp_send_stop races with other CPUs calling cpu_up().

Any comments?

>
>  arch/arm/kernel/process.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
> index 693b744..663a7a8 100644
> --- a/arch/arm/kernel/process.c
> +++ b/arch/arm/kernel/process.c
> @@ -239,6 +239,7 @@ __setup("reboot=", reboot_setup);
>  
>  void machine_shutdown(void)
>  {
> +	preempt_disable();
>  #ifdef CONFIG_SMP
>  	smp_send_stop();
>  #endif


-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

