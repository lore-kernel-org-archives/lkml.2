Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753050Ab2JBCBV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 22:01:21 -0400
Received: from noserose.net ([66.220.18.76]:51027 "HELO noserose.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752051Ab2JBCBT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 22:01:19 -0400
Date: Mon, 1 Oct 2012 19:01:15 -0700
Message-Id: <1dd6f0e49b1c1fb151ba57df86bff4b81aa0b258.1349104674.git.ecashin@coraid.com>
In-Reply-To: <3c9c2338b9c963e1d5f19cc9ed51b01cf829eeee.1349104674.git.ecashin@coraid.com>
References: <3c9c2338b9c963e1d5f19cc9ed51b01cf829eeee.1349104674.git.ecashin@coraid.com>
From: Ed Cashin <ecashin@coraid.com>
Subject: [PATCH 2/7] aoe: retain static block device numbers for backwards compatibility
To: akpm@linux-foundation.org
Cc: ecashin@coraid.com, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The old mapping between AoE target shelf and slot addresses and
the block device minor number is retained as a
backwards-compatible feature, with a new "aoe_dyndevs" module
parameter available for enabling dynamic block device minor
numbers.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
---
 drivers/block/aoe/aoedev.c |   54 +++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 51 insertions(+), 3 deletions(-)

diff --git a/drivers/block/aoe/aoedev.c b/drivers/block/aoe/aoedev.c
index 68a7a5a..3d494fd 100644
--- a/drivers/block/aoe/aoedev.c
+++ b/drivers/block/aoe/aoedev.c
@@ -11,6 +11,7 @@
 #include <linux/slab.h>
 #include <linux/bitmap.h>
 #include <linux/kdev_t.h>
+#include <linux/moduleparam.h>
 #include "aoe.h"
 
 static void dummy_timer(ulong);
@@ -18,6 +19,10 @@ static void aoedev_freedev(struct aoedev *);
 static void freetgt(struct aoedev *d, struct aoetgt *t);
 static void skbpoolfree(struct aoedev *d);
 
+static int aoe_dyndevs;
+module_param(aoe_dyndevs, int, 0644);
+MODULE_PARM_DESC(aoe_dyndevs, "Use dynamic minor numbers for devices.");
+
 static struct aoedev *devlist;
 static DEFINE_SPINLOCK(devlist_lock);
 
@@ -34,7 +39,7 @@ static DEFINE_SPINLOCK(used_minors_lock);
 static DECLARE_BITMAP(used_minors, N_DEVS);
 
 static int
-minor_get(ulong *minor)
+minor_get_dyn(ulong *sysminor)
 {
 	ulong flags;
 	ulong n;
@@ -48,10 +53,53 @@ minor_get(ulong *minor)
 		error = -1;
 	spin_unlock_irqrestore(&used_minors_lock, flags);
 
-	*minor = n * AOE_PARTITIONS;
+	*sysminor = n * AOE_PARTITIONS;
 	return error;
 }
 
+static int
+minor_get_static(ulong *sysminor, ulong aoemaj, int aoemin)
+{
+	ulong flags;
+	ulong n;
+	int error = 0;
+	enum {
+		/* for backwards compatibility when !aoe_dyndevs,
+		 * a static number of supported slots per shelf */
+		NPERSHELF = 16,
+	};
+
+	n = aoemaj * NPERSHELF + aoemin;
+	if (aoemin >= NPERSHELF || n >= N_DEVS) {
+		pr_err("aoe: %s with e%ld.%d\n",
+			"cannot use static minor device numbers",
+			aoemaj, aoemin);
+		error = -1;
+	} else {
+		spin_lock_irqsave(&used_minors_lock, flags);
+		if (test_bit(n, used_minors)) {
+			pr_err("aoe: %s %lu\n",
+				"existing device already has static minor number",
+				n);
+			error = -1;
+		} else
+			set_bit(n, used_minors);
+		spin_unlock_irqrestore(&used_minors_lock, flags);
+	}
+
+	*sysminor = n;
+	return error;
+}
+
+static int
+minor_get(ulong *sysminor, ulong aoemaj, int aoemin)
+{
+	if (aoe_dyndevs)
+		return minor_get_dyn(sysminor);
+	else
+		return minor_get_static(sysminor, aoemaj, aoemin);
+}
+
 static void
 minor_free(ulong minor)
 {
@@ -293,7 +341,7 @@ aoedev_by_aoeaddr(ulong maj, int min, int do_alloc)
 			d->ref++;
 			break;
 		}
-	if (d || !do_alloc || minor_get(&sysminor) < 0)
+	if (d || !do_alloc || minor_get(&sysminor, maj, min) < 0)
 		goto out;
 	d = kcalloc(1, sizeof *d, GFP_ATOMIC);
 	if (!d)
-- 
1.7.1

