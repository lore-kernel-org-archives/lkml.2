Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162089Ab2GLWnH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 18:43:07 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54985 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162063Ab2GLWm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:42:57 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>,
        Ohad Ben-Cohen <ohad@wizery.com>
Subject: [ 128/187] hwspinlock/core: use global ID to register hwspinlocks on multiple devices
Date: Thu, 12 Jul 2012 15:34:44 -0700
Message-Id: <20120712191534.245461475@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.742634173@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.742634173@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwspinlock/hwspinlock_core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/hwspinlock/hwspinlock_core.c
+++ b/drivers/hwspinlock/hwspinlock_core.c
@@ -345,7 +345,7 @@ int hwspin_lock_register(struct hwspinlo
 		spin_lock_init(&hwlock->lock);
 		hwlock->bank = bank;
 
-		ret = hwspin_lock_register_single(hwlock, i);
+		ret = hwspin_lock_register_single(hwlock, base_id + i);
 		if (ret)
 			goto reg_failed;
 	}
@@ -354,7 +354,7 @@ int hwspin_lock_register(struct hwspinlo
 
 reg_failed:
 	while (--i >= 0)
-		hwspin_lock_unregister_single(i);
+		hwspin_lock_unregister_single(base_id + i);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(hwspin_lock_register);


