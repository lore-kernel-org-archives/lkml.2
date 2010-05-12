Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254Ab0ELIZ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 04:25:26 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:34926 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754042Ab0ELIZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 04:25:23 -0400
Message-ID: <4BEA659F.9050206@ct.jp.nec.com>
Date: Wed, 12 May 2010 17:23:59 +0900
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090825)
MIME-Version: 1.0
To: Mike Snitzer <snitzer@redhat.com>
CC: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>,
       "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
       Vivek Goyal <vgoyal@redhat.com>, Nikanth Karthikesan <knikanth@suse.de>
Subject: Re: [RFC PATCH 2/2] dm: only initialize full request_queue for request-based
 device
References: <1273532139-23043-1-git-send-email-snitzer@redhat.com> <1273532139-23043-2-git-send-email-snitzer@redhat.com> <4BE8DBB0.5060701@ct.jp.nec.com> <20100511131502.GA25211@redhat.com>
In-Reply-To: <20100511131502.GA25211@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

On 05/11/2010 10:15 PM +0900, Mike Snitzer wrote:
> On Tue, May 11 2010 at 12:23am -0400,
> Kiyoshi Ueda <k-ueda@ct.jp.nec.com> wrote:
> 
>> Hi Mike,
>>
>> On 05/11/2010 07:55 AM +0900, Mike Snitzer wrote:
>>> Revert back to only allocating a minimalist request_queue structure
>>> initially (needed for both bio and request-based DM).  Initialization of
>>> a full request_queue (request_fn, elevator, etc) is deferred until it is
>>> known that the DM device is request-based.
>>
>> Thank you for working on this.
>> However, I still disagree with this patch as we discussed on this thread:
>> http://marc.info/?t=124990138700003&r=1&w=2
>> (Exporting a part of queue's features may cause some maintenance costs
>>  in future.)
> 
> Thanks for the reference.  I completely forgot about that thread (even
> though I responded to Nikanth's patches in detail! :)
> 
> It is clear we need to resolve the current full request_queue
> initialization that occurs even for bio-based DM devices.
> 
> I believe the 2 patches I posted accomplish this in a stright-forward
> way.  We can always improve on it (by looking at what you proposed
> below) but we need a minimlaist fix that doesn't depend on userspace
> LVM2 changes right now.

Humm, OK.
Indeed, showing iosched directory in bio-based device's sysfs is
confusing users actually, and we need something to resolve that soon.
So I don't strongly object to your approach as the first step, as long
as we can accept the risk of the maintenance cost which I mentioned.

By the way, your current patch has a problem below.
It needs to be fixed at least.


> Similarly, my proposed DM changes are also quite natural. By using
> dm_table_set_type() as the hook to initialize the request-based DM
> device's elevator we perform allocations during table load.

Your patch initializes queue everytime request-based table is loaded.
I think that could cause a problem (although I haven't tested your
patch yet).


Also, as you know, the table load can be canceled.
So initializing queue at table loading time may cause some weird
behaviors for users.  For example,
    # dmsetup create --notable bio-based
    # echo "0 100 multipath ..." | dmsetup load bio-based
    # echo "0 100 linear ..."    | dmsetup load bio-based
    # dmsetup resume bio-based
    # ls /sys/block/dm-0/queue/
    ... iosched ...
If you (and Alasdair) think this behavior is acceptable, it might
be OK.  I just feel it's weird though...


> Having just looked at Nikanth's proposed DM patch 2/2 again it shows
> that blk_init_allocated_queue(), which allocates memory, was being
> called during resume (dm_swap_table).  Allocations are not allowed
> during resume.

Right, in general.
However, in this special case, I think initializing queue (allocating
memory) during resume should be OK as I mentioned like below in:
    http://marc.info/?l=linux-kernel&m=124999806420663&w=2

    > Generally, dm must not allocate memory during resume because
    > it may cause a deadlock in no memory situation.
    > However, there is no I/O on this device at this point,
    > so the allocation should be ok for this special case.
    > I think some comments are needed here to describe that.

So you should be able to take this approach.

Thanks,
Kiyoshi Ueda
