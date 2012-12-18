Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449Ab2LRWDN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 17:03:13 -0500
Received: from mail-ob0-f175.google.com ([209.85.214.175]:34348 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754499Ab2LRWDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 17:03:09 -0500
MIME-Version: 1.0
In-Reply-To: <CAGXu5jL6od7Mpm3NPDD-wyo8cZGmOY8HZwpkVBaSPc61Z+TxOA@mail.gmail.com>
References: <1355866000-18295-1-git-send-email-dinggnu@gmail.com>
	<CAGXu5jL6od7Mpm3NPDD-wyo8cZGmOY8HZwpkVBaSPc61Z+TxOA@mail.gmail.com>
Date: Tue, 18 Dec 2012 14:03:08 -0800
X-Google-Sender-Auth: _-4Ix-YzMFBp3gmHWl6KcMLQh5E
Message-ID: <CAGXu5jKfrBikf1ND6Oeadwnr6Zh4wG2raF8BCNOxN2TJBwTedw@mail.gmail.com>
Subject: Re: [PATCH] usr/gen_init_cpio.c: remove unnecessary "if"
From: Kees Cook <keescook@chromium.org>
To: Cong Ding <dinggnu@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jiri Kosina <jkosina@suse.cz>,
        Jesper Juhl <jj@codesealer.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[resend, busted mailer]

On Tue, Dec 18, 2012 at 1:26 PM, Cong Ding <dinggnu@gmail.com> wrote:
>
> usr/gen_init_cpio.c: remove unnecessary "if"
>
> if it goes to fail, dname isn't allocated; otherwise, it is allocated
> successfully. so we just free memory when it doesn't fail.
>
> this patch also fix a trival trailing space warning by checkpatch
>
> Signed-off-by: Cong Ding <dinggnu@gmail.com>
> ---
>  usr/gen_init_cpio.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/usr/gen_init_cpio.c b/usr/gen_init_cpio.c
> index af8c925..afebe09 100644
> --- a/usr/gen_init_cpio.c
> +++ b/usr/gen_init_cpio.c
> @@ -372,7 +372,7 @@ static int cpio_mkfile(const char *name, const char
> *location,
>         }
>         ino++;
>         rc = 0;
> -
> +
>  error:
>         if (filebuf) free(filebuf);
>         if (file >= 0) close(file);


This chunk is fine.

> @@ -452,8 +452,8 @@ static int cpio_mkfile_line(const char *line)
>         }
>         rc = cpio_mkfile(dname, cpio_replace_env(location),
>                          mode, uid, gid, nlinks);
> +       free(dname);
>   fail:
> -       if (dname_len) free(dname);
>         return rc;
>  }

While technically correct, the dname_len check is there to avoid the case of
trying to free "name" if a "goto fail" is ever added to the code. So, it's
defensive given the mixing of dname being either allocated or static. I
think it might be cleaner to use a new char * (maybe "name_arg", instead of
re-using dname), and then dname can always be freed before the function
returns:

  char * name_arg;
  ...
  if (end && ...) {
      ...
      name_arg = dname;
  } else {
      name_arg = name;
  }
  rc = cpio_mkfile(name_arg, ...);
fail:
  free(dname);
  return rc;

And I'd probably rename "fail" to "out".

-Kees

--
Kees Cook
Chrome OS Security
