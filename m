Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451Ab1EWP1V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 11:27:21 -0400
Received: from smtp-out.google.com ([216.239.44.51]:38117 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754929Ab1EWP1U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 11:27:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=UnwOoX3zUsZNIy419oNYKoXcWZPjaNTnpc3lt3S5YsmgWKdK58SFRmIguORNuEJH9z
         wQ7JyFvBl27Rt/XbV5PQ==
MIME-Version: 1.0
In-Reply-To: <1306163700.18455.16.camel@twins>
References: <20110520143707.GA5347@quad>
	<1306141897.18455.8.camel@twins>
	<1306143168.18455.10.camel@twins>
	<BANLkTimVM2XvpJ1d9SbmAh7xZ+qSjukX+A@mail.gmail.com>
	<BANLkTinN92UpxU85r17zB+Khba8k59nJTA@mail.gmail.com>
	<1306149026.18455.11.camel@twins>
	<BANLkTik5v7WGygmZqjbh6_iwJ35S9upReg@mail.gmail.com>
	<1306163700.18455.16.camel@twins>
Date: Mon, 23 May 2011 17:27:17 +0200
Message-ID: <BANLkTimNhkdu_QcJqPjV5QLW8+G8E54jww@mail.gmail.com>
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

On Mon, May 23, 2011 at 5:15 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2011-05-23 at 14:00 +0200, Stephane Eranian wrote:
>> On Mon, May 23, 2011 at 1:10 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>> > On Mon, 2011-05-23 at 12:58 +0200, Stephane Eranian wrote:
>> >> There is a major issue as it stands, though. You can
>> >> get into an infinite loop bouncing between RSP_0 and RSP_1
>> >> in case there is no solution in the group, i.e., you have 3 values
>> >> for the extra MSR. I think you need to count the number of times
>> >> you've called intel_try_alt_er() with success or maintain some sort
>> >> of bitmask of possible alternate choices and when you exhaust that,
>> >> you simply fail.
>> >
>> > That should be sorted by the compare with the initial idx value, no?
>> > Once its back where it started out it'll bail.
>> >
>> Nope.
>>
>> Take:
>>   - ev1=rsp_0:0x1001
>>   - ev2=rsp_0:0x1002
>>   - ev3=rsp_1:0x1008
>>
>> ev1-> rsp_0
>> ev2-> rsp_0, conflict, then try yields rsp_1 -> ok
>> ev3 -> rsp_1, conflict, then rsp_0, but fails, try again -> rsp_1,
>> fails, and so on
>>
>> The issue is that the intel_try() function does not know the
>> history of the swaps between rsp_0, rsp1.
>
> But it does, we pass the initial reg->idx in, and return false when that
> matches the new idx, so in your example, ev3 will do:
>
>     rsp_1 -> conflict,
>  try rsp_0 -> conflict,
>  try rsp_1 -> bail, return emptyconstraint
>
>
Ok, my fault. That's because I tweaked your patch a bit and
I did not keep track of idx. I guess the logic is not obvious.
I think you should rename idx to orig_idx.


>
