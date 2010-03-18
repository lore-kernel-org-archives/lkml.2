Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037Ab0CRR7p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 13:59:45 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:37163 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753755Ab0CRR7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 13:59:42 -0400
Subject: [PATCH v2 3/4] hpet: clean up io mapping when hpet_alloc() fails
To: Clemens Ladisch <clemens@ladisch.de>
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Venkatesh Pallipadi <venki@google.com>, Vojtech Pavlik <vojtech@suse.cz>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Date: Thu, 18 Mar 2010 11:59:40 -0600
Message-ID: <20100318175940.15143.53027.stgit@bob.kio>
In-Reply-To: <20100318175852.15143.2124.stgit@bob.kio>
References: <20100318175852.15143.2124.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When hpet_alloc() fails, we should iounmap() the timer so we don't leak
the mapping.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---

 drivers/char/hpet.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)


diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
index d132fef..8961985 100644
--- a/drivers/char/hpet.c
+++ b/drivers/char/hpet.c
@@ -904,7 +904,7 @@ static int hpet_pnp_add(struct pnp_dev *dev, const struct pnp_device_id *dev_id)
 {
 	struct hpet_data data;
 	struct resource *mem, *irq;
-	int i;
+	int i, ret;
 
 	memset(&data, 0, sizeof(data));
 
@@ -924,7 +924,11 @@ static int hpet_pnp_add(struct pnp_dev *dev, const struct pnp_device_id *dev_id)
 	data.hd_phys_address = mem->start;
 	data.hd_address = ioremap(mem->start, resource_size(mem));
 
-	return hpet_alloc(&data);
+	ret = hpet_alloc(&data);
+	if (ret)
+		iounmap(data.hd_address);
+
+	return ret;
 }
 
 static void hpet_pnp_remove(struct pnp_dev *dev)

