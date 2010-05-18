Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757075Ab0ERIfq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 04:35:46 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:45350 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756662Ab0ERIfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 04:35:43 -0400
Message-ID: <4BF25091.3000507@ct.jp.nec.com>
Date: Tue, 18 May 2010 17:32:17 +0900
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
References: <1273532139-23043-1-git-send-email-snitzer@redhat.com> <1273532139-23043-2-git-send-email-snitzer@redhat.com> <4BE8DBB0.5060701@ct.jp.nec.com> <20100511131502.GA25211@redhat.com> <4BEA659F.9050206@ct.jp.nec.com> <20100513035750.GA25523@redhat.com> <4BED049C.5040409@ct.jp.nec.com> <20100514140852.GA10373@redhat.com> <4BF10BF1.3040108@ct.jp.nec.com> <20100517172737.GA24591@redhat.com>
In-Reply-To: <20100517172737.GA24591@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

On 05/18/2010 02:27 AM +0900, Mike Snitzer wrote:
> Kiyoshi Ueda <k-ueda@ct.jp.nec.com> wrote:
>> On 05/14/2010 11:08 PM +0900, Mike Snitzer wrote:
>>> Kiyoshi Ueda <k-ueda@ct.jp.nec.com> wrote:
>>>> On 05/13/2010 12:57 PM +0900, Mike Snitzer wrote:
>>>>> Kiyoshi Ueda <k-ueda@ct.jp.nec.com> wrote:
>>>>>> On 05/11/2010 10:15 PM +0900, Mike Snitzer wrote:
>>>>>>> It is clear we need to resolve the current full request_queue
>>>>>>> initialization that occurs even for bio-based DM devices.
>>>>>>>
>>>>>>> I believe the 2 patches I posted accomplish this in a stright-forward
>>>>>>> way.  We can always improve on it (by looking at what you proposed
>>>>>>> below) but we need a minimlaist fix that doesn't depend on userspace
>>>>>>> LVM2 changes right now.
>>>>>>
>>>>>> Humm, OK.
>>>>>> Indeed, showing iosched directory in bio-based device's sysfs is
>>>>>> confusing users actually, and we need something to resolve that soon.
>>>>>> So I don't strongly object to your approach as the first step, as long
>>>>>> as we can accept the risk of the maintenance cost which I mentioned.
>>>>>
>>>>> OK, I understand your concern (especially after having gone through this
>>>>> further over the past couple days).  I'm hopeful maintenance will be
>>>>> minimal.
>> snip
>>>> I feel your patch-set is growing and becoming complex fix rather than
>>>> minimalist/simple fix.
>>>>
>>>> I think touching mapped_device/queue at table loading time makes
>>>> things complex.  It is natural that table's arguments are reflected
>>>> to mapped_device/queue at table binding time instead.
>>>
>>> Seems the numerous patches I've posted over the past couple days have
>>> given a false impression.  But I do understand your concern.
>>>
>>> The longer-term direction you want to take DM (known type during
>>> alloc_dev) illustrates that we share a common goal: only do the precise
>>> work that is needed to initialize the request_queue for a DM device
>>> (whether it is bio-based or request-based).
>>>
>>> My changes do accomplish that in the near-term without requiring
>>> userspace change.  Many of my proposed changes are just refactoring
>>> existing code to clearly split out what is needed for request-based vs
>>> bio-based.
>>
>> As far as I understand, the current model of device-mapper is:
>>   - a table (precisely, a target) has various attributes,
>>     bio-based/request-based is one of such attributes
>>   - a table and its attributes are bound to the block device on resume
>> If we want to fix a problem, I think we should either work based on
>> this model or change the model.
>>
>> Your patch makes that loading table affects the block device, so you
>> are changing the model.
>>
>> If you change the model, it should be done carefully.
>> For example, the current model allows most of the table loading code
>> to run without exclusive lock on the device because it doesn't affect
>> the device itself.  If you change this model, table loading needs to
>> be serialized with appropriate locking.
> 
> Nice catch, yes md->queue needs protection (see patch below).

Not enough. (See drivers/md/dm-ioctl.c:table_load().)
Table load sequence is:
  1. populate table
  2. set the table to ->new_map of the hash_cell for the mapped_device
     in protection by _hash_lock.

Since your fix only serializes the step 1, concurrent table loading
could end up with inconsistent status; e.g. request-based table is
bound to the mapped_device while the queue is initialized as bio-based.
With your new model, those 2 steps above must be atomic.

Thanks,
Kiyoshi Ueda
