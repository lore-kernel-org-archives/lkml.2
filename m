Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758906Ab0JZJqO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 05:46:14 -0400
Received: from casper.infradead.org ([85.118.1.10]:54670 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758816Ab0JZJqM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 05:46:12 -0400
Subject: Re: [PATCH 5/6] Export ns irqtimes through /proc/stat -v1
From: Peter Zijlstra <peterz@infradead.org>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Shaun Ruffell <sruffell@digium.com>,
        Yong Zhang <yong.zhang0@gmail.com>
In-Reply-To: <1288045817-3135-6-git-send-email-venki@google.com>
References: <1288045817-3135-1-git-send-email-venki@google.com>
	 <1288045817-3135-6-git-send-email-venki@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 26 Oct 2010 11:45:50 +0200
Message-ID: <1288086350.15336.123.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-25 at 15:30 -0700, Venkatesh Pallipadi wrote:
> +static void irqtime_account_process_tick(struct task_struct *p, int user_tick,
> +                                               struct rq *rq)
> +{
> +       cputime_t one_jiffy_scaled = cputime_to_scaled(cputime_one_jiffy);
> +       cputime64_t tmp = cputime_to_cputime64(cputime_one_jiffy);
> +       struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
> +
> +       if (irqtime_account_hi_update()) {
> +               cpustat->irq = cputime64_add(cpustat->irq, tmp);
> +       } else if (irqtime_account_si_update()) {
> +               cpustat->softirq = cputime64_add(cpustat->softirq, tmp);
> +       } else 

I'm still not sure about this else stmt, the above two conditions can
basically 'eat' user/system ticks. What we need to show is that there is
no bias towards either kind so the ratio is not affected -- can we make
such an argument?

>                if (user_tick) {
> +               account_user_time(p, cputime_one_jiffy, one_jiffy_scaled);
> +       } else if (p == rq->idle) {
> +               account_idle_time(cputime_one_jiffy);
> +       } else if (p->flags & PF_VCPU) { /* System time or guest time */
> +               account_guest_time(p, cputime_one_jiffy, one_jiffy_scaled);
> +       } else {
> +               __account_system_time(p, cputime_one_jiffy, one_jiffy_scaled,
> +                                       &cpustat->system);
> +       }
> +} 
