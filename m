Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934344Ab1ETNkX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 09:40:23 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:62978 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933911Ab1ETNkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 09:40:21 -0400
X-Authority-Analysis: v=1.1 cv=ou1QuR4lBR9YeJgEH9ccYmbAdaWqVVq3lOvCKJtMpGM= c=1 sm=0 a=wom5GMh1gUkA:10 a=fXUj1uqOk9AA:10 a=Rj1_iGo3bfgA:10 a=kj9zAlcOel0A:10 a=g3F5VGk0NOMZWSIEWMgijA==:17 a=VnNF1IyMAAAA:8 a=fxJcL_dCAAAA:8 a=faYgXMQxVxIsQgNGN00A:9 a=CjuIK1q_8ugA:10 a=2eKvNQJKnqYA:10 a=g3F5VGk0NOMZWSIEWMgijA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 70.123.158.191
Date: Fri, 20 May 2011 08:40:19 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Dmitry Kasatkin <dmitry.kasatkin@nokia.com>,
        Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [PATCH v5 05/21] ima: move ima_file_free before releasing the
 file
Message-ID: <20110520134019.GA27466@mail.hallyn.com>
References: <1305557115-15652-1-git-send-email-zohar@linux.vnet.ibm.com>
 <1305557115-15652-6-git-send-email-zohar@linux.vnet.ibm.com>
 <20110519220649.GA4332@mail.hallyn.com>
 <1305852901.2528.40.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305852901.2528.40.camel@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Mimi Zohar (zohar@linux.vnet.ibm.com):
> On Thu, 2011-05-19 at 17:06 -0500, Serge E. Hallyn wrote:
> > Quoting Mimi Zohar (zohar@linux.vnet.ibm.com):
> > > Integrity appraisal measures files on file_free and stores the file
> > > measurement as an xattr.  Measure the file before releasing it.
> > 
> > Can you put a bit more in the commit msg about why?  What's magic
> > about the fs-specific release function?
> 
> ima_file_free(), called on __fput(), currently flags files that have
> changed, so that the file is re-measured.  However, for appraising a
> files's integrity, flagging the file is not enough.  The file's
> security.ima xattr must be updated to reflect any changes.  This patch
> moves releasing the file to after calculating the new file hash.

Sorry if I'm being dense, but I still don't understand (even though
apparently I used to :)  why the fs release is magic here.  The
dropping of the writelock comes later, so no file will be able to
open the file for execute or write until that point, meaning that
won't be happening without a re-measure with or without this patch.

So you must be thinking something about general opens(), but I
don't believe that file_operations->release makes a difference to
another tasks's ability to open the file, nor to the writing out
of changed contents.

security_file_free() doesn't appear to be hooked by ima or evm,
and if a security module changes its security.X xattr you'll
end up re-measuring the xattrs anyway.

So I'm still missing something, sorry  :)

-serge

> > > Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
> > > Acked-by: Serge Hallyn <serge.hallyn@ubuntu.com>
> > > ---
> > >  fs/file_table.c |    2 +-
> > >  1 files changed, 1 insertions(+), 1 deletions(-)
> > > 
> > > diff --git a/fs/file_table.c b/fs/file_table.c
> > > index 01e4c1e..33f54a1 100644
> > > --- a/fs/file_table.c
> > > +++ b/fs/file_table.c
> > > @@ -243,10 +243,10 @@ static void __fput(struct file *file)
> > >  		if (file->f_op && file->f_op->fasync)
> > >  			file->f_op->fasync(-1, file, 0);
> > >  	}
> > > +	ima_file_free(file);
> > >  	if (file->f_op && file->f_op->release)
> > >  		file->f_op->release(inode, file);
> > >  	security_file_free(file);
> > > -	ima_file_free(file);
> > >  	if (unlikely(S_ISCHR(inode->i_mode) && inode->i_cdev != NULL &&
> > >  		     !(file->f_mode & FMODE_PATH))) {
> > >  		cdev_put(inode->i_cdev);
> > > -- 
> 
