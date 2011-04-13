Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932889Ab1DMQ0j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 12:26:39 -0400
Received: from kroah.org ([198.145.64.141]:52791 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932805Ab1DMQMv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 12:12:51 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Apr 13 09:10:44 2011
Message-Id: <20110413161044.589499459@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 13 Apr 2011 09:09:43 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [20/71] irda: prevent heap corruption on invalid nickname
In-Reply-To: <20110413161106.GA20405@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

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

---
 net/irda/irnet/irnet_ppp.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/irda/irnet/irnet_ppp.c
+++ b/net/irda/irnet/irnet_ppp.c
@@ -105,6 +105,9 @@ irnet_ctrl_write(irnet_socket *	ap,
 	      while(isspace(start[length - 1]))
 		length--;
 
+	      DABORT(length < 5 || length > NICKNAME_MAX_LEN + 5,
+		     -EINVAL, CTRL_ERROR, "Invalid nickname.\n");
+
 	      /* Copy the name for later reuse */
 	      memcpy(ap->rname, start + 5, length - 5);
 	      ap->rname[length - 5] = '\0';


