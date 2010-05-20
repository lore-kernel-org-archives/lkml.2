Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754451Ab0ETL2w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 07:28:52 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:49848 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865Ab0ETL2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 07:28:50 -0400
Message-ID: <4BF51B52.70308@ct.jp.nec.com>
Date: Thu, 20 May 2010 20:21:54 +0900
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090825)
MIME-Version: 1.0
To: Mike Snitzer <snitzer@redhat.com>
CC: Nikanth Karthikesan <knikanth@suse.de>, linux-kernel@vger.kernel.org,
       dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
       Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [RFC PATCH 2/2] dm: only initialize full request_queue for request-based
 device
References: <4BEA659F.9050206@ct.jp.nec.com> <20100513035750.GA25523@redhat.com> <4BED049C.5040409@ct.jp.nec.com> <20100514140852.GA10373@redhat.com> <4BF10BF1.3040108@ct.jp.nec.com> <20100517172737.GA24591@redhat.com> <4BF25091.3000507@ct.jp.nec.com> <20100518134639.GA27582@redhat.com> <4BF37DD5.9050409@ct.jp.nec.com> <AANLkTinndXq8DkMBOUf5z8R_8lWRoRbDuOZ1LEmWeI21@mail.gmail.com> <20100519143900.GC24618@redhat.com>
In-Reply-To: <20100519143900.GC24618@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

On 05/19/2010 11:39 PM +0900, Mike Snitzer wrote:
> Mike Snitzer <snitzer@redhat.com> wrote:
>> On Wed, May 19, 2010 at 1:57 AM, Kiyoshi Ueda <k-ueda@ct.jp.nec.com> wrote:
>>> On 05/18/2010 10:46 PM +0900, Mike Snitzer wrote:
>>>> I'll post v5 of the overall patch which will revert the mapped_device
>>>> 'queue_lock' serialization that I proposed in v4.  v5 will contain
>>>> the following patch to localize all table load related queue
>>>> manipulation to the _hash_lock protected critical section in
>>>> table_load().  So it sets the queue up _after_ the table's type is
>>>> established with dm_table_set_type().
>>>
>>> dm_table_setup_md_queue() may allocate memory with blocking mode.
>>> Blocking allocation inside exclusive _hash_lock can cause deadlock;
>>> e.g. when it has to wait for other dm devices to resume to free some
>>> memory.
>>
>> We make no guarantees that other DM devices will resume before a table
>> load -- so calling dm_table_setup_md_queue() within the exclusive
>> _hash_lock is no different than other DM devices being suspended while
>> a request-based DM device performs its first table_load().
>>
>> My thinking was this should not be a problem as it is only valid to
>> call dm_table_setup_md_queue() before the newly created request-based
>> DM device has been resumed.
>>
>> AFAIK we don't have any explicit constraints on memory allocations
>> during table load (e.g. table loads shouldn't depend on other devices'
>> writeback) -- but any GFP_KERNEL allocation could recurse
>> (elevator_alloc() currently uses GFP_KERNEL with kmalloc_node)...
>>
>> I'll have to review the DM code further to see if all memory
>> allocations during table_load() are done via mempools.  I'll also
>> bring this up on this week's LVM call.
> 
> We discussed this and I understand the scope of the problem now.
> 
> Just reiterating what you covered when you first pointed this issue out:
> 
> It could be that a table load gets blocked (waiting on a memory
> allocation).  The table load can take as long as it needs.  But we can't
> have it block holding the exclusive _hash_lock while blocking.  Having
> _hash_lock prevents further DM ioctls.  The table load's allocation may
> be blocking waiting for writeback to a DM device that will be resumed by
> another thread.

That's right.
 
> Thanks again for pointing this out; I'll work to arrive at an
> alternative locking scheme.  Likely introduce a lock local to the
> multiple_device (effectively the 'queue_lock' I had before).  But
> difference is I'd take that lock before taking _hash_lock.

You have to see do_resume(), too.
do_resume() gets hc->new_map with _hash_lock held but without your
'queue_lock' held.  This could cause inconsistent status;
  table_load() for bio-based table    do_resume() for rq-based table
  --------------------------------------------------------------------
  dm_lock_md_queue(md)
  dm_table_setup_md_queue(t) (<= bio-based)
    dm_clear_request_based_queue(md)
      md->queue->request_fn = NULL
                                       down_write(_hash_lock)
                                       new_map = hc->new_map (<= rq-based)
                                       up_write(_hash_lock)
                                       dm_swap_table(md, new_map)
                                       __bind(md, new_map) (<= rq-based)
  down_write(_hash_lock)
  hc->new_map = t
  up_write(_hash_lock)
  dm_unlock_md_queue(md)
 
Other ioctls might be as well, since I have checked only interaction
between table load and resume.


> I hope to have v6 available at some point today but it may be delayed by
> a day.

Sorry for repeating but since you are trying to change the current dm
model, please design/consider it carefully; what objects/ioctls are
involved and how you change their relationships, where are the critical
sections and how you protect them.
Otherwise, I'm afraid we will just spend your time in transforming
one bug to another. (and my time for reviewing and verifying problems :)


>>> Also, your patch changes the queue configuration even when a table is
>>> already active and used.  (e.g. Loading bio-based table to a mapped_device
>>> which is already active/used as request-based sets q->requst_fn in NULL.)
>>> That could cause some critical problems.
>>
>> Yes, that is possible and I can add additional checks to prevent this.
>> But this speaks to a more general problem with the existing DM code.
>>
>> dm_swap_table() has the negative check to prevent such table loads, e.g.:
>> /* cannot change the device type, once a table is bound */
>>
>> This check should come during table_load, as part of
>> dm_table_set_type(), rather than during table resume.
> 
> I'll look to address this issue in v6 too.

It can race between table_load() and do_resume() as well;
  table_load() for bio-based            do_resume() for rq-based
  ---------------------------------------------------------------------
  dm_table_set_type(t) (<= bio-based)
    live_table = dm_get_live_table(md)
    (assume no live_table yet)
                                        new_map = hc->new_map (<= rq-based)
                                        dm_swap_table(md, new_map)
                                        __bind(md, new_map)
  dm_table_setup_md_queue(t)
    dm_clear_request_based_queue(md)
      md->queue->request_fn = NULL

Thanks,
Kiyoshi Ueda
