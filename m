Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703Ab2HMWEc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 18:04:32 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:33116 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754655Ab2HMWE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 18:04:26 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Theodore Tso" <tytso@mit.edu>
Subject: [ 22/44] random: create add_device_randomness() interface
Date: Mon, 13 Aug 2012 15:02:29 -0700
Message-Id: <20120813220144.091264274@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120813220142.113186818@linuxfoundation.org>
References: <20120813220142.113186818@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/char/random.c  |   28 ++++++++++++++++++++++++++++
 include/linux/random.h |    1 +
 2 files changed, 29 insertions(+)

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
@@ -646,6 +655,25 @@ static void set_timer_rand_state(unsigne
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
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -50,6 +50,7 @@ struct rnd_state {
 
 extern void rand_initialize_irq(int irq);
 
+extern void add_device_randomness(const void *, unsigned int);
 extern void add_input_randomness(unsigned int type, unsigned int code,
 				 unsigned int value);
 extern void add_interrupt_randomness(int irq, int irq_flags);


