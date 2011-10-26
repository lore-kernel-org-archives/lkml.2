Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753780Ab1JZGvw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 02:51:52 -0400
Received: from smtp-out.google.com ([216.239.44.51]:21822 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651Ab1JZGvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 02:51:51 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=r2gWniw5SGZly3ddZTCNNjKFRJ/gT0i7D1P4WxJrG7A9/TmDr7BL9T+t20AIy1SIs
	nNhHanafkE948xomxo3GA==
Date: Tue, 25 Oct 2011 23:51:45 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Colin Cross <ccross@android.com>
cc: Mel Gorman <mgorman@suse.de>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org
Subject: Re: [PATCH] mm: avoid livelock on !__GFP_FS allocations
In-Reply-To: <CAMbhsRR0z-aJ848gq6ZQATZOgz=EybVsRtaQbjCr42PtCubCzw@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1110252347330.20273@chino.kir.corp.google.com>
References: <1319524789-22818-1-git-send-email-ccross@android.com> <20111025090956.GA10797@suse.de> <alpine.DEB.2.00.1110251513520.26017@chino.kir.corp.google.com> <CAMbhsRQ3y2SBwEfjiYgfxz2-h0fgn20mLBYgFuBwGqon0f-a8g@mail.gmail.com>
 <alpine.DEB.2.00.1110252244270.18661@chino.kir.corp.google.com> <alpine.DEB.2.00.1110252311030.20273@chino.kir.corp.google.com> <CAMbhsRS+-jn7d1bTd4F0_RB9860iWjOHLfOkDsqLfWEUbR3TYA@mail.gmail.com> <alpine.DEB.2.00.1110252322220.20273@chino.kir.corp.google.com>
 <CAMbhsRQdrWRLkj7U-u2AZxM11mSUNj5_1K27g58cMBo1Js1Yeg@mail.gmail.com> <alpine.DEB.2.00.1110252327270.20273@chino.kir.corp.google.com> <CAMbhsRR0z-aJ848gq6ZQATZOgz=EybVsRtaQbjCr42PtCubCzw@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="397155492-1542067330-1319611906=:20273"
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--397155492-1542067330-1319611906=:20273
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Tue, 25 Oct 2011, Colin Cross wrote:

> >> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> >> index fef8dc3..59cd4ff 100644
> >> --- a/mm/page_alloc.c
> >> +++ b/mm/page_alloc.c
> >> @@ -1786,6 +1786,13 @@ should_alloc_retry(gfp_t gfp_mask, unsigned int order,
> >>                 return 0;
> >>
> >>         /*
> >> +        * If PM has disabled I/O, OOM is disabled and reclaim is unlikely
> >> +        * to make any progress.  To prevent a livelock, don't retry.
> >> +        */
> >> +       if (!(gfp_allowed_mask & __GFP_FS))
> >> +               return 0;
> >> +
> >> +       /*
> >>          * In this implementation, order <= PAGE_ALLOC_COSTLY_ORDER
> >>          * means __GFP_NOFAIL, but that may not be true in other
> >>          * implementations.
> >
> > Eek, this is precisely what we don't want and is functionally the same as
> > what you initially proposed except it doesn't care about __GFP_NOFAIL.
> 
> This is checking against gfp_allowed_mask, not gfp_mask.
> 

gfp_allowed_mask is initialized to GFP_BOOT_MASK to start so that __GFP_FS 
is never allowed before the slab allocator is completely initialized, so 
you've now implicitly made all early boot allocations to be __GFP_NORETRY 
even though they may not pass it.
--397155492-1542067330-1319611906=:20273--
