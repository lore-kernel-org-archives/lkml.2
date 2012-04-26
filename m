Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757304Ab2DZTPR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 15:15:17 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:35154 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598Ab2DZTPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 15:15:15 -0400
MIME-Version: 1.0
Date: Thu, 26 Apr 2012 13:15:14 -0600
X-Google-Sender-Auth: xCFznIvFs460QXPhcZaoFZsuZKU
Message-ID: <CAMLZHHTM6fojwcPAeyL07hz9U=7uNnxnwxm4kWY_-ffOtHm=vQ@mail.gmail.com>
Subject: Hang while loading firmware when going into suspend
From: Daniel Drake <dsd@laptop.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM list <linux-pm@vger.kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I can easily reproduce a hang related to loading firmware
(asynchronously) while going into suspend.

This is running on kernel 3.3.3.

I run:

echo mem > /sys/power/state; echo mem > /sys/power/state

i.e. I tell the system to suspend, and when I wake it up it will go
very quickly into suspend again.

After waking up, it will start to re-detect the libertas SDIO wifi
card which was completely powered down during suspend.
This triggers a firmware loading sequence.
However, the system then immediately goes into suspend, and at this
point the system becomes unhappy.

Here are the logs from the first wakeup into the second suspend,
including DEBUG enabled in firmware_class.c

[   49.389773] Restarting tasks ...
[   49.404539] olpc-dcon: The CPU has control
[   49.419371] done.
[   49.440444] PM: Syncing filesystems ...
[   49.505994] sdhci-pci 0000:00:0c.0: setting latency timer to 64
[   49.540921] done.
[   49.542865] PM: Preparing system for mem sleep
[   49.577882] sdhci-pci 0000:00:0c.0: setting latency timer to 64
[   49.654932] sdhci-pci 0000:00:0c.0: setting latency timer to 64
[   49.753343] sdhci-pci 0000:00:0c.0: setting latency timer to 64
[   49.890879] mmc1: new SDIO card at address 0001
[   49.914515] libertas_sdio: get async now
[   49.918506] Requesting libertas/sd8686_v9_helper.bin
[   49.940231] libertas_sdio mmc1:0001:1: firmware: requesting
libertas/sd8686_v9_helper.bin
[   49.961299] helper_firmware_cb   (null)
[   49.965200] Requesting libertas/sd8686_v8_helper.bin
[   49.970283] Freezing user space processes ... (elapsed 0.11 seconds) done.
[   50.092922] Freezing remaining freezable tasks ... (elapsed 0.01
seconds) done.
[   50.112828] PM: Entering mem sleep
[   50.116749] dcon_source_switch to DCON
[   50.142874] olpc-dcon: The DCON has control
[   50.147634] i8042 kbd 00:04: wake-up capability enabled by ACPI
[   50.153871] i8042 aux 00:03: wake-up capability disabled by ACPI
[   50.160268] sdhci-pci 0000:00:0c.0: setting latency timer to 64
[   50.167265] libertas_sdio mmc1:0001:1: mmc1:0001:1: suspend: PM flags = 0x3
[   50.174370] viafb_suspend!
[  109.980122] libertas_sdio mmc1:0001:1: firmware:
libertas/sd8686_v8_helper.bin loading timed out
[  109.989070] helper_firmware_cb   (null)
[  109.992952] Requesting sd8686_helper.bin
[  169.990109] libertas_sdio mmc1:0001:1: firmware: sd8686_helper.bin
loading timed out
[  169.997960] helper_firmware_cb   (null)
[  170.001859] libertas_sdio: sdio got firmware -2   (null)   (null)
[  170.008047] libertas_sdio: failed to find firmware (-2)
[  170.013351] libertas: INIT FAILED
[  170.016719] libertas: ret new state 2
[  170.020781] mmc1: card 0001 removed
[  170.024397] sdhci-pci 0000:00:0c.0: setting latency timer to 64
[  170.031423] sdhci-pci 0000:00:0c.0: setting latency timer to 64
[  170.038496] sdhci-pci 0000:00:0c.0: setting latency timer to 64
[  170.060137] PM: suspend of devices complete after 119943.496 msecs

Some weird things here:

Early during the routine, we request a firmware that cannot be found:

[   49.918506] Requesting libertas/sd8686_v9_helper.bin
[   49.940231] libertas_sdio mmc1:0001:1: firmware: requesting
libertas/sd8686_v9_helper.bin
[   49.961299] helper_firmware_cb   (null)

(The first and last lines are debug output from my driver, line 2
comes from firmware_class)

Then when we try to find a different firmware file, we don't get the
firmware_class debug line that we saw above, only my driver debug:
[   49.965200] Requesting libertas/sd8686_v8_helper.bin
[   49.970283] Freezing user space processes ... (elapsed 0.11 seconds) done.

Eventually we get a timeout, then we request another firmware, which
also times out, and finally we fall into suspend after a long delay.


Sidenote:
There is a driver race in the current libertas code - in the above
situation it will attempt to call the driver suspend routine even if
probe hasn't finished (i.e. async firmware loading still underway). I
have that solved locally in the tests above - the suspend routine will
detect that probing/firmware loading is still ongoing and wait for
that to complete before asking the hardware to suspend. However, in
testing this change, I am facing the above issue with the firmware
loader behaving badly when going into suspend.

Thanks
Daniel
