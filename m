Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741Ab1CKUnG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 15:43:06 -0500
Received: from kroah.org ([198.145.64.141]:46530 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754618Ab1CKUnC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 15:43:02 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar 11 12:41:09 2011
Message-Id: <20110311204109.638726681@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 11 Mar 2011 12:40:04 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Anton Blanchard <anton@samba.org>, David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [03/17] RxRPC: Fix v1 keys
In-Reply-To: <20110311204126.GA7223@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Anton Blanchard <anton@au1.ibm.com>

commit f009918a1c1bbf8607b8aab3959876913a30193a upstream.

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
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/keys/rxrpc-type.h |    1 -
 1 file changed, 1 deletion(-)

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


