Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162044Ab2GLXbR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 19:31:17 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:49910 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161850Ab2GLWk7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:40:59 -0400
MIME-Version: 1.0
In-Reply-To: <20120712175039.171791418@linuxfoundation.org>
References: <20120712175057.GA9917@kroah.com>
	<20120712175039.171791418@linuxfoundation.org>
Date: Fri, 13 Jul 2012 00:40:57 +0200
Message-ID: <CA+OH3v1vQ1kFy2E+VZqan3GSKGBKQowr8CHk49KDMXM-21rGrw@mail.gmail.com>
Subject: Re: [ 42/68] vfs: make O_PATH file descriptors usable for fchdir()
From: =?KOI8-R?B?z8zYx8Egy9LZ1sHOz9fTy8HR?= <olga.kryzhanovska@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just to be sure, has any one tested the patch (I can't, I am not doing
Linux kernel development and the closest here to me here only does
Solaris/Illumos and SUPERUX kernel development)?

My test case, which works on Solaris and AIX is below. You will have
to do a s/O_SEARCH/O_PATH/
-------- snip --------
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>

#include <stdlib.h>
#include <stdio.h>

int main(int ac, char *av[])
{
	int dirfd, dupdirfd;

	dirfd=open("/etc", O_SEARCH);
	if(dirfd<0)
	{
		fprintf(stderr, "open() failed.\n");
		return EXIT_FAILURE;
	}
	
	dupdirfd = fcntl(dirfd, F_DUPFD, 50);
	if(dirfd<0)
	{
		fprintf(stderr, "fcntl() failed.\n");
		return EXIT_FAILURE;
	}
	
	if(fchdir(dupdirfd)<0)
	{
		fprintf(stderr, "fchdir(dupdirfd) failed.\n");
		return EXIT_FAILURE;
	}

	if(fchdir(dirfd)<0)
	{
		fprintf(stderr, "fchdir(dirfd) failed.\n");
		return EXIT_FAILURE;
	}

	if(openat(dupdirfd, "profile", O_RDONLY)<0)
	{
		fprintf(stderr, "openat(dupdirfd, profile, O_RDONLY) failed.\n");
		return EXIT_FAILURE;
	}

	dirfd=openat(dupdirfd, "krb5", O_SEARCH);
	if(dirfd<0)
	{
		fprintf(stderr, "openat(dupdirfd, krb5, O_SEARCH) failed.\n");
		return EXIT_FAILURE;
	}

	if(fchdir(dirfd)<0)
	{
		fprintf(stderr, "2nd fchdir(dirfd) failed.\n");
		return EXIT_FAILURE;
	}
	
	puts("SUCCESS.");

	return EXIT_SUCCESS;
}
-------- snip --------

Olga

On Thu, Jul 12, 2012 at 7:51 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> 3.0-stable review patch.  If anyone has any objections, please let me know.
>
> ------------------
>
> From: Linus Torvalds <torvalds@linux-foundation.org>
>
> commit 332a2e1244bd08b9e3ecd378028513396a004a24 upstream.
>
> We already use them for openat() and friends, but fchdir() also wants to
> be able to use O_PATH file descriptors.  This should make it comparable
> to the O_SEARCH of Solaris.  In particular, O_PATH allows you to access
> (not-quite-open) a directory you don't have read persmission to, only
> execute permission.
>
> Noticed during development of multithread support for ksh93.
>
> Reported-by: ольга крыжановская <olga.kryzhanovska@gmail.com>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> ---
>  fs/open.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> --- a/fs/open.c
> +++ b/fs/open.c
> @@ -396,10 +396,10 @@ SYSCALL_DEFINE1(fchdir, unsigned int, fd
>  {
>         struct file *file;
>         struct inode *inode;
> -       int error;
> +       int error, fput_needed;
>
>         error = -EBADF;
> -       file = fget(fd);
> +       file = fget_raw_light(fd, &fput_needed);
>         if (!file)
>                 goto out;
>
> @@ -413,7 +413,7 @@ SYSCALL_DEFINE1(fchdir, unsigned int, fd
>         if (!error)
>                 set_fs_pwd(current->fs, &file->f_path);
>  out_putf:
> -       fput(file);
> +       fput_light(file, fput_needed);
>  out:
>         return error;
>  }
>
>



-- 
      ,   _                                    _   ,
     { \/`o;====-    Olga Kryzhanovska   -====;o`\/ }
.----'-/`-/     olga.kryzhanovska@gmail.com   \-`\-'----.
 `'-..-| /       http://twitter.com/fleyta     \ |-..-'`
      /\/\     Solaris/BSD//C/C++ programmer   /\/\
      `--`                                      `--`
