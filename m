Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932630Ab0GAUuI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 16:50:08 -0400
Received: from kroah.org ([198.145.64.141]:47267 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932573Ab0GAUtv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 16:49:51 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:34:30 2010
Message-Id: <20100701173429.972507671@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:33:43 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Anton Vorontsov <avorontsov@mvista.com>
Subject: [patch 037/164] USB: FHCI: cq_get() should check kfifo_out()s return value
In-Reply-To: <20100701175152.GA2135@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anton Vorontsov <avorontsov@mvista.com>

commit 7f1cccd3ec8789e52897bc34420ca81a5e2edeab upstream.

Since commit 7acd72eb85f1c7a15e8b5eb554994949241737f1 ("kfifo: rename
kfifo_put... into kfifo_in... and kfifo_get... into kfifo_out..."),
kfifo_out() is marked __must_check, and that causes gcc to produce
lots of warnings like this:

  CC      drivers/usb/host/fhci-mem.o
In file included from drivers/usb/host/fhci-hcd.c:34:
drivers/usb/host/fhci.h: In function 'cq_get':
drivers/usb/host/fhci.h:520: warning: ignoring return value of 'kfifo_out', declared with attribute warn_unused_result
...

This patch fixes the issue by properly checking the return value.

Signed-off-by: Anton Vorontsov <avorontsov@mvista.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/fhci.h |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/usb/host/fhci.h
+++ b/drivers/usb/host/fhci.h
@@ -20,6 +20,7 @@
 
 #include <linux/kernel.h>
 #include <linux/types.h>
+#include <linux/bug.h>
 #include <linux/spinlock.h>
 #include <linux/interrupt.h>
 #include <linux/kfifo.h>
@@ -515,9 +516,13 @@ static inline int cq_put(struct kfifo *k
 
 static inline void *cq_get(struct kfifo *kfifo)
 {
-	void *p = NULL;
+	unsigned int sz;
+	void *p;
+
+	sz = kfifo_out(kfifo, (void *)&p, sizeof(p));
+	if (sz != sizeof(p))
+		return NULL;
 
-	kfifo_out(kfifo, (void *)&p, sizeof(p));
 	return p;
 }
 


