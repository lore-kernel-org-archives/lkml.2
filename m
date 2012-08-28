Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387Ab2H1Uie (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 16:38:34 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:55178 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052Ab2H1Uic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 16:38:32 -0400
Date: Tue, 28 Aug 2012 23:38:27 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Nathan Zimmer <nzimmer@sgi.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] fs/proc: Move kfree outside pde_unload_lock
Message-ID: <20120828203826.GA5868@p183.telecom.by>
References: <n>
 <1345653510-22000-1-git-send-email-nzimmer@sgi.com>
 <1345660110.5158.1969.camel@edumazet-glaptop>
 <1345671778.5158.2369.camel@edumazet-glaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345671778.5158.2369.camel@edumazet-glaptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2012 at 11:42:58PM +0200, Eric Dumazet wrote:
> On Wed, 2012-08-22 at 20:28 +0200, Eric Dumazet wrote:
> 
> > 
> > Thats interesting, but if you really want this to fly, one RCU
> > conversion would be much better ;)
> > 
> > pde_users would be an atomic_t and you would avoid the spinlock
> > contention.
> 
> Here is what I had in mind, I would be interested to know how it helps a 512 core machine ;)

Nothing can stop RCU!

After running "modprobe;rmmod" in a loop and "cat" in another loop for a while
rmmod got stuck in D-state inside remove_proc_entry() with trace amounts of CPU time
being consumed.

It didn't oopsed, though.

> --- a/include/linux/proc_fs.h
> +++ b/include/linux/proc_fs.h
> @@ -64,16 +64,13 @@ struct proc_dir_entry {
>  	 * If you're allocating ->proc_fops dynamically, save a pointer
>  	 * somewhere.
>  	 */
> -	const struct file_operations *proc_fops;
> +	const struct file_operations __rcu *proc_fops;
>  	struct proc_dir_entry *next, *parent, *subdir;
>  	void *data;
>  	read_proc_t *read_proc;
>  	write_proc_t *write_proc;
>  	atomic_t count;		/* use count */
> -	int pde_users;	/* number of callers into module in progress */
> -	struct completion *pde_unload_completion;
> -	struct list_head pde_openers;	/* who did ->open, but not ->release */
> -	spinlock_t pde_unload_lock; /* proc_fops checks and pde_users bumps */
> +	atomic_t pde_users;	/* number of callers into module in progress */
