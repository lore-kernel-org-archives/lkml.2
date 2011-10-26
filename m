Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044Ab1JZHKd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 03:10:33 -0400
Received: from smtp-out.google.com ([216.239.44.51]:27126 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486Ab1JZHKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 03:10:32 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=g9R2uFqcQtDsC7qfq3Hv6c2KCnET5G/R3M/FM+K2iUQqqVsqDser0OywhC0hVT0ud
	dFiXqrxvR+mb76yiuNlrw==
Date: Wed, 26 Oct 2011 00:10:26 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Colin Cross <ccross@android.com>
cc: Mel Gorman <mgorman@suse.de>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org
Subject: Re: [PATCH] mm: avoid livelock on !__GFP_FS allocations
In-Reply-To: <CAMbhsRScgfokDOiT7c9RbmqC7E_ZXrwLEYXE7JZWFGoePjAXvg@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1110260006470.23227@chino.kir.corp.google.com>
References: <1319524789-22818-1-git-send-email-ccross@android.com> <20111025090956.GA10797@suse.de> <alpine.DEB.2.00.1110251513520.26017@chino.kir.corp.google.com> <CAMbhsRQ3y2SBwEfjiYgfxz2-h0fgn20mLBYgFuBwGqon0f-a8g@mail.gmail.com>
 <alpine.DEB.2.00.1110252244270.18661@chino.kir.corp.google.com> <alpine.DEB.2.00.1110252311030.20273@chino.kir.corp.google.com> <CAMbhsRS+-jn7d1bTd4F0_RB9860iWjOHLfOkDsqLfWEUbR3TYA@mail.gmail.com> <alpine.DEB.2.00.1110252322220.20273@chino.kir.corp.google.com>
 <CAMbhsRQdrWRLkj7U-u2AZxM11mSUNj5_1K27g58cMBo1Js1Yeg@mail.gmail.com> <alpine.DEB.2.00.1110252327270.20273@chino.kir.corp.google.com> <CAMbhsRR0z-aJ848gq6ZQATZOgz=EybVsRtaQbjCr42PtCubCzw@mail.gmail.com> <alpine.DEB.2.00.1110252347330.20273@chino.kir.corp.google.com>
 <CAMbhsRScgfokDOiT7c9RbmqC7E_ZXrwLEYXE7JZWFGoePjAXvg@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Oct 2011, Colin Cross wrote:

> > gfp_allowed_mask is initialized to GFP_BOOT_MASK to start so that __GFP_FS
> > is never allowed before the slab allocator is completely initialized, so
> > you've now implicitly made all early boot allocations to be __GFP_NORETRY
> > even though they may not pass it.
> 
> Only before interrupts are enabled, and then isn't it vulnerable to
> the same livelock?  Interrupts are off, single cpu, kswapd can't run.
> If an allocation ever failed, which seems unlikely, why would retrying
> help?
> 

If you want to claim gfp_allowed_mask as a pm-only entity, then I see no 
problem with this approach.  However, if gfp_allowed_mask would be allowed 
to temporarily change after init for another purpose then it would make 
sense to retry because another allocation with __GFP_FS on another cpu or 
kswapd could start making progress could allow for future memory freeing.

The suggestion to add a hook directly into a pm-interface was so that we 
could isolate it only to suspend and, to me, is the most maintainable 
solution.
