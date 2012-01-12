Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886Ab2ALPIQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 10:08:16 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:33474 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753703Ab2ALPIL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 10:08:11 -0500
MIME-Version: 1.0
X-Originating-IP: [212.179.42.66]
In-Reply-To: <CAOtvUMfmSrotCGn-51SC3eiQU=xK4C_Trh+8FEfTGOJcGUgVag@mail.gmail.com>
References: <1326276668-19932-1-git-send-email-mgorman@suse.de>
	<1326276668-19932-3-git-send-email-mgorman@suse.de>
	<CAOtvUMfmSrotCGn-51SC3eiQU=xK4C_Trh+8FEfTGOJcGUgVag@mail.gmail.com>
Date: Thu, 12 Jan 2012 17:08:10 +0200
Message-ID: <CAOtvUMeL19942umZH22THGU-TQbnjRfxz-JLdY_wdWPN7ZNy5Q@mail.gmail.com>
Subject: Re: [PATCH 2/2] mm: page allocator: Do not drain per-cpu lists via
 IPI from page allocator context
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Miklos Szeredi <mszeredi@novell.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, Greg KH <gregkh@suse.de>,
        Gong Chen <gong.chen@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 12, 2012 at 4:51 PM, Gilad Ben-Yossef <gilad@benyossef.com> wrote:
> On Wed, Jan 11, 2012 at 12:11 PM, Mel Gorman <mgorman@suse.de> wrote:
> <SNIP>
>> Rather than making it safe to call get_online_cpus() from the page
>> allocator, this patch simply removes the page allocator call to
>> drain_all_pages(). To avoid impacting high-order allocation success
>> rates, it still drains the local per-cpu lists for high-order
>> allocations that failed. As a side effect, this reduces the number
>> of IPIs sent during low memory situations.
>>
>> Signed-off-by: Mel Gorman <mgorman@suse.de>
>> ---
>>  mm/page_alloc.c |   16 ++++++++++++----
>>  1 files changed, 12 insertions(+), 4 deletions(-)
>>
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index 2b8ba3a..b6df6fc 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -1119,7 +1119,9 @@ void drain_local_pages(void *arg)
>>  */
>>  void drain_all_pages(void)
>>  {
>> +       get_online_cpus();
>>        on_each_cpu(drain_local_pages, NULL, 1);
>> +       put_online_cpus();
>>  }
>>
>>  #ifdef CONFIG_HIBERNATION
>> @@ -1982,11 +1984,17 @@ retry:
>>                                        migratetype);
>>
>>        /*
>> -        * If an allocation failed after direct reclaim, it could be because
>> -        * pages are pinned on the per-cpu lists. Drain them and try again
>> +        * If a high-order allocation failed after direct reclaim, there is a
>> +        * possibility that it is because the necessary buddies have been
>> +        * freed to the per-cpu list. Drain the local list and try again.
>> +        * drain_all_pages is not used because it is unsafe to call
>> +        * get_online_cpus from this context as it is possible that kthreadd
>> +        * would block during thread creation and the cost of sending storms
>> +        * of IPIs in low memory conditions is quite high.
>>         */
>> -       if (!page && !drained) {
>> -               drain_all_pages();
>> +       if (!page && order && !drained) {
>> +               drain_pages(get_cpu());
>> +               put_cpu();
>>                drained = true;
>>                goto retry;
>>        }
>> --
>> 1.7.3.4
>>
>
> I very much like the judo like quality of relying on the fact that in
> memory pressure conditions most
> of the cpus will end up in the direct reclaim path to drain them all
> without IPIs.
>
> What I can't figure out is why we don't need  get/put_online_cpus()
> pair around each and every call
> to on_each_cpu everywhere? and if we do, perhaps making it a part of
> on_each_cpu is the way to go?
>
> Something like:
>
> diff --git a/kernel/smp.c b/kernel/smp.c
> index f66a1b2..cfa3882 100644
> --- a/kernel/smp.c
> +++ b/kernel/smp.c
> @@ -691,11 +691,15 @@ void on_each_cpu(void (*func) (void *info), void
> *info, int wait)
>  {
>        unsigned long flags;
>
> +       BUG_ON(in_atomic());
> +
> +       get_online_cpus();
>        preempt_disable();
>        smp_call_function(func, info, wait);
>        local_irq_save(flags);
>        func(info);
>        local_irq_restore(flags);
>        preempt_enable();
> +       put_online_cpus();
>  }
>  EXPORT_SYMBOL(on_each_cpu);
>
> Does that makes?

Well, it dies on boot (after adding the needed include file), so it's
obviously wrong, but I'm still guessing
other users of on_each_cpu will need an  get/put_online_cpus() wrapper too.

Maybe -

on_each_cpu(...)
{
  get_online_cpus();
  __on_each_cpu(...);
  put_online_cpus();
}

We'll need to audit all callers.

Gilad

-- 
Gilad Ben-Yossef
Chief Coffee Drinker
gilad@benyossef.com
Israel Cell: +972-52-8260388
US Cell: +1-973-8260388
http://benyossef.com

"Unfortunately, cache misses are an equal opportunity pain provider."
-- Mike Galbraith, LKML
