Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965007Ab2KVS6w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:58:52 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37038 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964933Ab2KVS6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:58:47 -0500
Date: Wed, 21 Nov 2012 17:47:49 -0800
From: tip-bot for Jacob Shin <jacob.shin@amd.com>
Message-ID: <tip-4eea6aa581abfeb2695ebe9f9d4672597e1bdd4b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, penberg@kernel.org, jacob.shin@amd.com,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, penberg@kernel.org, jacob.shin@amd.com,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1353123563-3103-11-git-send-email-yinghai@kernel.org>
References: <1353123563-3103-11-git-send-email-yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm2] x86, mm:
  if kernel .text .data .bss are not marked as E820_RAM, complain and fix
Git-Commit-ID: 4eea6aa581abfeb2695ebe9f9d4672597e1bdd4b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 21 Nov 2012 17:47:54 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4eea6aa581abfeb2695ebe9f9d4672597e1bdd4b
Gitweb:     http://git.kernel.org/tip/4eea6aa581abfeb2695ebe9f9d4672597e1bdd4b
Author:     Jacob Shin <jacob.shin@amd.com>
AuthorDate: Fri, 16 Nov 2012 19:38:47 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Sat, 17 Nov 2012 11:59:08 -0800

x86, mm: if kernel .text .data .bss are not marked as E820_RAM, complain and fix

There could be cases where user supplied memmap=exactmap memory
mappings do not mark the region where the kernel .text .data and
.bss reside as E820_RAM, as reported here:

https://lkml.org/lkml/2012/8/14/86

Handle it by complaining, and adding the range back into the e820.

Signed-off-by: Jacob Shin <jacob.shin@amd.com>
Link: http://lkml.kernel.org/r/1353123563-3103-11-git-send-email-yinghai@kernel.org
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/setup.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 4bd8921..d85cbd9 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -832,6 +832,20 @@ void __init setup_arch(char **cmdline_p)
 	insert_resource(&iomem_resource, &data_resource);
 	insert_resource(&iomem_resource, &bss_resource);
 
+	/*
+	 * Complain if .text .data and .bss are not marked as E820_RAM and
+	 * attempt to fix it by adding the range. We may have a confused BIOS,
+	 * or the user may have incorrectly supplied it via memmap=exactmap. If
+	 * we really are running on top non-RAM, we will crash later anyways.
+	 */
+	if (!e820_all_mapped(code_resource.start, __pa(__brk_limit), E820_RAM)) {
+		pr_warn(".text .data .bss are not marked as E820_RAM!\n");
+
+		e820_add_region(code_resource.start,
+				__pa(__brk_limit) - code_resource.start + 1,
+				E820_RAM);
+	}
+
 	trim_bios_range();
 #ifdef CONFIG_X86_32
 	if (ppro_with_ram_bug()) {
