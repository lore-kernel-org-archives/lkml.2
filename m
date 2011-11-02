Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755571Ab1KCBuu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 21:50:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51389 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934684Ab1KCBmE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:42:04 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:27:43 2011
Message-Id: <20111102222742.989627088@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:26:20 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        James Morris <jmorris@namei.org>
Subject: [036/101] TPM: Call tpm_transmit with correct size
In-Reply-To: <20111102222755.GA10893@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Peter Huewe <huewe.external.infineon@googlemail.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/tpm/tpm.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/char/tpm/tpm.c
+++ b/drivers/char/tpm/tpm.c
@@ -374,6 +374,9 @@ static ssize_t tpm_transmit(struct tpm_c
 	u32 count, ordinal;
 	unsigned long stop;
 
+	if (bufsiz > TPM_BUFSIZE)
+		bufsiz = TPM_BUFSIZE;
+
 	count = be32_to_cpu(*((__be32 *) (buf + 2)));
 	ordinal = be32_to_cpu(*((__be32 *) (buf + 6)));
 	if (count == 0)


