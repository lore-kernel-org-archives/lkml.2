Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419Ab0L1Ldw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 06:33:52 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42510 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753093Ab0L1Ldu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 06:33:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bfkEecZ/ia2n5U7AMEqZLzpnwZuvOWDiQWlCNVd2CPcctpPvNbXol/U+FCalVklEl/
         L9J47Dz6NCBdOSVG2cW6uwTMu3vcyHNfFryeeBLXkOjHXMQlC8dfPjPsMf3wc3n0dAqm
         5d3TbjnaGecblxkT8nPr4uFYg+GDnTDvJ0OJ8=
Date: Tue, 28 Dec 2010 12:33:45 +0100
From: Tejun Heo <tj@kernel.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Shaohua Li <shaohua.li@intel.com>, lkml <linux-kernel@vger.kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, eric.dumazet@gmail.com,
        linux-arch@vger.kernel.org
Subject: [PATCH] alpha: use L1_CACHE_BYTES for cacheline size in the linker
 script
Message-ID: <20101228113345.GG488@htj.dyndns.org>
References: <20101227133719.GD488@htj.dyndns.org>
 <20101227204309.GA3878@merkur.ravnborg.org>
 <20101228111822.GF488@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101228111822.GF488@htj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the linker script uses 64 for cacheline size which isn't
optimal for all cases.  Include asm/cache.h and use L1_CACHE_BYTES
instead as suggested by Sam Ravnborg.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
---
Does this look okay?

 arch/alpha/kernel/vmlinux.lds.S |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/alpha/kernel/vmlinux.lds.S b/arch/alpha/kernel/vmlinux.lds.S
index 173518f..433be2a 100644
--- a/arch/alpha/kernel/vmlinux.lds.S
+++ b/arch/alpha/kernel/vmlinux.lds.S
@@ -1,5 +1,6 @@
 #include <asm-generic/vmlinux.lds.h>
 #include <asm/thread_info.h>
+#include <asm/cache.h>
 #include <asm/page.h>
 
 OUTPUT_FORMAT("elf64-alpha")
@@ -38,7 +39,7 @@ SECTIONS
 	__init_begin = ALIGN(PAGE_SIZE);
 	INIT_TEXT_SECTION(PAGE_SIZE)
 	INIT_DATA_SECTION(16)
-	PERCPU(64, PAGE_SIZE)
+	PERCPU(L1_CACHE_BYTES, PAGE_SIZE)
 	/* Align to THREAD_SIZE rather than PAGE_SIZE here so any padding page
 	   needed for the THREAD_SIZE aligned init_task gets freed after init */
 	. = ALIGN(THREAD_SIZE);
@@ -46,7 +47,7 @@ SECTIONS
 	/* Freed after init ends here */
 
 	_data = .;
-	RW_DATA_SECTION(64, PAGE_SIZE, THREAD_SIZE)
+	RW_DATA_SECTION(L1_CACHE_BYTES, PAGE_SIZE, THREAD_SIZE)
 
 	.got : {
 		*(.got)
-- 
1.7.1

