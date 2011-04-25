Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756323Ab1DYUXo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:23:44 -0400
Received: from 1wt.eu ([62.212.114.60]:33792 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756173Ab1DYUXj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:23:39 -0400
Message-Id: <20110425200234.296302023@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:03:02 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        James Morris <jmorris@namei.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 030/173] TPM: Long default timeout fix
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

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
@@ -353,12 +353,14 @@ unsigned long tpm_calc_ordinal_duration(
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
 


