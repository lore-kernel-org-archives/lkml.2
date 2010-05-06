Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645Ab0EFTPi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 15:15:38 -0400
Received: from imap.ru.mvista.com ([213.79.90.228]:57654 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752824Ab0EFTPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 15:15:36 -0400
Date: Thu, 6 May 2010 23:15:32 +0400
From: Anton Vorontsov <avorontsov@mvista.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Sebastian Siewior <bigeasy@linutronix.de>,
       Catalin Marinas <catalin.marinas@arm.com>,
       Bryan Wu <cooloney@kernel.org>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] USB: isp1760: Soften DW3 X/transaction error bit handling
Message-ID: <20100506191532.GA11365@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There were some reports[1] of isp1760 USB driver malfunctioning
with high speed devices, noticed on Blackfin and PowerPC targets.
These reports indicated that the original Philips 'pehcd'[2]
driver worked fine.

We've noticed the same issue with an ARM RealView platform. This
happens under load (with only some mass storage devices, not all,
just as in another report[3]):

  error bit is set in DW3
  error bit is set in DW3
  error bit is set in DW3
  usb 1-1.2: device descriptor read/64, error -32

It appears that the 'pehcd' driver checks the X bit only if the
transaction is halted, otherwise the error is so far
insignificant.

I didn't find where exactly ISP1760 spec mandates 'H && X'
handling (maybe it's in the EHCI spec?), but the approach that
is used in the original driver (and in the EHCI driver, FWIW)
fixes the issue.

[1] http://markmail.org/message/lx4qrlbrs2uhcnly
[2] svn co svn://sources.blackfin.uclinux.org/linux-kernel/trunk/drivers/usb/host -r 5494
    See pehci.c:pehci_hcd_update_error_status().
[3] http://blackfin.uclinux.org/gf/project/uclinux-dist/tracker/?action=TrackerItemEdit&tracker_item_id=5148

Signed-off-by: Anton Vorontsov <avorontsov@mvista.com>
---

Note that this isn't related to the recent cache issues on ARM
platforms, as the kernel I'm running has commit 3f54ccf38eb51
'isp1760: Flush the D-cache for the pipe-in transfer buffers'.

 drivers/usb/host/isp1760-hcd.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/host/isp1760-hcd.c b/drivers/usb/host/isp1760-hcd.c
index 9f01293..9989c0b 100644
--- a/drivers/usb/host/isp1760-hcd.c
+++ b/drivers/usb/host/isp1760-hcd.c
@@ -713,12 +713,11 @@ static int check_error(struct ptd *ptd)
 	u32 dw3;
 
 	dw3 = le32_to_cpu(ptd->dw3);
-	if (dw3 & DW3_HALT_BIT)
+	if (dw3 & DW3_HALT_BIT) {
 		error = -EPIPE;
 
-	if (dw3 & DW3_ERROR_BIT) {
-		printk(KERN_ERR "error bit is set in DW3\n");
-		error = -EPIPE;
+		if (dw3 & DW3_ERROR_BIT)
+			pr_err("error bit is set in DW3\n");
 	}
 
 	if (dw3 & DW3_QTD_ACTIVE) {
-- 
1.7.0.5
