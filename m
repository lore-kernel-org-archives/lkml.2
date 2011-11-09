Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479Ab1KIQ7d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 11:59:33 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:39110 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285Ab1KIQ7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 11:59:31 -0500
Date: Wed, 9 Nov 2011 08:59:25 -0800
From: Tejun Heo <tj@kernel.org>
To: Andrea Arcangeli <aarcange@redhat.com>, Oleg Nesterov <oleg@redhat.com>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "Rafael J. Wysocki" <rjw@suse.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] thp: reduce khugepaged freezing latency
Message-ID: <20111109165925.GC1260@google.com>
References: <4EB8E969.6010502@suse.cz>
 <1320766151-2619-1-git-send-email-aarcange@redhat.com>
 <1320766151-2619-2-git-send-email-aarcange@redhat.com>
 <4EB98A83.3040101@linux.vnet.ibm.com>
 <4EBA75F2.4080800@linux.vnet.ibm.com>
 <20111109155342.GA1260@google.com>
 <20111109165201.GI5075@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111109165201.GI5075@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Nov 09, 2011 at 05:52:01PM +0100, Andrea Arcangeli wrote:
> > 	schedule_timeout_interruptible(
> > 			msecs_to_jiffies(
> > 				khugepaged_alloc_sleep_millisecs));
> > 	try_to_freeze();
> > 	remove_wait_queue(&khugepaged_wait, &wait);
> > }
> 
> I thought about that but isn't there a race condition if TIF_FREEZE is
> set just in the point I marked above? I thought the
> set_freezable_with_signal by forcing the task runnable would fix it.
> 
> How exactly wait_event_freezable_timeout() would avoid the same race
> as above? I mean the freezer won't have visibility on the
> khugepaged_wait waitqueue head so it surely cannot wake it up. And if
> the freezing() check happens before TIF_FREEZE get set but before
> schedule() is called, we're still screwed even if I use
> wait_event_freezable_timeout()... Or is the signal_pending check
> fixing that? But without set_freezable_with_signal() we don't set
> TIF_SIGPENDING... so it's not immediately care how this whole logic is
> race free. If you use stop_machine that could avoid the races though,
> but it doesn't look like the freezer uses that.

Freezer depends on the usual "set_current_state(INTERRUPTIBLE); check
freezing; schedule(); check freezing" construct and sends
INTERRUPTIBLE wake up after setting freezing state.  The
synchronization hasn't been completely clear but recently been cleaned
up, so as long as freezing condition is tested after INTERRUPTIBLE is
set before going to sleep, the event won't go missing.

Maybe we need a helper here, which would be named horribly -
schedule_timeout_interruptible_freezable().  (cc'ing Oleg) Oleg, maybe
we need schedule_timeout(@sleep_type) too?

Thanks.

-- 
tejun
