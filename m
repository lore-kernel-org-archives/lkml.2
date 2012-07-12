Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162081Ab2GLXB5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 19:01:57 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60450 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162013Ab2GLWmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:42:43 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mark Rustad <mark.d.rustad@intel.com>,
        Ross Brattain <ross.b.brattain@intel.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [ 124/187] tcm_fc: Resolve suspicious RCU usage warnings
Date: Thu, 12 Jul 2012 15:34:40 -0700
Message-Id: <20120712191533.869731231@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.742634173@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.742634173@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Rustad <mark.d.rustad@intel.com>

commit 863555be0c81558b1af277addcf68acb8f778860 upstream.

Use rcu_dereference_protected to tell rcu that the ft_lport_lock
is held during ft_lport_create. This resolved "suspicious RCU usage"
warnings when debugging options are turned on.

Signed-off-by: Mark Rustad <mark.d.rustad@intel.com>
Tested-by: Ross Brattain <ross.b.brattain@intel.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/tcm_fc/tfc_sess.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/target/tcm_fc/tfc_sess.c
+++ b/drivers/target/tcm_fc/tfc_sess.c
@@ -58,7 +58,8 @@ static struct ft_tport *ft_tport_create(
 	struct ft_tport *tport;
 	int i;
 
-	tport = rcu_dereference(lport->prov[FC_TYPE_FCP]);
+	tport = rcu_dereference_protected(lport->prov[FC_TYPE_FCP],
+					  lockdep_is_held(&ft_lport_lock));
 	if (tport && tport->tpg)
 		return tport;
 


