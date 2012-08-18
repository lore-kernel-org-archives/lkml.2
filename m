Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329Ab2HRMJL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 08:09:11 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:38514 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750878Ab2HRMJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 08:09:07 -0400
From: Denis Efremov <yefremov.denis@gmail.com>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Denis Efremov <yefremov.denis@gmail.com>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Jesper Juhl <jj@chaosbits.net>, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@ispras.ru
Subject: [PATCH] tcm_fc: rcu_deref outside rcu lock/unlock section
Date: Sat, 18 Aug 2012 16:10:31 +0400
Message-Id: <1345291831-5086-1-git-send-email-yefremov.denis@gmail.com>
X-Mailer: git-send-email 1.7.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use rcu_dereference_protected in order to prevent lockdep
complaint. Sequel of the patch 863555be

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Denis Efremov <yefremov.denis@gmail.com>
---
 drivers/target/tcm_fc/tfc_sess.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/target/tcm_fc/tfc_sess.c b/drivers/target/tcm_fc/tfc_sess.c
index 87901fa..3c9e5b5 100644
--- a/drivers/target/tcm_fc/tfc_sess.c
+++ b/drivers/target/tcm_fc/tfc_sess.c
@@ -456,7 +456,9 @@ static void ft_prlo(struct fc_rport_priv *rdata)
 	struct ft_tport *tport;
 
 	mutex_lock(&ft_lport_lock);
-	tport = rcu_dereference(rdata->local_port->prov[FC_TYPE_FCP]);
+	tport = rcu_dereference_protected(rdata->local_port->prov[FC_TYPE_FCP],
+					  lockdep_is_held(&ft_lport_lock));
+
 	if (!tport) {
 		mutex_unlock(&ft_lport_lock);
 		return;
-- 
1.7.7

