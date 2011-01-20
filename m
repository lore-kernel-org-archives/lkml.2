Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365Ab1ATKGd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 05:06:33 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:65390 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755334Ab1ATKG3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 05:06:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=NOwnBPaChoodV7kEYVFlWZzk2nWysYbK+RzR7n62tOXxKGMzeyWGrEzR3/Xza4bv3K
         vpTd+k7Ju7I8fwPGwYggmAQrBAXheyrYZ3VyUfN2Fz6xuD6Dh1iyLCSDthBMyOLxLuAP
         9yF5CirnurpP4YfsFkK91HluDXZ9txZMdLEdc=
MIME-Version: 1.0
In-Reply-To: <1294367707-2593-6-git-send-email-ddaney@caviumnetworks.com>
References: <1294367707-2593-1-git-send-email-ddaney@caviumnetworks.com>
	<1294367707-2593-6-git-send-email-ddaney@caviumnetworks.com>
Date: Thu, 20 Jan 2011 18:06:28 +0800
Message-ID: <AANLkTi=8NndFv6czWy1q_iDvJRHhCYYu06fhyBL9ByE=@mail.gmail.com>
Subject: Re: [PATCH 5/6] MIPS: perf: Add support for 64-bit perf counters.
From: Deng-Cheng Zhu <dengcheng.zhu@gmail.com>
To: David Daney <ddaney@caviumnetworks.com>
Cc: linux-mips@linux-mips.org, ralf@linux-mips.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/1/7 David Daney <ddaney@caviumnetworks.com>:
> @@ -294,14 +519,29 @@ static void mipspmu_read(struct perf_event *event)
>
>  static void mipspmu_enable(struct pmu *pmu)
>  {
> -       if (mipspmu)
> -               mipspmu->start();
> +#ifdef CONFIG_MIPS_MT_SMP
> +       write_unlock(&pmuint_rwlock);
> +#endif
> +       resume_local_counters();
>  }

When working with CONFIG_MIPS_MT_SMP, the compiler says 'pmuint_rwlock
undeclared' because of its improper place of definition.


> @@ -1550,10 +1462,30 @@ init_hw_perf_events(void)
>                return -ENODEV;
>        }
>
> -       if (mipspmu)
> -               pr_cont("%s PMU enabled, %d counters available to each "
> -                       "CPU, irq %d%s\n", mipspmu->name, counters, irq,
> -                       irq < 0 ? " (share with timer interrupt)" : "");
> +       mipspmu.num_counters = counters;
> +       mipspmu.irq = irq;
> +
> +       if (read_c0_perfctrl0() & M_PERFCTL_WIDE) {
> +               mipspmu.max_period = (1ULL << 63) - 1;
> +               mipspmu.valid_count = (1ULL << 63) - 1;
> +               mipspmu.overflow = 1ULL << 63;
> +               mipspmu.read_counter = mipsxx_pmu_read_counter_64;
> +               mipspmu.write_counter = mipsxx_pmu_write_counter_64;
> +               counter_bits = 64;
> +       } else {
> +               mipspmu.max_period = (1ULL << 32) - 1;
> +               mipspmu.valid_count = (1ULL << 31) - 1;
> +               mipspmu.overflow = 1ULL << 31;
> +               mipspmu.read_counter = mipsxx_pmu_read_counter;
> +               mipspmu.write_counter = mipsxx_pmu_write_counter;
> +               counter_bits = 32;
> +       }
> +
> +       on_each_cpu(reset_counters, (void *)(long)counters, 1);
> +
> +       pr_cont("%s PMU enabled, %d %d-bit counters available to each "
> +               "CPU, irq %d%s\n", mipspmu.name, counters, counter_bits, irq,
> +               irq < 0 ? " (share with timer interrupt)" : "");
>
>        perf_pmu_register(&pmu);
>

perf_pmu_register(&pmu) should be now changed to perf_pmu_register(&pmu,
"cpu", PERF_TYPE_RAW).


Deng-Cheng
