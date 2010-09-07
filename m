Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757757Ab0IGPZx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 11:25:53 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:51861 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757700Ab0IGPZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 11:25:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Fu6GOtMzZkJy+XaBxmBbyHfynbFmdnWE2TKPPFT5dJIShARzC705VmDHFWRGmB3Bxt
         4lJgY1B6gaNmtDFjPX9YKS8Mmoc4JJvotkKhZDUj8xJMPtbtl927Bu8tg8hapk7D8pcO
         m6NtSmrwD2cCzLIfxsotn6ngBOD3qVkMYuaEA=
From: tom.leiming@gmail.com
To: greg@kroah.com
Cc: linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ming Lei <tom.leiming@gmail.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Felipe Balbi <me@felipebalbi.com>, Anand Gadiyar <gadiyar@ti.com>,
        Mike Frysinger <vapier@gentoo.org>,
        Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: [RESEND/PATCH 6/6] USB: musb-gadget: fix dma length in txstate
Date: Tue,  7 Sep 2010 23:23:34 +0800
Message-Id: <1283873014-32511-7-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1283873014-32511-1-git-send-email-tom.leiming@gmail.com>
References: <1283873014-32511-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ming Lei <tom.leiming@gmail.com>

DMA length should not go beyond the availabe space of request buffer,
so fix it.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Felipe Balbi <me@felipebalbi.com>
Cc: Anand Gadiyar <gadiyar@ti.com>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
---
 drivers/usb/musb/musb_gadget.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/usb/musb/musb_gadget.c b/drivers/usb/musb/musb_gadget.c
index fa826f9..cacae96 100644
--- a/drivers/usb/musb/musb_gadget.c
+++ b/drivers/usb/musb/musb_gadget.c
@@ -300,6 +300,11 @@ static void txstate(struct musb *musb, struct musb_request *req)
 #ifndef	CONFIG_MUSB_PIO_ONLY
 	if (is_dma_capable() && musb_ep->dma) {
 		struct dma_controller	*c = musb->dma_controller;
+		size_t request_size;
+
+		/* setup DMA, then program endpoint CSR */
+		request_size = min_t(size_t, request->length - request->actual,
+					musb_ep->dma->max_len);
 
 		use_dma = (request->dma != DMA_ADDR_INVALID);
 
@@ -307,11 +312,6 @@ static void txstate(struct musb *musb, struct musb_request *req)
 
 #ifdef CONFIG_USB_INVENTRA_DMA
 		{
-			size_t request_size;
-
-			/* setup DMA, then program endpoint CSR */
-			request_size = min_t(size_t, request->length,
-						musb_ep->dma->max_len);
 			if (request_size < musb_ep->packet_sz)
 				musb_ep->dma->desired_mode = 0;
 			else
@@ -373,8 +373,8 @@ static void txstate(struct musb *musb, struct musb_request *req)
 		use_dma = use_dma && c->channel_program(
 				musb_ep->dma, musb_ep->packet_sz,
 				0,
-				request->dma,
-				request->length);
+				request->dma + request->actual,
+				request_size);
 		if (!use_dma) {
 			c->channel_release(musb_ep->dma);
 			musb_ep->dma = NULL;
@@ -386,8 +386,8 @@ static void txstate(struct musb *musb, struct musb_request *req)
 		use_dma = use_dma && c->channel_program(
 				musb_ep->dma, musb_ep->packet_sz,
 				request->zero,
-				request->dma,
-				request->length);
+				request->dma + request->actual,
+				request_size);
 #endif
 	}
 #endif
-- 
1.6.2.5

