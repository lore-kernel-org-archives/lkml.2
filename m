Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752012Ab0GIFr5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 01:47:57 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:42931 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171Ab0GIFr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 01:47:56 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH -mmotm] 8250_early: fix printk format warnings
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Samium Gromoff <_deepfire@feelingofgreen.ru>,
       Greg KH <greg@kroah.com>
In-Reply-To: <20100702182437.977c8ef8.randy.dunlap@oracle.com>
References: <201007011948.o61JmnT2022795@imap1.linux-foundation.org> <20100702182437.977c8ef8.randy.dunlap@oracle.com>
Message-Id: <20100709144148.3D25.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri,  9 Jul 2010 14:47:52 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix printk format warnings in serial-mmio32-support-for-8250_earlyc.patch:
> 
> drivers/serial/8250_early.c:207: warning: format '%p' expects type 'void *', but argument 3 has type 'long long unsigned int'
> drivers/serial/8250_early.c:210: warning: format '%p' expects type 'void *', but argument 2 has type 'long long unsigned int'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: Samium Gromoff <_deepfire@feelingofgreen.ru>
> Cc: Greg KH <greg@kroah.com>
> ---
>  drivers/serial/8250_early.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> --- mmotm-2010-0701-1219.orig/drivers/serial/8250_early.c
> +++ mmotm-2010-0701-1219/drivers/serial/8250_early.c
> @@ -202,12 +202,12 @@ static int __init parse_options(struct e
>  	}
>  
>  	if (mmio || mmio32)
> -		printk(KERN_INFO "Early serial console at MMIO%s 0x%p (options '%s')\n",
> +		printk(KERN_INFO "Early serial console at MMIO%s 0x%llu (options '%s')\n",
>  		       mmio32 ? "32" : "", (unsigned long long) port->mapbase,
>  		       device->options);
>  	else
>  		printk(KERN_INFO "Early serial console at I/O port 0x%pr (options '%s')\n",
> -		       (unsigned long long) port->iobase, device->options);
> +		       (void *) port->iobase, device->options);

seems still odd.

%pr don't mean bare pointer. it want resource. another %pr use case is here.

drivers/pnp/resoruce.c
======================================================================
struct pnp_resource *pnp_add_dma_resource(struct pnp_dev *dev, int dma,
                                          int flags)
{
        struct pnp_resource *pnp_res;
        struct resource *res;
(snip)
        pnp_dbg(&dev->dev, "  add %pr\n", res);
======================================================================

and port->iobase is merely unsingned long.
I guess following change or something like are necessary.

-               printk(KERN_INFO "Early serial console at I/O port 0x%pr (options '%s')\n",
-                      (unsigned long long) port->iobase, device->options);
+               printk(KERN_INFO "Early serial console at I/O port %lu (options '%s')\n",
+                      port->iobase, device->options);


Thanks.


