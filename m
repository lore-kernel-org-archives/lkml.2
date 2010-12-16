Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952Ab0LPC67 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 21:58:59 -0500
Received: from hera.kernel.org ([140.211.167.34]:52700 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755148Ab0LPC65 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 21:58:57 -0500
Date: Thu, 16 Dec 2010 02:58:41 GMT
From: tip-bot for Andres Salomon <dilinger@queued.net>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        dilinger@queued.net, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        dilinger@queued.net, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <20101129153951.74202a84@queued.net>
References: <20101129153951.74202a84@queued.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/olpc] x86, olpc: Speed up device tree creation during boot
Message-ID: <tip-b5318d302f8a20eacbbfc01b0ee35b108085a363@git.kernel.org>
Git-Commit-ID: b5318d302f8a20eacbbfc01b0ee35b108085a363
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 16 Dec 2010 02:58:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b5318d302f8a20eacbbfc01b0ee35b108085a363
Gitweb:     http://git.kernel.org/tip/b5318d302f8a20eacbbfc01b0ee35b108085a363
Author:     Andres Salomon <dilinger@queued.net>
AuthorDate: Mon, 29 Nov 2010 23:39:51 +0000
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 15 Dec 2010 17:11:40 -0800

x86, olpc: Speed up device tree creation during boot

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

v4: clarify comment, requested by hpa
v3: fix wasted memory buglet found by Milton Miller, and style fix.
v2: reorder prom_early_alloc as suggested by Grant.

Signed-off-by: Andres Salomon <dilinger@queued.net>
LKML-Reference: <20101129153951.74202a84@queued.net>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/platform/olpc/olpc_dt.c |   28 +++++++++++++++++++++++-----
 1 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/arch/x86/platform/olpc/olpc_dt.c b/arch/x86/platform/olpc/olpc_dt.c
index 7054697..dab8746 100644
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
+		 * To mimimize the number of allocations, grab at least
+		 * PAGE_SIZE of memory (that's an arbitrary choice that's
+		 * fast enough on the platforms we care about while minimizing
+		 * wasted bootmem) and hand off chunks of it to callers.
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
 
