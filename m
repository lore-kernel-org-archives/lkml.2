Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964862Ab1C3VHr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:07:47 -0400
Received: from mga03.intel.com ([143.182.124.21]:2656 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964835Ab1C3VHf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:07:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="411277752"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: drosenberg@vsecurity.com, vladislav.yasevich@hp.com, davem@davemloft.net,
        gregkh@suse.de, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [113/275] sctp: Fix out-of-bounds reading in sctp_asoc_get_hmac()
Message-Id: <20110330210552.A49033E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:05:52 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Dan Rosenberg <drosenberg@vsecurity.com>

commit 51e97a12bef19b7e43199fc153cf9bd5f2140362 upstream.

The sctp_asoc_get_hmac() function iterates through a peer's hmac_ids
array and attempts to ensure that only a supported hmac entry is
returned.  The current code fails to do this properly - if the last id
in the array is out of range (greater than SCTP_AUTH_HMAC_ID_MAX), the
id integer remains set after exiting the loop, and the address of an
out-of-bounds entry will be returned and subsequently used in the parent
function, causing potentially ugly memory corruption.  This patch resets
the id integer to 0 on encountering an invalid id so that NULL will be
returned after finishing the loop if no valid ids are found.

Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>
Acked-by: Vlad Yasevich <vladislav.yasevich@hp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 net/sctp/auth.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

Index: linux-2.6.35.y/net/sctp/auth.c
===================================================================
--- linux-2.6.35.y.orig/net/sctp/auth.c	2011-03-29 22:51:23.475122499 -0700
+++ linux-2.6.35.y/net/sctp/auth.c	2011-03-29 23:03:00.538286398 -0700
@@ -543,16 +543,20 @@
 		id = ntohs(hmacs->hmac_ids[i]);
 
 		/* Check the id is in the supported range */
-		if (id > SCTP_AUTH_HMAC_ID_MAX)
+		if (id > SCTP_AUTH_HMAC_ID_MAX) {
+			id = 0;
 			continue;
+		}
 
 		/* See is we support the id.  Supported IDs have name and
 		 * length fields set, so that we can allocated and use
 		 * them.  We can safely just check for name, for without the
 		 * name, we can't allocate the TFM.
 		 */
-		if (!sctp_hmac_list[id].hmac_name)
+		if (!sctp_hmac_list[id].hmac_name) {
+			id = 0;
 			continue;
+		}
 
 		break;
 	}
