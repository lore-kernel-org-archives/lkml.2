Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964932Ab2HVS2l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 14:28:41 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34684 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933208Ab2HVS2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 14:28:37 -0400
Subject: Re: [PATCH] fs/proc: Move kfree outside pde_unload_lock
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Nathan Zimmer <nzimmer@sgi.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        adobriyan@gmail.com, Alexander Viro <viro@zeniv.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <1345653510-22000-1-git-send-email-nzimmer@sgi.com>
References: <n>  <1345653510-22000-1-git-send-email-nzimmer@sgi.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Aug 2012 20:28:30 +0200
Message-ID: <1345660110.5158.1969.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-08-22 at 11:38 -0500, Nathan Zimmer wrote:
> This moves a kfree outside a spinlock to help scaling on larger (512 core)
> systems.
> 
> I ran a simple test which just reads from /proc/cpuinfo.
> Lower is better, as you can see the worst case scenario is improved.
> 
> 	baseline	moved kfree
> tasks	read-sec	read-sec
> 1	0.0141		0.0141
> 2	0.0140		0.0140
> 4	0.0140		0.0141
> 8	0.0145		0.0145
> 16	0.0553		0.0548
> 32	0.1688		0.1622
> 64	0.5017		0.3856
> 128	1.7005		0.9710
> 256	5.2513		2.6519
> 512	8.0529		6.2976
> 
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: David Woodhouse <dwmw2@infradead.org>
> Acked-by: Alexey Dobriyan <adobriyan@gmail.com>
> Signed-off-by: Nathan Zimmer <nzimmer@sgi.com>
> ---
>  fs/proc/inode.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/proc/inode.c b/fs/proc/inode.c
> index 7ac817b..bf36266 100644
> --- a/fs/proc/inode.c
> +++ b/fs/proc/inode.c
> @@ -403,9 +403,9 @@ static int proc_reg_release(struct inode *inode, struct file *file)
>  	release = pde->proc_fops->release;
>  	if (pdeo) {
>  		list_del(&pdeo->lh);
> -		kfree(pdeo);
>  	}
>  	spin_unlock(&pde->pde_unload_lock);
> +	kfree(pdeo);
>  
>  	if (release)
>  		rv = release(inode, file);

Thats interesting, but if you really want this to fly, one RCU
conversion would be much better ;)

pde_users would be an atomic_t and you would avoid the spinlock
contention.



