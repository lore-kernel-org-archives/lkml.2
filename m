Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752340Ab0ESF7G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 01:59:06 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:65062 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831Ab0ESF7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 01:59:04 -0400
Message-ID: <4BF37DD5.9050409@ct.jp.nec.com>
Date: Wed, 19 May 2010 14:57:41 +0900
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090825)
MIME-Version: 1.0
To: Mike Snitzer <snitzer@redhat.com>
CC: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>,
       "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
       Vivek Goyal <vgoyal@redhat.com>, Nikanth Karthikesan <knikanth@suse.de>,
       Alasdair Kergon <agk@redhat.com>
Subject: Re: [RFC PATCH 2/2] dm: only initialize full request_queue for request-based
 device
References: <1273532139-23043-2-git-send-email-snitzer@redhat.com> <4BE8DBB0.5060701@ct.jp.nec.com> <20100511131502.GA25211@redhat.com> <4BEA659F.9050206@ct.jp.nec.com> <20100513035750.GA25523@redhat.com> <4BED049C.5040409@ct.jp.nec.com> <20100514140852.GA10373@redhat.com> <4BF10BF1.3040108@ct.jp.nec.com> <20100517172737.GA24591@redhat.com> <4BF25091.3000507@ct.jp.nec.com> <20100518134639.GA27582@redhat.com>
In-Reply-To: <20100518134639.GA27582@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

On 05/18/2010 10:46 PM +0900, Mike Snitzer wrote:
> Kiyoshi Ueda <k-ueda@ct.jp.nec.com> wrote:
>> On 05/18/2010 02:27 AM +0900, Mike Snitzer wrote:
>>> Kiyoshi Ueda <k-ueda@ct.jp.nec.com> wrote:
>>>> As far as I understand, the current model of device-mapper is:
>>>>   - a table (precisely, a target) has various attributes,
>>>>     bio-based/request-based is one of such attributes
>>>>   - a table and its attributes are bound to the block device on resume
>>>> If we want to fix a problem, I think we should either work based on
>>>> this model or change the model.
>>>>
>>>> Your patch makes that loading table affects the block device, so you
>>>> are changing the model.
>>>>
>>>> If you change the model, it should be done carefully.
>>>> For example, the current model allows most of the table loading code
>>>> to run without exclusive lock on the device because it doesn't affect
>>>> the device itself.  If you change this model, table loading needs to
>>>> be serialized with appropriate locking.
>>>
>>> Nice catch, yes md->queue needs protection (see patch below).
>>
>> Not enough. (See drivers/md/dm-ioctl.c:table_load().)
>> Table load sequence is:
>>   1. populate table
>>   2. set the table to ->new_map of the hash_cell for the mapped_device
>>      in protection by _hash_lock.
>>
>> Since your fix only serializes the step 1, concurrent table loading
>> could end up with inconsistent status; e.g. request-based table is
>> bound to the mapped_device while the queue is initialized as bio-based.
>> With your new model, those 2 steps above must be atomic.
> 
> Ah, yes.. I looked at the possibility of serializing the entirety of
> table_load but determined that would be too excessive (would reduce
> parallelism of table_load).  But I clearly missed the fact that there
> could be a race to the _hash_lock protected critical section in
> table_load() -- leading to queue inconsistency.
> 
> I'll post v5 of the overall patch which will revert the mapped_device
> 'queue_lock' serialization that I proposed in v4.  v5 will contain
> the following patch to localize all table load related queue
> manipulation to the _hash_lock protected critical section in
> table_load().  So it sets the queue up _after_ the table's type is
> established with dm_table_set_type().

dm_table_setup_md_queue() may allocate memory with blocking mode.
Blocking allocation inside exclusive _hash_lock can cause deadlock;
e.g. when it has to wait for other dm devices to resume to free some
memory.

Also, your patch changes the queue configuration even when a table is
already active and used.  (e.g. Loading bio-based table to a mapped_device
which is already active/used as request-based sets q->requst_fn in NULL.)
That could cause some critical problems.

Thanks,
Kiyoshi Ueda
