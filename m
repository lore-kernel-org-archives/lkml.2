Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757067Ab1F1Kzv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 06:55:51 -0400
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:43976
	"EHLO DB3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757181Ab1F1Kxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 06:53:44 -0400
X-SpamScore: -12
X-BigFish: VPS-12(zz4015L1432N98dKzz1202hzz8275bh8275dhz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LNHY9D-01-1X0-02
X-M-MSG: 
Date: Tue, 28 Jun 2011 12:53:35 +0200
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>,
        "francis.moro@gmail.com" <francis.moro@gmail.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@elte.hu" <mingo@elte.hu>
Subject: Re: [tip:perf/core] perf: Ignore non-sampling overflows
Message-ID: <20110628105335.GA17199@erda.amd.com>
References: <new-submission>
 <tip-963988262c3c8f4234f64a0dde59446a295e07bb@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <tip-963988262c3c8f4234f64a0dde59446a295e07bb@git.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26.11.10 10:04:56, tip-bot for Peter Zijlstra wrote:
> Commit-ID:  963988262c3c8f4234f64a0dde59446a295e07bb
> Gitweb:     http://git.kernel.org/tip/963988262c3c8f4234f64a0dde59446a295e07bb
> Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
> AuthorDate: Wed, 24 Nov 2010 18:55:29 +0100
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Fri, 26 Nov 2010 15:14:55 +0100
> 
> perf: Ignore non-sampling overflows
> 
> Some arch implementations call perf_event_overflow() by 'accident',
> ignore this.
> 
> Reported-by: Francis Moreau <francis.moro@gmail.com>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> LKML-Reference: <new-submission>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  kernel/perf_event.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/perf_event.c b/kernel/perf_event.c
> index 98c5549..af1e63f 100644
> --- a/kernel/perf_event.c
> +++ b/kernel/perf_event.c
> @@ -4240,6 +4240,13 @@ static int __perf_event_overflow(struct perf_event *event, int nmi,
>  	struct hw_perf_event *hwc = &event->hw;
>  	int ret = 0;
>  
> +	/*
> +	 * Non-sampling counters might still use the PMI to fold short
> +	 * hardware counters, ignore those.
> +	 */
> +	if (unlikely(!is_sampling_event(event)))
> +		return 0;
> +

Peter,

do you remember the background of this change. This check silently
drops data of non-sampling events. I want to use perf_event_overflow()
to write to the buffer and want to modify the check, but don't see
which 'accidentally' interrupts may occur that must be ignored.

I was thinking of modifying the check to something like:

static inline bool is_sampling_event(struct perf_event *event)
{
        return event->attr.sample_type != 0;
}

or

	if (unlikely(!is_sampling_event(event) && !event->attr.sample_type))
		...

Thanks,

-Robert

>  	if (!throttle) {
>  		hwc->interrupts++;
>  	} else {
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

