Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757202Ab1INRSs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 13:18:48 -0400
Received: from natasha.panasas.com ([67.152.220.90]:50237 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757104Ab1INRSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 13:18:46 -0400
Message-ID: <4E70E1C1.8040907@panasas.com>
Date: Wed, 14 Sep 2011 20:17:53 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Jens Axboe <axboe@kernel.dk>, <linux-raid@vger.kernel.org>,
        <dm-devel@redhat.com>, <linux-kernel@vger.kernel.org>,
        <nab@linux-iscsi.org>, <ryanh@us.ibm.com>
Subject: Re: [PATCH 1/2] block: export __make_request
References: <20110911145053.GA28996@infradead.org> <4E6DD7F0.8020903@kernel.dk> <20110912122507.GA12229@infradead.org> <4E6DFA8C.3030400@kernel.dk> <20110912133826.GA22548@infradead.org> <4E6E49BE.6020005@kernel.dk> <20110913211911.GA13894@infradead.org>
In-Reply-To: <20110913211911.GA13894@infradead.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/14/2011 12:19 AM, Christoph Hellwig wrote:
> On Mon, Sep 12, 2011 at 08:04:46PM +0200, Jens Axboe wrote:
>>> I really hate naming things different from the method they are
>>> implementing.  I've tried to figure out what the point of the
>>> old blk_make_request is - why would we not go through
>>> generic_make_request for this?
>>>
>>> Boaz, any idea?
>>
>> I tend to agree, we could rename the existing blk_make_request(). It
>> could be blk_make_request_from_bio() or something like that, since
>> that's what it does.
>
> It should at very least be renamed.  But I still can't figure out what
> it is for exactly.
>
> There are three users:
>
>   (1) virtio_blk::virtblk_get_id():
> 	This looks like it really should just use blk_rq_map_kern.
>   (2) osd_initiator::_make_request():
> 	This one looks like it should just use the same scheme as
> 	sg_io(), as it's doing the same thing.

Good god what sg_io? That broken pointr+length from user-mode that sg.c
and bsg.c are using? no can do it's not user-mode pointers, and it's not
pointer+length it's pages pointers of a bio. The only other structure
that could carry the same information is struct sg, but we work very 
hard to get rid of this contraption. (scsi_execute_async or something 
that it was)

blk_make_request() was made to be the parallel of __make_request, to be
used from filesystem level users. But with two differences.
1. Mainly support for none-FS BLOCK_PC requests
2. Also support chained bios. (was added later)

>   (3) target_core_pscsi::__pscsi_map_SG():
> 	Same as (2).
>

There is no better suitable structure in current Kernel to carry a list
of pages, with optional offset and length, then bio struct. Given a bio
at hand. how do you make a block request out of it? (If it's not an 
FS_PC type IO?)

As I remember target_core had their own pages-linked-list structure, and
how do you make a request out of that? again best at hand is bio.

bio is for a long time a page-pointers-carrier-structure and is out of 
private block-level use. The filesystem level is full of it.

Thanks
Boaz

