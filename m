Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832Ab2IAN67 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2012 09:58:59 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:60186 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752097Ab2IAN66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2012 09:58:58 -0400
Message-ID: <50421493.1020703@tao.ma>
Date: Sat, 01 Sep 2012 21:58:43 +0800
From: Tao Ma <tm@tao.ma>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH V2] block/throttle: Add IO throttled information in blkio.throttle.
References: <1346390109-3169-1-git-send-email-tm@tao.ma> <20120901010540.GA19535@dhcp-172-17-108-109.mtv.corp.google.com>
In-Reply-To: <20120901010540.GA19535@dhcp-172-17-108-109.mtv.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 114.254.77.70 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,
On 09/01/2012 09:05 AM, Tejun Heo wrote:
> On Fri, Aug 31, 2012 at 01:15:09PM +0800, Tao Ma wrote:
>> From: Tao Ma <boyu.mt@taobao.com>
>>
>> Currently, if the IO is throttled by io-throttle, the SA has no idea of
> 
> What's SA?
system admin.
> 
>> the situation and can't report it to the real application user about
>> that he/she has to do something. So this patch adds a new interface
> 
> Why does the application user "has to" do something?  There's nothing
> the upper layer "must" do.  I'm not necessarily objecting to adding
> the stat but the description seems a bit misleading.
> 
>> named blkio.throttle.io_queued which indicates how many IOs are
>> currently throttled.
> 
> Also, the suggested stat is rather lacking for such purposes.  There's
> no way other than keeping polling to find out the condition, which is
> rather sad.  What's the actual use case here?
Vivek and I have talked about its usage in my first try. See the thread
here. https://lkml.org/lkml/2012/5/22/81
And I am OK to say it again here. In our case, we use flashcache as a
block device and the bad thing is that flashcache is a bio-based dm
target and we can't use block io controller here to control the weight
of different cgroups. So io throttle is chosen. But as io throttle can
only set a hard upper limit for different instances, it makes the
control not flexible enough. Say with io controller, if there is no
requests form the cgroup with weight 1000, a cgroup with 500 can use the
whole bandwidth of the underlying device. But if we set 1000 iops for
cgroup A and 500 iops for cgroup B in io throttle, cgroup B can't exceed
its limit even if cgroup A has no request pending. So if we can export
the io_queued information out to the system admin, they can write some
daemon and in the above case, increase the upper limit of cgroup B to
some number say 1000. It helps us to utilize the device more
efficiently. Does it make sense to you?


> 
>> Also another function blkg_rwstat_dec is added since the number of throttled
>> IOs can be either added or decreased.
> 
> Maybe just make blkg_rwstat_add() to take int64_t instead of uint64_t?
sure, will change it in the later version.
> 
>> +static void throtl_update_queued_stats(struct throtl_grp *tg, int rw, int add)
>> +{
>> +	struct tg_stats_cpu *stats_cpu;
>> +	unsigned long flags;
>> +
>> +	/* If per cpu stats are not allocated yet, don't do any accounting. */
>> +	if (tg->stats_cpu == NULL)
>> +		return;
>> +
>> +	/*
>> +	 * Disabling interrupts to provide mutual exclusion between two
>> +	 * writes on same cpu. It probably is not needed for 64bit. Not
>> +	 * optimizing that case yet.
>> +	 */
>> +	local_irq_save(flags);
>> +
>> +	stats_cpu = this_cpu_ptr(tg->stats_cpu);
>> +	if (add)
>> +		blkg_rwstat_add(&stats_cpu->io_queued, rw, 1);
>> +	else
>> +		blkg_rwstat_dec(&stats_cpu->io_queued, rw, 1);
>> +
>> +	local_irq_restore(flags);
> 
> Adding throttle.io_queued could be a bit more consistent?
sorry, I don't know what is your meaning here. You mean some codes like
	blkg_rwstat_add(&stats_cpu->throttle.io_queude, rw, 1)?

Thanks
Tao
