Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755692Ab1BBXcw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 18:32:52 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:51845 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755678Ab1BBXct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 18:32:49 -0500
X-SpamScore: -15
X-BigFish: VPS-15(zzbb2dK1432N98dNzz1202hzz8275bh8275dhz2fh2a8h637h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
Message-ID: <4D49E985.7070806@am.sony.com>
Date: Wed, 2 Feb 2011 15:32:21 -0800
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: <frank.rowand@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        David Miller <davem@davemloft.net>, Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH] softirq: Avoid stack switch from ksoftirqd
References: <alpine.LFD.2.00.1102021704530.31804@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1102021704530.31804@localhost6.localdomain6>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/02/11 08:10, Thomas Gleixner wrote:
> ksoftirqd() calls do_softirq() which switches stacks on several
> architectures. That makes no sense at all. ksoftirqd's stack is
> sufficient.
> 
> Call __do_softirq() directly.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Reviewed-by: Frank Rowand <frank.rowand@am.sony.com>

> ---
>  kernel/softirq.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6-tip/kernel/softirq.c
> ===================================================================
> --- linux-2.6-tip.orig/kernel/softirq.c
> +++ linux-2.6-tip/kernel/softirq.c
> @@ -738,7 +738,10 @@ static int run_ksoftirqd(void * __bind_c
>  			   don't process */
>  			if (cpu_is_offline((long)__bind_cpu))
>  				goto wait_to_die;
> -			do_softirq();
> +			local_irq_disable();
> +			if (local_softirq_pending())
> +				__do_softirq();
> +			local_irq_enable();
>  			preempt_enable_no_resched();
>  			cond_resched();
>  			preempt_disable();
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


