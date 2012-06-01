Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759992Ab2FAOLN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 10:11:13 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:34926 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758970Ab2FAOLM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 10:11:12 -0400
MIME-Version: 1.0
In-Reply-To: <CABPqkBScjC5fJbTc1rYtbtRqOCyJ+7QUbdE32DgMcffBAGJNVw@mail.gmail.com>
References: <1338520856-21020-1-git-send-email-zheng.z.yan@intel.com>
	<CABPqkBScjC5fJbTc1rYtbtRqOCyJ+7QUbdE32DgMcffBAGJNVw@mail.gmail.com>
Date: Fri, 1 Jun 2012 22:11:11 +0800
X-Google-Sender-Auth: QTYGM8HDoAe2HCDki7ueSLztmmw
Message-ID: <CAAM7YAkYgUjwQptYvyeVawzcD5x4c-bTT_=+6AMyUb+-6HoMuQ@mail.gmail.com>
Subject: Re: [PATCH] perf: Fix intel shared extra msr allocation
From: "Yan, Zheng" <zheng.z.yan@linux.intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>, a.p.zijlstra@chello.nl,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 1, 2012 at 5:35 PM, Stephane Eranian <eranian@google.com> wrote:
> On Fri, Jun 1, 2012 at 5:20 AM, Yan, Zheng <zheng.z.yan@intel.com> wrote:
>> From: "Yan, Zheng" <zheng.z.yan@intel.com>
>>
>> intel_shared_reg_get/put_constraints() can be indirectly called
>> by validate_group(). In that case, they should avoid modifying
>> the perf_event date structure because the event can be already
>> in active state. Otherwise the shared extra msr's reference
>> count will be left in inconsistent state.
>>
> I understand the problem but I am wondering if you actually saw
> it in real life. The reason I am asking is because  of the way
> validate_group() collects the events and how they are added
> to sibling_list. The new event is added at the tail. Thus it will
> come last, and will get to __intel_shared_reg_get_constraints()
> last, thus I am wondering if it can really modify the programming
> on the existing events.

The real problem is from __intel_shared_reg_put_constraints(). it set
reg->alloc to 0 and decreases fake_cpuc->shared_regs->regs[reg->idx]'s
reference count. Later when deleting the event,  put_constraints() will find
reg->alloc is 0 and it won't decrease the shared msr's reference count.

Run 'perf stat --group -a -C 0 -e LLC-loads -e LLC-stores sleep 1" on
Nehalem can trigger the bug.

>
> See more comments inline.
>
>> Signed-off-by: Zheng Yan <zheng.z.yan@intel.com>
>> ---
>>  arch/x86/kernel/cpu/perf_event_intel.c |   31 +++++++++++++++++++++++--------
>>  1 files changed, 23 insertions(+), 8 deletions(-)
>>
>> diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
>> index 166546e..10840d0 100644
>> --- a/arch/x86/kernel/cpu/perf_event_intel.c
>> +++ b/arch/x86/kernel/cpu/perf_event_intel.c
>> @@ -1119,11 +1119,21 @@ intel_bts_constraints(struct perf_event *event)
>>        return NULL;
>>  }
>>
>> -static bool intel_try_alt_er(struct perf_event *event, int orig_idx)
>> +static bool intel_try_alt_er(struct perf_event *event, int *idx,
>> +                            int orig_idx, bool fake_cpuc)
>>  {
>> -       if (!(x86_pmu.er_flags & ERF_HAS_RSP_1))
>> +       if (!(x86_pmu.er_flags & ERF_HAS_RSP_1) || *idx != orig_idx)
>>                return false;
>>
>> +       /* don't modify the event structure if the cpuc is faked */
>> +       if (fake_cpuc) {
>> +               if (*idx == EXTRA_REG_RSP_0)
>> +                       *idx = EXTRA_REG_RSP_1;
>> +               else if (*idx == EXTRA_REG_RSP_1)
>> +                       *idx = EXTRA_REG_RSP_0;
>> +               return (*idx != orig_idx);
>> +       }
>> +
> I understand that.
>
>>        if (event->hw.extra_reg.idx == EXTRA_REG_RSP_0) {
>>                event->hw.config &= ~INTEL_ARCH_EVENT_MASK;
>>                event->hw.config |= 0x01bb;
>> @@ -1139,6 +1149,7 @@ static bool intel_try_alt_er(struct perf_event *event, int orig_idx)
>>        if (event->hw.extra_reg.idx == orig_idx)
>>                return false;
>>
>> +       *idx = event->hw.extra_reg.idx;
>>        return true;
>>  }
>>
>> @@ -1155,16 +1166,18 @@ __intel_shared_reg_get_constraints(struct cpu_hw_events *cpuc,
>>                                   struct hw_perf_event_extra *reg)
>>  {
>>        struct event_constraint *c = &emptyconstraint;
>> +       struct intel_shared_regs *shared_regs = cpuc->shared_regs;
>>        struct er_account *era;
>>        unsigned long flags;
>>        int orig_idx = reg->idx;
>> +       int idx = orig_idx;
>>
>> -       /* already allocated shared msr */
>> -       if (reg->alloc)
>> +       /* shared msr is already allocated and cpuc is not faked */
>> +       if (reg->alloc && shared_regs->core_id != -1)
>>                return NULL; /* call x86_get_event_constraint() */
>>
> I don't understand what you need this stuff. Shared_regs is faked as well.

The event can be in active state, we should avoid clearing reg->alloc.

Regards
Yan, Zheng
