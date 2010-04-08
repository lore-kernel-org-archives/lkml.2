Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759153Ab0DHV3h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 17:29:37 -0400
Received: from smtp-out.google.com ([74.125.121.35]:37116 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759076Ab0DHV3g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 17:29:36 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=jj2eZUbotOfrISIvJ3IxNDqMNOmNiAHCIVTtId4AyA8cWfa03fBeACQFOyAmwtkRQ
	0RtAha0COer47NQVnBPxg==
MIME-Version: 1.0
In-Reply-To: <1270761341.20295.3160.camel@laptop>
References: <4bbe4175.5124cc0a.5bd3.22d6@mx.google.com>
	 <1270760136.20295.3121.camel@laptop>
	 <v2xbd4cb8901004081408mf761d04ag5a365d068c58d64b@mail.gmail.com>
	 <1270761341.20295.3160.camel@laptop>
Date: Thu, 8 Apr 2010 23:29:31 +0200
Message-ID: <g2ubd4cb8901004081429qc0386d6ftac5fed296920d05@mail.gmail.com>
Subject: Re: [PATCH] perf_events: fix bogus warn_on(_once) in 
	perf_prepare_sample()
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
       davem@davemloft.net, fweisbec@gmail.com, robert.richter@amd.com,
       perfmon2-devel@lists.sf.net, eranian@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 8, 2010 at 11:15 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, 2010-04-08 at 23:08 +0200, Stephane Eranian wrote:
>> On Thu, Apr 8, 2010 at 10:55 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>> > On Thu, 2010-04-08 at 22:45 +0200, Stephane Eranian wrote:
>> >>       There is a warn_on_once() check for PERF_SAMPLE_RAW which trips
>> >>       when using PEBS on both Core and Nehalem. Core PEBS sample size is 144
>> >>       bytes and 176 bytes for Nehalem. Both are multiples of 8, but the size
>> >>       field is encoded as int, thus the total is never a multiple of 8 which
>> >>       trips the check. I think the size should have been u64, but now it is
>> >>       too late to change given it is ABI.
>> >
>> > PEBS hasn't seen -linus yet, so we can fix that.
>> >
>> Are you suggesting you add some padding the PEBS raw sample you
>> return as PERF_SAMPLE_RAW? Then you need to define what RAW
>> actually means? Seems here, it would mean more than what the
>> HW returns.
>
> The best fix here is to simply remove the PERF_SAMPLE_RAW support and
> implement PERF_SAMPLE_REGS. Its just that we need to come up with a way
> to deal with compat pt_regs muck.
>
>
But isn't RAW already part of the ABI?

It is true that you need to also provide the interrupted state (or
part of it) to the user, i.e.,
beyond just the IP.

But the interrupt state and PEBS state are distinct and should not be
swapped. In fact,
both may be useful at the same time to evaluate the skid.

So yes, you need PERF_SAMPLE_REGS. But just like your proposal with the two IPs.
I think you need to export two versions of REGS: IREGS and PREGS for
instance. The
issue is that PEBS does not record the whole state but only a very small subset.

Then, on Nehalem, there is PEBS more where you collect more that just
machine state,
you collect cache miss information. That's not regs anymore.
