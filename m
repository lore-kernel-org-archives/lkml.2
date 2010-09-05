Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754352Ab0IENFu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 09:05:50 -0400
Received: from hera.kernel.org ([140.211.167.34]:53154 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753739Ab0IENFt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 09:05:49 -0400
Date: Sun, 5 Sep 2010 13:05:20 GMT
From: tip-bot for Borislav Petkov <borislav.petkov@amd.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        fujita.tomonori@lab.ntt.co.jp, airlied@redhat.com, tglx@linutronix.de,
        borislav.petkov@amd.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fujita.tomonori@lab.ntt.co.jp, airlied@redhat.com, tglx@linutronix.de,
        borislav.petkov@amd.com, mingo@elte.hu
In-Reply-To: <1283531981-7495-4-git-send-email-bp@amd64.org>
References: <1283531981-7495-4-git-send-email-bp@amd64.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/iommu] AGP: Warn when GATT memory cannot be set to UC
Message-ID: <tip-1b13fe6a6e9986dbc079cbb05090be75edbffa5d@git.kernel.org>
Git-Commit-ID: 1b13fe6a6e9986dbc079cbb05090be75edbffa5d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 05 Sep 2010 13:05:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1b13fe6a6e9986dbc079cbb05090be75edbffa5d
Gitweb:     http://git.kernel.org/tip/1b13fe6a6e9986dbc079cbb05090be75edbffa5d
Author:     Borislav Petkov <borislav.petkov@amd.com>
AuthorDate: Fri, 3 Sep 2010 18:39:41 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 5 Sep 2010 14:28:34 +0200

AGP: Warn when GATT memory cannot be set to UC

This is one of those paranoid checks which should at least tell
us that something is about to go haywire after we've disabled
GART table walk probes which is done by default now on AMD.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Cc: Dave Airlie <airlied@redhat.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
LKML-Reference: <1283531981-7495-4-git-send-email-bp@amd64.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
