Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687Ab1EWK6Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 06:58:25 -0400
Received: from smtp-out.google.com ([74.125.121.67]:17439 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711Ab1EWK6Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 06:58:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wkWBZ9l97Bb9CK8FitIXFe7Z79EzcELOtPgwlWjp116MLjXz+hEimA5CxafvU+eJTX
         p/LbLcl3jUdazZjwoBRA==
MIME-Version: 1.0
In-Reply-To: <BANLkTimVM2XvpJ1d9SbmAh7xZ+qSjukX+A@mail.gmail.com>
References: <20110520143707.GA5347@quad>
	<1306141897.18455.8.camel@twins>
	<1306143168.18455.10.camel@twins>
	<BANLkTimVM2XvpJ1d9SbmAh7xZ+qSjukX+A@mail.gmail.com>
Date: Mon, 23 May 2011 12:58:20 +0200
Message-ID: <BANLkTinN92UpxU85r17zB+Khba8k59nJTA@mail.gmail.com>
Subject: Re: [PATCH 0/3] perf_events: update extra shared registers management (v2)
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>, Lin Ming <ming.m.lin@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 23, 2011 at 11:36 AM, Stephane Eranian <eranian@google.com> wrote:
> On Mon, May 23, 2011 at 11:32 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>> On Mon, 2011-05-23 at 11:11 +0200, Peter Zijlstra wrote:
>>> +       if (event->hw.extra_reg.idx == EXTRA_REG_RSP_0) {
>>> +               event->attr.config = 0x01bb;
>>> +               event->hw.extra_reg.idx = EXTRA_REG_RSP_1;
>>> +               event->hw.extra_reg.msr = MSR_OFFCORE_RSP_1;
>>> +       } else if (event->hw.extra_reg.idx == EXTRA_REG_RSP_1) {
>>> +               event->attr.config = 0x01b7;
>>> +               event->hw.extra_reg.idx = EXTRA_REG_RSP_0;
>>> +               event->hw.extra_reg.msr = MSR_OFFCORE_RSP_0;
>>> +       }
>>
>> clearly I meant to write:
>>
>> event->hw.config &= ~X86_RAW_EVENT_MASK;

Not quite, you want INTEL_ARCH_EVENT_MASK instead
because you only want to modify umask+event code.

There is a major issue as it stands, though. You can
get into an infinite loop bouncing between RSP_0 and RSP_1
in case there is no solution in the group, i.e., you have 3 values
for the extra MSR. I think you need to count the number of times
you've called intel_try_alt_er() with success or maintain some sort
of bitmask of possible alternate choices and when you exhaust that,
you simply fail.
