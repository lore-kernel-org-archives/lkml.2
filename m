Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241Ab1AQIlM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 03:41:12 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50984 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752962Ab1AQIlK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 03:41:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=qFqhkMwYmjfHhEsMpXy3LFOn8GvEjZYJtBzq0v0r5Zn7DWpvGHE4Z2YE+IA9v7lZ5B
         +Eqa1kA+Wf3Wmd+MEjiQ3JpnwSyYpWTQJy1D0mQ61h6adfElOgAzESuFaCmK34QkNSoD
         yqaa7aF5cFIiVrIJUPP0ZvI4fRlN5ThWiiCXY=
MIME-Version: 1.0
In-Reply-To: <4D33BA7F.3030606@cn.fujitsu.com>
References: <1294735916.1949.637.camel@sli10-conroe>
	<AANLkTim72yNM1svGbFTKW8pSnFP9W+YgvGs4moXq+pyo@mail.gmail.com>
	<20110112023026.GA26525@sli10-conroe.sh.intel.com>
	<AANLkTim=eCQ4AuipHXK=M-2ox4KZ8jntjcDbg+J6kfFb@mail.gmail.com>
	<4D33BA7F.3030606@cn.fujitsu.com>
Date: Mon, 17 Jan 2011 16:41:08 +0800
X-Google-Sender-Auth: ZDlhHncE8hE-vvbgteCryxwC5GM
Message-ID: <AANLkTim-DctQ+xpM7YVtOmmAxNqRV3nWKT1OwS2nJVV0@mail.gmail.com>
Subject: Re: [PATCH 1/2]block cfq: make queue preempt work for queues from
 different workload
From: Shaohua Li <shli@kernel.org>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: Corrado Zoccolo <czoccolo@gmail.com>, Jens Axboe <jaxboe@fusionio.com>,
        lkml <linux-kernel@vger.kernel.org>, Vivek Goyal <vgoyal@redhat.com>,
        "jmoyer@redhat.com" <jmoyer@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/1/17 Gui Jianfeng <guijianfeng@cn.fujitsu.com>:
> Shaohua Li wrote:
>> 2011/1/12 Shaohua Li <shaohua.li@intel.com>:
>>> Hi,
>>> On Wed, Jan 12, 2011 at 05:07:47AM +0800, Corrado Zoccolo wrote:
>>>> Hi Shaohua,
>>>> On Tue, Jan 11, 2011 at 9:51 AM, Shaohua Li <shaohua.li@intel.com> wrote:
>>>>> I got this:
>>>>>             fio-874   [007]  2157.724514:   8,32   m   N cfq874 preempt
>>>>>             fio-874   [007]  2157.724519:   8,32   m   N cfq830 slice expired t=1
>>>>>             fio-874   [007]  2157.724520:   8,32   m   N cfq830 sl_used=1 disp=0 charge=1 iops=0 sect=0
>>>>>             fio-874   [007]  2157.724521:   8,32   m   N cfq830 set_active wl_prio:0 wl_type:0
>>>>>             fio-874   [007]  2157.724522:   8,32   m   N cfq830 Not idling. st->count:1
>>>>> cfq830 is an async queue, and preempted by a sync queue cfq874. But since we
>>>>> have cfqg->saved_workload_slice mechanism, the preempt is a nop.
>>>>> Looks currently our preempt is totally broken if the two queues are not from
>>>>> the same workload type.
>>>>> Below patch fixes it. This will might make async queue starvation, but it's
>>>>> what our old code does before cgroup is added.
>>>> have you measured latency improvements by un-breaking preemption?
>>>> AFAIK, preemption behaviour changed since 2.6.33, before cgroups were
>>>> added, and the latency before the changes that weakened preemption in
>>>> 2.6.33 was far worse.
>>> Yes. I'm testing a SD card for MeeGo. The random write is very slow (~12k/s) but
>>> random read is relatively fast > 1M/s.
>>>
>>> Without patch:
>>> write: (groupid=0, jobs=1): err= 0: pid=3876
>>>  write: io=966656 B, bw=8054 B/s, iops=1 , runt=120008msec
>>>    clat (usec): min=5 , max=1716.3K, avg=88637.38, stdev=207100.44
>>>     lat (usec): min=5 , max=1716.3K, avg=88637.69, stdev=207100.41
>>>    bw (KB/s) : min=    0, max=   52, per=168.17%, avg=11.77, stdev= 8.85
>>> read: (groupid=0, jobs=1): err= 0: pid=3877
>>>  read : io=52516KB, bw=448084 B/s, iops=109 , runt=120014msec
>>>    slat (usec): min=7 , max=1918.5K, avg=519.78, stdev=25777.85
>>>    clat (msec): min=1 , max=2728 , avg=71.17, stdev=216.92
>>>     lat (msec): min=1 , max=2756 , avg=71.69, stdev=219.52
>>>    bw (KB/s) : min=    1, max= 1413, per=66.42%, avg=567.22, stdev=461.50
>>>
>>> With patch:
>>> write: (groupid=0, jobs=1): err= 0: pid=4884
>>>  write: io=81920 B, bw=677 B/s, iops=0 , runt=120983msec
>>>    clat (usec): min=13 , max=742976 , avg=155694.10, stdev=244610.02
>>>     lat (usec): min=13 , max=742976 , avg=155694.50, stdev=244609.89
>>>    bw (KB/s) : min=    0, max=   31, per=inf%, avg= 8.40, stdev=12.78
>>> read: (groupid=0, jobs=1): err= 0: pid=4885
>>>  read : io=133008KB, bw=1108.3KB/s, iops=277 , runt=120022msec
>>>    slat (usec): min=8 , max=1159.1K, avg=164.24, stdev=9116.65
>>>    clat (msec): min=1 , max=1988 , avg=28.34, stdev=55.81
>>>     lat (msec): min=1 , max=1989 , avg=28.51, stdev=57.51
>>>    bw (KB/s) : min=    2, max= 1808, per=51.10%, avg=1133.42, stdev=275.59
>>>
>>> Both read latency/throughput has big difference with the patch, but write
>>> gets starvation.
>> Hi Jens and others,
>> How do you think about the patch?
>
> Further more, Consider the following piece code.
>
> 2132         /*
> 2133          * For RT and BE, we have to choose also the type
> 2134          * (SYNC, SYNC_NOIDLE, ASYNC), and to compute a workload
> 2135          * expiration time
> 2136          */
> 2137         st = service_tree_for(cfqg, cfqd->serving_prio, cfqd->serving_type);
> 2138         count = st->count;
> 2139
> 2140         /*
> 2141          * check workload expiration, and that we still have other queues ready
> 2142          */
> 2143         if (count && !time_after(jiffies, cfqd->workload_expires))
> 2144                 return;
>
> here, cfqd->serving_prio might be changed. But we continue to check workload expire
> to decide whether let the old workload run. I don't think this makes too much sence.
> I think if cfqd->serving_prio gets changed, we should recalculate workload type.
> Am i missing something?
This is already fixed in latest git
e4ea0c16a85d221ebcc3a21f32e321440459e0fc

Thanks,
Shaohua
