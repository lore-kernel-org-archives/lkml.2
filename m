Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479Ab2D2Vjd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 17:39:33 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48713 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754002Ab2D2Vjc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 17:39:32 -0400
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <1335669917-23970-1-git-send-email-vapier@gentoo.org>
References: <1335669917-23970-1-git-send-email-vapier@gentoo.org>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Mon, 30 Apr 2012 09:39:11 +1200
Message-ID: <CAKgNAkgykZJV59WJXW9c9gVwXhn=WNYKxo_W1GM7ocHEEFqEXg@mail.gmail.com>
Subject: Re: [PATCH] open(2): document O_PATH
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-man@vger.kernel.org, aneesh.kumar@linux.vnet.ibm.com,
        viro@zeniv.linux.org.uk, Richard Weinberger <richard@nod.at>,
        lkml <linux-kernel@vger.kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

[Al, Aneesh, there is a question for you below]

On Sun, Apr 29, 2012 at 3:25 PM, Mike Frysinger <vapier@gentoo.org> wrote:
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> ---
>  man2/open.2 |   16 +++++++++++++++-
>  1 file changed, 15 insertions(+), 1 deletion(-)
>
> diff --git a/man2/open.2 b/man2/open.2
> index a655fae..61689cf 100644
> --- a/man2/open.2
> +++ b/man2/open.2
> @@ -47,7 +47,6 @@
>  .\" FIXME . Apr 08: The next POSIX revision has O_EXEC, O_SEARCH, and
>  .\" O_TTYINIT.  Eventually these may need to be documented.  --mtk
>  .\" FIXME Linux 2.6.33 has O_DSYNC, and a hidden __O_SYNC.
> -.\" FIXME: Linux 2.6.39 added O_PATH
>  .\"
>  .TH OPEN 2 2012-02-27 "Linux" "Linux Programmer's Manual"
>  .SH NAME
> @@ -428,6 +427,21 @@ For a discussion of the effect of
>  in conjunction with mandatory file locks and with file leases, see
>  .BR fcntl (2).
>  .TP
> +.B O_PATH
> +The path is opened for accessing its file attributes only.  Since the file
> +itself is not opened, most operations (such as
> +.BR read (2)
> +or
> +.BR write (2))
> +will return
> +.BR EBADF .
> +You may however use functions that operate on the file descriptor itself
> +such as
> +.BR close (2),
> +functions that duplicate file descriptors, and as the dirfd argument with
> +all the *at style of functions (e.g.
> +.BR openat (2)).
> +.TP
>  .B O_SYNC
>  The file is opened for synchronous I/O.
>  Any

Thanks for the prod. Adding this has been on my list for a while.
There's actually quite a lot more to say, and I've written the patch
below. Could you check it over.

Al, Aneesh, there is one question for you in a FIXME below. Could you
take a look please?

Thanks,

Michael


--- a/man2/open.2
+++ b/man2/open.2
@@ -428,6 +427,66 @@ For a discussion of the effect of
 in conjunction with mandatory file locks and with file leases, see
 .BR fcntl (2).
 .TP
+.BR O_PATH " (since Linux 2.6.39)"
+.\" commit 1abf0c718f15a56a0a435588d1b104c7a37dc9bd
+Obtain a file descriptor that is used only for fetching file attributes.
+The file itself is not opened, and most file operations (e.g.,
+.BR read (2),
+.BR write (2))
+fail with the error
+.BR EBADF .
+The following operations
+.I can
+be performed on the resulting file descriptor:
+.RS
+.IP * 3
+Closing the file descriptor
+.RB ( close (2)).
+.\" FIXME Commit 1abf0c718f15a56a0a435588d1b104c7a37dc9bdcw
+.\" message says that closing the file descriptor does not affect
+.\" POSIX locks or dnotify.
+.\" However, my testing shows that it DOES affect dnotify (and inotify).
+.\" Does close() affect POSIX locks?
+.IP *
+Duplicating the file descriptor
+.RB ( dup (2),
+.BR fcntl (2)
+.BR F_DUPFD ,
+etc.).
+.IP *
+Getting and setting file descriptor flags
+.RB ( fcntl (2)
+.BR F_GETFD
+and
+.BR F_SETFD ).
+.IP *
+Passing the file descriptor as the
+.IR dirfd
+argument of
+.BR openat (2)
+and the other "*at()" system calls.
+.IP *
+Passing the file descriptor to another process via a UNIX domain socket
+(see
+.BR SCM_RIGHTS
+in
+.BR unix (7)).
+.RE
+.IP
+When
+.B O_PATH
+is specified in
+.IR flags ,
+flag bits other than
+.BR O_DIRECTORY
+and
+.BR O_NOFOLLOW
+are ignored.
+If the
+.BR O_NOFOLLOW
+flag is specified,
+then the call returns a file descriptor referring to the symbolic link.
+.TP
 .B O_SYNC
 The file is opened for synchronous I/O.
 Any
@@ -612,8 +671,9 @@ SVr4, 4.3BSD, POSIX.1-2001.
 The
 .BR O_DIRECTORY ,
 .BR O_NOATIME ,
+.BR O_NOFOLLOW ,
 and
-.B O_NOFOLLOW
+.BR O_PATH
 flags are Linux-specific, and one may need to define
 .B _GNU_SOURCE
 (before including




-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
