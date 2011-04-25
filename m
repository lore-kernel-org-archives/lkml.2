Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757628Ab1DYU67 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:58:59 -0400
Received: from 1wt.eu ([62.212.114.60]:33801 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756196Ab1DYUXn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:23:43 -0400
Message-Id: <20110425200234.474693117@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:03:06 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Dan Rosenberg <drosenberg@vsecurity.com>,
        Vlad Yasevich <vladislav.yasevich@hp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 034/173] sctp: Fix out-of-bounds reading in sctp_asoc_get_hmac()
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

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

---
 net/sctp/auth.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/net/sctp/auth.c
+++ b/net/sctp/auth.c
@@ -542,16 +542,20 @@ struct sctp_hmac *sctp_auth_asoc_get_hma
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


