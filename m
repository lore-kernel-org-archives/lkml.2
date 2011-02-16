Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758871Ab1BPKQF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 05:16:05 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:52965 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754055Ab1BPKQB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 05:16:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=YXZI75zZx4c+LN2ZugfaU2Hqz4ffn173dzumIIvC1tmqYPPJ5G38kcnNFpw5hh3+r5
         qv0iotgY+c/nj1NEfkf1K+6BJa3W8MWtY8rYIsdO5AuQSTgmmr7Rf2lC9qg9Kf5SzotK
         sCItzSGIFxNFgvX8po5aEhwPmU85h0vZVYem4=
MIME-Version: 1.0
In-Reply-To: <20110215215604.GA3177@ele.uri.edu>
References: <4D59B891.8010300@zytor.com>
	<AANLkTimp9xKbZdDZpONrxDkfMSAiQre0v=SOsJUnnoWA@mail.gmail.com>
	<20110215211123.GA3094@ele.uri.edu>
	<20110215.132702.39199169.davem@davemloft.net>
	<20110215215604.GA3177@ele.uri.edu>
Date: Wed, 16 Feb 2011 10:15:56 +0000
Message-ID: <AANLkTikXy+AJ3tdEkEN--xJPefbXJ4-OVS3cg6R7yXzc@mail.gmail.com>
Subject: Re: [PATCH 0/2] jump label: 2.6.38 updates
From: Will Newton <will.newton@gmail.com>
To: Will Simoneau <simoneau@ele.uri.edu>
Cc: David Miller <davem@davemloft.net>, hpa@zytor.com, matt@console-pimps.org,
        rostedt@goodmis.org, peterz@infradead.org, jbaron@redhat.com,
        mathieu.desnoyers@polymtl.ca, mingo@elte.hu, tglx@linutronix.de,
        andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com, avi@redhat.com,
        sam@ravnborg.org, ddaney@caviumnetworks.com, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org, vapier@gentoo.org, cmetcalf@tilera.com,
        dhowells@redhat.com, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        benh@kernel.crashing.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 15, 2011 at 9:56 PM, Will Simoneau <simoneau@ele.uri.edu> wrote:
> On 13:27 Tue 15 Feb     , David Miller wrote:
>> From: Will Simoneau <simoneau@ele.uri.edu>
>> Date: Tue, 15 Feb 2011 16:11:23 -0500
>>
>> > Note how the cache and cache coherence protocol are fundamental parts of this
>> > operation; if these instructions simply bypassed the cache, they *could not*
>> > work correctly - how do you detect when the underlying memory has been
>> > modified?
>>
>> The issue here isn't L2 cache bypassing, it's local L1 cache bypassing.
>>
>> The chips in question aparently do not consult the local L1 cache on
>> "ll" instructions.
>>
>> Therefore you must only ever access such atomic data using "ll"
>> instructions.
>
> (I should not have said "underlying memory", since it is correct that
> only the L1 caches are the problem here)
>
> That's some really crippled hardware... it does seem like *any* loads
> from *any* address updated by an sc would have to be done with ll as
> well, else they may load stale values. One could work this into
> atomic_read(), but surely there are other places that are problems.

I think it's actually ok, atomics have arch implemented accessors, as
do spinlocks and atomic bitops. Those are the only place we do sc so
we can make sure we always ll or invalidate manually.

> It would be OK if the caches on the hardware in question were to
> back-invalidate matching cachelines when the sc is snooped from the bus,
> but it sounds like this doesn't happen?

Yes it's possible to manually invalidate the line but it is not
automatic. Manual invalidation is actually quite reasonable in many
cases because you never see a bad value, just a potentially stale one,
so many of the races are harmless in practice.

I think you're correct in your comments re multi-processor cache
coherence and the performance problems associated with not doing ll/sc
in the cache. I believe some of the reasoning behind the current
implementation is to allow different processors in the same SoC to
participate in the atomic store protocol without having a fully
coherent cache (and implementing a full cache coherence protocol).
It's my understanding that the ll/sc is implemented somewhere beyond
the cache in the bus fabric.
