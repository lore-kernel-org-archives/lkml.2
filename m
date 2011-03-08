Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739Ab1CHSjW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 13:39:22 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34556 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753889Ab1CHSjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 13:39:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Tsxuk6x4Ued890sp7V5pBTrHHQ/nBTaAQ1btwlMzNyaVZNaXoeNw6FO0rf6y2J2EJJ
         ZVO8kgyMPGhb4fg348gAYJgKpeMUQgy35VHVCTj2RulGEP6slmwGutCY32Bw5Lz502cH
         gIUTvO7H71dczdiCtSLdE+g/YDy57cnsi1IKM=
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: linux-next <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Cc: Sedat Dilek <sedat.dilek@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, "H.J. Lu" <hjl.tools@gmail.com>,
        Jan Beulich <JBeulich@novell.com>,
        Stratos Psomadakis <psomas@cslab.ece.ntua.gr>
Subject: [PATCH] x86: Fix mismatched ENTRY/END pair
Date: Tue,  8 Mar 2011 19:39:03 +0100
Message-Id: <1299609543-18549-1-git-send-email-sedat.dilek@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With CONFIG_KVM_GUEST=y, the following part of entry_32.S causes this compile failure:
[...]
AS      arch/x86/kernel/entry_32.o
arch/x86/kernel/entry_32.S: Assembler messages:
arch/x86/kernel/entry_32.S:1421: Error: .size expression with symbol `apf_page_fault' does not evaluate to a constant

1409 #ifdef CONFIG_KVM_GUEST
1410 ENTRY(async_page_fault)
1411         RING0_EC_FRAME
1412         pushl $do_async_page_fault
1413         CFI_ADJUST_CFA_OFFSET 4
1414         jmp error_code
1415         CFI_ENDPROC
1416 END(apf_page_fault)
1417 #endif

Replace apf_page_fault with async_page_fault, as intended.

The problem occured with a binutils including PR gas/12519.
An output like above can be seen with a binutils from upstream containing:
commit b9521fc0be7945fc842ce1197e241a023378125d
"Mention symbol name in non-constant .size expression."

The issue was introduced by:
commit 631bc4878220932fe67fc46fc7cf7cccdb1ec597
"KVM: Handle async PF in a guest."

Thanks Alexander for providing a more descriptive text.

Acked-by: Alexander van Heukelum <heukelum@fastmail.fm>
CC: Ingo Molnar <mingo@elte.hu>
CC: H. Peter Anvin <hpa@zytor.com>
CC: H.J. Lu <hjl.tools@gmail.com>
CC: Jan Beulich <JBeulich@novell.com>
CC: Stratos Psomadakis <psomas@cslab.ece.ntua.gr>
Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
---
 arch/x86/kernel/entry_32.S |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 2878821..f7cffb2 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -1412,7 +1412,7 @@ ENTRY(async_page_fault)
 	pushl_cfi $do_async_page_fault
 	jmp error_code
 	CFI_ENDPROC
-END(apf_page_fault)
+END(async_page_fault)
 #endif
 
 /*
-- 
1.7.4.1

