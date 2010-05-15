Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299Ab0EOT5W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 15:57:22 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37833 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792Ab0EOT5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 15:57:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:date:subject:mime-version:x-tuid:x-uid:x-length:to
         :reply-to:content-type:content-transfer-encoding:message-id;
        b=HvFZCzoLZ8H5qfU6f7aI+/z2iNNKKZip/pTKoLMMSgDYmPk4q8sNbi2oR9S190sr0J
         M+jGD4DRPA14H18RZAexPnDnY80UUI8nLO42MZo4w82cTfVS53yzjkWDGieKxE3Hcsdl
         GYFpLod8DssNy3wYt73fJi/OddUWn1cvZrKOI=
From: Florian Fainelli <florian@openwrt.org>
Date: Sat, 15 May 2010 21:57:10 +0200
Subject: [PATCH] MFD: prevent null pointer dereference in mfd_add_device
MIME-Version: 1.0
X-TUID: 1c1f2082a0eff895
X-Length: 1605
To: Samuel Ortiz <sameo@linux.intel.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Reply-To: Florian Fainelli <florian@openwrt.org>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201005152157.13121.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a driver calls mfd_add_device with a NULL argument for the mem_base resource
we will end up dereferencing it without checking for its validity here:
res[r].start = mem_base->start cell->resources[r].start; (line 53 of mfd-core.c)

This patch adds the checking on the mem_base argument and bails out accordingly
if it is NULL.

Signed-off-by: Florian Fainelli <florian@openwrt.org>
CC: stable@kernel.org
---
diff --git a/drivers/mfd/mfd-core.c b/drivers/mfd/mfd-core.c
index 8ffbb7a..f890b27 100644
--- a/drivers/mfd/mfd-core.c
+++ b/drivers/mfd/mfd-core.c
@@ -49,6 +49,8 @@ static int mfd_add_device(struct device *parent, int id,
 
 		/* Find out base to use */
 		if (cell->resources[r].flags & IORESOURCE_MEM) {
+			if (!mem_base)
+				goto fail_res;
 			res[r].parent = mem_base;
 			res[r].start = mem_base->start +
 				cell->resources[r].start;
