Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090Ab1EHO03 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 10:26:29 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:43030 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751206Ab1EHO00 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 10:26:26 -0400
Date: Sun, 8 May 2011 07:26:23 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Matthew Wilcox <matthew@wil.cx>,
        linux-fsdevel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Changli Gao <xiaosuo@gmail.com>
Subject: Re: [PATCH] fs: avoid unecessary smp_wmb() in dup_fd()
Message-ID: <20110508142623.GO2641@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1304749801.2821.716.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304749801.2821.716.camel@edumazet-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 07, 2011 at 08:30:01AM +0200, Eric Dumazet wrote:
> While copying old_fds array to new_fds, we dont need
> rcu_assign_pointer() and its smp_wmb(), since we are the only thread
> populating new_fds at this point.
> 
> A bit later, rcu_assign_pointer(newf->fdt, new_fdt) makes sure
> our writes are committed to memory before new_fds content is visible to
> other threads.
> 
> This removes following sparse warning :
> 
> fs/file.c:371:3: warning: incorrect type in assignment (different
> address spaces)
> fs/file.c:371:3:    expected struct file *<noident>
> fs/file.c:371:3:    got struct file [noderef] <asn:4>*<noident>

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> Cc: Matthew Wilcox <matthew@wil.cx>
> Cc: linux-fsdevel@vger.kernel.org
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Changli Gao <xiaosuo@gmail.com>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
>  fs/file.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/file.c b/fs/file.c
> index 4c6992d..8320a8e 100644
> --- a/fs/file.c
> +++ b/fs/file.c
> @@ -368,7 +368,7 @@ struct files_struct *dup_fd(struct files_struct *oldf, int *errorp)
>  			 */
>  			FD_CLR(open_files - i, new_fdt->open_fds);
>  		}
> -		rcu_assign_pointer(*new_fds++, f);
> +		*new_fds++ = f;
>  	}
>  	spin_unlock(&oldf->file_lock);
> 
> 
> 
