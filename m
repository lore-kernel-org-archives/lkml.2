Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617Ab2H2TGl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 15:06:41 -0400
Received: from db3ehsobe002.messaging.microsoft.com ([213.199.154.140]:8204
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754503Ab2H2TEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 15:04:33 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 8
X-BigFish: VPS8(z37d4l1036lzzz1202hzz8275bh8275dhz2dh668h839hd24he5bhf0ah107ah1155h)
X-WSS-ID: 0M9J6BC-01-8HS-02
X-M-MSG: 
From: Jacob Shin <jacob.shin@amd.com>
To: X86-ML <x86@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Yinghai Lu <yinghai@kernel.org>, Tejun Heo <tj@kernel.org>,
        Dave Young <dyoung@redhat.com>, Chao Wang <chaowang@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Jacob Shin <jacob.shin@amd.com>
Subject: [PATCH 6/6] x86: if kernel .text .data .bss are not marked as E820_RAM, complain and fix
Date: Wed, 29 Aug 2012 14:04:06 -0500
Message-ID: <1346267046-6724-7-git-send-email-jacob.shin@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1346267046-6724-1-git-send-email-jacob.shin@amd.com>
References: <1346267046-6724-1-git-send-email-jacob.shin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There could be cases where user supplied memmap=exactmap memory
mappings do not mark the region where the kernel .text .data and
.bss reside as E820_RAM, as reported here:

https://lkml.org/lkml/2012/8/14/86

Handle it by complaining, and adding the range back into the e820.

Signed-off-by: Jacob Shin <jacob.shin@amd.com>
---
 arch/x86/kernel/setup.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index a2e392e..68f82d2 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -913,6 +913,20 @@ void __init setup_arch(char **cmdline_p)
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
-- 
1.7.9.5


