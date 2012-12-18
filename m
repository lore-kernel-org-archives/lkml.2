Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499Ab2LRWuU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 17:50:20 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:46284 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753278Ab2LRWuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 17:50:17 -0500
Date: Tue, 18 Dec 2012 23:50:11 +0100
From: Cong Ding <dinggnu@gmail.com>
To: Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jiri Kosina <jkosina@suse.cz>,
        Jesper Juhl <jj@codesealer.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usr/gen_init_cpio.c: remove unnecessary "if"
Message-ID: <20121218225011.GB6143@gmail.com>
References: <1355866000-18295-1-git-send-email-dinggnu@gmail.com>
 <CAGXu5jL6od7Mpm3NPDD-wyo8cZGmOY8HZwpkVBaSPc61Z+TxOA@mail.gmail.com>
 <CAGXu5jKfrBikf1ND6Oeadwnr6Zh4wG2raF8BCNOxN2TJBwTedw@mail.gmail.com>
 <20121218224153.GA6143@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121218224153.GA6143@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2012 at 11:41:53PM +0100, Cong Ding wrote:
> On Tue, Dec 18, 2012 at 02:03:08PM -0800, Kees Cook wrote:
> > [resend, busted mailer]
> > 
> > On Tue, Dec 18, 2012 at 1:26 PM, Cong Ding <dinggnu@gmail.com> wrote:
> > >
> > > usr/gen_init_cpio.c: remove unnecessary "if"
> > >
> > > if it goes to fail, dname isn't allocated; otherwise, it is allocated
> > > successfully. so we just free memory when it doesn't fail.
> > >
> > > this patch also fix a trival trailing space warning by checkpatch
> > >
> > > Signed-off-by: Cong Ding <dinggnu@gmail.com>
> > > ---
> > >  usr/gen_init_cpio.c |    4 ++--
> > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/usr/gen_init_cpio.c b/usr/gen_init_cpio.c
> > > index af8c925..afebe09 100644
> > > --- a/usr/gen_init_cpio.c
> > > +++ b/usr/gen_init_cpio.c
> > > @@ -372,7 +372,7 @@ static int cpio_mkfile(const char *name, const char
> > > *location,
> > >         }
> > >         ino++;
> > >         rc = 0;
> > > -
> > > +
> > >  error:
> > >         if (filebuf) free(filebuf);
> > >         if (file >= 0) close(file);
> > 
> > 
> > This chunk is fine.
> > 
> > > @@ -452,8 +452,8 @@ static int cpio_mkfile_line(const char *line)
> > >         }
> > >         rc = cpio_mkfile(dname, cpio_replace_env(location),
> > >                          mode, uid, gid, nlinks);
> > > +       free(dname);
> > >   fail:
> > > -       if (dname_len) free(dname);
> > >         return rc;
> > >  }
> > 
> > While technically correct, the dname_len check is there to avoid the case of
> > trying to free "name" if a "goto fail" is ever added to the code. So, it's
> > defensive given the mixing of dname being either allocated or static. I
> > think it might be cleaner to use a new char * (maybe "name_arg", instead of
> > re-using dname), and then dname can always be freed before the function
> > returns:
> > 
> >   char * name_arg;
> >   ...
> >   if (end && ...) {
> >       ...
> >       name_arg = dname;
> >   } else {
> >       name_arg = name;
> >   }
> >   rc = cpio_mkfile(name_arg, ...);
> > fail:
> >   free(dname);
> >   return rc;
> sorry my patch is wrong (I missed the "else" branch). but I don't think it is
> necessary to use another variable name_arg.  so I think the correct version
> would be as following. if you think it is necessary and agree the change, I
> will send a version 2.
> 
> @@ -452,8 +452,8 @@ static int cpio_mkfile_line(const char *line)
>  	}
>  	rc = cpio_mkfile(dname, cpio_replace_env(location),
>  	                 mode, uid, gid, nlinks);
> +	if (dname_len) free(dname);
> - fail:
> + out:
> -	if (dname_len) free(dname);
>  	return rc;
>  }
> 
> or you want something like this? I have added variable name_arg, changed the
> dname_len to name_len, changed fail to out, moved free(dname) before "out".
> (btw, if we do like this, what do you suggest to use in the commit message?)
> 
>  usr/gen_init_cpio.c |   26 ++++++++++++++------------
>  1 file changed, 14 insertions(+), 12 deletions(-)
> 
> diff --git a/usr/gen_init_cpio.c b/usr/gen_init_cpio.c
> index af8c925..dff6a1e 100644
> --- a/usr/gen_init_cpio.c
> +++ b/usr/gen_init_cpio.c
> @@ -409,19 +409,20 @@ static int cpio_mkfile_line(const char *line)
>  {
>  	char name[PATH_MAX + 1];
>  	char *dname = NULL; /* malloc'ed buffer for hard links */
> +	char *name_arg;
>  	char location[PATH_MAX + 1];
>  	unsigned int mode;
>  	int uid;
>  	int gid;
>  	int nlinks = 1;
> -	int end = 0, dname_len = 0;
> +	int end = 0, name_len = 0;
>  	int rc = -1;
>  
>  	if (5 > sscanf(line, "%" str(PATH_MAX) "s %" str(PATH_MAX)
>  				"s %o %d %d %n",
>  				name, location, &mode, &uid, &gid, &end)) {
>  		fprintf(stderr, "Unrecognized file format '%s'", line);
> -		goto fail;
> +		goto out;
>  	}
>  	if (end && isgraph(line[end])) {
>  		int len;
> @@ -429,12 +430,13 @@ static int cpio_mkfile_line(const char *line)
>  
>  		dname = malloc(strlen(line));
>  		if (!dname) {
> -			fprintf (stderr, "out of memory (%d)\n", dname_len);
> -			goto fail;
> +			fprintf (stderr, "out of memory (%d)\n", name_len);
another thing I forgot to mention is that this the value of name_len in
fprintf is always 0. So can I assume here is something wrong? maybe we should
use this?
fprintf (stderr, "out of memory (%d)\n", strlen(line));
> +			goto out;
>  		}
>  
> -		dname_len = strlen(name) + 1;
> -		memcpy(dname, name, dname_len);
> +		name_arg = dname;
> +		name_len = strlen(name) + 1;
> +		memcpy(name_arg, name, name_len);
>  
>  		do {
>  			nend = 0;
> @@ -442,18 +444,18 @@ static int cpio_mkfile_line(const char *line)
>  					name, &nend) < 1)
>  				break;
>  			len = strlen(name) + 1;
> -			memcpy(dname + dname_len, name, len);
> -			dname_len += len;
> +			memcpy(name_arg + name_len, name, len);
> +			name_len += len;
>  			nlinks++;
>  			end += nend;
>  		} while (isgraph(line[end]));
>  	} else {
> -		dname = name;
> +		name_arg = name;
>  	}
> -	rc = cpio_mkfile(dname, cpio_replace_env(location),
> +	rc = cpio_mkfile(name_arg, cpio_replace_env(location),
>  	                 mode, uid, gid, nlinks);
> - fail:
> -	if (dname_len) free(dname);
> +	if (!dname) free(dname);
> + out:
>  	return rc;
>  }
>  
> -- 
> 1.7.10.4
> 
> 
> 
> 
>  
> -- 
> 1.7.10.4
> 
> > 
> > And I'd probably rename "fail" to "out".
> > 
> > -Kees
> > 
> > --
> > Kees Cook
> > Chrome OS Security
