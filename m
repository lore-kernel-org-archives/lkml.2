Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807Ab1KUREw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 12:04:52 -0500
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:38127 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623Ab1KUREu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 12:04:50 -0500
Message-ID: <4ECA84A8.5030005@linux.vnet.ibm.com>
Date: Mon, 21 Nov 2011 22:34:40 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, pavel@ucw.cz, lenb@kernel.org,
        ak@linux.intel.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3] PM/Memory-hotplug: Avoid task freezing failures
References: <20111117083042.11419.19871.stgit@srivatsabhat.in.ibm.com> <201111192257.19763.rjw@sisk.pl> <4EC8984E.30005@linux.vnet.ibm.com> <201111201124.17528.rjw@sisk.pl> <4EC9D557.9090008@linux.vnet.ibm.com> <20111121164006.GB15314@google.com>
In-Reply-To: <20111121164006.GB15314@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 11112117-4790-0000-0000-00000013EA46
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/2011 10:10 PM, Tejun Heo wrote:
> Hello, Srivatsa.
> 
> On Mon, Nov 21, 2011 at 10:06:39AM +0530, Srivatsa S. Bhat wrote:
>> void lock_system_sleep(void)
>> {
>> 	/* simplified freezer_do_not_count() */
>> 	current->flags |= PF_FREEZER_SKIP;
>>
>> 	mutex_lock(&pm_mutex);
>>
>> }
>>
>> void unlock_system_sleep(void)
>> {
>> 	mutex_unlock(&pm_mutex);
>>
>> 	/* simplified freezer_count() */
>> 	current->flags &= ~PF_FREEZER_SKIP;
>>
>> }
>>
>> We probably don't want the restriction that freezer_do_not_count() and
>> freezer_count() work only for userspace tasks. So I have open coded
>> the relevant parts of those functions here.
>>
>> I haven't tested this solution yet. Let me know if this solution looks
>> good and I'll send it out as a patch after testing and analyzing some
>> corner cases, if any.

I tested this, and it works great! I'll send the patch in some time.

> 
> Ooh ooh, I definitely like this one much better. 

Thanks :-) Even I like it far better than all those ugly hacks I proposed
earlier ;-)

> Oleg did something
> similar w/ wait_event_freezekillable() too.  On related notes,
> 
> * I think it would be better to remove direct access to pm_mutex and
>   use [un]lock_system_sleep() universally.  I don't think hinging it
>   on CONFIG_HIBERNATE_CALLBACKS buys us anything.
> 

Which direct access to pm_mutex are you referring to?
Other than suspend/hibernation call paths, I think mem-hotplug is the only
subsystem trying to access pm_mutex. I haven't checked thoroughly though. 

But yes, using lock_system_sleep() for mutually excluding some code path
from suspend/hibernation is good, and that is one reason why I wanted
to fix this API ASAP. But as long as memory hotplug is the only direct user
of pm_mutex, is it justified to remove the CONFIG_HIBERNATE_CALLBACKS
restriction and make it generic? I don't know...

Or, are you saying that we should use these APIs even in suspend/hibernate
call paths? That's not such a bad idea either...

[ On a totally different note, I was wondering:- if mem-hotplug wants to
exclude itself from hibernation alone, CONFIG_HIBERNATE_CALLBACKS is not
the right way to do it, because, it would still unintentionally exclude
itself from suspend also! (if suspend and hibernation are both enabled).
I don't think we should worry about this too much, because we don't get
much benefit trying to make mem-hotplug co-exist with suspend.. In fact,
I would say, its even better to let it be this way and exclude suspend
as well, since running exotic stuff like memory hotplug during suspend
or hibernation is best avoided ;-) ]

> * In the longer term, we should be able to toggle PF_NOFREEZE instead
>   as SKIP doesn't mean anything different.  We'll probably need a
>   better API tho.  But for now SKIP should work fine.
> 

Yep, I agree.

Thanks,
Srivatsa S. Bhat

