Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835Ab1JYWMd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 18:12:33 -0400
Received: from smtp-out.google.com ([216.239.44.51]:59533 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140Ab1JYWMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 18:12:31 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type;
	b=Y80wGOKbz5cxLsnyWSQuCCwWBYMu6YtECfYLFbwMPR1lQj8+4rta48ddbjyDZ8bKx
	luRC+AIPIhnDjBKX+QG9Q==
Date: Tue, 25 Oct 2011 15:12:26 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Colin Cross <ccross@android.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org
Subject: Re: [PATCH] mm: avoid livelock on !__GFP_FS allocations
In-Reply-To: <CAMbhsRQs+P9djqW_62ajfZTHE3yxsOs0agek81aZrBzZ2-5-Fg@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1110251510240.26017@chino.kir.corp.google.com>
References: <1319524789-22818-1-git-send-email-ccross@android.com> <CAOJsxLGuHZG9pvx5bCp9tOLA40uDz+U_ZY=_xOddtR9423-Jww@mail.gmail.com> <CAMbhsRQs+P9djqW_62ajfZTHE3yxsOs0agek81aZrBzZ2-5-Fg@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Oct 2011, Colin Cross wrote:

> GFP_KERNEL is __GFP_WAIT | __GFP_IO | __GFP_FS.  Once driver suspend
> has started, gfp_allowed_mask is ~(__GFP_IO | GFP_FS), so any call to
> __alloc_pages_nodemask(GFP_KERNEL, ...) gets masked to effectively
> __alloc_pages_nodemask(__GFP_WAIT, ...).
> 

Just passing __GFP_WAIT is the problem that you're trying to address, 
though.  Why not include __GFP_NORETRY since you know the liklihood of 
allocation being successful on the second iteration is very slim since 
you're not in a context where you can force reclaim or oom killing?

> The loop is in __alloc_pages_slowpath, from the rebalance label to
> should_alloc_retry.

The loop is by design and is activated because you're just passing 
__GFP_WAIT in this context for no sensible reason.
