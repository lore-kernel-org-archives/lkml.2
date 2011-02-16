Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932496Ab1BPAfH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:35:07 -0500
Received: from kroah.org ([198.145.64.141]:49681 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932332Ab1BPAY1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:24:27 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:47 2011
Message-Id: <20110216001447.619414869@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:14:42 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        James Morris <jmorris@namei.org>
Subject: [225/272] TPM: Long default timeout fix
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

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

---
 drivers/char/tpm/tpm.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/char/tpm/tpm.c
+++ b/drivers/char/tpm/tpm.c
@@ -364,12 +364,14 @@ unsigned long tpm_calc_ordinal_duration(
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
 


