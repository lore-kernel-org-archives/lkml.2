Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315Ab2LKMlX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 07:41:23 -0500
Received: from mail.eperm.de ([89.247.134.16]:2586 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752608Ab2LKMlW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 07:41:22 -0500
X-Greylist: delayed 487 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Dec 2012 07:41:21 EST
X-AuthUser: sm@eperm.de
Message-ID: <50C72800.20508@chronox.de>
Date: Tue, 11 Dec 2012 13:33:04 +0100
From: Stephan Mueller <smueller@chronox.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "Ted Ts'o" <tytso@mit.edu>, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] avoid entropy starvation due to stack protection
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ted, kernel hackers,

Some time ago, I noticed the fact that for every newly
executed process, the function create_elf_tables requests 16 bytes of
randomness from get_random_bytes. This is easily visible when calling

while [ 1 ]
do
	cat /proc/sys/kernel/random/entropy_avail
	sleep 1
done

You would expect that this number does not change significantly with the
call. But in fact, it does drop significantly -- it should drop
by 256 (bit) per loop count due to the exec of cat and sleep unless we
hit the lower boundary where nothing is copied from the input_pool. See
graph at http://www.eperm.de/entropy_estimator_time.png which indicates
the entropy counter on an Ubuntu with KDE installed (x-axis: time since
user space boot). Starting around 50 seconds, I log into lightdm which
spawns many processes.

Each request to get_random_bytes retrieves (good) entropy from the
input_pool, if available. The entire logic of getting 16 bytes per exec
depletes good quality entropy on a fast scale that also affects /dev/random.

This alone is already a burn of entropy that leaves the kernel starved
of entropy much more than we want it to.

The receiver of that entropy for this is the stack protector of glibc.
The patch that added this behavior is found in
http://mirror.lividpenguin.com/pub/linux/kernel/people/akpm/patches/2.6/2.6.28-rc2/2.6.28-rc2-mm1/broken-out/elf-implement-at_random-for-glibc-prng-seeding.patch

Even when considering an initial installation process, you assume it
generates massive entropy due to copying 100s of megabytes of data to
disk. That entropy can already be retained for the first reboot of the
system to ensure that already the first start has sufficient entropy
available (which for example may be used to generate missing
cryptographic keys, e.g. for OpenSSH).

However, analyzing the installation process and the entropy behavior
again showed very surprising results. See graph at
http://www.eperm.de/entropy_estimator_time_install.png (x-axis: time
since mount of root partition; red line: installed data in MB (rhs),
black/blue lines: estimated entropy in input_pool (lhs)). The graph is
for the entire installation process of the RHEL 6.2 minimal
installation. The spike of entropy at the end is caused *only* because
of the grub installation (see that there is no data added to the hard disk).

I would have expected that the entropy rises to the top of 4096 early on
in the install cycle and stayed there. But then, after thinking some
more, it is clear why this is not the case: when installing rpm packages
from anaconda, you exec many processes (rpm -Uhv, the pre/post install
scripts of the RPM packages).

So, if we would not have had the grub installation phase, our entropy
count would still be low.

Now my question to kernel hackers: may I propose the addition of a new
entropy pool solely used for purposes within the kernel? The entropy
pool has the following characteristics:

- it is non-blocking similarly to nonblocking_pool

- it has the same size as nonblocking_pool

- it draws from input_pool until the entropy counter in the kernel pool
reaches the maximum of poolinfo->poolwords. Starting at that point, we
assume that the pool is filled with entropy completely and the SHA-1
hash including the back-mixing ensures the entropy is preserved as much
as possible. The pulling of the entropy from input_pool is identical to
the nonblocking_pool.

- after reaching the entropy limit, it will never be seeded again.

Bottom line: before reaching the threshold, the kernel pool behaves
exactly like the nonblocking_pool. After reaching the threshold, it
decouples itself from the input_pool.

May I further propose to replace the get_random_bytes invocation from
create_elf_tables with a call to the retrieval of random numbers from
the kernel pool?

I think that approach satisfies the requirement for stack protection and
ASLR as there is still no prediction possible of the random number.
Maybe even other in-kernel users can use that for sufficient good random
numbers.

When testing the patch, the following behavior of the entropy estimator is seen: http://www.eperm.de/entropy_estimator_time_patch.png -- compare that to the initial graph! The first minute, you have the low numbers as the kernel pool needs to fill. Once it is filled, the entropy climbs. The sharp reductions are due to the start of Firefox which seems to pull entropy.

