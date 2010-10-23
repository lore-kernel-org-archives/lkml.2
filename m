Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295Ab0JWAWw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 20:22:52 -0400
Received: from LUNGE.MIT.EDU ([18.54.1.69]:45951 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752541Ab0JWAWv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 20:22:51 -0400
Date: Fri, 22 Oct 2010 17:22:47 -0700
From: Andres Salomon <dilinger@queued.net>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: devicetree-discuss@lists.ozlabs.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] x86: OLPC: speed up device tree creation during boot
Message-ID: <20101022172247.76cb3049@queued.net>
In-Reply-To: <20101022155846.66cde32f@queued.net>
References: <20101022155846.66cde32f@queued.net>
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
chunks of that to callers.  With this hack, the time between kernel load
and display initialization decreased to 23s.  If there's a better way to
do this early in the boot process, please let me know.

(Note: increasing the chunk size to 16k didn't noticably affect boot time,
and wasted 9k.)

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 arch/x86/kernel/olpc_dt.c |   27 +++++++++++++++++++++++----
 1 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/olpc_dt.c b/arch/x86/kernel/olpc_dt.c
index f660a11..44dd2ae 100644
--- a/arch/x86/kernel/olpc_dt.c
+++ b/arch/x86/kernel/olpc_dt.c
@@ -123,16 +123,35 @@ static int __init olpc_dt_pkg2path(phandle node, char *buf,
 }
 
 static unsigned int prom_early_allocated __initdata;
+#define DT_CHUNK_SIZE (1<<12)
 
 void * __init prom_early_alloc(unsigned long size)
 {
+	static u8 *mem = NULL;
+	static size_t free_mem = 0;
 	void *res;
 
-	res = alloc_bootmem(size);
-	if (res)
-		memset(res, 0, size);
+	if (free_mem >= size) {
+		/* allocate from the local cache */
+		free_mem -= size;
+		res = mem;
+		mem += size;
+		return res;
+	}
 
-	prom_early_allocated += size;
+	/*
+	 * To mimimize the number of allocations, grab 4k of memory (that's
+	 * an arbitrary choice that matches PAGE_SIZE on the platforms we care
+	 * about, and minimizes wasted bootmem) and hand off chunks of it to
+	 * callers.
+	 */
+	res = alloc_bootmem(DT_CHUNK_SIZE);
+	if (res) {
+		prom_early_allocated += DT_CHUNK_SIZE;
+		memset(res, 0, DT_CHUNK_SIZE);
+		free_mem = DT_CHUNK_SIZE - size;
+		mem = res + size;
+	}
 
 	return res;
 }
-- 
1.5.6.5

