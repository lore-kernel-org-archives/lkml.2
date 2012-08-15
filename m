Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756707Ab2HOU3Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 16:29:25 -0400
Received: from mail.windriver.com ([147.11.1.11]:36666 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756244Ab2HOTuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:50:03 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Peter Huewe <huewe.external.infineon@googlemail.com>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        James Morris <jmorris@namei.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 049/165] TPM: Call tpm_transmit with correct size
Date: Wed, 15 Aug 2012 15:46:33 -0400
Message-ID: <1345060109-9187-50-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Huewe <huewe.external.infineon@googlemail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 6b07d30aca7e52f2881b8c8c20c8a2cd28e8b3d3 upstream.

This patch changes the call of tpm_transmit by supplying the size of the
userspace buffer instead of TPM_BUFSIZE.

This got assigned CVE-2011-1161.

[The first hunk didn't make sense given one could expect
 way less data than TPM_BUFSIZE, so added tpm_transmit boundary
 check over bufsiz instead
 The last parameter of tpm_transmit() reflects the amount
 of data expected from the device, and not the buffer size
 being supplied to it. It isn't ideal to parse it directly,
 so we just set it to the maximum the input buffer can handle
 and let the userspace API to do such job.]

Signed-off-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Signed-off-by: James Morris <jmorris@namei.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/char/tpm/tpm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
index 7f95fec..f39e5ee 100644
--- a/drivers/char/tpm/tpm.c
+++ b/drivers/char/tpm/tpm.c
@@ -375,6 +375,9 @@ static ssize_t tpm_transmit(struct tpm_chip *chip, const char *buf,
 	u32 count, ordinal;
 	unsigned long stop;
 
+	if (bufsiz > TPM_BUFSIZE)
+		bufsiz = TPM_BUFSIZE;
+
 	count = be32_to_cpu(*((__be32 *) (buf + 2)));
 	ordinal = be32_to_cpu(*((__be32 *) (buf + 6)));
 	if (count == 0)
-- 
1.7.12.rc2

