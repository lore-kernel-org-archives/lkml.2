Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791Ab2GIOq3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 10:46:29 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38161 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754368Ab2GIOiC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 10:38:02 -0400
Message-Id: <20120709143123.361976495@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 09 Jul 2012 15:32:03 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Mark Rustad <mark.d.rustad@intel.com>,
        Ross Brattain <ross.b.brattain@intel.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [ 47/48] tcm_fc: Resolve suspicious RCU usage warnings
In-Reply-To: <20120709143116.348975190@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Rustad <mark.d.rustad@intel.com>

commit 863555be0c81558b1af277addcf68acb8f778860 upstream.

Use rcu_dereference_protected to tell rcu that the ft_lport_lock
is held during ft_lport_create. This resolved "suspicious RCU usage"
warnings when debugging options are turned on.

Signed-off-by: Mark Rustad <mark.d.rustad@intel.com>
Tested-by: Ross Brattain <ross.b.brattain@intel.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/target/tcm_fc/tfc_sess.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/target/tcm_fc/tfc_sess.c b/drivers/target/tcm_fc/tfc_sess.c
index cb99da9..87901fa 100644
--- a/drivers/target/tcm_fc/tfc_sess.c
+++ b/drivers/target/tcm_fc/tfc_sess.c
@@ -58,7 +58,8 @@ static struct ft_tport *ft_tport_create(struct fc_lport *lport)
 	struct ft_tport *tport;
 	int i;
 
-	tport = rcu_dereference(lport->prov[FC_TYPE_FCP]);
+	tport = rcu_dereference_protected(lport->prov[FC_TYPE_FCP],
+					  lockdep_is_held(&ft_lport_lock));
 	if (tport && tport->tpg)
 		return tport;
 


