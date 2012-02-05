Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754290Ab2BEW0k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 17:26:40 -0500
Received: from 1wt.eu ([62.212.114.60]:61952 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754024Ab2BEW0b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 17:26:31 -0500
Message-Id: <20120205220951.290345345@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Sun, 05 Feb 2012 23:10:32 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        James Morris <jmorris@namei.org>, Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH 43/91] TPM: Call tpm_transmit with correct size
In-Reply-To: <0635750f5f06ed2ca212b91fcb5c4483@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-longterm review patch.  If anyone has any objections, please let us know.

------------------

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
 1 files changed, 3 insertions(+), 0 deletions(-)

Index: longterm-2.6.27/drivers/char/tpm/tpm.c
===================================================================
--- longterm-2.6.27.orig/drivers/char/tpm/tpm.c	2012-02-05 22:34:33.730914904 +0100
+++ longterm-2.6.27/drivers/char/tpm/tpm.c	2012-02-05 22:34:40.951915689 +0100
@@ -375,6 +375,9 @@
 	u32 count, ordinal;
 	unsigned long stop;
 
+	if (bufsiz > TPM_BUFSIZE)
+		bufsiz = TPM_BUFSIZE;
+
 	count = be32_to_cpu(*((__be32 *) (buf + 2)));
 	ordinal = be32_to_cpu(*((__be32 *) (buf + 6)));
 	if (count == 0)


