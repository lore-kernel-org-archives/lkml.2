Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758419Ab0FIWhM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 18:37:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37618 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756513Ab0FIWhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 18:37:10 -0400
Date: Wed, 9 Jun 2010 15:36:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Tim Chen <tim.c.chen@linux.intel.com>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@linux.intel.com>, Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH v2 1/2] tmpfs: Quick token library to allow scalable
 retrieval of tokens from token jar
Message-Id: <20100609153654.0061e9c8.akpm@linux-foundation.org>
In-Reply-To: <87ocftyfnh.fsf@basil.nowhere.org>
References: <1274902371.31973.9392.camel@mudge.jf.intel.com>
	<20100601145126.f46572d1.akpm@linux-foundation.org>
	<87ocftyfnh.fsf@basil.nowhere.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 02 Jun 2010 10:58:42 +0200
Andi Kleen <andi@firstfloor.org> wrote:

> Andrew Morton <akpm@linux-foundation.org> writes:
> 
> I am to blame for the "token jar" name.
> 
> > OK, thanks.  But I'm still struggling a bit in understanding the
> > applicability.  Where else might one use this?  What particular
> > problem is it good at solving?
> 
> I wrote a similar scheme a long time ago for IP protocol ID
> allocation (but that code never ended up in mainline).
> Back then it was called "cookie jar" and you can actually
> still google for it :)
> 
> It can be used for pretty much anything where you have
> a global resource and want to hand it out to different CPUs,
> but still have a global limit that is enforced.
> 
> For example a file system could use it for accounting 
> free space too.
> 
> In principle you could even use it for pids for example
> or other IDs.

You could, execept the code's basically identical to percpu_counters,
only worse.

> >
> > I think the problem here is that you're using the term "token jar" as
> > if others already know what a token jar _is_.  I guess I was asleep
> > during that compsci lecture, but google doesn't appear to know about
> > the term either.
> >
> > And from looking at the tmpfs caller, it appears that the token jar is
> > being used to speed up the access to a single `unsigned long
> > free_blocks'.  Could we have used say a percpu_counter instead?
> 
> You need some synchronization, otherwise the accounting
> would not be exact and you could overflow. Yes you could
> open code it, but having it in a library is nicer.

The code doesn't have synchronisation!  qtoken_return() can modify the
per-cpu "cache" in parallel with qtoken_avail()'s walk across the
per-cpu "caches", yielding an inaccurate result.

This is all the same as percpu_add() executing in parallel with
percpu_counter_sum() or percpu_counter_sum_positive().

If we cannot tolerate that inaccuracy then these patches are no good
and we need a rethink.

If we _can_ tolerate that inaccuracy then percpu_counters can be used
here.  And doing that is preferable to reinventing percpu_counters
badly.

I'm just not seeing it.
