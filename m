Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932703Ab0EJWyj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 18:54:39 -0400
Received: from kroah.org ([198.145.64.141]:33330 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932504Ab0EJWwp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:52:45 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:33:25 2010
Message-Id: <20100510223325.243058423@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:32:58 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Vlad Yasevich <vladislav.yasevich@hp.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [087/117] sctp: fix potential reference of a freed pointer
In-Reply-To: <20100510223700.GA18404@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Vlad Yasevich <vladislav.yasevich@hp.com>

[ Upstream commit 0c42749cffbb4a06be86c5e5db6c7ebad548781f ]

When sctp attempts to update an assocition, it removes any
addresses that were not in the updated INITs.  However, the loop
may attempt to refrence a transport with address after removing it.

Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/sctp/associola.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -1194,8 +1194,10 @@ void sctp_assoc_update(struct sctp_assoc
 	/* Remove any peer addresses not present in the new association. */
 	list_for_each_safe(pos, temp, &asoc->peer.transport_addr_list) {
 		trans = list_entry(pos, struct sctp_transport, transports);
-		if (!sctp_assoc_lookup_paddr(new, &trans->ipaddr))
-			sctp_assoc_del_peer(asoc, &trans->ipaddr);
+		if (!sctp_assoc_lookup_paddr(new, &trans->ipaddr)) {
+			sctp_assoc_rm_peer(asoc, trans);
+			continue;
+		}
 
 		if (asoc->state >= SCTP_STATE_ESTABLISHED)
 			sctp_transport_reset(trans);


