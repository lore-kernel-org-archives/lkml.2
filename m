Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563Ab1DMRzW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 13:55:22 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42973
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753177Ab1DMRzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 13:55:21 -0400
Date: Wed, 13 Apr 2011 10:54:46 -0700 (PDT)
Message-Id: <20110413.105446.183041592.davem@davemloft.net>
To: venki@google.com
Cc: kaber@trash.net, zbr@ioremap.net, linux-kernel@vger.kernel.org
Subject: Re: System crash, bisect points to "connector: convert to
 synchronous netlink message processing"
From: David Miller <davem@davemloft.net>
In-Reply-To: <BANLkTin5kWej_pThqBvL7dypVB_JGYU7=A@mail.gmail.com>
References: <BANLkTin5kWej_pThqBvL7dypVB_JGYU7=A@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Venkatesh Pallipadi <venki@google.com>
Date: Wed, 13 Apr 2011 10:25:39 -0700

> I started seeing crashes with linus git recently. The failure
> signature is something like:

There is a fix in net-2.6 for this already:

--------------------
commit 0e08785845093ef4ed220463a739bc8d0db95de7
Author: Patrick McHardy <kaber@trash.net>
Date:   Tue Apr 12 05:39:51 2011 +0000

    connector: fix skb double free in cn_rx_skb()
    
    When a skb is delivered to a registered callback, cn_call_callback()
    incorrectly returns -ENODEV after freeing the skb, causing cn_rx_skb()
    to free the skb a second time.
    
    Reported-by: Eric B Munson <emunson@mgebm.net>
    Signed-off-by: Patrick McHardy <kaber@trash.net>
    Tested-by: Eric B Munson <emunson@mgebm.net>
    Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/connector/connector.c b/drivers/connector/connector.c
index d770058..219d88a 100644
--- a/drivers/connector/connector.c
+++ b/drivers/connector/connector.c
@@ -142,6 +142,7 @@ static int cn_call_callback(struct sk_buff *skb)
 		cbq->callback(msg, nsp);
 		kfree_skb(skb);
 		cn_queue_release_callback(cbq);
+		err = 0;
 	}
 
 	return err;
