Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752059Ab0CYNSK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 09:18:10 -0400
Received: from vps.mortis.eu ([79.99.135.181]:44859 "EHLO vps.mortis.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751234Ab0CYNSI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 09:18:08 -0400
From: Giel van Schijndel <me@mortis.eu>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Jean Delvare <khali@linux-fr.org>, Giel van Schijndel <me@mortis.eu>,
       Jonathan Cameron <jic23@cam.ac.uk>,
       Laurens Leemans <laurens@signips.com>, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 1/3] resource: shared I/O region support
Date: Thu, 25 Mar 2010 14:17:41 +0100
Message-Id: <1269523063-30346-1-git-send-email-me@mortis.eu>
X-Mailer: git-send-email 1.6.4.4
In-Reply-To: <20100325125005.6d58cfaf@lxorguk.ukuu.org.uk>
References: <20100325125005.6d58cfaf@lxorguk.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@lxorguk.ukuu.org.uk>

This patch was originally written by Alan Cox [1]. I only updated it to
apply correctly to Linus' current tree and changed IORESOURCE_MUXED's
value from 0x00200000 to 0x00400000 because the former has already been
taken in use since.

[1] https://patchwork.kernel.org/patch/32397/

Patch after this line:
========================================================================
SuperIO devices share regions and use lock/unlock operations to chip
select.  We therefore need to be able to request a resource and wait for
it to be freed by whichever other SuperIO device currently hogs it.
Right now you have to poll which is horrible.

Add a MUXED field to IO port resources. If the MUXED field is set on the
resource and on the request (via request_muxed_region) then we block
until the previous owner of the muxed resource releases their region.

This allows us to implement proper resource sharing and locking for
superio chips using code of the form

enable_my_superio_dev() {
	request_muxed_region(0x44, 0x02, "superio:watchdog");
	outb() ..sequence to enable chip
}

disable_my_superio_dev() {
	outb() .. sequence of disable chip
	release_region(0x44, 0x02);
}

Signed-off-by: Giel van Schijndel <me@mortis.eu>
---
 include/linux/ioport.h |    4 +++-
 kernel/resource.c      |   14 +++++++++++++-
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/include/linux/ioport.h b/include/linux/ioport.h
index 71ab79d..604fd29 100644
--- a/include/linux/ioport.h
+++ b/include/linux/ioport.h
@@ -52,6 +52,7 @@ struct resource_list {
 
 #define IORESOURCE_MEM_64	0x00100000
 #define IORESOURCE_WINDOW	0x00200000	/* forwarded by bridge */
+#define IORESOURCE_MUXED	0x00400000	/* Resource is software muxed */
 
 #define IORESOURCE_EXCLUSIVE	0x08000000	/* Userland may not map this resource */
 #define IORESOURCE_DISABLED	0x10000000
@@ -141,7 +142,8 @@ static inline unsigned long resource_type(const struct resource *res)
 }
 
 /* Convenience shorthand with allocation */
-#define request_region(start,n,name)	__request_region(&ioport_resource, (start), (n), (name), 0)
+#define request_region(start,n,name)		__request_region(&ioport_resource, (start), (n), (name), 0)
+#define request_muxed_region(start,n,name)	__request_region(&ioport_resource, (start), (n), (name), IORESOURCE_MUXED)
 #define __request_mem_region(start,n,name, excl) __request_region(&iomem_resource, (start), (n), (name), excl)
 #define request_mem_region(start,n,name) __request_region(&iomem_resource, (start), (n), (name), 0)
 #define request_mem_region_exclusive(start,n,name) \
diff --git a/kernel/resource.c b/kernel/resource.c
index 2d5be5d..1484180 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -651,6 +651,8 @@ resource_size_t resource_alignment(struct resource *res)
  * release_region releases a matching busy region.
  */
 
+static DECLARE_WAIT_QUEUE_HEAD(muxed_resource_wait);
+
 /**
  * __request_region - create a new busy resource region
  * @parent: parent resource descriptor
@@ -663,6 +665,7 @@ struct resource * __request_region(struct resource *parent,
 				   resource_size_t start, resource_size_t n,
 				   const char *name, int flags)
 {
+	DECLARE_WAITQUEUE(wait, current);
 	struct resource *res = kzalloc(sizeof(*res), GFP_KERNEL);
 
 	if (!res)
@@ -687,7 +690,14 @@ struct resource * __request_region(struct resource *parent,
 			if (!(conflict->flags & IORESOURCE_BUSY))
 				continue;
 		}
-
+		if (conflict->flags & flags & IORESOURCE_MUXED) {
+			add_wait_queue(&muxed_resource_wait, &wait);
+			write_unlock(&resource_lock);
+			schedule();
+			remove_wait_queue(&muxed_resource_wait, &wait);
+			write_lock(&resource_lock);
+			continue;
+		}
 		/* Uhhuh, that didn't work out.. */
 		kfree(res);
 		res = NULL;
@@ -761,6 +771,8 @@ void __release_region(struct resource *parent, resource_size_t start,
 				break;
 			*p = res->sibling;
 			write_unlock(&resource_lock);
+			if (res->flags & IORESOURCE_MUXED)
+				wake_up(&muxed_resource_wait);
 			kfree(res);
 			return;
 		}
-- 
1.6.4.4

