Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686Ab0IMPVg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 11:21:36 -0400
Received: from smtp-out.google.com ([74.125.121.35]:60079 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920Ab0IMPVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 11:21:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=IK/9Jdv5oSOgXiEIxLgmkroEfARXA39hWCbzzx0TjWb+oegPKAcXbqtOqswn1VpWI8
         +HT02+UdawGvj4X8zoNw==
MIME-Version: 1.0
In-Reply-To: <1284390530.2275.327.camel@laptop>
References: <4c8e3c0c.12d1d80a.73d9.ffffcf21@mx.google.com>
	<1284390530.2275.327.camel@laptop>
Date: Mon, 13 Sep 2010 17:21:31 +0200
Message-ID: <AANLkTikV-RVd0ZUi97TLSeHAUKwmtoCP=fgB=GJJMxWz@mail.gmail.com>
Subject: Re: [PATCH] perf_events: improve DS/BTS/PEBS buffer allocation
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
        davem@davemloft.net, fweisbec@gmail.com, perfmon2-devel@lists.sf.net,
        eranian@gmail.com, robert.richter@amd.com, markus.t.metzger@intel.com
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 13, 2010 at 5:08 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2010-09-13 at 16:55 +0200, Stephane Eranian wrote:
>> The DS, BTS, and PEBS memory regions were allocated using kzalloc(), i.e.,
>> requesting contiguous physical memory. There is no such restriction on
>> DS, PEBS and BTS buffers. Using kzalloc() could lead to error in case
>> no contiguous physical memory is available. BTS is requesting 64KB,
>> thus it can cause issues. PEBS is currently only requesting one page.
>> Both PEBS and BTS are static buffers allocated for each CPU at the
>> first user. When the last user exists, the buffers are released.
>>
>> All buffers are only accessed on the CPU they are attached to.
>> kzalloc() does not take into account NUMA, thus all allocations
>> are taking place on the NUMA node where the perf_event_open() is
>> made.
>
> I guess that should have been a alloc_pages_node() indeed.
>
>> This patch switches allocation to vmalloc_node() to use non-contiguous
>> physical memory and to allocate on the NUMA node corresponding to each
>> CPU. We switched DS and PEBS although they do not cause problems today,
>> to, at least, make the allocation on the correct NUMA node. In the future,
>> the PEBS buffer size may increase. DS may also grow bigger than a page.
>> This patch eliminates the memory allocation imbalance.
>
> I'm not really a fan of vmalloc, have you actually observed allocation
> failures for these 64k (order-4) allocations?
>
I did with small amount of memory in containers, after stressing
the system with perf for instance.

>
>
