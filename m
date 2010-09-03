Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192Ab0ICQkS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 12:40:18 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:56721 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756125Ab0ICQkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 12:40:16 -0400
From: Borislav Petkov <bp@amd64.org>
To: Dave Airlie <airlied@redhat.com>, <hpa@zytor.com>, <mingo@elte.hu>,
        <tglx@linutronix.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: <akpm@linux-foundation.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 3/3] AGP: Warn when GATT memory cannot be set to UC
Date: Fri,  3 Sep 2010 18:39:41 +0200
Message-Id: <1283531981-7495-4-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1283531981-7495-1-git-send-email-bp@amd64.org>
References: <1283531981-7495-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

This is one of those paranoid checks which should at least tell us that
something is about to go haywire after we've disabled GART table walk
probes which is done by default now on AMD.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/char/agp/generic.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/char/agp/generic.c b/drivers/char/agp/generic.c
index d2abf51..64255ce 100644
--- a/drivers/char/agp/generic.c
+++ b/drivers/char/agp/generic.c
@@ -984,7 +984,9 @@ int agp_generic_create_gatt_table(struct agp_bridge_data *bridge)
 
 	bridge->driver->cache_flush();
 #ifdef CONFIG_X86
-	set_memory_uc((unsigned long)table, 1 << page_order);
+	if (set_memory_uc((unsigned long)table, 1 << page_order))
+		printk(KERN_WARNING "Could not set GATT table memory to UC!");
+
 	bridge->gatt_table = (void *)table;
 #else
 	bridge->gatt_table = ioremap_nocache(virt_to_phys(table),
-- 
1.7.1

