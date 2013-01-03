Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269Ab3ACXyI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 18:54:08 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:56175 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753987Ab3ACXyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 18:54:06 -0500
X-Sasl-enc: qKbp/kz4qJneIZmBM+qEfa4la8QLYQoT4CN8jpm9epBX 1357257244
Message-ID: <1357257241.2207.2.camel@perseus.themaw.net>
Subject: Re: [PATCH] fs/autofs: Fix sparse warning: context imbalance in
 'autofs4_d_automount' - different lock contexts for basic block
From: Ian Kent <raven@themaw.net>
To: Peter Huewe <peterhuewe@gmx.de>
Cc: autofs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Fengguang Wu <fengguang.wu@intel.com>
Date: Fri, 04 Jan 2013 07:54:01 +0800
In-Reply-To: <1357224733-31251-1-git-send-email-peterhuewe@gmx.de>
References: <1357224733-31251-1-git-send-email-peterhuewe@gmx.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Yes, good catch, it looks right to me.
Acked-by: Ian Kent <raven@themaw.net>

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


