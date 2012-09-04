Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932866Ab2IDWtj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 18:49:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54341 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757824Ab2IDWti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 18:49:38 -0400
Date: Tue, 4 Sep 2012 15:49:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: yan <clouds.yan@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] proc : no need to initialize proc_inode->fd in
 proc_get_inode
Message-Id: <20120904154937.e39a728e.akpm@linux-foundation.org>
In-Reply-To: <1346681648-21427-3-git-send-email-clouds.yan@gmail.com>
References: <1346681648-21427-1-git-send-email-clouds.yan@gmail.com>
	<1346681648-21427-3-git-send-email-clouds.yan@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  3 Sep 2012 22:14:06 +0800
yan <clouds.yan@gmail.com> wrote:

> It has been initialized in proc_alloc_inode.
>
> ...

I think what you mean here is that the preceding call to iget_locked()
will call alloc_inode() which will call proc_alloc_inode() which clears
pro_inode.fd.  

And if iget_locked() instead found the inode via find_inode_fast(),
that inode will not have I_NEW set so this change has no effect.

Yes?  Please do spell things out in this level of detail so that others
can check your logic.

> --- a/fs/proc/inode.c
> +++ b/fs/proc/inode.c
> @@ -450,7 +450,6 @@ struct inode *proc_get_inode(struct super_block *sb, struct proc_dir_entry *de)
>  		return NULL;
>  	if (inode->i_state & I_NEW) {
>  		inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME;
> -		PROC_I(inode)->fd = 0;
>  		PROC_I(inode)->pde = de;
>  
>  		if (de->mode) {

I provided this changelog:

: proc_get_inode() obtains the inode via a call to iget_locked(). 
: iget_locked() calls alloc_inode() which will call proc_alloc_inode() which
: clears proc_inode.fd, so there is no need to clear this field in
: proc_get_inode().
:
: If iget_locked() instead found the inode via find_inode_fast(), that inode
: will not have I_NEW set so this change has no effect.

