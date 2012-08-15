Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932265Ab2HOTxF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 15:53:05 -0400
Received: from mail1.windriver.com ([147.11.146.13]:63156 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932122Ab2HOTwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:52:49 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 153/165] random: create add_device_randomness() interface
Date: Wed, 15 Aug 2012 15:48:17 -0400
Message-ID: <1345060109-9187-154-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit a2080a67abe9e314f9e9c2cc3a4a176e8a8f8793 upstream.

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/char/random.c  | 28 ++++++++++++++++++++++++++++
 include/linux/random.h |  1 +
 2 files changed, 29 insertions(+)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 3cfaf87..0c85b69 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -125,10 +125,19 @@
  * The current exported interfaces for gathering environmental noise
  * from the devices are:
  *
+ *	void add_device_randomness(const void *buf, unsigned int size);
  * 	void add_input_randomness(unsigned int type, unsigned int code,
  *                                unsigned int value);
  *	void add_interrupt_randomness(int irq, int irq_flags);
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
@@ -639,6 +648,25 @@ static void set_timer_rand_state(unsigned int irq,
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
+	mix_pool_bytes(&input_pool, buf, size, NULL);
+	mix_pool_bytes(&input_pool, &time, sizeof(time), NULL);
+	mix_pool_bytes(&nonblocking_pool, buf, size, NULL);
+	mix_pool_bytes(&nonblocking_pool, &time, sizeof(time), NULL);
+}
+EXPORT_SYMBOL(add_device_randomness);
+
 static struct timer_rand_state input_timer_state;
 
 /*
diff --git a/include/linux/random.h b/include/linux/random.h
index 8a85602..7451093 100644
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -46,6 +46,7 @@ struct rand_pool_info {
 
 extern void rand_initialize_irq(int irq);
 
+extern void add_device_randomness(const void *, unsigned int);
 extern void add_input_randomness(unsigned int type, unsigned int code,
 				 unsigned int value);
 extern void add_interrupt_randomness(int irq, int irq_flags);
-- 
1.7.12.rc2

