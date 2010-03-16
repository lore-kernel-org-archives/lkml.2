Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716Ab0CPLql (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 07:46:41 -0400
Received: from mail-gx0-f217.google.com ([209.85.217.217]:39733 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377Ab0CPLqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 07:46:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=NlbY+Be/UHDXd1AwueStFwBVpOU+rB96T7ahthHHJdEDQnfDfZUEq2gJSb0VGgNval
         aONxKrjx58mI/IWoDEmk7FVvrPkg/L6+Z+CJjPFr9XXx3k2U5iakFlntn/Cb/wAU5urY
         5cK7rrFzpKomjJiQaqAFta+TZMJ/fJm/d8DgM=
Subject: [PATCH] drivers/net/wimax/i2400m/fw.c fix possible double free
From: Darren Jenkins <darrenrjenkins@gmail.com>
To: Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>,
       linux-wimax@intel.com,
       Kernel Janitors <kernel-janitors@vger.kernel.org>
Cc: Cindy H Kao <cindy.h.kao@intel.com>,
       Dirk Brandewie <dirk.j.brandewie@intel.com>, wimax@linuxwimax.org,
       netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Mar 2010 22:46:28 +1100
Message-ID: <1268739988.17270.8.camel@ICE-BOX>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i2400m_fw_check() can free i2400m->fw_hdrs if krealloc() fails causing a double free
Add a check so we don't free the memory a second time.

coverity CID: 13455

Signed-off-by: Darren Jenkins <darrenrjenkins@gmail.com>
---
 drivers/net/wimax/i2400m/fw.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wimax/i2400m/fw.c b/drivers/net/wimax/i2400m/fw.c
index 25c24f0..a97c413 100644
--- a/drivers/net/wimax/i2400m/fw.c
+++ b/drivers/net/wimax/i2400m/fw.c
@@ -1490,7 +1490,8 @@ int i2400m_fw_bootstrap(struct i2400m *i2400m, const struct firmware *fw,
 	if (ret < 0)
 		dev_err(dev, "%s: cannot use: %d, skipping\n",
 			i2400m->fw_name, ret);
-	kfree(i2400m->fw_hdrs);
+	if (ret != -ENOMEM)
+		kfree(i2400m->fw_hdrs);
 	i2400m->fw_hdrs = NULL;
 	d_fnend(5, dev, "(i2400m %p) = %d\n", i2400m, ret);
 	return ret;
-- 
1.6.3.3



