Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770Ab1JZHWS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 03:22:18 -0400
Received: from smtp-out.google.com ([216.239.44.51]:30607 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754306Ab1JZHWQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 03:22:16 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:sender:in-reply-to:references:date:
	x-google-sender-auth:message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=CE2d3RaaBuS+Nkkr7S/qILkXRh9jjWcK6WumENzgpeaUWwIIpF1OynAnYbHRqyyJ8
	Y6kpqpOymK3IuWs+OLInQ==
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1110260006470.23227@chino.kir.corp.google.com>
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
	<CAMbhsRR0z-aJ848gq6ZQATZOgz=EybVsRtaQbjCr42PtCubCzw@mail.gmail.com>
	<alpine.DEB.2.00.1110252347330.20273@chino.kir.corp.google.com>
	<CAMbhsRScgfokDOiT7c9RbmqC7E_ZXrwLEYXE7JZWFGoePjAXvg@mail.gmail.com>
	<alpine.DEB.2.00.1110260006470.23227@chino.kir.corp.google.com>
Date: Wed, 26 Oct 2011 00:22:14 -0700
X-Google-Sender-Auth: EmyXQVypg7K_KLZ3umCKfUFvRUc
Message-ID: <CAMbhsRRZBUcfv5kT4aYm=Z3+kc-usYJVqyc_+1gAEy-4yH_nPQ@mail.gmail.com>
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

On Wed, Oct 26, 2011 at 12:10 AM, David Rientjes <rientjes@google.com> wrote:
> On Tue, 25 Oct 2011, Colin Cross wrote:
>
>> > gfp_allowed_mask is initialized to GFP_BOOT_MASK to start so that __GFP_FS
>> > is never allowed before the slab allocator is completely initialized, so
>> > you've now implicitly made all early boot allocations to be __GFP_NORETRY
>> > even though they may not pass it.
>>
>> Only before interrupts are enabled, and then isn't it vulnerable to
>> the same livelock?  Interrupts are off, single cpu, kswapd can't run.
>> If an allocation ever failed, which seems unlikely, why would retrying
>> help?
>>
>
> If you want to claim gfp_allowed_mask as a pm-only entity, then I see no
> problem with this approach.  However, if gfp_allowed_mask would be allowed
> to temporarily change after init for another purpose then it would make
> sense to retry because another allocation with __GFP_FS on another cpu or
> kswapd could start making progress could allow for future memory freeing.
>
> The suggestion to add a hook directly into a pm-interface was so that we
> could isolate it only to suspend and, to me, is the most maintainable
> solution.
>

pm_restrict_gfp_mask seems to claim gfp_allowed_mask as owned by pm at runtime:
"gfp_allowed_mask also should only be modified with pm_mutex held,
unless the suspend/hibernate code is guaranteed not to run in parallel
with that modification"

I think we've wrapped around to Mel's original patch, which adds a
pm_suspending() helper that is implemented next to
pm_restrict_gfp_mask.  His patch puts the check inside
!did_some_progress instead of should_alloc_retry, which I prefer as it
at least keeps trying until reclaim isn't working.  Pekka was trying
to avoid adding pm-specific checks into the allocator, which is why I
stuck to the symptom (__GFP_FS is clear) rather than the cause (PM).
