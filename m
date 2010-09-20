Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756972Ab0ITRQ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 13:16:57 -0400
Received: from smtp-out.google.com ([74.125.121.35]:36874 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753567Ab0ITRQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 13:16:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=FopiLZQGF3IYGRurwjBDHovi81FQ/uxJT6BqS6KY7LqKfVpvh4cZAYX3RA+9bc1H9u
         cKts3YX7RSUtOejERGGQ==
MIME-Version: 1.0
In-Reply-To: <1284974850.2275.682.camel@laptop>
References: <1284688596-6731-1-git-send-email-venki@google.com>
	<1284688596-6731-3-git-send-email-venki@google.com>
	<1284895291.2275.617.camel@laptop>
	<1284897666.2275.638.camel@laptop>
	<20100920092734.3f46af9f@mschwide.boeblingen.de.ibm.com>
	<1284974850.2275.682.camel@laptop>
Date: Mon, 20 Sep 2010 10:16:50 -0700
Message-ID: <AANLkTi=RvqLTG84sziDTHWn6p93rKB12ePsYW6TfMdSz@mail.gmail.com>
Subject: Re: [PATCH 2/6] Add IRQ_TIME_ACCOUNTING, finer accounting of CPU irq time
From: Venkatesh Pallipadi <venki@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        Paul Turner <pjt@google.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 20, 2010 at 2:27 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2010-09-20 at 09:27 +0200, Martin Schwidefsky wrote:
>
>> > OK, so by virtue of calling the same function on _enter and _exit its
>> > not incomplete, just weird.
>>
>> That is the same with CONFIG_VIRT_CPU_ACCOUNTING=y. irq_enter/irq_exit
>> call account_system_vtime, the function then uses the preempt/softirq/
>> hardirq counter to find out which context is currently active.
>
> Yeah, I realized that eventually, I've so far been able to mostly ignore
> all that VIRT_CPU_ACCOUNTING muck.
>
>> > And it won't account time double, since it uses irq_start_time to
>> > compute deltas between invocations and will attribute that delta to only
>> > one state.
>>
>> irq_start_time is a bit misleading, it is a time stamp of the last update.
>> The confusing part (which deserves a comment) is the fact that the delta
>> is not added to anything if hardirq_count and softirq_count are zero.
>
> Yeah, the name didn't help either, but I really expected to see two
> hooks: start/exit, I did eventually figure it all out, but its a bit
> daft.
>
> If you would have had 4 hooks, the below problem would have been fixable
> within the implementation.
>
>> > You still do have the problem with local_bh_disable() though, since you
>> > cannot distinguish between having bh disabled and processing softirq.
>> >
>> > So a hardirq that hits while you have bh disabled will inflate your
>> > softirq time.
>> >
>> > A possible solution is to have local_bh_{disable,enable} {add,sub}
>> > 2*SOFTIRQ_OFFSET and have the processing use SOFTIRQ_OFFSET, will need a
>> > bit of a code shuffle though.
>>
>> Hmm, that bug is valid for CONFIG_VIRT_CPU_ACCOUNTING=y as well.
>
> And nobody ever noticed?
>

Yes. I inherited the API from VIRT_CPU_ACCOUNTING along with this
local_bh_disable bug. Agree that we need one extra bit to handle this
case. I will take a stab at fixing this along with refresh of this
patchset if no one else has beaten me to it until then.

Thanks,
Venki
