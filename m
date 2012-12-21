Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113Ab2LUKpm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 05:45:42 -0500
Received: from mail-we0-f172.google.com ([74.125.82.172]:61132 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603Ab2LUKpf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 05:45:35 -0500
X-Greylist: delayed 1804 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Dec 2012 05:45:34 EST
MIME-Version: 1.0
In-Reply-To: <877gobn7fy.fsf@devron.myhome.or.jp>
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
Date: Fri, 21 Dec 2012 19:15:29 +0900
Message-ID: <CAKYAXd8SB7tz82Y57TKcngZC8vzvy1S=SAhzurA92jyobaVtNg@mail.gmail.com>
Subject: Re: [PATCH v5 7/8] fat (exportfs): rebuild directory-inode if
 fat_dget() fails
From: Namjae Jeon <linkinjeon@gmail.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/12/21, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
> Namjae Jeon <linkinjeon@gmail.com> writes:
>
>>>> Hm, start with copy of fat_search_long() and refactoring it. With it,
>>>> we
>>>> will be able to avoid the fixed bugs.
>>>>
>>>> After that, we might be able to merge those somehow. Well, I'm not
>>>> pretty sure without doing it actually though.
>> Hi OGAWA.
>>
>> When we checked to merge it with fat_search_long, we really did not
>> find any possibility of code reusing for fat_traverse_cluster.
>> It will not be proper. In case of fat_search_long()-> it is performing
>> a name based lookup in a particular directory.
>> While for reconnection with parent from NFS, we do not have the name
>> of the parent directory. We are relying on ‘i_pos’ on disk position of
>> directory entry.
>> So, on first request for lookup for “..” (i.e if we call
>> fat_search_long(child_dir->d_inode, MSDOS_DOTDOT,2,slot_info) it will
>> return the directory entry for “..” itself.  From this entry we can
>> read the “log start” which is the starting cluster of the parent
>> directory, but instead we need the “directory entry” where this is
>> stored.
>> So, from this level we need to go further one level up and read the
>> parent ->parent-> cluster. After reading that cluster, we need to do a
>> lookup of the “required ipos” in this directory block.
>> i.e., if the path is A/B/C and we call the get_parent() from ‘C’. We
>> need to read the directory block contents of ‘A’ and from those
>> ‘directory entries' compare the log_start with the log_start value of
>> B, which was obtained by doing a lookup “..” in C.
>> So, Instead of it, we suggest we fix the “infinite-loop” condition in
>> fat_traverse_logic and retain the code.
>> of course, we will test it with corrupted FATfs.
>> Please share your thoughts on this.
>
> Yes, we can't use fat_search_long() as is, of course. However, we can
> share the basic algorithm and code.
>
> The both are doing,
>
> 1) traverse the blocks chained by ->i_start.
> 2) get the record (dirent) from blocks.
> 3) check the detail of record
>
> The difference is only (3), right? I know, the code has many differences
> though. The actual logic are almost same.
>
> And see, e.g., fat_get_cluster() is checking several unexpected
> state. We have to care about corrupting data. It is not only
> "infinite-loop" case.  And why I'm saying it is better to share code.

Regarding unexpected conditions,
When we compare the unexpected conditions in fat_get_cluster:
We get these as conditions which can arise:
fat_end_read() returns:
 1) < 0
 2) FAT_ENT_FREE
 3) FAT_ENT_EOF
And the last is
      4) Preventing the infinite looping of cluster chain.

Our patch is already covering the cases:
 case 1) , 2) =>  if (search_clus < 0 || search_clus == FAT_ENT_FREE)
 about  case 3) => while (search_clus != FAT_ENT_EOF);

while for Case 4:
We can make changes like this:

@@ -179,8 +179,9 @@ struct dentry *fat_get_parent(struct dentry *child_dir)
        struct inode *parent_inode = NULL;
        struct msdos_sb_info *sbi = MSDOS_SB(sb);
        int parent_logstart;
-       int search_clus, clus_to_match;
+       int search_clus, clus_to_match, clus_count = 0;
        sector_t blknr;
+       const int limit = sb->s_maxbytes >> MSDOS_SB(sb)->cluster_bits;

        if (!fat_get_dotdot_entry(child_dir->d_inode, &dotdot_bh, &de)) {
                parent_logstart = fat_get_start(sbi, de);
@@ -223,6 +224,14 @@ struct dentry *fat_get_parent(struct dentry *child_dir)
                                                search_clus, clus_to_match);
                                if (IS_ERR(parent_inode) || parent_inode)
                                        break;
+                               if (++clus_count > limit) {
+                                       fat_fs_error_ratelimit(sb,
+                                       "%s: detected the cluster chain loop"
+                                       " while reading directory entries from"
+                                       " cluster %d", __func__, search_clus);
+                                       parent_inode = ERR_PTR(-EIO);
+                                       break;
+                               }
                                fatent_init(&fatent);
                                search_clus = fat_ent_read(sb, &fatent,
                                                           search_clus);
-- 
1.7.7.6

Are we missing anything more in this?

Thanks.
>
> Thanks.
> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>
