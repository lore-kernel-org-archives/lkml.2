Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934708Ab1ESUde (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 16:33:34 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45588 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932164Ab1ESUdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 16:33:32 -0400
Date: Thu, 19 May 2011 21:33:24 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: John Stultz <johnstul@us.ibm.com>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable-review@kernel.org,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [Stable-review] [05/21] Fix time() inconsistencies caused by
 intermediate xtime_cache values being read
Message-ID: <20110519203324.GN29924@decadent.org.uk>
References: <20110519182446.GA23751@kroah.com>
 <20110519182436.801262289@clark.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110519182436.801262289@clark.kroah.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I couldn't see who the author of this was, but assuming John Stultz.

On Thu, May 19, 2011 at 11:23:35AM -0700, Greg KH wrote:
[...]
> In order to resolve this, we could add locking to get_seconds(), but it
> needs to be lock free, as it is called from the machine check handler,
> opening a possible deadlock.
> 
> So instead, this patch introduces an intermediate value for the
> calculations, so that we only assign xtime_cache once with the correct
> time, using ACCESS_ONCE to make sure the compiler doesn't optimize out
> any intermediate values.
[...]
> --- a/kernel/time/timekeeping.c
> +++ b/kernel/time/timekeeping.c
> @@ -168,8 +168,15 @@ int __read_mostly timekeeping_suspended;
>  static struct timespec xtime_cache __attribute__ ((aligned (16)));
>  void update_xtime_cache(u64 nsec)
>  {
> -	xtime_cache = xtime;
> -	timespec_add_ns(&xtime_cache, nsec);
> +	/*
> +	 * Use temporary variable so get_seconds() cannot catch
> +	 * an intermediate xtime_cache.tv_sec value.
> +	 * The ACCESS_ONCE() keeps the compiler from optimizing
> +	 * out the intermediate value.
> +	 */
> +	struct timespec ts = xtime;
> +	timespec_add_ns(&ts, nsec);
> +	ACCESS_ONCE(xtime_cache) = ts;
[...]
 
I think this use of ACCESS_ONCE() is bogus.  What it does is to add
volatile-qualification to the write, and while we believe that has
a well-defined effect for int and long I don't think we can assume
that for structure assignment.

It probably works in practice, and I have no objection to this in
2.6.32.y, but I think it would be safer to assign each of the
structure fields separately with ACCESS_ONCE().

Ben.

-- 
Ben Hutchings
We get into the habit of living before acquiring the habit of thinking.
                                                              - Albert Camus
