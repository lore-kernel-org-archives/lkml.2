Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751376Ab0JLVj1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 17:39:27 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:46022 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013Ab0JLVj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 17:39:26 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 12 Oct 2010 23:39:13 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH unfinished update] firewire: sbp2: parallelize login/inquiry,
 reconnect, and shutdown
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
In-Reply-To: <tkrat.1433473bc081daa9@s5r6.in-berlin.de>
Message-ID: <tkrat.6dd361dadace9a41@s5r6.in-berlin.de>
References: <tkrat.06dc43b96f9ab9bf@s5r6.in-berlin.de>
 <tkrat.1433473bc081daa9@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So I changed the patch to the simple one below, but suddenly my
INIC-2430 device has trouble with inquiry in parallel to its two LUNs:

Oct 12 23:23:50 stein kernel: scsi22 : SBP-2 IEEE-1394
Oct 12 23:23:50 stein kernel: firewire_sbp2: Workarounds for fw7.0: 0x2 (firmware_revision 0x000241, model_id 0x000000)
Oct 12 23:23:50 stein kernel: scsi23 : SBP-2 IEEE-1394
Oct 12 23:23:50 stein kernel: firewire_sbp2: Workarounds for fw7.1: 0x2 (firmware_revision 0x000241, model_id 0x000000)
Oct 12 23:23:50 stein kernel: firewire_core: created device fw7: GUID 00027a0e440020c2, S800
Oct 12 23:23:50 stein kernel: firewire_sbp2: fw7.0: logged in to LUN 0000 (0 retries)
Oct 12 23:23:50 stein kernel: firewire_sbp2: fw7.1: logged in to LUN 0001 (0 retries)
Oct 12 23:23:52 stein kernel: scsi 23:0:0:1: CD-ROM            TEAC     DV-516GC         XT11 PQ: 0 ANSI: 0
Oct 12 23:23:52 stein kernel: sr1: scsi3-mmc drive: 48x/48x cd/rw xa/form2 cdda tray
Oct 12 23:23:52 stein kernel: sr 23:0:0:1: Attached scsi CD-ROM sr1
Oct 12 23:23:52 stein kernel: sr 23:0:0:1: Attached scsi generic sg6 type 5
Oct 12 23:23:52 stein kernel: firewire_sbp2: fw7.0: orb reply timed out, rcode=0x11

When I then force a bus reset by hardware or software, the device comes
to its senses:

Oct 12 23:24:38 stein kernel: firewire_sbp2: fw7.0: logged in to LUN 0000 (0 retries)
Oct 12 23:24:38 stein kernel: firewire_sbp2: fw7.1: reconnected to LUN 0001 (0 retries)
Oct 12 23:24:38 stein kernel: scsi 22:0:0:0: CD-ROM            TEAC     DV-516GC         XT11 PQ: 0 ANSI: 0
Oct 12 23:24:38 stein kernel: sr2: scsi3-mmc drive: 48x/48x cd/rw xa/form2 cdda tray
Oct 12 23:24:38 stein kernel: sr 22:0:0:0: Attached scsi CD-ROM sr2
Oct 12 23:24:38 stein kernel: sr 22:0:0:0: Attached scsi generic sg7 type 5

The initial Inquiry(?) timeout happens not always but quite often.  It
did not happen when I tested the earlier version of the patch in which I
used system_nrt_wq.

Maybe I need ordered per-target workqueues.  Not Signed-off-by me yet.

Tejun, can a workqueue job call destroy_workqueue on its own queue?
---
 drivers/firewire/sbp2.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: b/drivers/firewire/sbp2.c
===================================================================
--- a/drivers/firewire/sbp2.c
+++ b/drivers/firewire/sbp2.c
@@ -1656,7 +1656,8 @@ MODULE_ALIAS("sbp2");
 
 static int __init sbp2_init(void)
 {
-	sbp2_wq = create_singlethread_workqueue(KBUILD_MODNAME);
+	sbp2_wq = alloc_workqueue(KBUILD_MODNAME,
+				  WQ_NON_REENTRANT | WQ_RESCUER, 0);
 	if (!sbp2_wq)
 		return -ENOMEM;
 

-- 
Stefan Richter
-=====-==-=- =-=- -==--
http://arcgraph.de/sr/

