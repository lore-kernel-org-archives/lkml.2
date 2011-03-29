Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250Ab1C2Xqx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 19:46:53 -0400
Received: from relay3.sgi.com ([192.48.152.1]:51416 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751676Ab1C2Xqw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 19:46:52 -0400
Message-ID: <4D926F6C.8010705@sgi.com>
Date: Tue, 29 Mar 2011 16:46:52 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jack Steiner <steiner@sgi.com>,
        Lee Schermerhorn <lee.schermerhorn@hp.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] bitmap, irq: Add smp_affinity_list interface to /proc/irq
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: bitmap, irq: Add smp_affinity_list interface to /proc/irq

    Manually adjusting the smp_affinity for IRQ's becomes unwieldy when the
    cpu count is large.  Add a companion interface, smp_affinity_list to
    use cpu lists instead of cpu maps.  This conforms to other companion
    interfaces where both a map and a list interface exists.

    This required adding a bitmap_parselist_user() function in a manner
    similar to the bitmap_parse_user() function.

Signed-off-by: Mike Travis <travis@sgi.com>
---
 include/linux/bitmap.h  |    5 +-
 include/linux/cpumask.h |   15 ++++++
 kernel/irq/proc.c       |   54 ++++++++++++++++++++++-
 lib/bitmap.c            |  109 ++++++++++++++++++++++++++++++++++++++++++------
 4 files changed, 166 insertions(+), 17 deletions(-)

--- linux-2.6.32.orig/include/linux/bitmap.h
+++ linux-2.6.32/include/linux/bitmap.h
@@ -52,7 +52,8 @@
  * bitmap_parse(buf, buflen, dst, nbits)	Parse bitmap dst from kernel buf
  * bitmap_parse_user(ubuf, ulen, dst, nbits)	Parse bitmap dst from user buf
  * bitmap_scnlistprintf(buf, len, src, nbits)	Print bitmap src as list to buf
- * bitmap_parselist(buf, dst, nbits)		Parse bitmap dst from list
+ * bitmap_parselist(buf, dst, nbits)		Parse bitmap dst from kernel buf
+ * bitmap_parselist_user(buf, dst, nbits)	Parse bitmap dst from user buf
  * bitmap_find_free_region(bitmap, bits, order)	Find and allocate bit region
  * bitmap_release_region(bitmap, pos, order)	Free specified bit region
  * bitmap_allocate_region(bitmap, pos, order)	Allocate specified bit region
@@ -118,6 +119,8 @@ extern int bitmap_scnlistprintf(char *bu
 			const unsigned long *src, int nbits);
 extern int bitmap_parselist(const char *buf, unsigned long *maskp,
 			int nmaskbits);
