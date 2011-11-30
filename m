Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753049Ab1K3XrW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 18:47:22 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56397 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133Ab1K3XrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 18:47:21 -0500
Date: Wed, 30 Nov 2011 15:47:19 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Petr Holasek <pholasek@redhat.com>
Cc: Hugh Dickins <hughd@google.com>, Andrea Arcangeli <aarcange@redhat.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Anton Arapov <anton@redhat.com>
Subject: Re: [PATCH] [RFC] KSM: numa awareness sysfs knob
Message-Id: <20111130154719.57154fdd.akpm@linux-foundation.org>
In-Reply-To: <1322649446-11437-1-git-send-email-pholasek@redhat.com>
References: <1322649446-11437-1-git-send-email-pholasek@redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Nov 2011 11:37:26 +0100
Petr Holasek <pholasek@redhat.com> wrote:

> Introduce a new sysfs knob /sys/kernel/mm/ksm/max_node_dist, whose
> value will be used as the limitation for node distance of merged pages.
> 

The changelog doesn't really describe why you think Linux needs this
feature?  What's the reasoning?  Use cases?  What value does it provide?

> index b392e49..b882140 100644
> --- a/Documentation/vm/ksm.txt
> +++ b/Documentation/vm/ksm.txt
> @@ -58,6 +58,10 @@ sleep_millisecs  - how many milliseconds ksmd should sleep before next scan
>                     e.g. "echo 20 > /sys/kernel/mm/ksm/sleep_millisecs"
>                     Default: 20 (chosen for demonstration purposes)
>  
> +max_node_dist    - maximum node distance between two pages which could be
> +                   merged.
> +                   Default: 255 (without any limitations)

And this doesn't explain to our users why they might want to alter it,
and what effects they would see from doing so.  Maybe that's obvious to
them...

>  run              - set 0 to stop ksmd from running but keep merged pages,
>                     set 1 to run ksmd e.g. "echo 1 > /sys/kernel/mm/ksm/run",
>                     set 2 to stop ksmd and unmerge all pages currently merged,
>
> ...
>
> +#ifdef CONFIG_NUMA
> +static inline int node_dist(int from, int to)
> +{
> +	int dist = node_distance(from, to);
> +
> +	return dist == -1 ? 0 : dist;
> +}

So I spent some time grubbing around trying to work out what a return
value of -1 from node_distance() means, and wasn't successful.  Perhaps
an explanatory comment here would have helped.

> +#else
> +static inline int node_dist(int from, int to)
> +{
> +	return 0;
> +}
> +#endif
>
> ...
>
> +static ssize_t max_node_dist_store(struct kobject *kobj,
> +				   struct kobj_attribute *attr,
> +				   const char *buf, size_t count)
> +{
> +	int err;
> +	unsigned long node_dist;
> +
> +	err = kstrtoul(buf, 10, &node_dist);
> +	if (err || node_dist > 255)
> +		return -EINVAL;

If kstrtoul() returned an errno we should propagate that back rather than
overwriting it with -EINVAL.

> +	ksm_node_distance = node_dist;
> +
> +	return count;
> +}
>
> ...
>

