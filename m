Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702Ab1JKHr7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 03:47:59 -0400
Received: from smtp-out.google.com ([74.125.121.67]:10648 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984Ab1JKHr4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 03:47:56 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=xNR1HL9C45SEjxLI342jeuKmxd3LG6JOidVjluT3zo6nJiF/fLFTGmSwOCjo7AZUx
	7FPFI6w7YGnP9WNkznEFQ==
MIME-Version: 1.0
In-Reply-To: <1318319095.14400.54.camel@laptop>
References: <20111007204247.GA5444@mgebm.net>
	<20111010233842.GC24583@mgebm.net>
	<1318319095.14400.54.camel@laptop>
Date: Tue, 11 Oct 2011 09:47:52 +0200
Message-ID: <CABPqkBRs7iZr8pQB19Q2Gw45ntKUumE76v4K=nmXf_+wbBDY6Q@mail.gmail.com>
Subject: Re: Oprofile Regression Caused by commit e5d1367f17ba6a6fed5fd8b74e4d5720923e0c25
 on PPC
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Eric B Munson <emunson@mgebm.net>, mingo@elte.hu, anton@samba.org,
        linux-kernel@vger.kernel.org, paulus@samba.org, hbabu@us.ibm.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 11, 2011 at 9:44 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Mon, 2011-10-10 at 19:38 -0400, Eric B Munson wrote:
>> On Fri, 07 Oct 2011, Eric B Munson wrote:
>>
>> > This commit seems to have caused a regression with oprofile.  It is fairly easy
>> > to trigger, simply run oprofile monitoring an event that will fire (something
>> > frequent like CPU cycles) causes oprofile to fail saying that the PMU is in use.
>> > If I disable CONFIG_CGROUP_PERF, everything goes back to working.  I suspect the
>> > problem is that the PMU is being initialized without being reserved for perf.  I
>> > am not yet sure of the right fix yet so if you have any suggestions I would
>> > appreciate them.
>> >
>> > Eric
>>
>> This isn't the best description of the behavior we see, what happens is at some
>> point in the profiling session the MMCR register is clobbered by
>> perf_cgroup_switch() which calls perf_pmu_enable() without reserving the PMC
>> hardware.  When this happens oprofile stops counting.  It doesn't happen each
>> time so some runs show event counts that are reasonable, but it can also lead to
>> event counts that are smaller than expected, or completely missing.
>
> What kernel are you testing?
>
Looking at 3.1-rc9, I doubt it's coming from perf_cgroup_switch(). The function
is checking for perf context with at least of cgroup event before
calling perf_pmu_disable().
If there is no active perf context, there is no cgroup event, thus the
function is a nop.
Even if you have a competing perf session, it would have to have at
least one cgroup
event for this code to touch HW. The problem must come from somewhere else.

>
