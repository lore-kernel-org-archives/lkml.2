Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031722Ab2I1Twh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:52:37 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:51579 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964973Ab2I1S5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 14:57:41 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 088/262] digsig: add hash size comparision on signature verification
Date: Fri, 28 Sep 2012 11:50:17 -0700
Message-Id: <20120928183008.508046719@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Kasatkin <dmitry.kasatkin@intel.com>

commit bc01637a80f5b670bd70a0279d3f93fa8de1c96d upstream.

When pkcs_1_v1_5_decode_emsa() returns without error and hash sizes do
not match, hash comparision is not done and digsig_verify_rsa() returns
no error.  This is a bug and this patch fixes it.

The bug was introduced in v3.3 by commit b35e286a640f ("lib/digsig:
pkcs_1_v1_5_decode_emsa cleanup").

Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 lib/digsig.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/lib/digsig.c
+++ b/lib/digsig.c
@@ -163,9 +163,11 @@ static int digsig_verify_rsa(struct key
 	memcpy(out1 + head, p, l);
 
 	err = pkcs_1_v1_5_decode_emsa(out1, len, mblen, out2, &len);
+	if (err)
+		goto err;
 
-	if (!err && len == hlen)
-		err = memcmp(out2, h, hlen);
+	if (len != hlen || memcmp(out2, h, hlen))
+		err = -EINVAL;
 
 err:
 	mpi_free(in);


