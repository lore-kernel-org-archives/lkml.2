Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756766Ab2HOUwp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 16:52:45 -0400
Received: from mail1.windriver.com ([147.11.146.13]:64078 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756173Ab2HOUwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 16:52:43 -0400
Message-ID: <502C0C16.9060402@windriver.com>
Date: Wed, 15 Aug 2012 16:52:38 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: NeilBrown <neilb@suse.de>
CC: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [v2.6.34-stable 035/165] md: Fix handling for devices from 2TB
 to 4TB in 0.90 metadata.
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com> <1345060109-9187-36-git-send-email-paul.gortmaker@windriver.com> <20120816064631.61c7026d@notabene.brown>
In-Reply-To: <20120816064631.61c7026d@notabene.brown>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-08-15 04:46 PM, NeilBrown wrote:
> On Wed, 15 Aug 2012 15:46:19 -0400 Paul Gortmaker
> <paul.gortmaker@windriver.com> wrote:
> 
>> From: NeilBrown <neilb@suse.de>
>>
>>                    -------------------
>>     This is a commit scheduled for the next v2.6.34 longterm release.
>>     http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
>>     If you see a problem with using this for longterm, please comment.
> 
> This patch fixes one problem but unfortunately introduces another.
> The patch for that 'other' should get sent to linus in the next day or so
> after it has had a chance to sit in -next for a bit.
> 
> It can be found at:
>  http://neil.brown.name/git?p=md;a=commitdiff;h=30b798a352052b07c924956dda4ce720b00af711
> 
> you could either add that patch, or drop this patch until the next cycle.

Thanks for the review Neil, I'll postpone this off until the next
cycle, and then add both in.

Paul.
--

> 
> Thanks,
> NeilBrown
> 
>>                    -------------------
>>
>> commit 27a7b260f71439c40546b43588448faac01adb93 upstream.
>>
>> 0.90 metadata uses an unsigned 32bit number to count the number of
>> kilobytes used from each device.
>> This should allow up to 4TB per device.
>> However we multiply this by 2 (to get sectors) before casting to a
>> larger type, so sizes above 2TB get truncated.
>>
>> Also we allow rdev->sectors to be larger than 4TB, so it is possible
>> for the array to be resized larger than the metadata can handle.
>> So make sure rdev->sectors never exceeds 4TB when 0.90 metadata is in
>> used.
>>
>> Also the sanity check at the end of super_90_load should include level
>> 1 as it used ->size too. (RAID0 and Linear don't use ->size at all).
>>
>> Reported-by: Pim Zandbergen <P.Zandbergen@macroscoop.nl>
>> Signed-off-by: NeilBrown <neilb@suse.de>
>> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
>> ---
>>  drivers/md/md.c | 12 ++++++++++--
>>  1 file changed, 10 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index d26df7f..4788c82 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -985,8 +985,11 @@ static int super_90_load(mdk_rdev_t *rdev, mdk_rdev_t *refdev, int minor_version
>>  			ret = 0;
>>  	}
>>  	rdev->sectors = rdev->sb_start;
>> +	/* Limit to 4TB as metadata cannot record more than that */
>> +	if (rdev->sectors >= (2ULL << 32))
>> +		rdev->sectors = (2ULL << 32) - 2;
>>  
>> -	if (rdev->sectors < sb->size * 2 && sb->level > 1)
>> +	if (rdev->sectors < ((sector_t)sb->size) * 2 && sb->level >= 1)
>>  		/* "this cannot possibly happen" ... */
>>  		ret = -EINVAL;
>>  
>> @@ -1021,7 +1024,7 @@ static int super_90_validate(mddev_t *mddev, mdk_rdev_t *rdev)
>>  		mddev->clevel[0] = 0;
>>  		mddev->layout = sb->layout;
>>  		mddev->raid_disks = sb->raid_disks;
>> -		mddev->dev_sectors = sb->size * 2;
>> +		mddev->dev_sectors = ((sector_t)sb->size) * 2;
>>  		mddev->events = ev1;
>>  		mddev->bitmap_info.offset = 0;
>>  		mddev->bitmap_info.default_offset = MD_SB_BYTES >> 9;
>> @@ -1260,6 +1263,11 @@ super_90_rdev_size_change(mdk_rdev_t *rdev, sector_t num_sectors)
>>  	rdev->sb_start = calc_dev_sboffset(rdev->bdev);
>>  	if (!num_sectors || num_sectors > rdev->sb_start)
>>  		num_sectors = rdev->sb_start;
>> +	/* Limit to 4TB as metadata cannot record more than that.
>> +	 * 4TB == 2^32 KB, or 2*2^32 sectors.
>> +	 */
>> +	if (num_sectors >= (2ULL << 32))
>> +		num_sectors = (2ULL << 32) - 2;
>>  	md_super_write(rdev->mddev, rdev, rdev->sb_start, rdev->sb_size,
>>  		       rdev->sb_page);
>>  	md_super_wait(rdev->mddev);
> 
