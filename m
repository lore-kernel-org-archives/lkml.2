Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886Ab2KGMJf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 07:09:35 -0500
Received: from [204.155.152.216] ([204.155.152.216]:44859 "EHLO shutemov.name"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754832Ab2KGMJd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 07:09:33 -0500
Date: Wed, 7 Nov 2012 14:11:10 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Mel Gorman <mgorman@suse.de>, Pekka Enberg <penberg@kernel.org>,
        Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Minchan Kim <minchan@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com, linux-man@vger.kernel.org,
        Glauber Costa <glommer@parallels.com>
Subject: Re: [RFC v3 0/3] vmpressure_fd: Linux VM pressure notifications
Message-ID: <20121107121110.GA32402@shutemov.name>
References: <20121107105348.GA25549@lizard>
 <20121107112136.GA31715@shutemov.name>
 <20121107114346.GA32565@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121107114346.GA32565@lizard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 07, 2012 at 03:43:46AM -0800, Anton Vorontsov wrote:
> On Wed, Nov 07, 2012 at 01:21:36PM +0200, Kirill A. Shutemov wrote:
> [...]
> > Sorry, I didn't follow previous discussion on this, but could you
> > explain what's wrong with memory notifications from memcg?
> > As I can see you can get pretty similar functionality using memory
> > thresholds on the root cgroup. What's the point?
> 
> There are a few reasons we don't use cgroup notifications:
> 
> 1. We're not interested in the absolute number of pages/KB of available
>    memory, as provided by cgroup memory controller. What we're interested
>    in is the amount of easily reclaimable memory and new memory
>    allocations' cost.
> 
>    We can have plenty of "free" memory, of which say 90% will be caches,
>    and say 10% idle. But we do want to differentiate these types of memory
>    (although not going into details about it), i.e. we want to get
>    notified when kernel is reclaiming. And we also want to know when the
>    memory comes from swapping others' pages out (well, actually we don't
>    call it swap, it's "new allocations cost becomes high" -- it might be a
>    result of many factors (swapping, fragmentation, etc.) -- and userland
>    might analyze the situation when this happens).
> 
>    Exposing all the VM details to userland is not an option

IIUC, you want MemFree + Buffers + Cached + SwapCached, right?
It's already exposed to userspace.

> -- it is not
>    possible to build a stable ABI on this. Plus, it makes it really hard
>    for userland to deal with all the low level details of Linux VM
>    internals.
> 
>    So, no, raw numbers of "free/used KBs" are not interesting at all.
> 
> 1.5. But it is important to understand that vmpressure_fd() is not
>      orthogonal to cgroups (like it was with vmevent_fd()). We want it to
>      be "cgroup'able" too. :) But optionally.
> 
> 2. The last time I checked, cgroups memory controller did not (and I guess
>    still does not) not account kernel-owned slabs. I asked several times
>    why so, but nobody answered.

Almost there. Glauber works on it.

-- 
 Kirill A. Shutemov
