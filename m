Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097Ab0ETQfF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 12:35:05 -0400
Received: from isilmar-3.linta.de ([188.40.101.200]:45217 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751947Ab0ETQfD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 12:35:03 -0400
Date: Thu, 20 May 2010 18:34:19 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: "Justin P. Mattock" <justinmattock@gmail.com>,
       Jens.Kuenzer@fpga.homeip.net
Cc: linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][bisected]pcmcia:yenta_socket.c fix broken wireless
 cards.
Message-ID: <20100520163419.GA16522@comet.dominikbrodowski.net>
Mail-Followup-To: "Justin P. Mattock" <justinmattock@gmail.com>,
	Jens.Kuenzer@fpga.homeip.net, linux-pcmcia@lists.infradead.org,
	linux-kernel@vger.kernel.org
References: <1274303284-21529-1-git-send-email-justinmattock@gmail.com>
 <20100520145434.GA12166@comet.dominikbrodowski.net>
 <4BF55AC9.4000905@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BF55AC9.4000905@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens, Justin,

could both of you test this patch on top of 2.6.34, please?

pcmcia: only keep saved I365_CSCING flag if there is no PCI irq

Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>

diff --git a/drivers/pcmcia/yenta_socket.c b/drivers/pcmcia/yenta_socket.c
index 424e576..151ca43 100644
--- a/drivers/pcmcia/yenta_socket.c
+++ b/drivers/pcmcia/yenta_socket.c
@@ -371,8 +371,11 @@ static int yenta_set_socket(struct pcmcia_socket *sock, socket_state_t *state)
 			exca_writeb(socket, I365_POWER, reg);
 
 		/* CSC interrupt: no ISA irq for CSC */
-		reg = exca_readb(socket, I365_CSCINT);
-		reg &= I365_CSC_IRQ_MASK;
+		reg = 0;
+		if (!socket->dev->irq) {
+			reg = exca_readb(socket, I365_CSCINT);
+			reg &= I365_CSC_IRQ_MASK;
+		}
 		reg |= I365_CSC_DETECT;
 		if (state->flags & SS_IOCARD) {
 			if (state->csc_mask & SS_STSCHG)
