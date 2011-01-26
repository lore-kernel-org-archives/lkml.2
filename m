Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919Ab1AZTu5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 14:50:57 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:53015 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753342Ab1AZTu4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 14:50:56 -0500
Date: Wed, 26 Jan 2011 13:50:51 -0600
From: Robert Jennings <rcj@linux.vnet.ibm.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Nitin Gupta <ngupta@vflare.org>, Greg Kroah-Hartman <gregkh@suse.de>,
        Robert Jennings <rcj@linux.vnet.ibm.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/7] zram: Speed insertion of new pages with cached idx
Message-ID: <20110126195051.GF17383@linux.vnet.ibm.com>
Mail-Followup-To: Pekka Enberg <penberg@cs.helsinki.fi>,
	Nitin Gupta <ngupta@vflare.org>,
	Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinF=r_wUw_ZgfcdrFD6nWh3VKwUOjQ+wsbVax0C@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pekka Enberg (penberg@cs.helsinki.fi) wrote:
> On Wed, Jan 26, 2011 at 7:23 PM, Robert Jennings> <rcj@linux.vnet.ibm.com> wrote:
>> Calculate the first- and second-level indices for new page when the pool
>> is initialized rather than calculating them on each insertion.
>> 
>> Signed-off-by: Robert Jennings <rcj@linux.vnet.ibm.com>
>> ---
>>  drivers/staging/zram/xvmalloc.c     |   13 +++++++++++--
>>  drivers/staging/zram/xvmalloc_int.h |    4 ++++
>>  2 files changed, 15 insertions(+), 2 deletions(-)
>> 
>> diff --git a/drivers/staging/zram/xvmalloc.c b/drivers/staging/zram/xvmalloc.c
>> index 3fdbb8a..a507f95 100644
>> --- a/drivers/staging/zram/xvmalloc.c
>> +++ b/drivers/staging/zram/xvmalloc.c
>> @@ -184,8 +184,13 @@ static void insert_block(struct xv_pool *pool, struct page *page, u32 offset,
>>  	u32 flindex, slindex;
>>  	struct block_header *nextblock;
>>  
>> -	slindex = get_index_for_insert(block->size);
>> -	flindex = slindex / BITS_PER_LONG;
>> +	if (block->size >= (PAGE_SIZE - XV_ALIGN)) {
>> +		slindex = pagesize_slindex;
>> +		flindex = pagesize_flindex;
>> +	} else {
>> +		slindex = get_index_for_insert(block->size);
>> +		flindex = slindex / BITS_PER_LONG;
>> +	}
>>  
>>  	block->link.prev_page = 0;
>>  	block->link.prev_offset = 0;
>> @@ -316,6 +321,10 @@ struct xv_pool *xv_create_pool(void)
>>  	if (!pool)
>>  		return NULL;
>>  
>> +	/* cache the first/second-level indices for PAGE_SIZE allocations */
>> +	pagesize_slindex = get_index_for_insert(PAGE_SIZE);
>> +	pagesize_flindex = pagesize_slindex / BITS_PER_LONG;
> 
> Why is this in xv_create_pool(). AFAICT, it can be called multiple
> times if there's more than one zram device. Do we really need
> variables for these? They look like something GCC constant propagation
> should take care of if they would be defines or static inline
> functions.

It should have been a define rather than in xv_create_pool but as I read
more about GCC constant propagation and look at the get_index_for_insert
I believe that this patch is unnecessary.  For sizes near PAGE_SIZE
(>XV_MAX_ALLOC_SIZE) I believe GCC constant propagation should do
exactly what I though I was trying to do.  I will drop this patch.
Thank you for your reviews.
