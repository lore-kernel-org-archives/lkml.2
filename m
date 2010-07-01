Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759392Ab0GAVi3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:38:29 -0400
Received: from kroah.org ([198.145.64.141]:32992 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759215Ab0GAVOn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 17:14:43 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:42:58 2010
Message-Id: <20100701174258.233494395@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:43:50 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Dominik Brodowski <linux@dominikbrodowski.net>
Subject: [140/200] pcmcia: only keep saved I365_CSCINT flag if there is no PCI irq
In-Reply-To: <20100701175201.GA2149@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dominik Brodowski <linux@dominikbrodowski.net>

commit 02caa56e4b789b80ae7e0f0f0789f94b44ad32ef upstream.

Keeping the saved I365_CSCINT flag around breaks PCMCIA on some system,
and is only needed on a few systems to get PCMCIA to work. This patch
allows PCMCIA to work on both types, and it fixes
https://bugzilla.kernel.org/show_bug.cgi?id=16015

Reported-by: Justin P. Mattock <justinmattock@gmail.com>
Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pcmcia/yenta_socket.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/pcmcia/yenta_socket.c
+++ b/drivers/pcmcia/yenta_socket.c
@@ -975,7 +975,7 @@ static irqreturn_t yenta_probe_handler(i
 /* probes the PCI interrupt, use only on override functions */
 static int yenta_probe_cb_irq(struct yenta_socket *socket)
 {
-	u8 reg;
+	u8 reg = 0;
 
 	if (!socket->cb_irq)
 		return -1;
@@ -989,7 +989,8 @@ static int yenta_probe_cb_irq(struct yen
 	}
 
 	/* generate interrupt, wait */
-	reg = exca_readb(socket, I365_CSCINT);
+	if (!socket->dev->irq)
+		reg = exca_readb(socket, I365_CSCINT);
 	exca_writeb(socket, I365_CSCINT, reg | I365_CSC_STSCHG);
 	cb_writel(socket, CB_SOCKET_EVENT, -1);
 	cb_writel(socket, CB_SOCKET_MASK, CB_CSTSMASK);


