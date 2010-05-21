Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519Ab0EUIgK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 04:36:10 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:62649 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301Ab0EUIgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 04:36:07 -0400
Message-ID: <4BF64538.6010305@ct.jp.nec.com>
Date: Fri, 21 May 2010 17:32:56 +0900
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
References: <4BED049C.5040409@ct.jp.nec.com> <20100514140852.GA10373@redhat.com> <4BF10BF1.3040108@ct.jp.nec.com> <20100517172737.GA24591@redhat.com> <4BF25091.3000507@ct.jp.nec.com> <20100518134639.GA27582@redhat.com> <4BF37DD5.9050409@ct.jp.nec.com> <AANLkTinndXq8DkMBOUf5z8R_8lWRoRbDuOZ1LEmWeI21@mail.gmail.com> <20100519143900.GC24618@redhat.com> <4BF51B52.70308@ct.jp.nec.com> <20100520170732.GA22791@redhat.com>
In-Reply-To: <20100520170732.GA22791@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

On 05/21/2010 02:07 AM +0900, Mike Snitzer wrote:
> Kiyoshi Ueda <k-ueda@ct.jp.nec.com> wrote:
>> On 05/19/2010 11:39 PM +0900, Mike Snitzer wrote:
>>> Thanks again for pointing this out; I'll work to arrive at an
>>> alternative locking scheme.  Likely introduce a lock local to the
>>> multiple_device (effectively the 'queue_lock' I had before).  But
>>> difference is I'd take that lock before taking _hash_lock.
>>
>> You have to see do_resume(), too.
>> do_resume() gets hc->new_map with _hash_lock held but without your
>> 'queue_lock' held.  This could cause inconsistent status;
>>   table_load() for bio-based table    do_resume() for rq-based table
>>   --------------------------------------------------------------------
>>   dm_lock_md_queue(md)
>>   dm_table_setup_md_queue(t) (<= bio-based)
>>     dm_clear_request_based_queue(md)
>>       md->queue->request_fn = NULL
>>                                        down_write(_hash_lock)
>>                                        new_map = hc->new_map (<= rq-based)
>>                                        up_write(_hash_lock)
>>                                        dm_swap_table(md, new_map)
>>                                        __bind(md, new_map) (<= rq-based)
>>   down_write(_hash_lock)
>>   hc->new_map = t
>>   up_write(_hash_lock)
>>   dm_unlock_md_queue(md)
snip
>>>>> Also, your patch changes the queue configuration even when a table is
>>>>> already active and used.  (e.g. Loading bio-based table to a mapped_device
>>>>> which is already active/used as request-based sets q->requst_fn in NULL.)
>>>>> That could cause some critical problems.
>>>>
>>>> Yes, that is possible and I can add additional checks to prevent this.
>>>> But this speaks to a more general problem with the existing DM code.
>>>>
>>>> dm_swap_table() has the negative check to prevent such table loads, e.g.:
>>>> /* cannot change the device type, once a table is bound */
>>>>
>>>> This check should come during table_load, as part of
>>>> dm_table_set_type(), rather than during table resume.
>>>
>>> I'll look to address this issue in v6 too.
>>
>> It can race between table_load() and do_resume() as well;
>>   table_load() for bio-based            do_resume() for rq-based
>>   ---------------------------------------------------------------------
>>   dm_table_set_type(t) (<= bio-based)
>>     live_table = dm_get_live_table(md)
>>     (assume no live_table yet)
>>                                         new_map = hc->new_map (<= rq-based)
>>                                         dm_swap_table(md, new_map)
>>                                         __bind(md, new_map)
>>   dm_table_setup_md_queue(t)
>>     dm_clear_request_based_queue(md)
>>       md->queue->request_fn = NULL
> 
> Understood.
> 
> I've addressed the above races by:
> 1) properly protecting md->queue during do_resume().  Both do_resume()
>    and table_load() first take md->queue_lock and then _hash_lock.
> 2) adding a negative check for an existing live table to
>    dm_table_setup_md_queue().
> 
> I will mail out v7 after I've given it additional review.

dm_table_setup_md_queue() may allocate memory with blocking mode
inside md->queue_lock which is needed to resume the md.
That could cause a deadlock which doesn't happen in the current model;
e.g:
  - Assume a bio-based table has been already loaded in hc->new_map
    and no live table yet in a mapped_device.
  - Load a request-based table and then no memory situation happens
    in dm_table_setup_md_queue().
  - Then, the mapped_device can't be resumed even in the case that
    resuming the mapped_device with the preloaded bio-based table
    can make some memory by writeback.
  => deadlock

Thanks,
Kiyoshi Ueda
