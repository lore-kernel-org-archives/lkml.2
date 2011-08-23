Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083Ab1HWTxO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 15:53:14 -0400
Received: from smtp-out.google.com ([74.125.121.67]:37801 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756061Ab1HWTxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 15:53:04 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:x-system-of-record;
	b=fBoMjfzS8Ry1m6bwDMCEskbjKKPPbWofVp87mJSYk5YwNgqlE5mkrxg6c8D4GhMIe
	kHTb/G+G9ZiqOMIuoa4dg==
MIME-Version: 1.0
In-Reply-To: <20110822213347.GF2507@redhat.com>
References: <1313740111-27446-1-git-send-email-walken@google.com>
	<20110822213347.GF2507@redhat.com>
Date: Tue, 23 Aug 2011 12:52:56 -0700
Message-ID: <CANN689HE=TKyr-0yDQgXEoothGJ0Cw0HLB2iOvCKrOXVF2DNww@mail.gmail.com>
Subject: Re: [PATCH] thp: tail page refcounting fix
From: Michel Lespinasse <walken@google.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Shaohua Li <shaohua.li@intel.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrea,

On Mon, Aug 22, 2011 at 2:33 PM, Andrea Arcangeli <aarcange@redhat.com> wrote:
> So this solution:
>
> 1) should allow the working set estimation code to keep doing its
> get_page_unless_zero() without any change (you'll still have to modify
> it to check if you got a THP page etc... but you won't risk to get any
> tail page anymore). Maybe it still needs some non trivial thought
> about the changes but not anymore about tail pages refcounting screwups.
>
> 2) no change to all existing get_page_unless_zero() is required, so
> this should fix the radix tree speculative page lookup too.
>
> 3) no RCU new feature is needed

Adding Paul McKenney so he won't spend too much time on RCU cookie
feature until there is a firmer user...

> 4) get_page was actually called by direct-io as my debug
> instrumentation I wrote to test these changes noticed it so I fixed
> that too

Looks like this scheme will work. I'm off in Yosemite for a few days
with my family, but I should be able to review this more thoroughly on
Thursday.

>From a few-minutes look, I have a few minor concerns:
- When splitting THP pages, the old tail refcount will be visible as
the _mapcount for a short while after PageTail is cleared; not clear
yet to me if there are unintended side effects to that;
- (not a concern, but an opportunity) when splitting pages, there are
two atomic adds to the tail _count field, while we know the initial
value is 0. Why not just one straight assignment ? Similarly, the
adjustments to page head count could be added into a local variable
and the page head count could be updated once after all tail pages
have been split off.
- Not sure if we could/should add assertions to make sure people call
the right get_page variant.

The other question I have is about the use of the pagemap.h RCU
protocol for eventual page count stability. With your proposal, this
would now affect only head pages, so THP splitting is fine :) . I'm
not sure who else might use that protocol, but it looks like we should
either make all get_pages_unless_zero call sites follow it (if the
protocol matters to someone) or none (if the protocol turns out to be
obsolete).

Sorry for the incomplete reply, I'll have a better one by Thursday :)

Thanks,

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
