Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755902Ab1KOOMX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 09:12:23 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:36681 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754512Ab1KOOMW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 09:12:22 -0500
MIME-Version: 1.0
X-Originating-IP: [178.164.248.109]
In-Reply-To: <87obwof06x.fsf@tucsk.pomaz.szeredi.hu>
References: <87obwof06x.fsf@tucsk.pomaz.szeredi.hu>
Date: Tue, 15 Nov 2011 15:12:16 +0100
Message-ID: <CAJfpeguYfkaRB=E8Ui6Ew2dz0z_F52nYC4Oaxk+ttEHcLiKvjg@mail.gmail.com>
Subject: Re: [PATCH] audit: fix mark refcounting
From: Miklos Szeredi <miklos@szeredi.hu>
To: Eric Paris <eparis@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping?

On Mon, Nov 7, 2011 at 3:59 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
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
> --- linux.git.orig/kernel/audit_watch.c 2011-09-13 16:08:20.000000000 +0200
> +++ linux.git/kernel/audit_watch.c      2011-11-07 15:19:07.000000000 +0100
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
>
