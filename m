Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030973Ab2ERKnx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 06:43:53 -0400
Received: from merlin.infradead.org ([205.233.59.134]:34258 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965994Ab2ERKnu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 06:43:50 -0400
Message-ID: <1337337824.573.16.camel@twins>
Subject: Re: [PATCH 1/2] lib: Proportions with flexible period
From: Peter Zijlstra <peterz@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org
Date: Fri, 18 May 2012 12:43:44 +0200
In-Reply-To: <1337096583-6049-2-git-send-email-jack@suse.cz>
References: <1337096583-6049-1-git-send-email-jack@suse.cz>
	 <1337096583-6049-2-git-send-email-jack@suse.cz>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-15 at 17:43 +0200, Jan Kara wrote:
> +void __fprop_inc_percpu_max(struct fprop_global *p,
> +                           struct fprop_local_percpu *pl, int max_frac)
> +{
> +       if (unlikely(max_frac < 100)) {
> +               unsigned long numerator, denominator;
> +
> +               fprop_fraction_percpu(p, pl, &numerator, &denominator);
> +               if (numerator > ((long long)denominator) * max_frac / 100)
> +                       return;

Another thing, your fprop_fraction_percpu() can he horribly expensive
due to using _sum() (and to a lesser degree the retry), remember that
this function is called for _every_ page written out.

Esp. on the mega fast storage (multi-spindle or SSD) they're pushing cpu
limits as it is with iops, we should be very careful not to make it more
expensive than absolutely needed.

> +       } else
> +               fprop_reflect_period_percpu(p, pl);
> +       __percpu_counter_add(&pl->events, 1, PROP_BATCH);
> +       percpu_counter_add(&p->events, 1);
> +} 
