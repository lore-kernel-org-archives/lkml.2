Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965972Ab0GPQMt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 12:12:49 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:52234 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965891Ab0GPQMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 12:12:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=p+p2sFuf9lWQ5WHlobUatSc9LXv4hbrGmhhlhjubzd5xejwMCFdCDueIQZiwQUpdxf
         d7NS7qfufLEjtEXTHB4TuJvm74MrFujVITvr2b39UUfwaOSDhQKPk+b2Nrv7GgZyrHV7
         adXs9bR/yV/y+5v9ITTLqIf4sJf4SvTVMYBCg=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>, linux-alpha@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 01/15] alpha: srmcons: localize spin_lock section
Date: Fri, 16 Jul 2010 20:12:27 +0400
Message-Id: <1279296747-24783-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Scale down spin_lock_irqsave/spin_unlock_irqrestore exactly to area
where it is needed. Also it makes static checkers happy as code checks
kmalloc() result value exactly after call.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 arch/alpha/kernel/srmcons.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/alpha/kernel/srmcons.c b/arch/alpha/kernel/srmcons.c
index 783f4e5..6b04005 100644
--- a/arch/alpha/kernel/srmcons.c
+++ b/arch/alpha/kernel/srmcons.c
@@ -165,17 +165,15 @@ srmcons_get_private_struct(struct srmcons_private **ps)
 
 	if (srmconsp == NULL) {
 		srmconsp = kmalloc(sizeof(*srmconsp), GFP_KERNEL);
-		spin_lock_irqsave(&srmconsp_lock, flags);
-
 		if (srmconsp == NULL)
 			retval = -ENOMEM;
 		else {
+			spin_lock_irqsave(&srmconsp_lock, flags);
 			srmconsp->tty = NULL;
 			spin_lock_init(&srmconsp->lock);
 			init_timer(&srmconsp->timer);
+			spin_unlock_irqrestore(&srmconsp_lock, flags);
 		}
-
-		spin_unlock_irqrestore(&srmconsp_lock, flags);
 	}
 
 	*ps = srmconsp;
-- 
1.7.0.4

