Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284Ab2H0PyO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 11:54:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17287 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752692Ab2H0PyL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 11:54:11 -0400
Date: Mon, 27 Aug 2012 17:53:32 +0200
From: Andrew Jones <drjones@redhat.com>
To: Dong Hao <haodong@linux.vnet.ibm.com>
Cc: avi@redhat.com, acme@infradead.org, mtosatti@redhat.com, mingo@elte.hu,
        xiaoguangrong@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v7 3/3] KVM: perf: kvm events analysis tool
Message-ID: <20120827155331.GA18224@turtle.usersys.redhat.com>
References: <1346061106-5364-1-git-send-email-haodong@linux.vnet.ibm.com>
 <1346061106-5364-4-git-send-email-haodong@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346061106-5364-4-git-send-email-haodong@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 27, 2012 at 05:51:46PM +0800, Dong Hao wrote:

<snip>

> +struct event_stats {
> +	u64 count;
> +	u64 time;
> +
> +	/* used to calculate stddev. */
> +	double mean;
> +	double M2;
> +};

How about moving the stats functions from builtin-stat.c to e.g.
util/stats.c, and then reusing them? Then this struct (which I would
rename to kvm_event_stats) would look like this

struct kvm_event_stats {
        u64 time;
        struct stats stats;
};

of course the get_event_ accessor generators would need tweaking

<snip>

> +static void update_event_stats(struct event_stats *stats, u64 time_diff)
> +{
> +	double delta;
> +
> +	stats->count++;
> +	stats->time += time_diff;
> +
> +	delta = time_diff - stats->mean;
> +	stats->mean += delta / stats->count;
> +	stats->M2 += delta*(time_diff - stats->mean);
> +}

Reusing stats would allow this to become just

static void update_event_stats(struct kvm_event_stats *stats, u64 time_diff)
{
	update_stats(&kvm_stats->stats, time_diff);
	kvm_stats->time += time_diff;
}

> +
> +static double event_stats_stddev(int vcpu_id, struct kvm_event *event)
> +{
> +	struct event_stats *stats = &event->total;
> +	double variance, variance_mean, stddev;
> +
> +	if (vcpu_id != -1)
> +		stats = &event->vcpu[vcpu_id];
> +
> +	BUG_ON(!stats->count);
> +
> +	variance = stats->M2 / (stats->count - 1);
> +	variance_mean = variance / stats->count;
> +	stddev = sqrt(variance_mean);
> +
> +	return stddev * 100 / stats->mean;

This function's name implies it returns the stddev, but it returns the
relative stddev instead. Maybe rename it? This would be simplified
with code reuse too to basically just

return stddev_stats(&kvm_stats->stats) * 100 / kvm_stats->stats.mean;

Drew
