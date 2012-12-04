Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752314Ab2LDUXS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 15:23:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24176 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751144Ab2LDUXR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 15:23:17 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm\@kvack.org" <linux-mm@kvack.org>,
        Zach Brown <zab@redhat.com>
Subject: Re: [patch,v2] bdi: add a user-tunable cpu_list for the bdi flusher threads
References: <x49lidfnf0s.fsf@segfault.boston.devel.redhat.com>
	<50BE5988.3050501@fusionio.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 04 Dec 2012 15:23:13 -0500
In-Reply-To: <50BE5988.3050501@fusionio.com> (Jens Axboe's message of "Tue, 4
	Dec 2012 21:14:00 +0100")
Message-ID: <x498v9dpnwu.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe <jaxboe@fusionio.com> writes:

> On 2012-12-03 19:53, Jeff Moyer wrote:
>> Hi,
>> 
>> In realtime environments, it may be desirable to keep the per-bdi
>> flusher threads from running on certain cpus.  This patch adds a
>> cpu_list file to /sys/class/bdi/* to enable this.  The default is to tie
>> the flusher threads to the same numa node as the backing device (though
>> I could be convinced to make it a mask of all cpus to avoid a change in
>> behaviour).
>
> Looks sane, and I think defaulting to the home node is a sane default.
> One comment:
>
>> +	ret = cpulist_parse(buf, newmask);
>> +	if (!ret) {
>> +		spin_lock(&bdi->wb_lock);
>> +		task = wb->task;
>> +		if (task)
>> +			get_task_struct(task);
>> +		spin_unlock(&bdi->wb_lock);
>
> bdi->wb_lock needs to be bh safe. The above should have caused lockdep
> warnings for you.

No lockdep complaints.  I'll double check that's enabled (but I usually
have it enabled...).

>> @@ -437,6 +488,14 @@ static int bdi_forker_thread(void *ptr)
>>  				spin_lock_bh(&bdi->wb_lock);
>>  				bdi->wb.task = task;
>>  				spin_unlock_bh(&bdi->wb_lock);
>> +				mutex_lock(&bdi->flusher_cpumask_mutex);
>> +				ret = set_cpus_allowed_ptr(task,
>> +							bdi->flusher_cpumask);
>> +				mutex_unlock(&bdi->flusher_cpumask_mutex);
>
> It'd be very useful if we had a kthread_create_cpu_on_cpumask() instead
> of a _node() variant, since the latter could easily be implemented on
> top of the former. But not really a show stopper for the patch...

Hmm, if it isn't too scary, I might give this a try.

Thanks!
Jeff
