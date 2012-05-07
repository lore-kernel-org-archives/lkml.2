Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755661Ab2EGIb7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 04:31:59 -0400
Received: from cernmx32.cern.ch ([137.138.144.178]:56533 "EHLO
	CERNMX32.cern.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755447Ab2EGIb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 04:31:57 -0400
X-Greylist: delayed 326 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 May 2012 04:31:57 EDT
Date: Mon, 7 May 2012 10:20:07 +0200
From: Manohar Vanga <manohar.vanga@cern.ch>
To: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <devel@driverdev.osuosl.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/3] Staging: ipack: added support for the TEWS
 TPCI-200 carrier board
Message-ID: <20120507082007.GA30608@becoht-mvanga>
Mail-Followup-To: Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
References: <1336375569-21692-1-git-send-email-siglesias@igalia.com>
 <1336375569-21692-2-git-send-email-siglesias@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1336375569-21692-2-git-send-email-siglesias@igalia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [137.138.192.18]
Keywords: CERN SpamKiller Note: -50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Samuel,

Just a couple of quick comments on this patch :)

> +TPCI-200
> +--------
> +
> +* It receives the name of the mezzanine plugged in each slot by SYSFS.
> +  No autodetection supported yet, because the mezzanine driver could not be
> +  loaded at the time that the tpci200 driver loads.
> +
> +* It has a linked list with the tpci200 devices it is managing. Get rid of it
> +  and use driver_for_each_device() instead.
> +
>  Ipack
>  -----
>  
> @@ -20,4 +30,3 @@ Ipack
>    remove_device() to notify the carrier driver, or the opposite with the call to
>    the ipack_driver_ops' remove() function could be improved.
>  
> -

Is this whitespace change required?

> +#include <linux/module.h>
> +#include "tpci200.h"
> +
> +#define MODULE_NAME "tpci200"

Here you can just use the KBUILD_MODNAME variable

> +#define PFX MODULE_NAME ": "

You can also add this before all your includes:
#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

> +static int tpci200_install(struct tpci200_board *tpci200)
> +{
> +	int res = 0;
> +
> +	tpci200->slots = kzalloc(TPCI200_NB_SLOT * sizeof(struct tpci200_slot), GFP_KERNEL);

Did you run checkpatch.pl on the patches? Are you ignoring the >80 char
recommendation? In that case ignore this :)

> +static struct pci_device_id tpci200_idtable[2]; /* last must be zero */
> +
> +static struct pci_driver tpci200_pci_drv = {
> +	.name = "tpci200",
> +	.id_table = tpci200_idtable,
> +	.probe = tpci200_pciprobe,
> +	.remove = __devexit_p(tpci200_pci_remove),
> +};
> +
> +static int __init tpci200_drvr_init_module(void)
> +{
> +	tpci200_idtable[0].vendor = TPCI200_VENDOR_ID;
> +	tpci200_idtable[0].device = TPCI200_DEVICE_ID;
> +	tpci200_idtable[0].subvendor = TPCI200_SUBVENDOR_ID;
> +	tpci200_idtable[0].subdevice = TPCI200_SUBDEVICE_ID;
> +	return pci_register_driver(&tpci200_pci_drv);
> +}

Can't tpci200_idtable be statically declared instead of inside the init function?

> +static void __exit tpci200_drvr_exit_module(void)
> +{
> +	struct tpci200_board *tpci200;
> +	struct list_head *element, *next;
> +
> +	list_for_each_safe(element, next, &tpci200_list) {
> +		tpci200 = list_entry(element, struct tpci200_board, list);
> +		__tpci200_pci_remove(tpci200);
> +	}

You can use list_for_each_entry_safe instead of list_for_each_safe + list_entry.
I think you've used this everywhere so this would apply to the whole patch :)

-- 
/manohar
