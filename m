Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932136Ab1DMPO3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 11:14:29 -0400
Received: from bn-scl-osf02.barracuda.com ([64.235.144.26]:59969 "EHLO
	bn-scl-osf02.barracuda.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757427Ab1DMPO0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 11:14:26 -0400
X-Greylist: delayed 626 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Apr 2011 11:14:26 EDT
X-ASG-Debug-ID: 1302707017-38b501e20000-xx1T2L
X-Barracuda-URL: http://10.8.0.46:80/cgi-bin/mark.cgi
X-ASG-Orig-Subj: [PATCH 1/1] ipv6: ignore looped-back NA while dad is running
Subject: [PATCH 1/1] ipv6: ignore looped-back NA while dad is running
From: Daniel Walter <dwalter@barracuda.com>
To: <netdev@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Apr 2011 17:02:43 +0200
Message-ID: <1302706963.8923.25.camel@localhost>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8BIT
X-EXCLAIMER-MD-CONFIG: 23550527-0592-4512-8b29-af9b0339669a
X-Barracuda-Connect: bn-scl-smrthst01.it.cudanet.local[10.8.1.70]
X-Barracuda-Start-Time: 1302707017
X-Barracuda-Encrypted: AES256-SHA
X-Barracuda-Virus-Scanned: by Barracuda Spam & Virus Firewall at barracuda.com
X-Barracuda-Spam-Score: -1002.00
X-Barracuda-Spam-Status: No, SCORE=-1002.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=1000.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

﻿[ipv6] Ignore looped-back NAs while in Duplicate Address Detection

If we send an unsolicited NA shortly after bringing up an
IPv6 address, the duplicate address detection algorithm
fails and the ip stays in tentative mode forever. 
This is due a missing check if the NA is looped-back to us.

Signed-off-by: Daniel Walter <dwalter@barracuda.com>
---
apply against linux-2.6 HEAD

 net/ipv6/ndisc.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)
---
diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
index 92f952d..f057ff3 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -945,9 +945,10 @@ static void ndisc_recv_na(struct sk_buff *skb)
 	}
 	ifp = ipv6_get_ifaddr(dev_net(dev), &msg->target, dev, 1);
 	if (ifp) {
-		if (ifp->flags & IFA_F_TENTATIVE) {
-			addrconf_dad_failure(ifp);
-			return;
+		if (skb->pkt_type != PACKET_LOOPBACK
+		    && (ifp->flags & IFA_F_TENTATIVE)) {
+				addrconf_dad_failure(ifp);
+				return;
 		}
 		/* What should we make now? The advertisement
 		   is invalid, but ndisc specs say nothing







Barracuda Networks AG
Vorsitzender des Aufsichtsrates/ Chairman of the supervisory board: Dean Drako
Vorstand/ Executive Board: Dr. Wieland Alge, Mag. Guenter Klausner
Sitz der Gesellschaft/ Registered office: 6020 Innsbruck, Austria
Handelsgericht Innsbruck Firmenbuch/ Registration Number: 184392s
UID-Nr/ VAT Number: ATU47509003

Diese Nachricht und allfaellige angehaengte Dokumente sind vertraulich und nur fuer den/die Adressaten bestimmt. Sollten Sie nicht der beabsichtigte Adressat sein, ist jede Offenlegung, Weiterleitung oder sonstige Verwendung dieser Information nicht gestattet. In diesem Fall bitten wir, den Absender zu verstaendigen und die Information zu vernichten. Fuer Uebermittlungsfehler oder sonstige Irrtuemer bei Uebermittlung besteht keine Haftung.

This message and any attached files are confidential and intended solely for the addressee(s). Any publication, transmission or other use of the information by a person or entity other than the intended addressee is prohibited. If you receive this in error please contact the sender and delete the material. The sender does not accept liability for any errors or omissions as a result of the transmission.


Barracuda Networks solutions are now available as virtual appliances. 
Visit www.barracudanetworks.com/vx for more information.



