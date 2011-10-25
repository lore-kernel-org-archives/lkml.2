Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222Ab1JYRJE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 13:09:04 -0400
Received: from smtp-out.google.com ([216.239.44.51]:15256 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585Ab1JYRJC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 13:09:02 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:sender:in-reply-to:references:date:
	x-google-sender-auth:message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=lIR0daUmltkfPs7fNzD9pwn4mEkH0609Ejkfvi5+8Jo0Dea2LdFn8ykeIT0mYxqVI
	uwWUzy4StExsCDdLV61rw==
MIME-Version: 1.0
In-Reply-To: <20111025112300.GB10797@suse.de>
References: <1319524789-22818-1-git-send-email-ccross@android.com>
	<20111025090956.GA10797@suse.de>
	<CAMbhsRR07Gpv-nEAvq8OQmLxkMyL5cASpq1vqQ8qN5ctwnamsQ@mail.gmail.com>
	<20111025112300.GB10797@suse.de>
Date: Tue, 25 Oct 2011 10:08:58 -0700
X-Google-Sender-Auth: ATcEc9FL-k1pmkGhIef6wjmVxfs
Message-ID: <CAMbhsRTFWoEaWXQi7vKc3XVqDv3qVBVx8Ax5TfncJF8A4Txj_w@mail.gmail.com>
Subject: Re: [PATCH] mm: avoid livelock on !__GFP_FS allocations
From: Colin Cross <ccross@android.com>
To: Mel Gorman <mgorman@suse.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 25, 2011 at 4:23 AM, Mel Gorman <mgorman@suse.de> wrote:
> On Tue, Oct 25, 2011 at 02:26:56AM -0700, Colin Cross wrote:
>> On Tue, Oct 25, 2011 at 2:09 AM, Mel Gorman <mgorman@suse.de> wrote:
>> > On Mon, Oct 24, 2011 at 11:39:49PM -0700, Colin Cross wrote:
>> >> Under the following conditions, __alloc_pages_slowpath can loop
>> >> forever:
>> >> gfp_mask & __GFP_WAIT is true
>> >> gfp_mask & __GFP_FS is false
>> >> reclaim and compaction make no progress
>> >> order <= PAGE_ALLOC_COSTLY_ORDER
>> >>
>> >> These conditions happen very often during suspend and resume,
>> >> when pm_restrict_gfp_mask() effectively converts all GFP_KERNEL
>> >> allocations into __GFP_WAIT.
>> > b>
>> >> The oom killer is not run because gfp_mask & __GFP_FS is false,
>> >> but should_alloc_retry will always return true when order is less
>> >> than PAGE_ALLOC_COSTLY_ORDER.
>> >>
>> >> Fix __alloc_pages_slowpath to skip retrying when oom killer is
>> >> not allowed by the GFP flags, the same way it would skip if the
>> >> oom killer was allowed but disabled.
>> >>
>> >> Signed-off-by: Colin Cross <ccross@android.com>
>> >
>> > Hi Colin,
>> >
>> > Your patch functionally seems fine. I see the problem and we certainly
>> > do not want to have the OOM killer firing during suspend. I would prefer
>> > that the IO devices would not be suspended until reclaim was completed
>> > but I imagine that would be a lot harder.
>> >
>> > That said, it will be difficult to remember why checking __GFP_NOFAIL in
>> > this case is necessary and someone might "optimitise" it away later. It
>> > would be preferable if it was self-documenting. Maybe something like
>> > this? (This is totally untested)
>>
>> This issue is not limited to suspend, any GFP_NOIO allocation could
>> end up in the same loop.  Suspend is the most likely case, because it
>> effectively converts all GFP_KERNEL allocations into GFP_NOIO.
>>
>
> I see what you mean with GFP_NOIO but there is an important difference
> between GFP_NOIO and suspend.  A GFP_NOIO low-order allocation currently
> implies __GFP_NOFAIL as commented on in should_alloc_retry(). If no progress
> is made, we call wait_iff_congested() and sleep for a bit. As the system
> is running, kswapd and other process activity will proceed and eventually
> reclaim enough pages for the GFP_NOIO allocation to succeed. In a running
> system, GFP_NOIO can stall for a period of time but your patch will cause
> the allocation to fail. While I expect callers return ENOMEM or handle
> the situation properly with a wait-and-retry loop, there will be
> operations that fail that used to succeed. This is why I'd prefer it was
> a suspend-specific fix unless we know there is a case where a machine
> livelocks due to a GFP_NOIO allocation looping forever and even then I'd
> wonder why kswapd was not helping.

OK, I see the change in behavior you are trying to avoid.  With your
patch GFP_NOIO allocations can still fail during suspend, is that OK?
I'm also worried about GFP_NOIO allocations looping forever when swap
is not enabled, but I've never seen it happen, and it would probably
recover eventually when another tried tried a GFP_KERNEL allocation
and oom killed something.
