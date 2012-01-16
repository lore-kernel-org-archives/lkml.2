Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308Ab2APEF7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 23:05:59 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:17146 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753124Ab2APEF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 23:05:58 -0500
From: Maxim Uvarov <maxim.uvarov@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, wim@iguana.be, torvalds@linux-foundation.org,
        stable@vger.kernel.org, Thomas.Mingarelli@hp.com,
        Maxim Uvarov <maxim.uvarov@oracle.com>
Subject: [PATCH] hpwdt: clean up set_memory_x call for 32 bit
Date: Sun, 15 Jan 2012 20:02:50 -0800
Message-Id: <1326686570-19303-2-git-send-email-maxim.uvarov@oracle.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1326686570-19303-1-git-send-email-maxim.uvarov@oracle.com>
References: <1326686570-19303-1-git-send-email-maxim.uvarov@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090209.4F13A219.001E,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. addess has to be page aligned.
2. set_memory_x uses page size argument, not size.
Bug causes with following commit:
	commit da28179b4e90dda56912ee825c7eaa62fc103797
	Author: Mingarelli, Thomas <Thomas.Mingarelli@hp.com>
	Date:   Mon Nov 7 10:59:00 2011 +0100

     watchdog: hpwdt: Changes to handle NX secure bit in 32bit path

    commit e67d668e147c3b4fec638c9e0ace04319f5ceccd upstream.

    This patch makes use of the set_memory_x() kernel API in order
    to make necessary BIOS calls to source NMIs.

Signed-off-by: Maxim Uvarov <maxim.uvarov@oracle.com>
---
 drivers/watchdog/hpwdt.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
index 9cb60df..7f04d37 100644
--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -216,7 +216,7 @@ static int __devinit cru_detect(unsigned long map_entry,
 
 	cmn_regs.u1.reax = CRU_BIOS_SIGNATURE_VALUE;
 
-	set_memory_x((unsigned long)bios32_entrypoint, (2 * PAGE_SIZE));
+	set_memory_x((unsigned long)bios32_entrypoint & PAGE_MASK, 2);
 	asminline_call(&cmn_regs, bios32_entrypoint);
 
 	if (cmn_regs.u1.ral != 0) {
@@ -235,7 +235,7 @@ static int __devinit cru_detect(unsigned long map_entry,
 			cru_rom_addr =
 				ioremap(cru_physical_address, cru_length);
 			if (cru_rom_addr) {
-				set_memory_x((unsigned long)cru_rom_addr, cru_length);
+				set_memory_x((unsigned long)cru_rom_addr & PAGE_MASK, cru_length >> PAGE_SHIFT);
 				retval = 0;
 			}
 		}
-- 
1.7.4.1

