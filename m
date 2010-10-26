Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932482Ab0JZRfM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 13:35:12 -0400
Received: from smtp-out.google.com ([74.125.121.35]:21002 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754528Ab0JZRfK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 13:35:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SEK5EeO0dopP6nn/BvmviHqaoAEs8fkxbJ6gqu2+Oc+dPk6SyfTAOKALI9y0Kz6XXj
         HWdD3C/4P/4Egjm4qjPA==
MIME-Version: 1.0
In-Reply-To: <1288105046.15336.343.camel@twins>
References: <1288045817-3135-1-git-send-email-venki@google.com>
	<1288045817-3135-6-git-send-email-venki@google.com>
	<1288086350.15336.123.camel@twins>
	<1288105046.15336.343.camel@twins>
Date: Tue, 26 Oct 2010 10:35:04 -0700
Message-ID: <AANLkTimFQvszKyXPOSjjQ9ohBd1fSspiGhsqs96Ly2mr@mail.gmail.com>
Subject: Re: [PATCH 5/6] Export ns irqtimes through /proc/stat -v1
From: Venkatesh Pallipadi <venki@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Shaun Ruffell <sruffell@digium.com>,
        Yong Zhang <yong.zhang0@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 26, 2010 at 7:57 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2010-10-26 at 11:45 +0200, Peter Zijlstra wrote:
>> On Mon, 2010-10-25 at 15:30 -0700, Venkatesh Pallipadi wrote:
>> > +static void irqtime_account_process_tick(struct task_struct *p, int user_tick,
>> > +                                               struct rq *rq)
>> > +{
>> > +       cputime_t one_jiffy_scaled = cputime_to_scaled(cputime_one_jiffy);
>> > +       cputime64_t tmp = cputime_to_cputime64(cputime_one_jiffy);
>> > +       struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
>> > +
>> > +       if (irqtime_account_hi_update()) {
>> > +               cpustat->irq = cputime64_add(cpustat->irq, tmp);
>> > +       } else if (irqtime_account_si_update()) {
>> > +               cpustat->softirq = cputime64_add(cpustat->softirq, tmp);
>> > +       } else
>>
>> I'm still not sure about this else stmt, the above two conditions can
>> basically 'eat' user/system ticks. What we need to show is that there is
>> no bias towards either kind so the ratio is not affected -- can we make
>> such an argument?
>
> I think I can made a counter-argument: if either or both of these checks
> are true we had system time in the last tick, hence there is a larger
> chance this tick is a system tick.
>
> Therefore it will not provide the same user/system ratio.
>
> Hmm?
>

This is about task user/system time. Right?
With the earlier changes, hardirq/softirq won't be part of task
sum_exec_runtime anymore. So, if we have had significant hardirq or
softirq during this tick, then the task sum_exec_runtime wouldn't have
changed much. So, accounting this as task system time will tweak task
user/system ratio needlessly. So, eating up system time should be the
right thing to do here :-)

The other case of significant hardirq/softirq during last tick, but
not enough to cause the irq folding and so may get accounted as
system/user and we have a tiny hardirq/softirq in the next tick which
results in folding and so system/user wont be accounted. So, this can
affect user/system ratio if last tick was user and current tick is
system or vice-versa. This I feel, is no different from variation with
tick instance based sampling we have now.

Only other option I can think of, is to forget about this folding
business and micro account hardirq/softirq fraction on every tick and
account the remaining time (one_tick - (hardirq+softirq)) as
user/idle/guest/system. The problem with that is the task times and
kstat are done in cputime64, which in x86 is jiffies and so we dont
have enough resolution for this approach.

Thanks,
Venki

>> >                if (user_tick) {
>> > +               account_user_time(p, cputime_one_jiffy, one_jiffy_scaled);
>> > +       } else if (p == rq->idle) {
>> > +               account_idle_time(cputime_one_jiffy);
>> > +       } else if (p->flags & PF_VCPU) { /* System time or guest time */
>> > +               account_guest_time(p, cputime_one_jiffy, one_jiffy_scaled);
>> > +       } else {
>> > +               __account_system_time(p, cputime_one_jiffy, one_jiffy_scaled,
>> > +                                       &cpustat->system);
>> > +       }
>> > +}
>
>
