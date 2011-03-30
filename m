Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965245Ab1C3VeA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:34:00 -0400
Received: from mga14.intel.com ([143.182.124.37]:49299 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964796Ab1C3VIl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:08:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="411278338"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: anton@au1.ibm.com, anton@samba.org, dhowells@redhat.com,
        davem@davemloft.net, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [175/275] RxRPC: Fix v1 keys
Message-Id: <20110330210657.F2D073E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:06:57 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 include/keys/rxrpc-type.h |    1 -
 1 file changed, 1 deletion(-)

Index: linux-2.6.35.y/include/keys/rxrpc-type.h
===================================================================
--- linux-2.6.35.y.orig/include/keys/rxrpc-type.h	2011-03-29 22:50:53.770882557 -0700
+++ linux-2.6.35.y/include/keys/rxrpc-type.h	2011-03-29 23:03:01.881252033 -0700
@@ -99,7 +99,6 @@
  * structure of raw payloads passed to add_key() or instantiate key
  */
 struct rxrpc_key_data_v1 {
-	u32		kif_version;		/* 1 */
 	u16		security_index;
 	u16		ticket_length;
 	u32		expiry;			/* time_t */
