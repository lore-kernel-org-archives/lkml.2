Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933751Ab1DNSCz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 14:02:55 -0400
Received: from mail.windriver.com ([147.11.1.11]:42376 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965068Ab1DNR7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:59:10 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Dan Rosenberg <drosenberg@vsecurity.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 204/209] sctp: Fix out-of-bounds reading in sctp_asoc_get_hmac()
Date: Thu, 14 Apr 2011 13:56:02 -0400
Message-Id: <1302803767-9715-91-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
 <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Rosenberg <drosenberg@vsecurity.com>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

commit 51e97a12bef19b7e43199fc153cf9bd5f2140362 upstream

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/sctp/auth.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/sctp/auth.c b/net/sctp/auth.c
index 8636639..ddbbf7c 100644
--- a/net/sctp/auth.c
+++ b/net/sctp/auth.c
@@ -543,16 +543,20 @@ struct sctp_hmac *sctp_auth_asoc_get_hmac(const struct sctp_association *asoc)
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
-- 
1.7.4.4

