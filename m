Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753099Ab1JYTjg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 15:39:36 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:64404 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630Ab1JYTjf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 15:39:35 -0400
MIME-Version: 1.0
In-Reply-To: <20111025112300.GB10797@suse.de>
References: <1319524789-22818-1-git-send-email-ccross@android.com>
	<20111025090956.GA10797@suse.de>
	<CAMbhsRR07Gpv-nEAvq8OQmLxkMyL5cASpq1vqQ8qN5ctwnamsQ@mail.gmail.com>
	<20111025112300.GB10797@suse.de>
Date: Tue, 25 Oct 2011 22:39:34 +0300
X-Google-Sender-Auth: usYENZRqBD-pQWlmjIBQJKOT91Y
Message-ID: <CAOJsxLH54aUjVE3b7queQMOJP1kb+bxtUTAUA=T=N378M5_hJA@mail.gmail.com>
Subject: Re: [PATCH] mm: avoid livelock on !__GFP_FS allocations
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Mel Gorman <mgorman@suse.de>
Cc: Colin Cross <ccross@android.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mel,

On Tue, Oct 25, 2011 at 2:23 PM, Mel Gorman <mgorman@suse.de> wrote:
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

I'm not that happy about your patch because it's going to the
direction where the page allocator is special-casing for suspension.
If you don't think it's a good idea to fix it for the general case
(i.e. Colin's patch), why don't we fix it up in a way that suspension
code passes sane GFP flags?

                        Pekka
