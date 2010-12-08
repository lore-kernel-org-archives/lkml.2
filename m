Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932351Ab0LHCCD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 21:02:03 -0500
Received: from kroah.org ([198.145.64.141]:48332 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756782Ab0LHA7G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:59:06 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:22 2010
Message-Id: <20101208005722.384316220@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:56:27 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ben Hutchings <ben@decadent.org.uk>,
        "David S. Miller" <davem@davemloft.net>
Subject: [010/289] r6040: Fix multicast filter some more
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

commit e2269308359d5863b6aa1fcb95a425a2ab255f1f upstream.

This code has been broken forever, but in several different and
creative ways.

So far as I can work out, the R6040 MAC filter has 4 exact-match
entries, the first of which the driver uses for its assigned unicast
address, plus a 64-entry hash-based filter for multicast addresses
(maybe unicast as well?).

The original version of this code would write the first 4 multicast
addresses as exact-match entries from offset 1 (bug #1: there is no
entry 4 so this could write to some PHY registers).  It would fill the
remainder of the exact-match entries with the broadcast address (bug #2:
this would overwrite the last used entry).  If more than 4 multicast
addresses were configured, it would set up the hash table, write some
random crap to the MAC control register (bug #3) and finally walk off
the end of the list when filling the exact-match entries (bug #4).

All of this seems to be pointless, since it sets the promiscuous bit
when the interface is made promiscuous or if >4 multicast addresses
are enabled, and never clears it (bug #5, masking bug #2).

The recent(ish) changes to the multicast list fixed bug #4, but
completely removed the limit on iteration over the exact-match entries
(bug #6).

Bug #4 was reported as
<https://bugzilla.kernel.org/show_bug.cgi?id=15355> and more recently
as <http://bugs.debian.org/600155>.  Florian Fainelli attempted to fix
these in commit 3bcf8229a8c49769e48d3e0bd1e20d8e003f8106, but that
actually dealt with bugs #1-3, bug #4 having been fixed in mainline at
that point.

That commit fixes the most important current bug #6.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/r6040.c |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

--- a/drivers/net/r6040.c
+++ b/drivers/net/r6040.c
@@ -893,16 +893,18 @@ static void r6040_multicast_list(struct
 	/* Multicast Address 1~4 case */
 	i = 0;
 	netdev_for_each_mc_addr(ha, dev) {
-		if (i < MCAST_MAX) {
-			adrp = (u16 *) ha->addr;
-			iowrite16(adrp[0], ioaddr + MID_1L + 8 * i);
-			iowrite16(adrp[1], ioaddr + MID_1M + 8 * i);
-			iowrite16(adrp[2], ioaddr + MID_1H + 8 * i);
-		} else {
-			iowrite16(0xffff, ioaddr + MID_1L + 8 * i);
-			iowrite16(0xffff, ioaddr + MID_1M + 8 * i);
-			iowrite16(0xffff, ioaddr + MID_1H + 8 * i);
-		}
+		if (i >= MCAST_MAX)
+			break;
+		adrp = (u16 *) ha->addr;
+		iowrite16(adrp[0], ioaddr + MID_1L + 8 * i);
+		iowrite16(adrp[1], ioaddr + MID_1M + 8 * i);
+		iowrite16(adrp[2], ioaddr + MID_1H + 8 * i);
+		i++;
+	}
+	while (i < MCAST_MAX) {
+		iowrite16(0xffff, ioaddr + MID_1L + 8 * i);
+		iowrite16(0xffff, ioaddr + MID_1M + 8 * i);
+		iowrite16(0xffff, ioaddr + MID_1H + 8 * i);
 		i++;
 	}
 }


