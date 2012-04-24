Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932066Ab2DXI4Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 04:56:25 -0400
Received: from mga09.intel.com ([134.134.136.24]:29362 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754452Ab2DXI4X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 04:56:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="133152609"
Message-ID: <4F966AB5.4010909@intel.com>
Date: Tue, 24 Apr 2012 16:56:21 +0800
From: "Yan, Zheng" <zheng.z.yan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: a.p.zijlstra@chello.nl, mingo@elte.hu, andi@firstfloor.org,
        linux-kernel@vger.kernel.org, ming.m.lin@intel.com,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: [RFC PATCH V2 0/6] perf: Intel uncore pmu counting support
References: <1333244495-1020-1-git-send-email-zheng.z.yan@intel.com> <CABPqkBQQo4TZVDA4pfujt7X0tTaV+PVOg8epDVS89DONV_XOtg@mail.gmail.com>
In-Reply-To: <CABPqkBQQo4TZVDA4pfujt7X0tTaV+PVOg8epDVS89DONV_XOtg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2012 11:21 PM, Stephane Eranian wrote:
> Hi,
> 
> [+jolsa as it may have something to do with the event parser]
> 
> I started testing this on my NHM desktop machine, and I ran into the following
> problem:
> $ perf stat -a -C 0 -e uncore_nhm/CLOCKTICKS/,cycles,ref-cycles  --
> taskset -c 0 noploop 1
> noploop for 1 seconds
>  Performance counter stats for 'taskset -c 0 noploop 1':
>      3,435,695,848 cycles                    #    0.000 GHz
>          [100.00%]
>      2,803,309,845 ref-cycles
>      2,410,926,590 pmu
>        1.001391268 seconds time elapsed
> 
> First here, the cmdline event order is not respected. uncore events
> appear at the end. That's not very
> intuitive. Especially when you know that they all show up as 'pmu'. In
> other words, you cannot figure
> out what each value represents.
> 
> $ sudo perf stat -a -C 0 -e uncore_nhm/CLOCKTICKS/  -- taskset -c 0 noploop 1
> noploop for 1 seconds
>  Performance counter stats for 'taskset -c 0 noploop 1':
>      2,410,862,301 pmu
>        1.001393218 seconds time elapsed
> 
> That looks like the right value, well, minus the 'pmu' event name. But
> that's a different problem.
> 
> But then, the pathological case:
> 
> $ sudo perf stat -a -C 0 -e
> uncore_nhm/CLOCKTICKS/,uncore_nhm/QMC_NORMAL_READS_ANY/  -- taskset -c
> 0 noploop 1
> noploop for 1 seconds
>  Performance counter stats for 'taskset -c 0 noploop 1':
>             10,705 pmu
>        1.001395772 seconds time elapsed
> 
> If you pass more than one uncore event, all but the last one are
> suppressed from the output.
> It does not happen with core PMU events.
> 
> Looks like something may be wrong in the way the parser adds uncore events.
> 
> 
Thank you very much for pointing out this. I will try changing the flex and
bison input files to generate reentrant parser. I hope it can solve all these
issues.

Regards
Yan, Zheng

> On Sun, Apr 1, 2012 at 3:41 AM, Yan, Zheng <zheng.z.yan@intel.com> wrote:
>> Hi, all
>>
>> Here is the RFC patches to add uncore counting support for Nehalem,
>> Sandy Bridge and Sandy Bridge-EP, applied on top of current tip.
>> The code is based on Lin Ming's old patches.
>>
>> For Nehalem and Sandy Bridge-EP, A few general events are exported
>> under directory:
>> /sys/bus/event_source/devices/uncore_xxx/events/
>>
>> You can use 'perf stat' to access to the uncore pmu. For example:
>> perf stat -a -C 0 -e 'uncore_nhm/QMC_WRITES_FULL_ANY/' sleep 1
>>
>> Any comment is appreciated.
>> Thank you
>>
>> ---
>> Changes since v1:
>>  - Modify perf tool to parse events from sysfs
>>  - A few minor code cleanup
>>

