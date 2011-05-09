Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932522Ab1EIXSN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 19:18:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:60112 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932436Ab1EIXSL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 19:18:11 -0400
Date: Mon, 9 May 2011 23:18:03 GMT
From: tip-bot for Matthew Garrett <mjg@redhat.com>
Message-ID: <tip-935a638241b0658b9749edd060f972575f9d4a78@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, mjg@redhat.com, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, mjg@redhat.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1304623186-18261-5-git-send-email-mjg@redhat.com>
References: <1304623186-18261-5-git-send-email-mjg@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/efi] x86, efi: Ensure that the entirity of a region is mapped
Git-Commit-ID: 935a638241b0658b9749edd060f972575f9d4a78
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 09 May 2011 23:18:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  935a638241b0658b9749edd060f972575f9d4a78
Gitweb:     http://git.kernel.org/tip/935a638241b0658b9749edd060f972575f9d4a78
Author:     Matthew Garrett <mjg@redhat.com>
AuthorDate: Thu, 5 May 2011 15:19:46 -0400
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 9 May 2011 12:14:45 -0700

x86, efi: Ensure that the entirity of a region is mapped

It's possible for init_memory_mapping() to fail to map the entire region
if it crosses a boundary, so ensure that we complete the mapping.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Link: http://lkml.kernel.org/r/1304623186-18261-5-git-send-email-mjg@redhat.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/platform/efi/efi_64.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index 94d6b39..2649426 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -89,8 +89,10 @@ void __iomem *__init efi_ioremap(unsigned long phys_addr, unsigned long size,
 		return ioremap(phys_addr, size);
 
 	last_map_pfn = init_memory_mapping(phys_addr, phys_addr + size);
-	if ((last_map_pfn << PAGE_SHIFT) < phys_addr + size)
-		return NULL;
+	if ((last_map_pfn << PAGE_SHIFT) < phys_addr + size) {
+		unsigned long top = last_map_pfn << PAGE_SHIFT;
+		efi_ioremap(top, size - (top - phys_addr), type);
+	}
 
 	return (void __iomem *)__va(phys_addr);
 }
