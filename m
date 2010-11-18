Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760108Ab0KRSRK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 13:17:10 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:46620 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760095Ab0KRSRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 13:17:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=pHNaqvCHp4J8ezOQfjIzSbVSy5WLHDP82iZmzsCwZk3GBV8qFAtH8xP2FR5oBHByWx
         g5aCzJhvF8DrSP2Czr0T8DpSupCgmRQ7vt8f3ituJMPI/nZcMGH6S6UBOuMNfSbO++FM
         +xKtfgCWHWcy/SzpRSCbCfu22UnPA/AxpSrpI=
From: Vasiliy Kulikov <segoon@openwall.com>
To: kernel-janitors@vger.kernel.org
Cc: Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] leds: leds-lp5521: fix potential buffer overflow
Date: Thu, 18 Nov 2010 21:17:00 +0300
Message-Id: <1290104221-31375-1-git-send-email-segoon@openwall.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code doesn't check first sscanf() return value.
If first sscanf() failed then c contains some garbage.
It might lead to buffer overflow in second sscanf() call.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 Compile tested.

 drivers/leds/leds-lp5521.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/leds/leds-lp5521.c b/drivers/leds/leds-lp5521.c
index 3782f31..939319d 100644
--- a/drivers/leds/leds-lp5521.c
+++ b/drivers/leds/leds-lp5521.c
@@ -362,6 +362,8 @@ static int lp5521_do_store_load(struct lp5521_engine *engine,
 	while ((offset < len - 1) && (i < LP5521_PROGRAM_LENGTH)) {
 		/* separate sscanfs because length is working only for %s */
 		ret = sscanf(buf + offset, "%2s%n ", c, &nrchars);
+		if (ret != 2)
+			goto fail;
 		ret = sscanf(c, "%2x", &cmd);
 		if (ret != 1)
 			goto fail;
-- 
1.7.0.4

