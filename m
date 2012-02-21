Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497Ab2BUSip (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 13:38:45 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:42881 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755089Ab2BUSil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 13:38:41 -0500
From: Brian Norris <computersforpeace@gmail.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: <linux-ide@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Brian Norris <computersforpeace@gmail.com>,
        Lin Ming <ming.m.lin@intel.com>, Norbert Preining <preining@logic.at>,
        "Srivatsa S . Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Valdis Kletnieks <valdis.kletnieks@vt.edu>,
        "Rafael J . Wysocki" <rjw@sisk.pl>
Subject: [PATCH v2 1/3] ahci: add AHCI_HFLAG_DELAY_ENGINE host flag
Date: Tue, 21 Feb 2012 10:38:42 -0800
Message-Id: <1329849524-23758-2-git-send-email-computersforpeace@gmail.com>
X-Mailer: git-send-email 1.7.5.4.2.g519b1
In-Reply-To: <1329849524-23758-1-git-send-email-computersforpeace@gmail.com>
References: <1329849524-23758-1-git-send-email-computersforpeace@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following commit was intended to fix problems with specific AHCI
controller(s) that would become bricks if the AHCI specification was not
followed strictly (that is, if ahci_start_engine() was called while the
controller was in the wrong state):

    commit 7faa33da9b7add01db9f1ad92c6a5d9145e940a7
    ahci: start engine only during soft/hard resets

However, some devices currently have issues with that fix, so we must
implement a flag that delays the ahci_start_engine() call only for specific
controllers.

This commit simply introduces the flag, without enabling it in any driver.

Note that even when AHCI_HFLAG_DELAY_ENGINE is not enabled, this patch does
not constitue a full revert to commit 7faa33da; there is still a change in
behavior to the ahci_port_suspend() failure path.

Signed-off-by: Brian Norris <computersforpeace@gmail.com>
---
 drivers/ata/ahci.h    |    3 +++
 drivers/ata/libahci.c |    5 +++++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
index b175000..feb127e 100644
--- a/drivers/ata/ahci.h
+++ b/drivers/ata/ahci.h
@@ -210,6 +210,9 @@ enum {
 	AHCI_HFLAG_NO_SNTF		= (1 << 12), /* no sntf */
 	AHCI_HFLAG_NO_FPDMA_AA		= (1 << 13), /* no FPDMA AA */
 	AHCI_HFLAG_YES_FBS		= (1 << 14), /* force FBS cap on */
+	AHCI_HFLAG_DELAY_ENGINE		= (1 << 15), /* do not start engine on
+						        port start (wait until
+						        error-handling stage) */
 
 	/* ap->flags bits */
 
diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index a72bfd0..f9eaa82 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -737,6 +737,7 @@ static void ahci_power_down(struct ata_port *ap)
 
 static void ahci_start_port(struct ata_port *ap)
 {
+	struct ahci_host_priv *hpriv = ap->host->private_data;
 	struct ahci_port_priv *pp = ap->private_data;
 	struct ata_link *link;
 	struct ahci_em_priv *emp;
@@ -746,6 +747,10 @@ static void ahci_start_port(struct ata_port *ap)
 	/* enable FIS reception */
 	ahci_start_fis_rx(ap);
 
+	/* enable DMA */
+	if (!(hpriv->flags & AHCI_HFLAG_DELAY_ENGINE))
+		ahci_start_engine(ap);
+
 	/* turn on LEDs */
 	if (ap->flags & ATA_FLAG_EM) {
 		ata_for_each_link(link, ap, EDGE) {
