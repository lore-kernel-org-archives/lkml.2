Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932495Ab2GESUV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 14:20:21 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:37060 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753468Ab2GESUN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 14:20:13 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: torvalds@linux-foundation.org, w@1wt.eu, ewust@umich.edu, zakir@umich.edu,
        greg@kroah.com, mpm@selenic.com, nadiah@cs.ucsd.edu,
        jhalderm@umich.edu, tglx@linutronix.de, davem@davemloft.net,
        "Theodore Ts'o" <tytso@mit.edu>, stable@kernel.org
Subject: [PATCH 07/10] random: add new get_random_bytes_arch() function
Date: Thu,  5 Jul 2012 14:12:10 -0400
Message-Id: <1341511933-11169-8-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.7.11.1.108.gb129051
In-Reply-To: <1341511933-11169-1-git-send-email-tytso@mit.edu>
References: <1341511933-11169-1-git-send-email-tytso@mit.edu>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Cc: stable@kernel.org
---
 drivers/char/random.c  | 29 ++++++++++++++++++++++++-----
 include/linux/random.h |  1 +
 2 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 7f95f91..63ba944 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1022,17 +1022,34 @@ static ssize_t extract_entropy_user(struct entropy_store *r, void __user *buf,
 
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
 		unsigned long v;
 		int chunk = min(nbytes, (int)sizeof(unsigned long));
-		
+
 		if (!arch_get_random_long(&v))
 			break;
 		
@@ -1041,9 +1058,11 @@ void get_random_bytes(void *buf, int nbytes)
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
index 6b55c51..7959407 100644
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -56,6 +56,7 @@ extern void add_input_randomness(unsigned int type, unsigned int code,
 extern void add_interrupt_randomness(int irq);
 
 extern void get_random_bytes(void *buf, int nbytes);
+extern void get_random_bytes_arch(void *buf, int nbytes);
 void generate_random_uuid(unsigned char uuid_out[16]);
 
 #ifndef MODULE
-- 
1.7.11.1.108.gb129051

