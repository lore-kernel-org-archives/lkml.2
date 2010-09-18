Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757410Ab0IRT1t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:27:49 -0400
Received: from kroah.org ([198.145.64.141]:43575 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756926Ab0IRTPd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:15:33 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:13:03 2010
Message-Id: <20100918191303.443273257@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 12:12:49 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jeff Garzik <jgarzik@redhat.com>
Subject: [071/129] libata,pata_via: revert ata_wait_idle() removal from ata_sff/via_tf_load()
In-Reply-To: <20100918191317.GA11386@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tejun Heo <teheo@novell.com>

commit 40c6023031369ae5573e622ca54fa3ffe89fb865 upstream.

Commit 978c0666 (libata: Remove excess delay in the tf_load path)
removed ata_wait_idle() from ata_sff_tf_load() and via_tf_load().
This caused obscure detection problems in sata_sil.

  https://bugzilla.kernel.org/show_bug.cgi?id=16606

The commit was pure performance optimization.  Revert it for now.

Reported-by: Dieter Plaetinck <dieter@plaetinck.be>
Reported-by: Jan Beulich <JBeulich@novell.com>
Bisected-by: gianluca <gianluca@sottospazio.it>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/libata-sff.c |    3 +++
 drivers/ata/pata_via.c   |    2 ++
 2 files changed, 5 insertions(+)

--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -418,6 +418,7 @@ void ata_sff_tf_load(struct ata_port *ap
 		if (ioaddr->ctl_addr)
 			iowrite8(tf->ctl, ioaddr->ctl_addr);
 		ap->last_ctl = tf->ctl;
+		ata_wait_idle(ap);
 	}
 
 	if (is_addr && (tf->flags & ATA_TFLAG_LBA48)) {
@@ -453,6 +454,8 @@ void ata_sff_tf_load(struct ata_port *ap
 		iowrite8(tf->device, ioaddr->device_addr);
 		VPRINTK("device 0x%X\n", tf->device);
 	}
+
+	ata_wait_idle(ap);
 }
 EXPORT_SYMBOL_GPL(ata_sff_tf_load);
 
--- a/drivers/ata/pata_via.c
+++ b/drivers/ata/pata_via.c
@@ -417,6 +417,8 @@ static void via_tf_load(struct ata_port
 			tf->lbam,
 			tf->lbah);
 	}
+
+	ata_wait_idle(ap);
 }
 
 static int via_port_start(struct ata_port *ap)


