Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357Ab1KQI2A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 03:28:00 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:35952 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828Ab1KQI17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 03:27:59 -0500
Date: Thu, 17 Nov 2011 16:26:24 +0800
From: wangyanqing <udknight@gmail.com>
To: torvalds@linux-foundation.org
Cc: castet.matthieu@free.fr, akpm@linux-foundation.org, hpa@zytor.com,
        x86@kernel.org, spock@gentoo.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] x86: remove NX from video bios area
Message-ID: <20111117082624.GA4136@udknight.homenetwork>
Mail-Followup-To: wangyanqing <Udknight@gmail.com>,
	torvalds@linux-foundation.org, castet.matthieu@free.fr,
	akpm@linux-foundation.org, hpa@zytor.com, x86@kernel.org,
	spock@gentoo.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

5bd5a452662bc37c54fb6828db1a3faf87e6511c make area
between BIOS_BEGIN and BIOS_END NX when boot machine
with ACPI enable.

It make my machine can't boot, system hang with black
screen very early.

The more detail, please see:
https://lkml.org/lkml/2011/11/16/84

This patch try to resolve it. Any comment is welcome.
Signed-off-by: Wang YanQing <Udknight@gmail.com>
---
 arch/x86/include/asm/e820.h |    4 ++++
 arch/x86/mm/pageattr.c      |    6 ++++++
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/e820.h b/arch/x86/include/asm/e820.h
index 908b969..1adc26e 100644
--- a/arch/x86/include/asm/e820.h
+++ b/arch/x86/include/asm/e820.h
@@ -72,6 +72,10 @@ struct e820map {
 #define BIOS_BEGIN		0x000a0000
 #define BIOS_END		0x00100000
 
+/*we hope this the right video bios range*/
+#define VIDEO_BIOS_BEGIN	0x000c0000
+#define VIDEO_BIOS_END		0x000c7fff
+
 #define BIOS_ROM_BASE		0xffe00000
 #define BIOS_ROM_END		0xffffffff
 
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index f9e5267..c4e5100 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -263,6 +263,12 @@ static inline pgprot_t static_protections(pgprot_t prot, unsigned long address,
 	if (pcibios_enabled && within(pfn, BIOS_BEGIN >> PAGE_SHIFT, BIOS_END >> PAGE_SHIFT))
 		pgprot_val(forbidden) |= _PAGE_NX;
 #endif
+	/*The video bios area needs to be executable for
+	 *some programs(like v86d for uvesafb) to execute
+	 *video bios functions
+	 */
+	if (!pcibios_enable && within(pfn, VIDEO_BIOS_BEGIN >> PAGE_SHIFT, VIDEO_BIOS_END >> PAGE_SHIFT))
+		pgprot_val(forbidden) |= _PAGE_NX;
 
 	/*
 	 * The kernel text needs to be executable for obvious reasons
-- 
1.7.3.4

