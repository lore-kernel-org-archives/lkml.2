Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751656Ab0D0FSr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 01:18:47 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:51865 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139Ab0D0FSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 01:18:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=kgTjGIx8DETNo6zFQh1FXG/9GPsKgK6ug7djosnrZxo67nSYdFBkF9+0uugCo9f9F6
         oLTu/bk5fxMJddCCJazB/GU9vaq9djQ6lEzgL+WRUIW3VanJk51G4/f4k6oOOd90bkj7
         mY5QDYn3cwKIjNl6ypmSlSTw3a6OEdMT+m9fQ=
Date: Tue, 27 Apr 2010 07:18:42 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Arnd Bergmann <arnd@arndb.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: linux-next: manual merge of the bkl-ioctl tree with the
	bkl-procfs tree
Message-ID: <20100427051841.GF5695@nowhere>
References: <20100427150636.241eb65b.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100427150636.241eb65b.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 27, 2010 at 03:06:36PM +1000, Stephen Rothwell wrote:
> Hi Frédéric,
> 
> Today's linux-next merge of the bkl-ioctl tree got a conflict in
> fs/proc/inode.c between commit 3ab8dfb0802f33741cc4afa6adf7cb30b1cd1761
> ("procfs: Kill the bkl in ioctl") from the bkl-procfs tree and commit
> 1dd97d3d546aa14db7efa5366b21d1336b91379e ("Rename 'struct
> file_operations' 'ioctl' fn pointer to 'bkl_ioctl'") from the bkl-ioctl
> tree.
> 
> I fixed it up (see below - probably not optimal) and can carry the fix as
> necessary.
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc fs/proc/inode.c
> index aea8502,8e8f813..0000000
> --- a/fs/proc/inode.c
> +++ b/fs/proc/inode.c
> @@@ -231,10 -231,10 +231,10 @@@ static long proc_reg_unlocked_ioctl(str
>   		rv = unlocked_ioctl(file, cmd, arg);
>   		if (rv == -ENOIOCTLCMD)
>   			rv = -EINVAL;
> - 	} else if (ioctl) {
> + 	} else if (bkl_ioctl) {
>  -		lock_kernel();
>  +		WARN_ONCE(1, "Procfs ioctl handlers must use unlocked_ioctl, "
>  +			  "%pf will be called without the Bkl held\n", bkl_ioctl);
> - 		rv = ioctl(file->f_path.dentry->d_inode, file, cmd, arg);
> + 		rv = bkl_ioctl(file->f_path.dentry->d_inode, file, cmd, arg);
>  -		unlock_kernel();
>   	}
>   
>   	pde_users_dec(pde);


Thanks, looks like the right fix!

