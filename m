Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756562Ab2F0Ly1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 07:54:27 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:44314 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753605Ab2F0LyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 07:54:24 -0400
Message-ID: <1340798009.2755.6.camel@falcor>
Subject: Re: [PATCH] ima: use full pathnames in measurement list
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Cc: James Morris <jmorris@namei.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Wed, 27 Jun 2012 07:53:29 -0400
In-Reply-To: <CALLzPKYLyr9UrBn1eZ_8fAEusDpDJJGyTT_7_ytwO2-x67AWOg@mail.gmail.com>
References: <1340375022.2464.29.camel@falcor>
	 <alpine.LRH.2.02.1206251229180.26369@tundra.namei.org>
	 <1340621148.2366.2.camel@falcor>
	 <CALLzPKYLyr9UrBn1eZ_8fAEusDpDJJGyTT_7_ytwO2-x67AWOg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12062711-4242-0000-0000-000002221E4A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-27 at 14:18 +0300, Kasatkin, Dmitry wrote:
> On Mon, Jun 25, 2012 at 1:45 PM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> > On Mon, 2012-06-25 at 12:29 +1000, James Morris wrote:
> >> On Fri, 22 Jun 2012, Mimi Zohar wrote:
> >>
> >> > The IMA measurement list contains filename hints, which can be
> >> > ambigious without the full pathname.  This patch replaces the
> >> > filename hint with the full pathname, simplifying for userspace
> >> > the correlating of file hash measurements with files.
> >> >
> >> > Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
> >>
> >> Are you posting this for review or do you want it applied to my tree?
> >
> > It was posted for review, but both are good.
> >
> > thanks,
> >
> > Mimi
> >
> >> > ---
> >> >  security/integrity/ima/ima_main.c |   40 +++++++++++++++++++++++++++++++-----
> >> >  1 files changed, 34 insertions(+), 6 deletions(-)
> >> >
> >> > diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
> >> > index b17be79..91fa323 100644
> >> > --- a/security/integrity/ima/ima_main.c
> >> > +++ b/security/integrity/ima/ima_main.c
> >> > @@ -54,6 +54,7 @@ static void ima_rdwr_violation_check(struct file *file)
> >> >     fmode_t mode = file->f_mode;
> >> >     int rc;
> >> >     bool send_tomtou = false, send_writers = false;
> >> > +   unsigned char *pathname = NULL, *pathbuf = NULL;
> >> >
> >> >     if (!S_ISREG(inode->i_mode) || !ima_initialized)
> >> >             return;
> >> > @@ -75,12 +76,25 @@ static void ima_rdwr_violation_check(struct file *file)
> >> >  out:
> >> >     mutex_unlock(&inode->i_mutex);
> >> >
> >> > +   if (!send_tomtou && !send_writers)
> >> > +           return;
> >> > +
> >> > +   /* We will allow 11 spaces for ' (deleted)' to be appended */
> >> > +   pathbuf = kmalloc(PATH_MAX + 11, GFP_KERNEL);
> >> > +   if (pathbuf) {
> >> > +           pathname = d_path(&file->f_path, pathbuf, PATH_MAX + 11);
> >> > +           if (IS_ERR(pathname))
> >> > +                   pathname = NULL;
> >> > +   }
> >> >     if (send_tomtou)
> >> > -           ima_add_violation(inode, dentry->d_name.name, "invalid_pcr",
> >> > -                             "ToMToU");
> >> > +           ima_add_violation(inode,
> >> > +                             !pathname ? dentry->d_name.name : pathname,
> >> > +                             "invalid_pcr", "ToMToU");
> >> >     if (send_writers)
> >> > -           ima_add_violation(inode, dentry->d_name.name, "invalid_pcr",
> >> > -                             "open_writers");
> >> > +           ima_add_violation(inode,
> >> > +                             !pathname ? dentry->d_name.name : pathname,
> >> > +                             "invalid_pcr", "open_writers");
> >> > +   kfree(pathbuf);
> >> >  }
> >> >
> >> >  static void ima_check_last_writer(struct integrity_iint_cache *iint,
> >> > @@ -123,6 +137,7 @@ static int process_measurement(struct file *file, const unsigned char *filename,
> >> >  {
> >> >     struct inode *inode = file->f_dentry->d_inode;
> >> >     struct integrity_iint_cache *iint;
> >> > +   unsigned char *pathname = NULL, *pathbuf = NULL;
> >> >     int rc = 0;
> >> >
> >> >     if (!ima_initialized || !S_ISREG(inode->i_mode))
> >> > @@ -147,8 +162,21 @@ retry:
> >> >             goto out;
> >> >
> >> >     rc = ima_collect_measurement(iint, file);
> >> > -   if (!rc)
> >> > -           ima_store_measurement(iint, file, filename);
> >> > +   if (rc != 0)
> >> > +           goto out;
> >> > +
> >> > +   if (function != BPRM_CHECK) {
> >> > +           /* We will allow 11 spaces for ' (deleted)' to be appended */
> >> > +           pathbuf = kmalloc(PATH_MAX + 11, GFP_KERNEL);
> >> > +           if (pathbuf) {
> >> > +                   pathname =
> >> > +                       d_path(&file->f_path, pathbuf, PATH_MAX + 11);
> >> > +                   if (IS_ERR(pathname))
> >> > +                           pathname = NULL;
> >> > +           }
> >> > +   }
> >> > +   ima_store_measurement(iint, file, !pathname ? filename : pathname);
> 
> 
> ima_store_measurement() has such line:
> 
> strncpy(entry->template.file_name, filename, IMA_EVENT_NAME_LEN_MAX);
> 
> It might happens to copy beginning of the path....
> 
> - Dmitry

Yes, for now I'll add a string check, but it's time to resurrect the
template patches, which add support for different hashes and other file
metadata, and support variable length records.

Mimi

