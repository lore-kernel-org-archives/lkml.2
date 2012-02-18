Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551Ab2BRVB0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Feb 2012 16:01:26 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:52748 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799Ab2BRVBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Feb 2012 16:01:24 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 18 Feb 2012 22:01:14 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: linux1394-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] firewire: sbp2: identify to driver core as
 "firewire_sbp2", not "sbp2"
Message-ID: <20120218220114.0ab054d6@stein>
In-Reply-To: <20120218215824.5b2359bf@stein>
References: <20120218215824.5b2359bf@stein>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.5; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit eba9ebaaa26d "firewire: sbp2: use dev_printk API" changed
messages from e.g.
    firewire_sbp2: fw3.0: logged in to LUN 0000 (0 retries)
to
    sbp2 fw3.0: logged in to LUN 0000 (0 retries)
because the driver calls itself as "sbp2" when registering with driver
core and with SCSI core.  This is of course confusing, so switch to the
name "firewire_sbp2" for driver core in order to match what lsmod and
/sys/module/ show.  So we are back to
    firewire_sbp2 fw3.0: logged in to LUN 0000 (0 retries)
in the kernel log.

This also changes
    /sys/bus/firewire/drivers/sbp2
    /sys/bus/firewire/devices/fw3.0/driver -> [...]/sbp2
    /sys/module/firewire_sbp2/drivers/firewire:sbp2
to
    /sys/bus/firewire/drivers/firewire_sbp2
    /sys/bus/firewire/devices/fw3.0/driver -> [...]/firewire_sbp2
    /sys/module/firewire_sbp2/drivers/firewire:firewire_sbp2

but "cat /sys/class/scsi_host/host27/proc_name" stays "sbp2" just in
case that proc_name is used by any userland.

The transport detection in lsscsi is not affected.  (Tested with lsscsi
version 0.25.)  Udev's /dev/disk/by-id and by-path symlinks are not
affected either.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/sbp2.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/firewire/sbp2.c
+++ b/drivers/firewire/sbp2.c
@@ -125,8 +125,6 @@ MODULE_PARM_DESC(workarounds, "Work arou
 	", override internal blacklist = " __stringify(SBP2_WORKAROUND_OVERRIDE)
 	", or a combination)");
 
-static const char sbp2_driver_name[] = "sbp2";
-
 /*
  * We create one struct sbp2_logical_unit per SBP-2 Logical Unit Number Entry
  * and one struct scsi_device per sbp2_logical_unit.
@@ -1270,7 +1268,7 @@ static const struct ieee1394_device_id s
 static struct fw_driver sbp2_driver = {
 	.driver   = {
 		.owner  = THIS_MODULE,
-		.name   = sbp2_driver_name,
+		.name   = KBUILD_MODNAME,
 		.bus    = &fw_bus_type,
 		.probe  = sbp2_probe,
 		.remove = sbp2_remove,
@@ -1599,7 +1597,7 @@ static struct device_attribute *sbp2_scs
 static struct scsi_host_template scsi_driver_template = {
 	.module			= THIS_MODULE,
 	.name			= "SBP-2 IEEE-1394",
-	.proc_name		= sbp2_driver_name,
+	.proc_name		= "sbp2",
 	.queuecommand		= sbp2_scsi_queuecommand,
 	.slave_alloc		= sbp2_scsi_slave_alloc,
 	.slave_configure	= sbp2_scsi_slave_configure,


-- 
Stefan Richter
-=====-===-- --=- =--=-
http://arcgraph.de/sr/
