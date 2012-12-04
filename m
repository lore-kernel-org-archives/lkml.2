Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804Ab2LDU1O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 15:27:14 -0500
Received: from mx1.fusionio.com ([66.114.96.30]:35077 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751795Ab2LDU1J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 15:27:09 -0500
X-ASG-Debug-ID: 1354652828-03d6a57f9b279190001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <50BE5C99.6070703@fusionio.com>
Date: Tue, 4 Dec 2012 21:27:05 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>, Zach Brown <zab@redhat.com>
Subject: Re: [patch,v2] bdi: add a user-tunable cpu_list for the bdi flusher
 threads
References: <x49lidfnf0s.fsf@segfault.boston.devel.redhat.com> <50BE5988.3050501@fusionio.com> <x498v9dpnwu.fsf@segfault.boston.devel.redhat.com>
X-ASG-Orig-Subj: Re: [patch,v2] bdi: add a user-tunable cpu_list for the bdi flusher
 threads
In-Reply-To: <x498v9dpnwu.fsf@segfault.boston.devel.redhat.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1354652828
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.116098
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-12-04 21:23, Jeff Moyer wrote:
> Jens Axboe <jaxboe@fusionio.com> writes:
> 
>> On 2012-12-03 19:53, Jeff Moyer wrote:
>>> Hi,
>>>
>>> In realtime environments, it may be desirable to keep the per-bdi
>>> flusher threads from running on certain cpus.  This patch adds a
>>> cpu_list file to /sys/class/bdi/* to enable this.  The default is to tie
>>> the flusher threads to the same numa node as the backing device (though
>>> I could be convinced to make it a mask of all cpus to avoid a change in
>>> behaviour).
>>
>> Looks sane, and I think defaulting to the home node is a sane default.
>> One comment:
>>
>>> +	ret = cpulist_parse(buf, newmask);
>>> +	if (!ret) {
>>> +		spin_lock(&bdi->wb_lock);
>>> +		task = wb->task;
>>> +		if (task)
>>> +			get_task_struct(task);
>>> +		spin_unlock(&bdi->wb_lock);
>>
>> bdi->wb_lock needs to be bh safe. The above should have caused lockdep
>> warnings for you.
> 
> No lockdep complaints.  I'll double check that's enabled (but I usually
> have it enabled...).
> 
>>> @@ -437,6 +488,14 @@ static int bdi_forker_thread(void *ptr)
>>>  				spin_lock_bh(&bdi->wb_lock);
>>>  				bdi->wb.task = task;
>>>  				spin_unlock_bh(&bdi->wb_lock);
>>> +				mutex_lock(&bdi->flusher_cpumask_mutex);
>>> +				ret = set_cpus_allowed_ptr(task,
>>> +							bdi->flusher_cpumask);
>>> +				mutex_unlock(&bdi->flusher_cpumask_mutex);
>>
>> It'd be very useful if we had a kthread_create_cpu_on_cpumask() instead
>> of a _node() variant, since the latter could easily be implemented on
>> top of the former. But not really a show stopper for the patch...
> 
> Hmm, if it isn't too scary, I might give this a try.

Should not be, pretty much just removing the node part of the create
struct passed in and making it a cpumask. And for the on_node() case,
cpumask_of_ndoe() will do the trick.

-- 
Jens Axboe

