Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360Ab0CZWXp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 18:23:45 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:50453 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752013Ab0CZWXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 18:23:43 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 01/24] x86: Make smp_locks end with page alignment
Date: Fri, 26 Mar 2010 15:21:31 -0700
Message-Id: <1269642114-16588-2-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1269642114-16588-1-git-send-email-yinghai@kernel.org>
References: <1269642114-16588-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4BAD33D6.0012,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Try to fix
------------[ cut here ]------------
WARNING: at arch/x86/mm/init.c:342 free_init_pages+0x4c/0xfa()
free_init_pages: range [0x40daf000, 0x40db5c24] is not aligned
Modules linked in:
Pid: 0, comm: swapper Not tainted 2.6.34-rc2-tip-03946-g4f16b23-dirty #50
Call Trace:
 [<40232e9f>] warn_slowpath_common+0x65/0x7c
 [<4021c9f0>] ? free_init_pages+0x4c/0xfa
 [<40881434>] ? _etext+0x0/0x24
 [<40232eea>] warn_slowpath_fmt+0x24/0x27
 [<4021c9f0>] free_init_pages+0x4c/0xfa
 [<40881434>] ? _etext+0x0/0x24
 [<40d3f4bd>] alternative_instructions+0xf6/0x100
 [<40d3fe4f>] check_bugs+0xbd/0xbf
 [<40d398a7>] start_kernel+0x2d5/0x2e4
 [<40d390ce>] i386_start_kernel+0xce/0xd5
---[ end trace 4eaa2a86a8e2da22 ]---

Comments in vmlinux.lds.S already said:
|        /*
|         * smp_locks might be freed after init
|         * start/end must be page aligned
|         */

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/kernel/vmlinux.lds.S |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 44879df..2cc2497 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -291,8 +291,8 @@ SECTIONS
 	.smp_locks : AT(ADDR(.smp_locks) - LOAD_OFFSET) {
 		__smp_locks = .;
 		*(.smp_locks)
-		__smp_locks_end = .;
 		. = ALIGN(PAGE_SIZE);
+		__smp_locks_end = .;
 	}
 
 #ifdef CONFIG_X86_64
-- 
1.6.4.2

