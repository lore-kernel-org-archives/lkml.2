Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219Ab1JRRG7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 13:06:59 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42371 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753738Ab1JRRG6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 13:06:58 -0400
MIME-Version: 1.0
In-Reply-To: <20111017134155.GD4528@quack.suse.cz>
References: <1318668106-2147-1-git-send-email-linkinjeon@gmail.com>
	<20111017134155.GD4528@quack.suse.cz>
Date: Wed, 19 Oct 2011 02:06:56 +0900
Message-ID: <CAKYAXd-MJ5CS=gHMTQoW-qkg62ikqYexzZJW7e2_HcTTxz-0mg@mail.gmail.com>
Subject: Re: [PATCH v2] udf : skip finding mirror meta in same location with metadata.
From: NamJae Jeon <linkinjeon@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, Ashish Sangwan <ashishsangwan2@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/10/17 Jan Kara <jack@suse.cz>:
> On Sat 15-10-11 17:41:46, Namjae Jeon wrote:
>> If metadata duplicate flag is clear, it means there is mirror metadata
>> file in same location with metadata file.  So this patch try to skip
>> finding mirror partition on this case.  Mount time is improved and avoid
>> unnecessarily loading mirror metadata.
>>
>> Signed-off-by: Ashish Sangwan <ashishsangwan2@gmail.com>
>> Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
>  Thanks for the patch but I do not completely agree. The point is that if
> there is error which prevents us to read metadata of "metadata FE", then we
> can very well succeed with reading equivalent metadata from the "mirror
> metadata FE" even when "duplicated" flag is set - metadata is never shared
> according to the specification (OSTA UDF Spec, section 2.2.10, "Flags"
> bullet). That is exactly what the current code tries to achieve.
>
> Now I agree that in the majority of cases we don't need to read mirror
> metadata FE since the original one is OK so there is some room for
> improvement. What we could do is just read metadata FE and if it succeeds,
> skip reading mirror metadata FE and try to read it only the first time
> udf_get_pblock_meta25() fails to map the block from metadata FE.
Thanks for your idea. Actually I and ashish are also considering to
post same suggestion with your idea.
I will make the new patch included your suggestion today.
>
>                                                                Honza
>> diff --git a/fs/udf/super.c b/fs/udf/super.c
>> index e58123a..f76f9e6 100644
>> --- a/fs/udf/super.c
>> +++ b/fs/udf/super.c
>> @@ -857,28 +857,39 @@ static int udf_load_metadata_files(struct super_block *sb, int partition)
>>               mdata->s_metadata_fe = NULL;
>>       }
>>
>> -     /* mirror file entry */
>> -     addr.logicalBlockNum = mdata->s_mirror_file_loc;
>> -     addr.partitionReferenceNum = map->s_partition_num;
>> +     if (!mdata->s_dup_md_flag) {
>> +             udf_info("There is mirror metadata file in same location with metadata file.");
>> +             if (fe_error) {
>> +                     udf_err(sb, "So mirror inode efe can not found too");
>> +                     goto error_exit;
>> +             } else {
>> +                     mdata->s_mirror_fe = mdata->s_metadata_fe;
>> +             }
>> +     } else {
>>
>> -     udf_debug("Mirror metadata file location: block = %d part = %d\n",
>> -               addr.logicalBlockNum, addr.partitionReferenceNum);
>> +             /* mirror file entry */
>> +             addr.logicalBlockNum = mdata->s_mirror_file_loc;
>> +             addr.partitionReferenceNum = map->s_partition_num;
>>
>> -     mdata->s_mirror_fe = udf_iget(sb, &addr);
>> +             udf_debug("Mirror metadata file location: block = %d part = %d\n",
>> +                       addr.logicalBlockNum, addr.partitionReferenceNum);
>>
>> -     if (mdata->s_mirror_fe == NULL) {
>> -             if (fe_error) {
>> -                     udf_err(sb, "mirror inode efe not found and metadata inode is missing too, exiting...\n");
>> -                     goto error_exit;
>> -             } else
>> -                     udf_warn(sb, "mirror inode efe not found, but metadata inode is OK\n");
>> -     } else if (UDF_I(mdata->s_mirror_fe)->i_alloc_type !=
>> -              ICBTAG_FLAG_AD_SHORT) {
>> -             udf_warn(sb, "mirror inode efe does not have short allocation descriptors!\n");
>> -             iput(mdata->s_mirror_fe);
>> -             mdata->s_mirror_fe = NULL;
>> -             if (fe_error)
>> -                     goto error_exit;
>> +             mdata->s_mirror_fe = udf_iget(sb, &addr);
>> +
>> +             if (mdata->s_mirror_fe == NULL) {
>> +                     if (fe_error) {
>> +                             udf_err(sb, "mirror inode efe not found and metadata inode is missing too, exiting...\n");
>> +                             goto error_exit;
>> +                     } else
>> +                             udf_warn(sb, "mirror inode efe not found, but metadata inode is OK\n");
>> +             } else if (UDF_I(mdata->s_mirror_fe)->i_alloc_type !=
>> +                      ICBTAG_FLAG_AD_SHORT) {
>> +                     udf_warn(sb, "mirror inode efe does not have short allocation descriptors!\n");
>> +                     iput(mdata->s_mirror_fe);
>> +                     mdata->s_mirror_fe = NULL;
>> +                     if (fe_error)
>> +                             goto error_exit;
>> +             }
>>       }
>>
>>       /*
>> --
>> 1.7.4.4
>>
> --
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
>
