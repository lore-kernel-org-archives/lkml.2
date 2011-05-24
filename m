Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932961Ab1EXOqi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 10:46:38 -0400
Received: from lon1-post-2.mail.demon.net ([195.173.77.149]:62874 "EHLO
	lon1-post-2.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932085Ab1EXOqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 10:46:37 -0400
X-Greylist: delayed 3395 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 May 2011 10:46:37 EDT
Subject: [PATCH] x86: reorder mm_context_t to remove x86_64 alignment
 padding & so shrink mm_struct
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
Cc: lkml <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>, wilsons@start.ca
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 May 2011 14:49:59 +0100
Message-ID: <1306244999.1999.5.camel@castor.rsk>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reorder mm_context_t to remove alignment padding on 64 bit builds
shrinking its size from 64 to 56 bytes.
    
This allows mm_struct to shrink from 840 to 832 bytes, so using one
fewer cache lines, and getting more objects per slab when using slub.
    
    
slabinfo mm_struct reports
before :-
    
    Sizes (bytes)     Slabs
    -----------------------------------
    Object :     840  Total  :       7
    SlabObj:     896  Full   :       1
    SlabSiz:   16384  Partial:       4
    Loss   :      56  CpuSlab:       2
    Align  :      64  Objects:      18
    
after :-

    Sizes (bytes)     Slabs
    ----------------------------------
    Object :     832  Total  :       7
    SlabObj:     832  Full   :       1
    SlabSiz:   16384  Partial:       4
    Loss   :       0  CpuSlab:       2
    Align  :      64  Objects:      19
    
Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>

---
patch against v2.6.39
compiled & tested on x86_64.

regards
Richard



diff --git a/arch/x86/include/asm/mmu.h b/arch/x86/include/asm/mmu.h
index aeff3e8..5f55e69 100644
--- a/arch/x86/include/asm/mmu.h
+++ b/arch/x86/include/asm/mmu.h
@@ -11,14 +11,14 @@
 typedef struct {
 	void *ldt;
 	int size;
-	struct mutex lock;
-	void *vdso;
 
 #ifdef CONFIG_X86_64
 	/* True if mm supports a task running in 32 bit compatibility mode. */
 	unsigned short ia32_compat;
 #endif
 
+	struct mutex lock;
+	void *vdso;
 } mm_context_t;
 
 #ifdef CONFIG_SMP


