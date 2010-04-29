Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933405Ab0D3S1B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 14:27:01 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:43466 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759354Ab0D3S02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 14:26:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=hfTkilboQVzB0BtOxzu+zwmw0MA9IIvEwoyabRU+GS00Oc6WZ6ZJYFyPZ3Jcr8A4vQ
         ctxsYW6JqkjUpaiUEnrIdxR6efo5UDskxO3Nrr/YLvcRwcfVAvkwP94s0Rmmz5UkKeiB
         SnsHIp8VXjcbaHqwj1tQR+25mqfmHjT6Ce94E=
Message-ID: <4BD95E7A.90402@panasas.com>
Date: Thu, 29 Apr 2010 13:24:58 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jens Axboe <Jens.Axboe@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: exofs: add bdi backing to mount session
References: <201004282059.o3SKx7hG029846@hera.kernel.org>
In-Reply-To: <201004282059.o3SKx7hG029846@hera.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/28/2010 11:59 PM, Linux Kernel Mailing List wrote:
> Gitweb:     http://git.kernel.org/linus/b3d0ab7e60d1865bb6f6a79a77aaba22f2543236
> Commit:     b3d0ab7e60d1865bb6f6a79a77aaba22f2543236
> Parent:     9df9c8b930156a2f9ce2b2ae66acb14bee2663f5
> Author:     Jens Axboe <jens.axboe@oracle.com>
> AuthorDate: Thu Apr 22 12:26:04 2010 +0200
> Committer:  Jens Axboe <jens.axboe@oracle.com>
> CommitDate: Thu Apr 22 12:26:04 2010 +0200
> 
>     exofs: add bdi backing to mount session
>     
>     This ensures that dirty data gets flushed properly.
>     
>     Signed-off-by: Jens Axboe <jens.axboe@oracle.com>

This patch introduced a bug (together with a fix). I'm sorry that
my "Linux Kernel Mailing List" filtering techniques are lacking and
I missed it completely. Searching on google I can see it was hiding
under "[GIT PULL] block/writeback bits for 2.6.34-rc". I have only
seen it now, in git-commits-head ml.

I wish filesystem related patches where CC to linux-fsdevel, and/or
posted as individual patches, sigh.

I'll post a fix as reply to this mail. Linus please submit.

Boaz
> ---
>  fs/exofs/exofs.h |    2 ++
>  fs/exofs/super.c |    8 ++++++++
>  2 files changed, 10 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/exofs/exofs.h b/fs/exofs/exofs.h
> index 8442e35..5437327 100644
> --- a/fs/exofs/exofs.h
> +++ b/fs/exofs/exofs.h
> @@ -35,6 +35,7 @@
>  
>  #include <linux/fs.h>
>  #include <linux/time.h>
> +#include <linux/backing-dev.h>
>  #include "common.h"
>  
>  /* FIXME: Remove once pnfs hits mainline
> @@ -92,6 +93,7 @@ struct exofs_sb_info {
>  	struct exofs_layout	layout;		/* Default files layout,
>  						 * contains the variable osd_dev
>  						 * array. Keep last */
> +	struct backing_dev_info bdi;
>  	struct osd_dev	*_min_one_dev[1];	/* Place holder for one dev   */
>  };
>  
> diff --git a/fs/exofs/super.c b/fs/exofs/super.c
> index 18e57ea..03149b9 100644
> --- a/fs/exofs/super.c
> +++ b/fs/exofs/super.c
> @@ -302,6 +302,7 @@ static void exofs_put_super(struct super_block *sb)
>  	_exofs_print_device("Unmounting", NULL, sbi->layout.s_ods[0],
>  			    sbi->layout.s_pid);
>  
> +	bdi_destroy(&sbi->bdi);
>  	exofs_free_sbi(sbi);
>  	sb->s_fs_info = NULL;
>  }
> @@ -546,6 +547,10 @@ static int exofs_fill_super(struct super_block *sb, void *data, int silent)
>  	if (!sbi)
>  		return -ENOMEM;
>  
> +	ret = bdi_setup_and_register(&sbi->bdi, "exofs", BDI_CAP_MAP_COPY);
> +	if (ret)
> +		goto free_bdi;
> +
>  	/* use mount options to fill superblock */
>  	od = osduld_path_lookup(opts->dev_name);
>  	if (IS_ERR(od)) {
> @@ -612,6 +617,7 @@ static int exofs_fill_super(struct super_block *sb, void *data, int silent)
>  	}
>  
>  	/* set up operation vectors */
> +	sb->s_bdi = &sbi->bdi;
>  	sb->s_fs_info = sbi;
>  	sb->s_op = &exofs_sops;
>  	sb->s_export_op = &exofs_export_ops;
> @@ -643,6 +649,8 @@ static int exofs_fill_super(struct super_block *sb, void *data, int silent)
>  	return 0;
>  
>  free_sbi:
> +	bdi_destroy(&sbi->bdi);
> +free_bdi:
>  	EXOFS_ERR("Unable to mount exofs on %s pid=0x%llx err=%d\n",
>  		  opts->dev_name, sbi->layout.s_pid, ret);
>  	exofs_free_sbi(sbi);
> --
> To unsubscribe from this list: send the line "unsubscribe git-commits-head" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

