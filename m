Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760339Ab2D0PBp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 11:01:45 -0400
Received: from mx2.parallels.com ([64.131.90.16]:49622 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759967Ab2D0PBn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 11:01:43 -0400
Message-ID: <4F9AB459.5010308@parallels.com>
Date: Fri, 27 Apr 2012 11:59:37 -0300
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Jason Baron <jbaron@redhat.com>
CC: Steven Rostedt <rostedt@goodmis.org>, <cgroups@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>, Tejun Heo <tj@kernel.org>,
        <kamezawa.hiroyu@jp.fujitsu.com>, <linux-mm@kvack.org>,
        <devel@openvz.org>, Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH v4 1/3] make jump_labels wait while updates are in place
References: <1335480667-8301-1-git-send-email-glommer@parallels.com> <1335480667-8301-2-git-send-email-glommer@parallels.com> <20120427004305.GC23877@home.goodmis.org> <20120427135320.GA13762@redhat.com>
In-Reply-To: <20120427135320.GA13762@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [201.82.19.44]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27/2012 10:53 AM, Jason Baron wrote:
> On Thu, Apr 26, 2012 at 08:43:06PM -0400, Steven Rostedt wrote:
>> On Thu, Apr 26, 2012 at 07:51:05PM -0300, Glauber Costa wrote:
>>> In mem cgroup, we need to guarantee that two concurrent updates
>>> of the jump_label interface wait for each other. IOW, we can't have
>>> other updates returning while the first one is still patching the
>>> kernel around, otherwise we'll race.
>>
>> But it shouldn't. The code as is should prevent that.
>>
>>>
>>> I believe this is something that can fit well in the static branch
>>> API, without noticeable disadvantages:
>>>
>>> * in the common case, it will be a quite simple lock/unlock operation
>>> * Every context that calls static_branch_slow* already expects to be
>>>    in sleeping context because it will mutex_lock the unlikely case.
>>> * static_key_slow_inc is not expected to be called in any fast path,
>>>    otherwise it would be expected to have quite a different name. Therefore
>>>    the mutex + atomic combination instead of just an atomic should not kill
>>>    us.
>>>
>>> Signed-off-by: Glauber Costa<glommer@parallels.com>
>>> CC: Tejun Heo<tj@kernel.org>
>>> CC: Li Zefan<lizefan@huawei.com>
>>> CC: Kamezawa Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com>
>>> CC: Johannes Weiner<hannes@cmpxchg.org>
>>> CC: Michal Hocko<mhocko@suse.cz>
>>> CC: Ingo Molnar<mingo@elte.hu>
>>> CC: Jason Baron<jbaron@redhat.com>
>>> ---
>>>   kernel/jump_label.c |   21 +++++++++++----------
>>>   1 files changed, 11 insertions(+), 10 deletions(-)
>>>
>>> diff --git a/kernel/jump_label.c b/kernel/jump_label.c
>>> index 4304919..5d09cb4 100644
>>> --- a/kernel/jump_label.c
>>> +++ b/kernel/jump_label.c
>>> @@ -57,17 +57,16 @@ static void jump_label_update(struct static_key *key, int enable);
>>>
>>>   void static_key_slow_inc(struct static_key *key)
>>>   {
>>> +	jump_label_lock();
>>>   	if (atomic_inc_not_zero(&key->enabled))
>>> -		return;
>>
>> If key->enabled is not zero, there's nothing to be done. As the jump
>> label has already been enabled. Note, the key->enabled doesn't get set
>> until after the jump label is updated. Thus, if two tasks were to come
>> in, they both would be locked on the jump_label_lock().
>>
>

Okay, we seem to have been tricked by the usage of atomic while 
analyzing this. The fact that the atomic update happens after the code 
is patched seems enough to guarantee what we need, now that I read it 
again (and it seems so obvious =p )
