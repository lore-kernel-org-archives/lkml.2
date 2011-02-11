Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757638Ab1BKPpU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 10:45:20 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:42295 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757555Ab1BKPpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 10:45:15 -0500
Date: Fri, 11 Feb 2011 15:45:08 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Greg KH <greg@kroah.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH] Platform: add Samsung Laptop platform driver
Message-ID: <20110211154508.GA5435@srcf.ucam.org>
References: <20110209224006.GA11202@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110209224006.GA11202@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 09, 2011 at 02:40:06PM -0800, Greg KH wrote:

> +/* Structure to get data back to the calling function */
> +struct sabi_retval {
> +	u8 retval[20];
> +};

20 bytes, but only 4 of them end up being used?

> +	if (readb(sabi_iface + SABI_IFACE_COMPLETE) == 0xaa &&
> +	    readb(sabi_iface + SABI_IFACE_DATA) != 0xff) {
> +		/*
> +		 * It did!
> +		 * Save off the data into a structure so the caller use it.
> +		 * Right now we only care about the first 4 bytes,
> +		 * I suppose there are commands that need more, but I don't
> +		 * know about them.
> +		 */
> +		sretval->retval[0] = readb(sabi_iface + SABI_IFACE_DATA);
> +		sretval->retval[1] = readb(sabi_iface + SABI_IFACE_DATA + 1);
> +		sretval->retval[2] = readb(sabi_iface + SABI_IFACE_DATA + 2);
> +		sretval->retval[3] = readb(sabi_iface + SABI_IFACE_DATA + 3);
> +		goto exit;
> +	}

goto on success, continue failure? That's a pretty atypical pattern, and 
the goto's not even really needed in this case.

> +	/* Something bad happened, so report it and error out */
> +	printk(KERN_WARNING "SABI command 0x%02x failed with completion flag 0x%02x and output 0x%02x\n",
> +		command, readb(sabi_iface + SABI_IFACE_COMPLETE),
> +		readb(sabi_iface + SABI_IFACE_DATA));

Is it guaranteed that further reads will still return the failure state?

> +	/* see if the command actually succeeded */
> +	if (readb(sabi_iface + SABI_IFACE_COMPLETE) == 0xaa &&
> +	    readb(sabi_iface + SABI_IFACE_DATA) != 0xff) {
> +		/* it did! */
> +		goto exit;
> +	}

Ditto for this block.

> +static struct dmi_system_id __initdata samsung_dmi_table[] = {

This is kind of ugly. Are there any Samsung laptops where reading the 
bios area is going to cause problems?

> +	/* Get a pointer to the SABI Interface */
> +	ifaceP = (readw(sabi + sabi_config->header_offsets.data_segment) & 0x0ffff) << 4;
> +	ifaceP += readw(sabi + sabi_config->header_offsets.data_offset) & 0x0ffff;
> +	sabi_iface = ioremap(ifaceP, 16);
> +	if (!sabi_iface) {
> +		printk(KERN_ERR "Can't remap %x\n", ifaceP);

dev_err()? It'd be nice to have a prefix on the failure cases.

> +	retval = init_wireless(sdev);

No way to identify whether or not the hardware has wifi before 
registering rfkill?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
