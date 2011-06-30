Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435Ab1F3Vzr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 17:55:47 -0400
Received: from casper.infradead.org ([85.118.1.10]:52228 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252Ab1F3Vze convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 17:55:34 -0400
Subject: Re: [PATCH v3 7/9] KVM-GST: KVM Steal time accounting
From: Peter Zijlstra <peterz@infradead.org>
To: Glauber Costa <glommer@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Avi Kivity <avi@redhat.com>, Anthony Liguori <aliguori@us.ibm.com>,
        Eric B Munson <emunson@mgebm.net>
In-Reply-To: <1309361388-30163-8-git-send-email-glommer@redhat.com>
References: <1309361388-30163-1-git-send-email-glommer@redhat.com>
	 <1309361388-30163-8-git-send-email-glommer@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 30 Jun 2011 23:54:32 +0200
Message-ID: <1309470872.12449.609.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-06-29 at 11:29 -0400, Glauber Costa wrote:
> +static noinline bool touch_steal_time(int is_idle)

That noinline is very unlucky there,

> +{
> +       u64 steal, st = 0;
> +
> +       if (static_branch(&paravirt_steal_enabled)) {
> +
> +               steal = paravirt_steal_clock(smp_processor_id());
> +
> +               steal -= this_rq()->prev_steal_time;
> +
> +               st = steal_ticks(steal);
> +               this_rq()->prev_steal_time += st * TICK_NSEC;
> +
> +               if (is_idle || st == 0)
> +                       return false;
> +
> +               account_steal_time(st);
> +               return true;
> +       }
> +       return false;
> +}
> +
>  static void update_rq_clock_task(struct rq *rq, s64 delta)
>  {
>         s64 irq_delta;
> @@ -3716,6 +3760,9 @@ void account_user_time(struct task_struct *p,
> cputime_t cputime,
>         struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
>         cputime64_t tmp;
>  
> +       if (touch_steal_time(0))
> +               return; 

Means we have an unconditional call here, even if the static_branch() is
patched out.
