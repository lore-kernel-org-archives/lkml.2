Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933525Ab2JAXNp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:13:45 -0400
Received: from 1wt.eu ([62.212.114.60]:35516 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933055Ab2JAXCN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:02:13 -0400
Message-Id: <20121001225204.776041246@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:54:46 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Theodore Tso" <tytso@mit.edu>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 169/180] random: create add_device_randomness() interface
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

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
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/char/random.c  |   28 ++++++++++++++++++++++++++++
 include/linux/random.h |    1 +
 2 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index d7135b9..cfcb31d 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -125,11 +125,20 @@
  * The current exported interfaces for gathering environmental noise
  * from the devices are:
  *
+ *	void add_device_randomness(const void *buf, unsigned int size);
  * 	void add_input_randomness(unsigned int type, unsigned int code,
  *                                unsigned int value);
  *	void add_interrupt_randomness(int irq, int irq_flags);
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
@@ -646,6 +655,25 @@ static void set_timer_rand_state(unsigned int irq,
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
1.7.2.1.45.g54fbc



