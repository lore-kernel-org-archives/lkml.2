Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363Ab2JOWhM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 18:37:12 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:45572 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611Ab2JOWhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 18:37:08 -0400
From: Kevin Hilman <khilman@deeprootsystems.com>
To: Tony Lindgren <tony@atomide.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Sourav <sourav.poddar@ti.com>, Paul Walmsley <paul@pwsan.com>,
        Felipe Balbi <balbi@ti.com>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, santosh.shilimkar@ti.com,
        linux-serial@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, alan@linux.intel.com
Subject: Re: [RFT/PATCH] serial: omap: prevent resume if device is not suspended.
Organization: Deep Root Systems, LLC
References: <20120925092118.GJ31374@n2100.arm.linux.org.uk>
	<CAKdam57bpTJ94Gn=mKVw1Fm-76fVPp3DGjFuNu_HfesybM1hPg@mail.gmail.com>
	<87ipas2y4h.fsf@deeprootsystems.com>
	<alpine.DEB.2.00.1210111748010.5736@utopia.booyaka.com>
	<50784458.9080806@ti.com> <877gqv7imt.fsf@deeprootsystems.com>
	<20121012164202.GQ28061@n2100.arm.linux.org.uk>
	<877gqv4lmt.fsf@deeprootsystems.com>
	<20121012185426.GS28061@n2100.arm.linux.org.uk>
	<87lifbwhwd.fsf@deeprootsystems.com>
	<20121012215156.GL30339@atomide.com>
Date: Mon, 15 Oct 2012 15:37:17 -0700
In-Reply-To: <20121012215156.GL30339@atomide.com> (Tony Lindgren's message of
	"Fri, 12 Oct 2012 14:51:56 -0700")
Message-ID: <87391fs6oy.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tony Lindgren <tony@atomide.com> writes:

> * Kevin Hilman <khilman@deeprootsystems.com> [121012 13:34]:
>>
>> I'm not conviced (yet) that a mismatch is the root cause.  Yes, that's
>> what the author of $SUBJECT patch assumed and stated, but I'm not
>> pursuaded.  
>> 
>> If it's an improperly configured mux issue, then the UART will break
>> whenever the device is actually omap_device_enable'd, whether in the
>> driver or in the bus layer.
>
> I tried booting n800 here with CONFIG_OMAP_MUX disabled, and no
> change. Serial console output stops right when the console initializes.

OK, since it's not mux, and since those who actually maintain this
driver don't seem to be taking care of this, I did some digging today.

Russell is right.  It's a mismatch between assumed runtime PM state
(disabled) and actual HW state.

During init, all omap_devices are idled by default, so that they are
correctly in the state that the runtime PM framework will later expect
them to be.  That is, all devices *except* the console UART.  For that
one, we use the special hwmod flag to not idle/reset the UART since that
will cause problems during earlyprintk usage, and the switch between
the earlyprintk console and the real console driver.

Since the console uart was left enabled during init, it needs to be
fully enabled and the runtime PM status set accordingly.

The patch below does this, and works fine on 2420/n810, as well as on
3530/Overo, 3730/OveroSTORM, 3730/Beagle-XM and 4430/PandaES.

Will send patch with a proper changelog shortly,

Kevin

diff --git a/arch/arm/mach-omap2/serial.c b/arch/arm/mach-omap2/serial.c
index 0405c81..37b5dbe 100644
--- a/arch/arm/mach-omap2/serial.c
+++ b/arch/arm/mach-omap2/serial.c
@@ -327,6 +327,11 @@ void __init omap_serial_init_port(struct omap_board_data *bdata,
 	if ((console_uart_id == bdata->id) && no_console_suspend)
 		omap_device_disable_idle_on_suspend(pdev);
 
+	if (console_uart_id == bdata->id) {
+		omap_device_enable(pdev);
+		pm_runtime_set_active(&pdev->dev);
+	}
+
 	oh->mux = omap_hwmod_mux_init(bdata->pads, bdata->pads_cnt);
 
 	oh->dev_attr = uart;
