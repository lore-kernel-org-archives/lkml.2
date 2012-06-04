Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760910Ab2FDQNO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 12:13:14 -0400
Received: from natasha.panasas.com ([67.152.220.90]:41251 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752297Ab2FDQNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 12:13:12 -0400
Message-ID: <4FCCDE86.4060507@panasas.com>
Date: Mon, 4 Jun 2012 19:12:54 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111113 Thunderbird/8.0
MIME-Version: 1.0
To: Artem Bityutskiy <dedekind1@gmail.com>
CC: Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        Benny Halevy <bhalevy@tonian.com>, <osd-dev@open-osd.org>
Subject: Re: [PATCH] exofs: stop using s_dirt
References: <1338810507-26539-1-git-send-email-dedekind1@gmail.com>
In-Reply-To: <1338810507-26539-1-git-send-email-dedekind1@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2012 02:48 PM, Artem Bityutskiy wrote:

> From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
> 
> Exofs has the '->write_super()' handler and makes some use of the '->s_dirt'
> superblock flag, but it really needs neither of them because it never sets
> 's_dirt' to one which means the VFS never calls its '->write_super()' handler.
> Thus, remove both.
> 


Thanks Artem. I have seen your other FS conversions and thought I would
eventually need to also do it for exofs, thanks for beating me to it ;-)

I have removed all uses of sb->s_dirt = 1 cases around last year, by
writing the SB-info as part of the create/delete commands directly. So
I agree it is not needed anymore see here
	1cea312 exofs: Write sbi->s_nextid as part of the Create command

I have one question though, which I did not understand at the time?

Today at exofs_write_super() we call exofs_sync_fs() (super_operations->sync_fs)
Who/when calls ->sync_fs() without the ->write_super() below.

But otherwise I agree that sb->s_dirt = 1 and ->write_super() are not needed
at all, for regular operations.

Should I take this for 3.6 through my tree. Or do you want my:

Ack-by: Boaz Harrosh <bharrosh@panasas.com>

> Note, I am trying to remove both 's_dirt' and 'write_super()' from VFS
> altogether once all users are gone.
> 
> Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
> ---
>  fs/exofs/super.c |   11 -----------
>  1 files changed, 0 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/exofs/super.c b/fs/exofs/super.c
> index 735ca06..6e1c515 100644
> --- a/fs/exofs/super.c
> +++ b/fs/exofs/super.c
> @@ -400,8 +400,6 @@ static int exofs_sync_fs(struct super_block *sb, int wait)
>  	ret = ore_write(ios);
>  	if (unlikely(ret))
>  		EXOFS_ERR("%s: ore_write failed.\n", __func__);
> -	else
> -		sb->s_dirt = 0;
>  
>  
>  	unlock_super(sb);
> @@ -412,14 +410,6 @@ out:
>  	return ret;
>  }
>  
> -static void exofs_write_super(struct super_block *sb)
> -{
> -	if (!(sb->s_flags & MS_RDONLY))
> -		exofs_sync_fs(sb, 1);
> -	else
> -		sb->s_dirt = 0;
> -}
> -
>  static void _exofs_print_device(const char *msg, const char *dev_path,
>  				struct osd_dev *od, u64 pid)
>  {
> @@ -942,7 +932,6 @@ static const struct super_operations exofs_sops = {
>  	.write_inode    = exofs_write_inode,
>  	.evict_inode    = exofs_evict_inode,
>  	.put_super      = exofs_put_super,
> -	.write_super    = exofs_write_super,
>  	.sync_fs	= exofs_sync_fs,
>  	.statfs         = exofs_statfs,
>  };


