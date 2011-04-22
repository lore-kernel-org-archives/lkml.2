Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756204Ab1DVQhq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 12:37:46 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:46301 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756180Ab1DVQhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 12:37:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=O26SYgIGcY7YcZqKC7FqlrYbExEEE74ctk+e4IulSYBvfi3qWce76RIo6YR7EEd0cq
         VSRr71icPq/bFxwcJrJvBA8GBumZcmos3Ym7qvwrtOiea7EOBaZmjNgNqIp/Qqrw1QQK
         iVYgKRGs/SVbyu3f/lYI81l2LjXSlTMgqAGc4=
Message-ID: <4DB1AED0.60600@gmail.com>
Date: Fri, 22 Apr 2011 10:37:36 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Tim Blechmann <tim@klingt.org>, linux-kernel@vger.kernel.org
Subject: Re: [2.6.39-rc2] perf top fails to mmap - bisected to 70db7533
References: <inhgjs$54a$1@dough.gmane.org> <4D9C84D5.6090303@gmail.com> <20110406175217.GC4987@ghostprotocols.net> <201104062248.23853.tim@klingt.org> <4D9CE610.4020603@gmail.com> <4D9CECF5.3090309@gmail.com>
In-Reply-To: <4D9CECF5.3090309@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I know you've been busy with other stuff the past few weeks, but have
you had a chance to look into this? Basically, perf in 2.6.39 is broken
when trying to profile a process (-p argument to record or top).

David


> On 04/06/11 16:15, David Ahern wrote:
>>
>>
>> On 04/06/11 14:48, Tim Blechmann wrote:
>>>>> David
>>>>>
>>>>>> this happens when running perf as the same process as the process and
>>>>>> when running perf as root.
>>>>
>>>> yep, works for me as well:
>>>>
>>>> [acme@emilia ~]$ cat vsyscall.c
>>>
>>> after including unistd.h, this compiles and works fine. however i cannot profile 
>>> any multithreaded program. does this work for you?
>>>
>>> tim
>>>
>>
>> That does fail:
>> # ps -C rsyslogd -L
>>   PID   LWP TTY          TIME CMD
>>   795   795 ?        00:00:00 rsyslogd
>>   795   797 ?        00:00:00 rsyslogd
>>   795   798 ?        00:00:00 rsyslogd
>>
>> # /tmp/build-perf/perf top -p 795
>> Failed to mmap with 22 (Invalid argument)
>>
>> strace shows it failing at:
>> ioctl(4, PERF_EVENT_IOC_SET_OUTPUT, 0x3) = -1 EINVAL (Invalid argument)
>>
>> Changing to use thread only works:
>> # /tmp/build-perf/perf top -t 795
> 
> git bisect points to:
> 
> 70db7533caef02350ec8d6852e589491bca3a951 is the first bad commit
> commit 70db7533caef02350ec8d6852e589491bca3a951
> Author: Arnaldo Carvalho de Melo <acme@redhat.com>
> Date:   Wed Jan 12 22:39:13 2011 -0200
> 
> perf evlist: Move the mmap array from perf_evsel
> 
> Adopting the new model used in 'perf record', where we don't have a map
> per thread per cpu, instead we have an mmap per cpu, established on the
> first fd for that cpu and ask the kernel using the
> PERF_EVENT_IOC_SET_OUTPUT ioctl to send events for the other fds on that
> cpu for the one with the mmap.
> 
> The methods moved from perf_evsel to perf_evlist, but for easing review
> they were modified in place, in evsel.c, the next patch will move the
> migrated methods to evlist.c.
> 
> With this 'perf top' now uses the same mmap model used by 'perf record'
> and the next patches will make 'perf record' use these new routines,
> establishing a common codebase for both tools.
> 
> ----------
> 
> Coincidentally, perf-record is also broken. git bisect points to:
> 
> dd7927f4f8ee75b032ff15aeef4bda49719a443a is the first bad commit
> commit dd7927f4f8ee75b032ff15aeef4bda49719a443a
> Author: Arnaldo Carvalho de Melo <acme@redhat.com>
> Date:   Wed Jan 12 14:28:51 2011 -0200
> 
> perf record: Use perf_evsel__open
> 
> Now its time to factor out the mmap handling bits into the perf_evsel
> class.
