Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761996Ab0GUBWZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 21:22:25 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:41862 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761974Ab0GUBWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 21:22:22 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4C464BA0.20609@jp.fujitsu.com>
Date: Wed, 21 Jul 2010 10:21:36 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: linux-scsi@vger.kernel.org, James Smart <james.smart@emulex.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Brian Gerst <brgerst@gmail.com>
Subject: [PATCH] BISECTED x86: avoid qword access in memcpy_*io
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With v2.6.35-rc5, my x86-64 server doesn't boot but reports a
Completer Abort on lpfc card.

The result of git-bisect is:
  6175ddf06b6172046a329e3abfd9c901a43efd2e is the first bad commit
  commit 6175ddf06b6172046a329e3abfd9c901a43efd2e
  Author: Brian Gerst <brgerst@gmail.com>
  Date:   Fri Feb 5 09:37:07 2010 -0500
    x86: Clean up mem*io functions.

What I found are:
 - memcpy for 64bit uses movq if count >= 64 (arch/x86/lib/memcpy_64.S)
 - memcpy_toio and memcpy_fromio have changed to use this memcpy by
   the above commit.
 - my debug shows that lpfc calls memcpy_toio with not-qword-aligned
   addresses and count >= 64, e.g.:
     memcpy_toio(0xffffc900118de004, 0xffff88047293d614, 124);
   and it seems that it comes from:
   [drivers/scsi/lpfc/lpfc_sli.c]
    4929   /* First copy mbox command data to HBA SLIM, skip past first
    4930      word */
    4931   to_slim = phba->MBslimaddr + sizeof (uint32_t);
    4932   lpfc_memcpy_to_slim(to_slim, &mb->un.varWords[0],
    4933               MAILBOX_CMD_SIZE - sizeof (uint32_t));

Still I'm not sure what is wrong in software or hardware, however
I suppose that qword access to iomem is not always safe, so it will
be OK to back to use __inline_memcpy which uses movsl.

I confirmed that my server (w/ lpfc) boots with 35-rc5 + this patch.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 arch/x86/include/asm/io.h |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/io.h b/arch/x86/include/asm/io.h
index 30a3e97..e15a74a 100644
--- a/arch/x86/include/asm/io.h
+++ b/arch/x86/include/asm/io.h
@@ -227,13 +227,21 @@ memset_io(volatile void __iomem *addr, unsigned char val, size_t count)
 static inline void
 memcpy_fromio(void *dst, const volatile void __iomem *src, size_t count)
 {
+#ifdef CONFIG_X86_64
+	__inline_memcpy(dst, (const void __force *)src, count);
+#else
 	memcpy(dst, (const void __force *)src, count);
+#endif
 }
 
 static inline void
 memcpy_toio(volatile void __iomem *dst, const void *src, size_t count)
 {
+#ifdef CONFIG_X86_64
+	__inline_memcpy((void __force *)dst, src, count);
+#else
 	memcpy((void __force *)dst, src, count);
+#endif
 }
 
 /*
-- 
1.7.1.1


