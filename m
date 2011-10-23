Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394Ab1JWLOm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 07:14:42 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:53034 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754586Ab1JWLOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 07:14:40 -0400
X-Sasl-enc: RaZry/r8bix7qqp3upagU6lT8/p1SNsyxhmi8r/mh78S 1319368479
Subject: Re: [PATCH] CIFS: fix automount for DFS shares
From: Ian Kent <raven@themaw.net>
To: Gerlando Falauto <gerlando.falauto@keymile.com>
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Jeffrey Layton <jlayton@redhat.com>
In-Reply-To: <1317985771-28876-2-git-send-email-gerlando.falauto@keymile.com>
References: <1317985771-28876-1-git-send-email-gerlando.falauto@keymile.com>
	 <1317985771-28876-2-git-send-email-gerlando.falauto@keymile.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 23 Oct 2011 19:14:34 +0800
Message-ID: <1319368474.7876.4.camel@perseus.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-10-07 at 13:09 +0200, Gerlando Falauto wrote:
> Automounting directories are now invalidated by .d_revalidate()
> so to be d_instantiate()d again with the right DCACHE_NEED_AUTOMOUNT
> flag

But why doesn't CIFS know this is a DFS inode the first time around, it
appears to do a truck load of work looking that stuff up?

> 
> Signed-off-by: Gerlando Falauto <gerlando.falauto@keymile.com>
> ---
>  fs/cifs/dir.c |    7 ++++++-
>  1 files changed, 6 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
> index 9ea65cf..67f54d3 100644
> --- a/fs/cifs/dir.c
> +++ b/fs/cifs/dir.c
> @@ -637,8 +637,13 @@ cifs_d_revalidate(struct dentry *direntry, struct nameidata *nd)
>  	if (direntry->d_inode) {
>  		if (cifs_revalidate_dentry(direntry))
>  			return 0;
> -		else
> +		else {
> +			/* We want automonting inodes to be
> +			 * considered invalid or so */
> +			if (IS_AUTOMOUNT(direntry->d_inode))
> +				return 0;

I'd be inclined to set DCACHE_NEED_AUTOMOUNT here but are we certain
that cifs_revalidate_dentry() will always return 0 for a DFS inode or at
least ones that don't yet have DCACHE_NEED_AUTOMOUNT set and why?

>  			return 1;
> +		}
>  	}
>  
>  	/*


