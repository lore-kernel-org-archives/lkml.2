Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031359Ab2HGWrv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 18:47:51 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53839 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031333Ab2HGWro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:47:44 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Andreas Schwab <schwab@linux-m68k.org>,
        Thorsten Glaser <tg@debian.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [ 45/49] m68k: Make sys_atomic_cmpxchg_32 work on classic m68k
Date: Tue,  7 Aug 2012 15:45:03 -0700
Message-Id: <20120807222030.887995969@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807222026.848194739@linuxfoundation.org>
References: <20120807222026.848194739@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Schwab <schwab@linux-m68k.org>

commit 9e2760d18b3cf179534bbc27692c84879c61b97c upstream.

User space access must always go through uaccess accessors, since on
classic m68k user space and kernel space are completely separate.

Signed-off-by: Andreas Schwab <schwab@linux-m68k.org>
Tested-by: Thorsten Glaser <tg@debian.org>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/m68k/kernel/sys_m68k.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/arch/m68k/kernel/sys_m68k.c
+++ b/arch/m68k/kernel/sys_m68k.c
@@ -479,9 +479,13 @@ sys_atomic_cmpxchg_32(unsigned long newv
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


