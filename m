Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934633Ab0HFRQ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 13:16:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31372 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933385Ab0HFRQz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 13:16:55 -0400
Date: Fri, 6 Aug 2010 12:33:38 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: raven@themaw.net, viro@zeniv.linux.org.uk, jblunck@suse.de,
        hch@infradead.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 21/38] union-mount: Support for mounting union mount file systems
Message-ID: <20100806163338.GA15068@shell>
References: <1276627208-17242-1-git-send-email-vaurora@redhat.com> <1276627208-17242-22-git-send-email-vaurora@redhat.com> <20100713044701.GF3949@zeus.themaw.net> <20100716210226.GD21201@shell> <1279595537.2979.10.camel@localhost> <20100804215943.GA29353@shell> <E1OgxmE-0002x2-QW@pomaz-ex.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1OgxmE-0002x2-QW@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 05, 2010 at 12:34:18PM +0200, Miklos Szeredi wrote:
> On Wed, 4 Aug 2010, Valerie Aurora wrote:
> > I went for MS_WHITEOUT and MS_FALLTHRU, and added the checks for the
> > ops being non-null.
> 
> This bit me.  Mount failing with EINVAL is a big PITA.

Thanks, I merged this.

-VAL


> Miklos
> 
> 
> Index: linux-2.6/fs/namespace.c
> ===================================================================
> --- linux-2.6.orig/fs/namespace.c	2010-08-05 11:06:56.000000000 +0200
> +++ linux-2.6/fs/namespace.c	2010-08-05 11:39:19.000000000 +0200
> @@ -1387,6 +1387,7 @@ check_mnt_union(struct path *mntpnt, str
>  		return 0;
>  
>  #ifndef CONFIG_UNION_MOUNT
> +	printk(KERN_INFO "union mount: not supported by the kernel\n");
>  	return -EINVAL;
>  #endif
>  	for (p = lower_mnt; p; p = next_mnt(p, lower_mnt)) {
> @@ -1396,17 +1397,23 @@ check_mnt_union(struct path *mntpnt, str
>  			return -EBUSY;
>  	}
>  
> -	if (!IS_ROOT(mntpnt->dentry))
> +	if (!IS_ROOT(mntpnt->dentry)) {
> +		printk(KERN_INFO "union mount: not root\n");
>  		return -EINVAL;
> +	}
>  
>  	if (mnt_flags & MNT_READONLY)
>  		return -EROFS;
>  
> -	if (!(topmost_mnt->mnt_sb->s_flags & MS_WHITEOUT))
> +	if (!(topmost_mnt->mnt_sb->s_flags & MS_WHITEOUT)) {
> +		printk(KERN_INFO "union mount: whiteout not supported by fs\n");
>  		return -EINVAL;
> +	}
>  
> -	if (!(topmost_mnt->mnt_sb->s_flags & MS_FALLTHRU))
> +	if (!(topmost_mnt->mnt_sb->s_flags & MS_FALLTHRU)) {
> +		printk(KERN_INFO "union mount: fallthrough not supported by fs\n");
>  		return -EINVAL;
> +	}
>  
>  	/* XXX top level mount should only be mounted once */
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
