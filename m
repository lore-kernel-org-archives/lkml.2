Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757032Ab2GESMi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 14:12:38 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:37004 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750846Ab2GESMg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 14:12:36 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: torvalds@linux-foundation.org, w@1wt.eu, ewust@umich.edu, zakir@umich.edu,
        greg@kroah.com, mpm@selenic.com, nadiah@cs.ucsd.edu,
        jhalderm@umich.edu, tglx@linutronix.de, davem@davemloft.net,
        "Theodore Ts'o" <tytso@mit.edu>, stable@kernel.org
Subject: [PATCH 03/10] random: create add_device_randomness() interface
Date: Thu,  5 Jul 2012 14:12:06 -0400
Message-Id: <1341511933-11169-4-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.7.11.1.108.gb129051
In-Reply-To: <1341511933-11169-1-git-send-email-tytso@mit.edu>
References: <1341511933-11169-1-git-send-email-tytso@mit.edu>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

Add a new interface, add_device_randomness() for adding data to the
random pool that is likely to differ between two devices (or possibly
even per boot).  This would be things like MAC addresses or serial
numbers, or the read-out of the RTC. This does *not* add any actual
entropy to the pool, but it initializes the pool to different values
for devices that might otherwise be identical and have very little
entropy available to them (particularly common in the embedded world).

[ Modified by tytso to mix in a timestamp, since there may be some
  variability caused by the time needed to detect/configure the hardware
  in question. ]

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: stable@kernel.org
---
 drivers/char/random.c  | 28 ++++++++++++++++++++++++++++
 include/linux/random.h |  1 +
 2 files changed, 29 insertions(+)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 789709e..59ddcce 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -125,11 +125,20 @@
  * The current exported interfaces for gathering environmental noise
  * from the devices are:
  *
+ *	void add_device_randomness(const void *buf, unsigned int size);
  * 	void add_input_randomness(unsigned int type, unsigned int code,
  *                                unsigned int value);
  * 	void add_interrupt_randomness(int irq);
  * 	void add_disk_randomness(struct gendisk *disk);
  *
+ * add_device_randomness() is for adding data to the random pool that
+ * is likely to differ between two devices (or possibly even per boot).
+ * This would be things like MAC addresses or serial numbers, or the
+ * read-out of the RTC. This does *not* add any actual entropy to the
+ * pool, but it initializes the pool to different values for devices
+ * that might otherwise be identical and have very little entropy
+ * available to them (particularly common in the embedded world).
+ *
  * add_input_randomness() uses the input layer interrupt timing, as well as
  * the event type information from the hardware.
  *
@@ -652,6 +661,25 @@ static void set_timer_rand_state(unsigned int irq,
 }
 #endif
 
+/*
+ * Add device- or boot-specific data to the input and nonblocking
+ * pools to help initialize them to unique values.
+ *
+ * None of this adds any entropy, it is meant to avoid the
+ * problem of the nonblocking pool having similar initial state
+ * across largely identical devices.
+ */
+void add_device_randomness(const void *buf, unsigned int size)
+{
+	unsigned long time = get_cycles() ^ jiffies;
+
+	mix_pool_bytes(&input_pool, buf, size);
+	mix_pool_bytes(&input_pool, &time, sizeof(time));
+	mix_pool_bytes(&nonblocking_pool, buf, size);
+	mix_pool_bytes(&nonblocking_pool, &time, sizeof(time));
+}
+EXPORT_SYMBOL(add_device_randomness);
+
 static struct timer_rand_state input_timer_state;
 
 /*
diff --git a/include/linux/random.h b/include/linux/random.h
index 8f74538..6b55c51 100644
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -50,6 +50,7 @@ struct rnd_state {
 
 extern void rand_initialize_irq(int irq);
 
+extern void add_device_randomness(const void *, unsigned int);
 extern void add_input_randomness(unsigned int type, unsigned int code,
 				 unsigned int value);
 extern void add_interrupt_randomness(int irq);
-- 
1.7.11.1.108.gb129051

