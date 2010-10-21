Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758720Ab0JUWhZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 18:37:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47422 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751806Ab0JUWhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 18:37:24 -0400
Date: Thu, 21 Oct 2010 15:37:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Nick Piggin <npiggin@kernel.dk>, Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH] percpu_counter : add percpu_counter_add_fast()
Message-Id: <20101021153719.c8bde251.akpm@linux-foundation.org>
In-Reply-To: <1287238754.2799.376.camel@edumazet-laptop>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com>
	<1285762729-17928-17-git-send-email-david@fromorbit.com>
	<20100929215322.ff635d3e.akpm@linux-foundation.org>
	<20100930061039.GX5665@dastard>
	<20101016075510.GH19147@amd>
	<1287217748.2799.68.camel@edumazet-laptop>
	<20101016020744.366bd9c6.akpm@linux-foundation.org>
	<1287221475.2799.123.camel@edumazet-laptop>
	<1287238754.2799.376.camel@edumazet-laptop>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Oct 2010 16:19:14 +0200
Eric Dumazet <eric.dumazet@gmail.com> wrote:

> The current way to change a percpu_counter is to call
> percpu_counter_add(), which is a bit expensive.
> (More than 40 instructions, possible false sharing, ...)
> 
> When we dont need to maintain the approximate value of the
> percpu_counter (aka fbc->count), and dont need a "s64" wide counter but
> a regular "int" or "long" one, we can use this new function : 
> percpu_counter_add_fast()
> 
> This function is pretty fast : 
> - One instruction on x86 SMP, no register pressure.
> - Is safe in preempt enabled contexts.
> - No lock acquisition, less false sharing.
> 
> Users of this percpu_counter variant should not use
> percpu_counter_read() or percpu_counter_read_positive() anymore, only
> percpu_counter_sum{_positive}() variant.

That isn't actually what I was suggesting.  I was suggesting the use of
an inlined, this_cpu_add()-using percpu_counter_add() variant which
still does the batched spilling into ->count.  IOW, just speed up the
current implementation along the lines of

{
	val = this_cpu_add_return(*fbc->counters, amount);
	if (unlikely(abs(val) > fbc->batch))
		out_of_line_stuff();
}	

I suppose what you're proposing here is useful, although the name isn't
a good one.  It's a different way of using the existing data structure.
I'd suggest that a better name is something like percpu_counter_add_local()?