+extern int bitmap_parselist_user(const char __user *ubuf, unsigned int ulen,
+			unsigned long *dst, int nbits);
 extern void bitmap_remap(unsigned long *dst, const unsigned long *src,
 		const unsigned long *old, const unsigned long *new, int bits);
 extern int bitmap_bitremap(int oldbit,
--- linux-2.6.32.orig/include/linux/cpumask.h
+++ linux-2.6.32/include/linux/cpumask.h
@@ -533,6 +533,21 @@ static inline int cpumask_parse_user(con
 }
 
 /**
+ * cpumask_parselist_user - extract a cpumask from a user string
+ * @buf: the buffer to extract from
+ * @len: the length of the buffer
+ * @dstp: the cpumask to set.
+ *
+ * Returns -errno, or 0 for success.
+ */
+static inline int cpumask_parselist_user(const char __user *buf, int len,
+				     struct cpumask *dstp)
+{
+	return bitmap_parselist_user(buf, len, cpumask_bits(dstp),
+							nr_cpumask_bits);
+}
+
+/**
  * cpulist_scnprintf - print a cpumask into a string as comma-separated list
  * @buf: the buffer to sprintf into
  * @len: the length of the buffer
--- linux-2.6.32.orig/kernel/irq/proc.c
+++ linux-2.6.32/kernel/irq/proc.c
@@ -17,7 +17,7 @@ static struct proc_dir_entry *root_irq_d
 
 #ifdef CONFIG_SMP
 
-static int irq_affinity_proc_show(struct seq_file *m, void *v)
+static int show_irq_affinity(int type, struct seq_file *m, void *v)
 {
 	struct irq_desc *desc = irq_to_desc((long)m->private);
 	const struct cpumask *mask = desc->affinity;
@@ -26,17 +26,31 @@ static int irq_affinity_proc_show(struct
 	if (desc->status & IRQ_MOVE_PENDING)
 		mask = desc->pending_mask;
 #endif
-	seq_cpumask(m, mask);
+	if (type)
+		seq_cpumask_list(m, mask);
+	else
+		seq_cpumask(m, mask);
 	seq_putc(m, '\n');
 	return 0;
 }
 
+static int irq_affinity_proc_show(struct seq_file *m, void *v)
+{
+	return show_irq_affinity(0, m, v);
+}
+
+static int irq_affinity_list_proc_show(struct seq_file *m, void *v)
+{
+	return show_irq_affinity(1, m, v);
+}
+
+
 #ifndef is_affinity_mask_valid
 #define is_affinity_mask_valid(val) 1
 #endif
 
 int no_irq_affinity;
-static ssize_t irq_affinity_proc_write(struct file *file,
+static ssize_t write_irq_affinity(int type, struct file *file,
 		const char __user *buffer, size_t count, loff_t *pos)
 {
 	unsigned int irq = (int)(long)PDE(file->f_path.dentry->d_inode)->data;
@@ -50,7 +64,10 @@ static ssize_t irq_affinity_proc_write(s
 	if (!alloc_cpumask_var(&new_value, GFP_KERNEL))
 		return -ENOMEM;
 
-	err = cpumask_parse_user(buffer, count, new_value);
+	if (type)
+		err = cpumask_parselist_user(buffer, count, new_value);
+	else
+		err = cpumask_parse_user(buffer, count, new_value);
 	if (err)
 		goto free_cpumask;
 
@@ -78,11 +95,28 @@ free_cpumask:
 	return err;
 }
 
+static ssize_t irq_affinity_proc_write(struct file *file,
+		const char __user *buffer, size_t count, loff_t *pos)
+{
+	return write_irq_affinity(0, file, buffer, count, pos);
+}
+
+static ssize_t irq_affinity_list_proc_write(struct file *file,
+		const char __user *buffer, size_t count, loff_t *pos)
+{
+	return write_irq_affinity(1, file, buffer, count, pos);
+}
+
 static int irq_affinity_proc_open(struct inode *inode, struct file *file)
 {
 	return single_open(file, irq_affinity_proc_show, PDE(inode)->data);
 }
 
+static int irq_affinity_list_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, irq_affinity_list_proc_show, PDE(inode)->data);
+}
+
 static const struct file_operations irq_affinity_proc_fops = {
 	.open		= irq_affinity_proc_open,
 	.read		= seq_read,
@@ -91,6 +125,14 @@ static const struct file_operations irq_
 	.write		= irq_affinity_proc_write,
 };
 
+static const struct file_operations irq_affinity_list_proc_fops = {
+	.open		= irq_affinity_list_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+	.write		= irq_affinity_list_proc_write,
+};
+
 static int default_affinity_show(struct seq_file *m, void *v)
 {
 	seq_cpumask(m, irq_default_affinity);
@@ -240,6 +282,10 @@ void register_irq_proc(unsigned int irq,
 	proc_create_data("smp_affinity", 0600, desc->dir,
 			 &irq_affinity_proc_fops, (void *)(long)irq);
 
+	/* create /proc/irq/<irq>/smp_affinity_list */
+	proc_create_data("smp_affinity_list", 0600, desc->dir,
+			 &irq_affinity_list_proc_fops, (void *)(long)irq);
+
 	proc_create_data("node", 0444, desc->dir,
 			 &irq_node_proc_fops, (void *)(long)irq);
 #endif
--- linux-2.6.32.orig/lib/bitmap.c
+++ linux-2.6.32/lib/bitmap.c
@@ -491,8 +491,11 @@ int bitmap_scnlistprintf(char *buf, unsi
 EXPORT_SYMBOL(bitmap_scnlistprintf);
 
 /**
- * bitmap_parselist - convert list format ASCII string to bitmap
+ * __bitmap_parselist - convert list format ASCII string to bitmap
  * @bp: read nul-terminated user string from this buffer
+ * @buflen: buffer size in bytes.  If string is smaller than this
+ *    then it must be terminated with a \0.
+ * @is_user: location of buffer, 0 indicates kernel space
  * @maskp: write resulting mask here
  * @nmaskbits: number of bits in mask to be written
  *
@@ -507,20 +510,63 @@ EXPORT_SYMBOL(bitmap_scnlistprintf);
  *    %-EINVAL: invalid character in string
  *    %-ERANGE: bit number specified too large for mask
  */
-int bitmap_parselist(const char *bp, unsigned long *maskp, int nmaskbits)
+int __bitmap_parselist(const char *buf, unsigned int buflen,
+		int is_user, unsigned long *maskp,
+		int nmaskbits)
 {
 	unsigned a, b;
+	int c, old_c, totaldigits;
+	const char __user *ubuf = buf;
+	int exp_digit, in_range;
 
+	totaldigits = c = 0;
 	bitmap_zero(maskp, nmaskbits);
 	do {
-		if (!isdigit(*bp))
-			return -EINVAL;
-		b = a = simple_strtoul(bp, (char **)&bp, BASEDEC);
-		if (*bp == '-') {
-			bp++;
-			if (!isdigit(*bp))
+		exp_digit = 1;
+		in_range = 0;
+		a = b = 0;
+
+		/* Get the next cpu# or a range of cpu#'s */
+		while (buflen) {
+			old_c = c;
+			if (is_user) {
+				if (__get_user(c, ubuf++))
+					return -EFAULT;
+			} else
+				c = *buf++;
+			buflen--;
+			if (isspace(c))
+				continue;
+
+			/*
+			 * If the last character was a space and the current
+			 * character isn't '\0', we've got embedded whitespace.
+			 * This is a no-no, so throw an error.
+			 */
+			if (totaldigits && c && isspace(old_c))
 				return -EINVAL;
-			b = simple_strtoul(bp, (char **)&bp, BASEDEC);
+
+			/* A '\0' or a ',' signal the end of a cpu# or range */
+			if (c == '\0' || c == ',')
+				break;
+
+			if (c == '-') {
+				if (exp_digit || in_range)
+					return -EINVAL;
+				b = 0;
+				in_range = 1;
+				exp_digit = 1;
+				continue;
+			}
+
+			if (!isdigit(c))
+				return -EINVAL;
+
+			b = b * 10 + (c - '0');
+			if (!in_range)
+				a = b;
+			exp_digit = 0;
+			totaldigits++;
 		}
 		if (!(a <= b))
 			return -EINVAL;
@@ -530,13 +576,52 @@ int bitmap_parselist(const char *bp, uns
 			set_bit(a, maskp);
 			a++;
 		}
-		if (*bp == ',')
-			bp++;
-	} while (*bp != '\0' && *bp != '\n');
+	} while (buflen && c == ',');
 	return 0;
 }
+
+int bitmap_parselist(const char *bp, unsigned long *maskp, int nmaskbits)
+{
+	char *nl  = strchr(bp, '\n');
+	int len;
+
+	if (nl)
+		len = nl - bp;
+	else
+		len = strlen(bp);
+
+	return __bitmap_parselist(bp, len, 0, maskp, nmaskbits);
+}
 EXPORT_SYMBOL(bitmap_parselist);
 
+
+/**
+ * bitmap_parselist_user()
+ *
+ * @ubuf: pointer to user buffer containing string.
+ * @ulen: buffer size in bytes.  If string is smaller than this
+ *    then it must be terminated with a \0.
+ * @maskp: pointer to bitmap array that will contain result.
+ * @nmaskbits: size of bitmap, in bits.
+ *
+ * Wrapper for bitmap_parselist(), providing it with user buffer.
+ *
+ * We cannot have this as an inline function in bitmap.h because it needs
+ * linux/uaccess.h to get the access_ok() declaration and this causes
+ * cyclic dependencies.
+ */
+int bitmap_parselist_user(const char __user *ubuf,
+			unsigned int ulen, unsigned long *maskp,
+			int nmaskbits)
+{
+	if (!access_ok(VERIFY_READ, ubuf, ulen))
+		return -EFAULT;
+	return __bitmap_parselist((const char *)ubuf,
+					ulen, 1, maskp, nmaskbits);
+}
+EXPORT_SYMBOL(bitmap_parselist_user);
+
+
 /**
  * bitmap_pos_to_ord(buf, pos, bits)
  *	@buf: pointer to a bitmap
