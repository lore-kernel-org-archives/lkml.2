Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425Ab2LDW0e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 17:26:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34941 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751836Ab2LDW0c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 17:26:32 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm\@kvack.org" <linux-mm@kvack.org>,
        Zach Brown <zab@redhat.com>, tj@kernel.org,
        Peter Zijlstra <pzijlstr@redhat.com>, Ingo <mingo@redhat.com>
Subject: Re: [patch,v2] bdi: add a user-tunable cpu_list for the bdi flusher threads
References: <x49lidfnf0s.fsf@segfault.boston.devel.redhat.com>
	<50BE5988.3050501@fusionio.com>
	<x498v9dpnwu.fsf@segfault.boston.devel.redhat.com>
	<50BE5C99.6070703@fusionio.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 04 Dec 2012 17:26:26 -0500
In-Reply-To: <50BE5C99.6070703@fusionio.com> (Jens Axboe's message of "Tue, 4
	Dec 2012 21:27:05 +0100")
Message-ID: <x494nk1pi7h.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe <jaxboe@fusionio.com> writes:

>>>> @@ -437,6 +488,14 @@ static int bdi_forker_thread(void *ptr)
>>>>  				spin_lock_bh(&bdi->wb_lock);
>>>>  				bdi->wb.task = task;
>>>>  				spin_unlock_bh(&bdi->wb_lock);
>>>> +				mutex_lock(&bdi->flusher_cpumask_mutex);
>>>> +				ret = set_cpus_allowed_ptr(task,
>>>> +							bdi->flusher_cpumask);
>>>> +				mutex_unlock(&bdi->flusher_cpumask_mutex);
>>>
>>> It'd be very useful if we had a kthread_create_cpu_on_cpumask() instead
>>> of a _node() variant, since the latter could easily be implemented on
>>> top of the former. But not really a show stopper for the patch...
>> 
>> Hmm, if it isn't too scary, I might give this a try.
>
> Should not be, pretty much just removing the node part of the create
> struct passed in and making it a cpumask. And for the on_node() case,
> cpumask_of_ndoe() will do the trick.

I think it's a bit more involved than that.  If you look at
kthread_create_on_node, the node portion only applies to where the
memory comes from, it says nothing of scheduling.  To whit:

                /*                                                              
                 * root may have changed our (kthreadd's) priority or CPU mask.
                 * The kernel thread should not inherit these properties.       
                 */
                sched_setscheduler_nocheck(create.result, SCHED_NORMAL, &param);
                set_cpus_allowed_ptr(create.result, cpu_all_mask);

So, if I were to make the change you suggested, I would be modifying the
existing behaviour.  The way things stand, I think
kthread_create_on_node violates the principal of least surprise.  ;-)  I
would prefer a variant that affected scheduling behaviour as well as
memory placement.  Tejun, Peter, Ingo, what are your opinions?

Cheers,
Jeff
