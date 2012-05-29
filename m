Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750Ab2E2I6X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 04:58:23 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:39438 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161Ab2E2I6W convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Tue, 29 May 2012 04:58:22 -0400
Message-Id: <4FC4A10F0200007800086842@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Tue, 29 May 2012 09:12:31 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Stefano Stabellini" <stefano.stabellini@eu.citrix.com>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 2/2] xen/blkfront: Add BUG_ON to deal
 with misbehaving backends.
References: <1337982603-15692-1-git-send-email-konrad.wilk@oracle.com>
 <1337982603-15692-3-git-send-email-konrad.wilk@oracle.com>
 <alpine.DEB.2.00.1205281111460.26786@kaball-desktop>
In-Reply-To: <alpine.DEB.2.00.1205281111460.26786@kaball-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 28.05.12 at 12:18, Stefano Stabellini <stefano.stabellini@eu.citrix.com>
wrote:
> On Fri, 25 May 2012, Konrad Rzeszutek Wilk wrote:
>> Part of the ring structure is the 'id' field which is under
>> control of the frontend. The frontend stamps it with "some"
>> value (this some in this implementation being a value less
>> than BLK_RING_SIZE), and when it gets a response expects
>> said value to be in the response structure. We have a check
>> for the id field when spolling new requests but not when
>> de-spolling responses.
>> 
>> We also add an extra check in add_id_to_freelist to make
>> sure that the 'struct request' was not NULL - as we cannot
>> pass a NULL to __blk_end_request_all, otherwise that crashes
>> (and all the operations that the response is dealing with
>> end up with __blk_end_request_all).
>> 
>> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
>> ---
>>  drivers/block/xen-blkfront.c |    7 +++++++
>>  1 files changed, 7 insertions(+), 0 deletions(-)
>> 
>> diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
>> index 60eed4b..8e177ca 100644
>> --- a/drivers/block/xen-blkfront.c
>> +++ b/drivers/block/xen-blkfront.c
>> @@ -145,6 +145,7 @@ static void add_id_to_freelist(struct blkfront_info 
> *info,
>>  			       unsigned long id)
>>  {
>>  	info->shadow[id].req.u.rw.id  = info->shadow_free;
>> +	BUG_ON(info->shadow[id].request == NULL);

This only catches a small sub-portion of possible bad backend
behavior. Checking (as the very first thing in the function) e.g.

info->shadow[id].req.u.rw.id == id

would seem to cover a broader set (based on my recent looking
at similar mismatches apparently resulting from the qdisk
backend occasionally sending bad/duplicate responses).

But take this with the below applied here too.

>>  	info->shadow[id].request = NULL;
>>  	info->shadow_free = id;
>>  }
>> @@ -746,6 +747,12 @@ static irqreturn_t blkif_interrupt(int irq, void 
> *dev_id)
>>  
>>  		bret = RING_GET_RESPONSE(&info->ring, i);
>>  		id   = bret->id;
>> +		/*
>> +		 * The backend has messed up and given us an id that we would
>> +		 * never have given to it (we stamp it up to BLK_RING_SIZE -
>> +		 * look in get_id_from_freelist.
>> +		 */
>> +		BUG_ON(id >= BLK_RING_SIZE);
>>  		req  = info->shadow[id].request;
>>  
>>  		if (bret->operation != BLKIF_OP_DISCARD)
> 
> While we should certainly check whether bret->id is valid before
> using it, is it actually correct that the frontend BUGs in response of a
> backend bug?
> 
> If the IO doesn't involve the root disk, the guest might be able to
> function correctly without communicating with the backend at all.
> I think we should WARN and return error. Maybe also call blkfront_remove
> if we can.

I very much agree to this.

Jan

