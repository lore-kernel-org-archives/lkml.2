Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757972Ab1KKP62 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 10:58:28 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:15278 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751584Ab1KKP61 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 10:58:27 -0500
Message-ID: <4EBD461E.1000106@parallels.com>
Date: Fri, 11 Nov 2011 19:58:22 +0400
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
References: <4EBC0696.9030103@parallels.com> <4EBC06DB.3090202@parallels.com> <20111110184654.GA1006@redhat.com> <20111110185603.GA1757@redhat.com> <4EBCF4E7.4090002@parallels.com> <20111111152532.GA22640@redhat.com>
In-Reply-To: <20111111152532.GA22640@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2011 07:25 PM, Oleg Nesterov wrote:
> On 11/11, Pavel Emelyanov wrote:
>>
>>>> Unless: you are using CLONE_NEWPID along with CLONE_CHILD_USEPIDS and
>>>> this child_tidptr array has only one pid (before zero pid).
>>>
>>> And, if you do clone(CLONE_NEWPID | CLONE_CHILD_USEPIDS), then
>>> new_ns->child_reaper == NULL (unless you pass "1" in child_tidptr[]) ?
>>>
>>>> So, could you please explain what I have missed?
>>>
>>> please ;) I guess I misread this patch completely. Help!
>>
>> This is how I plan to use this functionality.
>>
>> When creating an init of a container being restored I call
>>
>>    pids[0] = 1;
>>    pids[1] = 0;
>>
>>    clone(CLONE_NEWPID | CLONE_CHILD_USEPIDS, &pids)
> 
> Yep, this is clear. In this case everything works because the pid_ns
> has no pids (and thus ->last_pid == 0).
> 
> But. Let me repeat the question, what if you do the same with
> pids[0] = 2 /* anything != 1 */ ? In this case we create the new
> pid_ns, but its ->child_reaper is NULL. Unless I missed something.

Hm... You're right here. I've missed the fact, then in recent kernels
child_reaper is set under pid == 1 condition (was clone_flags & CLONE_NEWPID).

How about if I fix it by disabling the simultaneous use of CLONE_NEWPID and
CLONE_CHILD_USEPIDS and checking for last_pid != 1 in the set_pidmap?

>> Then this created "init" task will have to read pids
>> from image files and call
>>
>> pids[0] = <pid>
>> pids[1] = 0
>>
>> clone(CLONE_CHILD_USEPIDS, &pids);
>>
>> one by one. At this point the last_pid is still 0
> 
> Yes, understood. set_pidmap() bypasses the last_pid logic.
> 
> Clever hack^Wtrick ;)

:)

> May be this deserves a comment above "if (pid_ns->last_pid != 0)",
> and perhaps it would be more clean to do this check before anything
> else.

OK, will fix this.

> Hmm. It seems, we can make a simpler patch to achieve the (roughly)
> same effect. Without touching copy_process/alloc_pid paths. What if
> we simply add PR_SET_LAST_PID? (or something else).
> 
> In this case the new init (created normally) read the pids from image
> file and does prcrl(PR_SET_LAST_PID, pid-1) before the next fork.
> 
> What do you think?

This will make it impossible to fork() children on restore in parallel. And
I don't want to lose this ability :(

> Oleg.
