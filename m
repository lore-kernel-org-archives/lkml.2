Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157Ab0IAB7N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 21:59:13 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:57675 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733Ab0IAB7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 21:59:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:content-transfer-encoding:user-agent;
        b=ud2nFlB0bcbAyPXXiSGZiwhY8bFjb0R7TpHAfceRCAHqlHLiyUQ8WTPaXEdz3bv7o7
         Q6vNvvLzOWhGzcHqHd1NwkvKxoVu4OXWwguWpCcUi8kBy6VTEOYOZSVNIP/4fU5bkD1x
         wXH6/u8jWIXMRZn86wQlxxdIQyp2jtKQLSWM8=
Date: Tue, 31 Aug 2010 18:59:03 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: tpmdd-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        David Safford <safford@watson.ibm.com>,
        James Morris <jmorris@namei.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [RESEND] [PATCH] TPM: change 'tpm_suspend_pcr' to be module parameter
Message-ID: <20100901015903.GA23585@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This gets rid of the following warning:

drivers/char/tpm/tpm.c:1085: warning: ‘tpm_suspend_setup’ defined but not used

and makes the workaround operable in case when TPM is compiled as a module.
As a side-effect the option will be called tpm.suspend_pcr

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/char/tpm/tpm.c |   22 ++++++++++------------
 1 files changed, 10 insertions(+), 12 deletions(-)


diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
index 05ad4a1..7c41335 100644
--- a/drivers/char/tpm/tpm.c
+++ b/drivers/char/tpm/tpm.c
@@ -47,6 +47,16 @@ enum tpm_duration {
 #define TPM_MAX_PROTECTED_ORDINAL 12
 #define TPM_PROTECTED_ORDINAL_MASK 0xFF
 
+/*
+ * Bug workaround - some TPM's don't flush the most
+ * recently changed pcr on suspend, so force the flush
+ * with an extend to the selected _unused_ non-volatile pcr.
+ */
+static int tpm_suspend_pcr;
+module_param_named(suspend_pcr, tpm_suspend_pcr, uint, 0644);
+MODULE_PARM_DESC(suspend_pcr,
+		 "PCR to use for dummy writes to faciltate flush on suspend.");
+
 static LIST_HEAD(tpm_chip_list);
 static DEFINE_SPINLOCK(driver_lock);
 static DECLARE_BITMAP(dev_mask, TPM_NUM_DEVICES);
@@ -1077,18 +1087,6 @@ static struct tpm_input_header savestate_header = {
 	.ordinal = TPM_ORD_SAVESTATE
 };
 
-/* Bug workaround - some TPM's don't flush the most
- * recently changed pcr on suspend, so force the flush
- * with an extend to the selected _unused_ non-volatile pcr.
- */
-static int tpm_suspend_pcr;
-static int __init tpm_suspend_setup(char *str)
-{
-	get_option(&str, &tpm_suspend_pcr);
-	return 1;
-}
-__setup("tpm_suspend_pcr=", tpm_suspend_setup);
-
 /*
  * We are about to suspend. Save the TPM state
  * so that it can be restored.
-- 
Dmitry
