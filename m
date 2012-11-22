Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030181Ab2KVTTH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:19:07 -0500
Received: from dupo.coraid.com ([208.71.232.133]:41757 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753269Ab2KVTTD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:19:03 -0500
Message-Id: <af9b4b40f3d60914f463599ef1d0ee9c9bdbfb01.1353518444.git.ecashin@coraid.com>
In-Reply-To: <cover.1353518444.git.ecashin@coraid.com>
References: <cover.1353518444.git.ecashin@coraid.com>
From: Ed Cashin <ecashin@coraid.com>
Subject: [PATCH 6/8] aoe: make error messages more specific in static minor allocation
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ecashin@coraid.com
From: Ed Cashin <ecashin@coraid.com>
X-Mailer: nedmail
Date: Wed, 21 Nov 2012 20:04:16 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For some special-purpose systems where udev isn't present, static
allocation of minor numbers is desirable.  This update
distinguishes different failure scenarios, to help the user
understand what went wrong.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
---
 drivers/block/aoe/aoedev.c |   31 ++++++++++++++++++++-----------
 1 files changed, 20 insertions(+), 11 deletions(-)

diff --git a/drivers/block/aoe/aoedev.c b/drivers/block/aoe/aoedev.c
index 91f7c99..88ccd6d 100644
--- a/drivers/block/aoe/aoedev.c
+++ b/drivers/block/aoe/aoedev.c
@@ -69,25 +69,34 @@ minor_get_static(ulong *sysminor, ulong aoemaj, int aoemin)
 		NPERSHELF = 16,
 	};
 
+	if (aoemin >= NPERSHELF) {
+		pr_err("aoe: %s %d slots per shelf\n",
+			"static minor device numbers support only",
+			NPERSHELF);
+		error = -1;
+		goto out;
+	}
+
 	n = aoemaj * NPERSHELF + aoemin;
-	if (aoemin >= NPERSHELF || n >= N_DEVS) {
+	if (n >= N_DEVS) {
 		pr_err("aoe: %s with e%ld.%d\n",
 			"cannot use static minor device numbers",
 			aoemaj, aoemin);
 		error = -1;
-	} else {
-		spin_lock_irqsave(&used_minors_lock, flags);
-		if (test_bit(n, used_minors)) {
-			pr_err("aoe: %s %lu\n",
-				"existing device already has static minor number",
-				n);
-			error = -1;
-		} else
-			set_bit(n, used_minors);
-		spin_unlock_irqrestore(&used_minors_lock, flags);
+		goto out;
 	}
 
+	spin_lock_irqsave(&used_minors_lock, flags);
+	if (test_bit(n, used_minors)) {
+		pr_err("aoe: %s %lu\n",
+			"existing device already has static minor number",
+			n);
+		error = -1;
+	} else
+		set_bit(n, used_minors);
+	spin_unlock_irqrestore(&used_minors_lock, flags);
 	*sysminor = n;
+out:
 	return error;
 }
 
-- 
1.7.1

