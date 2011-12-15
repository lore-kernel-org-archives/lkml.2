Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758572Ab1LOCPh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 21:15:37 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33816 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755804Ab1LOCPf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 21:15:35 -0500
MIME-Version: 1.0
In-Reply-To: <87ipljcjc2.fsf@tucsk.pomaz.szeredi.hu>
References: <87obwof06x.fsf@tucsk.pomaz.szeredi.hu> <87ipljcjc2.fsf@tucsk.pomaz.szeredi.hu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 14 Dec 2011 18:15:11 -0800
X-Google-Sender-Auth: fECD7HXOXqj_HC8IN0tspHWIhMA
Message-ID: <CA+55aFxuGPj5rhFYt3O1yci_CqHe+Xs8U7WrWOih2W9U73N69w@mail.gmail.com>
Subject: Re: [PATCH resend] audit: fix mark refcounting
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Eric Paris <eparis@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks reasonable, but why doesn't all callers have that "put_mark()" thing?

And if/when all callers *do* have that put_mark() thing, maybe we
should make destroy_mark() just do it?

In particular, a quick grep shows that there are destroy_mark users still in:

 - fs/notify/fanotify/fanotify_user.c

 - fs/notify/dnotify/dnotify.c (2 of them)

 - fs/notify/inotify/inotify_fsnotify.c


that don't do "put_mark()" after the destroy. Why is it ok there?

I don't know the code, it's probably fine, but I'd like to know why
the audit code needs it but not the other sites (but my grep didn't
look at context)

And I'd like Al to say something. Al?

                      Linus

On Wed, Dec 14, 2011 at 6:35 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> I think this should go into 3.2 (and stable).
>
> Please apply.
>
> Thanks,
> Miklos
> ----
>
> From: Miklos Szeredi <mszeredi@suse.cz>
> Subject: audit: fix mark refcounting
>
> Removing the parent of a watched file results in "kernel BUG at
> fs/notify/mark.c:139".
>
> To reproduce
>
>  add "-w /tmp/audit/dir/watched_file" to audit.rules
>  rm -rf /tmp/audit/dir
>
> This is caused by fsnotify_destroy_mark() being called without an
> extra reference taken by the caller.
>
> Reported by Francesco Cosoleto here:
>
>  https://bugzilla.novell.com/show_bug.cgi?id=689860
>
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> CC: Al Viro <viro@zeniv.linux.org.uk>
> CC: Eric Paris <eparis@redhat.com>
> CC: stable@vger.kernel.org
> ---
>  kernel/audit_watch.c |    2 ++
>  1 file changed, 2 insertions(+)
>
> Index: linux.git/kernel/audit_watch.c
> ===================================================================
> --- linux.git.orig/kernel/audit_watch.c 2011-12-06 16:39:48.000000000 +0100
> +++ linux.git/kernel/audit_watch.c      2011-12-13 14:05:37.000000000 +0100
> @@ -349,7 +349,9 @@ static void audit_remove_parent_watches(
>        }
>        mutex_unlock(&audit_filter_mutex);
>
> +       audit_get_parent(parent);
>        fsnotify_destroy_mark(&parent->mark);
> +       audit_put_parent(parent);
>  }
>
>  /* Get path information necessary for adding watches. */
