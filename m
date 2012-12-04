Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984Ab2LDOnM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 09:43:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60993 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751903Ab2LDOnK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 09:43:10 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Jens Axboe <jaxboe@fusionio.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Zach Brown <zab@redhat.com>
Subject: Re: [patch,v2] bdi: add a user-tunable cpu_list for the bdi flusher threads
References: <x49lidfnf0s.fsf@segfault.boston.devel.redhat.com>
	<20121204023405.GE32450@dastard>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 04 Dec 2012 09:42:55 -0500
In-Reply-To: <20121204023405.GE32450@dastard> (Dave Chinner's message of "Tue,
	4 Dec 2012 13:34:05 +1100")
Message-ID: <x49liddq3o0.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Chinner <david@fromorbit.com> writes:

> On Mon, Dec 03, 2012 at 01:53:39PM -0500, Jeff Moyer wrote:
>> +static ssize_t cpu_list_store(struct device *dev,
>> +		struct device_attribute *attr, const char *buf, size_t count)
>> +{
>> +	struct backing_dev_info *bdi = dev_get_drvdata(dev);
>> +	struct bdi_writeback *wb = &bdi->wb;
>> +	cpumask_var_t newmask;
>> +	ssize_t ret;
>> +	struct task_struct *task;
>> +
>> +	if (!alloc_cpumask_var(&newmask, GFP_KERNEL))
>> +		return -ENOMEM;
>> +
>> +	ret = cpulist_parse(buf, newmask);
>> +	if (!ret) {
>> +		spin_lock(&bdi->wb_lock);
>> +		task = wb->task;
>> +		if (task)
>> +			get_task_struct(task);
>> +		spin_unlock(&bdi->wb_lock);
>> +		if (task) {
>> +			ret = set_cpus_allowed_ptr(task, newmask);
>> +			put_task_struct(task);
>> +		}
>
> Why is this set here outside the bdi->flusher_cpumask_mutex?

The cpumask mutex protects updates to bdi->flusher_cpumask, it has
nothing to do with the call to set_cpus_allowed.  We are protected from
concurrent calls to cpu_list_store by the sysfs mutex that is taken on
entry.  I understand that this is non-obvious, and it wouldn't be wrong
to hold the mutex here.  If you'd like me to do that for clarity, that
would be ok with me.

> Also, I'd prefer it named "..._lock" as that is the normal
> convention for such variables. You can tell the type of lock from
> the declaration or the use...

I'm sure I can find counter-examples, but it doesn't really matter to
me.  I'll change it.

>> @@ -437,6 +488,14 @@ static int bdi_forker_thread(void *ptr)
>>  				spin_lock_bh(&bdi->wb_lock);
>>  				bdi->wb.task = task;
>>  				spin_unlock_bh(&bdi->wb_lock);
>> +				mutex_lock(&bdi->flusher_cpumask_mutex);
>> +				ret = set_cpus_allowed_ptr(task,
>> +							bdi->flusher_cpumask);
>> +				mutex_unlock(&bdi->flusher_cpumask_mutex);
>
> As it is set under the lock here....

It's done under the lock here since we need to keep bdi->flusher_cpumask
from changing during the call to set_cpus_allowed.

Cheers,
Jeff
