Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752302Ab1GYRi2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 13:38:28 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:53182 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751113Ab1GYRiY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 13:38:24 -0400
Date: Mon, 25 Jul 2011 13:38:11 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Josef Bacik <josef@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, hch@infradead.org, viro@zeniv.linux.org.uk,
        jack@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs: push i_mutex and filemap_write_and_wait down into
 ->fsync() handlers
Message-ID: <20110725173811.GJ3469@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>, Josef Bacik <josef@redhat.com>,
	linux-fsdevel@vger.kernel.org, hch@infradead.org,
	viro@zeniv.linux.org.uk, jack@suse.cz, linux-kernel@vger.kernel.org
References: <1309370716-12235-1-git-send-email-josef@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309370716-12235-1-git-send-email-josef@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 29, 2011 at 02:05:16PM -0400, Josef Bacik wrote:
> diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
> index ce66d2f..da3bed3 100644
> --- a/fs/ext4/fsync.c
> +++ b/fs/ext4/fsync.c
> @@ -151,6 +151,32 @@ static int ext4_sync_parent(struct inode *inode)
>  	return ret;
>  }
>  
> +/**
> + * __sync_file - generic_file_fsync without the locking and filemap_write
> + * @inode:	inode to sync
> + * @datasync:	only sync essential metadata if true
> + *
> + * This is just generic_file_fsync without the locking.  This is needed for
> + * nojournal mode to make sure this inodes data/metadata makes it to disk
> + * properly.  The i_mutex should be held already.
> + */
> +static int __sync_inode(struct inode *inode, int datasync)

The comment calls this __sync_file, instead of __sync_inode.

Maybe it would be better to define a generic_file_fsync_nolock() in
fs/libfs.c and then have generic_file_fsync() call the _nolock()
function?  That way we don't have the code duplicated in two different
places, and eventually risking it going out of sync with each other.

	    	       	       	  	- Ted
