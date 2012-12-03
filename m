Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755198Ab2LCPtb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 10:49:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24185 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753906Ab2LCPt3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 10:49:29 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Zach Brown <zab@redhat.com>
Cc: Jens Axboe <jaxboe@fusionio.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [patch] bdi: add a user-tunable cpu_list for the bdi flusher threads
References: <x49boehtipu.fsf@segfault.boston.devel.redhat.com>
	<20121130221542.GM18574@lenny.home.zabbo.net>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 03 Dec 2012 10:49:25 -0500
In-Reply-To: <20121130221542.GM18574@lenny.home.zabbo.net> (Zach Brown's
	message of "Fri, 30 Nov 2012 14:15:42 -0800")
Message-ID: <x49zk1vnnju.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zach Brown <zab@redhat.com> writes:

>> +	ret = cpulist_parse(buf, newmask);
>> +	if (!ret) {
>> +		spin_lock(&bdi->wb_lock);
>> +		task = wb->task;
>> +		get_task_struct(task);
>> +		spin_unlock(&bdi->wb_lock);
>> +		if (task)
>> +			ret = set_cpus_allowed_ptr(task, newmask);
>> +		put_task_struct(task);
>
> If that test for a non-null task is needed then surely the get and put
> need to be similarly protected :).

How embarrassing.

>> +		bdi->flusher_cpumask = kmalloc(sizeof(cpumask_t), GFP_KERNEL);
>> +		if (!bdi->flusher_cpumask)
>> +			return -ENOMEM;
>
> The bare GFP_KERNEL raises an eyebrow.  Some bdi_init() callers like
> blk_alloc_queue_node() look like they'll want to pass in a gfp_t for the
> allocation.

I'd be surprised if that was necessary, seeing how every single caller
of blk_alloc_queue_node passes in GFP_KERNEL.  I'll make the change,
though, there aren't too many callers of bdi_init out there.

> And shouldn't this be freed in the error path of bdi_init()?

Yes.  ;-)

Thanks!
Jeff
