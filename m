Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755678Ab0JJJrY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 05:47:24 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:42202 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754303Ab0JJJrV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 05:47:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=A3bBQeysd4owmd7lse0ZvzuKjSUc3dXmGEILSu6f2g9h2ZMOftrGAlGQMNtcKGEFjA
         r2QxBhJit+xjXt2ZHJWQ/QFF7tWHxNreCugqpMLRY6szBk8nQ/SM2pzsHZeixTuRlqa1
         sSrq4tek43kHRYFBynH51hvzKEmD5poy+8QA0=
MIME-Version: 1.0
In-Reply-To: <20101007174948.GT19804@ZenIV.linux.org.uk>
References: <20101007174948.GT19804@ZenIV.linux.org.uk>
Date: Sun, 10 Oct 2010 11:47:20 +0200
X-Google-Sender-Auth: JQZvgvrLvJJ-hl_OjUNlrc8sk8w
Message-ID: <AANLkTin4886D+-yo=zrf2Yj2R5NM9qdRkc3M9cG2rN_F@mail.gmail.com>
Subject: Re: aranym bug, manifests as "ida_remove called for id=13" on recent kernels
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 7, 2010 at 19:49, Al Viro <viro@zeniv.linux.org.uk> wrote:
>        I've spent quite a while hunting that crap down; reverting VFS fix
> mentioned in original thread *does* get rid of the symptoms, but so does the
> patch below.
>
>        What happens is this: if ->follow_link() (usually something like
> stat("/proc/2/fd", ...) done by pidof(8)) return ERR_PTR(-....), we return
> to __do_follow_link() and do the following:
>        *p = dentry->d_inode->i_op->follow_link(dentry, nd);
>        error = PTR_ERR(*p);
>        if (!IS_ERR(*p)) {
>                char *s = nd_get_link(nd);
>                error = 0;
>                if (s)
>                        error = __vfs_follow_link(nd, s);
>                else if (nd->last_type == LAST_BIND) {
>                        error = force_reval_path(&nd->path, nd);
>                        if (error)
>                                path_put(&nd->path);
>                }
>        }
>        return error;
>
> We _should_ return non-zero value; IS_ERR(ERR_PTR(-n)) is 1 and
> PTR_ERR(ERR_PTR(n)) is -n.  What happens instead is that this thing
> actually returns 0.  And no, it's not a miscompile.  Patch below
> removes the symptoms of the bug, but only if both parts are present.
> I.e. *not* doing "report = 1" in proc_pid_follow_link() gives us
> visible breakage, despite the fact that report is initialized as
> 1 and nothing except proc_pid_follow_link() ever tries to assign
> anything to it.  Seeing that fs/namei.c and fs/proc/base.c are
> compiled separately, we can exclude gcc problems.
>
> The cheapest way to reproduce is to boot with init=/bin/sh, then
> mount /proc and have stat("/proc/2/exe", &st) called; if stat()
> returns 0, we are fscked.  The critical part is between return
> from proc_exe_link() (we'll leave it via if (!mm) return -ENOENT;)
> to return from __do_follow_link() -> do_follow_link() -> link_path_walk().

I booted 2.6.36-rc7-atari-00360-g0dd2e6a (my current private test kernel) with
init=/bin/sh, mounted /proc, and tried

    for i in $(seq 1000); do stat /proc/2/exe; done

a few times, but I didn't see any ida_remove messages.
It cannot read the /proc/2/exe symlink, though.

This is on aranym-0.9.9-1 from Ubuntu/amd64.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
