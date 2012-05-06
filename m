Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753719Ab2EFNPd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 09:15:33 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:64371 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753671Ab2EFNPb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 09:15:31 -0400
MIME-Version: 1.0
X-Originating-IP: [212.179.42.66]
In-Reply-To: <20120503153941.GA5528@google.com>
References: <1336056962-10465-1-git-send-email-gilad@benyossef.com>
	<1336056962-10465-4-git-send-email-gilad@benyossef.com>
	<20120503153941.GA5528@google.com>
Date: Sun, 6 May 2012 16:15:30 +0300
Message-ID: <CAOtvUMcJurhAKB5pbq91WCsSM7cELNOdUbANzx4gF0Cf8x4cTg@mail.gmail.com>
Subject: Re: [PATCH v1 3/6] workqueue: introduce schedule_on_each_cpu_cond
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>, Mike Frysinger <vapier@gentoo.org>,
        David Rientjes <rientjes@google.com>, Hugh Dickins <hughd@google.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Christoph Lameter <cl@linux.com>, Chris Metcalf <cmetcalf@tilera.com>,
        Hakan Akkan <hakanakkan@gmail.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 3, 2012 at 6:39 PM, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> On Thu, May 03, 2012 at 05:55:59PM +0300, Gilad Ben-Yossef wrote:
>> Introduce the schedule_on_each_cpu_cond() function that schedules
>> a work item on each online CPU for which the supplied condition
>> function returns true.
>>
>> This function should be used instead of schedule_on_each_cpu()
>> when only some of the CPUs have actual work to do and a predicate
>> function can tell if a certain CPU does or does not have work to do,
>> thus saving unneeded wakeups and schedules.
>>
>>  /**
>> + * schedule_on_each_cpu_cond - execute a function synchronously on each
>> + * online CPU for which the supplied condition function returns true
>> + * @func: the function to run on the selected CPUs
>> + * @cond_func: the function to call to select the CPUs
>> + *
>> + * schedule_on_each_cpu_cond() executes @func on each online CPU for
>> + * @cond_func returns true using the system workqueue and blocks until
>> + * all CPUs have completed.
>> + * schedule_on_each_cpu_cond() is very slow.
>> + *
>> + * RETURNS:
>> + * 0 on success, -errno on failure.
>> + */
>> +int schedule_on_each_cpu_cond(work_func_t func, bool (*cond_func)(int cpu))
>> +{
>> +     int cpu, ret;
>> +     cpumask_var_t mask;
>> +
>> +     if (unlikely(!zalloc_cpumask_var(&mask, GFP_KERNEL)))
>> +             return -ENOMEM;
>> +
>> +     get_online_cpus();
>> +
>> +     for_each_online_cpu(cpu)
>> +             if (cond_func(cpu))
>> +                     cpumask_set_cpu(cpu, mask);
>> +
>> +     ret = schedule_on_each_cpu_mask(func, mask);
>> +
>> +     put_online_cpus();
>> +
>> +     free_cpumask_var(mask);
>> +
>> +     return ret;
>> +}
>
> I'm usually not a big fan of callback based interface.  They tend to
> be quite clunky to use.

My first academic computer science course used SICP as the text book.
I've managed to kick most of the bad habits I've gained in that course
over the years,
but two: a taste for higher order functions and a fetish for
parenthesis.I can't quite tell
which of the two is a bigger barrier to my re-integration with normal
society... ;-)

>  e.g. in this case, wouldn't it be better to
> have helper functions which allocate cpumask and disables cpu hotplug
> and undo that afterwards?  That is, if such convenience helpers are
> necessary at all.

If we'll always have only a single call sign you are certainly right.
My thought was
that I'm not only solving the specific problem here, but trying to
help the next person
doing something similar do the right thing.

A single helper function called schedule_on_each_cpu_cond() is very
obvious to find
to someone reading the source or documentation. On the other hand
figuring out that
the helper functions that handle cpu hotplug and cpumask allocation
are there for that
purpose is a bit more involved.

That was my thinking at least.

> Also, callback which doesn't have a private data
> argument tends to be PITA.
>

You are 100% right. The callback should have a private data parameter.

The way i see it, I can either obliterate on_each_cpu_cond() and out its code
in place in the LRU path, or fix the callback to get an extra private
data parameter -

It's your call - what would you have me do?

Thanks,
Gilad



> Thanks.
>
> --
> tejun



-- 
Gilad Ben-Yossef
Chief Coffee Drinker
gilad@benyossef.com
Israel Cell: +972-52-8260388
US Cell: +1-973-8260388
http://benyossef.com

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
