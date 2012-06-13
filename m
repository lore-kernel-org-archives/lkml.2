Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751766Ab2FMGhw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 02:37:52 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:55428 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751094Ab2FMGhv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 02:37:51 -0400
MIME-Version: 1.0
In-Reply-To: <4FD7EFCB.6060005@intel.com>
References: <1339479468-3815-1-git-send-email-zheng.z.yan@intel.com>
	<CABPqkBQu1hTa2R-PKsygLqOSSD9nu3+xR-79pT-8bB8Y16CBuw@mail.gmail.com>
	<4FD7EFCB.6060005@intel.com>
Date: Wed, 13 Jun 2012 08:37:49 +0200
Message-ID: <CABPqkBQmdyfxJ1iFoGt45c84zzzUphosY8Qg76MACX=xdtk_mw@mail.gmail.com>
Subject: Re: [PATCH V5 0/13] perf: Intel uncore pmu counting support
From: Stephane Eranian <eranian@google.com>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: a.p.zijlstra@chello.nl, mingo@elte.hu, jolsa@redhat.com,
        andi@firstfloor.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2012 at 3:41 AM, Yan, Zheng <zheng.z.yan@intel.com> wrote:
> On 06/12/2012 11:38 PM, Stephane Eranian wrote:
>> On Tue, Jun 12, 2012 at 7:37 AM, Yan, Zheng <zheng.z.yan@intel.com> wrote:
>>> Hi, all
>>>
>>> Here is the V5 patches to add uncore counting support for Nehalem,
>>> Sandy Bridge and Sandy Bridge-EP, applied on top of current tip.
>>> The code is based on Lin Ming's old patches.
>>>
>>> For Nehalem and Sandy Bridge-EP, A few general events are exported
>>> under sysfs directory:
>>>  /sys/bus/event_source/devices/${uncore_dev}/events/
>>>
>> On NHM, I tried:
>>     perf stat -a -e Uncore/CLOCKTICKS/
>> invalid or unsupported event: 'Uncore/CLOCKTICKS/'
>
> Strange enough. Did you re-compile the perf tool? Are there
> files under directory /sys/bus/event_source/devices/Uncore/events
>>
Of course I did recompile. And of course there are files under events. Otherwise
I would not have gone that far in the analysis of the parsing problem.

>> I started tracking this down but gave up because it's coming
>> once again from the too complex parser. You are looking for
>> a format match (inv, edge, cmask) with the word CLOCKTICKS
>> instead of config.
>>
>> Please fix this.
>>
>> Also I don't think using upper case for the PMU name is a good idea.
>> Just call it uncore.
>>
>
> Peter suggests keeping the uncore names as they're listed in the intel
> doc. For Sandybirdge-EP, uncore names are something like: Cbo, iMC, QPI.
> I think Uncore_Cbo_0 appears better than uncore_Cbo_0
>
Keeping the name is different from keeping the upper vs. lower case letters.
I think this need to be case insensitive. What does it buy you to be case
sensitive? Don't think Intel is ever going to create two events which differ
only by the lower vs. upper case. And, I think that's extra frustration when
you type the event name because you have to also remember the letter
case.

> Regards
> Yan, Zheng
>>
>>> Each file in the events directory defines an event. The content is
>>> a string such as:
>>>  config=1,config1=2
>>>
>>> You can use 'perf stat' to access to the uncore pmu. For example:
>>>  perf stat -a -C 0 -e 'Uncore_iMC_0/CAS_COUNT_RD/' sleep 1
>>>  perf stat -a -C 0 -e 'Uncore_iMC_0/event=CAS_COUNT_RD/' sleep 1
>>>
>>> Any comment is appreciated.
>>> Thank you
>>> ---
>>> Changes since v1:
>>>  - Modify perf tool to parse events from sysfs
>>>  - A few minor code cleanup
>>>
>>> Changes since v2:
>>>  - Place all events for a particular socket onto a single cpu
>>>  - Make the events parser in perf tool reentrantable
>>>  - A few code cleanup
>>>
>>> Changes since v3:
>>>  - Use per cpu pointer to track uncore box
>>>  - Rework the cpu hotplug code because topology_physical_package_id()
>>>   return wrong result when the cpu is offline
>>>  - Rework the event alias code, event terms are stored in the alias
>>>   structure instead events string
>>>
>>> Changes since v4:
>>>  - Include Jiri's uncore related changes patch set
>>>  - Add pmu/event=alias/ syntax support
>>>
>
>
