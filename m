Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756385Ab1DKX2d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 19:28:33 -0400
Received: from mail.tpi.com ([70.99.223.143]:4978 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753510Ab1DKX2c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 19:28:32 -0400
Message-ID: <4DA38E90.4020101@canonical.com>
Date: Mon, 11 Apr 2011 16:28:16 -0700
From: Tim Gardner <tim.gardner@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110411 Thunderbird/3.1.9
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Harry Wei <jiaweiwei.xiyou@gmail.com>, petr@vandrovec.name,
        viro@zeniv.linux.org.uk, arnd@arndb.de, npiggin@kernel.dk,
        jens.axboe@oracle.com, greg@kroah.com, joe@perches.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH]initialize the array of fs/ncpfs/inode.c
References: <20110410100816.GB4953@gmail.com> <20110411161838.dabbc3f3.akpm@linux-foundation.org>
In-Reply-To: <20110411161838.dabbc3f3.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2011 04:18 PM, Andrew Morton wrote:
> On Sun, 10 Apr 2011 18:08:18 +0800
> Harry Wei<jiaweiwei.xiyou@gmail.com>  wrote:
>
>> Hi us,
>> 	When i compile the linux-2.6.38.2, some warnings happened
>> to me. One of them is like following.
>>
>> fs/ncpfs/inode.c: In function 'ncp_fill_super':
>> fs/ncpfs/inode.c:451: warning: 'data.mounted_vol[1u]' may be used
>> uninitialized in this function
>> ...
>> See details by the URL:
>> http://s1202.photobucket.com/albums/bb364/harrywei/Kernel/?action=view&current=patched.png
>
> Yup.  The compiler is "wrong" because it doesn't know that the
> uninitialised bytes will never be read, because they fall after the
> '\0' in a null-terminated string.
>
>> @@ -461,6 +462,7 @@ static int ncp_fill_super(struct super_block *sb, void *raw_data, int silent)
>>   #endif
>>   	struct ncp_entry_info finfo;
>>
>> +	data.mounted_vol[NCP_VOLNAME_LEN + 1] = {0};
>>   	data.wdog_pid = NULL;
>>   	server = kzalloc(sizeof(struct ncp_server), GFP_KERNEL);
>>   	if (!server)
>
> hm.  I'm not sure that this fixed data.mounted_vol[2u],
> data.mounted_vol[3u], etc.
>
> How about we use the big hammer?
>
>
>
> From: Andrew Morton<akpm@linux-foundation.org>
>
> fs/ncpfs/inode.c: In function 'ncp_fill_super':
> fs/ncpfs/inode.c:451: warning: 'data.mounted_vol[1u]' may be used uninitialized in this function
> fs/ncpfs/inode.c:451: warning: 'data.mounted_vol[2u]' may be used uninitialized in this function
> fs/ncpfs/inode.c:451: warning: 'data.mounted_vol[3u]' may be used uninitialized in this function
> ...
>
> It's notabug, but we can easily fix it with a memset().
>
> Reported-by: Harry Wei<jiaweiwei.xiyou@gmail.com>
> Cc: Petr Vandrovec<petr@vandrovec.name>
> Signed-off-by: Andrew Morton<akpm@linux-foundation.org>
> ---
>
>   fs/ncpfs/inode.c |    4 +---
>   1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff -puN fs/ncpfs/inode.c~fs-ncpfs-inodec-suppress-used-uninitialised-warning fs/ncpfs/inode.c
> --- a/fs/ncpfs/inode.c~fs-ncpfs-inodec-suppress-used-uninitialised-warning
> +++ a/fs/ncpfs/inode.c
> @@ -461,7 +461,7 @@ static int ncp_fill_super(struct super_b
>   #endif
>   	struct ncp_entry_info finfo;
>
> -	data.wdog_pid = NULL;
> +	memset(data, 0, sizeof(data));

Needs '&' ?

	memset(&data, 0, sizeof(data));

>   	server = kzalloc(sizeof(struct ncp_server), GFP_KERNEL);
>   	if (!server)
>   		return -ENOMEM;
> @@ -496,7 +496,6 @@ static int ncp_fill_super(struct super_b
>   				struct ncp_mount_data_v4* md = (struct ncp_mount_data_v4*)raw_data;
>
>   				data.flags = md->flags;
> -				data.int_flags = 0;
>   				data.mounted_uid = md->mounted_uid;
>   				data.wdog_pid = find_get_pid(md->wdog_pid);
>   				data.ncp_fd = md->ncp_fd;
> @@ -507,7 +506,6 @@ static int ncp_fill_super(struct super_b
>   				data.file_mode = md->file_mode;
>   				data.dir_mode = md->dir_mode;
>   				data.info_fd = -1;
> -				data.mounted_vol[0] = 0;
>   			}
>   			break;
>   		default:
> _
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


-- 
Tim Gardner tim.gardner@canonical.com
