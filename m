Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964816Ab1FWR6u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:58:50 -0400
Received: from mail.windriver.com ([147.11.1.11]:35079 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933596Ab1FWRhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:37:36 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Anton Blanchard <anton@au1.ibm.com>,
        Anton Blanchard <anton@samba.org>, David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 152/247] RxRPC: Fix v1 keys
Date: Thu, 23 Jun 2011 13:33:40 -0400
Message-Id: <1308850515-15242-93-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anton Blanchard <anton@au1.ibm.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
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
-- 
1.7.4.4

