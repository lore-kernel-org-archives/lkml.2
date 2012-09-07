Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752249Ab2IGRDd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 13:03:33 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:38237 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750980Ab2IGRDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 13:03:30 -0400
MIME-Version: 1.0
In-Reply-To: <1347032350.18408.88.camel@twins>
References: <1347028169-1983-1-git-send-email-eranian@google.com>
	<1347028169-1983-2-git-send-email-eranian@google.com>
	<1347032350.18408.88.camel@twins>
Date: Fri, 7 Sep 2012 19:03:28 +0200
Message-ID: <CABPqkBT=2H5WuWZ+uFq39XTTxniVvT6tEuaYDHvaV2VSbjBPDQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] perf: use hrtimer for event multiplexing
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, ak@linux.intel.com,
        zheng.z.yan@intel.com, robert.richter@amd.com
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 7, 2012 at 5:39 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, 2012-09-07 at 16:29 +0200, Stephane Eranian wrote:
>> @@ -148,6 +148,15 @@ static LIST_HEAD(pmus);
>>  static DEFINE_MUTEX(pmus_lock);
>>  static struct srcu_struct pmus_srcu;
>>
>> +struct perf_cpu_hrtimer {
>> +       struct hrtimer hrtimer;
>> +       int active;
>> +};
>> +
>> +static DEFINE_PER_CPU(struct list_head, rotation_list);
>> +
>> +static DEFINE_PER_CPU(struct perf_cpu_hrtimer, perf_cpu_hrtimer);
>
>
> How about sticking the hrtimer in perf_cpu_context so you can have a
> different rotation interval per PMU ?
>
I think having different intervals would be a good thing, especially for uncore.
But now, I am wondering how this could work without too much overhead.
Looks like you're suggesting arming multiple hrtimers if multiple PMU are
overcommitted. Is that right? As opposed to having a PMU multiplier off of a
single per-cpu hrtimer.

> Sorta like e9d2b064149ff7ef4acbc65a1b9374ac8b218d3e removed. Stopping
> the timer when the PMU isn't over committed should solve the NOHZ
> problem I think.

Yeah, my patch does solve this. That's what I show in my example in the intro
msg.
