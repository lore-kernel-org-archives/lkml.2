Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933428Ab1I1Wt3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:49:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54925 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933411Ab1I1WtZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:49:25 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:45 2011
Message-Id: <20110928220145.593287383@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:02:36 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        James Morris <jmorris@namei.org>
Subject: [192/244] TPM: Call tpm_transmit with correct size
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

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
@@ -383,6 +383,9 @@ static ssize_t tpm_transmit(struct tpm_c
 	u32 count, ordinal;
 	unsigned long stop;
 
+	if (bufsiz > TPM_BUFSIZE)
+		bufsiz = TPM_BUFSIZE;
+
 	count = be32_to_cpu(*((__be32 *) (buf + 2)));
 	ordinal = be32_to_cpu(*((__be32 *) (buf + 6)));
 	if (count == 0)


