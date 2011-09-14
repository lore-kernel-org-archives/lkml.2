Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757254Ab1INRx0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 13:53:26 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:60590 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757104Ab1INRxY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 13:53:24 -0400
MIME-Version: 1.0
Reply-To: doug@easyco.com
In-Reply-To: <4E70E1C1.8040907@panasas.com>
References: <20110911145053.GA28996@infradead.org>
	<4E6DD7F0.8020903@kernel.dk>
	<20110912122507.GA12229@infradead.org>
	<4E6DFA8C.3030400@kernel.dk>
	<20110912133826.GA22548@infradead.org>
	<4E6E49BE.6020005@kernel.dk>
	<20110913211911.GA13894@infradead.org>
	<4E70E1C1.8040907@panasas.com>
Date: Wed, 14 Sep 2011 10:53:22 -0700
X-Google-Sender-Auth: ZlOhQXRXeE1mxfqGRBUG_XjKAPE
Message-ID: <CAFx4rwR=EnCVfi4Pzm9pmTtKWAdzvzOg7wwzBbzZN7YTvu5-fw@mail.gmail.com>
Subject: Re: [PATCH 1/2] block: export __make_request
From: Doug Dumitru <doug@easyco.com>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
        linux-raid@vger.kernel.org, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org, nab@linux-iscsi.org, ryanh@us.ibm.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It would be great if this function were exported, but I would
encourage everyone to consider exporting it generally, not just for
GPL usage.

The kernel seems to be pretty clean that some subsystems are GPL only
(things like sysfs), and some are open (things like the device-mapper
interfaces).  When a subsystem is part GPL and part open, it gets very
confusing for developers of commercial modules to know what to use and
what not to use.

The goal of GPL versus commercial exports should be to encourage GPL
code, not to punish commercial code by requiring stupid work arounds
that only waste time and hurt performance.

Again, most of the block IO layer is plain exports.  Adding random GPL
exports seems somewhat arbitrary.

Then again, this is your code, and If you believe it should be GPL
linkable only, then that is fine.  Just consider that there are
projects out there that are strange enough to be impacted and some
degree of symmetry is desirable.

As a side node, I would vote for longer, more descriptive names.
"__anything" should never be exported.

Doug Dumitru
EasyCo LLC



On Wed, Sep 14, 2011 at 10:17 AM, Boaz Harrosh <bharrosh@panasas.com> wrote:
> On 9/14/2011 12:19 AM, Christoph Hellwig wrote:
>>
>> On Mon, Sep 12, 2011 at 08:04:46PM +0200, Jens Axboe wrote:
>>>>
>>>> I really hate naming things different from the method they are
>>>> implementing.  I've tried to figure out what the point of the
>>>> old blk_make_request is - why would we not go through
>>>> generic_make_request for this?
>>>>
>>>> Boaz, any idea?
>>>
>>> I tend to agree, we could rename the existing blk_make_request(). It
>>> could be blk_make_request_from_bio() or something like that, since
>>> that's what it does.
>>
>> It should at very least be renamed.  But I still can't figure out what
>> it is for exactly.
>>
>> There are three users:
>>
>>  (1) virtio_blk::virtblk_get_id():
>>        This looks like it really should just use blk_rq_map_kern.
>>  (2) osd_initiator::_make_request():
>>        This one looks like it should just use the same scheme as
>>        sg_io(), as it's doing the same thing.
>
> Good god what sg_io? That broken pointr+length from user-mode that sg.c
> and bsg.c are using? no can do it's not user-mode pointers, and it's not
> pointer+length it's pages pointers of a bio. The only other structure
> that could carry the same information is struct sg, but we work very hard to
> get rid of this contraption. (scsi_execute_async or something that it was)
>
> blk_make_request() was made to be the parallel of __make_request, to be
> used from filesystem level users. But with two differences.
> 1. Mainly support for none-FS BLOCK_PC requests
> 2. Also support chained bios. (was added later)
>
>>  (3) target_core_pscsi::__pscsi_map_SG():
>>        Same as (2).
>>
>
> There is no better suitable structure in current Kernel to carry a list
> of pages, with optional offset and length, then bio struct. Given a bio
> at hand. how do you make a block request out of it? (If it's not an FS_PC
> type IO?)
>
> As I remember target_core had their own pages-linked-list structure, and
> how do you make a request out of that? again best at hand is bio.
>
> bio is for a long time a page-pointers-carrier-structure and is out of
> private block-level use. The filesystem level is full of it.
>
> Thanks
> Boaz
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Doug Dumitru
EasyCo LLC
