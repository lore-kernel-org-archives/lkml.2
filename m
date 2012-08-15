Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932213Ab2HOTw6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 15:52:58 -0400
Received: from mail1.windriver.com ([147.11.146.13]:63159 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932173Ab2HOTwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:52:50 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: "Theodore Ts'o" <tytso@mit.edu>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 155/165] random: add new get_random_bytes_arch() function
Date: Wed, 15 Aug 2012 15:48:19 -0400
Message-ID: <1345060109-9187-156-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Theodore Ts'o <tytso@mit.edu>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit c2557a303ab6712bb6e09447df828c557c710ac9 upstream.

Create a new function, get_random_bytes_arch() which will use the
architecture-specific hardware random number generator if it is
present.  Change get_random_bytes() to not use the HW RNG, even if it
is avaiable.

The reason for this is that the hw random number generator is fast (if
it is present), but it requires that we trust the hardware
manufacturer to have not put in a back door.  (For example, an
increasing counter encrypted by an AES key known to the NSA.)

It's unlikely that Intel (for example) was paid off by the US
Government to do this, but it's impossible for them to prove otherwise
 --- especially since Bull Mountain is documented to use AES as a
whitener.  Hence, the output of an evil, trojan-horse version of
RDRAND is statistically indistinguishable from an RDRAND implemented
to the specifications claimed by Intel.  Short of using a tunnelling
electronic microscope to reverse engineer an Ivy Bridge chip and
disassembling and analyzing the CPU microcode, there's no way for us
to tell for sure.

Since users of get_random_bytes() in the Linux kernel need to be able
to support hardware systems where the HW RNG is not present, most
time-sensitive users of this interface have already created their own
cryptographic RNG interface which uses get_random_bytes() as a seed.
So it's much better to use the HW RNG to improve the existing random
number generator, by mixing in any entropy returned by the HW RNG into
/dev/random's entropy pool, but to always _use_ /dev/random's entropy
pool.

This way we get almost of the benefits of the HW RNG without any
potential liabilities.  The only benefits we forgo is the
speed/performance enhancements --- and generic kernel code can't
depend on depend on get_random_bytes() having the speed of a HW RNG
anyway.

For those places that really want access to the arch-specific HW RNG,
if it is available, we provide get_random_bytes_arch().

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/char/random.c  | 27 +++++++++++++++++++++++----
 include/linux/random.h |  1 +
 2 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index f41a9f3..8dc4c16 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1031,11 +1031,28 @@ static ssize_t extract_entropy_user(struct entropy_store *r, void __user *buf,
 
 /*
  * This function is the exported kernel interface.  It returns some
- * number of good random numbers, suitable for seeding TCP sequence
- * numbers, etc.
+ * number of good random numbers, suitable for key generation, seeding
+ * TCP sequence numbers, etc.  It does not use the hw random number
+ * generator, if available; use get_random_bytes_arch() for that.
  */
 void get_random_bytes(void *buf, int nbytes)
 {
+	extract_entropy(&nonblocking_pool, buf, nbytes, 0, 0);
+}
+EXPORT_SYMBOL(get_random_bytes);
+
+/*
+ * This function will use the architecture-specific hardware random
+ * number generator if it is available.  The arch-specific hw RNG will
+ * almost certainly be faster than what we can do in software, but it
+ * is impossible to verify that it is implemented securely (as
+ * opposed, to, say, the AES encryption of a sequence number using a
+ * key known by the NSA).  So it's useful if we need the speed, but
+ * only if we're willing to trust the hardware manufacturer not to
+ * have put in a back door.
+ */
+void get_random_bytes_arch(void *buf, int nbytes)
+{
 	char *p = buf;
 
 	while (nbytes) {
@@ -1050,9 +1067,11 @@ void get_random_bytes(void *buf, int nbytes)
 		nbytes -= chunk;
 	}
 
-	extract_entropy(&nonblocking_pool, p, nbytes, 0, 0);
+	if (nbytes)
+		extract_entropy(&nonblocking_pool, p, nbytes, 0, 0);
 }
-EXPORT_SYMBOL(get_random_bytes);
+EXPORT_SYMBOL(get_random_bytes_arch);
+
 
 /*
  * init_std_data - initialize pool with system data
diff --git a/include/linux/random.h b/include/linux/random.h
index 7451093..5a376bc 100644
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -52,6 +52,7 @@ extern void add_input_randomness(unsigned int type, unsigned int code,
 extern void add_interrupt_randomness(int irq, int irq_flags);
 
 extern void get_random_bytes(void *buf, int nbytes);
+extern void get_random_bytes_arch(void *buf, int nbytes);
 void generate_random_uuid(unsigned char uuid_out[16]);
 
 #ifndef MODULE
-- 
1.7.12.rc2

