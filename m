Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933528Ab1KBT1m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 15:27:42 -0400
Received: from [85.183.114.52] ([85.183.114.52]:56059 "EHLO Dublin.logfs.org"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S932850Ab1KBT1j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 15:27:39 -0400
X-Greylist: delayed 1669 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Nov 2011 15:27:39 EDT
Date: Wed, 2 Nov 2011 20:00:46 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Prasad Joshi <prasadjoshi.linux@gmail.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Josef Bacik <josef@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: linux-next: manual merge of the logfs tree with Linus' tree
Message-ID: <20111102190046.GB3485@logfs.org>
References: <20111101141000.3531dbfbf0490c6d3521d6b6@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20111101141000.3531dbfbf0490c6d3521d6b6@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 November 2011 14:10:00 +1100, Stephen Rothwell wrote:
> 
> Hi all,
> 
> Today's linux-next merge of the logfs tree got a conflict in
> fs/logfs/file.c between commit 02c24a82187d ("fs: push i_mutex and
> filemap_write_and_wait down into ->fsync() handlers") from Linus' tree
> and commit 39da12ef4bbe ("logfs: take write mutex lock during fsync and
> sync") from the logfs tree.
> 
> I have no idea what needs to be done here.  I fixed it like below to make
> it build, but a better fix is needed.

>From a code perspective your fix below is correct, to the best of my
judgement.  I'm less sure what to do from a git perspective.
Explicitly tell Linus about it in the logfs pull request?

> diff --cc fs/logfs/file.c
> index b548c87,f85d603..0000000
> --- a/fs/logfs/file.c
> +++ b/fs/logfs/file.c
> @@@ -219,20 -219,13 +219,22 @@@ long logfs_ioctl(struct file *file, uns
>   	}
>   }
>   
>  -int logfs_fsync(struct file *file, int datasync)
>  +int logfs_fsync(struct file *file, loff_t start, loff_t end, int datasync)
>   {
>   	struct super_block *sb = file->f_mapping->host->i_sb;
>  +	struct inode *inode = file->f_mapping->host;
>  +	int ret;
>  +
>  +	ret = filemap_write_and_wait_range(inode->i_mapping, start, end);
>  +	if (ret)
>  +		return ret;
>   
>  +	mutex_lock(&inode->i_mutex);
> + 	logfs_get_wblocks(sb, NULL, WF_LOCK);
>   	logfs_write_anchor(sb);
> + 	logfs_put_wblocks(sb, NULL, WF_LOCK);
>  +	mutex_unlock(&inode->i_mutex);
>  +
>   	return 0;
>   }
>   



Jörn

-- 
You can take my soul, but not my lack of enthusiasm.
-- Wally
