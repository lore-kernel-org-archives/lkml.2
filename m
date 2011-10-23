Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443Ab1JWLl1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 07:41:27 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:55190 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755424Ab1JWLl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 07:41:26 -0400
X-Sasl-enc: GEYocZBlJEt0wnf8Ux3VWbY2rRLxz17caVaGgwauKDd9 1319370084
Subject: Re: [22/27] VFS: Fix automount for negative autofs dentries
From: Ian Kent <raven@themaw.net>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        stable-review@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Chuck Ebbert <cebbert@redhat.com>
In-Reply-To: <20111023062540.684446582@pistachio.kroah.org>
References: <20111023062540.684446582@pistachio.kroah.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 23 Oct 2011 19:41:18 +0800
Message-ID: <1319370078.7876.8.camel@perseus.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-10-23 at 08:24 +0200, Greg KH wrote:
> 3.0-stable review patch.  If anyone has any objections, please let us know.

Yes, as others point out, either the patch needs to be correctly
backported or the dependent patches need to be pulled in.

I can do either of these, what would you prefer?

> 
> ------------------
> 
> From: David Howells <dhowells@redhat.com>
> 
> commit 5a30d8a2b8ddd5102c440c7e5a7c8e1fd729c818 upstream.
> [ backport for 3.0.x: LOOKUP_PARENT => LOOKUP_CONTINUE by Chuck Ebbert
> <cebbert@redhat.com> ]
> 
> Autofs may set the DCACHE_NEED_AUTOMOUNT flag on negative dentries.  These
> need attention from the automounter daemon regardless of the LOOKUP_FOLLOW flag.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> Acked-by: Ian Kent <raven@themaw.net>
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Chuck Ebbert <cebbert@redhat.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> ---
>  fs/namei.c |   24 +++++++++++++++---------
>  1 file changed, 15 insertions(+), 9 deletions(-)
> 
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -779,19 +779,25 @@ static int follow_automount(struct path
>  	if ((flags & LOOKUP_NO_AUTOMOUNT) && !(flags & LOOKUP_CONTINUE))
>  		return -EISDIR; /* we actually want to stop here */
>  
> -	/* We want to mount if someone is trying to open/create a file of any
> -	 * type under the mountpoint, wants to traverse through the mountpoint
> -	 * or wants to open the mounted directory.
> -	 *
> +	/*
>  	 * We don't want to mount if someone's just doing a stat and they've
>  	 * set AT_SYMLINK_NOFOLLOW - unless they're stat'ing a directory and
>  	 * appended a '/' to the name.
>  	 */
> -	if (!(flags & LOOKUP_FOLLOW) &&
> -	    !(flags & (LOOKUP_CONTINUE | LOOKUP_DIRECTORY |
> -		       LOOKUP_OPEN | LOOKUP_CREATE)))
> -		return -EISDIR;
> -
> +	if (!(flags & LOOKUP_FOLLOW)) {
> +		/* We do, however, want to mount if someone wants to open or
> +		 * create a file of any type under the mountpoint, wants to
> +		 * traverse through the mountpoint or wants to open the mounted
> +		 * directory.
> +		 * Also, autofs may mark negative dentries as being automount
> +		 * points.  These will need the attentions of the daemon to
> +		 * instantiate them before they can be used.
> +		 */
> +		if (!(flags & (LOOKUP_PARENT | LOOKUP_DIRECTORY |
> +			     LOOKUP_OPEN | LOOKUP_CREATE)) &&
> +		    path->dentry->d_inode)
> +			return -EISDIR;
> +	}
>  	current->total_link_count++;
>  	if (current->total_link_count >= 40)
>  		return -ELOOP;
> 
> 


