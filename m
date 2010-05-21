Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934388Ab0EURBt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 13:01:49 -0400
Received: from kroah.org ([198.145.64.141]:39084 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934218Ab0EUQyP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 12:54:15 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Julia Lawall <julia@diku.dk>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 07/38] driver core: module.c: Use kasprintf
Date: Fri, 21 May 2010 09:53:37 -0700
Message-Id: <1274460848-11377-7-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <20100521165106.GA11216@kroah.com>
References: <20100521165106.GA11216@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

kasprintf combines kmalloc and sprintf, and takes care of the size
calculation itself.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression a,flag;
expression list args;
statement S;
@@

  a =
-  \(kmalloc\|kzalloc\)(...,flag)
+  kasprintf(flag,args)
  <... when != a
  if (a == NULL || ...) S
  ...>
- sprintf(a,args);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/module.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/base/module.c b/drivers/base/module.c
index f32f2f9..db930d3 100644
--- a/drivers/base/module.c
+++ b/drivers/base/module.c
@@ -15,12 +15,10 @@ static char *make_driver_name(struct device_driver *drv)
 {
 	char *driver_name;
 
-	driver_name = kmalloc(strlen(drv->name) + strlen(drv->bus->name) + 2,
-			      GFP_KERNEL);
+	driver_name = kasprintf(GFP_KERNEL, "%s:%s", drv->bus->name, drv->name);
 	if (!driver_name)
 		return NULL;
 
-	sprintf(driver_name, "%s:%s", drv->bus->name, drv->name);
 	return driver_name;
 }
 
-- 
1.7.0.3

