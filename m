Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880Ab0JRGZP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 02:25:15 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:40105 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753335Ab0JRGZN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 02:25:13 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
        Jeremy Fitzhardinge <jeremy@xensource.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: [PATCH] vmlinux.lds.h: gather .data..shared_aligned sections in DATA_DATA
Date: Mon, 18 Oct 2010 02:27:31 -0400
Message-Id: <1287383251-28427-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <AANLkTilVZ3GCU_hsfVNeR4oG6ETREb9UeJ0Cv_5hSwVZ@mail.gmail.com>
References: <AANLkTilVZ3GCU_hsfVNeR4oG6ETREb9UeJ0Cv_5hSwVZ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the recent change "net: remove time limit in process_backlog()",
the softnet_data variable changed from "DEFINE_PER_CPU()" to
"DEFINE_PER_CPU_ALIGNED()" which moved it from the .data section to
the .data.shared_align section.  I'm not saying this patch is wrong,
just that is what caused me to notice this larger problem.  No one
else in the kernel is using this aligned macro variant, so I imagine
that's why no one has noticed yet.

Since .data.shared_align isnt declared in any vmlinux files that I can
see, the linker just places it last.  This "just works" for most
people, but when building a ROM kernel on Blackfin systems, it causes
section overlap errors:
bfin-uclinux-ld.real:
	section .init.data [00000000202e06b8 -> 00000000202e48b7] overlaps
	section .data.shared_aligned [00000000202e06b8 -> 00000000202e0723]
I imagine other arches which support the ROM config option and thus do
funky placement would see similar issues ...

On x86, it is stuck in a dedicated section at the end:
 [8] .data             PROGBITS ffffffff810ec000 2ec0000303a8 00 WA 0 0 4096
 [9] .data.shared_alig PROGBITS ffffffff8111c3c0 31c3c00000c8 00 WA 0 0 64

So mark sure we include this section in the DATA_DATA macro so that
it is placed in the right location.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
note: this was reported back in May, patch posted in Aug, and no feedback since

 include/asm-generic/vmlinux.lds.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 7657a3b..75b6b58 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -150,6 +150,7 @@
 #define DATA_DATA							\
 	*(.data)							\
 	*(.ref.data)							\
+	*(.data..shared_aligned) /* percpu related */			\
 	DEV_KEEP(init.data)						\
 	DEV_KEEP(exit.data)						\
 	CPU_KEEP(init.data)						\
-- 
1.7.3.1

