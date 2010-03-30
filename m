Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757343Ab0C3XvO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:51:14 -0400
Received: from kroah.org ([198.145.64.141]:45830 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932450Ab0C3XTj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:19:39 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:47:39 2010
Message-Id: <20100330224738.651951668@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:41:03 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [029/156] sparc64: Make prom entry spinlock NMI safe.
In-Reply-To: <20100330230630.GA28824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David S. Miller <davem@davemloft.net>

[ Upstream commit 8a4fd1e4922413cfdfa6c51a59efb720d904a5eb ]

If we do something like try to print to the OF console from an NMI
while we're already in OpenFirmware, we'll deadlock on the spinlock.

Use a raw spinlock and disable NMIs when we take it.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/sparc/prom/p1275.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/arch/sparc/prom/p1275.c
+++ b/arch/sparc/prom/p1275.c
@@ -32,10 +32,9 @@ extern void prom_cif_interface(void);
 extern void prom_cif_callback(void);
 
 /*
- * This provides SMP safety on the p1275buf. prom_callback() drops this lock
- * to allow recursuve acquisition.
+ * This provides SMP safety on the p1275buf.
  */
-DEFINE_SPINLOCK(prom_entry_lock);
+DEFINE_RAW_SPINLOCK(prom_entry_lock);
 
 long p1275_cmd(const char *service, long fmt, ...)
 {
@@ -47,7 +46,9 @@ long p1275_cmd(const char *service, long
 	
 	p = p1275buf.prom_buffer;
 
-	spin_lock_irqsave(&prom_entry_lock, flags);
+	raw_local_save_flags(flags);
+	raw_local_irq_restore(PIL_NMI);
+	raw_spin_lock(&prom_entry_lock);
 
 	p1275buf.prom_args[0] = (unsigned long)p;		/* service */
 	strcpy (p, service);
@@ -139,7 +140,8 @@ long p1275_cmd(const char *service, long
 	va_end(list);
 	x = p1275buf.prom_args [nargs + 3];
 
-	spin_unlock_irqrestore(&prom_entry_lock, flags);
+	raw_spin_unlock(&prom_entry_lock);
+	raw_local_irq_restore(flags);
 
 	return x;
 }


