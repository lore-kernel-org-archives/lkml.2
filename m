Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759502Ab1FAU33 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 16:29:29 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:50373 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753845Ab1FAU31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 16:29:27 -0400
Date: Wed, 1 Jun 2011 16:29:26 -0400
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: linux-serial@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: ioremap warning fix for jsm driver.
Message-ID: <20110601202926.GK21345@caffeine.csclub.uwaterloo.ca>
References: <20110601183841.GJ21345@caffeine.csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110601183841.GJ21345@caffeine.csclub.uwaterloo.ca>
User-Agent: Mutt/1.5.20 (2009-06-14)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 01, 2011 at 02:38:41PM -0400, Lennart Sorensen wrote:
> I saw a warning about ioremap from the jsm driver on a system which
> looked like this:
> 
> resource map sanity check conflict: 0xe0200800 0xe02017ff 0xe0200800 0xe0200fff 0000:01:08.0
> 
> Turns out the warning is valid.  The jsm driver has been asking to ioremap
> 0x1000 forever, but in fact only 8 port chips have 0x1000 bytes of memory.
> 4 port chips have 0x800 and 2 port chips have 0x400 according to the
> data sheet.  It makes more sense to map the size of the region rather
> than a hard coded value.  If you happen to have the regiong legitimately
> mapped to a base addres that is not 4K aligned, ioremap complains
> otherwise.

I can't believe I didn't spell check that. :(

Should have been:

Turns out the warning is valid.  The jsm driver has been asking to ioremap
0x1000 forever, but in fact only 8 port chips have 0x1000 bytes of memory.
4 port chips have 0x800 and 2 port chips have 0x400 according to the
data sheet.  It makes more sense to map the size of the region rather
than a hard coded value.  If you happen to have the region legitimately
mapped to a base address that is not 4K aligned ioremap complains, and
otherwise memory not belonging to the device is reserved as far as I
can tell.

> Signed-off-by: Len Sorensen <lsorense@csclub.uwaterloo.ca>
> 
> 
> diff --git a/drivers/tty/serial/jsm/jsm_driver.c b/drivers/tty/serial/jsm/jsm_driver.c
> index 18f5484..96da178 100644
> --- a/drivers/tty/serial/jsm/jsm_driver.c
> +++ b/drivers/tty/serial/jsm/jsm_driver.c
> @@ -125,7 +125,7 @@ static int __devinit jsm_probe_one(struct pci_dev *pdev, const struct pci_device
>  	brd->bd_uart_offset = 0x200;
>  	brd->bd_dividend = 921600;
>  
> -	brd->re_map_membase = ioremap(brd->membase, 0x1000);
> +	brd->re_map_membase = ioremap(brd->membase, pci_resource_len(pdev, 0));
>  	if (!brd->re_map_membase) {
>  		dev_err(&pdev->dev,
>  			"card has no PCI Memory resources, "
> 
> 
> -- 
> Len Sorensen
