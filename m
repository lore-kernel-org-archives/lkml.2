Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527Ab0KPP1z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 10:27:55 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:64638 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079Ab0KPP1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 10:27:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=GSfl0nOOhWeFXJkL9YG0I5b1zLcLnhXw8IuNJ+Zz23DtoIDh0w2ll9f9kYUZSXZQi8
         YJdgxBfMkVFTV7BJv5rpoVGmFi0fB7C+6bDF4Oe2dVFcYN2B3o8NqFO0Z1hwq5uiAz16
         dP6Yl2Rc3h8CM/7I12wusI70BsoO/CuDi9Y44=
From: Namhyung Kim <namhyung@gmail.com>
To: Steffen Klassert <klassert@mathematik.tu-chemnitz.de>,
        netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] 3c59x: fix build failure on !CONFIG_PCI
Date: Wed, 17 Nov 2010 00:27:51 +0900
Message-Id: <1289921271-15295-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

VORTEX_PCI() could return NULL so it needs to be casted before
accessing any member of struct pci_dev. This fixes following
build failure. Likewise VORTEX_EISA() was changed also.

  CC [M]  drivers/net/3c59x.o
drivers/net/3c59x.c: In function 'acpi_set_WOL':
drivers/net/3c59x.c:3211:39: warning: dereferencing 'void *' pointer
drivers/net/3c59x.c:3211:39: error: request for member 'current_state' in something not a structure or union
make[3]: *** [drivers/net/3c59x.o] Error 1
make[2]: *** [drivers/net/3c59x.o] Error 2
make[1]: *** [sub-make] Error 2
make: *** [all] Error 2

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 drivers/net/3c59x.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/3c59x.c b/drivers/net/3c59x.c
index e1da258..0a92436 100644
--- a/drivers/net/3c59x.c
+++ b/drivers/net/3c59x.c
@@ -699,7 +699,8 @@ DEFINE_WINDOW_IO(32)
 #define DEVICE_PCI(dev) NULL
 #endif
 
-#define VORTEX_PCI(vp) (((vp)->gendev) ? DEVICE_PCI((vp)->gendev) : NULL)
+#define VORTEX_PCI(vp)							\
+	((struct pci_dev *) (((vp)->gendev) ? DEVICE_PCI((vp)->gendev) : NULL))
 
 #ifdef CONFIG_EISA
 #define DEVICE_EISA(dev) (((dev)->bus == &eisa_bus_type) ? to_eisa_device((dev)) : NULL)
@@ -707,7 +708,8 @@ DEFINE_WINDOW_IO(32)
 #define DEVICE_EISA(dev) NULL
 #endif
 
-#define VORTEX_EISA(vp) (((vp)->gendev) ? DEVICE_EISA((vp)->gendev) : NULL)
+#define VORTEX_EISA(vp)							\
+	((struct eisa_device *) (((vp)->gendev) ? DEVICE_EISA((vp)->gendev) : NULL))
 
 /* The action to take with a media selection timer tick.
    Note that we deviate from the 3Com order by checking 10base2 before AUI.
-- 
1.7.0.4

