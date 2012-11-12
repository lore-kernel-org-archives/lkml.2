Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025Ab2KLRzg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 12:55:36 -0500
Received: from xes-mad.com ([216.165.139.218]:40852 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753979Ab2KLRze (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 12:55:34 -0500
X-Greylist: delayed 1411 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Nov 2012 12:55:34 EST
Message-ID: <1352741475.6008.16.camel@petert>
Subject: Re: mfd: lpc_ich: NULL pointer dereference at (second) module
 removal
From: Peter Tyser <ptyser@xes-inc.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Date: Mon, 12 Nov 2012 11:31:15 -0600
In-Reply-To: <1352467148.1895.20.camel@x61.thuisdomein>
References: <1352467148.1895.20.camel@x61.thuisdomein>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for reporting the issue!

On Fri, 2012-11-09 at 14:19 +0100, Paul Bolle wrote:
> 0) I can trigger a NULL pointer dereference if I remove the lpc_ich
> module. This seems to only happen if I remove it for the second time
> (ie, remove the module, insert it and remove it again). This happens
> both on i686 and x86_64 (different setups, as inserting the module
> triggers different messages about the initialization of the MFD cells on
> these machines). Both machines are running v3.6.6.

I believe this is caused by the fact that non-MFD devices get attached
to the same parent as the iTCO_wdt driver, which is an MFD.  When the
MFD code attempts unregister the MFD drivers, it oops when the non-MFD
devices are accessed since they don't have the mfd_cell node.  I was
able to trigger the problem on the first removal of the lpc_ich driver
by doing:
$ insmod iTCO_wdt.ko
$ insmod lpc_ich.ko
$ rmmod lpc_ich


> 1) On x86_64 the Oops looks like this:
> [...]
> <6>[11783.359637] iTCO_wdt: Found a ICH8M-E TCO device (Version=2, TCOBASE=0x1060)
> <6>[11783.360477] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
> <4>[11783.360492] ACPI Warning: 0x0000000000001028-0x000000000000102f SystemIO conflicts with Region \_SB_.PCI0.LPC_.PMIO 1 (20120711/utaddress-251)
> <6>[11783.360498] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
> <4>[11783.360503] ACPI Warning: 0x0000000000001180-0x00000000000011bf SystemIO conflicts with Region \_SB_.PCI0.LPC_.LPIO 1 (20120711/utaddress-251)
> <6>[11783.360507] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
> <4>[11783.360509] lpc_ich: Resource conflict(s) found affecting gpio_ich
> [modprobe -r lcp_ich must have been done in these two seconds]
> <1>[11785.617128] BUG: unable to handle kernel NULL pointer dereference at 0000000000000010

<snip>

> 3) So to me it looks like "cell" is NULL here, and we oops when we're
> trying to access "cell->usage_count" (which will then be at offset
> 0x10). I have no idea how this can happen.

Your analysis looks correct.  This patch should fix the problem I
believe.

--- a/drivers/mfd/mfd-core.c
+++ b/drivers/mfd/mfd-core.c
@@ -208,6 +208,14 @@ static int mfd_remove_devices_fn(struct device *dev, void *c)
        const struct mfd_cell *cell = mfd_get_cell(pdev);
        atomic_t **usage_count = c;
 
+       /*
+        * Ignore non-MFD devices.  MFD and non-MFD devices can be children of
+        * the same parent in some cases.  Eg the iTCO WDT is a MFD driver, but
+        * the common WDT core and dev drivers it instantiates are not.
+        */
+       if (!cell)
+               return 0;
+
        /* find the base address of usage_count pointers (for freeing) */
        if (!*usage_count || (cell->usage_count < *usage_count))
                *usage_count = cell->usage_count;

Samuel, let me know if you have any comments on the fix, otherwise I'll
submit a proper patch shortly.

> 4) Side note: why does the kernel print offsets in hex and gdb in
> decimal? (Of course, here it's trivial to realize that 0x1d is 29.)

Note sure about that one...

Thanks for the report.

Best,
Peter


