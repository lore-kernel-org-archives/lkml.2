Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751291Ab2KGF1m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 00:27:42 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:35870 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747Ab2KGF1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 00:27:40 -0500
Message-ID: <5099F133.5030305@oracle.com>
Date: Wed, 07 Nov 2012 13:27:15 +0800
From: Jeff Liu <jeff.liu@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, Andreas Dilger <aedilger@gmail.com>,
        John Sobecki <john.sobecki@oracle.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        Alan Cox <alan@linux.intel.com>, "arnd@arndb.de" <arnd@arndb.de>,
        James Morris <james.l.morris@oracle.com>, "Ted Ts'o" <tytso@mit.edu>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        jakub@redhat.com, drepper@redhat.com,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: [PATCH V3] binfmt_elf.c: Introduce a wrapper of get_random_int()
 to fix entropy depleting
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

We have observed entropy quickly depleting under normal I/O between 2.6.30 to upstream, for instance:

$ cat /proc/sys/kernel/random/entropy_avail 
3428
$ cat /proc/sys/kernel/random/entropy_avail 
2911
$cat /proc/sys/kernel/random/entropy_avail 
2620

It has been occurred with fs/binfmt_elf.c: create_elf_tables()->get_random_bytes()
was introduced began at 2.6.30.
/*
 * Generate 16 random bytes for userspace PRNG seeding.
 */
get_random_bytes(k_rand_bytes, sizeof(k_rand_bytes));

This proposal patch is trying to introduce a wrapper of get_random_int() which has lower overhead
than calling get_random_bytes() directly.

Entropy increased with this patch applied:
$ cat /proc/sys/kernel/random/entropy_avail
2731
$ cat /proc/sys/kernel/random/entropy_avail
2802
$ cat /proc/sys/kernel/random/entropy_avail
2878


v3->v2:
-------
Remove redundant bits mask and shift upon the random variable according to Kees's review.

v2->v1:
-------
Fix random copy to check up buffer length that are not 4-byte multiples according to Andreas's comments.

v2 can be found at:
http://www.spinics.net/lists/linux-fsdevel/msg59418.html
v1 can be found at:
http://www.spinics.net/lists/linux-fsdevel/msg59128.html

Many thanks to Andreas, Andrew as well as Kees for reviewing the patch of past.

-Jeff


Signed-off-by: Jie Liu <jeff.liu@oracle.com>
Cc: John Sobecki <john.sobecki@oracle.com>
CC: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Dilger <aedilger@gmail.com>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Arnd Bergmann <arnn@arndb.de>
Cc: James Morris <james.l.morris@oracle.com>
Cc: Ted Ts'o <tytso@mit.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Jakub Jelinek <jakub@redhat.com>
Cc: Ulrich Drepper <drepper@redhat.com>

---
 fs/binfmt_elf.c |   24 +++++++++++++++++++++++-
 1 files changed, 23 insertions(+), 1 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index fbd9f60..9c36e50 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -48,6 +48,7 @@ static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs);
 static int load_elf_library(struct file *);
 static unsigned long elf_map(struct file *, unsigned long, struct elf_phdr *,
 				int, int, unsigned long);
+static void randomize_stack_user(unsigned char *buf, size_t nbytes);
 
 /*
  * If we don't support core dumping, then supply a NULL so we
@@ -200,7 +201,7 @@ create_elf_tables(struct linux_binprm *bprm, struct elfhdr *exec,
 	/*
 	 * Generate 16 random bytes for userspace PRNG seeding.
 	 */
-	get_random_bytes(k_rand_bytes, sizeof(k_rand_bytes));
+	randomize_stack_user(k_rand_bytes, sizeof(k_rand_bytes));
 	u_rand_bytes = (elf_addr_t __user *)
 		       STACK_ALLOC(p, sizeof(k_rand_bytes));
 	if (__copy_to_user(u_rand_bytes, k_rand_bytes, sizeof(k_rand_bytes)))
@@ -558,6 +559,27 @@ static unsigned long randomize_stack_top(unsigned long stack_top)
 #endif
 }
 
+/*
+ * A wrapper of get_random_int() to generate random bytes which has lower
+ * overhead than calling get_random_bytes() directly.
+ * create_elf_tables() call this function to generate 16 random bytes for
+ * userspace PRNG seeding.
+ */
+static void randomize_stack_user(unsigned char *buf, size_t nbytes)
+{
+	unsigned char *p = buf;
+
+	while (nbytes) {
+		unsigned int random_variable;
+		size_t chunk = min(nbytes, sizeof(unsigned int));
+
+		random_variable = get_random_int();
+		memcpy(p, &random_variable, chunk);
+		p += chunk;
+		nbytes -= chunk;
+	}
+}
+
 static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 {
 	struct file *interpreter = NULL; /* to shut gcc up */
-- 
1.7.4.1
