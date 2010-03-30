Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932165Ab0CaANg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 20:13:36 -0400
Received: from kroah.org ([198.145.64.141]:51903 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756802Ab0C3XRs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:17:48 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:56:18 2010
Message-Id: <20100330225618.196697028@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:55:10 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [032/116] [PATCH] sparc64: Make prom entry spinlock NMI safe.
In-Reply-To: <20100330230600.GA28802@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David S. Miller <davem@davemloft.net>

[ Upstream commit 8a4fd1e4922413cfdfa6c51a59efb720d904a5eb ]

If we do something like try to print to the OF console from an NMI
while we're already in OpenFirmware, we'll deadlock on the spinlock.

Use a raw spinlock and disable NMIs when we take it.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/sparc/prom/p1275.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/arch/sparc/prom/p1275.c
+++ b/arch/sparc/prom/p1275.c
@@ -32,8 +32,7 @@ extern void prom_cif_interface(void);
 extern void prom_cif_callback(void);
 
 /*
- * This provides SMP safety on the p1275buf. prom_callback() drops this lock
- * to allow recursuve acquisition.
+ * This provides SMP safety on the p1275buf.
  */
 DEFINE_SPINLOCK(prom_entry_lock);
 
@@ -47,7 +46,9 @@ long p1275_cmd(const char *service, long
 	
 	p = p1275buf.prom_buffer;
 
-	spin_lock_irqsave(&prom_entry_lock, flags);
+	raw_local_save_flags(flags);
+	raw_local_irq_restore(PIL_NMI);
+	spin_lock(&prom_entry_lock);
 
 	p1275buf.prom_args[0] = (unsigned long)p;		/* service */
 	strcpy (p, service);
@@ -139,7 +140,8 @@ long p1275_cmd(const char *service, long
 	va_end(list);
 	x = p1275buf.prom_args [nargs + 3];
 
-	spin_unlock_irqrestore(&prom_entry_lock, flags);
+	spin_unlock(&prom_entry_lock);
+	raw_local_irq_restore(flags);
 
 	return x;
 }


