Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933405Ab1C3V5r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:57:47 -0400
Received: from mga09.intel.com ([134.134.136.24]:13486 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933320Ab1C3VGv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:06:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="727133018"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: srajiv@linux.vnet.ibm.com, jmorris@namei.org, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [72/275] TPM: Long default timeout fix
Message-Id: <20110330210509.7C5C43E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:05:09 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>

commit c4ff4b829ef9e6353c0b133b7adb564a68054979 upstream.

If duration variable value is 0 at this point, it's because
chip->vendor.duration wasn't filled by tpm_get_timeouts() yet.
This patch sets then the lowest timeout just to give enough
time for tpm_get_timeouts() to further succeed.

This fix avoids long boot times in case another entity attempts
to send commands to the TPM when the TPM isn't accessible.

Signed-off-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Signed-off-by: James Morris <jmorris@namei.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/char/tpm/tpm.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

Index: linux-2.6.35.y/drivers/char/tpm/tpm.c
===================================================================
--- linux-2.6.35.y.orig/drivers/char/tpm/tpm.c	2011-03-29 22:51:41.259667437 -0700
+++ linux-2.6.35.y/drivers/char/tpm/tpm.c	2011-03-29 23:55:12.337151500 -0700
@@ -354,12 +354,14 @@
 		    tpm_protected_ordinal_duration[ordinal &
 						   TPM_PROTECTED_ORDINAL_MASK];
 
-	if (duration_idx != TPM_UNDEFINED)
+	if (duration_idx != TPM_UNDEFINED) {
 		duration = chip->vendor.duration[duration_idx];
-	if (duration <= 0)
+		/* if duration is 0, it's because chip->vendor.duration wasn't */
+		/* filled yet, so we set the lowest timeout just to give enough */
+		/* time for tpm_get_timeouts() to succeed */
+		return (duration <= 0 ? HZ : duration);
+	} else
 		return 2 * 60 * HZ;
-	else
-		return duration;
 }
 EXPORT_SYMBOL_GPL(tpm_calc_ordinal_duration);
 
