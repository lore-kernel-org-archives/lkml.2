Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752663Ab1IFDxq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 23:53:46 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:45865 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751448Ab1IFDxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 23:53:37 -0400
X-Sasl-enc: GwMnOgjzco9oH8aoTozD9oNNQ3msz2kAfK7IaSUiBM1s 1315281214
Subject: Re: [PATCH] vfs: automount should ignore LOOKUP_FOLLOW
From: Ian Kent <raven@themaw.net>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: David Howells <dhowells@redhat.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Leonardo Chiquitto <leonardo.lists@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        autofs@linux.kernel.org
In-Reply-To: <87hb4q9b3r.fsf@tucsk.pomaz.szeredi.hu>
References: <87liu37z3x.fsf@tucsk.pomaz.szeredi.hu>
	 <17416.1315240659@redhat.com>  <87hb4q9b3r.fsf@tucsk.pomaz.szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 06 Sep 2011 11:53:28 +0800
Message-ID: <1315281208.3210.26.camel@perseus.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-09-05 at 19:02 +0200, Miklos Szeredi wrote:
> David Howells <dhowells@redhat.com> writes:
> 
> > Miklos Szeredi <miklos@szeredi.hu> wrote:
> >
> >> After 2.6.38, with the introduction of the ->d_automount()
> >> infrastructure, stat(2) and others would start triggering automount
> >> while lstat(2), etc. still would not.  This is a regression and a
> >> userspace ABI change.
> >
> > It doesn't necessarily mean it's wrong.  The main class of program that needs
> > to be prevented from automounting are things that do bulk stat'ing (e.g. ls) -
> > and they should probably be doing lstat() anyway.
> 
> Yeah, some of those uses are probably minor bugs in userspace, but there are
> probably many of them (Leonardo reported that for example Nautilus also
> triggers all child automounts in a directory).  So I don't think it's OK to
> just change the behavior here.

Yes, Leonard has been a big help with his recent efforts, thanks
Leonard.

> 
> If automounting on lstat(2) is the correct behavior (is it?  why?)  then at
> least it should be enabled by a global switch or mount option, IMO.

Ideally we wouldn't need to take special precautions for these
operations at all but we can't, especially for GUI environments that
constantly scan file systems on mount/umount activity.

Historically for autofs, neither stat(2) or lstat(2) would trigger a
mount. With the current implementation stat(2) now does but lstat(2)
doesn't which is a step in the right direction IMHO. So, I recommend we
continue to encourage user space to make the needed changes so we
continue to move in the right direction, and yes, I acknowledge it is a
pain but it'll never get done otherwise.

And, yes, other subsystems that need to automount also have the same
problems as autofs now so we do need to take precautions, but that was
already the case before the current implementation.

Hopefully, in time, user space will adopt the use of fcntl(2) and
AT_NO_AUTOMOUNT and we will be able to fix this once and for all, as
this was David's intent in introducing it. Not quite sure how we will go
about promoting that adoption or how much pain that will mean for user
space though.

> 
> >
> >> +	/* We don't want to mount if someone's just doing a stat -
> >> +	 * unless they're stat'ing a directory and appended a '/' to
> >> +	 * the name.
> >
> > Btw, line length is 80 chars.  This comment could easily use one fewer line.
> >
> > If you use emacs you can do:
> >
> > 	ESC 7 9 C-x f
> >
> > to set the right margin and then:
> >
> > 	M-q
> >
> > whilst the cursor is in the comment paragraph to be rearranged and it will
> > 'fill' the paragraph to 79 characters.
> 
> Cool.  Updated patch below.
> 
> Thanks,
> Miklos
> ----
> 
> 
> Subject: vfs: automount should ignore LOOKUP_FOLLOW
> 
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Prior to 2.6.38 automount would not trigger on either stat(2) or
> lstat(2) on the automount point.
> 
> After 2.6.38, with the introduction of the ->d_automount()
> infrastructure, stat(2) and others would start triggering automount
> while lstat(2), etc. still would not.  This is a regression and a
> userspace ABI change.
> 
> Problem originally reported here:
> 
>   http://thread.gmane.org/gmane.linux.kernel.autofs/6098
> 
> It appears that there was an attempt at fixing various userspace tools
> to not trigger the automount.  But since the stat system call is
> rather common it is impossible to "fix" all userspace.
> 
> This patch reverts the original behavior, which is to not trigger on
> stat(2) and other symlink following syscalls.
> 
> Reported-by: Leonardo Chiquitto <leonardo.lists@gmail.com>
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> CC: David Howells <dhowells@redhat.com>
> CC: Ian Kent <raven@themaw.net>
> CC: stable@kernel.org
> ---
>  fs/namei.c |   32 ++++++++++++++------------------
>  1 file changed, 14 insertions(+), 18 deletions(-)
> 
> Index: linux-2.6/fs/namei.c
> ===================================================================
> --- linux-2.6.orig/fs/namei.c	2011-09-05 18:01:59.000000000 +0200
> +++ linux-2.6/fs/namei.c	2011-09-05 18:51:25.000000000 +0200
> @@ -727,25 +727,21 @@ static int follow_automount(struct path
>  	if ((flags & LOOKUP_NO_AUTOMOUNT) && !(flags & LOOKUP_PARENT))
>  		return -EISDIR; /* we actually want to stop here */
>  
> -	/*
> -	 * We don't want to mount if someone's just doing a stat and they've
> -	 * set AT_SYMLINK_NOFOLLOW - unless they're stat'ing a directory and
> -	 * appended a '/' to the name.
> +	/* We don't want to mount if someone's just doing a stat - unless
> +	 * they're stat'ing a directory and appended a '/' to the name.
> +	 *
> +	 * We do, however, want to mount if someone wants to open or create a
> +	 * file of any type under the mountpoint, wants to traverse through the
> +	 * mountpoint or wants to open the mounted directory.  Also, autofs may
> +	 * mark negative dentries as being automount points.  These will need
> +	 * the attentions of the daemon to instantiate them before they can be
> +	 * used.
>  	 */
> -	if (!(flags & LOOKUP_FOLLOW)) {
> -		/* We do, however, want to mount if someone wants to open or
> -		 * create a file of any type under the mountpoint, wants to
> -		 * traverse through the mountpoint or wants to open the mounted
> -		 * directory.
> -		 * Also, autofs may mark negative dentries as being automount
> -		 * points.  These will need the attentions of the daemon to
> -		 * instantiate them before they can be used.
> -		 */
> -		if (!(flags & (LOOKUP_PARENT | LOOKUP_DIRECTORY |
> -			     LOOKUP_OPEN | LOOKUP_CREATE)) &&
> -		    path->dentry->d_inode)
> -			return -EISDIR;
> -	}
> +	if (!(flags & (LOOKUP_PARENT | LOOKUP_DIRECTORY |
> +		     LOOKUP_OPEN | LOOKUP_CREATE)) &&
> +	    path->dentry->d_inode)
> +		return -EISDIR;
> +
>  	current->total_link_count++;
>  	if (current->total_link_count >= 40)
>  		return -ELOOP;


