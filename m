Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751619Ab1HZHfK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 03:35:10 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:32122 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750704Ab1HZHfI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 03:35:08 -0400
Message-ID: <4E574CA5.4010701@openvz.org>
Date: Fri, 26 Aug 2011 11:35:01 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.19) Gecko/20110702 Iceape/2.0.14
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Michal Hocko <mhocko@suse.cz>, Oleg Nesterov <oleg@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] oom: skip frozen tasks
References: <20110823073101.6426.77745.stgit@zurg> <alpine.DEB.2.00.1108231313520.21637@chino.kir.corp.google.com> <20110824101927.GB3505@tiehlicka.suse.cz> <alpine.DEB.2.00.1108241226550.31357@chino.kir.corp.google.com> <20110825091920.GA22564@tiehlicka.suse.cz> <20110825151818.GA4003@redhat.com> <20110825164758.GB22564@tiehlicka.suse.cz> <alpine.DEB.2.00.1108251404130.18747@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1108251404130.18747@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Rientjes wrote:
> On Thu, 25 Aug 2011, Michal Hocko wrote:
>
>>>>> That's obviously false since we call oom_killer_disable() in
>>>>> freeze_processes() to disable the oom killer from ever being called in the
>>>>> first place, so this is something you need to resolve with Rafael before
>>>>> you cause more machines to panic.
>>>>
>>>> I didn't mean suspend/resume path (that is protected by oom_killer_disabled)
>>>> so the patch doesn't make any change.
>>>
>>> Confused... freeze_processes() does try_to_freeze_tasks() before
>>> oom_killer_disable() ?
>>
>> Yes you are right, I must have been blind.
>>
>> Now I see the point. We do not want to panic while we are suspending and
>> the memory is really low just because all the userspace is already in
>> the the fridge.
>> Sorry for confusion.
>>
>> I still do not follow the oom_killer_disable note from David, though.
>>
>
> oom_killer_disable() was added to that path for a reason when all threads
> are frozen: memory allocations still occur in the suspend path in an oom
> condition and adding the oom_killer_disable() will cause those
> allocations to fail rather than sending pointless SIGKILLs to frozen
> threads.
>
> Now consider if the only _eligible_ threads for oom kill (because of
> cpusets or mempolicies) are those that are frozen.  We certainly do not
> want to panic because other cpusets are still getting work done.  We'd
> either want to add a mem to the cpuset or thaw the processes because the
> cpuset is oom.
>
> You can't just selectively skip certain threads when their state can be
> temporary without risking a panic.  That's why this patch is a
> non-starter.
>
> A much better solution would be to lower the badness score that the oom
> killer uses for PF_FROZEN threads so that they aren't considered a
> priority for kill unless there's nothing else left to kill.

Anyway, oom killer shouldn't loop endlessly if it see TIF_MEMDIE on frozen task,
it must go on and try to kill somebody else. We cannot wait for thawing this task.
