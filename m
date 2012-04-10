Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932409Ab2DJU4E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 16:56:04 -0400
Received: from mga02.intel.com ([134.134.136.20]:54593 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759455Ab2DJUzZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 16:55:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="127468281"
Subject: [PATCH v4 3/3] serial/8250_pci: fix suspend/resume vs init/exit
 quirks
To: gregkh@linuxfoundation.org
From: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Alan Cox <alan@linux.intel.com>
Date: Tue, 10 Apr 2012 14:11:03 -0700
Message-ID: <20120410211103.13805.41517.stgit@dwillia2-linux.jf.intel.com>
In-Reply-To: <20120410210438.13805.40525.stgit@dwillia2-linux.jf.intel.com>
References: <20120410210438.13805.40525.stgit@dwillia2-linux.jf.intel.com>
User-Agent: StGit/0.16-1-g7004
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit e86ff4a6 "serial/8250_pci: init-quirk msi support for kt serial
controller" introduced a regression in suspend/resume by causing msi's
to be enabled twice without an intervening disable.

00:16.3 Serial controller: Intel Corporation Patsburg KT Controller (rev 05) (prog-if 02 [16550])
       Subsystem: Intel Corporation Device 7270
       Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 72
       I/O ports at 4080 [size=8]
       Memory at d1c30000 (32-bit, non-prefetchable) [size=4K]
       Capabilities: [c8] Power Management version 3
       Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
       Kernel driver in use: serial

[  365.250523] sysfs: cannot create duplicate filename '/devices/pci0000:00/0000:00:16.3/msi_irqs'
[  365.250525] Modules linked in: nls_utf8 ipv6 uinput sg iTCO_wdt
  iTCO_vendor_support ioatdma dca i2c_i801 i2c_core wmi sd_mod ahci libahci isci
  libsas libata scsi_transport_sas [last unloaded: scsi_wait_scan]
[  365.250540] Pid: 9030, comm: kworker/u:1 Tainted: G        W    3.3.0-isci-3.0.213+ #1
[  365.250542] Call Trace:
[  365.250545]  [<ffffffff8115e955>] ? sysfs_add_one+0x99/0xad
[  365.250548]  [<ffffffff8102db8b>] warn_slowpath_common+0x85/0x9e
[  365.250551]  [<ffffffff8102dc96>] warn_slowpath_fmt+0x6e/0x70
[  365.250555]  [<ffffffff8115e8fa>] ? sysfs_add_one+0x3e/0xad
[  365.250558]  [<ffffffff8115e8b4>] ? sysfs_pathname+0x3c/0x44
[  365.250561]  [<ffffffff8115e8b4>] ? sysfs_pathname+0x3c/0x44
[  365.250564]  [<ffffffff8115e8b4>] ? sysfs_pathname+0x3c/0x44
[  365.250567]  [<ffffffff8115e8b4>] ? sysfs_pathname+0x3c/0x44
[  365.250570]  [<ffffffff8115e955>] sysfs_add_one+0x99/0xad
[  365.250573]  [<ffffffff8115f031>] create_dir+0x72/0xa5
[  365.250577]  [<ffffffff8115f194>] sysfs_create_dir+0xa2/0xbe
[  365.250581]  [<ffffffff81262463>] kobject_add_internal+0x126/0x1f8
[  365.250585]  [<ffffffff8126255b>] kset_register+0x26/0x3f
[  365.250588]  [<ffffffff8126275a>] kset_create_and_add+0x62/0x7c
[  365.250592]  [<ffffffff81293619>] populate_msi_sysfs+0x34/0x103
[  365.250595]  [<ffffffff81293e1c>] pci_enable_msi_block+0x1b3/0x216
[  365.250599]  [<ffffffff81303f7c>] try_enable_msi+0x13/0x17
[  365.250603]  [<ffffffff81303fb3>] pciserial_resume_ports+0x21/0x42
[  365.250607]  [<ffffffff81304041>] pciserial_resume_one+0x50/0x57
[  365.250610]  [<ffffffff81283e1a>] pci_legacy_resume+0x38/0x47
[  365.250613]  [<ffffffff81283e7d>] pci_pm_restore+0x54/0x87
[  365.250616]  [<ffffffff81283e29>] ? pci_legacy_resume+0x47/0x47
[  365.250619]  [<ffffffff8131e9e8>] dpm_run_callback+0x48/0x7b
[  365.250623]  [<ffffffff8131f39a>] device_resume+0x342/0x394
[  365.250626]  [<ffffffff8131f5b7>] async_resume+0x21/0x49

That patch has since been reverted, but by inspection it seems that
pciserial_suspend_ports() should be invoking .exit() quirks to release
resources acquired during .init().

Acked-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/tty/serial/8250/8250_pci.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/tty/serial/8250/8250_pci.c b/drivers/tty/serial/8250/8250_pci.c
index 024551a..24ea98c 100644
--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -2814,6 +2814,12 @@ void pciserial_suspend_ports(struct serial_private *priv)
 	for (i = 0; i < priv->nr; i++)
 		if (priv->line[i] >= 0)
 			serial8250_suspend_port(priv->line[i]);
+
+	/*
+	 * Ensure that every init quirk is properly torn down
+	 */
+	if (priv->quirk->exit)
+		priv->quirk->exit(priv->dev);
 }
 EXPORT_SYMBOL_GPL(pciserial_suspend_ports);
 

