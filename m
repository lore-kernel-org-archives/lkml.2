Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752031Ab0IBINX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 04:13:23 -0400
Received: from smtp-out.google.com ([216.239.44.51]:13938 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205Ab0IBINV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 04:13:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rkJ1b4vZahdBVsEKXLugq6D0eI+hHqRDc0hkdo71wKylgjG1fE+EcDqhWSzUBHL4FT
         0pp+pkoy3ZcxBb3oW1sg==
MIME-Version: 1.0
In-Reply-To: <20100901145728.GM22783@erda.amd.com>
References: <AANLkTimA-AZWJugaLR3VPGVhBaJid=t=a1rPVNUE_8Dh@mail.gmail.com>
	<20100901145728.GM22783@erda.amd.com>
Date: Thu, 2 Sep 2010 10:13:19 +0200
Message-ID: <AANLkTikOaCL8FqQuUQsYPxm19WZOdarp8AMAugN0mnqQ@mail.gmail.com>
Subject: Re: [PATCH 4/4] [x86] perf: fix accidentally ack'ing a second event
 on intel perf counter
From: Stephane Eranian <eranian@google.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Don Zickus <dzickus@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert,

Do you have the test program you used to test this?
I believe the NHM hack does not solve the problem, it
just makes it harder to appear.

I suspect the real issue is that the GLOBAL_STATUS
bitmask cannot be trusted. I'd like to verify this.

Has the problem appear only on Nehalem or also on
Westmere?


On Wed, Sep 1, 2010 at 4:57 PM, Robert Richter <robert.richter@amd.com> wrote:
> On 01.09.10 09:04:45, Stephane Eranian wrote:
>> Don,
>>
>> Found your patch on LKML (I am not on it).
>>
>> In your changelog you said:
>>
>> > During testing of a patch to stop having the perf subsytem swallow nmis,
>> > it was uncovered that Nehalem boxes were randomly getting unknown nmis
>> > when using the perf tool.
>> >
>> > Moving the ack'ing of the PMI closer to when we get the status allows
>> > the hardware to properly re-set the PMU bit signaling another PMI was
>> > triggered during the processing of the first PMI.  This allows the new
>> > logic for dealing with the shortcomings of multiple PMIs to handle the
>> > extra NMI by 'eat'ing it later.
>>
>> > Now one can wonder why are we getting a second PMI when we disable all
>> > the PMUs in the beginning of the NMI handler to prevent such a case, for
>> > that I do not know.  But I know the fix below helps deal with this quirk.
>> >
>>
>> I am assuming you're talking about back-to-back NMIs here, not nested NMIs.
>> I don't quite understand the scenario here. Is it the case that you handled 1
>> overflow, and then right as you return from the interrupt, you get a second
>> PMI with a ovfl_status=0 ?
>>
>> What events did you measure? Which counters did you use?
>> Did you have HT turned on?
>
> It is related to this thread:
>
>  http://lkml.org/lkml/2010/8/25/124
>
> Not acking the status immediately triggered an nmi, but the status was
> 0. Acking after reading and before processing the counters results in
> a non-zero status and thus, no empty nmi.
>
> -Robert
>
>>
>> > Tested on multiple Nehalems where the problem was occuring.  With the
>> > patch, the code now loops a second time to handle the second PMI (whereas
>> > before it was not).
>>
>
> --
> Advanced Micro Devices, Inc.
> Operating System Research Center
>
>
