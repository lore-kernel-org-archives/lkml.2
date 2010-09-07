Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757634Ab0IGPZO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 11:25:14 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:39134 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757432Ab0IGPZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 11:25:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=L6BTOToS4QUR3jw9pH5sIAMxXQJTwJqPkfaAg4khwPzR6MfZmtevqVKwUjmku6szPl
         MCe5VvoHVyZbMkPX3iRcZFr7uynJg3B67rj/waRCG5S3Rj1Em2U/HWCZj08/1IsfsuZT
         56MpDCSduK0Xe9M2bpNXdr/h808xRwtwtBP7Y=
From: tom.leiming@gmail.com
To: greg@kroah.com
Cc: linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ming Lei <tom.leiming@gmail.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Felipe Balbi <me@felipebalbi.com>, Anand Gadiyar <gadiyar@ti.com>,
        Mike Frysinger <vapier@gentoo.org>,
        Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: [RESEND/PATCH 4/6] USB: musb-gadget: fix DMA length for OUT transfer
Date: Tue,  7 Sep 2010 23:23:32 +0800
Message-Id: <1283873014-32511-5-git-send-email-tom.leiming@gmail.com>
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
Acked-by:   Anand Gadiyar <gadiyar@ti.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Felipe Balbi <me@felipebalbi.com>
Cc: Anand Gadiyar <gadiyar@ti.com>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
---
 drivers/usb/musb/musb_gadget.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/musb/musb_gadget.c b/drivers/usb/musb/musb_gadget.c
index 176e127..f3ee04f 100644
--- a/drivers/usb/musb/musb_gadget.c
+++ b/drivers/usb/musb/musb_gadget.c
@@ -659,10 +659,11 @@ static void rxstate(struct musb *musb, struct musb_request *req)
 				if (request->actual < request->length) {
 					int transfer_size = 0;
 #ifdef USE_MODE1
-					transfer_size = min(request->length,
+					transfer_size = min(request->length - request->actual,
 							channel->max_len);
 #else
-					transfer_size = len;
+					transfer_size = min(request->length - request->actual,
+							(unsigned)len);
 #endif
 					if (transfer_size <= musb_ep->packet_sz)
 						musb_ep->dma->desired_mode = 0;
-- 
1.6.2.5

