Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510Ab1G0X2z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 19:28:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46239 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751900Ab1G0X2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 19:28:52 -0400
Date: Wed, 27 Jul 2011 16:28:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hugh Dickins <hughd@google.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/3] tmpfs radix_tree: locate_item to speed up swapoff
Message-Id: <20110727162819.b595e442.akpm@linux-foundation.org>
In-Reply-To: <alpine.LSU.2.00.1107191553040.1593@sister.anvils>
References: <alpine.LSU.2.00.1107191549540.1593@sister.anvils>
	<alpine.LSU.2.00.1107191553040.1593@sister.anvils>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Jul 2011 15:54:23 -0700 (PDT)
Hugh Dickins <hughd@google.com> wrote:

> We have already acknowledged that swapoff of a tmpfs file is slower
> than it was before conversion to the generic radix_tree: a little
> slower there will be acceptable, if the hotter paths are faster.
> 
> But it was a shock to find swapoff of a 500MB file 20 times slower
> on my laptop, taking 10 minutes; and at that rate it significantly
> slows down my testing.

So it used to take half a minute?  That was already awful.  Why?  Was
it IO-bound?  It doesn't sound like it.

> Now, most of that turned out to be overhead from PROVE_LOCKING and
> PROVE_RCU: without those it was only 4 times slower than before;
> and more realistic tests on other machines don't fare as badly.

What's unrealistic about doing swapoff of a 500MB tmpfs file?

Also, confused.  You're talking about creating a regular file on tmpfs
and then using that as a swapfile?  If so, that's a
kernel-hacker-curiosity only?

> I've tried a number of things to improve it, including tagging the
> swap entries, then doing lookup by tag: I'd expected that to halve
> the time, but in practice it's erratic, and often counter-productive.
> 
> The only change I've so far found to make a consistent improvement,
> is to short-circuit the way we go back and forth, gang lookup packing
> entries into the array supplied, then shmem scanning that array for the
> target entry.  Scanning in place doubles the speed, so it's now only
> twice as slow as before (or three times slower when the PROVEs are on).
> 
> So, add radix_tree_locate_item() as an expedient, once-off, single-caller
> hack to do the lookup directly in place.  #ifdef it on CONFIG_SHMEM and
> CONFIG_SWAP, as much to document its limited applicability as save space
> in other configurations.  And, sadly, #include sched.h for cond_resched().
> 

How much did that 10 minutes improve?

