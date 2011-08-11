Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755422Ab1HKAoc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 20:44:32 -0400
Received: from DMZ-MAILSEC-SCANNER-4.MIT.EDU ([18.9.25.15]:43221 "EHLO
	dmz-mailsec-scanner-4.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753542Ab1HKAob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 20:44:31 -0400
X-AuditID: 1209190f-b7b44ae000000a24-bf-4e4325572f3f
From: Andy Lutomirski <luto@MIT.EDU>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@MIT.EDU>
Subject: [MINIMAL BACKPORT] x86-64: Fix garbage at the end of the vdso mapping
Date: Wed, 10 Aug 2011 20:44:24 -0400
Message-Id: <463ff0f1c8f6f1ae4d0d0e26a7e71aea9ff03b9d.1313023219.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNIsWRmVeSWpSXmKPExsUixCmqrRuu6uxn0PiVx6LvylF2i2kbxS0u
	75rDZvFjw2NWBxaPnbPusntsWtXJ5vF5k5zHiZYvrAEsUVw2Kak5mWWpRfp2CVwZF//eYyr4
	yFNx68965gbGlVxdjJwcEgImEr837WaHsMUkLtxbz9bFyMUhJLCPUaJp3RUmCGcDo0TzkzYo
	5xmTxMTzBxhBWtgEVCQ6lj5gArFFgOzpPz+B2cwCkRIXnqxmAbGFBfwkNu5qAqtnEVCVWDX9
	PCuIzSsQJPH/+wdmiNVyEkcuP2eawMizgJFhFaNsSm6Vbm5iZk5xarJucXJiXl5qka6JXm5m
	iV5qSukmRnCYSPLvYPx2UOkQowAHoxIPL+NqJz8h1sSy4srcQ4ySHExKorz+Ss5+QnxJ+SmV
	GYnFGfFFpTmpxYcYJTiYlUR4peYBlfOmJFZWpRblw6SkOViUxHkbdzj4CQmkJ5akZqemFqQW
	wWRlODiUJHi1gPEgJFiUmp5akZaZU4KQZuLgBBnOAzT8igpQDW9xQWJucWY6RP4Uo6KUOK8J
	SLMASCKjNA+uFxbHrxjFgV4R5vUDqeIBpgC47ldAg5mABtffcQAZXJKIkJJqYOSc4zBZ8G+d
	bnz2ycrglTlzSt6EHMp+tTywvrF46p2ZNyWcZQS38F7T8Xc8wr+q0vrhWftLt3kunWBcHfBE
	JVdswmapedvYPng+Vk32uJTb8EFHduVVt94P9+7M7Ol5G6PwrEc6a+3TWvmOfzuKz1ruj22o
	O/LzVELBhQumVTOWTFeLE7i/pE6JpTgj0VCLuag4EQAKMVVbvgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The vdso mapping has a bunch of random garbage at the end of it,
because the code that copies the vdso from the kernel image uses
copy_page to copy unaligned data that isn't actually one page long.

This is a trivial fix that just aligns and pags the source data.
The same bug is fixed in 3.1 by:

commit aafade242ff24fac3aabf61c7861dfa44a3c2445
Author: Andy Lutomirski <luto@mit.edu>
Date:   Thu Jul 21 15:47:10 2011 -0400

    x86-64, vdso: Do not allocate memory for the vDSO

commit 1bdfac19b3ecfca545281c15c7aea7ebc2eaef31
Author: Andy Lutomirski <luto@MIT.EDU>
Date:   Wed Aug 3 09:31:49 2011 -0400

    x86-64: Pad vDSO to a page boundary

Signed-off-by: Andy Lutomirski <luto@mit.edu>
---

aafade2 upstream made the bug worse (the information disclosed
became something non-constant), but the bug exists in 3.0 (and
presumably even much older kernels) even without that change.

hpa, feel free to send to stable if you like.  If anyone has an x86
machine that dies when copy_page isn't page-aligned, then this fix
is critical, but I'm pretty sure we would have noticed that by now.

This applies to and is tested on 3.0.

 arch/x86/vdso/vdso.S |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/vdso/vdso.S b/arch/x86/vdso/vdso.S
index 1d3aa6b..3ace53b 100644
--- a/arch/x86/vdso/vdso.S
+++ b/arch/x86/vdso/vdso.S
@@ -1,10 +1,13 @@
 #include <linux/init.h>
+#include <asm/page_types.h>
 
 __INITDATA
 
 	.globl vdso_start, vdso_end
+	.balign PAGE_SIZE
 vdso_start:
 	.incbin "arch/x86/vdso/vdso.so"
+	.balign PAGE_SIZE
 vdso_end:
 
 __FINIT
-- 
1.7.6

