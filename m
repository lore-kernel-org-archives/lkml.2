Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932069Ab1JZBqP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 21:46:15 -0400
Received: from smtp-out.google.com ([74.125.121.67]:11048 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754297Ab1JZBqO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 21:46:14 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:sender:in-reply-to:references:date:
	x-google-sender-auth:message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=szRUuBF/kz2OwpkR3/pViwq3BMlAO2IqehmWEF/M1yjSWyiu1M8CXgWvDHiwagdiz
	jasinAzjgwsa58fg7XZ1g==
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1110251513520.26017@chino.kir.corp.google.com>
References: <1319524789-22818-1-git-send-email-ccross@android.com>
	<20111025090956.GA10797@suse.de>
	<alpine.DEB.2.00.1110251513520.26017@chino.kir.corp.google.com>
Date: Tue, 25 Oct 2011 18:46:10 -0700
X-Google-Sender-Auth: jUNeSbyWHCxcYJT9VCR9zex6cFc
Message-ID: <CAMbhsRQ3y2SBwEfjiYgfxz2-h0fgn20mLBYgFuBwGqon0f-a8g@mail.gmail.com>
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

On Tue, Oct 25, 2011 at 3:18 PM, David Rientjes <rientjes@google.com> wrote:
> On Tue, 25 Oct 2011, Mel Gorman wrote:
>
>> That said, it will be difficult to remember why checking __GFP_NOFAIL in
>> this case is necessary and someone might "optimitise" it away later. It
>> would be preferable if it was self-documenting. Maybe something like
>> this? (This is totally untested)
>>
>
> __GFP_NOFAIL _should_ be optimized away in this case because all he's
> passing is __GFP_WAIT | __GFP_NOFAIL.  That doesn't make any sense unless
> all you want to do is livelock.

__GFP_NOFAIL is not set in the case that I care about.  If my change
is hit, no forward progress has been made, so I agree it should not
honor __GFP_NOFAIL.

> __GFP_NOFAIL doesn't mean the page allocator would infinitely loop in all
> conditions.  That's why GFP_ATOMIC | __GFP_NOFAIL actually fails, and I
> would argue that __GFP_WAIT | __GFP_NOFAIL should fail as well since it's
> the exact same condition except doesn't have access to the extra memory
> reserves.
>
> Suspend needs to either set __GFP_NORETRY to avoid the livelock if it's
> going to disable all means of memory reclaiming or freeing in the page
> allocator.  Or, better yet, just make it GFP_NOWAIT.
>

It would be nice to give compaction and the slab shrinker a chance to
recover a few pages, both methods will work fine in suspend.
GFP_NOWAIT will prevent them from ever running, and __GFP_NORETRY will
give up even if they are making progress but haven't recovered enough
pages.

Converting suspend to GFP_NOWAIT would simply be ~GFP_KERNEL instead
of ~GFP_IOFS in pm_restrict_gfp_mask().
