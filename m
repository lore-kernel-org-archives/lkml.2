Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757368Ab2HGDif (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 23:38:35 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59712 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757336Ab2HGDi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 23:38:29 -0400
Message-Id: <20120807032804.958167326@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Tue, 07 Aug 2012 04:28:56 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Andreas Schwab <schwab@linux-m68k.org>,
        Thorsten Glaser <tg@debian.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [ 61/70] m68k: Make sys_atomic_cmpxchg_32 work on classic m68k
In-Reply-To: <20120807032755.803571133@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Schwab <schwab@linux-m68k.org>

commit 9e2760d18b3cf179534bbc27692c84879c61b97c upstream.

User space access must always go through uaccess accessors, since on
classic m68k user space and kernel space are completely separate.

Signed-off-by: Andreas Schwab <schwab@linux-m68k.org>
Tested-by: Thorsten Glaser <tg@debian.org>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/m68k/kernel/sys_m68k.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/m68k/kernel/sys_m68k.c b/arch/m68k/kernel/sys_m68k.c
index 8623f8d..9a5932e 100644
--- a/arch/m68k/kernel/sys_m68k.c
+++ b/arch/m68k/kernel/sys_m68k.c
@@ -479,9 +479,13 @@ sys_atomic_cmpxchg_32(unsigned long newval, int oldval, int d3, int d4, int d5,
 			goto bad_access;
 		}
 
-		mem_value = *mem;
+		/*
+		 * No need to check for EFAULT; we know that the page is
+		 * present and writable.
+		 */
+		__get_user(mem_value, mem);
 		if (mem_value == oldval)
-			*mem = newval;
+			__put_user(newval, mem);
 
 		pte_unmap_unlock(pte, ptl);
 		up_read(&mm->mmap_sem);


