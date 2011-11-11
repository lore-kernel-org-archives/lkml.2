Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752242Ab1KKKL5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 05:11:57 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:6830 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751956Ab1KKKLz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 05:11:55 -0500
Message-ID: <4EBCF4E7.4090002@parallels.com>
Date: Fri, 11 Nov 2011 14:11:51 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Glauber Costa <glommer@parallels.com>, Nathan Lynch <ntl@pobox.com>,
        Tejun Heo <tj@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Serge Hallyn <serue@us.ibm.com>, Daniel Lezcano <dlezcano@fr.ibm.com>
Subject: Re: [PATCH 3/3] pids: Make it possible to clone tasks with given
 pids
References: <4EBC0696.9030103@parallels.com> <4EBC06DB.3090202@parallels.com> <20111110184654.GA1006@redhat.com> <20111110185603.GA1757@redhat.com>
In-Reply-To: <20111110185603.GA1757@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> The child_tidptr points to an array of pids for current namespace and
>>> its ancestors. When 0 is met in this array the pid number for the
>>> corresponding namespace is generated, rather than set.
>>
>> I must have missed something, but I can't unserstand how this works.
>>
>>> For security reasons after a regular clone/fork is done in a namespace
>>> further cloning with predefined pid is not allowed.
>>
>> I guess, this is pid_ns->last_pid != 0 check in set_pidmap(), right ?

Thanks for the feedback, Oleg! Please, see my explanation below.

>>> +static int set_pidmap(struct pid_namespace *pid_ns, int pid)
>>> +{
>>> +	int offset;
>>> +	struct pidmap *map;
>>> +
>>> +	offset = pid & BITS_PER_PAGE_MASK;
>>> +	map = &pid_ns->pidmap[pid/BITS_PER_PAGE];
>>> +
>>> +	if (unlikely(!map->page))
>>> +		if (alloc_pidmap_page(map))
>>> +			return -ENOMEM;
>>> +
>>> +	if (pid_ns->last_pid != 0)
>>> +		return -EPERM;
>>
>> OK, but it should be always true, no? IOW, set_pidmap() should always
>> fail?
>>
>> Unless: you are using CLONE_NEWPID along with CLONE_CHILD_USEPIDS and
>> this child_tidptr array has only one pid (before zero pid).
> 
> And, if you do clone(CLONE_NEWPID | CLONE_CHILD_USEPIDS), then
> new_ns->child_reaper == NULL (unless you pass "1" in child_tidptr[]) ?
> 
>> So, could you please explain what I have missed?
> 
> please ;) I guess I misread this patch completely. Help!

This is how I plan to use this functionality.

When creating an init of a container being restored I call

   pids[0] = 1;
   pids[1] = 0;

   clone(CLONE_NEWPID | CLONE_CHILD_USEPIDS, &pids)

At this point the newly created namespace will have last_pid == 0 and will allow
for this init to be created. Then this created "init" task will have to read pids
from image files and call

pids[0] = <pid>
pids[1] = 0

clone(CLONE_CHILD_USEPIDS, &pids);

one by one. At this point the last_pid is still 0 and this new tasks with given
pids will be created. The newly created tasks if they have children too will have
to call the same code snippet.

After the restore is completed and new tasks are fork()-ed the last_pid gets finally
updated and new CLONE_CHILD_USEPIDS will return the EPERM in this namespace not
allowing for pids confusion.

And for the init_pid_ns the last_pid is set to non zero early at boot (when the kthreadd
is created) and thus pids abuse isn't allowed for the non-containerized system from
the very boot.

Does this sound OK?

> Oleg.
