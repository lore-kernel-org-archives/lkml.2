Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757356Ab2FEMvz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 08:51:55 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:46450 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757Ab2FEMvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 08:51:53 -0400
MIME-Version: 1.0
In-Reply-To: <1338899999.28282.164.camel@twins>
References: <1338520856-21020-1-git-send-email-zheng.z.yan@intel.com>
	<CABPqkBScjC5fJbTc1rYtbtRqOCyJ+7QUbdE32DgMcffBAGJNVw@mail.gmail.com>
	<CAAM7YAkYgUjwQptYvyeVawzcD5x4c-bTT_=+6AMyUb+-6HoMuQ@mail.gmail.com>
	<1338891271.28282.155.camel@twins>
	<CABPqkBSv8CbMzUiRsN2uOF1v6rFTpzhQqNbo7OKe-nzsus0GDg@mail.gmail.com>
	<1338892071.28282.157.camel@twins>
	<CABPqkBSqLpa4X-WbR0PkouYvhODT78r3pxWq70=PTj1j=a307Q@mail.gmail.com>
	<1338898024.28282.160.camel@twins>
	<1338899999.28282.164.camel@twins>
Date: Tue, 5 Jun 2012 14:51:52 +0200
Message-ID: <CABPqkBRCMAnPH3UW0=afMw4-YXgwQ5D-NLMEtnNWde_Tzh3aew@mail.gmail.com>
Subject: Re: [PATCH] perf: Fix intel shared extra msr allocation
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Yan, Zheng" <zheng.z.yan@linux.intel.com>,
        "Yan, Zheng" <zheng.z.yan@intel.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 5, 2012 at 2:39 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2012-06-05 at 14:07 +0200, Peter Zijlstra wrote:
>> On Tue, 2012-06-05 at 12:38 +0200, Stephane Eranian wrote:
>> > How about we add a field or flag to cpuc to tell it's fake, and then
>> > in
>> > try_alt_er() and __intel_shared_reg_get_constraints() we avoid
>> > touching
>> > live struct (like reg->alloc) if fake==1. I think he was trying to do
>> > the same with the core_id == -1 test.
>>
>> We might have to do something like that, however I'm trying to figure
>> out when that reg->alloc test in __intel_shared_reg_get_contraints() is
>> useful.
>>
>> If it is useful in event scheduling, we cannot just leave it out in
>> validate_group().
>
> OK, so x86_schedule_events() can call that multiple times on the same
> event in case we keep adding events.. it needs the constraints of the
> previous events as well, and in that case we skip the whole extra_reg
> muck.

That reg->alloc is to avoid going through that shared MSR allocation
code again because we already have a valid assignment. It helps with
incremental scheduling of events (collect() -> schedule()).
>
> But for validate_group() we only do this once, so it should work. Nasty
> though.

True, only one pass. So I think if you say in:
__intel_shared_reg_put_constraints()

     if (!cpuc->is_fake)
           reg->alloc = 1;

That should do it given that:

__intel_shared_reg_put_constraints(struct cpu_hw_events *cpuc,
                                   struct hw_perf_event_extra *reg)
{
        struct er_account *era;
        if (!reg->alloc)
                return;

}

But then, if reg->alloc was already set to 1, you will have a problem
if you leave
it as is. So I think in __intel_shared_reg_put_constraints(), you still need:

__intel_shared_reg_put_constraints(struct cpu_hw_events *cpuc,
                                   struct hw_perf_event_extra *reg)
{
       if (!reg->alloc || cpuc->is_fake)
          return;

Or something like that.
