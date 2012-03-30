Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966102Ab2C3VVp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:21:45 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40131 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966088Ab2C3VVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:21:39 -0400
Message-Id: <20120330194844.321844918@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:50:01 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Brian Norris <computersforpeace@gmail.com>,
        Jeff Garzik <jgarzik@redhat.com>
Subject: [ 096/175] ahci: add AHCI_HFLAG_DELAY_ENGINE host flag
In-Reply-To: <20120330195801.GA31806@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Norris <computersforpeace@gmail.com>

commit 66583c9fa63d05d5580e409f9a58d3cad6d76d17 upstream.

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
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/ata/ahci.h    |    3 +++
 drivers/ata/libahci.c |    5 +++++
 2 files changed, 8 insertions(+)

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
 
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -737,6 +737,7 @@ static void ahci_power_down(struct ata_p
 
 static void ahci_start_port(struct ata_port *ap)
 {
+	struct ahci_host_priv *hpriv = ap->host->private_data;
 	struct ahci_port_priv *pp = ap->private_data;
 	struct ata_link *link;
 	struct ahci_em_priv *emp;
@@ -746,6 +747,10 @@ static void ahci_start_port(struct ata_p
 	/* enable FIS reception */
 	ahci_start_fis_rx(ap);
 
+	/* enable DMA */
+	if (!(hpriv->flags & AHCI_HFLAG_DELAY_ENGINE))
+		ahci_start_engine(ap);
+
 	/* turn on LEDs */
 	if (ap->flags & ATA_FLAG_EM) {
 		ata_for_each_link(link, ap, EDGE) {


