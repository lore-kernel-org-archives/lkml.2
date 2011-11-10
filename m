Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757535Ab1KJIar (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 03:30:47 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:37691 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757458Ab1KJIap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 03:30:45 -0500
X-Sasl-enc: ppnmW3vKbFlOPBYA210VaEu4EDPcygNqRr/hwI0B7TV4 1320913843
Subject: Re: [132/262] vfs pathname lookup: Add LOOKUP_AUTOMOUNT flag
From: Ian Kent <raven@themaw.net>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Trond Myklebust <Trond.Myklebust@netapp.com>,
        Jeff Layton <jlayton@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>,
        David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Miklos Szeredi <mszeredi@suse.cz>
In-Reply-To: <20111109212713.879189869@clark.kroah.org>
References: <20111109212713.879189869@clark.kroah.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 Nov 2011 16:30:36 +0800
Message-ID: <1320913836.3206.68.camel@perseus.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-09 at 13:27 -0800, Greg KH wrote:
> 3.0-stable review patch.  If anyone has any objections, please let me know.

I was going to say we need commits
815d405ceff0d6964683f033e18b9b23a88fba87 and
b6c8069d3577481390b3f24a8434ad72a3235594 but I see those patches are
present in stable-queue repo along with
5c8a0fbba543d9428a486f0d1282bbcf3cf1d95a.

This last commit is, as Linux points out, open to question, although if
it was an autofs mount point that status is not really useful to the
user. OTOH for other fs (that use automounting) the status of the file
system containing the mount point might be useful but possibly
misleading. IMHO I'd include this commit as well.

> 
> ------------------
> 
> 
> From: Linus Torvalds <torvalds@linux-foundation.org>
> 
> Since we've now turned around and made LOOKUP_FOLLOW *not* force an
> automount, we want to add the ability to force an automount event on
> lookup even if we don't happen to have one of the other flags that force
> it implicitly (LOOKUP_OPEN, LOOKUP_DIRECTORY, LOOKUP_PARENT..)
> 
> Most cases will never want to use this, since you'd normally want to
> delay automounting as long as possible, which usually implies
> LOOKUP_OPEN (when we open a file or directory, we really cannot avoid
> the automount any more).
> 
> But Trond argued sufficiently forcefully that at a minimum bind mounting
> a file and quotactl will want to force the automount lookup.  Some other
> cases (like nfs_follow_remote_path()) could use it too, although
> LOOKUP_DIRECTORY would work there as well.
> 
> This commit just adds the flag and logic, no users yet, though.  It also
> doesn't actually touch the LOOKUP_NO_AUTOMOUNT flag that is related, and
> was made irrelevant by the same change that made us not follow on
> LOOKUP_FOLLOW.
> 
> Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
> Cc: Ian Kent <raven@themaw.net>
> Cc: Jeff Layton <jlayton@redhat.com>
> Cc: Miklos Szeredi <miklos@szeredi.hu>
> Cc: David Howells <dhowells@redhat.com>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> ---
>  fs/namei.c            |    2 +-
>  include/linux/namei.h |    1 +
>  2 files changed, 2 insertions(+), 1 deletion(-)
> 
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -793,7 +793,7 @@ static int follow_automount(struct path
>  	 * of the daemon to instantiate them before they can be used.
>  	 */
>  	if (!(flags & (LOOKUP_CONTINUE | LOOKUP_DIRECTORY |
> -		     LOOKUP_OPEN | LOOKUP_CREATE)) &&
> +		     LOOKUP_OPEN | LOOKUP_CREATE | LOOKUP_AUTOMOUNT)) &&
>  	    path->dentry->d_inode)
>  		return -EISDIR;
>  
> --- a/include/linux/namei.h
> +++ b/include/linux/namei.h
> @@ -49,6 +49,7 @@ enum {LAST_NORM, LAST_ROOT, LAST_DOT, LA
>  #define LOOKUP_FOLLOW		0x0001
>  #define LOOKUP_DIRECTORY	0x0002
>  #define LOOKUP_CONTINUE		0x0004
> +#define LOOKUP_AUTOMOUNT	0x0008
>  
>  #define LOOKUP_PARENT		0x0010
>  #define LOOKUP_REVAL		0x0020
> 
> 


