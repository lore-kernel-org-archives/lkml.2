Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544Ab1KAM3p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 08:29:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40300 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754330Ab1KAM3n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 08:29:43 -0400
Date: Tue, 1 Nov 2011 12:29:40 +0000
From: Mel Gorman <mgorman@suse.de>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Colin Cross <ccross@android.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org
Subject: Re: [PATCH] mm: avoid livelock on !__GFP_FS allocations
Message-ID: <20111101122940.GC25123@suse.de>
References: <1319524789-22818-1-git-send-email-ccross@android.com>
 <20111025090956.GA10797@suse.de>
 <CAMbhsRR07Gpv-nEAvq8OQmLxkMyL5cASpq1vqQ8qN5ctwnamsQ@mail.gmail.com>
 <20111025112300.GB10797@suse.de>
 <CAOJsxLH54aUjVE3b7queQMOJP1kb+bxtUTAUA=T=N378M5_hJA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOJsxLH54aUjVE3b7queQMOJP1kb+bxtUTAUA=T=N378M5_hJA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 25, 2011 at 10:39:34PM +0300, Pekka Enberg wrote:
> Hi Mel,
> 
> On Tue, Oct 25, 2011 at 2:23 PM, Mel Gorman <mgorman@suse.de> wrote:
> > I see what you mean with GFP_NOIO but there is an important difference
> > between GFP_NOIO and suspend.  A GFP_NOIO low-order allocation currently
> > implies __GFP_NOFAIL as commented on in should_alloc_retry(). If no progress
> > is made, we call wait_iff_congested() and sleep for a bit. As the system
> > is running, kswapd and other process activity will proceed and eventually
> > reclaim enough pages for the GFP_NOIO allocation to succeed. In a running
> > system, GFP_NOIO can stall for a period of time but your patch will cause
> > the allocation to fail. While I expect callers return ENOMEM or handle
> > the situation properly with a wait-and-retry loop, there will be
> > operations that fail that used to succeed. This is why I'd prefer it was
> > a suspend-specific fix unless we know there is a case where a machine
> > livelocks due to a GFP_NOIO allocation looping forever and even then I'd
> > wonder why kswapd was not helping.
> 
> I'm not that happy about your patch because it's going to the
> direction where the page allocator is special-casing for suspension.

Suspend really is a special case. While I'd prefer to avoid special
casing it like this, I prefer it a *lot* more than failing GFP_NOIO
allocations that used to succeed.

-- 
Mel Gorman
SUSE Labs
