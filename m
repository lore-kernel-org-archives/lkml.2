Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755959Ab1JYJ1E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 05:27:04 -0400
Received: from smtp-out.google.com ([74.125.121.67]:30668 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755850Ab1JYJ1C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 05:27:02 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:sender:in-reply-to:references:date:
	x-google-sender-auth:message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=pVshUatXHTS8tVuoNJtj26nouVh5LVTkCI+NXmeVBw7nC3RArqSil/B6pUZv6FYDA
	vrS9jsPVOqPDyn+2Krw5w==
MIME-Version: 1.0
In-Reply-To: <20111025090956.GA10797@suse.de>
References: <1319524789-22818-1-git-send-email-ccross@android.com>
	<20111025090956.GA10797@suse.de>
Date: Tue, 25 Oct 2011 02:26:56 -0700
X-Google-Sender-Auth: 8757b7zcWR2h6w3m9duSgous_Z8
Message-ID: <CAMbhsRR07Gpv-nEAvq8OQmLxkMyL5cASpq1vqQ8qN5ctwnamsQ@mail.gmail.com>
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

On Tue, Oct 25, 2011 at 2:09 AM, Mel Gorman <mgorman@suse.de> wrote:
> On Mon, Oct 24, 2011 at 11:39:49PM -0700, Colin Cross wrote:
>> Under the following conditions, __alloc_pages_slowpath can loop
>> forever:
>> gfp_mask & __GFP_WAIT is true
>> gfp_mask & __GFP_FS is false
>> reclaim and compaction make no progress
>> order <= PAGE_ALLOC_COSTLY_ORDER
>>
>> These conditions happen very often during suspend and resume,
>> when pm_restrict_gfp_mask() effectively converts all GFP_KERNEL
>> allocations into __GFP_WAIT.
> b>
>> The oom killer is not run because gfp_mask & __GFP_FS is false,
>> but should_alloc_retry will always return true when order is less
>> than PAGE_ALLOC_COSTLY_ORDER.
>>
>> Fix __alloc_pages_slowpath to skip retrying when oom killer is
>> not allowed by the GFP flags, the same way it would skip if the
>> oom killer was allowed but disabled.
>>
>> Signed-off-by: Colin Cross <ccross@android.com>
>
> Hi Colin,
>
> Your patch functionally seems fine. I see the problem and we certainly
> do not want to have the OOM killer firing during suspend. I would prefer
> that the IO devices would not be suspended until reclaim was completed
> but I imagine that would be a lot harder.
>
> That said, it will be difficult to remember why checking __GFP_NOFAIL in
> this case is necessary and someone might "optimitise" it away later. It
> would be preferable if it was self-documenting. Maybe something like
> this? (This is totally untested)

This issue is not limited to suspend, any GFP_NOIO allocation could
end up in the same loop.  Suspend is the most likely case, because it
effectively converts all GFP_KERNEL allocations into GFP_NOIO.

>  mm/page_alloc.c |   22 ++++++++++++++++++++++
>  1 files changed, 22 insertions(+), 0 deletions(-)
>
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 6e8ecb6..ad8f376 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -127,6 +127,20 @@ void pm_restrict_gfp_mask(void)
>        saved_gfp_mask = gfp_allowed_mask;
>        gfp_allowed_mask &= ~GFP_IOFS;
>  }
> +
> +static bool pm_suspending(void)
> +{
> +       if ((gfp_allowed_mask & GFP_IOFS) == GFP_IOFS)
> +               return false;
> +       return true;
> +}
> +
> +#else
> +
> +static bool pm_suspending(void)
> +{
> +       return false;
> +}
>  #endif /* CONFIG_PM_SLEEP */
>
>  #ifdef CONFIG_HUGETLB_PAGE_SIZE_VARIABLE
> @@ -2207,6 +2221,14 @@ rebalance:
>
>                        goto restart;
>                }
> +
> +               /*
> +                * Suspend converts GFP_KERNEL to __GFP_WAIT which can
> +                * prevent reclaim making forward progress without
> +                * invoking OOM. Bail if we are suspending
> +                */
> +               if (pm_suspending())
> +                       goto nopage;
>        }
>
>        /* Check if we should retry the allocation */
>
