Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755728Ab2LLAtF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 19:49:05 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:50006 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754191Ab2LLAtA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 19:49:00 -0500
MIME-Version: 1.0
In-Reply-To: <1355272421.24219.11.camel@kjgkr>
References: <1355238625-6581-1-git-send-email-linkinjeon@gmail.com>
	<1355272421.24219.11.camel@kjgkr>
Date: Wed, 12 Dec 2012 09:48:59 +0900
Message-ID: <CAKYAXd_ZkJ5DJnQP7rH0DNH501Ty9Hj+2UDJ4thev6M_POHx1g@mail.gmail.com>
Subject: Re: [PATCH] f2fs: fix up f2fs_get_parent issue to retrieve correct
 parent inode number
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/12/12, Jaegeuk Kim <jaegeuk.kim@samsung.com>:
> 2012-12-12 (수), 00:10 +0900, Namjae Jeon:
>> From: Namjae Jeon <namjae.jeon@samsung.com>
>>
>> Test Case:
>> [NFS Client]
>> ls -lR .
>>
>> [NFS Server]
>> while [ 1 ]
>> do
>> echo 3 > /proc/sys/vm/drop_caches
>> done
>>
>> Error on NFS Client: "No such file or directory"
>>
>> When cache is dropped at the server, it results in lookup failure at the
>> NFS client due to non-connection with the parent. The default path is it
>> initiates a lookup by calculating the hash value for the name, even
>> though
>> the hash values stored on the disk for "." and ".." is maintained as
>> zero,
>> which results in failure from find_in_block due to not matching HASH
>> values.
>> Fix up, by using the correct hashing values for these entries and
>> then initiating lookup request.
>>
>> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
>> Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
>> ---
>>  fs/f2fs/dir.c |    5 +++--
>>  1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
>> index b4e24f3..6cf39db 100644
>> --- a/fs/f2fs/dir.c
>> +++ b/fs/f2fs/dir.c
>> @@ -184,7 +184,7 @@ struct f2fs_dir_entry *f2fs_find_entry(struct inode
>> *dir,
>>  	int namelen = child->len;
>>  	unsigned long npages = dir_blocks(dir);
>>  	struct f2fs_dir_entry *de = NULL;
>> -	f2fs_hash_t name_hash;
>> +	f2fs_hash_t name_hash = 0;
>>  	unsigned int max_depth;
>>  	unsigned int level;
>>
>> @@ -193,7 +193,8 @@ struct f2fs_dir_entry *f2fs_find_entry(struct inode
>> *dir,
>>
>>  	*res_page = NULL;
>>
>> -	name_hash = f2fs_dentry_hash(name, namelen);
>> +	if (strcmp(name, ".") && (strcmp(name, "..")))
>> +		name_hash = f2fs_dentry_hash(name, namelen);
>
> Got it.
> For code consistency, could you rewrite the patch like below?
> Thanks,
Sure, I will resend the patch at tonight.
Thanks!
>
> diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
> index b4e24f3..e1f66df 100644
> --- a/fs/f2fs/dir.c
> +++ b/fs/f2fs/dir.c
> @@ -540,13 +540,13 @@ int f2fs_make_empty(struct inode *inode, struct
> inode *parent)
>
>  	de = &dentry_blk->dentry[0];
>  	de->name_len = cpu_to_le16(1);
> -	de->hash_code = 0;
> +	de->hash_code = f2fs_dentry_hash(".", 1);
>  	de->ino = cpu_to_le32(inode->i_ino);
>  	memcpy(dentry_blk->filename[0], ".", 1);
>  	set_de_type(de, inode);
>
>  	de = &dentry_blk->dentry[1];
> -	de->hash_code = 0;
> +	de->hash_code = f2fs_dentry_hash("..", 2);
>  	de->name_len = cpu_to_le16(2);
>  	de->ino = cpu_to_le32(parent->i_ino);
>  	memcpy(dentry_blk->filename[1], "..", 2);
> diff --git a/fs/f2fs/hash.c b/fs/f2fs/hash.c
> index a60f042..30ca4a2 100644
> --- a/fs/f2fs/hash.c
> +++ b/fs/f2fs/hash.c
> @@ -76,6 +76,10 @@ f2fs_hash_t f2fs_dentry_hash(const char *name, int
> len)
>  	const char *p;
>  	__u32 in[8], buf[4];
>
> +	/* dot and dotdot dentries should have zero-value hash code */
> +	if (!memcmp(name, ".", 1) || !memcmp(name, "..", 2))
> +		return 0;
> +
>  	/* Initialize the default seed for the hash checksum functions */
>  	buf[0] = 0x67452301;
>  	buf[1] = 0xefcdab89;
> --
> 1.8.0.1.250.gb7973fb
>
>
>
> --
> Jaegeuk Kim
> Samsung
>