See patch attached. It applies against vanilla version 3.6.

Thanks
Stephan

Signed-off-by: Stephan Mueller <smueller@chronox.de>

---

diff -purN linux-3.6/drivers/char/random.c linux-3.6-sm/drivers/char/random.c
--- linux-3.6/drivers/char/random.c	2012-10-01 01:47:46.000000000 +0200
+++ linux-3.6-sm/drivers/char/random.c	2012-12-11 11:51:58.997172447 +0100
@@ -404,11 +404,12 @@ static bool debug;
 module_param(debug, bool, 0644);
 #define DEBUG_ENT(fmt, arg...) do { \
 	if (debug) \
-		printk(KERN_DEBUG "random %04d %04d %04d: " \
+		printk(KERN_DEBUG "random %04d %04d %04d %04d: " \
 		fmt,\
 		input_pool.entropy_count,\
 		blocking_pool.entropy_count,\
 		nonblocking_pool.entropy_count,\
+		kernel_pool.entropy_count,\
 		## arg); } while (0)
 #else
 #define DEBUG_ENT(fmt, arg...) do {} while (0)
@@ -428,7 +429,11 @@ struct entropy_store {
 	__u32 *pool;
 	const char *name;
 	struct entropy_store *pull;
-	int limit;
+	int limit;	/* 0 -> no limit when extracting data (nonblocking)
+			 * 1 -> limit extracted data based on entropy counter
+			 * 2 -> no limit when extracting data and disabling
+			 *      use of seed source once pool has full entropy
+			 */
 
 	/* read-write data: */
 	spinlock_t lock;
@@ -443,6 +448,7 @@ struct entropy_store {
 static __u32 input_pool_data[INPUT_POOL_WORDS];
 static __u32 blocking_pool_data[OUTPUT_POOL_WORDS];
 static __u32 nonblocking_pool_data[OUTPUT_POOL_WORDS];
+static __u32 kernel_pool_data[OUTPUT_POOL_WORDS];
 
 static struct entropy_store input_pool = {
 	.poolinfo = &poolinfo_table[0],
@@ -469,6 +475,15 @@ static struct entropy_store nonblocking_
 	.pool = nonblocking_pool_data
 };
 
+static struct entropy_store kernel_pool = {
+	.poolinfo = &poolinfo_table[1],
+	.name = "kernel",
+	.limit = 2,
+	.pull = &input_pool,
+	.lock = __SPIN_LOCK_UNLOCKED(&kernel_pool.lock),
+	.pool = kernel_pool_data
+};
+
 static __u32 const twist_table[8] = {
 	0x00000000, 0x3b6e20c8, 0x76dc4190, 0x4db26158,
 	0xedb88320, 0xd6d6a3e8, 0x9b64c2b0, 0xa00ae278 };
@@ -613,6 +628,15 @@ retry:
 			r->initialized = 1;
 	}
 
+	/*
+	 * An entropy pool that is marked with limit 2 will only be
+	 * seeded by the input_pool until it is full of entropy.
+	 */
+	if (r->limit == 2 && r->entropy_count >= r->poolinfo->poolwords)
+	{
+		r->pull = NULL;
+	}
+
 	trace_credit_entropy_bits(r->name, nbits, entropy_count,
 				  r->entropy_total, _RET_IP_);
 
@@ -652,6 +676,8 @@ void add_device_randomness(const void *b
 	mix_pool_bytes(&input_pool, &time, sizeof(time), NULL);
 	mix_pool_bytes(&nonblocking_pool, buf, size, NULL);
 	mix_pool_bytes(&nonblocking_pool, &time, sizeof(time), NULL);
+	mix_pool_bytes(&kernel_pool, buf, size, NULL);
+	mix_pool_bytes(&kernel_pool, &time, sizeof(time), NULL);
 }
 EXPORT_SYMBOL(add_device_randomness);
 
@@ -820,7 +846,7 @@ static void xfer_secondary_pool(struct e
 	if (r->pull && r->entropy_count < nbytes * 8 &&
 	    r->entropy_count < r->poolinfo->POOLBITS) {
 		/* If we're limited, always leave two wakeup worth's BITS */
-		int rsvd = r->limit ? 0 : random_read_wakeup_thresh/4;
+		int rsvd = r->limit == 1 ? 0 : random_read_wakeup_thresh/4;
 		int bytes = nbytes;
 
 		/* pull at least as many as BYTES as wakeup BITS */
@@ -868,7 +894,7 @@ static size_t account(struct entropy_sto
 		nbytes = 0;
 	} else {
 		/* If limited, never pull more than available */
-		if (r->limit && nbytes + reserved >= r->entropy_count / 8)
+		if (r->limit == 1 && nbytes + reserved >= r->entropy_count / 8)
 			nbytes = r->entropy_count/8 - reserved;
 
 		if (r->entropy_count / 8 >= nbytes + reserved)
@@ -883,7 +909,7 @@ static size_t account(struct entropy_sto
 	}
 
 	DEBUG_ENT("debiting %d entropy credits from %s%s\n",
-		  nbytes * 8, r->name, r->limit ? "" : " (unlimited)");
+		  nbytes * 8, r->name, r->limit == 1 ? "" : " (unlimited)");
 
 	spin_unlock_irqrestore(&r->lock, flags);
 
@@ -1037,6 +1063,21 @@ void get_random_bytes(void *buf, int nby
 EXPORT_SYMBOL(get_random_bytes);
 
 /*
+ * This function exports the kernel random number pool. It is of
+ * slightly less quality than the nonblocking_pool exported by
+ * the function get_random_bytes because once it is filled completely
+ * with entropy, it is never seeded again. Yet, the quality of the
+ * random bytes depend on the SHA-1 hash and should be sufficient
+ * for purposes like ASLR and stack protection.
+ */
+void get_random_kernel_bytes(void *buf, int nbytes)
+{
+	extract_entropy(&kernel_pool, buf, nbytes, 0, 0);
+}
+EXPORT_SYMBOL(get_random_kernel_bytes);
+
+
+/*
  * This function will use the architecture-specific hardware random
  * number generator if it is available.  The arch-specific hw RNG will
  * almost certainly be faster than what we can do in software, but it
@@ -1110,6 +1151,7 @@ static int rand_initialize(void)
 	init_std_data(&input_pool);
 	init_std_data(&blocking_pool);
 	init_std_data(&nonblocking_pool);
+	init_std_data(&kernel_pool);
 	return 0;
 }
 module_init(rand_initialize);
@@ -1239,6 +1281,9 @@ static ssize_t random_write(struct file
 	ret = write_pool(&nonblocking_pool, buffer, count);
 	if (ret)
 		return ret;
+	ret = write_pool(&kernel_pool, buffer, count);
+	if (ret)
+		return ret;
 
 	return (ssize_t)count;
 }
diff -purN linux-3.6/fs/binfmt_elf.c linux-3.6-sm/fs/binfmt_elf.c
--- linux-3.6/fs/binfmt_elf.c	2012-10-01 01:47:46.000000000 +0200
+++ linux-3.6-sm/fs/binfmt_elf.c	2012-12-11 10:25:36.357094685 +0100
@@ -193,7 +193,7 @@ create_elf_tables(struct linux_binprm *b
 	/*
 	 * Generate 16 random bytes for userspace PRNG seeding.
 	 */
-	get_random_bytes(k_rand_bytes, sizeof(k_rand_bytes));
+	get_random_kernel_bytes(k_rand_bytes, sizeof(k_rand_bytes));
 	u_rand_bytes = (elf_addr_t __user *)
 		       STACK_ALLOC(p, sizeof(k_rand_bytes));
 	if (__copy_to_user(u_rand_bytes, k_rand_bytes, sizeof(k_rand_bytes)))
diff -purN linux-3.6/include/linux/random.h linux-3.6-sm/include/linux/random.h
--- linux-3.6/include/linux/random.h	2012-10-01 01:47:46.000000000 +0200
+++ linux-3.6-sm/include/linux/random.h	2012-12-11 10:31:45.033100217 +0100
@@ -54,6 +54,7 @@ extern void add_input_randomness(unsigne
 extern void add_interrupt_randomness(int irq, int irq_flags);
 
 extern void get_random_bytes(void *buf, int nbytes);
+extern void get_random_kernel_bytes(void *buf, int nbytes);
 extern void get_random_bytes_arch(void *buf, int nbytes);
 void generate_random_uuid(unsigned char uuid_out[16]);
 

