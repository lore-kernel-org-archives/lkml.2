Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751714Ab2LNFlX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 00:41:23 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:32770 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049Ab2LNFlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 00:41:21 -0500
MIME-Version: 1.0
In-Reply-To: <1355460921.16178.21.camel@kjgkr>
References: <1355409851-6389-1-git-send-email-linkinjeon@gmail.com>
	<1355460921.16178.21.camel@kjgkr>
Date: Fri, 14 Dec 2012 14:41:20 +0900
Message-ID: <CAKYAXd8Q38vG83Hc2jB3tM9xjkgWH=dNae6qLTuVceBGqRvdsQ@mail.gmail.com>
Subject: Re: [PATCH v2] f2fs: fix up f2fs_get_parent issue to retrieve correct
 parent inode number
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/12/14, Jaegeuk Kim <jaegeuk.kim@samsung.com>:
> Hi,
>
>> diff --git a/fs/f2fs/hash.c b/fs/f2fs/hash.c
>> index a60f042..5e48bac 100644
>> --- a/fs/f2fs/hash.c
>> +++ b/fs/f2fs/hash.c
>> @@ -76,6 +76,10 @@ f2fs_hash_t f2fs_dentry_hash(const char *name, int
>> len)
>>  	const char *p;
>>  	__u32 in[8], buf[4];
>>
>> +	if ((len <= 2) && (name[0] == '.') &&
>> +		(name[1] == '.' || name[1] == '\0'))
>> +		return 0;
>
> If len == 1, we should avoid referencing name[1].
> Likewise VFS does, I rewrote that like below.
>
> 	if (name[0] == '.') {
> 		switch (len) {
> 		case 1:
> 			return 0;
> 		case 2:
> 			if (name[1] == '.')
> 				return 0;
> 		}
> 	}
>
> So, how about this patch?

I think that there is no issue on current patch. Since, the strings
are always expected to be NULL terminated.

"." should include '\0', So we can distingsh by checking only name[0], name[1].

When we do:
char *ptr="hello"; -> it will always be NULL terminated -> "hello" in
memory followed by '\0';
when we reserver space
char ptr[5];-> We need to reserver space for '\0' at the end.

Also, even if we donot encounter NULL at the end.
there should be no problem referencing the memory, it is just we can
get garbage value from that refrencing.

May be I am not able to think the code path which will cause the problem.
Is it possible that "." is not null termindated ?

Otherwise, in my opinion - we can retain the suggested changes, there
is no need to introducing switch case, even
though technically there is no issues in the code you suggested also.

So, final decision is yours.

Thanks.

>
> From 391d584afadfb177584a3a3e4a7ec97e1a674457 Mon Sep 17 00:00:00 2001
> From: Namjae Jeon <namjae.jeon@samsung.com>
> Date: Thu, 13 Dec 2012 23:44:11 +0900
> Subject: [PATCH] f2fs: fix up f2fs_get_parent issue to retrieve correct
> parent
>  inode number
>
> Test Case:
> [NFS Client]
> ls -lR .
>
> [NFS Server]
> while [ 1 ]
> do
> echo 3 > /proc/sys/vm/drop_caches
> done
>
> Error on NFS Client: "No such file or directory"
>
> When cache is dropped at the server, it results in lookup failure at the
> NFS client due to non-connection with the parent. The default path is it
> initiates a lookup by calculating the hash value for the name, even
> though
> the hash values stored on the disk for "." and ".." is maintained as
> zero,
> which results in failure from find_in_block due to not matching HASH
> values.
> Fix up, by using the correct hashing values for these entries.
>
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
> Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
> ---
>  fs/f2fs/dir.c  |  4 ++--
>  fs/f2fs/hash.c | 10 ++++++++++
>  2 files changed, 12 insertions(+), 2 deletions(-)
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
> index a60f042..9d7a7c6 100644
> --- a/fs/f2fs/hash.c
> +++ b/fs/f2fs/hash.c
> @@ -76,6 +76,16 @@ f2fs_hash_t f2fs_dentry_hash(const char *name, int
> len)
>  	const char *p;
>  	__u32 in[8], buf[4];
>
> +	if (name[0] == '.') {
> +		switch (len) {
> +		case 1:
> +			return 0;
> +		case 2:
> +			if (name[1] == '.')
> +				return 0;
> +		}
> +	}
> +
>  	/* Initialize the default seed for the hash checksum functions */
>  	buf[0] = 0x67452301;
>  	buf[1] = 0xefcdab89;
> --
> 1.8.0.1.250.gb7973fb
>
> --
> Jaegeuk Kim
> Samsung
>
