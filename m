Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855Ab1JYWSW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 18:18:22 -0400
Received: from smtp-out.google.com ([216.239.44.51]:62573 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026Ab1JYWSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 18:18:21 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=rk8w1nFeLzx3BiyNA2u4FXlf20w0kQbfeQHRbgFFdoC3Z1gl+sXq78I+aQvomIAYP
	ysYyMBVooxlYwQxZ0uAWg==
Date: Tue, 25 Oct 2011 15:18:15 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mel Gorman <mgorman@suse.de>
cc: Colin Cross <ccross@android.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org
Subject: Re: [PATCH] mm: avoid livelock on !__GFP_FS allocations
In-Reply-To: <20111025090956.GA10797@suse.de>
Message-ID: <alpine.DEB.2.00.1110251513520.26017@chino.kir.corp.google.com>
References: <1319524789-22818-1-git-send-email-ccross@android.com> <20111025090956.GA10797@suse.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Oct 2011, Mel Gorman wrote:

> That said, it will be difficult to remember why checking __GFP_NOFAIL in
> this case is necessary and someone might "optimitise" it away later. It
> would be preferable if it was self-documenting. Maybe something like
> this? (This is totally untested)
> 

__GFP_NOFAIL _should_ be optimized away in this case because all he's 
passing is __GFP_WAIT | __GFP_NOFAIL.  That doesn't make any sense unless 
all you want to do is livelock.

__GFP_NOFAIL doesn't mean the page allocator would infinitely loop in all 
conditions.  That's why GFP_ATOMIC | __GFP_NOFAIL actually fails, and I 
would argue that __GFP_WAIT | __GFP_NOFAIL should fail as well since it's 
the exact same condition except doesn't have access to the extra memory 
reserves.

Suspend needs to either set __GFP_NORETRY to avoid the livelock if it's 
going to disable all means of memory reclaiming or freeing in the page 
allocator.  Or, better yet, just make it GFP_NOWAIT.
