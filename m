Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418Ab1DQOfl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 10:35:41 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43465 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240Ab1DQOff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 10:35:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=oqK0vALAVYSDWHiT9luPNbJeVQ4QC6ITXrE7hl/4D1pmYlIpHSxs+kqLBsFuNwMEdd
         O0zM29O1bMqrCQ5JDVhYgDLsU7cDzPnliPgn/jcITPguJl+/dqNEaW5HV0MsVXRe7LfH
         vWFSamCEa3pVUQTTHEx/Urdya2qHtF1NNzCaQ=
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, yinghai@kernel.org,
        stefano.stabellini@eu.citrix.com, castet.matthieu@free.fr
Cc: Sedat Dilek <sedat.dilek@gmail.com>, "PaX" <pageexec@freemail.hu>
Subject: [PATCH -next] x86/mm: Fix section mismatch derived from native_pagetable_reserve()
Date: Sun, 17 Apr 2011 16:35:08 +0200
Message-Id: <1303050908-32539-1-git-send-email-sedat.dilek@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With CONFIG_DEBUG_SECTION_MISMATCH=y I see these warnings in next-20110415:

  LD      vmlinux.o
  MODPOST vmlinux.o
WARNING: vmlinux.o(.text+0x1ba48): Section mismatch in reference from the function native_pagetable_reserve() to the function .init.text:memblock_x86_reserve_range()
The function native_pagetable_reserve() references
the function __init memblock_x86_reserve_range().
This is often because native_pagetable_reserve lacks a __init
annotation or the annotation of memblock_x86_reserve_range is wrong.

This patch fixes the issue.
Thanks to pipacs from PaX project for help on IRC.

Cc: "PaX" <pageexec@freemail.hu>
Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
---
 arch/x86/mm/init.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index ed0650b..ae1ff24 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -81,7 +81,7 @@ static void __init find_early_table_space(unsigned long end, int use_pse,
 		end, pgt_buf_start << PAGE_SHIFT, pgt_buf_top << PAGE_SHIFT);
 }
 
-void native_pagetable_reserve(u64 start, u64 end)
+void __init native_pagetable_reserve(u64 start, u64 end)
 {
 	memblock_x86_reserve_range(start, end, "PGTABLE");
 }
-- 
1.7.4.4

