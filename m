Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935992Ab2JYQ5q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 12:57:46 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:54461 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933975Ab2JYQ53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 12:57:29 -0400
From: Brian Norris <computersforpeace@gmail.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: <linux-ide@vger.kernel.org>, <linux-pm@lists.linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Kevin Cernekee <cernekee@gmail.com>, Tejun Heo <tj@kernel.org>
Subject: [RFC 3/3] libata: don't perform HW activity in devres
Date: Thu, 25 Oct 2012 09:56:01 -0700
Message-Id: <1351184161-31433-4-git-send-email-computersforpeace@gmail.com>
X-Mailer: git-send-email 1.7.11.3
In-Reply-To: <1351184161-31433-1-git-send-email-computersforpeace@gmail.com>
References: <1351184161-31433-1-git-send-email-computersforpeace@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devres functions are intended for simplified cleanup of memory and other
software resources on device exit, not for hardware shutdown sequences.
In addition, inducing hardware activity at device removal hamstrings
some drivers (particularly ahci_platform) so that they cannot totally
power off their hardware before removal, as devres cleanup occurs after
the driver's exit() sequence.

More concretely, I experience the following bus error when using rmmod
to remove (and power off) the SATA block on my SoC:

    # rmmod ahci_platform.ko
    Data bus error, epc == e07c0ca0, ra == e07c0d24
    Oops[#1]:
    ...
    Call Trace:
    [<e07c0ca0>] ahci_stop_engine+0x28/0x84 [libahci]
    [<e07c0d24>] ahci_deinit_port+0x28/0xe8 [libahci]
    [<e07c0e08>] ahci_port_stop+0x24/0x64 [libahci]
    [<802dcc28>] ata_host_stop+0x5c/0xc0
    [<802b5390>] release_nodes+0x144/0x244
    [<802b159c>] __device_release_driver+0x68/0xcc
    [<802b1fd8>] driver_detach+0xe8/0xf0
    [<802b13e0>] bus_remove_driver+0x98/0x128
    [<8007b9e4>] sys_delete_module+0x188/0x2d4
    [<8000e6fc>] stack_done+0x20/0x40

This hardware activity pattern seems wrong.

Therefore, I move ata_host_stop() to simply be called as part of the
ata_host_detach() sequence already performed by all SATA drivers at
device exit.

Signed-off-by: Brian Norris <computersforpeace@gmail.com>
---
 drivers/ata/libata-core.c | 18 +++---------------
 1 file changed, 3 insertions(+), 15 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index d31ee55..85dee79 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5772,9 +5772,8 @@ int ata_slave_link_init(struct ata_port *ap)
 	return 0;
 }
 
-static void ata_host_stop(struct device *gendev, void *res)
+static void ata_host_stop(struct ata_host *host)
 {
-	struct ata_host *host = dev_get_drvdata(gendev);
 	int i;
 
 	WARN_ON(!(host->flags & ATA_HOST_STARTED));
@@ -5858,7 +5857,6 @@ static void ata_finalize_port_ops(struct ata_port_operations *ops)
  */
 int ata_host_start(struct ata_host *host)
 {
-	int have_stop = 0;
 	void *start_dr = NULL;
 	int i, rc;
 
@@ -5874,18 +5872,6 @@ int ata_host_start(struct ata_host *host)
 
 		if (!host->ops && !ata_port_is_dummy(ap))
 			host->ops = ap->ops;
-
-		if (ap->ops->port_stop)
-			have_stop = 1;
-	}
-
-	if (host->ops->host_stop)
-		have_stop = 1;
-
-	if (have_stop) {
-		start_dr = devres_alloc(ata_host_stop, 0, GFP_KERNEL);
-		if (!start_dr)
-			return -ENOMEM;
 	}
 
 	for (i = 0; i < host->n_ports; i++) {
@@ -6214,6 +6200,8 @@ void ata_host_detach(struct ata_host *host)
 
 	/* the host is dead now, dissociate ACPI */
 	ata_acpi_dissociate(host);
+
+	ata_host_stop(host);
 }
 
 #ifdef CONFIG_PCI
-- 
1.7.11.3

