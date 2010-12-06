Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468Ab0LFPMW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 10:12:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42110 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750774Ab0LFPMU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 10:12:20 -0500
Date: Mon, 6 Dec 2010 10:12:14 -0500
From: Jeff Layton <jlayton@redhat.com>
To: Jeff Layton <jlayton@samba.org>
Cc: Bernhard Walle <bernhard@bwalle.de>, sfrench@samba.org,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cifs: Add information about noserverino
Message-ID: <20101206101214.52a24415@tlielax.poochiereds.net>
In-Reply-To: <20101206095725.78422138@tlielax.poochiereds.net>
References: <1291568855-22604-1-git-send-email-bernhard@bwalle.de>
	<20101206095725.78422138@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Dec 2010 09:57:25 -0500
Jeff Layton <jlayton@samba.org> wrote:

> On Sun,  5 Dec 2010 18:07:35 +0100
> Bernhard Walle <bernhard@bwalle.de> wrote:
> 
> > In my case I had the problem that 32 bit userspace applications in an
> > amd64 environment was not able to list the directories of a CIFS-mounted
> > share. The simple userspace code
> > 
> >     int main(int argc, char *argv[])
> >     {
> >         DIR *dir;
> >         struct dirent *dirent;
> > 
> >         if (!argv[1]) {
> >             fprintf(stderr, "Usage: %s <directory>\n", argv[0]);
> >             return -1;
> >         }
> > 
> >         dir = opendir(argv[1]);
> >         if (!dir) {
> >             perror("Unable to open directory");
> >             return -1;
> >         }
> > 
> >         while ((dirent = readdir(dir)) != NULL)
> >             puts(dirent->d_name);
> > 
> >         closedir(dir);
> > 
> >         return 0;
> >     }
> > 
> > was sufficient to trigger the problem.
> > 
> > I discovered that the problem was that the inodes were too large to fit
> > in a 32 bit (unsigned long) integer, so the compat_filldir() function
> > returned -EOVERFLOW.
> > 
> > While that is okay it would have saved me a some hours of debugging if
> > the message below would have appeared in my kernel log.
> > 
> > The target was a Samba server (I guess) of a Buffalo LinkStation Duo
> > with the unmodified vendor firmware 1.34.
> > 
> > Signed-off-by: Bernhard Walle <bernhard@bwalle.de>
> > ---
> >  fs/cifs/readdir.c |   23 +++++++++++++++++++----
> >  1 files changed, 19 insertions(+), 4 deletions(-)
> > 
> > diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
> > index d5e591f..d979826 100644
> > --- a/fs/cifs/readdir.c
> > +++ b/fs/cifs/readdir.c
> > @@ -773,6 +773,7 @@ int cifs_readdir(struct file *file, void *direntry, filldir_t filldir)
> >  	char *tmp_buf = NULL;
> >  	char *end_of_smb;
> >  	unsigned int max_len;
> > +	int err;
> >  
> >  	xid = GetXid();
> >  
> > @@ -783,17 +784,31 @@ int cifs_readdir(struct file *file, void *direntry, filldir_t filldir)
> >  
> >  	switch ((int) file->f_pos) {
> >  	case 0:
> > -		if (filldir(direntry, ".", 1, file->f_pos,
> > -		     file->f_path.dentry->d_inode->i_ino, DT_DIR) < 0) {
> > +		err = filldir(direntry, ".", 1, file->f_pos,
> > +		     file->f_path.dentry->d_inode->i_ino, DT_DIR);
> > +		if (err < 0) {
> >  			cERROR(1, "Filldir for current dir failed");
> > +			if (err == -EOVERFLOW) {
> > +				cERROR(1, "Server inodes are too large for 32 "
> > +						"bit userspace. You might "
> > +						"consider using 'noserverino' "
> > +						"mount option for this mount.");
> > +			}
> >  			rc = -ENOMEM;
> >  			break;
> >  		}
> >  		file->f_pos++;
> >  	case 1:
> > -		if (filldir(direntry, "..", 2, file->f_pos,
> > -		     file->f_path.dentry->d_parent->d_inode->i_ino, DT_DIR) < 0) {
> > +		err = filldir(direntry, "..", 2, file->f_pos,
> > +		     file->f_path.dentry->d_parent->d_inode->i_ino, DT_DIR);
> > +		if (err < 0) {
> >  			cERROR(1, "Filldir for parent dir failed");
> > +			if (err == -EOVERFLOW) {
> > +				cERROR(1, "Server inodes are too large for 32 "
> > +						"bit userspace. You might "
> > +						"consider using 'noserverino' "
> > +						"mount option for this mount.");
> > +			}
> >  			rc = -ENOMEM;
> >  			break;
> >  		}
> 
> This doesn't look right to me...
> 
> i_ino is an unsigned long. The code in filldir() is this:
> 
>         unsigned long d_ino;
> 
> [...]
> 
>         d_ino = ino;
>         if (sizeof(d_ino) < sizeof(ino) && d_ino != ino) {
>                 buf->error = -EOVERFLOW;
>                 return -EOVERFLOW;
>         }
> 
> ...so the first condition will return true on a 32-bit arch, but it's
> not clear to me how you'd get the second one to return true in this
> situation.
> 

Oh.... *compat*_filldir. Ok, that makes more sense...

I'm still not sure I like this patch however. It potentially means a
lot of printk spam since these things have no ratelimiting. It also
doesn't tell me anything about which server might be giving me grief.

Maybe this should be turned into a cFYI?

The bottom line though is that running 32-bit applications that were
built without -D_FILE_OFFSET_BITS=64 on a 64-bit kernel is a very bad
idea. It would be nice to be able to alert users that things aren't
working the way they expect, but I'm not sure this is the right place
to do that.

-- 
Jeff Layton <jlayton@redhat.com>
