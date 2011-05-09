Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932492Ab1EIXRV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 19:17:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:60086 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755115Ab1EIXRU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 19:17:20 -0400
Date: Mon, 9 May 2011 23:17:15 GMT
From: tip-bot for Matthew Garrett <mjg@redhat.com>
Message-ID: <tip-202f9d0a41809e3424af5f61489b48b622824aed@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, mjg@redhat.com, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, mjg@redhat.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1304623186-18261-3-git-send-email-mjg@redhat.com>
References: <1304623186-18261-3-git-send-email-mjg@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/efi] x86, efi: Merge contiguous memory regions of the same type and attribute
Git-Commit-ID: 202f9d0a41809e3424af5f61489b48b622824aed
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 09 May 2011 23:17:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  202f9d0a41809e3424af5f61489b48b622824aed
Gitweb:     http://git.kernel.org/tip/202f9d0a41809e3424af5f61489b48b622824aed
Author:     Matthew Garrett <mjg@redhat.com>
AuthorDate: Thu, 5 May 2011 15:19:44 -0400
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 9 May 2011 12:14:34 -0700

x86, efi: Merge contiguous memory regions of the same type and attribute

Some firmware implementations assume that physically contiguous regions
will be contiguous in virtual address space. This assumption is, obviously,
entirely unjustifiable. Said firmware implementations lack the good grace
to handle their failings in a measured and reasonable manner, instead
tending to shit all over address space and oopsing the kernel.

In an ideal universe these firmware implementations would simultaneously
catch fire and cease to be a problem, but since some of them are present
in attractively thin and shiny metal devices vanity wins out and some
poor developer spends an extended period of time surrounded by a
growing array of empty bottles until the underlying reason becomes
apparent. Said developer presents this patch, which simply merges
adjacent regions if they happen to be contiguous and have the same EFI
memory type and caching attributes.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Link: http://lkml.kernel.org/r/1304623186-18261-3-git-send-email-mjg@redhat.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/platform/efi/efi.c |   30 +++++++++++++++++++++++++++++-
 1 files changed, 29 insertions(+), 1 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 7daae27..a46a73e 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -498,13 +498,41 @@ static void __init runtime_code_page_mkexec(void)
  */
 void __init efi_enter_virtual_mode(void)
 {
-	efi_memory_desc_t *md;
+	efi_memory_desc_t *md, *prev_md = NULL;
 	efi_status_t status;
 	unsigned long size;
 	u64 end, systab, addr, npages, end_pfn;
 	void *p, *va;
 
 	efi.systab = NULL;
+
+	/* Merge contiguous regions of the same type and attribute */
+	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
+		u64 prev_size;
+		md = p;
+
+		if (!prev_md) {
+			prev_md = md;
+			continue;
+		}
+
+		if (prev_md->type != md->type ||
+		    prev_md->attribute != md->attribute) {
+			prev_md = md;
+			continue;
+		}
+
+		prev_size = prev_md->num_pages << EFI_PAGE_SHIFT;
+
+		if (md->phys_addr == (prev_md->phys_addr + prev_size)) {
+			prev_md->num_pages += md->num_pages;
+			md->type = EFI_RESERVED_TYPE;
+			md->attribute = 0;
+			continue;
+		}
+		prev_md = md;
+	}
+
 	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
 		md = p;
 		if (!(md->attribute & EFI_MEMORY_RUNTIME))
