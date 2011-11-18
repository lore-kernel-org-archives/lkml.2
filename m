Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323Ab1KRVJp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 16:09:45 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:31878 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751751Ab1KRVJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 16:09:44 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAITHxk55LGY5/2dsb2JhbABDqjeBBoFyAQEFOhwjEAgDGBUZFCUDIRO+eRKGZIMhBJQ4iQKJFA
Date: Sat, 19 Nov 2011 08:09:41 +1100
From: Dave Chinner <david@fromorbit.com>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: remove struct reclaim_state
Message-ID: <20111118210941.GK7046@dastard>
References: <20111118092806.21688.8662.stgit@zurg>
 <20111118095644.GJ7046@dastard>
 <4EC62E46.6080503@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EC62E46.6080503@openvz.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 18, 2011 at 02:07:02PM +0400, Konstantin Khlebnikov wrote:
> Dave Chinner wrote:
> >On Fri, Nov 18, 2011 at 01:28:06PM +0300, Konstantin Khlebnikov wrote:
> >>Memory reclaimer want to know how much pages was reclaimed during shrinking slabs.
> >>Currently there is special struct reclaim_state with single counter and pointer from
> >>task-struct. Let's store counter direcly on task struct and account freed pages
> >>unconditionally. This will reduce stack usage and simplify code in reclaimer and slab.
> >>
> >>Logic in do_try_to_free_pages() is slightly changed, but this is ok.
> >>Nobody calls shrink_slab() explicitly before do_try_to_free_pages(),
> >
> >Except for drop_slab() and shake_page()....
> 
> Indeed, but they do not care about accounting reclaimed pages and
> they do not call do_try_to_free_pages() after all.

Right, so you're effectively leaving a landmine for someone to trip
over - anyone that cares about accounting during shrink_slab needs
to zero the value first.  The current code makes this obvious by not
having a reclaim structure in the cases where callers don't care
about accounting - after your change the correct usage is
undocumented....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
