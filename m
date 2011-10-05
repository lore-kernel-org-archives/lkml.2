Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755Ab1JEESk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 00:18:40 -0400
Received: from mail.windriver.com ([147.11.1.11]:38627 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751657Ab1JEESj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 00:18:39 -0400
Date: Wed, 5 Oct 2011 00:18:28 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Subject: Re: linux-next: manual merge of the moduleh tree with the  tree
Message-ID: <20111005041828.GC14123@windriver.com>
References: <20111004175724.b253f03270f1067531e5d95d@canb.auug.org.au>
 <4E8B24BE.8060102@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4E8B24BE.8060102@cam.ac.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Re: linux-next: manual merge of the moduleh tree with the  tree] On 04/10/2011 (Tue 16:22) Jonathan Cameron wrote:

> On 10/04/11 07:57, Stephen Rothwell wrote:
> > Hi Paul,
> > 
> > Today's linux-next merge of the moduleh tree got a conflict in
> > drivers/staging/iio/industrialio-ring.c between commit 14555b14455f
> > ("staging:iio: replacing term ring with buffer in the IIO core") from the
> > staging tree and commit 4903058fe223 ("staging: Add export.h for
> > THIS_MODULE/EXPORT_SYMBOL to drivers/staging users") from the moduleh
> > tree.
> > 
> > The former renamed the file modified by the latter.  The new file is
> > drivers/staging/iio/industrialio-buffer.c and will need to include
> > export.h.
> > 
> > From: Stephen Rothwell <sfr@canb.auug.org.au>
> > Date: Tue, 4 Oct 2011 17:48:56 +1100
> > Subject: [PATCH] staging: Add export.h for EXPORT_SYMBOL to
> >  drivers/staging/iio/industrialio-buffer.c
> > 
> > Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Acked-by: Jonathan Cameron <jic23@cam.ac.uk>
> 
> Sorry Paul, I fear this going to keep happening.  Is there
> a minimal set of patches Greg could pull into staging-next
> to avoid more similar issues?
> (assuming it isn't already all sorted out!)

Git will handle renames without issue (e.g. net-next renames
nearly all the drivers, and there are no issues there). I'm
not sure what you've got planned that makes you think this will keep
happening, but regardless, what you can do to help out is this:

If you create/rewrite some staging driver, check whether it
uses module_param and only that -- if so it needs moduleparam.h

Then check if it uses MODULE_* or module_*  -- such as
MODULE_LICENSE and module_table or similar.  If so you really
need to include module.h or else it will build fail in linux-next.
The module.h will give you moduleparam.h (and export.h in l-next).

Finally if it only uses EXPORT_SYMBOL and/or THIS_MODULE, it will
eventually need export.h -- but since your tree won't have that
file (yet) you can put a module.h include into that file, and give
me a heads up on it and I can "downgrade" the include to be just
for export.h later (via my post-merge queue of patches).  By putting
the module.h in as a placeholder for the export.h, you manage to
avoid Stephen having to deal with it as a build failure.

Greg can't pull the module.h tree into staging permanently since
the streams have to be presented separately for the final permanent
merge upstream.  But there is nothing stopping you from fetching
the module.h content, merging it into your sandbox and having it
present during your testing if you were so inclined.

Thanks for asking,
Paul.

> > ---
> >  drivers/staging/iio/industrialio-buffer.c |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/staging/iio/industrialio-buffer.c b/drivers/staging/iio/industrialio-buffer.c
> > index 4ce101a..628aa69 100644
> > --- a/drivers/staging/iio/industrialio-buffer.c
> > +++ b/drivers/staging/iio/industrialio-buffer.c
> > @@ -14,6 +14,7 @@
> >   * - Alternative access techniques?
> >   */
> >  #include <linux/kernel.h>
> > +#include <linux/export.h>
> >  #include <linux/device.h>
> >  #include <linux/fs.h>
> >  #include <linux/cdev.h>
> 
