Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746Ab2FFHvg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 03:51:36 -0400
Received: from mga03.intel.com ([143.182.124.21]:8138 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751733Ab2FFHve (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 03:51:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="152223127"
Message-ID: <4FCF0C03.9010400@linux.intel.com>
Date: Wed, 06 Jun 2012 15:51:31 +0800
From: Chen Gong <gong.chen@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, "Luck, Tony" <tony.luck@intel.com>,
        "bp@amd64.org" <bp@amd64.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [tip:x86/urgent] x86/mce: Fix the MCE poll timer logic
References: <1338863702-9245-1-git-send-email-gong.chen@linux.intel.com> <tip-958fb3c51295764599d6abce87e1a01ace897a3e@git.kernel.org>
In-Reply-To: <tip-958fb3c51295764599d6abce87e1a01ace897a3e@git.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2012/6/6 15:10, tip-bot for Chen Gong 写道:
> Commit-ID:  958fb3c51295764599d6abce87e1a01ace897a3e
> Gitweb:     http://git.kernel.org/tip/958fb3c51295764599d6abce87e1a01ace897a3e
> Author:     Chen Gong <gong.chen@linux.intel.com>
> AuthorDate: Tue, 5 Jun 2012 10:35:02 +0800
> Committer:  Ingo Molnar <mingo@kernel.org>
> CommitDate: Wed, 6 Jun 2012 08:28:21 +0200
>
> x86/mce: Fix the MCE poll timer logic
>
> In commit 82f7af09 ("x86/mce: Cleanup timer mess), Thomas just
> forgot the "/ 2" there while cleaning up.
>
> Signed-off-by: Chen Gong <gong.chen@linux.intel.com>
> Acked-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: bp@amd64.org
> Cc: tony.luck@intel.com
> Link: http://lkml.kernel.org/r/1338863702-9245-1-git-send-email-gong.chen@linux.intel.com
> Signed-off-by: Ingo Molnar <mingo@kernel.org>
> ---
>  arch/x86/kernel/cpu/mcheck/mce.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
> index 0a687fd..a97f3c4 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce.c
> @@ -1274,7 +1274,7 @@ static void mce_timer_fn(unsigned long data)
>  	 */
>  	iv = __this_cpu_read(mce_next_interval);
>  	if (mce_notify_irq())
> -		iv = max(iv, (unsigned long) HZ/100);
> +		iv = max(iv / 2, (unsigned long) HZ/100);
>  	else
>  		iv = min(iv * 2, round_jiffies_relative(check_interval * HZ));
>  	__this_cpu_write(mce_next_interval, iv);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

In fact, there still exists another potential issue:

static void __mcheck_cpu_init_timer(void)
{
        struct timer_list *t = &__get_cpu_var(mce_timer);
        unsigned long iv = __this_cpu_read(mce_next_interval);

        setup_timer(t, mce_timer_fn, smp_processor_id());

        if (mce_ignore_ce)
                return;

        __this_cpu_write(mce_next_interval, iv);
        if (!iv)
                return;
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Because the 2nd patch is not merged yet, so here iv is zero when this
function is called, which means at the beginning, the poll timers are
not registered until some other conditions trigger *add_timer_on*.

        t->expires = round_jiffies(jiffies + iv);
        add_timer_on(t, smp_processor_id());
}

Another potential issue is in this function two smp_processor_id()
are called. If conext changes during this procedure (I'm not sure
if it can hapen, besides secondary_cpu kickoff, online/offline will
call these functions, even in virtualization envrionment, etc.).
So I think it will be better saving the value in the beginning of
this function. Make sense?

