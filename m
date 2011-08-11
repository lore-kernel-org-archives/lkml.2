Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751758Ab1HKSKY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 14:10:24 -0400
Received: from smtp2-g21.free.fr ([212.27.42.2]:48892 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751069Ab1HKSKX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 14:10:23 -0400
Message-ID: <4E441B0C.4060707@free.fr>
Date: Thu, 11 Aug 2011 20:10:20 +0200
From: Daniel Lezcano <daniel.lezcano@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110516 Thunderbird/3.1.10
MIME-Version: 1.0
To: =?UTF-8?B?QnJ1bm8gUHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
CC: containers@lists.linux-foundation.org, LXC@d06av03.portsmouth.uk.ibm.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Development <Lxc-devel@lists.sourceforge.net>
Subject: Re: [lxc-devel] [RFC] catching sys_reboot syscall
References: <4E4051A0.8030009@free.fr> <20110810221028.2e0c8590@neptune.home> <4E42EEE3.9050608@free.fr> <20110811183027.49275b2d@neptune.home> <4E44082F.6040606@free.fr> <20110811190456.77ff9280@neptune.home>
In-Reply-To: <20110811190456.77ff9280@neptune.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11/2011 07:04 PM, Bruno Prémont wrote:
> On Thu, 11 August 2011 Daniel Lezcano <daniel.lezcano@free.fr> wrote:
>> On 08/11/2011 06:30 PM, Bruno Prémont wrote:
>>> On Wed, 10 August 2011 Daniel Lezcano <daniel.lezcano@free.fr> wrote:
>>>> On 08/10/2011 10:10 PM, Bruno Prémont wrote:
>>>>> Hi Daniel,
>>>>>
>>>>> [I'm adding containers ml as we had a discussion there some time ago
>>>>>  for this feature]
>>>> [ ... ]
>>>>
>>>>>> +    if (cmd == LINUX_REBOOT_CMD_RESTART2)
>>>>>> +        if (strncpy_from_user(&buffer[0], arg, sizeof(buffer) - 1) < 0)
>>>>>> +            return -EFAULT;
>>>>>> +
>>>>>> +    /* If we are not in the initial pid namespace, we send a signal
>>>>>> +     * to the parent of this init pid namespace, notifying a shutdown
>>>>>> +     * occured */
>>>>>> +    if (pid_ns != &init_pid_ns)
>>>>>> +        pid_namespace_reboot(pid_ns, cmd, buffer);
>>>>> Should there be a return here?
>>>>> Or does pid_namespace_reboot() never return by submitting signal to
>>>>> parent?
>>>> Yes, it does not return a value, like 'do_notify_parent_cldstop'
>>> So execution flow continues reaching the whole "host reboot code"?
>>>
>>> That's not so good as it then prevents using CAP_SYS_BOOT inside PID namespace
>>> to limit access to rebooting the container from inside as giving a process
>>> inside container CAP_SYS_BOOT would cause host to reboot (and when not given
>>> process inside container would get -EPERM in all cases).
>>>
>>> Wouldn't the following be better?:
>>> ...
>>> +
>>> +    /* We only trust the superuser with rebooting the system. */
>>> +    if (!capable(CAP_SYS_BOOT))
>>> +        return -EPERM;
>>> +
>>> +    /* If we are not in the initial pid namespace, we send a signal
>>> +     * to the parent of this init pid namespace, notifying a shutdown
>>> +     * occured */
>>> +    if (pid_ns != &init_pid_ns) {
>>> +        pid_namespace_reboot(pid_ns, cmd, buffer);
>>> +        return 0;
>>> +    }
>>> +
>>>      mutex_lock(&reboot_mutex);
>>>      switch (cmd) {
>>> ...
>>>
>>>
>>> If I misunderstood, please correct me.
>>
>> Yep, this is what I did at the beginning but I realized I was closing
>> the door for future applications using the pid namespaces. The pid
>> namespace could be used by another kind of application, not a container,
>> running some administrative tasks so they may want to shutdown the host
>> from a different pid namespace.
>>
>> For this reason, to prevent this execution flow, the container has to
>> drop the CAP_SYS_BOOT in addition of taking care of the SIGCHLD signal
>> with CLDREBOOT.
> 
> Ok, though for later source code readers to know adding/extending comment
> would be nice.
> Maybe something like
> 
> +    /* If we are not in the initial pid namespace, we send a signal
> +     * to the parent of this init pid namespace, notifying a shutdown
> +     * occured
> +     * NOTE: if process has CAP_SYS_BOOT it will additionally have the
> +     * same effect as if it was not namespaced */
> 
> 
> How would all of this integrate with the ongoing work on user namespaces?
> Maybe that one should later be the differentiator for who may or may not
> trigger the host reboot.

I think if you are in a different user namespace than the init one, the
process won't be able to reboot.
I talked with Serge about that and he should execute the
pid_namespace_reboot if it is 'ns_capable' of rebooting the host.

But I think that does not collide after all.


> In addition sending the signal to parent process seems moot as chances are
> that parent process will never have the opportunity to see the signal when
> the host is being rebooted.

Right.

> Then a construct like the following would give a better hint to the reader:
> ...
> +
> +    /* We only trust the superuser with rebooting the system. */
> +    if (!capable(CAP_SYS_BOOT)) {
> +        /* If we are not in the initial pid namespace, we send a signal
> +         * to the parent of this init pid namespace, notifying a shutdown
> +         * occured */
> +        if (pid_ns != &init_pid_ns)
> +            pid_namespace_reboot(pid_ns, cmd, buffer);
> +
> +        return -EPERM;
> +    }

Ok, let me respin the patchset and change that. I will submit the patch
to akpm and lkml. Let's see what they think about this approach.

Thanks
  -- Daniel
