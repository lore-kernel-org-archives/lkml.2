Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632Ab2IYDj0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 23:39:26 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:34960 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208Ab2IYDjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 23:39:24 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: al viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
References: <50609C43.1070702@canonical.com>
Date: Mon, 24 Sep 2012 20:39:17 -0700
In-Reply-To: <50609C43.1070702@canonical.com> (Maarten Lankhorst's message of
	"Mon, 24 Sep 2012 19:45:39 +0200")
Message-ID: <87txumrct6.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18+y7Z4JuMz4dr054UXPJ2n69Ac+fz1XAI=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0024]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Maarten Lankhorst <maarten.lankhorst@canonical.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] Revert "__d_unalias() should refuse to move mountpoints"
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maarten Lankhorst <maarten.lankhorst@canonical.com> writes:

> This reverts commit ee3efa91e240f513898050ef305a49a653c8ed90.
>
> Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
>
> My thread about the regression seemed to have been ignored, so I can only
> conclude nobody objects against a full revert of this patch.
>
> My testcase is simply booting through netboot with / and ~/nfs as separate
> nfs filesystems, then doing 'ls ~/nfs' followed by 'ls ~' in a gnome-terminal
> window, then I get:

Do I read your description correctly:  Without using a bind mount you
have the same nfs filesystem mounted on / and on ~/nfs?

Something is definitely off with your configuration but if to work you
need to move mount points around then that something seems much deeper
than the __d_unalias change.

What filesystems do you have mounted where?

> ls: cannot access nfs: Device or resource busy
>
> Similar things seem to happen with ls /, /dev /proc and /sys will no longer work.
>
> Reverting this patch seems to make things work again.
>
> ---
>
> diff --git a/fs/dcache.c b/fs/dcache.c
> index 16521a9..711f421 100644
> --- a/fs/dcache.c
> +++ b/fs/dcache.c
> @@ -2387,13 +2387,14 @@ static struct dentry *__d_unalias(struct inode *inode,
>  		struct dentry *dentry, struct dentry *alias)
>  {
>  	struct mutex *m1 = NULL, *m2 = NULL;
> -	struct dentry *ret = ERR_PTR(-EBUSY);
> +	struct dentry *ret;
>  
>  	/* If alias and dentry share a parent, then no extra locks required */
>  	if (alias->d_parent == dentry->d_parent)
>  		goto out_unalias;
>  
>  	/* See lock_rename() */
> +	ret = ERR_PTR(-EBUSY);
>  	if (!mutex_trylock(&dentry->d_sb->s_vfs_rename_mutex))
>  		goto out_err;
>  	m1 = &dentry->d_sb->s_vfs_rename_mutex;
> @@ -2401,10 +2402,8 @@ static struct dentry *__d_unalias(struct inode *inode,
>  		goto out_err;
>  	m2 = &alias->d_parent->d_inode->i_mutex;
>  out_unalias:
> -	if (likely(!d_mountpoint(alias))) {
> -		__d_move(alias, dentry);
> -		ret = alias;
> -	}
> +	__d_move(alias, dentry);
> +	ret = alias;
>  out_err:
>  	spin_unlock(&inode->i_lock);
>  	if (m2)
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
