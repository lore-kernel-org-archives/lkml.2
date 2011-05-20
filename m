Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757007Ab1ETAzJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 20:55:09 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:35855 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752739Ab1ETAzG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 20:55:06 -0400
Subject: Re: [PATCH v5 05/21] ima: move ima_file_free before releasing the
 file
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Dmitry Kasatkin <dmitry.kasatkin@nokia.com>,
        Mimi Zohar <zohar@us.ibm.com>
In-Reply-To: <20110519220649.GA4332@mail.hallyn.com>
References: <1305557115-15652-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <1305557115-15652-6-git-send-email-zohar@linux.vnet.ibm.com>
	 <20110519220649.GA4332@mail.hallyn.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 19 May 2011 20:55:01 -0400
Message-ID: <1305852901.2528.40.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-19 at 17:06 -0500, Serge E. Hallyn wrote:
> Quoting Mimi Zohar (zohar@linux.vnet.ibm.com):
> > Integrity appraisal measures files on file_free and stores the file
> > measurement as an xattr.  Measure the file before releasing it.
> 
> Can you put a bit more in the commit msg about why?  What's magic
> about the fs-specific release function?

ima_file_free(), called on __fput(), currently flags files that have
changed, so that the file is re-measured.  However, for appraising a
files's integrity, flagging the file is not enough.  The file's
security.ima xattr must be updated to reflect any changes.  This patch
moves releasing the file to after calculating the new file hash.

> > Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
> > Acked-by: Serge Hallyn <serge.hallyn@ubuntu.com>
> > ---
> >  fs/file_table.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/fs/file_table.c b/fs/file_table.c
> > index 01e4c1e..33f54a1 100644
> > --- a/fs/file_table.c
> > +++ b/fs/file_table.c
> > @@ -243,10 +243,10 @@ static void __fput(struct file *file)
> >  		if (file->f_op && file->f_op->fasync)
> >  			file->f_op->fasync(-1, file, 0);
> >  	}
> > +	ima_file_free(file);
> >  	if (file->f_op && file->f_op->release)
> >  		file->f_op->release(inode, file);
> >  	security_file_free(file);
> > -	ima_file_free(file);
> >  	if (unlikely(S_ISCHR(inode->i_mode) && inode->i_cdev != NULL &&
> >  		     !(file->f_mode & FMODE_PATH))) {
> >  		cdev_put(inode->i_cdev);
> > -- 

