Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915Ab2ACMqc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 07:46:32 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35107 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751574Ab2ACMq0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 07:46:26 -0500
Date: Tue, 3 Jan 2012 13:46:24 +0100
From: Jan Kara <jack@suse.cz>
To: Djalal Harouni <tixxdz@opendz.org>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Yongqiang Yang <xiaoqiangnk@gmail.com>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] fs/ext{3,4}: fix potential race when setversion ioctl
 updates inode
Message-ID: <20120103124624.GB31457@quack.suse.cz>
References: <20120103013152.GA26455@dztty>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120103013152.GA26455@dztty>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello,

On Tue 03-01-12 02:31:52, Djalal Harouni wrote:
> 
> The EXT{3,4}_IOC_SETVERSION ioctl() updates the inode without i_mutex,
> this can lead to a race with the other operations that update the same
> inode.
> 
> Patch tested.
  Thanks for the patch but I don't quite understand the problem.
i_generation is set when:
  a) inode is loaded from disk
  b) inode is allocated
  c) in SETVERSION ioctl

  The only thing that can race here seems to be c) against c) and that is
racy with i_mutex as well. So what problems do you exactly observe without
the patch?

								Honza
> Signed-off-by: Djalal Harouni <tixxdz@opendz.org>
> ---
>  fs/ext3/ioctl.c |    6 +++++-
>  fs/ext4/ioctl.c |    6 +++++-
>  2 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext3/ioctl.c b/fs/ext3/ioctl.c
> index ba1b54e..e7b2ed9 100644
> --- a/fs/ext3/ioctl.c
> +++ b/fs/ext3/ioctl.c
> @@ -134,10 +134,11 @@ flags_out:
>  			goto setversion_out;
>  		}
>  
> +		mutex_lock(&inode->i_mutex);
>  		handle = ext3_journal_start(inode, 1);
>  		if (IS_ERR(handle)) {
>  			err = PTR_ERR(handle);
> -			goto setversion_out;
> +			goto unlock_out;
>  		}
>  		err = ext3_reserve_inode_write(handle, inode, &iloc);
>  		if (err == 0) {
> @@ -146,6 +147,9 @@ flags_out:
>  			err = ext3_mark_iloc_dirty(handle, inode, &iloc);
>  		}
>  		ext3_journal_stop(handle);
> +
> +unlock_out:
> +		mutex_unlock(&inode->i_mutex);
>  setversion_out:
>  		mnt_drop_write(filp->f_path.mnt);
>  		return err;
> diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
> index a567968..46a8de6 100644
> --- a/fs/ext4/ioctl.c
> +++ b/fs/ext4/ioctl.c
> @@ -158,10 +158,11 @@ flags_out:
>  			goto setversion_out;
>  		}
>  
> +		mutex_lock(&inode->i_mutex);
>  		handle = ext4_journal_start(inode, 1);
>  		if (IS_ERR(handle)) {
>  			err = PTR_ERR(handle);
> -			goto setversion_out;
> +			goto unlock_out;
>  		}
>  		err = ext4_reserve_inode_write(handle, inode, &iloc);
>  		if (err == 0) {
> @@ -170,6 +171,9 @@ flags_out:
>  			err = ext4_mark_iloc_dirty(handle, inode, &iloc);
>  		}
>  		ext4_journal_stop(handle);
> +
> +unlock_out:
> +		mutex_unlock(&inode->i_mutex);
>  setversion_out:
>  		mnt_drop_write(filp->f_path.mnt);
>  		return err;
> -- 
> 1.7.1
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
