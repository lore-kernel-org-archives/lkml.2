Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757750Ab2FECSR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 22:18:17 -0400
Received: from mga11.intel.com ([192.55.52.93]:17166 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751173Ab2FECSQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 22:18:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="174821945"
Message-ID: <4FCD6C67.9050103@linux.intel.com>
Date: Tue, 05 Jun 2012 10:18:15 +0800
From: "Yan, Zheng" <zheng.z.yan@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120424 Thunderbird/12.0
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: "Yan, Zheng" <zheng.z.yan@intel.com>, a.p.zijlstra@chello.nl,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf: Fix intel shared extra msr allocation
References: <1338520856-21020-1-git-send-email-zheng.z.yan@intel.com> <CABPqkBScjC5fJbTc1rYtbtRqOCyJ+7QUbdE32DgMcffBAGJNVw@mail.gmail.com> <CAAM7YAkYgUjwQptYvyeVawzcD5x4c-bTT_=+6AMyUb+-6HoMuQ@mail.gmail.com> <CABPqkBRA0Z-oZfSgdyurtW0=KUbuGJ+uFqiVKiwbt9Wpk1Ph7w@mail.gmail.com>
In-Reply-To: <CABPqkBRA0Z-oZfSgdyurtW0=KUbuGJ+uFqiVKiwbt9Wpk1Ph7w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2012 09:12 PM, Stephane Eranian wrote:
> On Fri, Jun 1, 2012 at 4:11 PM, Yan, Zheng <zheng.z.yan@linux.intel.com> wrote:
>> On Fri, Jun 1, 2012 at 5:35 PM, Stephane Eranian <eranian@google.com> wrote:
>>> On Fri, Jun 1, 2012 at 5:20 AM, Yan, Zheng <zheng.z.yan@intel.com> wrote:
>>>> From: "Yan, Zheng" <zheng.z.yan@intel.com>
>>>>
>>>> intel_shared_reg_get/put_constraints() can be indirectly called
>>>> by validate_group(). In that case, they should avoid modifying
>>>> the perf_event date structure because the event can be already
>>>> in active state. Otherwise the shared extra msr's reference
>>>> count will be left in inconsistent state.
>>>>
>>> I understand the problem but I am wondering if you actually saw
>>> it in real life. The reason I am asking is because  of the way
>>> validate_group() collects the events and how they are added
>>> to sibling_list. The new event is added at the tail. Thus it will
>>> come last, and will get to __intel_shared_reg_get_constraints()
>>> last, thus I am wondering if it can really modify the programming
>>> on the existing events.
>>
>> The real problem is from __intel_shared_reg_put_constraints(). it set
>> reg->alloc to 0 and decreases fake_cpuc->shared_regs->regs[reg->idx]'s
>> reference count. Later when deleting the event,  put_constraints() will find
>> reg->alloc is 0 and it won't decrease the shared msr's reference count.
>>
>> Run 'perf stat --group -a -C 0 -e LLC-loads -e LLC-stores sleep 1" on
>> Nehalem can trigger the bug.
>>
> And what do you see in this particular example?
The offcore_rsp msr's reference count are left in inconsistent state. It means
we can only use the msr for LLC-loads event after that. Any other events that
require programming the offcore_rsp msr will fail.

> 
> I'd like to see the results via libpfm4 and /perf_examples/syst_count:
> $ sudo ./syst_count -e offcore_response_0:dmnd_data_rd
> -eoffcore_response_0:dmnd_rfo  -p -d 10 -c 0
> 
This does not use the event group feature. do you mean
./syst_count -e offcore_response_0:dmnd_data_rd,offcore_response_0:dmnd_rfo -p -d 10 -c 0.

After apply my patch, the above command fails on Nehalem. Because there is no offcore_rsp1.

Regards
Yan, Zheng
