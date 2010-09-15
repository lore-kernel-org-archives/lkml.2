Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730Ab0IOQr5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 12:47:57 -0400
Received: from smtp-out.google.com ([74.125.121.35]:19912 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744Ab0IOQr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 12:47:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=m10V0BQ9os4ONy1ppnXryMZMGzJJU3bnlX0Yk5xWruEyFWdjT9DcNg6HBa+pM4onHg
         WAnM9N+YXcpSns0URUWw==
MIME-Version: 1.0
In-Reply-To: <20100915164610.GA5959@lenovo>
References: <20100910132741.GB4879@redhat.com>
	<20100910144634.GA1060@elte.hu>
	<20100910155659.GD13563@erda.amd.com>
	<20100911094157.GA11521@elte.hu>
	<20100911114404.GE13563@erda.amd.com>
	<20100911124537.GA22850@elte.hu>
	<20100912095202.GF13563@erda.amd.com>
	<20100913143713.GK13563@erda.amd.com>
	<20100914174132.GN13563@erda.amd.com>
	<20100915162034.GO13563@erda.amd.com>
	<20100915164610.GA5959@lenovo>
Date: Wed, 15 Sep 2010 18:47:51 +0200
Message-ID: <AANLkTim5knbg8GdUAYyx_i5WQUwnez8tHkU1SfiJJ+L7@mail.gmail.com>
Subject: Re: [PATCH] perf, x86: catch spurious interrupts after disabling counters
From: Stephane Eranian <eranian@google.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Robert Richter <robert.richter@amd.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, Don Zickus <dzickus@redhat.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ying.huang@intel.com" <ying.huang@intel.com>,
        "ming.m.lin@intel.com" <ming.m.lin@intel.com>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "andi@firstfloor.org" <andi@firstfloor.org>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 15, 2010 at 6:46 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> On Wed, Sep 15, 2010 at 06:20:34PM +0200, Robert Richter wrote:
>> On 14.09.10 19:41:32, Robert Richter wrote:
>> > I found the reason why we get the unknown nmi. For some reason
>> > cpuc->active_mask in x86_pmu_handle_irq() is zero. Thus, no counters
>> > are handled when we get an nmi. It seems there is somewhere a race
>> > accessing the active_mask. So far I don't have a fix available.
>> > Changing x86_pmu_stop() did not help:
>>
>> The patch below for tip/perf/urgent fixes this.
>>
>> -Robert
>>
>> From 4206a086f5b37efc1b4d94f1d90b55802b299ca0 Mon Sep 17 00:00:00 2001
>> From: Robert Richter <robert.richter@amd.com>
>> Date: Wed, 15 Sep 2010 16:12:59 +0200
>> Subject: [PATCH] perf, x86: catch spurious interrupts after disabling counters
>>
>> Some cpus still deliver spurious interrupts after disabling a counter.
>> This caused 'undelivered NMI' messages. This patch fixes this.
>>
>> Signed-off-by: Robert Richter <robert.richter@amd.com>
>> ---
> ...
>
> Hi Robert, thanks a lot for tracking this issue! I might be missing
> something but why don't you clean this ->running mask bits on pmu-stop?
> What if counter gets disabled/freed or whatever before issue any nmis?
> Another question I have still -- is this an hardware issue in general?
>
what's for sure, is that you can have an interrupt in flight by the time
you disable.
