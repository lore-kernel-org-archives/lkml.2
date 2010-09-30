Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756691Ab0I3Q0y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 12:26:54 -0400
Received: from smtp-out.google.com ([216.239.44.51]:59069 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753234Ab0I3Q0x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 12:26:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=EiPOLD3AiKFb4oQo7EwlRuo3KWuMAzbgOlker2IxnC3YHcAbdVZLQJw/r8mH5G3k/V
         vDzwZCuQsNAmSJnpmEtQ==
MIME-Version: 1.0
In-Reply-To: <1285844662.2144.9.camel@laptop>
References: <1285788096-29471-1-git-send-email-venki@google.com>
	<1285788096-29471-2-git-send-email-venki@google.com>
	<1285844662.2144.9.camel@laptop>
Date: Thu, 30 Sep 2010 09:26:49 -0700
Message-ID: <AANLkTinEN8i=Tx-CrdVzv-FGJH5jXaxwsPm-GDf-M_hi@mail.gmail.com>
Subject: Re: [PATCH 1/7] si time accounting accounts bh_disable'd time to si -v3
From: Venkatesh Pallipadi <venki@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 30, 2010 at 4:04 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2010-09-29 at 12:21 -0700, Venkatesh Pallipadi wrote:
>> Peter Zijlstra found a bug in the way softirq time is accounted in
>> VIRT_CPU_ACCOUNTING on this thread.
>> http://lkml.indiana.edu/hypermail//linux/kernel/1009.2/01366.html
>>
>> The problem is, softirq processing uses local_bh_disable internally. There
>> is no way, later in the flow, to differentiate between whether softirq is
>> being processed or is it just that bh has been disabled. So, a hardirq when bh
>> is disabled results in time being wrongly accounted as softirq.
>>
>> Looking at the code a bit more, the problem exists in !VIRT_CPU_ACCOUNTING
>> as well. As account_system_time() in normal tick based accouting also uses
>> softirq_count, which will be set even when not in softirq with bh disabled.
>>
>> Peter also suggested solution of using 2 * SOFTIRQ_OFFSET as irq count
>> for local_bh_{disable,enable} and using just SOFTIRQ_OFFSET while softirq
>> processing. The patch below does that and adds API in_serving_softirq() which
>> returns whether we are currently processing softirq or not.
>>
>> Also changes one of the usages of softirq_count in net/sched/cls_cgroup.c
>> to in_serving_softirq.
>>
>> Looks like many usages of in_softirq really want in_serving_softirq. Those
>> changes can be made individually on a case by case basis.
>>
>> Signed-off-by: Venkatesh Pallipadi <venki@google.com>
>
> One nit: in_serving_softirq() doesn't seem right as either:
>
>  - we're not accounting ksoftirq in it, or
>  - we're are and VIRT_CPU_ACCOUNTING is again broken ;-)
>
> So only the softirq from irq tails wants to have SOFTIRQ_OFFSET set, the
> ksoftirqd stuff can be tested for using PF_flags or something (ksoftirq
> doesn't currently have a PF_SOFTIRQ flag, but -rt does and we could
> bring that over).
>

The problem is that ksoftirqd is also handling softirq's and some
eventual users of in_serving_softirq (like the network code in this
patch) want to differentiate between whether it is the softirq thats
running or some real process (!ksoftirqd) context.

Also, ksoftirqd adds to softirq counts, does trace softirq, etc. So,
it kind of made sense to add the time also to softirq stats as well.
If we dont account time to softirq stats, then if some user is looking
at say time per softirq using the softirq count will be misled. No?

In the other thread you mentioned doing that will cause problems. Were
you thinking of scheduler issues or are there other problems charging
softirq time this way?

Thanks,
Venki
