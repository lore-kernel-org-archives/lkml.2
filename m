Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752876Ab2BDIqA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Feb 2012 03:46:00 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:29861 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139Ab2BDIp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Feb 2012 03:45:59 -0500
Date: Sat, 4 Feb 2012 09:45:43 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Aaron Sierra <asierra@xes-inc.com>
Cc: guenter roeck <guenter.roeck@ericsson.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        LKML <linux-kernel@vger.kernel.org>, Peter Tyser <ptyser@xes-inc.com>
Subject: Re: [PATCH 1/3] mfd: Add LPC driver for Intel ICH chipsets
Message-ID: <20120204094543.75e3c0b6@endymion.delvare>
In-Reply-To: <eab6c0bf-4908-454c-b7fa-606e70050793@zimbra>
References: <1328298346.2261.196.camel@groeck-laptop>
	<eab6c0bf-4908-454c-b7fa-606e70050793@zimbra>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Aaron,

On Fri, 03 Feb 2012 16:50:28 -0600 (CST), Aaron Sierra wrote:
> I received and applied your patches. I had to compile with ACPI
> disabled because 3.3-rc2 now reports a resource conflict between the
> WDAT structure (that we report for Microsoft Windows watchdog timer
> support) and the TCO watchdog portion of lpc_ich:
> 
> ACPI Warning: 0x00000460-0x0000047f SystemIO conflicts with
> Region \PMIO 1 (20120111/utaddress-251)
> ACPI: If an ACPI driver is available for this device, you should use
> it instead of the native driver
> lpc_ich: probe of 0000:00:1f.0 failed with error -16
> 
> We may have to submit a driver in the future to utilize the WDAT
> ACPI table, but that's another topic.
> 
> Do you think it's worth modifying lcp_ich to register all of the
> resources that it can and only populate the mfd_cells that have
> all of their required resources? That would prevent the entire
> driver from bombing out in situations like this. I can't imagine
> our BIOS is the only one implementing the WDAT table.

Yes, definitely. One subdevice being unavailable shouldn't have any
impact on other subdevices. The lpc_sch driver suffers from the same
issue, I had sent a patch one 10 months ago but it was never applied.
I'll update it and resend it.

To mention another ACPI resource conflict that can happen, I see the
following on my Asus Z8NA-D6:

ACPI Warning: 0x0000000000000500-0x000000000000053f SystemIO conflicts with Region \_SI_.LEDR 1 (20120111/utaddress-251)
ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
i801_gpio: probe of 0000:00:1f.0 failed with error -16

        OperationRegion (LEDR, SystemIO, 0x051A, One)
        Field (LEDR, ByteAcc, NoLock, Preserve)
        {
            LEDY,   8
        }

This is with my own GPIO driver, no MFD involved, so that's a different
problem but your driver will likely show the same. This might mean that
we have to fine-tune which I/O ports to request. In my case ACPI wants
to access only the "GPIO Blink Enable" register, which neither my
driver nor yours uses, so the conflict could be avoided.

> Anyway, after compiling without ACPI the lpc_ich driver registered
> as expected and the gpio-ich and iTCO_wdt drivers detected and
> configured their associated resources. I have verified that the
> watchdog timer still works as expected. I need to track down some
> other hardware to properly test the GPIO.

Note that for testing purpose only, it can be more convenient to boot
with acpi_enforce_resources=lax rather than rebuilding the kernel
without ACPI support.

-- 
Jean Delvare
