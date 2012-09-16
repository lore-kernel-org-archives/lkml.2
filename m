Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751818Ab2IPCbG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2012 22:31:06 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:50469 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865Ab2IPCax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2012 22:30:53 -0400
MIME-Version: 1.0
In-Reply-To: <CANEcBPSEamgOiGqNUSwB+hYCo1k2OTXDA=qsrw0Co8_F7treWw@mail.gmail.com>
References: <CANEcBPSEamgOiGqNUSwB+hYCo1k2OTXDA=qsrw0Co8_F7treWw@mail.gmail.com>
Date: Sun, 16 Sep 2012 10:30:53 +0800
Message-ID: <CANEcBPQnsV26UkyGxms0vKM9wK1NxfKjN4Z0qGipQtV4UPZgGA@mail.gmail.com>
Subject: [PATCH] fix ZOMBIE state bug in PPPOE driver
From: Xiaodong Xu <stid.smth@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I found a bug in kernel PPPOE driver.
When PPPOE is running over a virtual ethernet interface (e.g., a
bonding interface) and the user tries to delete the interface in case
the PPPOE state is ZOMBIE, the kernel will loop infinitely while
unregistering net_device for the reference count is not reset to zero
which should be done by dev_put().

The following patch could fix this issue:

$ git diff
diff --git a/drivers/net/ppp/pppoe.c b/drivers/net/ppp/pppoe.c
index cbf7047..20f31d0 100644
--- a/drivers/net/ppp/pppoe.c
+++ b/drivers/net/ppp/pppoe.c
@@ -570,7 +570,7 @@ static int pppoe_release(struct socket *sock)

        po = pppox_sk(sk);

-       if (sk->sk_state & (PPPOX_CONNECTED | PPPOX_BOUND)) {
+       if (sk->sk_state & (PPPOX_CONNECTED | PPPOX_BOUND | PPPOX_ZOMBIE)) {
                dev_put(po->pppoe_dev);
                po->pppoe_dev = NULL;
        }

Thanks.

Regards,
Xiaodong Xu
