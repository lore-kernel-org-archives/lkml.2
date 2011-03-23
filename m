Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046Ab1CWMsM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 08:48:12 -0400
Received: from smtp-out.google.com ([216.239.44.51]:5125 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755478Ab1CWMsL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 08:48:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=bB92JzBV1GFGVZ2VT2vSw5H7LtFNkDZrE6SHMmpBtptzb11scEM7Uu4tMrYP+uHq1I
         HdheJfzsNLvJE+hfPS9A==
MIME-Version: 1.0
In-Reply-To: <20110323113601.GA27809@elte.hu>
References: <20110321151126.GA5084@quad>
	<20110323113601.GA27809@elte.hu>
Date: Wed, 23 Mar 2011 13:47:19 +0100
Message-ID: <AANLkTimC6MqioV=6Ry=xvL9m4NeAEmZbkoOGQZ+66Duc@mail.gmail.com>
Subject: Re: [PATCH] perf_events: fix cgrp stale pointer in update_cgrp_time_from_cpuctx()
From: Stephane Eranian <eranian@google.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org,
        perfmon2-devel@lists.sf.net, paulus@samba.org, davem@davemloft.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 23, 2011 at 12:36 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Stephane Eranian <eranian@google.com> wrote:
>
>> -     if (is_cgroup_event(event))
>> +     if (is_cgroup_event(event)) {
>>               ctx->nr_cgroups--;
>> +             cpuctx = __get_cpu_context(ctx);
>> +             /*
>> +              * if there are no more cgroup events
>> +              * then clear cgrp to avoid stale pointer
>> +              * in update_cgrp_time_from_cpuctx()
>> +              */
>> +             if (!ctx->nr_cgroups)
>> +                     cpuctx->cgrp = NULL;
>> +     }
>
> The ->cgrp pointer does not exist on !CGROUPS kernels. I suspect the cleanest
> approach would be to make those two cgrp fields available unconditionally in
> struct perf_event.
>
Argh, I forgot to test !CGROUP.
I tend to agree with you on making those fields unconditional. We
don't save that
much by not doing it.

> Thanks,
>
>        Ingo
>
