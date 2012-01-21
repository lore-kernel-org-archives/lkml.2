Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610Ab2AUQmn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 11:42:43 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:42560 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751737Ab2AUQmk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 11:42:40 -0500
Message-ID: <1327164143.2050.9.camel@joe2Laptop>
Subject: Re: [PATCH 3/3] xgifb: checkpatch cleanup, printk() KERN_*
From: Joe Perches <joe@perches.com>
To: Sam Hansen <solid.se7en@gmail.com>
Cc: Arnaud Patard <arnaud.patard@rtp-net.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Dan Carpenter <dan.carpenter@oracle.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Sat, 21 Jan 2012 08:42:23 -0800
In-Reply-To: <1327140612-9694-3-git-send-email-solid.se7en@gmail.com>
References: <1327140612-9694-1-git-send-email-solid.se7en@gmail.com>
	 <1327140612-9694-3-git-send-email-solid.se7en@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-01-21 at 02:10 -0800, Sam Hansen wrote:
> Added KERN_ facility levels in XGI_main_26.c and vb_init.c in a few different
> printk() statements.
[]
> @@ -2018,12 +2018,12 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
>  	printk(KERN_INFO "XGIfb: MMIO at 0x%lx, mapped to 0x%p, size %ldk\n",
>  	       xgifb_info->mmio_base, xgifb_info->mmio_vbase,
>  	       xgifb_info->mmio_size / 1024);
> -	printk("XGIfb: XGIInitNew() ...");
> +	printk(KERN_INFO "XGIfb: XGIInitNew() ...");
>  	pci_set_drvdata(pdev, xgifb_info);
>  	if (XGIInitNew(pdev))
> -		printk("OK\n");
> +		printk(KERN_INFO "OK\n");
>  	else
> -		printk("Fail\n");
> +		printk(KERN_ERR "Fail\n");

These last two should be KERN_CONT
though the block could be rewritten as

	if (XGIInitNew(pdev))
		printk(KERN_INFO "XGIfb: XGIInitNew() ... OK\n");
 	else
		printk(KERN_ERR "XGIfb: XGIInitNew() ... Fail\n");

Emitting any dmesg output like "XGIInitNew() ... OK\n"
is almost always low value.

Perhaps just emitting on the error case is better:
	if (!XGIInitNew(pdev))
		printk(KERN_ERR "XGIfb: XBIInitNew() failed\n");

One other thing.  It would be better to add
#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
before any #include and convert all the
printks(KERN_<LEVEL> to pr_<level>( 
stripping all the leading XGIfb: too.


