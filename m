Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751410Ab0KQFLV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 00:11:21 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:44715 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859Ab0KQFLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 00:11:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=xMGwj/830EuP/qrh53IGogbm7IW5QyJo72sdeTV07eeJUNHfTtbzMkeAxE+TIqwrHt
         qVj+93yTV9GkOL+0jUKQRmERPfLYWMA3DreZooMW5oOHcLSUUl3Ku+tMwBWtLnqYA3ib
         YYYuLvQfy077XVfYicqSMou4bmbYLoEu933ik=
Date: Wed, 17 Nov 2010 08:10:32 +0300
From: Dan Carpenter <error27@gmail.com>
To: Maciej Sosnowski <maciej.sosnowski@intel.com>
Cc: "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] dca: missing unlock in unregister_dca_providers()
Message-ID: <20101117051032.GC31724@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Maciej Sosnowski <maciej.sosnowski@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We return here with the lock held and IRQs disabled by mistake.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/dca/dca-core.c b/drivers/dca/dca-core.c
index b98c676..b4c95be 100644
--- a/drivers/dca/dca-core.c
+++ b/drivers/dca/dca-core.c
@@ -110,8 +110,10 @@ static void unregister_dca_providers(void)
 
 	/* at this point only one domain in the list is expected */
 	domain = list_first_entry(&dca_domains, struct dca_domain, node);
-	if (!domain)
+	if (!domain) {
+		spin_unlock_irqrestore(&dca_lock, flags);
 		return;
+	}
 
 	list_for_each_entry_safe(dca, _dca, &domain->dca_providers, node) {
 		list_del(&dca->node);
