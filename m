Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757366Ab0KLV0k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 16:26:40 -0500
Received: from smtp-out.google.com ([216.239.44.51]:46311 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757059Ab0KLV0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 16:26:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=L9WFscyx+m4F2WPtu6zDaX4aZ7MHeNGFoLagHMHyzDLGZKjZ7CM8ilcVpet0h6GkEX
         Flsrq4dJbdN5Tfm0uNKg==
MIME-Version: 1.0
In-Reply-To: <1289583192.2084.339.camel@laptop>
References: <1289580941-29744-1-git-send-email-andi@firstfloor.org>
	<AANLkTimJ3nLwmRfmf+uTuUvg6HVrHBzrjgQXuTi5dxyp@mail.gmail.com>
	<1289583192.2084.339.camel@laptop>
Date: Fri, 12 Nov 2010 22:26:36 +0100
Message-ID: <AANLkTimpw=Y+JX3vD=Q-AMvDJC8Y=zHQ3DDoqGm8WKe9@mail.gmail.com>
Subject: Re: [PATCH 1/2] perf-events: Add support for supplementary event
 registers v2
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu, fweisbec@gmail.com,
        Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 12, 2010 at 6:33 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Fri, 2010-11-12 at 18:17 +0100, Stephane Eranian wrote:
>> I looked at this patch thinking how could this be reused for LBR_SELECT.
>>
>> I am wondering if storing the extra MSR value in attr.config is really the way
>> to go now as opposed to adding/overloading a field.
>>
>> For OFFCORE_RESPONSE, it makes sense to use attr.config because this is
>> a refinement of the event (a sub-sub event if you want).
>
> Correct, it makes sense for offcore and load-latency, not so much for
> lbr_config.
>
Good.

>> For LBR_SELECT, you also need to pass a value, but there is no specific event
>> associated with it. You can enable LBR with any event you want. Thus,
>> storing the
>> LBR_SELECT value independently would also make sense. And if we have this
>> field for LBR_SELECT then we may as well use it for OFFCORE_REPONSE.
>
> That would assume a single event doesn't contain offcore and lbr, no?
> Currently the extra_reg thing assumes there's only one extra reg encoded
> in the config word.
>
Good point. You want to allow simultaneous LBR + OFFCORE, i.e., to figure
out the path that led to the event (with some skid). So those need to be in
separate fields. I would go with offcore in attr.config, lbr somewhere else.
If you do this then you have the issue of how generic in the content of that
extra field.


>> The alternative would be to consider LBR_SELECT also as a refinement of
>> the event being measured. Though by itself, it wouldn't do anything, it would
>> have to be combine with a PERF_SAMPLE_BRANCH_STACK to attr.sample_type.
>
> A separate field for the lbr_config seems to make most sense, we could
> of course use the top 16 bits for lbr, the next 16 for offcore/ll and
> the bottom 32 for eventsel, but that's mighty crowded.
>
Agreed, not such a good idea. I like the separate lbr_config better.
Could be made
more generic, e.g., branch_stack_config. This is how you've named LBR in the
generic code currently.
