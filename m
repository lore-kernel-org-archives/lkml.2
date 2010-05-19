Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751900Ab0ESVIO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 17:08:14 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:36674 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711Ab0ESVIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 17:08:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=gkhSYE/DISPqhL4A6XvRFJ+GdrDAAQA/MsAYxNSUIdeiFY8FR8tSblZmywPny5cHjT
         dPuoF5RzXOIaIrhKh5BCCPJH4Fc3A8R8f2u3PfmqYRj2/FdnEcQQ3H+C4ZhFygIyiRir
         g3EKR7RxzJdHz254dCx742ONmMvVakEfJ/Cjc=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: linux-pcmcia@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux@dominikbrodowski.net,
       "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH][bisected]pcmcia:yenta_socket.c fix broken wireless cards.
Date: Wed, 19 May 2010 14:08:04 -0700
Message-Id: <1274303284-21529-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.6.5.2.180.gc5b3e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've an old dell inspiron 1200(amazingly still works), that use's
a D-Link DWL-G650, and/or a Dell Wireless 1350 for it's wireless
connection.

With using opensuse11.2(kernel:2.6.32*), the card(s) work fine, but as soon
as I pulled the latest HEAD, all hell broke loose. So after doing a
days worth of bisecting with this machine(painfully slow), it finally
came down to this commit:

commit 28ca8dd71fc170090edca62cb8129625d01b7760
Author: Jens K<C3><BC>nzer <Jens.Kuenzer@fpga.homeip.net>
Date:   Sat Mar 6 07:46:16 2010 +0100

    pcmcia: honor saved flags in yenta_socket's I365_CSCINT register
    
    Instead of overwriting the I365_CSCINT register, save the old value and
    merely change the bits we care about.
    
    Part 1 of a series to allow the ISA irq to be used for Cardbus devices
    if the socket's PCI irq is unusable.
    
    [linux@dominikbrodowski.net: split up the original patch, commit message]
    
    Signed-off-by: Jens Kuenzer <Jens.Kuenzer@fpga.homeip.net>
    Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>
 
so after fussing around with this commit, and yenta_socket.c
I come up with something, that does get my cards
powered up, and all good(hopefully).

Anyways please have a look, if you need me to test something
different let me know. 
 
 Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/pcmcia/yenta_socket.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pcmcia/yenta_socket.c b/drivers/pcmcia/yenta_socket.c
index 83ace27..7d6f43b 100644
--- a/drivers/pcmcia/yenta_socket.c
+++ b/drivers/pcmcia/yenta_socket.c
@@ -989,7 +989,7 @@ static int yenta_probe_cb_irq(struct yenta_socket *socket)
 	}
 
 	/* generate interrupt, wait */
-	reg = exca_readb(socket, I365_CSCINT);
+	reg = exca_readb(socket, I365_CSCINT | I365_CSC_ANY);
 	exca_writeb(socket, I365_CSCINT, reg | I365_CSC_STSCHG);
 	cb_writel(socket, CB_SOCKET_EVENT, -1);
 	cb_writel(socket, CB_SOCKET_MASK, CB_CSTSMASK);
-- 
1.6.5.2.180.gc5b3e

