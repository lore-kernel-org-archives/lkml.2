Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757285Ab1COLOh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 07:14:37 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:34925 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757187Ab1COLOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 07:14:33 -0400
Message-Id: <20110315111426.773477001@linux.vnet.ibm.com>
User-Agent: quilt/0.48-1
Date: Tue, 15 Mar 2011 07:13:11 -0400
From: Stefan Berger <stefanb@linux.vnet.ibm.com>
To: debora@linux.vnet.ibm.com, srajiv@linux.vnet.ibm.com,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: jirislaby@gmail.com, preining@logic.at,
        Stefan Berger <stefanb@linux.vnet.ibm.com>
Subject: [patch 4/8] tpm_tis: Delay ACPI S3 suspend while TPM is busy
References: <20110315111307.895085413@linux.vnet.ibm.com>
Content-Disposition: inline; filename=tpm_irq_refuse_susp_while_execute.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch delays the (ACPI S3) suspend while the TPM is busy processing a
command and the TPM TIS driver is run in interrupt mode. This is the same
behavior as we already have it for the TPM TIS driver in polling mode.

Reasoning: Some of the TPM's commands advance the internal state of the TPM.
An example would be the extending of one of its PCR registers. Upper layers,
such as IMA or TSS (TrouSerS), would certainly want to be sure that the
command succeeded rather than getting an error code (-62 = -ETIME) that may
not give a conclusive answer as for what reason the command failed. Reissuing
such a command would put the TPM into the wrong state, so waiting for it to
finish is really the only option.

The downside is that some commands (key creation) can take a long time and
actually prevent the machine from entering S3 at all before the 20 second
timeout of the power management subsystem arrives.

Signed-off-by: Stefan Berger <stefanb@linux.vnet.ibm.com>

---
 drivers/char/tpm/tpm_tis.c |   28 +++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)

Index: linux-2.6/drivers/char/tpm/tpm_tis.c
===================================================================
--- linux-2.6.orig/drivers/char/tpm/tpm_tis.c
+++ linux-2.6/drivers/char/tpm/tpm_tis.c
@@ -26,6 +26,7 @@
 #include <linux/interrupt.h>
 #include <linux/wait.h>
 #include <linux/acpi.h>
+#include <linux/freezer.h>
 #include "tpm.h"
 
 #define TPM_HEADER_SIZE 10
@@ -120,7 +121,7 @@ static void release_locality(struct tpm_
 
 static int request_locality(struct tpm_chip *chip, int l)
 {
-	unsigned long stop;
+	unsigned long stop, timeout;
 	long rc;
 
 	if (check_locality(chip, l) >= 0)
@@ -129,17 +130,25 @@ static int request_locality(struct tpm_c
 	iowrite8(TPM_ACCESS_REQUEST_USE,
 		 chip->vendor.iobase + TPM_ACCESS(l));
 
+	stop = jiffies + chip->vendor.timeout_a;
+
 	if (chip->vendor.irq) {
+again:
+		timeout = stop - jiffies;
+		if ((long)timeout <= 0)
+			return -1;
 		rc = wait_event_interruptible_timeout(chip->vendor.int_queue,
 						      (check_locality
 						       (chip, l) >= 0),
-						      chip->vendor.timeout_a);
+						      timeout);
 		if (rc > 0)
 			return l;
-
+		if (rc == -ERESTARTSYS && freezing(current)) {
+			clear_thread_flag(TIF_SIGPENDING);
+			goto again;
+		}
 	} else {
 		/* wait for burstcount */
-		stop = jiffies + chip->vendor.timeout_a;
 		do {
 			if (check_locality(chip, l) >= 0)
 				return l;
@@ -196,15 +205,24 @@ static int wait_for_stat(struct tpm_chip
 	if ((status & mask) == mask)
 		return 0;
 
+	stop = jiffies + timeout;
+
 	if (chip->vendor.irq) {
+again:
+		timeout = stop - jiffies;
+		if ((long)timeout <= 0)
+			return -ETIME;
 		rc = wait_event_interruptible_timeout(*queue,
 						      ((tpm_tis_status
 							(chip) & mask) ==
 						       mask), timeout);
 		if (rc > 0)
 			return 0;
+		if (rc == -ERESTARTSYS && freezing(current)) {
+			clear_thread_flag(TIF_SIGPENDING);
+			goto again;
+		}
 	} else {
-		stop = jiffies + timeout;
 		do {
 			msleep(TPM_TIMEOUT);
 			status = tpm_tis_status(chip);

