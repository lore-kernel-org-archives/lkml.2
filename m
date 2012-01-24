Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752316Ab2AXWmy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 17:42:54 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:51575 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182Ab2AXWmx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 17:42:53 -0500
MIME-Version: 1.0
In-Reply-To: <20120124141332.GD18136@quack.suse.cz>
References: <1327132572-11841-1-git-send-email-linkinjeon@gmail.com>
	<20120124141332.GD18136@quack.suse.cz>
Date: Wed, 25 Jan 2012 07:42:51 +0900
Message-ID: <CAKYAXd_uskOwun-cieNhsr=SQae0Qm7sh9=UTh0ahSOsGamyUQ@mail.gmail.com>
Subject: Re: [PATCH] ext4: add error handling when discarding is fail in
 FITRIM ioctl
From: Namjae Jeon <linkinjeon@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Amit Sahrawat <amit.sahrawat83@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/1/24 Jan Kara <jack@suse.cz>:
> On Sat 21-01-12 02:56:12, Namjae Jeon wrote:
>> Although free extents is proper not trimmed(mmc driver return error code while sending trim command), currently FITRIM ioctl return success.
>> I tried to add exception routine to inform user error code.
>>
>> #> ./fitrim_test
>> end_request: I/O error, dev mmcblk0, sector 27232
>> EXT4-fs warning (device mmcblk0): ext4_trim_all_free:4857: Discard command returned error -5
>> #>
>>
>> Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
>> Signed-off-by: Amit Sahrawat <amit.sahrawat83@gmail.com>
>> ---
>>  fs/ext4/mballoc.c |   22 +++++++++++++++-------
>>  1 files changed, 15 insertions(+), 7 deletions(-)
>>
>> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
>> index cb990b2..09cc09a 100644
>> --- a/fs/ext4/mballoc.c
>> +++ b/fs/ext4/mballoc.c
>> @@ -4901,10 +4901,11 @@ error_return:
>>   * one will allocate those blocks, mark it as used in buddy bitmap. This must
>>   * be called with under the group lock.
>>   */
>> -static void ext4_trim_extent(struct super_block *sb, int start, int count,
>> +static int ext4_trim_extent(struct super_block *sb, int start, int count,
>>                            ext4_group_t group, struct ext4_buddy *e4b)
>>  {
>>       struct ext4_free_extent ex;
>> +     int err;
>>
>>       trace_ext4_trim_extent(sb, group, start, count);
>>
>> @@ -4920,9 +4921,10 @@ static void ext4_trim_extent(struct super_block *sb, int start, int count,
>>        */
>>       mb_mark_used(e4b, &ex);
>>       ext4_unlock_group(sb, group);
>> -     ext4_issue_discard(sb, group, start, count);
>> +     err = ext4_issue_discard(sb, group, start, count);
>>       ext4_lock_group(sb, group);
>>       mb_free_blocks(NULL, e4b, start, ex.fe_len);
>> +     return err;
>>  }
>>
>>  /**
>> @@ -4978,15 +4980,21 @@ ext4_trim_all_free(struct super_block *sb, ext4_group_t group,
>>               next = mb_find_next_bit(bitmap, max, start);
>>
>>               if ((next - start) >= minblocks) {
>> -                     ext4_trim_extent(sb, start,
>> -                                      next - start, group, &e4b);
>> -                     count += next - start;
>> +                     ret = ext4_trim_extent(sb, start,
>> +                                             next - start, group, &e4b);
>> +                     if (ret < 0) {
>> +                             if (ret != -EOPNOTSUPP)
>> +                                     ext4_warning(sb, "Discard command "
>> +                                              "returned error %d\n", ret);
>> +                             break;
>> +                     } else
>> +                             count += next - start;
>>               }
>>               free_count += next - start;
>>               start = next + 1;
>>
>>               if (fatal_signal_pending(current)) {
>> -                     count = -ERESTARTSYS;
>> +                     ret = -ERESTARTSYS;
>>                       break;
>>               }
>>
>> @@ -5009,7 +5017,7 @@ out:
>>       ext4_debug("trimmed %d blocks in the group %d\n",
>>               count, group);
>>
>> -     return count;
>> +     return (ret < 0) ? ret : count;
>  I think you need to initialize ret to 0 at the beginning of the function.
> Otherwise you could use it uninitialized. Otherwise the patch looks good to
> me and makes things consistent with ext3 so after fixing that bug you can add:
>  Reviewed-by: Jan Kara <jack@suse.cz>
Hi. Jan.
Thanks for your review.~
>
>                                                                Honza
> --
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
