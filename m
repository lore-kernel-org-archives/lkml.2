Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965886Ab2FBV0V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2012 17:26:21 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:47399 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965826Ab2FBV0T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2012 17:26:19 -0400
Message-ID: <1338672377.24148.6.camel@joe2Laptop>
Subject: Re: [PATCH] ide: icside.c: fix printk format string compile warning
From: Joe Perches <joe@perches.com>
To: Christian Dietrich <christian.dietrich@informatik.uni-erlangen.de>
Cc: Sergei Shtylyov <sshtylyov@mvista.com>,
        "David S. Miller" <davem@davemloft.net>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, vamos-dev@lists.cs.fau.de
Date: Sat, 02 Jun 2012 14:26:17 -0700
In-Reply-To: <86hauw7jee.fsf_-_@gandalf.zerties.org>
References: <20120529103002.GA13283@faui49q.informatik.uni-erlangen.de>
	 <4FC4C391.50700@mvista.com> <86hauw7jee.fsf_-_@gandalf.zerties.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-31 at 12:08 +0200, Christian Dietrich wrote:
> Peak datarate is never bigger than an integer, and can therefore, as
> suggested in the printk format string, casted to an integer.
> ---
>  drivers/ide/icside.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/ide/icside.c b/drivers/ide/icside.c
> index 83e5100..755ef6b 100644
> --- a/drivers/ide/icside.c
> +++ b/drivers/ide/icside.c
> @@ -271,9 +271,9 @@ static void icside_set_dma_mode(ide_hwif_t *hwif, ide_drive_t *drive)
>  
>  	ide_set_drivedata(drive, (void *)cycle_time);
>  
> -	printk("%s: %s selected (peak %dMB/s)\n", drive->name,
> -		ide_xfer_verbose(xfer_mode),
> -		2000 / (unsigned long)ide_get_drivedata(drive));
> +	printk(KERN_INFO "%s: %s selected (peak %dMB/s)\n", drive->name,
> +	       ide_xfer_verbose(xfer_mode),
> +	       (int) (2000 / (unsigned long)ide_get_drivedata(drive)));

Why do an unsigned long int divide then cast
the result at all?  Why not just
do a divide without the cast?

Using ide_get_drivedata is rather odd too as it would be
more readable as without the set/get and just use:

	printk(KERN_IFNO "%s: %s selected (peak %luMB/s)\n",
	       drive->name, ide_xfer_verbose(xfer_mode),
	       2000UL / cycle_time);

	ide_set_drivedata(drive, (void *)cycle_time);

without the additional get.

Also, cycle_time _could_ be used uninitialized
if somehow an xfer_mode switch/case isn't reached.

