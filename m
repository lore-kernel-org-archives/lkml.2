Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965627Ab2CBXqn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 18:46:43 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:43143 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965577Ab2CBXql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 18:46:41 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus971@gmail.com designates 10.68.132.198 as permitted sender) smtp.mail=linus971@gmail.com; dkim=pass header.i=linus971@gmail.com
Date: Fri, 2 Mar 2012 15:46:33 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@i5.linux-foundation.org
To: Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Word-at-a-time dcache name accesses (was Re: .. anybody know of any
 filesystems that depend on the exact VFS 'namehash' implementation?)
Message-ID: <alpine.LFD.2.02.1203021544300.28247@i5.linux-foundation.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Here's a new version of that patch.

It's based n the cleanups I committed and pushed out today, so the base 
may not look familiar, but the upside is that this does the configuration 
automatically (currently the patch enables the word accesses on x86 by 
default as long as DEBUG_PAGEALLOC isn't set).

I worked around my problems with stupid branch prediction on the '/' test 
at the end by just reorganizing the code a bit, and it actually all just 
looks cleaner.

This *does* assume that "bsf" is a reasonably fast instruction, which is 
not necessarily the case especially on 32-bit x86. So the config option 
choice for this might want some tuning even on x86, but it would be lovely 
to get comments and have people test it out on older hardware.

NOTE! There's a fair number of users of "full_name_hash()", and I'm a bit 
nervous about the fact that now "full_name_hash()" does *not* match the 
concept of doing

    hash = name_hash_init();
    .. for each char .. hash = partial_name_hash(c, hash);
    return end_name_hash()

but the usage does appear to be non-overlapping. The pure number of 
full_name_hash() users surprises me a bit, though. There are lots of 
people doing that odd "create qstr and then do a 'd_lookup()' on the 
result". 

Anyway, things work for me, and this generates pretty code and seems to 
perform quite well too.

Comments?

                  Linus

---
 arch/x86/Kconfig       |    1 +
 fs/Kconfig             |    4 +++
 fs/namei.c             |   76 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/dcache.h |   23 +++++++++++++++
 4 files changed, 104 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 5bed94e189fa..09675d3e0ac3 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -82,6 +82,7 @@ config X86
 	select CLKEVT_I8253
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select GENERIC_IOMAP
+	select DCACHE_WORD_ACCESS if !DEBUG_PAGEALLOC
 
 config INSTRUCTION_DECODER
 	def_bool (KPROBES || PERF_EVENTS)
diff --git a/fs/Kconfig b/fs/Kconfig
index d621f02a3f9e..aa195265362f 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -4,6 +4,10 @@
 
 menu "File systems"
 
+# Use unaligned word dcache accesses
+config DCACHE_WORD_ACCESS
+       bool
+
 if BLOCK
 
 source "fs/ext2/Kconfig"
diff --git a/fs/namei.c b/fs/namei.c
index 71807dc7e402..258ef22783e1 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1374,6 +1374,80 @@ static inline int can_lookup(struct inode *inode)
 	return 1;
 }
 
+/* Only works for little-endian with fast unaligned accesses! */
+#ifdef CONFIG_DCACHE_WORD_ACCESS
+
+static inline unsigned int fold_hash(unsigned long hash)
+{
+#ifdef CONFIG_64BIT
+	hash += hash >> (8*sizeof(int));
+#endif
+	return hash;
+}
+
+unsigned int full_name_hash(const unsigned char *name, unsigned int len)
+{
+	unsigned long a, mask;
+	unsigned long hash = 0;
+
+	for (;;) {
+		a = *(unsigned long *)name;
+		hash *= 9;
+		if (len < sizeof(unsigned long))
+			break;
+		hash += a;
+		name += sizeof(unsigned long);
+		len -= sizeof(unsigned long);
+		if (!len)
+			goto done;
+	}
+	mask = ~(~0ul << len*8);
+	hash += mask & a;
+done:
+	return fold_hash(hash);
+}
+
+#define ONEBYTES	0x0101010101010101ul
+#define SLASHBYTES	0x2f2f2f2f2f2f2f2ful
+#define HIGHBITS	0x8080808080808080ul
+
+/* Return the high bit set in the first byte that is a zero */
+static inline unsigned long has_zero(unsigned long a)
+{
+	return ((a - ONEBYTES) & ~a) & HIGHBITS;
+}
+
+/*
+ * Calculate the length and hash of the path component, and
+ * return the length of the component;
+ */
+static inline unsigned long hash_name(const char *name, unsigned int *hashp)
+{
+	unsigned long a, mask, hash, len;
+
+	hash = a = 0;
+	len = -sizeof(unsigned long);
+	do {
+		hash = (hash + a) * 9;
+		len += sizeof(unsigned long);
+		a = *(unsigned long *)(name+len);
+		/* Do we have any NUL or '/' bytes in this word? */
+		mask = has_zero(a) | has_zero(a ^ SLASHBYTES);
+	} while (!mask);
+
+	/* Get the final path component length */
+	len += __ffs(mask) >> 3;
+
+	/* The mask *below* the first high bit set */
+	mask = (mask - 1) & ~mask;
+	mask >>= 7;
+	hash += a & mask;
+	*hashp = fold_hash(hash);
+	return len;
+}
+
+#else
+
 unsigned int full_name_hash(const unsigned char *name, unsigned int len)
 {
 	unsigned long hash = init_name_hash();
@@ -1401,6 +1475,8 @@ static inline unsigned long hash_name(const char *name, unsigned int *hashp)
 	return len;
 }
 
+#endif
+
 /*
  * Name resolution.
  * This is the basic name resolution function, turning a pathname into
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index 4270bedd2308..6a35eaf5f3f2 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -54,6 +54,28 @@ extern struct dentry_stat_t dentry_stat;
 static inline int dentry_cmp(const unsigned char *cs, size_t scount,
 				const unsigned char *ct, size_t tcount)
 {
+#ifdef CONFIG_DCACHE_WORD_ACCESS
+	unsigned long a,b,mask;
+
+	if (unlikely(scount != tcount))
+		return 1;
+
+	for (;;) {
+		a = *(unsigned long *)cs;
+		b = *(unsigned long *)ct;
+		if (tcount < sizeof(unsigned long))
+			break;
+		if (unlikely(a != b))
+			return 1;
+		cs += sizeof(unsigned long);
+		ct += sizeof(unsigned long);
+		tcount -= sizeof(unsigned long);
+		if (!tcount)
+			return 0;
+	}
+	mask = ~(~0ul << tcount*8);
+	return unlikely(!!((a ^ b) & mask));
+#else
 	if (scount != tcount)
 		return 1;
 
@@ -65,6 +87,7 @@ static inline int dentry_cmp(const unsigned char *cs, size_t scount,
 		tcount--;
 	} while (tcount);
 	return 0;
+#endif
 }
 
 /* Name hashing routines. Initial hash value */
