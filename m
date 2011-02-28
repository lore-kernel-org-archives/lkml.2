Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288Ab1B1QxJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 11:53:09 -0500
Received: from kroah.org ([198.145.64.141]:41163 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755155Ab1B1Qgv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 11:36:51 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Feb 28 08:24:06 2011
Message-Id: <20110228162406.082092634@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Mon, 28 Feb 2011 08:22:25 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        Vlad Yasevich <vladislav.yasevich@hp.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [04/68] sctp: Fix out-of-bounds reading in sctp_asoc_get_hmac()
In-Reply-To: <20110228163502.GA27221@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

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


