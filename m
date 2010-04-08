Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933141Ab0DHTLZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 15:11:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32064 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933059Ab0DHTLH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 15:11:07 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Vivek Goyal <vgoyal@redhat.com>,
       linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch,rfc v2] ext3/4: enhance fsync performance when using cfq
References: <x49ochv7yi3.fsf@segfault.boston.devel.redhat.com>
	<20100408110045.GJ10103@kernel.dk>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 08 Apr 2010 15:10:58 -0400
In-Reply-To: <20100408110045.GJ10103@kernel.dk> (Jens Axboe's message of "Thu,
	8 Apr 2010 13:00:45 +0200")
Message-ID: <x497hohpxod.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe <jens.axboe@oracle.com> writes:

>> @@ -2065,7 +2065,7 @@ static void cfq_choose_cfqg(struct cfq_data *cfqd)
>>  	cfqd->serving_group = cfqg;
>>  
>>  	/* Restore the workload type data */
>> -	if (cfqg->saved_workload_slice) {
>> +	if (cfqg && cfqg->saved_workload_slice) {
>>  		cfqd->workload_expires = jiffies + cfqg->saved_workload_slice;
>>  		cfqd->serving_type = cfqg->saved_workload;
>>  		cfqd->serving_prio = cfqg->saved_serving_prio;
>
> Unrelated change?

Probably not needed for this incarnation of the patch, though previous
iterations would Oops on boot w/o this.  If you look through all of the
code in this code path, cfqg == NULL seems to be handled, so it's
probably safe to take this.  I'll pull it out of this patch, though.

>> +static void cfq_yield(struct request_queue *q)
>> +{
>> +	struct cfq_data *cfqd = q->elevator->elevator_data;
>> +	struct cfq_io_context *cic;
>> +	struct cfq_queue *cfqq;
>> +	unsigned long flags;
>> +
>> +	cic = cfq_cic_lookup(cfqd, current->io_context);
>> +	if (!cic)
>> +		return;
>> +
>> +	spin_lock_irqsave(q->queue_lock, flags);
>
> spin_lock_irq() is sufficient here.

OK, thanks!

Jeff
