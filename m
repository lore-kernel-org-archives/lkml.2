Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757322Ab3AIHZ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 02:25:29 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:38407 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756051Ab3AIHZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 02:25:27 -0500
X-Greylist: delayed 507 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Jan 2013 02:25:26 EST
X-Sasl-enc: q6bNQBH3BKT7fNZe9hOYFQuXFuSfVUD3FSAGQ1FiDPOl 1357715818
Message-ID: <1357715816.11178.23.camel@perseus.themaw.net>
Subject: Re: [PATCH] fs/autofs: Fix sparse warning: context imbalance in
 'autofs4_d_automount' - different lock contexts for basic block
From: Ian Kent <raven@themaw.net>
To: Peter Huewe <peterhuewe@gmx.de>
Cc: autofs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Fengguang Wu <fengguang.wu@intel.com>
Date: Wed, 09 Jan 2013 15:16:56 +0800
In-Reply-To: <1357224733-31251-1-git-send-email-peterhuewe@gmx.de>
References: <1357224733-31251-1-git-send-email-peterhuewe@gmx.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I see this hasn't been merged yet.
Do I need to re-post this (perhaps to Linus)?

On Thu, 2013-01-03 at 15:52 +0100, Peter Huewe wrote:
> Sparse complains:
> + fs/autofs4/root.c:409:9: sparse: context imbalance in
> 'autofs4_d_automount' - different lock contexts for basic block
> 
> This was introduced by commit
> f55fb0c243 autofs4 - dont clear DCACHE_NEED_AUTOMOUNT on rootless mount
> 
> The function autofs4_d_automount can be left with the (&sbi->fs_lock)
> held if sbi->version <= 4 and simple_empty(dentry) == false so the warning seems valid.
> 
> --> Add an spin_unlock in this case before we jump to done
> 
> Unfortunately compile tested only.
> 
> Reported-by: Fengguang Wu <fengguang.wu@intel.com>
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
> ---
>  fs/autofs4/root.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
> index c934476..74a299f 100644
> --- a/fs/autofs4/root.c
> +++ b/fs/autofs4/root.c
> @@ -383,8 +383,10 @@ static struct vfsmount *autofs4_d_automount(struct path *path)
>  				goto done;
>  			}
>  		} else {
> -			if (!simple_empty(dentry))
> +			if (!simple_empty(dentry)) {
> +				spin_unlock(&sbi->fs_lock);
>  				goto done;
> +			}
>  		}
>  		ino->flags |= AUTOFS_INF_PENDING;
>  		spin_unlock(&sbi->fs_lock);


