Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751777Ab2GDMbe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 08:31:34 -0400
Received: from one.firstfloor.org ([213.235.205.2]:45145 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095Ab2GDMbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 08:31:32 -0400
Date: Wed, 4 Jul 2012 14:31:31 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] floppy: Run floppy initialization asynchronous
Message-ID: <20120704123131.GQ11413@one.firstfloor.org>
References: <1341275224-31696-1-git-send-email-andi@firstfloor.org> <alpine.LNX.2.00.1207041402010.17304@pobox.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1207041402010.17304@pobox.suse.cz>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 04, 2012 at 02:03:07PM +0200, Jiri Kosina wrote:
> On Mon, 2 Jul 2012, Andi Kleen wrote:
> 
> > From: Andi Kleen <ak@linux.intel.com>
> > 
> > floppy_init is quite slow, 3s on my test system to determine
> > that there is no floppy. Run it asynchronous to the other
> > init calls to improve boot time.
> > 
> > Signed-off-by: Andi Kleen <ak@linux.intel.com>
> > ---
> >  drivers/block/floppy.c |   21 ++++++++++++++++++++-
> >  1 files changed, 20 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
> > index cce7df3..8b5769b 100644
> > --- a/drivers/block/floppy.c
> > +++ b/drivers/block/floppy.c
> > @@ -191,6 +191,7 @@ static int print_unex = 1;
> >  #include <linux/mutex.h>
> >  #include <linux/io.h>
> >  #include <linux/uaccess.h>
> > +#include <linux/async.h>
> >  
> >  /*
> >   * PS/2 floppies have much slower step rates than regular floppies.
> > @@ -4122,7 +4123,7 @@ static struct kobject *floppy_find(dev_t dev, int *part, void *data)
> >  	return get_disk(disks[drive]);
> >  }
> >  
> > -static int __init floppy_init(void)
> > +static int __init do_floppy_init(void)
> >  {
> >  	int i, unit, drive;
> >  	int err, dr;
> > @@ -4337,6 +4338,24 @@ out_put_disk:
> >  	return err;
> >  }
> >  
> > +#ifndef MODULE
> > +static __init void floppy_async_init(void *data, async_cookie_t cookie)
> > +{
> > +	do_floppy_init();
> > +}
> > +#endif
> > +
> > +static int __init floppy_init(void)
> > +{
> > +#ifdef MODULE
> > +	return do_floppy_init(void);
> 
> This isn't really a valid C.
> 
> I have fixed that and applied.

Thanks.

It would be also good to figure out how to move floppy_init 
earlier in the init sequence. I think then you could hide more 
of the 3s latency than just 1s.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
