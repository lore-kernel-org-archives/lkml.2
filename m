Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753852Ab0DMWZu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 18:25:50 -0400
Received: from xenotime.net ([72.52.64.118]:60306 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752353Ab0DMWZt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 18:25:49 -0400
Date: Tue, 13 Apr 2010 15:25:48 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Jan III Sobieski <jan3sobi3ski@gmail.com>, Scott Smedley <ss@aao.gov.au>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH] build error drivers/staging/dt3155/dt3155_drv.c
Message-Id: <20100413152548.1ac1b3a3.rdunlap@xenotime.net>
In-Reply-To: <r2h9c2470ce1004131520naf637fbdj9a41a0d28ada3db6@mail.gmail.com>
References: <p2r9c2470ce1004062104ra6b9c662uf303fb1b9e82cd6@mail.gmail.com>
	<x2t9c2470ce1004062105g83a050d0gc2269e4a8af7ae05@mail.gmail.com>
	<r2h9c2470ce1004131520naf637fbdj9a41a0d28ada3db6@mail.gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Apr 2010 00:20:31 +0200 Jan III Sobieski wrote:

> W dniu 7 kwietnia 2010 06:05 użytkownik Jan III Sobieski
> <jan3sobi3ski@gmail.com> napisał:
> > W dniu 7 kwietnia 2010 06:04 użytkownik Jan III Sobieski
> > <jan3sobi3ski@gmail.com> napisał:
> >> Hi,
> >>
> >>  CC      drivers/staging/dt3155/dt3155_drv.o
> >> drivers/staging/dt3155/dt3155_drv.c: In function 'init_module':
> >> drivers/staging/dt3155/dt3155_drv.c:1047: error: implicit declaration
> >> of function 'request_irq'
> >> drivers/staging/dt3155/dt3155_drv.c:1048: error: 'IRQF_SHARED'
> >> undeclared (first use in this function)
> >> drivers/staging/dt3155/dt3155_drv.c:1048: error: (Each undeclared
> >> identifier is reported only once
> >> drivers/staging/dt3155/dt3155_drv.c:1048: error: for each function it
> >> appears in.)
> >> drivers/staging/dt3155/dt3155_drv.c:1048: error: 'IRQF_DISABLED'
> >> undeclared (first use in this function)
> >> drivers/staging/dt3155/dt3155_drv.c: In function 'cleanup_module':
> >> drivers/staging/dt3155/dt3155_drv.c:1091: error: implicit declaration
> >> of function 'free_irq'
> >> make[3]: *** [drivers/staging/dt3155/dt3155_drv.o] Błąd 1
> >> make[2]: *** [drivers/staging/dt3155] Błąd 2
> >> make[1]: *** [drivers/staging] Błąd 2
> >> make: *** [drivers] Błąd 2
> >
> > BTW. Kernel 2.6.34-rc3-git6
> 
> I still get this bug on 2.6.34-rc4. Anyone care to pick this patch?


I sent a patch on March 09, 2010, that should fix it.
Please test it.  Thanks.

---
From: Randy Dunlap <randy.dunlap@oracle.com>

When the dt3155 driver is built-in (not as a loadable module),
these build errors happen:

drivers/staging/dt3155/dt3155_drv.c:1047: error: implicit declaration of function 'request_irq'
drivers/staging/dt3155/dt3155_drv.c:1048: error: 'IRQF_SHARED' undeclared (first use in this function)
drivers/staging/dt3155/dt3155_drv.c:1048: error: 'IRQF_DISABLED' undeclared (first use in this function)
drivers/staging/dt3155/dt3155_drv.c:1091: error: implicit declaration of function 'free_irq'

so remove the #ifdef MODULE check since it's not needed.
Also remove the CONFIG_PCI check since the Kconfig file already
requires that.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Scott Smedley <ss@aao.gov.au>
---
 drivers/staging/dt3155/dt3155_drv.c |   14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

--- linux-next-20100309.orig/drivers/staging/dt3155/dt3155_drv.c
+++ linux-next-20100309/drivers/staging/dt3155/dt3155_drv.c
@@ -57,19 +57,8 @@ MA 02111-1307 USA
 
 extern void printques(int);
 
-#ifdef MODULE
 #include <linux/module.h>
 #include <linux/interrupt.h>
-
-
-MODULE_LICENSE("GPL");
-
-#endif
-
-#ifndef CONFIG_PCI
-#error  "DT3155 :  Kernel PCI support not enabled (DT3155 drive requires PCI)"
-#endif
-
 #include <linux/pci.h>
 #include <linux/types.h>
 #include <linux/poll.h>
@@ -84,6 +73,9 @@ MODULE_LICENSE("GPL");
 #include "dt3155_io.h"
 #include "allocator.h"
 
+
+MODULE_LICENSE("GPL");
+
 /* Error variable.  Zero means no error. */
 int dt3155_errno = 0;
 
