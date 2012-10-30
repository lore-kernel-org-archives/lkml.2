Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965764Ab2J3TWe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 15:22:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4981 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758457Ab2J3TWS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 15:22:18 -0400
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 18/23] pefile: Parse the presumed PKCS#7 content of the
 certificate blob
To: rusty@rustcorp.com.au
Cc: dhowells@redhat.com, pjones@redhat.com, jwboyer@redhat.com, mjg@redhat.com,
        dmitry.kasatkin@intel.com, zohar@linux.vnet.ibm.com,
        keescook@chromium.org, keyrings@linux-nfs.org,
        linux-kernel@vger.kernel.org
Date: Tue, 30 Oct 2012 19:22:05 +0000
Message-ID: <20121030192205.11000.50738.stgit@warthog.procyon.org.uk>
In-Reply-To: <20121030191927.11000.68420.stgit@warthog.procyon.org.uk>
References: <20121030191927.11000.68420.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Parse the content of the certificate blob, presuming it to be PKCS#7 format.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 crypto/asymmetric_keys/pefile_parser.c |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)


diff --git a/crypto/asymmetric_keys/pefile_parser.c b/crypto/asymmetric_keys/pefile_parser.c
index 24c117e..68fc525 100644
--- a/crypto/asymmetric_keys/pefile_parser.c
+++ b/crypto/asymmetric_keys/pefile_parser.c
@@ -198,6 +198,7 @@ static int pefile_strip_sig_wrapper(struct key_preparsed_payload *prep,
  */
 static int pefile_key_preparse(struct key_preparsed_payload *prep)
 {
+	struct pkcs7_message *pkcs7;
 	struct pefile_context ctx;
 	int ret;
 
@@ -212,7 +213,22 @@ static int pefile_key_preparse(struct key_preparsed_payload *prep)
 	if (ret < 0)
 		return ret;
 
-	return -ENOANO; // Not yet complete
+	pkcs7 = pkcs7_parse_message(prep->data + ctx.sig_offset, ctx.sig_len);
+	if (IS_ERR(pkcs7))
+		return PTR_ERR(pkcs7);
+	ctx.pkcs7 = pkcs7;
+
+	if (!ctx.pkcs7->data || !ctx.pkcs7->data_len) {
+		pr_devel("PKCS#7 message does not contain data\n");
+		ret = -EBADMSG;
+		goto error;
+	}
+
+	ret = -ENOANO; // Not yet complete
+
+error:
+	pkcs7_free_message(ctx.pkcs7);
+	return ret;
 }
 
 static struct asymmetric_key_parser pefile_key_parser = {

