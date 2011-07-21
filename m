Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578Ab1GUM1g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 08:27:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59759 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751888Ab1GUM1f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 08:27:35 -0400
Date: Thu, 21 Jul 2011 08:27:31 -0400
From: Don Zickus <dzickus@redhat.com>
To: Huang Ying <ying.huang@intel.com>
Cc: "Luck, Tony" <tony.luck@intel.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] pstore: change mutex locking to spin_locks
Message-ID: <20110721122731.GV3765@redhat.com>
References: <1311195386-22743-1-git-send-email-dzickus@redhat.com>
 <4E277584.1060200@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E277584.1060200@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 21, 2011 at 08:40:36AM +0800, Huang Ying wrote:
> On 07/21/2011 04:56 AM, Don Zickus wrote:
> > pstore was using mutex locking to protect read/write access to the
> > backend plug-ins.  This causes problems when pstore is executed in
> > an NMI context through panic() -> kmsg_dump().
> > 
> > This patch changes the mutex to a spin_lock_irqsave then also checks to
> > see if we are in an NMI context.  If we are in an NMI and can't get the
> > lock, just print a message stating that and blow by the locking.
> > 
> > All this is probably a hack around the bigger locking problem but it
> > solves my current situation of trying to sleep in an NMI context.
> > 
> > Tested by loading the lkdtm module and executing a HARDLOCKUP which
> > will cause the machine to panic inside the nmi handler.
> > 
> > Signed-off-by: Don Zickus <dzickus@redhat.com>
> > ---
> >  drivers/acpi/apei/erst.c |    2 +-
> >  fs/pstore/platform.c     |   28 ++++++++++++++++++++++------
> >  include/linux/pstore.h   |    2 +-
> >  3 files changed, 24 insertions(+), 8 deletions(-)
> > 
> > diff --git a/drivers/acpi/apei/erst.c b/drivers/acpi/apei/erst.c
> > index e6cef8e..3d9c2a3 100644
> > --- a/drivers/acpi/apei/erst.c
> > +++ b/drivers/acpi/apei/erst.c
> > @@ -1155,7 +1155,7 @@ static int __init erst_init(void)
> >  		goto err_release_erange;
> >  
> >  	buf = kmalloc(erst_erange.size, GFP_KERNEL);
> > -	mutex_init(&erst_info.buf_mutex);
> > +	spin_lock_init(&erst_info.buf_lock);
> >  	if (buf) {
> >  		erst_info.buf = buf + sizeof(struct cper_pstore_record);
> >  		erst_info.bufsize = erst_erange.size -
> > diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
> > index f2c3ff2..53ba00b 100644
> > --- a/fs/pstore/platform.c
> > +++ b/fs/pstore/platform.c
> > @@ -27,6 +27,7 @@
> >  #include <linux/string.h>
> >  #include <linux/slab.h>
> >  #include <linux/uaccess.h>
> > +#include <linux/hardirq.h>
> >  
> >  #include "internal.h"
> >  
> > @@ -68,13 +69,21 @@ static void pstore_dump(struct kmsg_dumper *dumper,
> >  	char		*dst, *why;
> >  	u64		id;
> >  	int		hsize, part = 1;
> > +	unsigned long	flags = 0;
> > +	int 		is_locked = 0;
> >  
> >  	if (reason < ARRAY_SIZE(reason_str))
> >  		why = reason_str[reason];
> >  	else
> >  		why = "Unknown";
> >  
> > -	mutex_lock(&psinfo->buf_mutex);
> > +	if (in_nmi()) {
> > +		is_locked = spin_trylock(&psinfo->buf_lock);
> > +		if (!is_locked)
> > +			pr_err("pstore dump routine blocked in NMI, may corrupt error record\n");
> > +	} else {
> > +		spin_lock_irqsave(&psinfo->buf_lock, flags);
> > +	}
> >  	oopscount++;
> >  	while (total < kmsg_bytes) {
> >  		dst = psinfo->buf;
> > @@ -103,7 +112,12 @@ static void pstore_dump(struct kmsg_dumper *dumper,
> >  		l2 -= l2_cpy;
> >  		total += l1_cpy + l2_cpy;
> >  	}
> > -	mutex_unlock(&psinfo->buf_mutex);
> > +	if (in_nmi()) {
> > +		if (is_locked)
> > +			spin_unlock(&psinfo->buf_lock);
> > +	} else {
> > +		spin_unlock_irqrestore(&psinfo->buf_lock, flags);
> > +	}
> >  }
> >  
> >  static struct kmsg_dumper pstore_dumper = {
> > @@ -157,11 +171,12 @@ void pstore_get_records(void)
> >  	enum pstore_type_id	type;
> >  	struct timespec		time;
> >  	int			failed = 0, rc;
> > +	unsigned long		flags;
> >  
> >  	if (!psi)
> >  		return;
> >  
> > -	mutex_lock(&psinfo->buf_mutex);
> > +	spin_lock_irqsave(&psinfo->buf_lock, flags);
> >  	rc = psi->open(psi);
> >  	if (rc)
> >  		goto out;
> > @@ -173,7 +188,7 @@ void pstore_get_records(void)
> >  	}
> >  	psi->close(psi);
> >  out:
> > -	mutex_unlock(&psinfo->buf_mutex);
> > +	spin_unlock_irqrestore(&psinfo->buf_lock, flags);
> >  
> >  	if (failed)
> >  		printk(KERN_WARNING "pstore: failed to load %d record(s) from '%s'\n",
> > @@ -187,6 +202,7 @@ out:
> >  int pstore_write(enum pstore_type_id type, char *buf, size_t size)
> >  {
> >  	u64	id;
> > +	unsigned long flags;
> >  
> >  	if (!psinfo)
> >  		return -ENODEV;
> > @@ -194,13 +210,13 @@ int pstore_write(enum pstore_type_id type, char *buf, size_t size)
> >  	if (size > psinfo->bufsize)
> >  		return -EFBIG;
> >  
> > -	mutex_lock(&psinfo->buf_mutex);
> > +	spin_lock_irqsave(&psinfo->buf_lock, flags);
> >  	memcpy(psinfo->buf, buf, size);
> >  	id = psinfo->write(type, size);
> >  	if (pstore_is_mounted())
> >  		pstore_mkfile(PSTORE_TYPE_DMESG, psinfo->name, id, psinfo->buf,
> >  			      size, CURRENT_TIME, psinfo->erase);
> > -	mutex_unlock(&psinfo->buf_mutex);
> > +	spin_unlock_irqrestore(&psinfo->buf_lock, flags);
> 
> Is it safe to call pstore_mkfile with IRQ disabled?
> 
> pstore_mkfile -> d_alloc_name -> d_alloc -> kmem_cache_alloc(, GFP_KERNEL).

Don't know.  But would that mean we would have to put the pstore_mkfile
on a workqueue then or something similar?

Cheers,
Don
