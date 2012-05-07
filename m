Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755848Ab2EGIhM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 04:37:12 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:59648 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755564Ab2EGIhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 04:37:11 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArgLAFCJp09bdWOb/2dsb2JhbABEhXKkbyKHbYEHggwBAQUjBEASEAsYAgImAgJXBoglp3eSBoEvjliBGASXD48xgms
X-IronPort-AV: E=Sophos;i="4.75,543,1330902000"; 
   d="scan'208";a="910457577"
Message-ID: <1336379814.2852.22.camel@fourier.local.igalia.com>
Subject: Re: [PATCH v2 2/3] Staging: ipack: added support for the TEWS
 TPCI-200 carrier board
From: Samuel Iglesias =?ISO-8859-1?Q?Gons=E1lvez?= 
	<siglesias@igalia.com>
To: Manohar Vanga <manohar.vanga@cern.ch>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Mon, 07 May 2012 10:36:54 +0200
In-Reply-To: <20120507082007.GA30608@becoht-mvanga>
References: <1336375569-21692-1-git-send-email-siglesias@igalia.com>
	 <1336375569-21692-2-git-send-email-siglesias@igalia.com>
	 <20120507082007.GA30608@becoht-mvanga>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-05-07 at 10:20 +0200, Manohar Vanga wrote:
> Hey Samuel,
> 
> Just a couple of quick comments on this patch :)
> 
> > +TPCI-200
> > +--------
> > +
> > +* It receives the name of the mezzanine plugged in each slot by
SYSFS.
> > +  No autodetection supported yet, because the mezzanine driver
could not be
> > +  loaded at the time that the tpci200 driver loads.
> > +
> > +* It has a linked list with the tpci200 devices it is managing. Get
rid of it
> > +  and use driver_for_each_device() instead.
> > +
> >  Ipack
> >  -----
> >  
> > @@ -20,4 +30,3 @@ Ipack
> >    remove_device() to notify the carrier driver, or the opposite
with the call to
> >    the ipack_driver_ops' remove() function could be improved.
> >  
> > -
> 
> Is this whitespace change required?
> 
> 
It is not. I will rearrange the previous patch to avoid this
uncomfortable change.

> +#include <linux/module.h>
> > +#include "tpci200.h"
> > +
> > +#define MODULE_NAME "tpci200"
> 
> Here you can just use the KBUILD_MODNAME variable
> 
> > +#define PFX MODULE_NAME ": "
> 
> You can also add this before all your includes:
> #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> 
> 
Thanks a lot. I didn't know about it.

> +static int tpci200_install(struct tpci200_board *tpci200)
> > +{
> > +	int res = 0;
> > +
> > +	tpci200->slots = kzalloc(TPCI200_NB_SLOT * sizeof(struct
tpci200_slot), GFP_KERNEL);
> 
> Did you run checkpatch.pl on the patches? Are you ignoring the >80
char
> recommendation? In that case ignore this :)
> 

Yes, I ran it. I ignore the warning to facilitate the reading of the
sentences. However, I will re-check all the warnings to minimize the
number of them.

> > +static struct pci_device_id tpci200_idtable[2]; /* last must be
zero */
> > +
> > +static struct pci_driver tpci200_pci_drv = {
> > +	.name = "tpci200",
> > +	.id_table = tpci200_idtable,
> > +	.probe = tpci200_pciprobe,
> > +	.remove = __devexit_p(tpci200_pci_remove),
> > +};
> > +
> > +static int __init tpci200_drvr_init_module(void)
> > +{
> > +	tpci200_idtable[0].vendor = TPCI200_VENDOR_ID;
> > +	tpci200_idtable[0].device = TPCI200_DEVICE_ID;
> > +	tpci200_idtable[0].subvendor = TPCI200_SUBVENDOR_ID;
> > +	tpci200_idtable[0].subdevice = TPCI200_SUBDEVICE_ID;
> > +	return pci_register_driver(&tpci200_pci_drv);
> > +}
> 
> Can't tpci200_idtable be statically declared instead of inside the
init function?
> 
> 
Yes, it can. I will fix it.

> +static void __exit tpci200_drvr_exit_module(void)
> > +{
> > +	struct tpci200_board *tpci200;
> > +	struct list_head *element, *next;
> > +
> > +	list_for_each_safe(element, next, &tpci200_list) {
> > +		tpci200 = list_entry(element, struct tpci200_board, list);
> > +		__tpci200_pci_remove(tpci200);
> > +	}
> 
> You can use list_for_each_entry_safe instead of list_for_each_safe +
list_entry.
> I think you've used this everywhere so this would apply to the whole
patch :)
> 
> 
Thanks for the tips,

Sam

