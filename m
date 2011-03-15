Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757975Ab1COOgU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 10:36:20 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35678 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757917Ab1COOgT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 10:36:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=WJRWEV+OxfFid4NaMoVb+7Q8sK6oFvFyIFHpS8esR+nxmoOQbt3si8ByLNK9ri8CYg
         8/i97e1o7aHZcgZyLinRqlFg4+6UYXWlm/ijIvIBxtPYLuvf8EyaI8zVmW5F0k2s0Rhh
         yj+lzzkJM9/0QD2BY/mZ9fxYO1LOCpZREEvtk=
MIME-Version: 1.0
In-Reply-To: <1300130283-10466-2-git-send-email-fweisbec@gmail.com>
References: <1300130283-10466-1-git-send-email-fweisbec@gmail.com>
	<1300130283-10466-2-git-send-email-fweisbec@gmail.com>
Date: Tue, 15 Mar 2011 22:36:18 +0800
Message-ID: <AANLkTim4gFdxn3pHZuxXe-AwTCYrnUHHeFkEK6wisYiL@mail.gmail.com>
Subject: Re: [RFC PATCH 1/4] perf: Starter and stopper events
From: Lin Ming <minggr@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 15, 2011 at 3:18 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:

>
> +static void perf_event_pause_resume(struct perf_event *event, int nmi,
> +                                   struct perf_sample_data *data,
> +                                   struct pt_regs *regs)
> +{
> +       struct perf_event *iter;
> +       unsigned long flags;
> +
> +       /*
> +        * Ensure the targets can't be sched in/out concurrently.
> +        * Disabling irqs is sufficient for that because starters/stoppers
> +        * are on the same cpu/task.
> +        */
> +       local_irq_save(flags);

Could you explain this more detail?

> +
> +
> +       /* Prevent the targets from being removed under us. */
> +       rcu_read_lock();
> +
> +       list_for_each_entry_rcu(iter, &event->starter_list, starter_entry) {
> +               /*
> +                * There is a small race window here, between the state
> +                * gets set to active and the event is actually ->add().
> +                * We need to find a way to ensure the starter/stopper
> +                * can't trigger in between.

Can we set the state to active after the event is actually ->add()?

> +                */
> +               if (iter->state == PERF_EVENT_STATE_ACTIVE) {
> +                       if (iter->paused) {
> +                               iter->pmu->start(iter, PERF_EF_RELOAD);
> +                               iter->paused = 0;
> +                       }
> +               }
> +       }
> +

Thanks,
Lin Ming
