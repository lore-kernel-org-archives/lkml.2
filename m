Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755303Ab3AHVo3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 16:44:29 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:49972 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754972Ab3AHVo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 16:44:26 -0500
Date: Tue, 8 Jan 2013 13:44:24 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: David Rientjes <rientjes@google.com>, Pekka Enberg <penberg@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Glauber Costa <glommer@parallels.com>,
        Michal Hocko <mhocko@suse.cz>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Luiz Capitulino <lcapitulino@redhat.com>,
        Greg Thelen <gthelen@google.com>,
        Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Minchan Kim <minchan@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: Re: [PATCH 1/2] Add mempressure cgroup
Message-Id: <20130108134424.0423dc1f.akpm@linux-foundation.org>
In-Reply-To: <1357288152-23625-1-git-send-email-anton.vorontsov@linaro.org>
References: <20130104082751.GA22227@lizard.gateway.2wire.net>
	<1357288152-23625-1-git-send-email-anton.vorontsov@linaro.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  4 Jan 2013 00:29:11 -0800
Anton Vorontsov <anton.vorontsov@linaro.org> wrote:

> This commit implements David Rientjes' idea of mempressure cgroup.
> 
> The main characteristics are the same to what I've tried to add to vmevent
> API; internally, it uses Mel Gorman's idea of scanned/reclaimed ratio for
> pressure index calculation. But we don't expose the index to the userland.
> Instead, there are three levels of the pressure:
> 
>  o low (just reclaiming, e.g. caches are draining);
>  o medium (allocation cost becomes high, e.g. swapping);
>  o oom (about to oom very soon).
> 
> The rationale behind exposing levels and not the raw pressure index
> described here: http://lkml.org/lkml/2012/11/16/675
> 
> For a task it is possible to be in both cpusets, memcg and mempressure
> cgroups, so by rearranging the tasks it is possible to watch a specific
> pressure (i.e. caused by cpuset and/or memcg).
> 
> Note that while this adds the cgroups support, the code is well separated
> and eventually we might add a lightweight, non-cgroups API, i.e. vmevent.
> But this is another story.
> 

I'd have thought that it's pretty important offer this feature to
non-cgroups setups.  Restricting it to cgroups-only seems a large
limitation.

> diff --git a/mm/mempressure.c b/mm/mempressure.c
> new file mode 100644
> index 0000000..ea312bb
> --- /dev/null
> +++ b/mm/mempressure.c
> @@ -0,0 +1,330 @@
> +/*
> + * Linux VM pressure
> + *
> + * Copyright 2012 Linaro Ltd.
> + *		  Anton Vorontsov <anton.vorontsov@linaro.org>
> + *
> + * Based on ideas from Andrew Morton, David Rientjes, KOSAKI Motohiro,
> + * Leonid Moiseichuk, Mel Gorman, Minchan Kim and Pekka Enberg.
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2 as published
> + * by the Free Software Foundation.
> + */
> +
> +#include <linux/cgroup.h>
> +#include <linux/fs.h>
> +#include <linux/sched.h>
> +#include <linux/mm.h>
> +#include <linux/vmstat.h>
> +#include <linux/eventfd.h>
> +#include <linux/swap.h>
> +#include <linux/printk.h>
> +
> +static void mpc_vmpressure(struct mem_cgroup *memcg, ulong s, ulong r);

mm/ doesn't use uint or ulong.  In fact I can find zero uses of either
in all of mm/.

I don't have a problem with them personally - they're short and clear. 
But we just ...  don't do that.  Perhaps we shold start using them.

> +
> +/*
> + * Generic VM Pressure routines (no cgroups or any other API details)
> + */
> +
> +/*
> + * The window size is the number of scanned pages before we try to analyze
> + * the scanned/reclaimed ratio (or difference).
> + *
> + * It is used as a rate-limit tunable for the "low" level notification,
> + * and for averaging medium/oom levels. Using small window sizes can cause
> + * lot of false positives, but too big window size will delay the
> + * notifications.
> + */
> +static const uint vmpressure_win = SWAP_CLUSTER_MAX * 16;
> +static const uint vmpressure_level_med = 60;
> +static const uint vmpressure_level_oom = 99;
> +static const uint vmpressure_level_oom_prio = 4;
> +
> +enum vmpressure_levels {
> +	VMPRESSURE_LOW = 0,
> +	VMPRESSURE_MEDIUM,
> +	VMPRESSURE_OOM,

VMPRESSURE_OOM seems an odd-man-out.  VMPRESSURE_HIGH would be pleasing.

> +	VMPRESSURE_NUM_LEVELS,
> +};
> +
>
> ...
>
> +static void mpc_vmpressure(struct mem_cgroup *memcg, ulong s, ulong r)
> +{
> +	/*
> +	 * There are two options for implementing cgroup pressure
> +	 * notifications:
> +	 *
> +	 * - Store pressure counter atomically in the task struct. Upon
> +	 *   hitting 'window' wake up a workqueue that will walk every
> +	 *   task and sum per-thread pressure into cgroup pressure (to
> +	 *   which the task belongs). The cons are obvious: bloats task
> +	 *   struct, have to walk all processes and makes pressue less
> +	 *   accurate (the window becomes per-thread);
> +	 *
> +	 * - Store pressure counters in per-cgroup state. This is easy and
> +	 *   straightforward, and that's how we do things here. But this
> +	 *   requires us to not put the vmpressure hooks into hotpath,
> +	 *   since we have to grab some locks.
> +	 */
> +
> +#ifdef CONFIG_MEMCG
> +	if (memcg) {
> +		struct cgroup_subsys_state *css = mem_cgroup_css(memcg);
> +		struct cgroup *cg = css->cgroup;
> +		struct mpc_state *mpc = cg2mpc(cg);
> +
> +		if (mpc)
> +			__mpc_vmpressure(mpc, s, r);
> +		return;
> +	}
> +#endif
> +	task_lock(current);
> +	__mpc_vmpressure(tsk2mpc(current), s, r);
> +	task_unlock(current);
> +}

The task_lock() is mysterious.  What's it protecting?  That's unobvious
and afacit undocumented.

Also it is buggy: __mpc_vmpressure() does mutex_lock(). 
Documentation/SubmitChecklist section 12 has handy hints!

>
> ...
>

