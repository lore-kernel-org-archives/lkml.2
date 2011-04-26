Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758636Ab1DZVkq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:40:46 -0400
Received: from mga14.intel.com ([143.182.124.37]:51374 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758558Ab1DZVNh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:13:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,270,1301900400"; 
   d="scan'208";a="425950842"
From: Andi Kleen <andi@firstfloor.org>
References: <20110426212.641772347@firstfloor.org>
In-Reply-To: <20110426212.641772347@firstfloor.org>
To: drosenberg@vsecurity.com, davem@davemloft.net, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [10/106] irda: prevent heap corruption on invalid nickname
Message-Id: <20110426211248.4B6223E1886@tassilo.jf.intel.com>
Date: Tue, 26 Apr 2011 14:12:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Dan Rosenberg <drosenberg@vsecurity.com>

commit d50e7e3604778bfc2dc40f440e0742dbae399d54 upstream.

Invalid nicknames containing only spaces will result in an underflow in
a memcpy size calculation, subsequently destroying the heap and
panicking.

v2 also catches the case where the provided nickname is longer than the
buffer size, which can result in controllable heap corruption.

Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 net/irda/irnet/irnet_ppp.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-2.6.35.y/net/irda/irnet/irnet_ppp.c
===================================================================
--- linux-2.6.35.y.orig/net/irda/irnet/irnet_ppp.c
+++ linux-2.6.35.y/net/irda/irnet/irnet_ppp.c
@@ -106,6 +106,9 @@ irnet_ctrl_write(irnet_socket *	ap,
 	      while(isspace(start[length - 1]))
 		length--;
 
+	      DABORT(length < 5 || length > NICKNAME_MAX_LEN + 5,
+		     -EINVAL, CTRL_ERROR, "Invalid nickname.\n");
+
 	      /* Copy the name for later reuse */
 	      memcpy(ap->rname, start + 5, length - 5);
 	      ap->rname[length - 5] = '\0';
