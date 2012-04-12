Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762449Ab2DLJug (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 05:50:36 -0400
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:4102 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762359Ab2DLJue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 05:50:34 -0400
X-Greylist: delayed 372 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Apr 2012 05:50:34 EDT
Message-ID: <1334223857.2439.5.camel@x61.thuisdomein>
Subject: [PATCH] [RFC] TPM: be silent if disabled or deactivated
From: Paul Bolle <pebolle@tiscali.nl>
To: Debora Velarde <debora@linux.vnet.ibm.com>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        Marcel Selhorst <m.selhorst@sirrix.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Date: Thu, 12 Apr 2012 11:44:17 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-2.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 12 Apr 2012 09:44:17.0123 (UTC) FILETIME=[D3CA7330:01CD1890]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since v3.3 the TPM security chip on a laptop I use prints two messages
at every boot and every resume:
    tpm_tis 00:0a: A TPM error (6) occurred attempting to read a pcr value
    tpm_tis 00:0a: TPM is disabled/deactivated (0x6)

The second message is just an informational message, indicating that
this chip is deactivated (0x6 is TPM_ERR_DEACTIVATED). That doesn't
bother me. The first message is printed at KERN_ERR level. To me it
seems that it is not an error if a security chip is deactivated or
disabled. So suppress that error message in those two cases.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Tested against v3.3. (This laptop is currently tracking the Fedora 16
kernel, which is now v3.3 based.) Applies cleanly to v3.4-rc2.

1) Sent as an RFC because I don't actually use any TPM functionality.
(At least, that's what I think. I'm entirely unfamiliar with TPM.)
Moreover, there are a number of code paths that hit this messages, and
for some of those this patch might hide this error where people still
would like to see it. But my usage probably doesn't trigger those code
paths.

 drivers/char/tpm/tpm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
index 32362cf..40a09b5 100644
--- a/drivers/char/tpm/tpm.c
+++ b/drivers/char/tpm/tpm.c
@@ -473,7 +473,7 @@ static ssize_t transmit_cmd(struct tpm_chip *chip, struct tpm_cmd_t *cmd,
 		return -EFAULT;
 
 	err = be32_to_cpu(cmd->header.out.return_code);
-	if (err != 0)
+	if (err != 0 && err != TPM_ERR_DISABLED && err != TPM_ERR_DEACTIVATED)
 		dev_err(chip->dev, "A TPM error (%d) occurred %s\n", err, desc);
 
 	return err;
-- 
1.7.7.6

