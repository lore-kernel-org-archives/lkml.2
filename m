Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756973Ab0FPJoY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 05:44:24 -0400
Received: from poutre.nerim.net ([62.4.16.124]:61087 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753057Ab0FPJoX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 05:44:23 -0400
Date: Wed, 16 Jun 2010 11:44:18 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Andrew Morton <akpm@osdl.org>, Greg Kroah-Hartman <gregkh@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] Drop __must_check from bus_for_each_drv()
Message-ID: <20100616114418.4a529eb4@hyperion.delvare>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is little rationale for marking bus_for_each_drv() __must_check.
It is more of an iteration helper than a real function. You don't know
in advance which callback it will be used on, so you have no clue how
important it can be to check the returned value. In practice, this
helper function can be used for best-effort tasks.

As a matter of fact, bus_for_each_dev() is not marked __must_check.
So remove it from bus_for_each_drv() as well. This is the same that
was done back in October 2006 by Russell King for
device_for_each_child(), for exactly the same reasons.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Andrew Morton <akpm@osdl.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
Background: I am calling bus_for_each_drv() in i2c-core, putting the
result in a dummy variable because I know it will always be 0. Now,
gcc 4.6 complains about variables that are set but never used, so I
was proposed ugly workarounds to silent this warning. I think it is
much saner to just acknowledge that this specific __must_check was
not desirable, and clean up the code.

 include/linux/device.h |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- linux-2.6.35-rc3.orig/include/linux/device.h	2010-05-31 09:59:56.000000000 +0200
+++ linux-2.6.35-rc3/include/linux/device.h	2010-06-16 09:37:55.000000000 +0200
@@ -84,9 +84,8 @@ struct device *bus_find_device_by_name(s
 				       struct device *start,
 				       const char *name);
 
-int __must_check bus_for_each_drv(struct bus_type *bus,
-				  struct device_driver *start, void *data,
-				  int (*fn)(struct device_driver *, void *));
+int bus_for_each_drv(struct bus_type *bus, struct device_driver *start,
+		     void *data, int (*fn)(struct device_driver *, void *));
 
 void bus_sort_breadthfirst(struct bus_type *bus,
 			   int (*compare)(const struct device *a,


-- 
Jean Delvare
