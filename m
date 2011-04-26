Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932896Ab1DZVgQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:36:16 -0400
Received: from mga14.intel.com ([143.182.124.37]:19974 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758705Ab1DZVNy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:13:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,270,1301900400"; 
   d="scan'208";a="425950975"
From: Andi Kleen <andi@firstfloor.org>
References: <20110426212.641772347@firstfloor.org>
In-Reply-To: <20110426212.641772347@firstfloor.org>
To: segoon@openwall.com, padovan@profusion.mobi, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [26/106] Bluetooth: bnep: fix buffer overflow
Message-Id: <20110426211305.2003B3E1886@tassilo.jf.intel.com>
Date: Tue, 26 Apr 2011 14:13:05 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Vasiliy Kulikov <segoon@openwall.com>

commit 43629f8f5ea32a998d06d1bb41eefa0e821ff573 upstream.

Struct ca is copied from userspace.  It is not checked whether the "device"
field is NULL terminated.  This potentially leads to BUG() inside of
alloc_netdev_mqs() and/or information leak by creating a device with a name
made of contents of kernel stack.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
Signed-off-by: Gustavo F. Padovan <padovan@profusion.mobi>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 net/bluetooth/bnep/sock.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.35.y/net/bluetooth/bnep/sock.c
===================================================================
--- linux-2.6.35.y.orig/net/bluetooth/bnep/sock.c
+++ linux-2.6.35.y/net/bluetooth/bnep/sock.c
@@ -88,6 +88,7 @@ static int bnep_sock_ioctl(struct socket
 			sockfd_put(nsock);
 			return -EBADFD;
 		}
+		ca.device[sizeof(ca.device)-1] = 0;
 
 		err = bnep_add_connection(&ca, nsock);
 		if (!err) {
