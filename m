Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756145Ab1DFWpO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 18:45:14 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:40279 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754992Ab1DFWpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 18:45:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=TvXYJGFcCDqD3wYPrJgD19ShdQF57J6oy7J3q8WuKnbA/lRZ1Mz/5wz6M7AYetThLq
         bRQr0Vj6d4vVSmMFZ0JiNkaT7BYvB0bC2cgOnvc67oNqCUZMr27BBHWv4CeQGVpLgw/S
         GWm/CLM0RkOvN0OcfM44utM8ifPOZY9bYD0o8=
Message-ID: <4D9CECF5.3090309@gmail.com>
Date: Wed, 06 Apr 2011 16:45:09 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Tim Blechmann <tim@klingt.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: [2.6.39-rc2] perf top fails to mmap - bisected to 70db7533
References: <inhgjs$54a$1@dough.gmane.org> <4D9C84D5.6090303@gmail.com> <20110406175217.GC4987@ghostprotocols.net> <201104062248.23853.tim@klingt.org> <4D9CE610.4020603@gmail.com>
In-Reply-To: <4D9CE610.4020603@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 04/06/11 16:15, David Ahern wrote:
> 
> 
> On 04/06/11 14:48, Tim Blechmann wrote:
>>>> David
>>>>
>>>>> this happens when running perf as the same process as the process and
>>>>> when running perf as root.
>>>
>>> yep, works for me as well:
>>>
>>> [acme@emilia ~]$ cat vsyscall.c
>>
>> after including unistd.h, this compiles and works fine. however i cannot profile 
>> any multithreaded program. does this work for you?
>>
>> tim
>>
> 
> That does fail:
> # ps -C rsyslogd -L
>   PID   LWP TTY          TIME CMD
>   795   795 ?        00:00:00 rsyslogd
>   795   797 ?        00:00:00 rsyslogd
>   795   798 ?        00:00:00 rsyslogd
> 
> # /tmp/build-perf/perf top -p 795
> Failed to mmap with 22 (Invalid argument)
> 
> strace shows it failing at:
> ioctl(4, PERF_EVENT_IOC_SET_OUTPUT, 0x3) = -1 EINVAL (Invalid argument)
> 
> Changing to use thread only works:
> # /tmp/build-perf/perf top -t 795

git bisect points to:

70db7533caef02350ec8d6852e589491bca3a951 is the first bad commit
commit 70db7533caef02350ec8d6852e589491bca3a951
Author: Arnaldo Carvalho de Melo <acme@redhat.com>
Date:   Wed Jan 12 22:39:13 2011 -0200

perf evlist: Move the mmap array from perf_evsel

Adopting the new model used in 'perf record', where we don't have a map
per thread per cpu, instead we have an mmap per cpu, established on the
first fd for that cpu and ask the kernel using the
PERF_EVENT_IOC_SET_OUTPUT ioctl to send events for the other fds on that
cpu for the one with the mmap.

The methods moved from perf_evsel to perf_evlist, but for easing review
they were modified in place, in evsel.c, the next patch will move the
migrated methods to evlist.c.

With this 'perf top' now uses the same mmap model used by 'perf record'
and the next patches will make 'perf record' use these new routines,
establishing a common codebase for both tools.

----------

Coincidentally, perf-record is also broken. git bisect points to:

dd7927f4f8ee75b032ff15aeef4bda49719a443a is the first bad commit
commit dd7927f4f8ee75b032ff15aeef4bda49719a443a
Author: Arnaldo Carvalho de Melo <acme@redhat.com>
Date:   Wed Jan 12 14:28:51 2011 -0200

perf record: Use perf_evsel__open

Now its time to factor out the mmap handling bits into the perf_evsel
class.
