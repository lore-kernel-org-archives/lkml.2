Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299Ab2G2P4w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 11:56:52 -0400
Received: from fieldses.org ([174.143.236.118]:39020 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753266Ab2G2P4t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 11:56:49 -0400
Date: Sun, 29 Jul 2012 11:56:42 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Filipe Brandenburger <filbranden@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Matthew Wilcox <matthew@wil.cx>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3] locks: prevent side-effects of locks_release_private
 before file_lock is initialized
Message-ID: <20120729155642.GJ6388@fieldses.org>
References: <20120707190451.GA17049@fieldses.org>
 <1343364172-1763-1-git-send-email-filbranden@gmail.com>
 <20120727204552.GA6388@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120727204552.GA6388@fieldses.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2012 at 04:45:52PM -0400, J. Bruce Fields wrote:
> On Fri, Jul 27, 2012 at 12:42:52AM -0400, Filipe Brandenburger wrote:
> > When calling fcntl(fd, F_SETLEASE, lck) [with lck=F_WRLCK or F_RDLCK],
> > the custom signal or owner (if any were previously set using F_SETSIG
> > or F_SETOWN fcntls) would be reset when F_SETLEASE was called for the
> > second time on the same file descriptor.
> > 
> > This bug is a regression of 2.6.37 and is described here:
> > https://bugzilla.kernel.org/show_bug.cgi?id=43336
> > 
> > This patch reverts a commit from Oct 2004 (with subject "nfs4 lease:
> > move the f_delown processing") which originally introduced the
> > lm_release_private callback.
> 
> Looks fine, thanks.  I think can also do something like the following
> (on top of your patch).

(Committing this as well.)--b.

> 
> --b.
> 
> commit 96d6d59ceaeaacba4088862f3c57fcd011f52832
> Author: J. Bruce Fields <bfields@redhat.com>
> Date:   Fri Jul 27 16:18:00 2012 -0400
> 
>     locks: move lease-specific code out of locks_delete_lock
>     
>     No point putting something only used by one caller into common code.
>     
>     Signed-off-by: J. Bruce Fields <bfields@redhat.com>
> 
> diff --git a/fs/locks.c b/fs/locks.c
> index 86668dd..541075a 100644
> --- a/fs/locks.c
> +++ b/fs/locks.c
> @@ -570,12 +570,6 @@ static void locks_delete_lock(struct file_lock **thisfl_p)
>  	fl->fl_next = NULL;
>  	list_del_init(&fl->fl_link);
>  
> -	fasync_helper(0, fl->fl_file, 0, &fl->fl_fasync);
> -	if (fl->fl_fasync != NULL) {
> -		printk(KERN_ERR "locks_delete_lock: fasync == %p\n", fl->fl_fasync);
> -		fl->fl_fasync = NULL;
> -	}
> -
>  	if (fl->fl_nspid) {
>  		put_pid(fl->fl_nspid);
>  		fl->fl_nspid = NULL;
> @@ -1150,6 +1144,11 @@ int lease_modify(struct file_lock **before, int arg)
>  
>  		f_delown(filp);
>  		filp->f_owner.signum = 0;
> +		fasync_helper(0, fl->fl_file, 0, &fl->fl_fasync);
> +		if (fl->fl_fasync != NULL) {
> +			printk(KERN_ERR "locks_delete_lock: fasync == %p\n", fl->fl_fasync);
> +			fl->fl_fasync = NULL;
> +		}
>  		locks_delete_lock(before);
>  	}
>  	return 0;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
