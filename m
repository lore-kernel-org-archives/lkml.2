Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751409Ab2LCWHT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 17:07:19 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:19818 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210Ab2LCWHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 17:07:17 -0500
Message-ID: <50BD2283.2080809@oracle.com>
Date: Mon, 03 Dec 2012 16:06:59 -0600
From: Dave Kleikamp <dave.kleikamp@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zach Brown <zab@zabbo.net>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH v4 09/31] dio: create a dio_aligned() helper function
References: <1353537671-26284-1-git-send-email-dave.kleikamp@oracle.com> <1353537671-26284-10-git-send-email-dave.kleikamp@oracle.com> <20121123081938.GB10731@infradead.org>
In-Reply-To: <20121123081938.GB10731@infradead.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding Andi

On 11/23/2012 02:19 AM, Christoph Hellwig wrote:
> On Wed, Nov 21, 2012 at 04:40:49PM -0600, Dave Kleikamp wrote:
>> From: Zach Brown <zab@zabbo.net>
>>
>> __blockdev_direct_IO() had two instances of the same code to determine
>> if a given offset wasn't aligned first to the inode's blkbits and then
>> to the underlying device's blkbits.   This was confusing enough but
>> we're about to add code that performs the same check on offsets in bvec
>> arrays.  Rather than add yet more copies of this code let's have
>> everyone call a helper.
>>
>> Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
>> Cc: Zach Brown <zab@zabbo.net>
>> ---
>>  fs/direct-io.c | 59 ++++++++++++++++++++++++++++++++++++----------------------
>>  1 file changed, 37 insertions(+), 22 deletions(-)
>>
>> diff --git a/fs/direct-io.c b/fs/direct-io.c
>> index f86c720..035c0a3 100644
>> --- a/fs/direct-io.c
>> +++ b/fs/direct-io.c
>> @@ -1020,6 +1020,39 @@ static inline int drop_refcount(struct dio *dio)
>>  }
>>  
>>  /*
>> + * Returns true if the given offset is aligned to either the IO size
>> + * specified by the given blkbits or by the logical block size of the
>> + * given block device.
>> + *
>> + * If the given offset isn't aligned to the blkbits arguments as this is
>> + * called then blkbits is set to the block size of the specified block
>> + * device.  The call can then return either true or false.
>> + *
>> + * This bizarre calling convention matches the code paths that
>> + * duplicated the functionality that this helper was built from.  We
>> + * reproduce the behaviour to avoid introducing subtle bugs.
>> + */
>> +static int dio_aligned(unsigned long offset, unsigned *blkbits,
>> +		       struct block_device *bdev)
>> +{
>> +	unsigned mask = (1 << *blkbits) - 1;
>> +
>> +	/*
>> +	 * Avoid references to bdev if not absolutely needed to give
>> +	 * the early prefetch in the caller enough time.
>> +	 */
>> +
>> +	if (offset & mask) {
>> +		if (bdev)
>> +			*blkbits = blksize_bits(bdev_logical_block_size(bdev));
> 
> I don't like having the blkbits assignment hidden in the helper,
> shouldn't we have a:
> 
> 	if (bdev)
> 		blkbits = blksize_bits(bdev_logical_block_size(bdev));
> 	else
> 		blkbits = inode->i_blkbits;
> 
> in the caller instead?

I'm not sure what's preferable here. As the comment states, the code is
making an effort to avoid a cache miss by avoiding the reference to bdev
when possible. If this micro-optimization is worth keeping, then it's a
question of which is uglier, this new function that modifies blkbits, or
duplicating this bit of code three times.

On the other hand, if we can do as you suggest, dio_aligned() becomes
trivial, so there's no need to create it. That would make for cleaner
code, but I'd at least want Andi's okay before I do that.

Thanks,
Shaggy
