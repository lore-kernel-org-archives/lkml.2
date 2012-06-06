Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153Ab2FFOd4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 10:33:56 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:57098 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753452Ab2FFOdz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 10:33:55 -0400
MIME-Version: 1.0
In-Reply-To: <1338992472.2749.116.camel@twins>
References: <1338944211-28275-1-git-send-email-andi@firstfloor.org>
	<1338944211-28275-5-git-send-email-andi@firstfloor.org>
	<1338979579.2749.95.camel@twins>
	<20120606141644.GF28225@tassilo.jf.intel.com>
	<1338992472.2749.116.camel@twins>
Date: Wed, 6 Jun 2012 16:33:53 +0200
Message-ID: <CABPqkBQ7xwK+BjYainpxXV+D_KjMgH0KFVhYK9w89TxqQOF_MQ@mail.gmail.com>
Subject: Re: [PATCH 5/5] perf, x86: Prefer RDPMC over RDMSR for reading counters
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andi Kleen <ak@linux.intel.com>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 6, 2012 at 4:21 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Wed, 2012-06-06 at 07:16 -0700, Andi Kleen wrote:
>> On Wed, Jun 06, 2012 at 12:46:19PM +0200, Peter Zijlstra wrote:
>> > On Tue, 2012-06-05 at 17:56 -0700, Andi Kleen wrote:
>> > > From: Andi Kleen <ak@linux.intel.com>
>> > >
>> > > RDPMC is much faster than RDMSR for reading performance counters,
>> > > since it's not serializing.  Use it if possible in the perf handler.
>> > >
>> > > Only tested on Sandy Bridge, so I only enabled it there so far.
>> >
>> > That's just stupid.. I took Vince's patch from a while back.
>>
>> What do you mean? It's significantly faster to read the counters this
>> way, because it avoids serialization and other overhead.
>
> What I'm saying is you only enabling it for snb and being too lazy to
> test anything else. Nor do I think its worth the conditional, all chips
> we have PMU support for have rdpmc instructions.
>
>> Vince's patch only enabled it for user space I believe, This is for lowering
>> the kernel PMI handler overhead.
>
> No, his patch did the kernel thing. Furthermore he actually tested it on
> a bunch of machines.

Yes, his patch did but somehow I don't see this code in tip-x86.
The thing that I would worry about between rdmsrl() and rdpmc()
is what happens to the upper bits. rdpmc() returns bits [N-1:0] of
the N-bit counters. N is 48 (or 40) nowadays. When you read 64 bit
worth, what do you get in bits [63:N]? are those sign-extended or
zero-extended. Is that the same behavior across all Intel and AMD
processors? With perf_events, I think the (N-1)th bit is always set.
