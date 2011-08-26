Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754443Ab1HZMvt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 08:51:49 -0400
Received: from casper.infradead.org ([85.118.1.10]:37125 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796Ab1HZMvs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 08:51:48 -0400
Subject: Re: [PATCH 05/10] writeback: per task dirty rate limit
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>,
        Dave Chinner <david@fromorbit.com>, Greg Thelen <gthelen@google.com>,
        Minchan Kim <minchan.kim@gmail.com>, Vivek Goyal <vgoyal@redhat.com>,
        Andrea Righi <arighi@develer.com>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Fri, 26 Aug 2011 14:51:09 +0200
In-Reply-To: <20110826114619.268843347@intel.com>
References: <20110826113813.895522398@intel.com>
	 <20110826114619.268843347@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314363069.11049.3.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-08-26 at 19:38 +0800, Wu Fengguang wrote:
> +       preempt_disable();
>         /*
> -        * Check the rate limiting. Also, we do not want to throttle real-time
> -        * tasks in balance_dirty_pages(). Period.
> +        * This prevents one CPU to accumulate too many dirtied pages without
> +        * calling into balance_dirty_pages(), which can happen when there are
> +        * 1000+ tasks, all of them start dirtying pages at exactly the same
> +        * time, hence all honoured too large initial task->nr_dirtied_pause.
>          */
> -       preempt_disable();
>         p =  &__get_cpu_var(bdp_ratelimits);

	p = &get_cpu_var(bdp_ratelimits);

> -       *p += nr_pages_dirtied;
> -       if (unlikely(*p >= ratelimit)) {
> -               ratelimit = sync_writeback_pages(*p);
> +       if (unlikely(current->nr_dirtied >= ratelimit))
>                 *p = 0;
> -               preempt_enable();
> -               balance_dirty_pages(mapping, ratelimit);
> -               return;
> +       else {
> +               *p += nr_pages_dirtied;
> +               if (unlikely(*p >= ratelimit_pages)) {
> +                       *p = 0;
> +                       ratelimit = 0;
> +               }
>         }
>         preempt_enable(); 

	put_cpu_var(bdp_ratelimits);
