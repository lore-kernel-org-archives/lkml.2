Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964983Ab1JFPjA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 11:39:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40334 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935224Ab1JFPi7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 11:38:59 -0400
Date: Thu, 6 Oct 2011 17:38:55 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>, Niels de Vos <ndevos@redhat.com>,
        Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>
Cc: Joe Krahn <krahn@niehs.nih.gov>, Andrew Morton <akpm@google.com>,
        Rich.Liu@ite.com.tw, linux-kernel@vger.kernel.org
Subject: [PATCH] parport_pc: release IO region properly if unsupported ITE887x
 card is found
Message-ID: <alpine.LNX.2.00.1110061654280.31654@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sio_ite_8872_probe() bails out if it detects no-parallel (1S, 2S) or unknown
card.

It doesn't call release_region() on the previously allocated resource though.
This causes

  (a) leak of the resource
  (b) kernel oops when parport module is removed and /proc/ioports is read. This
      is because the string that has been associated to the IO port region
      is a static char array inside the already removed module.

Let's call release_region() properly before baling out.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 drivers/parport/parport_pc.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/parport/parport_pc.c b/drivers/parport/parport_pc.c
index d1cdb94..d0b597b 100644
--- a/drivers/parport/parport_pc.c
+++ b/drivers/parport/parport_pc.c
@@ -2595,14 +2595,17 @@ static int __devinit sio_ite_8872_probe(struct pci_dev *pdev, int autoirq,
 		break;
 	case 0x6:
 		printk(KERN_INFO "parport_pc: ITE8873 found (1S)\n");
+		release_region(inta_addr[i], 32);
 		return 0;
 	case 0x8:
 		printk(KERN_INFO "parport_pc: ITE8874 found (2S)\n");
+		release_region(inta_addr[i], 32);
 		return 0;
 	default:
 		printk(KERN_INFO "parport_pc: unknown ITE887x\n");
 		printk(KERN_INFO "parport_pc: please mail 'lspci -nvv' "
 			"output to Rich.Liu@ite.com.tw\n");
+		release_region(inta_addr[i], 32);
 		return 0;
 	}
 
-- 
1.7.3.1
