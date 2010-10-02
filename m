Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751176Ab0JBRkN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 13:40:13 -0400
Received: from smtp-out.google.com ([216.239.44.51]:40425 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041Ab0JBRkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 13:40:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Z9l3MHk21aTjvtV54uvXX4KeNP9XAEkYq8lhhjeKphz2TDpjLbG2mw29UG/LAHS/hJ
         1oKbrEmcVa7tLAKCovfA==
MIME-Version: 1.0
In-Reply-To: <20101002095022.GK13563@erda.amd.com>
References: <20100915162034.GO13563@erda.amd.com>
	<tip-63e6be6d98e1a2bcdca86872b67052e51ab6afa1@git.kernel.org>
	<AANLkTimB2gf=2zYCwiKEgozt_Rsa1Cpb6JuLSzmHusFX@mail.gmail.com>
	<20100929125301.GG13563@erda.amd.com>
	<20100929125453.GH13563@erda.amd.com>
	<AANLkTimoE8wAhT+yxXBPnZvTTGrAtDjdaXPBN3Xg28eL@mail.gmail.com>
	<20100929133923.GI13563@erda.amd.com>
	<AANLkTin2QnqsfxdZa2D07DKCM0n5bX43Ch6KqumaDW=O@mail.gmail.com>
	<AANLkTimPUmFuoGNurgW3cQm41biT5y-Gpmob-mqC=rD8@mail.gmail.com>
	<20101002095022.GK13563@erda.amd.com>
Date: Sat, 2 Oct 2010 19:40:08 +0200
Message-ID: <AANLkTimcETBkp75b+EY-Vy8g65Hn2suTkpm-5Q8fEqMi@mail.gmail.com>
Subject: Re: [tip:perf/urgent] perf, x86: Catch spurious interrupts after
 disabling counters
From: Stephane Eranian <eranian@google.com>
To: Robert Richter <robert.richter@amd.com>
Cc: "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "gorcunov@gmail.com" <gorcunov@gmail.com>,
        "ying.huang@intel.com" <ying.huang@intel.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "ming.m.lin@intel.com" <ming.m.lin@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "mingo@elte.hu" <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 2, 2010 at 11:50 AM, Robert Richter <robert.richter@amd.com> wrote:
> On 29.09.10 10:00:54, Stephane Eranian wrote:
>
>> > Here is another difference I noticed in x86_handle_irq() vs.
>> > intel_pmu_handle_irq().
>> > For Intel, handled is incremented even if there is no 64-bit overflow.
>> >
>> > With generic X86, it is incremented only when you have a 64-bit
>> > overflow. I think that's wrong. You don't hit that condition very often
>> > on AMD because counters are 47 bits wide, but this is generic code
>> > and on P6 you definitively will. I believe you need to hoist handled++
>> > just after the check on active_mask.
>> >
>> >
>> > What do you think?
>> >
>> In other words, I think handled is there to track interrupts, i.e., hw
>> counter overflows, and not 64-bit software counter overflows (which
>> do trigger sample recording).
>
> Stephane, the code looks good. We must first read the counter msr, its
> raw value is returned by x86_perf_event_update(). Then we check we MSB
> of the *counter* value and if it is zero, we detected a counter
> overflow (not a 64 bit overflow) and increment 'handled'.
>
Yes, you are right. I double-checked that again Friday and the code is
okay for Intel, generic X86 and P4.
