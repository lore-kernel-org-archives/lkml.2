Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556Ab0IMSkX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 14:40:23 -0400
Received: from smtp-out.google.com ([74.125.121.35]:51956 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752948Ab0IMSkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 14:40:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=g/35y6nZOPNM8wiALuUBD5jWLvfEt7ne5k1l+1moS3e5jwg00XB7StvY2JDuoJRflF
         CNDkDSa1+p8AMIsCpcEw==
MIME-Version: 1.0
In-Reply-To: <1284399329.2275.387.camel@laptop>
References: <4c8e3c0c.12d1d80a.73d9.ffffcf21@mx.google.com>
	<20100913150914.GA6155@nowhere>
	<AANLkTi=OR69sDbUMkSnx_-bpF=yHF_xNY1v=-BJgLpp5@mail.gmail.com>
	<1284391000.2275.338.camel@laptop>
	<AANLkTin35TXPcs9u3pLfo8QRUmGnftT1DPfswRUVEvJW@mail.gmail.com>
	<1284391480.2275.350.camel@laptop>
	<AANLkTik8r4moPy5muNyT2oKGH5aEaMOLL0Zqn=-hkpos@mail.gmail.com>
	<1284392476.2275.369.camel@laptop>
	<AANLkTimZTzCjea3KFxGcaQ7kscod7sOrz13LkNF_u38w@mail.gmail.com>
	<1284399329.2275.387.camel@laptop>
Date: Mon, 13 Sep 2010 20:40:16 +0200
Message-ID: <AANLkTi=DGnP-r++PhzWFMdwdu_ReUKAmGLCA2zPNBG5J@mail.gmail.com>
Subject: Re: [PATCH] perf_events: improve DS/BTS/PEBS buffer allocation
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
        davem@davemloft.net, perfmon2-devel@lists.sf.net, eranian@gmail.com,
        robert.richter@amd.com,
        "markus.t.metzger" <markus.t.metzger@intel.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 13, 2010 at 7:35 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2010-09-13 at 17:55 +0200, Stephane Eranian wrote:
>>
>> Ok, so you're saying there is no allocator that will give non-contiguous
>> physical memory WITHOUT requiring a page fault to populate the pte.
>>
>> On the other hand, with vmalloc_node() the pte are populated when
>> you first touch the memory. That happens as part of memset() right after
>> the allocation and thus outside of NMI interrupt handler.
>>
>> Does this sound right?
>
> Nope, in particular read: http://lkml.org/lkml/2010/7/14/465
>
> The issue is that the vmalloc space can be mapped in different
> processes, and that memset() will only ensure its mapped in the current
> process, but the next one might need that fault to populate.
>
Ok, so can we play the same trick you're playing with the sampling
buffer, i.e., you use alloc_pages_node() for one page at a time, and
then you stitch them on demand via SW?
