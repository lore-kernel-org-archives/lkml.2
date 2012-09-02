Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833Ab2IBNvZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 09:51:25 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:47841 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762Ab2IBNvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 09:51:23 -0400
Message-ID: <50436452.2010405@linux.vnet.ibm.com>
Date: Sun, 02 Sep 2012 21:51:14 +0800
From: don <haodong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Andrew Jones <drjones@redhat.com>
CC: avi@redhat.com, acme@infradead.org, mtosatti@redhat.com, mingo@elte.hu,
        xiaoguangrong@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, dsahern@gmail.com
Subject: Re: [PATCH v7 3/3] KVM: perf: kvm events analysis tool
References: <1346061106-5364-1-git-send-email-haodong@linux.vnet.ibm.com> <1346061106-5364-4-git-send-email-haodong@linux.vnet.ibm.com> <20120827155331.GA18224@turtle.usersys.redhat.com>
In-Reply-To: <20120827155331.GA18224@turtle.usersys.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
x-cbid: 12090213-3568-0000-0000-00000266ED07
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2012年08月27日 23:53, Andrew Jones 写道:
> On Mon, Aug 27, 2012 at 05:51:46PM +0800, Dong Hao wrote:
>
> <snip>
>
>> +struct event_stats {
>> +	u64 count;
>> +	u64 time;
>> +
>> +	/* used to calculate stddev. */
>> +	double mean;
>> +	double M2;
>> +};
> How about moving the stats functions from builtin-stat.c to e.g.
> util/stats.c, and then reusing them? Then this struct (which I would
> rename to kvm_event_stats) would look like this
>
> struct kvm_event_stats {
>          u64 time;
>          struct stats stats;
> };
>
> of course the get_event_ accessor generators would need tweaking
>
> <snip>
>
>> +static void update_event_stats(struct event_stats *stats, u64 time_diff)
>> +{
>> +	double delta;
>> +
>> +	stats->count++;
>> +	stats->time += time_diff;
>> +
>> +	delta = time_diff - stats->mean;
>> +	stats->mean += delta / stats->count;
>> +	stats->M2 += delta*(time_diff - stats->mean);
>> +}
> Reusing stats would allow this to become just
>
> static void update_event_stats(struct kvm_event_stats *stats, u64 time_diff)
> {
> 	update_stats(&kvm_stats->stats, time_diff);
> 	kvm_stats->time += time_diff;
> }
>
>> +
>> +static double event_stats_stddev(int vcpu_id, struct kvm_event *event)
>> +{
>> +	struct event_stats *stats = &event->total;
>> +	double variance, variance_mean, stddev;
>> +
>> +	if (vcpu_id != -1)
>> +		stats = &event->vcpu[vcpu_id];
>> +
>> +	BUG_ON(!stats->count);
>> +
>> +	variance = stats->M2 / (stats->count - 1);
>> +	variance_mean = variance / stats->count;
>> +	stddev = sqrt(variance_mean);
>> +
>> +	return stddev * 100 / stats->mean;
> This function's name implies it returns the stddev, but it returns the
> relative stddev instead. Maybe rename it? This would be simplified
> with code reuse too to basically just
>
> return stddev_stats(&kvm_stats->stats) * 100 / kvm_stats->stats.mean;
>
> Drew
>
Sorry for my late response, Andrew and thank you very much for your 
comments. We will try
to realize it in our next version.

Thanks,
Dong

