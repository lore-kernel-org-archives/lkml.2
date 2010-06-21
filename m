Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757944Ab0FUTQf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 15:16:35 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:43648 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751608Ab0FUTQe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 15:16:34 -0400
Message-ID: <4C1FBA91.3040601@kernel.dk>
Date: Mon, 21 Jun 2010 21:16:33 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: trying to understand READ_META, READ_SYNC, WRITE_SYNC & co
References: <20100621094828.GA30748@lst.de> <4C1F3916.4070608@kernel.dk> <20100621110436.GA4056@lst.de> <4C1FB5F7.3070908@kernel.dk> <20100621191410.GA24213@lst.de>
In-Reply-To: <20100621191410.GA24213@lst.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/06/10 21.14, Christoph Hellwig wrote:
> On Mon, Jun 21, 2010 at 08:56:55PM +0200, Jens Axboe wrote:
>> FWIW, Windows marks meta data writes and they go out with FUA set
>> on SATA disks. And SATA firmware prioritizes FUA writes, it's essentially
>> a priority bit as well as a platter access bit. So at least we have some
>> one else using a meta data boost. I agree that it would be a lot more
>> trivial to add the annotations if they didn't have scheduler impact
>> as well, but I still think it's a sane thing.
> 
> And we still disable the FUA bit in libata unless people set a
> non-standard module option..

Yes, but that's a separate thing. The point is that boosting meta data
IO is done by others as well. That we don't fully do the same on the
hw side is a different story. That doesn't mean that the io scheduler
boost isn't useful.

>>>> Reads are sync by nature in the block layer, so they don't get that
>>>> special annotation.
>>>
>>> Well, we do give them this special annotation in a few places, but we
>>> don't actually use it.
>>
>> For unplugging?
> 
> We use the explicit unplugging, yes - but READ_META also includes
> REQ_SYNC which is not used anywhere.

That does look superfluous.

>>> But that leaves the question why disabling the idling logical for
>>> data integrity ->writepage is fine?  This gets called from ->fsync
>>> or O_SYNC writes and will have the same impact as O_DIRECT writes.
>>
>> We have never enabled idling for those. O_SYNC should get a nice
>> boost too, it just needs to be benchmarked and tested and then
>> there would be no reason not to add it.
> 
> We've only started using any kind of sync tag last year in ->writepage in
> commit a64c8610bd3b753c6aff58f51c04cdf0ae478c18 "block_write_full_page:
> Use synchronous writes for WBC_SYNC_ALL writebacks", switching from
> WRITE_SYNC to WRITE_SYNC_PLUG a bit later in commit
> 6e34eeddf7deec1444bbddab533f03f520d8458c "block_write_full_page: switch
> synchronous writes to use WRITE_SYNC_PLUG"
> 
> Before that we used plain WRITE, which had the normal idling logic.

Plain write does not idle.

-- 
Jens Axboe

