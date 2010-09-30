Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756906Ab0I3WYw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 18:24:52 -0400
Received: from cantor.suse.de ([195.135.220.2]:57081 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755613Ab0I3WYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 18:24:51 -0400
Date: Fri, 1 Oct 2010 00:23:54 +0200
From: Jan Kara <jack@suse.cz>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] [RFC] isofs: work-around for Rock Ridge+Joliet CDs
 with empty ISO root directory
Message-ID: <20100930222354.GG3573@quack.suse.cz>
References: <201009052139.06313.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201009052139.06313.linux@rainbow-software.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 05-09-10 21:39:04, Ondrej Zary wrote:
> If a CD has both Rock Ridge and Joliet extensions and the ISO root directory
> is empty, no files are visible. Disable Rock Ridge extensions in this case and
> use Joliet root directory instead.
  Thanks for the patch but as you properly mention in the comment, such CDs
are rather broken. Proper way to mount them would be to use 'norock' mount
option (which is essentially manual equivalent of your patch). So I'd
prefer to not introduce this workaround into the kernel. Or do you have
some good reason why kernel should handle this?

								Honza
> 
> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
> ---
> This is v2 with variable initialization.
> 
> --- linux-2.6.35-rc2/fs/isofs/inode.c	2010-06-06 05:43:24.000000000 +0200
> +++ linux-2.6.35-rc3/fs/isofs/inode.c	2010-08-31 23:43:46.000000000 +0200
> @@ -549,6 +549,34 @@ static unsigned int isofs_get_last_sessi
>  }
>  
>  /*
> + * Check if root directory is empty (has less than 3 files).
> + *
> + * Used to detect broken CDs where ISO root directory is empty but Joliet root
> + * directory is OK. If such CD has Rock Ridge extensions, they will be disabled
> + * (and Joliet used instead) or else no files would be visible.
> + */
> +static bool rootdir_empty(struct super_block *sb, unsigned long block)
> +{
> +	int offset = 0, files = 0, de_len;
> +	struct iso_directory_record *de;
> +	struct buffer_head *bh;
> +
> +	bh = sb_bread(sb, block);
> +	if (!bh)
> +		return true;
> +	while (files < 3) {
> +		de = (struct iso_directory_record *) (bh->b_data + offset);
> +		de_len = *(unsigned char *) de;
> +		if (de_len == 0)
> +			break;
> +		files++;
> +		offset += de_len;
> +	}
> +	brelse(bh);
> +	return files < 3;
> +}
> +
> +/*
>   * Initialize the superblock and read the root inode.
>   *
>   * Note: a check_disk_change() has been done immediately prior
> @@ -842,6 +870,18 @@ root_found:
>  		goto out_no_root;
>  
>  	/*
> +	 * Fix for broken CDs with Rock Ridge and empty ISO root directory but
> +	 * correct Joliet root directory.
> +	 */
> +	if (sbi->s_rock == 1 && joliet_level &&
> +				rootdir_empty(s, sbi->s_firstdatazone)) {
> +		printk(KERN_NOTICE
> +			"ISOFS: primary root directory is empty. "
> +			"Disabling Rock Ridge and switching to Joliet.");
> +		sbi->s_rock = 0;
> +	}
> +
> +	/*
>  	 * If this disk has both Rock Ridge and Joliet on it, then we
>  	 * want to use Rock Ridge by default.  This can be overridden
>  	 * by using the norock mount option.  There is still one other
> 
> 
> -- 
> Ondrej Zary
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
