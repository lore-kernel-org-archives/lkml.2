Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751547Ab2AXV5Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 16:57:16 -0500
Received: from tex.lwn.net ([70.33.254.29]:60910 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750895Ab2AXV5P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 16:57:15 -0500
Date: Tue, 24 Jan 2012 14:57:13 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Pekka Enberg <penberg@kernel.org>
Cc: Rik van Riel <riel@redhat.com>, Minchan Kim <minchan@kernel.org>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        leonid.moiseichuk@nokia.com, kamezawa.hiroyu@jp.fujitsu.com,
        mel@csn.ul.ie, rientjes@google.com,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, Ronen Hod <rhod@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [RFC 1/3] /dev/low_mem_notify
Message-ID: <20120124145713.20fad866@dt>
In-Reply-To: <alpine.LFD.2.02.1201172044310.15303@tux.localdomain>
References: <1326788038-29141-1-git-send-email-minchan@kernel.org>
	<1326788038-29141-2-git-send-email-minchan@kernel.org>
	<CAOJsxLHGYmVNk7D9NyhRuqQDwquDuA7LtUtp-1huSn5F-GvtAg@mail.gmail.com>
	<4F15A34F.40808@redhat.com>
	<alpine.LFD.2.02.1201172044310.15303@tux.localdomain>
Organization: LWN.net
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jan 2012 20:51:13 +0200 (EET)
Pekka Enberg <penberg@kernel.org> wrote:

> Ok, so here's a proof of concept patch that implements sample-base 
> per-process free threshold VM event watching using perf-like syscall ABI. 
> I'd really like to see something like this that's much more extensible and 
> clean than the /dev based ABIs that people have proposed so far.

OK, so I'm slow, but better late than never.  I plead travel.

I guess the thing that surprises me is that nobody has said this yet: this
looks a lot like an event-reporting mechanism like perf.  Is there a reason
these can't be perf-style events integrated with all the rest?

> +struct vmnotify_config {
> +	/*
> +	 * Size of the struct for ABI extensibility.
> +	 */
> +	__u32		   size;
> +
> +	/*
> +	 * Notification type bitmask
> +	 */
> +	__u64			type;
> +
> +	/*
> +	 * Free memory threshold in percentages [1..99]
> +	 */
> +	__u32			free_threshold;

Is this an upper-bound threshold or a lower-bound threshold?  From your
example, it looks like "free_threshold" is "the amount of memory that is
not free", which seems confusing.

[...]

> new file mode 100644
> index 0000000..6800450
> --- /dev/null
> +++ b/mm/vmnotify.c
> @@ -0,0 +1,235 @@
> +#include <linux/anon_inodes.h>
> +#include <linux/vmnotify.h>
> +#include <linux/syscalls.h>
> +#include <linux/file.h>
> +#include <linux/list.h>
> +#include <linux/poll.h>
> +#include <linux/slab.h>
> +#include <linux/swap.h>
> +
> +#define VMNOTIFY_MAX_FREE_THRESHOD	100

Did we run out of L's here? :)

> +static ssize_t vmnotify_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
> +{
> +	struct vmnotify_watch *watch = file->private_data;
> +	int ret = 0;
> +
> +	mutex_lock(&watch->mutex);
> +
> +	if (!watch->pending)
> +		goto out_unlock;
> +
> +	if (copy_to_user(buf, &watch->event, sizeof(struct vmnotify_event))) {
> +		ret = -EFAULT;
> +		goto out_unlock;
> +	}
> +
> +	ret = watch->event.size;
> +
> +	watch->pending = false;
> +
> +out_unlock:
> +	mutex_unlock(&watch->mutex);
> +
> +	return ret;
> +}

So this is a nonblocking-only interface?  That may surprise some
developers.  You already have a wait queue, why not wait on it if need be?

> +static int vmnotify_copy_config(struct vmnotify_config __user *uconfig,
> +				struct vmnotify_config *config)
> +{
> +	int ret;
> +
> +	ret = copy_from_user(config, uconfig, sizeof(struct vmnotify_config));
> +	if (ret)
> +		return -EFAULT;
> +
> +	if (!config->type)
> +		return -EINVAL;
> +
> +	if (config->type & VMNOTIFY_TYPE_SAMPLE) {
> +		if (config->sample_period_ns < NSEC_PER_MSEC)
> +			return -EINVAL;
> +	}

What happens if the sample period is zero?

jon
