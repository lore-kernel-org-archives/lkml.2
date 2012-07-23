Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876Ab2GWBqs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 21:46:48 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54479 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753598Ab2GWBnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 21:43:47 -0400
Message-Id: <20120723010656.638227018@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 23 Jul 2012 02:07:25 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>,
        Ohad Ben-Cohen <ohad@wizery.com>
Subject: [ 034/108] hwspinlock/core: use global ID to register hwspinlocks on multiple
 devices
In-Reply-To: <20120723010651.408577075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>

commit 476a7eeb60e70ddab138e7cb4bc44ef5ac20782e upstream.

Commit 300bab9770 (hwspinlock/core: register a bank of hwspinlocks in a
single API call, 2011-09-06) introduced 'hwspin_lock_register_single()'
to register numerous (a bank of) hwspinlock instances in a single API,
'hwspin_lock_register()'.

At which time, 'hwspin_lock_register()' accidentally passes 'local IDs'
to 'hwspin_lock_register_single()', despite that ..._single() requires
'global IDs' to register hwspinlocks.

We have to convert into global IDs by supplying the missing 'base_id'.

Signed-off-by: Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>
[ohad: fix error path of hwspin_lock_register, too]
Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/hwspinlock/hwspinlock_core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hwspinlock/hwspinlock_core.c b/drivers/hwspinlock/hwspinlock_core.c
index 61c9cf1..1201a15 100644
--- a/drivers/hwspinlock/hwspinlock_core.c
+++ b/drivers/hwspinlock/hwspinlock_core.c
@@ -345,7 +345,7 @@ int hwspin_lock_register(struct hwspinlock_device *bank, struct device *dev,
 		spin_lock_init(&hwlock->lock);
 		hwlock->bank = bank;
 
-		ret = hwspin_lock_register_single(hwlock, i);
+		ret = hwspin_lock_register_single(hwlock, base_id + i);
 		if (ret)
 			goto reg_failed;
 	}
@@ -354,7 +354,7 @@ int hwspin_lock_register(struct hwspinlock_device *bank, struct device *dev,
 
 reg_failed:
 	while (--i >= 0)
-		hwspin_lock_unregister_single(i);
+		hwspin_lock_unregister_single(base_id + i);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(hwspin_lock_register);


