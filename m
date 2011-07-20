Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751140Ab1GTHYe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 03:24:34 -0400
Received: from www.linutronix.de ([62.245.132.108]:45234 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777Ab1GTHYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 03:24:33 -0400
Date: Wed, 20 Jul 2011 09:24:32 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, sodaville@linutronix.de
Subject: [PATCH 1/2 v2] gpio/gpio-generic: read correct set register for
 caching if available
Message-ID: <20110720072432.GA20042@linutronix.de>
References: <1309159583-11339-1-git-send-email-bigeasy@linutronix.de>
 <20110704154447.GG29977@ponder.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20110704154447.GG29977@ponder.secretlab.ca>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ->data is a shadow copy which is used during the ->set callback in
order to avoid a read of the register before write.
If ->reg_set is set then we write to this location therefore we should
cache that value.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
* Grant Likely | 2011-07-04 09:44:47 [-0600]:

>On most of the gpio controllers that I've seen, the 'set' register
>isn't something that you can actually read.  I don't think this is
>something that can be done for all gpio controllers.

I have reworked the part to only read the set register only if not
set/clear mode. Is this okay or are they any controller where this does
not work?

 drivers/gpio/gpio-generic.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/gpio/gpio-generic.c b/drivers/gpio/gpio-generic.c
index 231714d..5234b20 100644
--- a/drivers/gpio/gpio-generic.c
+++ b/drivers/gpio/gpio-generic.c
@@ -398,7 +398,10 @@ int __devinit bgpio_init(struct bgpio_chip *bgc,
 	if (ret)
 		return ret;
 
-	bgc->data = bgc->read_reg(bgc->reg_dat);
+	if (bgc->reg_set == bgpio_set_set)
+		bgc->data = bgc->read_reg(bgc->reg_set);
+	else if (bgc->reg_set == bgpio_set)
+		bgc->data = bgc->read_reg(bgc->reg_dat);
 
 	return ret;
 }
-- 
1.7.4.4

