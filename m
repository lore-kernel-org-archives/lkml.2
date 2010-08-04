Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756866Ab0HDWY2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 18:24:28 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:54941 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831Ab0HDWYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 18:24:21 -0400
Date: Wed, 4 Aug 2010 23:24:10 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH] RFC: AMBA bus discardable probe() function
Message-ID: <20100804222410.GB12502@n2100.arm.linux.org.uk>
References: <1280925543-6862-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280925543-6862-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 04, 2010 at 02:39:03PM +0200, Linus Walleij wrote:
> Fighting a compilation warning when using __init on probe():s in
> the AMBA (PrimeCell) bus abstraction, the intended effect of
> discarding AMBA probe():s is not achieveable without first adding
> the amba_driver_probe() function akin to platform_driver_probe().

Well, I've decided to investigate what kind of savings we're looking
at.  Going by my most recently built Realview kernel, I see in
System.map:

c01754c4 t pl061_probe
c01757b0 t pl061_irq_handler
	=> 748 bytes

c01842dc t clcdfb_probe
c0184658 t clcdfb_check_var
	=> 892 bytes

c01a3860 t pl011_probe
c01a39e4 T dev_driver_string
	=> 388 bytes

c01ee0c4 t pl030_probe
c01ee1dc t pl031_alarm_irq_enable
	=> 280 bytes

c01ee7e8 t pl031_probe
c01ee950 t pl031_interrupt
	=> 360 bytes

c02b43dc t amba_kmi_probe
c02b453c t ds1307_probe
	=> 352 bytes

c02b4b84 t mmci_probe
c02b4f74 t aaci_probe
c02b53fc t smc_drv_remove
	=> 2168 bytes

which gives a total of 5188 bytes for all the above probe functions.
However, in order to free this, we're adding 184 bytes of code and
literal pool to achieve this:

c01847b8 t amba_driver_probe_fail
c01847cc t resource_show
	=> 20 bytes

c0184e40 T amba_driver_probe
c0184ee4 W unxlate_dev_mem_ptr
	=> 164 bytes

This reduces the saving to 5004 bytes.

The overall kernel size is 3877020 bytes, which means we're potentially
allowing for 0.13% of the kernel to be freed at run time - which may
equate to one or at most two additional pages.
