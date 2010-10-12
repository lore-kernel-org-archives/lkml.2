Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751904Ab0JLWZ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 18:25:29 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:46174 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401Ab0JLWZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 18:25:28 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 13 Oct 2010 00:25:13 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH unfinished update] firewire: sbp2: parallelize
 login/inquiry, reconnect, and shutdown
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
In-Reply-To: <tkrat.6dd361dadace9a41@s5r6.in-berlin.de>
Message-ID: <tkrat.b190ad8b687a549a@s5r6.in-berlin.de>
References: <tkrat.06dc43b96f9ab9bf@s5r6.in-berlin.de>
 <tkrat.1433473bc081daa9@s5r6.in-berlin.de>
 <tkrat.6dd361dadace9a41@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So I changed the patch to the simple one below, but suddenly my
> INIC-2430 device has trouble with inquiry in parallel to its two LUNs:

The following modification fixes this mostly, i.e. always when the first
Inquiry attempt to one LUN fails but succeeds on the other.  But I had
one occasion just now at which both failed; then that reschedule does
simply lead into the same situation until retry limit.

> Maybe I need ordered per-target workqueues.

No, I actually need per-node ordering.  This device, like my other one
and apparently most ones on the market actually keep their SCSI logical
units in separate FireWire units.  Currently firewire-sbp2 is not aware
that fw_unit instances reside on the same node.

This is going to be tougher than I hoped.  Maybe I need a driver-global
Inquiry mutex.  Or move the __scsi_add_device() out of sbp2_login() into
another work which is scheduled to a "single-threaded" workqueue.

--- a/drivers/firewire/sbp2.c
+++ b/drivers/firewire/sbp2.c
@@ -982,6 +982,8 @@ static void sbp2_login(struct work_struc
 	 * lu->work already.  Reset the work from reconnect to login.
 	 */
 	PREPARE_DELAYED_WORK(&lu->work, sbp2_login);
+	if (lu->retries++ < 5)
+		sbp2_queue_work(lu, DIV_ROUND_UP(HZ, 5));
  out:
 	sbp2_target_put(tgt);
 }
@@ -1656,7 +1658,8 @@ MODULE_ALIAS("sbp2");
 
 static int __init sbp2_init(void)
 {
-	sbp2_wq = create_singlethread_workqueue(KBUILD_MODNAME);
+	sbp2_wq = alloc_workqueue(KBUILD_MODNAME,
+				  WQ_NON_REENTRANT | WQ_RESCUER, 0);
 	if (!sbp2_wq)
 		return -ENOMEM;
 
-- 
Stefan Richter
-=====-==-=- =-=- -==-=
http://arcgraph.de/sr/

