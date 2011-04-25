Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932765Ab1DYUoi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:44:38 -0400
Received: from 1wt.eu ([62.212.114.60]:34322 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932264Ab1DYUYs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:24:48 -0400
Message-Id: <20110425200238.382954287@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:04:36 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Dan Rosenberg <drosenberg@vsecurity.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 124/173] irda: prevent heap corruption on invalid nickname
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

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
@@ -106,6 +106,9 @@ irnet_ctrl_write(irnet_socket *	ap,
 	      while(isspace(start[length - 1]))
 		length--;
 
+	      DABORT(length < 5 || length > NICKNAME_MAX_LEN + 5,
+		     -EINVAL, CTRL_ERROR, "Invalid nickname.\n");
+
 	      /* Copy the name for later reuse */
 	      memcpy(ap->rname, start + 5, length - 5);
 	      ap->rname[length - 5] = '\0';


