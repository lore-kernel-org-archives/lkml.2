Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753741Ab1B1N2B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 08:28:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8834 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752677Ab1B1N16 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 08:27:58 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] RxRPC: Fix v1 keys
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Anton Blanchard <anton@samba.org>,
        David Howells <dhowells@redhat.com>
Date: Mon, 28 Feb 2011 13:27:53 +0000
Message-ID: <20110228132753.30463.24909.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anton Blanchard <anton@au1.ibm.com>

commit 339412841d7 (RxRPC: Allow key payloads to be passed in XDR form)
broke klog for me. I notice the v1 key struct had a kif_version field
added:

-struct rxkad_key {
-       u16     security_index;         /* RxRPC header security index */
-       u16     ticket_len;             /* length of ticket[] */
-       u32     expiry;                 /* time at which expires */
-       u32     kvno;                   /* key version number */
-       u8      session_key[8];         /* DES session key */
-       u8      ticket[0];              /* the encrypted ticket */
-};

+struct rxrpc_key_data_v1 {
+       u32             kif_version;            /* 1 */
+       u16             security_index;
+       u16             ticket_length;
+       u32             expiry;                 /* time_t */
+       u32             kvno;
+       u8              session_key[8];
+       u8              ticket[0];
+};

However the code in rxrpc_instantiate strips it away:

	data += sizeof(kver);
	datalen -= sizeof(kver);

Removing kif_version fixes my problem.

Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/keys/rxrpc-type.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/include/keys/rxrpc-type.h b/include/keys/rxrpc-type.h
index 5cb86c3..fc48754 100644
--- a/include/keys/rxrpc-type.h
+++ b/include/keys/rxrpc-type.h
@@ -99,7 +99,6 @@ struct rxrpc_key_token {
  * structure of raw payloads passed to add_key() or instantiate key
  */
 struct rxrpc_key_data_v1 {
-	u32		kif_version;		/* 1 */
 	u16		security_index;
 	u16		ticket_length;
 	u32		expiry;			/* time_t */

