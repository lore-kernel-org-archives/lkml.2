Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016Ab2LUKfn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 05:35:43 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:55185 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751594Ab2LUKfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 05:35:33 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: Re: [PATCH v5 7/8] fat (exportfs): rebuild directory-inode if fat_dget() fails
References: <1353504311-6020-1-git-send-email-linkinjeon@gmail.com>
	<878v9f5ugn.fsf@devron.myhome.or.jp>
	<CAKYAXd-ydXkwDq6vkECEKPUQiNgg2+GKbL+ah9sn+uqr8BT1kQ@mail.gmail.com>
	<87k3sy17vk.fsf@devron.myhome.or.jp>
	<CAKYAXd8=7BG8NsVyvUP5xW48Y9FJpD7M95_MiJVGcwYOfYsrLA@mail.gmail.com>
	<87txs0x45r.fsf@devron.myhome.or.jp>
	<CAKYAXd8OP_FXxJWHESW_bCY1hGQuZPMJYOkLkmQ4fOkDhGO8xw@mail.gmail.com>
	<CAKYAXd9NXVsBTMpTUWxN_10z1Ozt47f6Ghvsv9rbp_Y8tVMg2A@mail.gmail.com>
	<87623ydnvq.fsf@devron.myhome.or.jp>
	<CAKYAXd8GgrG+cMN_wQDFLiuXoBPbR7c6N9eZqGCrK-OH3HpuZA@mail.gmail.com>
	<CAKYAXd9OhKDh5r6O=ACyDez1B2S=DB0Eo2-cSNuM1vaURmFNoQ@mail.gmail.com>
	<877gobn7fy.fsf@devron.myhome.or.jp>
	<CAKYAXd8SB7tz82Y57TKcngZC8vzvy1S=SAhzurA92jyobaVtNg@mail.gmail.com>
Date: Fri, 21 Dec 2012 19:35:30 +0900
In-Reply-To: <CAKYAXd8SB7tz82Y57TKcngZC8vzvy1S=SAhzurA92jyobaVtNg@mail.gmail.com>
	(Namjae Jeon's message of "Fri, 21 Dec 2012 19:15:29 +0900")
Message-ID: <87obhnlmkt.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

>> Yes, we can't use fat_search_long() as is, of course. However, we can
>> share the basic algorithm and code.
>>
>> The both are doing,
>>
>> 1) traverse the blocks chained by ->i_start.
>> 2) get the record (dirent) from blocks.
>> 3) check the detail of record
>>
>> The difference is only (3), right? I know, the code has many differences
>> though. The actual logic are almost same.
>>
>> And see, e.g., fat_get_cluster() is checking several unexpected
>> state. We have to care about corrupting data. It is not only
>> "infinite-loop" case.  And why I'm saying it is better to share code.
>
> Regarding unexpected conditions,
> When we compare the unexpected conditions in fat_get_cluster:
> We get these as conditions which can arise:
> fat_end_read() returns:
>  1) < 0
>  2) FAT_ENT_FREE
>  3) FAT_ENT_EOF
> And the last is
>       4) Preventing the infinite looping of cluster chain.
>
> Our patch is already covering the cases:
>  case 1) , 2) =>  if (search_clus < 0 || search_clus == FAT_ENT_FREE)
>  about  case 3) => while (search_clus != FAT_ENT_EOF);
>
> while for Case 4:
> We can make changes like this:
>
> @@ -179,8 +179,9 @@ struct dentry *fat_get_parent(struct dentry *child_dir)
>         struct inode *parent_inode = NULL;
>         struct msdos_sb_info *sbi = MSDOS_SB(sb);
>         int parent_logstart;
> -       int search_clus, clus_to_match;
> +       int search_clus, clus_to_match, clus_count = 0;
>         sector_t blknr;
> +       const int limit = sb->s_maxbytes >> MSDOS_SB(sb)->cluster_bits;
>
>         if (!fat_get_dotdot_entry(child_dir->d_inode, &dotdot_bh, &de)) {
>                 parent_logstart = fat_get_start(sbi, de);
> @@ -223,6 +224,14 @@ struct dentry *fat_get_parent(struct dentry *child_dir)
>                                                 search_clus, clus_to_match);
>                                 if (IS_ERR(parent_inode) || parent_inode)
>                                         break;
> +                               if (++clus_count > limit) {
> +                                       fat_fs_error_ratelimit(sb,
> +                                       "%s: detected the cluster chain loop"
> +                                       " while reading directory entries from"
> +                                       " cluster %d", __func__, search_clus);
> +                                       parent_inode = ERR_PTR(-EIO);
> +                                       break;
> +                               }
>                                 fatent_init(&fatent);
>                                 search_clus = fat_ent_read(sb, &fatent,
>                                                            search_clus);

and it is copy of fat_get_cluster(), right? It would be sane as start
though, it is true to increase maintain cost, and it makes more similar
to fat_search_long() path. It is why I said, copy at first, and
refactoring after that.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
