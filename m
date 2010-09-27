Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756374Ab0I0VLa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 17:11:30 -0400
Received: from smtp-out.google.com ([216.239.44.51]:52952 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930Ab0I0VL3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 17:11:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tRMun5lmYGs9ns7b0Ht5J6yFF0ox1DZNR1hRLwpDtz7anZeY1cZPwQZwKcx9PrYI/u
         GhEKbUN1boRlOLsgIQ8Q==
MIME-Version: 1.0
In-Reply-To: <1285620805.2512.128.camel@edumazet-laptop>
References: <1285003599.2275.756.camel@laptop>
	<1285619753-10892-1-git-send-email-venki@google.com>
	<1285620805.2512.128.camel@edumazet-laptop>
Date: Mon, 27 Sep 2010 14:11:25 -0700
Message-ID: <AANLkTim2=ZN=DMFCYcvVx31mOPd40q+EoTVfx-bqMCob@mail.gmail.com>
Subject: Re: [PATCH] si time accounting accounts bh_disable'd time to si
From: Venkatesh Pallipadi <venki@google.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        Paul Turner <pjt@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 27, 2010 at 1:53 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Le lundi 27 septembre 2010 à 13:35 -0700, Venkatesh Pallipadi a écrit :
>> >> >> > You still do have the problem with local_bh_disable() though, since you
>> >> >> > cannot distinguish between having bh disabled and processing softirq.
>> >> >> >
>> >> >> > So a hardirq that hits while you have bh disabled will inflate your
>> >> >> > softirq time.
>>
>> >> >> Hmm, that bug is valid for CONFIG_VIRT_CPU_ACCOUNTING=y as well.
>> >> >
>> >> > And nobody ever noticed?
>> >> >
>> >> Yes. I inherited the API from VIRT_CPU_ACCOUNTING along with this
>> >> local_bh_disable bug. Agree that we need one extra bit to handle this
>> >> case. I will take a stab at fixing this along with refresh of this
>> >> patchset if no one else has beaten me to it until then.
>> >
>> >Make sure to only fix the softirq processing on the hardirq tail, not
>> > the ksoftirqd one :-)
>>
>> softirq processing from hardirq tail and ksoftirqd are currently
>> handled in the same way and I didn't see any issues changing both of
>> them. Am I missing something?
>>
>> Here's the patch I have for this.
>>
>> [PATCH] si time accounting accounts bh_disable'd time to si
>>
>> Peter Zijlstra found a bug in the way softirq time is accounted in
>> VIRT_CPU_ACCOUNTING on this thread.
>> http://lkml.indiana.edu/hypermail//linux/kernel/1009.2/01366.html
>>
>> The problem is, softirq processing uses local_bh_disable internally and there
>> would be no way later in the flow to differentiate between whether softirq is
>> being processed or is it just that bh has been disabled. So, a hardirq when bh
>> id disabled results in time being wrongly accounted for softirq.
>>
>> Looking at the code a bit more, the problem exists in !VIRT_CPU_ACCOUNTING
>> as well. As account_system_time() in normal tick based accouting also uses
>> softirq_count, which will be set when not in softirq with bh disabled.
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
>> ---
>>  include/linux/hardirq.h |    3 ++
>>  include/linux/sched.h   |    2 +-
>>  kernel/sched.c          |    2 +-
>>  kernel/softirq.c        |   51 +++++++++++++++++++++++++++++++---------------
>>  net/sched/cls_cgroup.c  |    2 +-
>>  5 files changed, 40 insertions(+), 20 deletions(-)
>>
>> diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h
>> index d5b3876..1c736ae 100644
>> --- a/include/linux/hardirq.h
>> +++ b/include/linux/hardirq.h
>> @@ -82,10 +82,13 @@
>>  /*
>>   * Are we doing bottom half or hardware interrupt processing?
>>   * Are we in a softirq context? Interrupt context?
>> + * in_softirq answers - are we currently processing softirq or have bh disabled?
>> + * in_serving_softirq answers - are we currently processing softirq?
>>   */
>>  #define in_irq()             (hardirq_count())
>>  #define in_softirq()         (softirq_count())
>>  #define in_interrupt()               (irq_count())
>> +#define in_serving_softirq() (softirq_count() == SOFTIRQ_OFFSET)
>>
>
> But softirq handlers sometime call functions that might disable bh
> again. It would be good to not switch softirq time to system time ;)

Yes. Good point :-). I should rather have
+#define in_serving_softirq() (softirq_count() & SOFTIRQ_OFFSET)

>
> Shouldnt we reserve a bit (high order bit out of 8) instead ?
>
>  * PREEMPT_MASK:    0x000000ff
>  * SOFTIRQ_MASK:    0x0000ff00
>  * SERVING_SOFTIRQ: 0x00008000
>  * HARDIRQ_MASK:    0x03ff0000
>  *     NMI_MASK:    0x04000000

Things will be very much similar using higher order bit or lower order
bit. Somehow I felt using lower order bit was cleaner...

Thanks,
Venki
