Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628Ab2KKLj3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 06:39:29 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:61173 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244Ab2KKLj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 06:39:27 -0500
MIME-Version: 1.0
In-Reply-To: <87fw4omibl.fsf@devron.myhome.or.jp>
References: <1351924134-14320-1-git-send-email-linkinjeon@gmail.com>
	<87fw4omibl.fsf@devron.myhome.or.jp>
Date: Sun, 11 Nov 2012 20:39:26 +0900
Message-ID: <CAKYAXd94Zb3Xqwo9WRGCKLAqyqvFWKgtE90Bz-PXJXgo++C+dQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] fat: warn when discard request fails other than EOPNOTSUPP
From: Namjae Jeon <linkinjeon@gmail.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Amit Sahrawat <amit.sahrawat83@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/11/5 OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
> Namjae Jeon <linkinjeon@gmail.com> writes:
>
>> FAT also warn user then the discard request fails
>> as ext4(http://patchwork.ozlabs.org/patch/192669/)
>
> Why don't we do this at block layer like normal bio?
Yes, maybe it will be better than doing in filesystem.
I will check more.
Thanks.
>
>> Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
>> Signed-off-by: Amit Sahrawat <amit.sahrawat83@gmail.com>
>> ---
>>  fs/fat/fatent.c |   15 +++++++++------
>>  1 file changed, 9 insertions(+), 6 deletions(-)
>>
>> diff --git a/fs/fat/fatent.c b/fs/fat/fatent.c
>> index 260705c..fc1f407 100644
>> --- a/fs/fat/fatent.c
>> +++ b/fs/fat/fatent.c
>> @@ -583,12 +583,15 @@ int fat_free_clusters(struct inode *inode, int cluster)
>>                        */
>>                       if (cluster != fatent.entry + 1) {
>>                               int nr_clus = fatent.entry - first_cl + 1;
>> -
>> -                             sb_issue_discard(sb,
>> -                                     fat_clus_to_blknr(sbi, first_cl),
>> -                                     nr_clus * sbi->sec_per_clus,
>> -                                     GFP_NOFS, 0);
>> -
>> +                             sector_t sblk = fat_clus_to_blknr(sbi, first_cl);
>> +                             sector_t nrblk = nr_clus * sbi->sec_per_clus;
>> +
>> +                             err = sb_issue_discard(sb,
>> +                                             sblk, nrblk, GFP_NOFS, 0);
>> +                             if (err && err != -EOPNOTSUPP)
>> +                                     fat_msg(sb, KERN_WARNING, "discard request for"
>> +                                                     " block:%llu count:%llu failed"
>> +                                                     " with %d", sblk, nrblk, err);
>>                               first_cl = cluster;
>>                       }
>>               }
>
> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
