Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767583Ab2KOEN1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 23:13:27 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:29757 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767565Ab2KOENW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 23:13:22 -0500
Message-ID: <50A46BBD.3060701@oracle.com>
Date: Thu, 15 Nov 2012 12:12:45 +0800
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
Subject: [PATCH v4] binfmt_elf.c: use get_random_int() to fix entropy depleting
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

The problems have been fixed in this version as per Kees's comments for v3.

Hi Kees,
Would you please ACK this patch if you think it is ok except the strength
of these various RNGs you are concerned?


Changes:
--------
v4->v3:
- s/random_stack_user()/get_atrandom_bytes()/
- Move this function to ahead of its use to avoid the predeclaration.

v3->v2:
- Tweak code comments of random_stack_user().
- Remove redundant bits mask and shift upon the random variable.

v2->v1:
- Fix random copy to check up buffer length that are not 4-byte multiples.

v3 can be found at:
http://www.spinics.net/lists/linux-fsdevel/msg59597.html
v2 can be found at:
http://www.spinics.net/lists/linux-fsdevel/msg59418.html
v1 can be found at:
http://www.spinics.net/lists/linux-fsdevel/msg59128.html


Thanks,
-Jeff


Entropy is quickly depleted under normal operations like ls(1), cat(1),
etc...  between 2.6.30 to current mainline, for instance:

$ cat /proc/sys/kernel/random/entropy_avail
3428
$ cat /proc/sys/kernel/random/entropy_avail
2911
$cat /proc/sys/kernel/random/entropy_avail
2620

We observed this problem has been occurring since 2.6.30 with
fs/binfmt_elf.c: create_elf_tables()->get_random_bytes(), introduced by
f06295b44c296c8f ("ELF: implement AT_RANDOM for glibc PRNG seeding").

/*
 * Generate 16 random bytes for userspace PRNG seeding.
 */
get_random_bytes(k_rand_bytes, sizeof(k_rand_bytes));

The patch introduces a wrapper around get_random_int() which has lower
overhead than calling get_random_bytes() directly.

With this patch applied:
$ cat /proc/sys/kernel/random/entropy_avail
2731
$ cat /proc/sys/kernel/random/entropy_avail
2802
$ cat /proc/sys/kernel/random/entropy_avail
2878

Analyzed by John Sobecki.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Dilger <aedilger@gmail.com>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Arnd Bergmann <arnn@arndb.de>
Cc: John Sobecki <john.sobecki@oracle.com>
Cc: James Morris <james.l.morris@oracle.com>
Cc: Jakub Jelinek <jakub@redhat.com>
Cc: Ted Ts'o <tytso@mit.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Ulrich Drepper <drepper@redhat.com>

---
 fs/binfmt_elf.c |   21 ++++++++++++++++++++-
 1 files changed, 20 insertions(+), 1 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index fbd9f60..ab4428e 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -139,6 +139,25 @@ static int padzero(unsigned long elf_bss)
 #define ELF_BASE_PLATFORM NULL
 #endif
 
+/*
+ * Use get_random_int() to implement AT_RANDOM while avoiding depletion
+ * of the entropy pool.
+ */
+static void get_atrandom_bytes(unsigned char *buf, size_t nbytes)
+{
+	unsigned char *p = buf;
+
+	while (nbytes) {
+		unsigned int random_variable;
+		size_t chunk = min(nbytes, sizeof(random_variable));
+
+		random_variable = get_random_int();
+		memcpy(p, &random_variable, chunk);
+		p += chunk;
+		nbytes -= chunk;
+	}
+}
+
 static int
 create_elf_tables(struct linux_binprm *bprm, struct elfhdr *exec,
 		unsigned long load_addr, unsigned long interp_load_addr)
@@ -200,7 +219,7 @@ create_elf_tables(struct linux_binprm *bprm, struct elfhdr *exec,
 	/*
 	 * Generate 16 random bytes for userspace PRNG seeding.
 	 */
-	get_random_bytes(k_rand_bytes, sizeof(k_rand_bytes));
+	get_atrandom_bytes(k_rand_bytes, sizeof(k_rand_bytes));
 	u_rand_bytes = (elf_addr_t __user *)
 		       STACK_ALLOC(p, sizeof(k_rand_bytes));
 	if (__copy_to_user(u_rand_bytes, k_rand_bytes, sizeof(k_rand_bytes)))
-- 
1.7.4.1
