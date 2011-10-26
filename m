Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752012Ab1JZGgu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 02:36:50 -0400
Received: from smtp-out.google.com ([216.239.44.51]:17321 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402Ab1JZGgt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 02:36:49 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:sender:in-reply-to:references:date:
	x-google-sender-auth:message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=V6fXzcwcbhWjLLd54dRsKHSh5dCQJ+xX6zADrBI11+dN6wQhrNoIsJvlhKX9MV3P8
	wqprLd1GWnlT1QLJdZVhQ==
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1110252327270.20273@chino.kir.corp.google.com>
References: <1319524789-22818-1-git-send-email-ccross@android.com>
	<20111025090956.GA10797@suse.de>
	<alpine.DEB.2.00.1110251513520.26017@chino.kir.corp.google.com>
	<CAMbhsRQ3y2SBwEfjiYgfxz2-h0fgn20mLBYgFuBwGqon0f-a8g@mail.gmail.com>
	<alpine.DEB.2.00.1110252244270.18661@chino.kir.corp.google.com>
	<alpine.DEB.2.00.1110252311030.20273@chino.kir.corp.google.com>
	<CAMbhsRS+-jn7d1bTd4F0_RB9860iWjOHLfOkDsqLfWEUbR3TYA@mail.gmail.com>
	<alpine.DEB.2.00.1110252322220.20273@chino.kir.corp.google.com>
	<CAMbhsRQdrWRLkj7U-u2AZxM11mSUNj5_1K27g58cMBo1Js1Yeg@mail.gmail.com>
	<alpine.DEB.2.00.1110252327270.20273@chino.kir.corp.google.com>
Date: Tue, 25 Oct 2011 23:36:44 -0700
X-Google-Sender-Auth: XxgmYGKJ18Vkb5zqF26Kg_l5D6M
Message-ID: <CAMbhsRR0z-aJ848gq6ZQATZOgz=EybVsRtaQbjCr42PtCubCzw@mail.gmail.com>
Subject: Re: [PATCH] mm: avoid livelock on !__GFP_FS allocations
From: Colin Cross <ccross@android.com>
To: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mgorman@suse.de>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 25, 2011 at 11:33 PM, David Rientjes <rientjes@google.com> wrote:
> On Tue, 25 Oct 2011, Colin Cross wrote:
>
>> Makes sense.  What about this?  Official patch to follow.
>>
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index fef8dc3..59cd4ff 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -1786,6 +1786,13 @@ should_alloc_retry(gfp_t gfp_mask, unsigned int order,
>>                 return 0;
>>
>>         /*
>> +        * If PM has disabled I/O, OOM is disabled and reclaim is unlikely
>> +        * to make any progress.  To prevent a livelock, don't retry.
>> +        */
>> +       if (!(gfp_allowed_mask & __GFP_FS))
>> +               return 0;
>> +
>> +       /*
>>          * In this implementation, order <= PAGE_ALLOC_COSTLY_ORDER
>>          * means __GFP_NOFAIL, but that may not be true in other
>>          * implementations.
>
> Eek, this is precisely what we don't want and is functionally the same as
> what you initially proposed except it doesn't care about __GFP_NOFAIL.

This is checking against gfp_allowed_mask, not gfp_mask.

> You're trying to address a suspend issue where nothing on the system can
> logically make progress because __GFP_FS seriously restricts the ability
> of reclaim to do anything useful if it doesn't succeed the first time and
> kswapd isn't effective.  That's why I suggested a hook into
> pm_restrict_gfp_mask() to set a variable and then treat it exactly as
> __GFP_NORETRY in should_alloc_retry().
>
> Consider if nobody is using suspend and they are allocating with GFP_NOFS.
> There's potentially a lot of candidates:
>
>        $ grep -r GFP_NOFS * | wc -l
>        1016
>
> and now we've just introduced a regression where the allocation would
> eventually succeed because of either kswapd, a backing device that is no
> longer congested, or an allocation on another cpu in a context where
> direct reclaim can be more aggressive or the oom killer can at least free
> some memory.
>
> So you definitely want to localize your change to only suspend and
> pm_restrict_gfp_mask() is a very easy way to do it.  So I'd suggest adding
> a static bool that can be tested in should_alloc_retry() and identify such
> situations and tag it as __read_mostly.
>
