Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758730Ab2HUWEB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 18:04:01 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:45021 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758697Ab2HUWD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 18:03:57 -0400
Date: Wed, 22 Aug 2012 01:03:52 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Nathan Zimmer <nzimmer@sgi.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [RFC] Move kfree outside pde_unload_lock
Message-ID: <20120821220351.GA4463@p183.telecom.by>
References: <20120821205454.GA7772@gulag1.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120821205454.GA7772@gulag1.americas.sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2012 at 03:54:54PM -0500, Nathan Zimmer wrote:
> I am currently tracking a hotlock reported by a customer on a large, 512 cores,
> system, I am currently running 3.6.0 rc1 but the issue looks like it has been
> this way for a very long time.
> The offending lock is proc_dir_entry->pde_unload_lock.  
> 
> In proc_reg_release we are doing a kfree under the spinlock which is ok but it
> means we are holding the lock longer then required. Scaling improved when I 
> moved kfree out.

It's OK to move it out.
Acked-by: Alexey Dobriyan <adobriyan@gmail.com>

> Also shouldn't the comment on pde_unload_lock also note that pde_openers and 
> pde_unload_completion are both used under the lock?

Yeah, why not.

> --- a/fs/proc/inode.c
> +++ b/fs/proc/inode.c
> @@ -403,9 +403,11 @@ static int proc_reg_release(struct inode *inode, struct file *file)
>  	release = pde->proc_fops->release;
>  	if (pdeo) {
>  		list_del(&pdeo->lh);
> -		kfree(pdeo);
>  	}
>  	spin_unlock(&pde->pde_unload_lock);
> +	if (pdeo) {
> +		kfree(pdeo);
> +	}
>  
>  	if (release)
>  		rv = release(inode, file);
