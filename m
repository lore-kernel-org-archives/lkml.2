Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754415Ab0EYFMB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 01:12:01 -0400
Received: from mail-pz0-f185.google.com ([209.85.222.185]:59857 "EHLO
	mail-pz0-f185.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324Ab0EYFL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 01:11:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:content-transfer-encoding:user-agent;
        b=kqE2tKDcBOqFmCkpr1GHTTsmOOvMc959FW1P6iFa880KAlADskRVXEvVglo0PMwZpo
         i9TzhaXliu/Gls3LtTcvU/iw0V+t+dCVlQppMV7Yg98R3Iq9ZpCv454z7PUNlp7MBU5X
         +gsMvt2N3g+s4akX0jPCgpcBkWZcCf53NDNaA=
Date: Mon, 24 May 2010 22:11:53 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: tpmdd-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
       David Safford <safford@watson.ibm.com>,
       James Morris <jmorris@namei.org>
Subject: [PATCH] TPM: change 'tpm_suspend_pcr' to be module parameter
Message-ID: <20100525051153.GA21436@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-08-17)
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
