Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610Ab1GNDiC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 23:38:02 -0400
Received: from hera.kernel.org ([140.211.167.34]:58681 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753491Ab1GNDiA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 23:38:00 -0400
Date: Thu, 14 Jul 2011 03:37:42 GMT
From: tip-bot for Tejun Heo <tj@kernel.org>
Message-ID: <tip-bf61549a2d8e0326f5d6e4d1718883a7212d725f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        benh@kernel.crashing.org, yinghai@kernel.org, tj@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, benh@kernel.crashing.org, tj@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1310457490-3356-2-git-send-email-tj@kernel.org>
References: <1310457490-3356-2-git-send-email-tj@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/memblock] x86: Fix memblock_x86_check_reserved_size() use in efi_reserve_boot_services()
Git-Commit-ID: bf61549a2d8e0326f5d6e4d1718883a7212d725f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 14 Jul 2011 03:37:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bf61549a2d8e0326f5d6e4d1718883a7212d725f
Gitweb:     http://git.kernel.org/tip/bf61549a2d8e0326f5d6e4d1718883a7212d725f
Author:     Tejun Heo <tj@kernel.org>
AuthorDate: Tue, 12 Jul 2011 09:58:05 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 13 Jul 2011 16:35:52 -0700

x86: Fix memblock_x86_check_reserved_size() use in efi_reserve_boot_services()

The return value of memblock_x86_check_reserved_size() doesn't
indicate whether there's an overlapping reservatoin or not.  It
indicates whether the caller needs to iterate further to discover all
reserved portions of the specified area.

efi_reserve_boot_esrvices() wants to check whether the boot services
area overlaps with other reservations but incorrectly used
membloc_x86_check_reserved_size().  Use memblock_is_region_reserved()
instead.

Signed-off-by: Tejun Heo <tj@kernel.org>
Link: http://lkml.kernel.org/r/1310457490-3356-2-git-send-email-tj@kernel.org
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/platform/efi/efi.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 899e393..a4c322c 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -325,8 +325,7 @@ void __init efi_reserve_boot_services(void)
 		if ((start+size >= virt_to_phys(_text)
 				&& start <= virt_to_phys(_end)) ||
 			!e820_all_mapped(start, start+size, E820_RAM) ||
-			memblock_x86_check_reserved_size(&start, &size,
-							1<<EFI_PAGE_SHIFT)) {
+			memblock_is_region_reserved(start, size)) {
 			/* Could not reserve, skip it */
 			md->num_pages = 0;
 			memblock_dbg(PFX "Could not reserve boot range "
