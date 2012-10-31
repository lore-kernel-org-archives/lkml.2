Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422657Ab2JaKeP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 06:34:15 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:42302 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933030Ab2JaKeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 06:34:13 -0400
From: Xiaotian Feng <xtfeng@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Xiaotian Feng <xtfeng@gmail.com>, Xiaotian Feng <dannyfeng@tencent.com>,
        Chas Williams <chas@cmf.nrl.navy.mil>,
        linux-atm-general@lists.sourceforge.net
Subject: [PATCH] atm: he: use tasklet_kill in device remove/release process
Date: Wed, 31 Oct 2012 18:34:47 +0800
Message-Id: <1351679687-27049-1-git-send-email-xtfeng@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some driver uses tasklet_disable in device remove/release process,
tasklet_disable will inc tasklet->count and return. If the tasklet
is not handled yet under some softirq pressure, the tasklet will be
placed on the tasklet_vec, never have a chance to be excuted. This might
lead to a heavy loaded ksoftirqd, wakeup with pending_softirq, but
tasklet is disabled. tasklet_kill should be used in this case.

Signed-off-by: Xiaotian Feng <dannyfeng@tencent.com>
Cc: Chas Williams <chas@cmf.nrl.navy.mil>
Cc: linux-atm-general@lists.sourceforge.net
---
 drivers/atm/he.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/atm/he.c b/drivers/atm/he.c
index b182c2f..1dfcc9a 100644
--- a/drivers/atm/he.c
+++ b/drivers/atm/he.c
@@ -1556,7 +1556,7 @@ he_stop(struct he_dev *he_dev)
 		gen_cntl_0 &= ~(INT_PROC_ENBL | INIT_ENB);
 		pci_write_config_dword(pci_dev, GEN_CNTL_0, gen_cntl_0);
 
-		tasklet_disable(&he_dev->tasklet);
+		tasklet_kill(&he_dev->tasklet);
 
 		/* disable recv and transmit */
 
-- 
1.7.9.5

