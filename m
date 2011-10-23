Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489Ab1JWBY2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 21:24:28 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53641 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589Ab1JWBY1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 21:24:27 -0400
MIME-Version: 1.0
In-Reply-To: <20111020234703.GI20542@quack.suse.cz>
References: <1319036598-4367-1-git-send-email-linkinjeon@gmail.com>
	<20111020234703.GI20542@quack.suse.cz>
Date: Sun, 23 Oct 2011 10:24:25 +0900
Message-ID: <CAKYAXd-Bi+=ZdXbHG+Rd0C3Yh9+v1PyjarTFdBA5YayP_FVOLQ@mail.gmail.com>
Subject: Re: [PATCH] udf : skip mirror metadata FE since metadata FE is ok.
From: NamJae Jeon <linkinjeon@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, Ashish Sangwan <ashishsangwan2@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/10/21 Jan Kara <jack@suse.cz>:
> On Thu 20-10-11 00:03:18, Namjae Jeon wrote:
>> By Jan Kara's suggestion, This patch skip mirror metadata FE since
>> metadata FE is ok. And try to read it only the first time
>> udf_get_pblock_meta25() fails to map the block from metadata FE.
>>
>> Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
>> Signed-off-by: Ashish Sangwan <ashishsangwan2@gmail.com>
>> ---
>>  fs/udf/partition.c |   20 ++++++++++++++++++++
>>  fs/udf/super.c     |   33 ++++++++++++++++-----------------
>>  2 files changed, 36 insertions(+), 17 deletions(-)
>>
>> diff --git a/fs/udf/partition.c b/fs/udf/partition.c
>> index f3e472c..8bfc25b 100644
>> --- a/fs/udf/partition.c
>> +++ b/fs/udf/partition.c
>> @@ -311,6 +311,7 @@ uint32_t udf_get_pblock_meta25(struct super_block *sb, uint32_t block,
>>       struct udf_meta_data *mdata;
>>       uint32_t retblk;
>>       struct inode *inode;
>> +     struct kernel_lb_addr addr;
>>
>>       udf_debug("READING from METADATA\n");
>>
>> @@ -323,6 +324,25 @@ uint32_t udf_get_pblock_meta25(struct super_block *sb, uint32_t block,
>>       retblk = udf_try_read_meta(inode, block, partition, offset);
>>       if (retblk == 0xFFFFFFFF) {
>>               udf_warn(sb, "error reading from METADATA, trying to read from MIRROR\n");
>> +             if (mdata->s_mirror_fe == NULL) {
>  This won't be good because if s_mirror_fe cannot be loaded as well, you'd
> just try loading it on every block mapping which failed from the primary
> metadata map. So you should have a flag somewhere whether in mdata, whether
> you tried loading mirror_fe or not and use that.
>
>> +                     /* mirror file entry */
>> +                     addr.logicalBlockNum = mdata->s_mirror_file_loc;
>> +                     addr.partitionReferenceNum = map->s_partition_num;
>> +                     udf_debug("Mirror metadata file location: block = %d part = %d\n",
>> +                             addr.logicalBlockNum,
>> +                             addr.partitionReferenceNum);
>> +                     mdata->s_mirror_fe = udf_iget(sb, &addr);
>> +
>> +                     if (mdata->s_mirror_fe == NULL)
>> +                             udf_err(sb, "mirror inode efe not found");
>> +                     else if (UDF_I(mdata->s_mirror_fe)->i_alloc_type !=
>> +                                     ICBTAG_FLAG_AD_SHORT) {
>> +                             udf_warn(sb, "mirror inode efe does not have short allocation descriptors!\n");
>> +                             iput(mdata->s_mirror_fe);
>> +                             mdata->s_mirror_fe = NULL;
>> +                     }
>  Also please create a helper function for loading metadata/mirror metadat
> FE so that we don't have loading duplicated in three places... Thanks.
Hi Jan.
Thanks for your review.
I will do it.

>
>                                                                Honza
> --
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
>
