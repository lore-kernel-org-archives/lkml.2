Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297Ab1ABHzr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:55:47 -0500
Received: from mail.windriver.com ([147.11.1.11]:35437 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753655Ab1ABHXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:23:16 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 112/260] irda: Correctly clean up self->ias_obj on irda_bind() failure.
Date: Sun,  2 Jan 2011 02:16:48 -0500
Message-Id: <1293952756-15010-113-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:22:12.0368 (UTC) FILETIME=[C6249100:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David S. Miller <davem@davemloft.net>

commit 628e300cccaa628d8fb92aa28cb7530a3d5f2257 upstream.

If irda_open_tsap() fails, the irda_bind() code tries to destroy
the ->ias_obj object by hand, but does so wrongly.

In particular, it fails to a) release the hashbin attached to the
object and b) reset the self->ias_obj pointer to NULL.

Fix both problems by using irias_delete_object() and explicitly
setting self->ias_obj to NULL, just as irda_release() does.

Reported-by: Tavis Ormandy <taviso@cmpxchg8b.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/irda/af_irda.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/irda/af_irda.c b/net/irda/af_irda.c
index 2a4efce..6fae047 100644
--- a/net/irda/af_irda.c
+++ b/net/irda/af_irda.c
@@ -824,8 +824,8 @@ static int irda_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 
 	err = irda_open_tsap(self, addr->sir_lsap_sel, addr->sir_name);
 	if (err < 0) {
-		kfree(self->ias_obj->name);
-		kfree(self->ias_obj);
+		irias_delete_object(self->ias_obj);
+		self->ias_obj = NULL;
 		goto out;
 	}
 
-- 
1.7.3.3

