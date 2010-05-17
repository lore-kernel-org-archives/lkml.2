Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102Ab0EQIUY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 04:20:24 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42153 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446Ab0EQIUX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 04:20:23 -0400
Subject: Re: [PATCH] sched: Avoid side-effect of tickless idle on
 update_cpu_load (v2)
From: Peter Zijlstra <peterz@infradead.org>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Ken Chen <kenchen@google.com>, Paul Turner <pjt@google.com>,
       Nikhil Rao <ncrao@google.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
In-Reply-To: <1273886490-15627-1-git-send-email-venki@google.com>
References: <1273886490-15627-1-git-send-email-venki@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 17 May 2010 10:19:59 +0200
Message-ID: <1274084399.5605.3655.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-14 at 18:21 -0700, Venkatesh Pallipadi wrote:


>  /*
> + * The exact cpu_load decay at various idx values would be
> + * [0] new = 0 * old + 1 * new
> + * [1] new = 1/2 * old + 1/2 * new
> + * [2] new = 3/4 * old + 1/4 * new
> + * [3] new = 7/8 * old + 1/8 * new
> + * [4] new = 15/16 * old + 1/16 * new

Would that be something like?

 load_i = ((2^i)-1)/(2^i) * load_i + 1/(2^i) * load_(i-1)

Where load_-1 == current load.

> + * Load degrade calculations below are approximated on a 128 point scale.
> + * degrade_zero_ticks is the number of ticks after which old_load at any
> + * particular idx is approximated to be zero.
> + * degrade_factor is a precomputed table, a row for each load idx.
> + * Each column corresponds to degradation factor for a power of two ticks,
> + * based on 128 point scale.
> + * Example:
> + * row 2, col 3 (=12) says that the degradation at load idx 2 after
> + * 8 ticks is 12/128 (which is an approximation of exact factor 3^8/4^8).

So because we're in no_hz, current load == 0 and we could approximate
the thing by:

 load_i = ((2^i)-1)/(2^i) * load_i

Because for i ~ 1, there is no new input, and for i >> 1 the fraction is
small.

But why then do we precalculate these factors? It seems to me
((2^i)-1)/(2^i) is something that is trivial to compute and doesn't
warrant a lookup table?

> + * With this power of 2 load factors, we can degrade the load n times
> + * by looking at 1 bits in n and doing as many mult/shift instead of
> + * n mult/shifts needed by the exact degradation.
> + */
> +#define DEGRADE_SHIFT		7
> +static const unsigned char
> +		degrade_zero_ticks[CPU_LOAD_IDX_MAX] = {0, 8, 32, 64, 128};
> +static const unsigned char
> +		degrade_factor[CPU_LOAD_IDX_MAX][DEGRADE_SHIFT + 1] = {
> +					{0, 0, 0, 0, 0, 0, 0, 0},
> +					{64, 32, 8, 0, 0, 0, 0, 0},
> +					{96, 72, 40, 12, 1, 0, 0},
> +					{112, 98, 75, 43, 15, 1, 0},
> +					{120, 112, 98, 76, 45, 16, 2} };



