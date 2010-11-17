Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934275Ab0KQGM4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 01:12:56 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:48118 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932824Ab0KQGMz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 01:12:55 -0500
Date: Tue, 16 Nov 2010 22:12:41 -0800
From: Andres Salomon <dilinger@queued.net>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Milton Miller <miltonm@bga.com>, devicetree-discuss@lists.ozlabs.org,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] x86: OLPC: speed up device tree creation during boot
 (v3)
Message-ID: <20101116221241.21419250@queued.net>
In-Reply-To: <4CE17133.2050101@zytor.com>
References: <20101111214546.4e573cad@queued.net>
	<reply-olpc-3-v2@mdm.bga.com>
	<20101112002704.50c629e2@queued.net>
	<20101114095013.GB24206@elte.hu>
	<4CE0B54E.6000101@zytor.com>
	<20101115070254.GA25243@elte.hu>
	<4CE17133.2050101@zytor.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Calling alloc_bootmem() for tiny chunks of memory over and over is really
slow; on an XO-1, it caused the time between when the kernel started
booting and when the display came alive (post-lxfb probe) to increase
to 44s.  This patch optimizes the prom_early_alloc function by
calling alloc_bootmem for 4k-sized blocks of memory, and handing out
chunks of that to callers.  With this patch, the time between kernel load
and display initialization decreased to 23s.  If there's a better way to
do this early in the boot process, please let me know.

(Note: increasing the chunk size to 16k didn't noticably affect boot time,
and wasted 9k.)

v3: fix wasted memory buglet found by Milton Miller, and style fixes.
v2: reorder prom_early_alloc as suggested by Grant Likely.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 arch/x86/platform/olpc/olpc_dt.c |   28 +++++++++++++++++++++++-----
 1 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/arch/x86/platform/olpc/olpc_dt.c b/arch/x86/platform/olpc/olpc_dt.c
index 7054697..6614ec4 100644
--- a/arch/x86/platform/olpc/olpc_dt.c
+++ b/arch/x86/platform/olpc/olpc_dt.c
@@ -126,14 +126,32 @@ static unsigned int prom_early_allocated __initdata;
 
 void * __init prom_early_alloc(unsigned long size)
 {
+	static u8 *mem;
+	static size_t free_mem;
 	void *res;
 
-	res = alloc_bootmem(size);
-	if (res)
-		memset(res, 0, size);
-
-	prom_early_allocated += size;
+	if (free_mem < size) {
+		const size_t chunk_size = max(PAGE_SIZE, size);
+
+		/*
+		 * To mimimize the number of allocations, grab at least 4k of
+		 * memory (that's an arbitrary choice that matches PAGE_SIZE on
+		 * the platforms we care about, and minimizes wasted bootmem)
+		 * and hand off chunks of it to callers.
+		 */
+		res = alloc_bootmem(chunk_size);
+		if (!res)
+			return NULL;
+		prom_early_allocated += chunk_size;
+		memset(res, 0, chunk_size);
+		free_mem = chunk_size;
+		mem = res;
+	}
 
+	/* allocate from the local cache */
+	free_mem -= size;
+	res = mem;
+	mem += size;
 	return res;
 }
 
-- 
1.7.2.3



