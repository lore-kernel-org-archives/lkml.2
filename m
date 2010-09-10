Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752314Ab0IJLQm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 07:16:42 -0400
Received: from smtp-out.google.com ([74.125.121.35]:47932 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277Ab0IJLQl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 07:16:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=mC+Xgba9B+mTBC95NpLM0G4nauIqOFUNM+H0uAeKy9S1TvLvUHNbxrKCIEj/6O4kEl
         9HKIjZ18nM+zxaGF3sZQ==
MIME-Version: 1.0
In-Reply-To: <4c8a121b.0e28e30a.4dc9.718d@mx.google.com>
References: <4c8a121b.0e28e30a.4dc9.718d@mx.google.com>
Date: Fri, 10 Sep 2010 13:16:37 +0200
Message-ID: <AANLkTinghij+US6sbk4epU95HTQUt-SK_0UyM9iMHi7w@mail.gmail.com>
Subject: Re: [PATCH] perf_events: fix BTS interrupt handling to avoid being
 dazed by NMI
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
        fweisbec@gmail.com, perfmon2-devel@lists.sf.net, eranian@gmail.com,
        eranian@google.com, robert.richter@amd.com, dzickus@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, my patch is missing one piece. I will repost.


On Fri, Sep 10, 2010 at 1:09 PM, Stephane Eranian <eranian@google.com> wrote:
> Fix a bug introduced with commit de725de and the change in the meaning of the
> return value of intel_pmu_handle_irq(). With the current code, when you are
> using the BTS, you get 'dazed by NMI' each time the BTS buffer fills up.
>
> BTS does interrupt on the PMU vector, thus NMI. You need to take this
> into account in the return value of the function.
>
> Signed-off-by: Stephane Eranian <eranian@google.com>
> --
>
> diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
> index ee05c90..b4d2e1c 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel.c
> @@ -713,18 +713,18 @@ static int intel_pmu_handle_irq(struct pt_regs *regs)
>        struct cpu_hw_events *cpuc;
>        int bit, loops;
>        u64 status;
> -       int handled = 0;
> +       int handled;
>
>        perf_sample_data_init(&data, 0);
>
>        cpuc = &__get_cpu_var(cpu_hw_events);
>
>        intel_pmu_disable_all();
> -       intel_pmu_drain_bts_buffer();
> +       handled = intel_pmu_drain_bts_buffer();
>        status = intel_pmu_get_status();
>        if (!status) {
>                intel_pmu_enable_all(0);
> -               return 0;
> +               return handled;
>        }
>
>        loops = 0;
>
