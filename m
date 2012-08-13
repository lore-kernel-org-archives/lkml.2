Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751938Ab2HMSLK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 14:11:10 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:34900 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227Ab2HMSLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 14:11:08 -0400
MIME-Version: 1.0
In-Reply-To: <1344632282.9131.5.camel@lenny>
References: <1344632282.9131.5.camel@lenny>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 13 Aug 2012 11:10:46 -0700
Message-ID: <CALCETrVOcNxfiAm0QDUjqhn=yx5LTPEKBJw8To-AcOTM3d1UcQ@mail.gmail.com>
Subject: Re: linux-user-chroot 2012.2
To: Colin Walters <walters@verbum.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 10, 2012 at 1:58 PM, Colin Walters <walters@verbum.org> wrote:
> Hi,
>
> This is the release of linux-user-chroot 2012.2.  The major change now
> is that it makes use of Andy's new PR_SET_NO_NEW_PRIVS.  This doesn't
> close any security hole I'm aware of - our previous use of the MS_NOSUID
> bind mount over / should work - but, belt and suspenders as they say.
>
> The code:
> http://git.gnome.org/browse/linux-user-chroot/commit/?id=515c714471d0b5923f6633ef44a2270b23656ee9
>
> As for how linux-user-chroot and PR_SET_NO_NEW_PRIVS relate, see this
> thread:
> http://thread.gmane.org/gmane.linux.kernel.lsm/15339
>
> Summary
> -------
>
> This tool allows regular (non-root) users to call chroot(2), create
> Linux bind mounts, and use some Linux container features.  It's
> primarily intended for use by build systems.

Nifty.

One of these days, I intend to resurrect my unprivileged chroot kernel
patches.  My current thought is to add a new syscall weak_chroot,
which should have these properties:

1. Can't be used unless no_new_privs is set or you have CAP_SYS_ADMIN.
2. Can't be used if fs->users > 1 (to avoid a trivial no_new_privs bypass).
3. Can't be used to break out of chroot jail.

The interface might be:

weak_chroot_at(int fd, const char *path, int flags)

Sets fs->weak_root to path, as seen from fd, according to flags.
Works if (no_new_privs && fs->users == 1) || capable(CAP_SYS_ADMIN).

Modify chroot to change fs->weak_root and fs->root.  Further modify
the path walking code so that / sees weak_root instead of root and so
that .. will not traverse root or weak_root.

I'm somewhat tempted to add a flag to weak_chroot_at to break out of
weak_root jail to prevent people from thinking that it's a security
feature.  I'm not sure about that, though.

--Andy
