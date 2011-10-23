Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885Ab1JWHfi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 03:35:38 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61611 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753412Ab1JWHfh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 03:35:37 -0400
MIME-Version: 1.0
In-Reply-To: <20111023062540.684446582@pistachio.kroah.org>
References: <20111023062833.GA8126@kroah.com> <20111023062540.684446582@pistachio.kroah.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 23 Oct 2011 10:35:14 +0300
X-Google-Sender-Auth: 6MfLyG4Kx5on9UVjtaEkfmKiE7I
Message-ID: <CA+55aFxkHr75LZU0udv=A+Bg52fMMOEfp47TTxHGbgf51UouRg@mail.gmail.com>
Subject: Re: [22/27] VFS: Fix automount for negative autofs dentries
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        stable-review@vger.kernel.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, David Howells <dhowells@redhat.com>,
        Ian Kent <raven@themaw.net>, Al Viro <viro@zeniv.linux.org.uk>,
        Chuck Ebbert <cebbert@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This one is debatable.

I think it also wants

 - commit 0ec26fd0698285b31248e34bf1abb022c00f23d6 (with
LOOKUP_PARENT->LOOKUP_CONTINUE too)

 - commit d94c177beeb4469cd4f6e83354ab0223353e98ed (to get the few
other cases right too)

anything else I missed?

             Linus

On Sun, Oct 23, 2011 at 9:24 AM, Greg KH <gregkh@suse.de> wrote:
> 3.0-stable review patch.  If anyone has any objections, please let us know.
>
> ------------------
>
> From: David Howells <dhowells@redhat.com>
>
> commit 5a30d8a2b8ddd5102c440c7e5a7c8e1fd729c818 upstream.
> [ backport for 3.0.x: LOOKUP_PARENT => LOOKUP_CONTINUE by Chuck Ebbert
> <cebbert@redhat.com> ]
>
> Autofs may set the DCACHE_NEED_AUTOMOUNT flag on negative dentries.  These
> need attention from the automounter daemon regardless of the LOOKUP_FOLLOW flag.
>
> Signed-off-by: David Howells <dhowells@redhat.com>
> Acked-by: Ian Kent <raven@themaw.net>
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Chuck Ebbert <cebbert@redhat.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
>
> ---
>  fs/namei.c |   24 +++++++++++++++---------
>  1 file changed, 15 insertions(+), 9 deletions(-)
>
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -779,19 +779,25 @@ static int follow_automount(struct path
>        if ((flags & LOOKUP_NO_AUTOMOUNT) && !(flags & LOOKUP_CONTINUE))
>                return -EISDIR; /* we actually want to stop here */
>
> -       /* We want to mount if someone is trying to open/create a file of any
> -        * type under the mountpoint, wants to traverse through the mountpoint
> -        * or wants to open the mounted directory.
> -        *
> +       /*
>         * We don't want to mount if someone's just doing a stat and they've
>         * set AT_SYMLINK_NOFOLLOW - unless they're stat'ing a directory and
>         * appended a '/' to the name.
>         */
> -       if (!(flags & LOOKUP_FOLLOW) &&
> -           !(flags & (LOOKUP_CONTINUE | LOOKUP_DIRECTORY |
> -                      LOOKUP_OPEN | LOOKUP_CREATE)))
> -               return -EISDIR;
> -
> +       if (!(flags & LOOKUP_FOLLOW)) {
> +               /* We do, however, want to mount if someone wants to open or
> +                * create a file of any type under the mountpoint, wants to
> +                * traverse through the mountpoint or wants to open the mounted
> +                * directory.
> +                * Also, autofs may mark negative dentries as being automount
> +                * points.  These will need the attentions of the daemon to
> +                * instantiate them before they can be used.
> +                */
> +               if (!(flags & (LOOKUP_PARENT | LOOKUP_DIRECTORY |
> +                            LOOKUP_OPEN | LOOKUP_CREATE)) &&
> +                   path->dentry->d_inode)
> +                       return -EISDIR;
> +       }
>        current->total_link_count++;
>        if (current->total_link_count >= 40)
>                return -ELOOP;
>
>
>
