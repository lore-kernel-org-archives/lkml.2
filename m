Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932131Ab0GWPHV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 11:07:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39661 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760246Ab0GWPHQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 11:07:16 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cfq-iosched: don't allow aliased requests to starve others
References: <x49zkxuaymb.fsf@segfault.boston.devel.redhat.com>
	<20100723042530.GD11236@redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Fri, 23 Jul 2010 11:07:11 -0400
In-Reply-To: <20100723042530.GD11236@redhat.com> (Vivek Goyal's message of
	"Fri, 23 Jul 2010 00:25:30 -0400")
Message-ID: <x49pqyejkyo.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> On Wed, Jul 14, 2010 at 11:09:48AM -0400, Jeff Moyer wrote:
>> Hi,
>> 
>> In running a test case that tries to trip up the kernel's AIO
>> implementation, we ran into a situation where no other I/O to the device
>> under test would be completed.  The test program spawned (in this case)
>> 100 threads, each of which performed the following in a loop:
>> 
>> open file O_DIRECT
>> queue 1MB of read I/O from file using 16 iocbs
>> close file
>> repeat
>> 
>> The program does NOT wait for the I/O to complete.  The file length is
>> only 4MB, meaning that you have 25 threads performing I/O on each of the
>> 4 1MB regions.
>> 
>> Both deadline and cfq check for aliased requests in the sorted list of
>> I/Os, and when an alias is found, the request in the rb tree is moved to
>> the dispatch list.  So, what happens is that, with this workload, only
>> requests from this program are moved to the dispatch list, starving out
>> all other I/O.
>> 
>> The attached patch fixes this problem by issuing all expired requests in
>> the aliased request handling code.  The reason I opted to issue all
>> expired requsts is because if we only service a single one, I still see
>> really awful interactivity;  an ls would take over 5 minutes to
>> complete.  With the attached patch, the ls took about 7 seconds to
>> complete.
>> 
>> Comments, as always, are welcome.
>> 
>> Cheers,
>> Jeff
>> 
>> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
>> index 7982b83..0d8d2cd 100644
>> --- a/block/cfq-iosched.c
>> +++ b/block/cfq-iosched.c
>> @@ -417,6 +417,7 @@ static inline int cfqg_busy_async_queues(struct cfq_data *cfqd,
>>  }
>>  
>>  static void cfq_dispatch_insert(struct request_queue *, struct request *);
>> +static struct request *cfq_check_fifo(struct cfq_queue *cfqq);
>>  static struct cfq_queue *cfq_get_queue(struct cfq_data *, bool,
>>  				       struct io_context *, gfp_t);
>>  static struct cfq_io_context *cfq_cic_lookup(struct cfq_data *,
>> @@ -1394,10 +1395,22 @@ static void cfq_add_rq_rb(struct request *rq)
>>  
>>  	/*
>>  	 * looks a little odd, but the first insert might return an alias.
>> -	 * if that happens, put the alias on the dispatch list
>> +	 * If that happens, put the alias on the dispatch list, but don't
>> +	 * allow issuing of aliased requests to starve out the queue.
>>  	 */
>> -	while ((__alias = elv_rb_add(&cfqq->sort_list, rq)) != NULL)
>> +	while ((__alias = elv_rb_add(&cfqq->sort_list, rq)) != NULL) {
>> +		int fifo_checked = cfq_cfqq_fifo_expire(cfqq);
>> +		struct request *__rq;
>> +
>>  		cfq_dispatch_insert(cfqd->queue, __alias);
>> +		cfq_clear_cfqq_fifo_expire(cfqq);
>> +		while ((__rq = cfq_check_fifo(cfqq))) {
>> +			cfq_dispatch_insert(cfqd->queue, __rq);
>> +			cfq_clear_cfqq_fifo_expire(cfqq);
>> +		}
>> +		if (fifo_checked)
>> +			cfq_mark_cfqq_fifo_expire(cfqq);
>> +	}
>
> Jeff,
>
> IIUC correctly upon receiving an alias, you are checking fifo of same
> cfqq and not the fifo of other cfqqs which are blocked. So dispatching
> more expired requests from the cfqq which is generating lots of aliases
> can at best only worsen the problem. I am wondering how does this patch
> help in dispatching requests from other cfqqs. 

I think you're missing a key element, here.  Let's assume some harmless
process has the I/O scheduler.  Then, your pathological alias generator
process comes in and inserts a request into the queue.  If that request
is an alias, then it gets moved to the dispatch list immediately, even
though the cfqq for that process is not currently being served.

Now, I'm not sure why we ever get back into select_queue if the request
queue is always full of these aliases.  I didn't dig down that far, but
I did verify that progress was made in my simple reproducer.

> Also for my education purposes I was curious to know that why can't
> we keep aliased requests in the service tree. 

You know, I dug back through the logs, and I didn't find any mention of
that.  The anticipatory scheduler used to allow such aliases, but then
that support was removed in favor of a simpler approach.  So, the reason
may just be out of convenience.

Cheers,
Jeff
