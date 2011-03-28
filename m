Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508Ab1C1OIx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 10:08:53 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:61935 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754439Ab1C1OIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 10:08:52 -0400
Date: Mon, 28 Mar 2011 10:08:46 -0400
From: Jeff Layton <jlayton@poochiereds.net>
To: linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net
Subject: TPM chip prevents machine from suspending
Message-ID: <20110328100846.0ba2e039@tlielax.poochiereds.net>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.3; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My wife's machine apparently has a TPM chip in it. Since I upgraded it
to Fedora 14, it fails to suspend consistently. On the first attempt to
suspend it, it works fine. Once it has woken back up however, it will
not suspend again. Here's the dmesg log from such an attempt:

[  202.460967] PM: Syncing filesystems ... done.
[  202.464818] PM: Preparing system for mem sleep
[  202.485968] Freezing user space processes ... (elapsed 0.01 seconds) done.
[  202.497079] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[  202.508067] PM: Entering mem sleep
[  202.508086] Suspending console(s) (use no_console_suspend to debug)
[  202.508451] sd 3:0:0:0: [sdb] Synchronizing SCSI cache
[  202.508562] sd 2:0:0:0: [sda] Synchronizing SCSI cache
[  202.508616] sd 3:0:0:0: [sdb] Stopping disk
[  202.511956] parport_pc 00:0b: disabled
[  202.512127] serial 00:09: disabled
[  202.512134] serial 00:09: wake-up capability disabled by ACPI
[  202.536058] legacy_suspend(): pnp_bus_suspend+0x0/0x82 returns 38
[  202.536061] PM: Device 00:02 failed to suspend: error 38
[  202.997517] sd 2:0:0:0: [sda] Stopping disk
[  202.997806] PM: Some devices failed to suspend
[  202.998085] sd 2:0:0:0: [sda] Starting disk
[  202.998144] sd 3:0:0:0: [sdb] Starting disk
[  202.998614] serial 00:09: activated
[  202.999158] parport_pc 00:0b: activated
[  204.543094] PM: resume of devices complete after 1545.282 msecs
[  204.543268] PM: Finishing wakeup.
[  204.543270] Restarting tasks ... done.

...error 38 is ENOSYS, and the 00:02 is this:

# cat /sys/bus/pnp/devices/00\:02/id 
IFX0102
PNP0c31

That appears to be an Infineon TPM chip:

# modinfo tpm_infineon
filename:       /lib/modules/2.6.38.2-8.fc15.x86_64/kernel/drivers/char/tpm/tpm_infineon.ko
license:        GPL
version:        1.9.2
description:    Driver for Infineon TPM SLD 9630 TT 1.1 / SLB 9635 TT 1.2
author:         Marcel Selhorst <m.selhorst@sirrix.com>
srcversion:     01A807F04E1D1EC617254C4
alias:          acpi*:IFX0102:*
alias:          pnp:dIFX0102*
alias:          acpi*:IFX0101:*
alias:          pnp:dIFX0101*
depends:        
vermagic:       2.6.38.2-8.fc15.x86_64 SMP mod_unload 

Perhaps it's not being reset correctly on the initial wakeup? I've seen
some other emails about similar problems that were fixed a few releases
ago, but I can reproduce the above behavior with kernels as late as
2.6.38.2. Specifically, the above log is from the most recent kernel I
could find in Fedora koji:

     2.6.38.2-8.fc15.x86_64

Let me know if you need other info or need me to test patches.

Thanks,
-- 
Jeff Layton <jlayton@poochiereds.net>
