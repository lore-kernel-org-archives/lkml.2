Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226Ab0FOISe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 04:18:34 -0400
Received: from cantor.suse.de ([195.135.220.2]:35375 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753263Ab0FOISd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 04:18:33 -0400
Date: Tue, 15 Jun 2010 18:18:28 +1000
From: Nick Piggin <npiggin@suse.de>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Johansen <john.johansen@canonical.com>,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] vfs: show unreachable paths in getcwd and proc
Message-ID: <20100615081828.GG6138@laptop>
References: <E1OKVRc-0002Zk-Sc@pomaz-ex.szeredi.hu>
 <E1OKVT4-0002bA-KD@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1OKVT4-0002bA-KD@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 04, 2010 at 01:53:42PM +0200, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Prepend "(unreachable)" to path strings if the path is not reachable
> from the current root.
> 
> Two places updated are
>  - the return string from getcwd()
>  - and symlinks under /proc/$PID.
> 
> Other uses of d_path() are left unchanged (we know that some old
> software crashes if /proc/mounts is changed).
> 
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> ---
>  fs/dcache.c            |   82 +++++++++++++++++++++++++++++++++++++++++--------
>  fs/proc/base.c         |    2 -
>  include/linux/dcache.h |    1 
>  3 files changed, 72 insertions(+), 13 deletions(-)
> 
> Index: linux-2.6/fs/dcache.c
> ===================================================================
> --- linux-2.6.orig/fs/dcache.c	2010-05-27 12:22:21.000000000 +0200
> +++ linux-2.6/fs/dcache.c	2010-05-27 12:22:24.000000000 +0200
> @@ -1957,6 +1957,33 @@ int __d_path(const struct path *path, st
>  	return error;
>  }
>  
> +static void current_root(struct path *root)
> +{
> +	read_lock(&current->fs->lock);
> +	*root = current->fs->root;
> +	path_get(root);
> +	read_unlock(&current->fs->lock);
> +}

Does this really need a helper? If yes, then please put matching
get_fs_{root,pwd,both} helpers into fs_struct.c and use them throughout
the tree.

