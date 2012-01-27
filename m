Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054Ab2A0W7K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 17:59:10 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55222 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab2A0W7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 17:59:08 -0500
Date: Fri, 27 Jan 2012 14:59:07 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Philip Prindeville <philipp@redfish-solutions.com>
Cc: linux-kernel@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: Re: [PATCH 1/1] net5501: platform driver for Soekris Engineering
 net5501 single-board computer
Message-Id: <20120127145907.dfd5f8a0.akpm@linux-foundation.org>
In-Reply-To: <1325323722-25930-1-git-send-email-philipp@redfish-solutions.com>
References: <1325323722-25930-1-git-send-email-philipp@redfish-solutions.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 Dec 2011 02:28:42 -0700
Philip Prindeville <philipp@redfish-solutions.com> wrote:

> From: "Philip A. Prindeville" <philipp@redfish-solutions.com>
> 
> Trivial platform driver for Soekris Engineering net5501 single-board
> computer. Probes well-known locations in ROM for BIOS signature to
> confirm correct platform. Registers 1 LED and 1 GPIO-based button
> (typically used for soft reset).
> 
>
> ...
>
> +static int __init net5501_present(void)
> +{
> +	int i;
> +	unsigned char *rombase, *bios;
> +
> +	rombase = ioremap(BIOS_REGION_BASE, BIOS_REGION_SIZE - 1);
> +	if (!rombase)
> +		printk(KERN_INFO "Soekris net5501 LED driver failed to get rombase");

It seems wrong to continue if ioremap() failed.  It should return
-ENOMEM here.  And perhaps boost the KERN_INFO to KERN_ERR?

> +	bios = rombase + 0x20;	/* null terminated */
> +
> +	if (memcmp(bios, "comBIOS", 7))
> +		goto unmap;
> +
> +	for (i = 0; i < ARRAY_SIZE(boards); i++) {
> +		unsigned char *model = rombase + boards[i].offset;
> +
> +		if (memcmp(model, boards[i].sig, boards[i].len) == 0) {
> +			printk(KERN_INFO "Soekris %s: %s\n", model, bios);
> +
> +			register_net5501();
> +			break;
> +		}
> +	}
> +
> +unmap:
> +	iounmap(rombase);
> +	return 0;
> +}
> +
> +static int __init net5501_init(void)
> +{
> +	if (!is_geode())
> +		return 0;
> +
> +	if (net5501_present())
> +		register_net5501();

This makes no sense.  net5501_present() always returns zero so
register_net5501() is never called.  net5501_present() itself calls
register_net5501(), so perhaps this is just dead code.

It seems cleaner to me to do the register_net5501() call from
net5501_init().  A function called "foo_present()" should test for the
presence of foo (and return a bool!) - we don't expect it to run off
and register things.

I assume this code is all runtime tested?

>
> ...
>

