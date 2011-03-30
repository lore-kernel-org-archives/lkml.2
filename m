Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299Ab1C3BML (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 21:12:11 -0400
Received: from relay3.sgi.com ([192.48.152.1]:60911 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753804Ab1C3BMK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 21:12:10 -0400
Message-ID: <4D92836B.1080108@sgi.com>
Date: Tue, 29 Mar 2011 18:12:11 -0700
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
References: <4D926F6C.8010705@sgi.com>
In-Reply-To: <4D926F6C.8010705@sgi.com>
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
 Documentation/IRQ-affinity.txt     |   19 +++++-
 Documentation/filesystems/proc.txt |   11 +++
 include/linux/bitmap.h             |    5 +
 include/linux/cpumask.h            |   15 +++++
 kernel/irq/proc.c                  |   54 ++++++++++++++++--
 lib/bitmap.c                       |  109 ++++++++++++++++++++++++++++++++-----
 6 files changed, 190 insertions(+), 23 deletions(-)

--- linux.orig/Documentation/IRQ-affinity.txt
+++ linux/Documentation/IRQ-affinity.txt
@@ -4,10 +4,11 @@ ChangeLog:
 
 SMP IRQ affinity
 
-/proc/irq/IRQ#/smp_affinity specifies which target CPUs are permitted
-for a given IRQ source. It's a bitmask of allowed CPUs. It's not allowed
-to turn off all CPUs, and if an IRQ controller does not support IRQ
-affinity then the value will not change from the default 0xffffffff.
+/proc/irq/IRQ#/smp_affinity and /proc/irq/IRQ#/smp_affinity_list specify
+which target CPUs are permitted for a given IRQ source.  It's a bitmask
+(smp_affinity) or cpu list (smp_affinity_list) of allowed CPUs.  It's not
+allowed to turn off all CPUs, and if an IRQ controller does not support
+IRQ affinity then the value will not change from the default of all cpus.
 
 /proc/irq/default_smp_affinity specifies default affinity mask that applies
 to all non-active IRQs. Once IRQ is allocated/activated its affinity bitmask
@@ -54,3 +55,13 @@ round-trip min/avg/max = 0.1/0.5/585.4 m
 This time around IRQ44 was delivered only to the last four processors.
 i.e counters for the CPU0-3 did not change.
 
+Here is an example of limiting that same irq (44) to cpus 1024 to 1031:
+
+[root@moon 44]# echo 1024-1031 > smp_affinity
+[root@moon 44]# cat smp_affinity
+1024-1031
+
+Note that to do this with a bitmask would require 32 bitmasks of zero
+to follow the pertinent one.
+
+
--- linux.orig/Documentation/filesystems/proc.txt
+++ linux/Documentation/filesystems/proc.txt
@@ -574,6 +574,12 @@ The contents of each smp_affinity file i
   > cat /proc/irq/0/smp_affinity
   ffffffff
 
+There is an alternate interface, smp_affinity_list which allows specifying
+a cpu range instead of a bitmask:
+
+  > cat /proc/irq/0/smp_affinity_list
+  1024-1031
+
 The default_smp_affinity mask applies to all non-active IRQs, which are the
 IRQs which have not yet been allocated/activated, and hence which lack a
 /proc/irq/[0-9]* directory.
@@ -583,12 +589,13 @@ reports itself as being attached. This h
 include information about any possible driver locality preference.
 
 prof_cpu_mask specifies which CPUs are to be profiled by the system wide
-profiler. Default value is ffffffff (all cpus).
+profiler. Default value is ffffffff (all cpus if there are only 32 of them).
 
 The way IRQs are routed is handled by the IO-APIC, and it's Round Robin
 between all the CPUs which are allowed to handle it. As usual the kernel has
 more info than you and does a better job than you, so the defaults are the
-best choice for almost everyone.
+best choice for almost everyone.  [Note this applies only to those IO-APIC's
+that support "Round Robin" interrupt distribution.]
 
 There are  three  more  important subdirectories in /proc: net, scsi, and sys.
 The general  rule  is  that  the  contents,  or  even  the  existence of these
--- linux.orig/include/linux/bitmap.h
+++ linux/include/linux/bitmap.h
@@ -55,7 +55,8 @@
  * bitmap_parse(buf, buflen, dst, nbits)	Parse bitmap dst from kernel buf
  * bitmap_parse_user(ubuf, ulen, dst, nbits)	Parse bitmap dst from user buf
  * bitmap_scnlistprintf(buf, len, src, nbits)	Print bitmap src as list to buf
- * bitmap_parselist(buf, dst, nbits)		Parse bitmap dst from list
+ * bitmap_parselist(buf, dst, nbits)		Parse bitmap dst from kernel buf
+ * bitmap_parselist_user(buf, dst, nbits)	Parse bitmap dst from user buf
  * bitmap_find_free_region(bitmap, bits, order)	Find and allocate bit region
  * bitmap_release_region(bitmap, pos, order)	Free specified bit region
  * bitmap_allocate_region(bitmap, pos, order)	Allocate specified bit region
@@ -129,6 +130,8 @@ extern int bitmap_scnlistprintf(char *bu
 			const unsigned long *src, int nbits);
 extern int bitmap_parselist(const char *buf, unsigned long *maskp,
 			int nmaskbits);
+extern int bitmap_parselist_user(const char __user *ubuf, unsigned int ulen,
+			unsigned long *dst, int nbits);
 extern void bitmap_remap(unsigned long *dst, const unsigned long *src,
 		const unsigned long *old, const unsigned long *new, int bits);
 extern int bitmap_bitremap(int oldbit,
--- linux.orig/include/linux/cpumask.h
+++ linux/include/linux/cpumask.h
@@ -547,6 +547,21 @@ static inline int cpumask_parse_user(con
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
--- linux.orig/kernel/irq/proc.c
+++ linux/kernel/irq/proc.c
@@ -19,7 +19,7 @@ static struct proc_dir_entry *root_irq_d
 
 #ifdef CONFIG_SMP
 
-static int irq_affinity_proc_show(struct seq_file *m, void *v)
+static int show_irq_affinity(int type, struct seq_file *m, void *v)
 {
 	struct irq_desc *desc = irq_to_desc((long)m->private);
 	const struct cpumask *mask = desc->irq_data.affinity;
@@ -28,7 +28,10 @@ static int irq_affinity_proc_show(struct
 	if (irqd_is_setaffinity_pending(&desc->irq_data))
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
@@ -59,7 +62,18 @@ static int irq_affinity_hint_proc_show(s
 #endif
 
 int no_irq_affinity;
-static ssize_t irq_affinity_proc_write(struct file *file,
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
+static ssize_t write_irq_affinity(int type, struct file *file,
 		const char __user *buffer, size_t count, loff_t *pos)
 {
 	unsigned int irq = (int)(long)PDE(file->f_path.dentry->d_inode)->data;
@@ -72,7 +86,10 @@ static ssize_t irq_affinity_proc_write(s
 	if (!alloc_cpumask_var(&new_value, GFP_KERNEL))
 		return -ENOMEM;
 
-	err = cpumask_parse_user(buffer, count, new_value);
+	if (type)
+		err = cpumask_parselist_user(buffer, count, new_value);
+	else
+		err = cpumask_parse_user(buffer, count, new_value);
 	if (err)
 		goto free_cpumask;
 
@@ -100,11 +117,28 @@ free_cpumask:
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
 static int irq_affinity_hint_proc_open(struct inode *inode, struct file *file)
 {
 	return single_open(file, irq_affinity_hint_proc_show, PDE(inode)->data);
@@ -125,6 +159,14 @@ static const struct file_operations irq_
 	.release	= single_release,
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
@@ -289,6 +331,10 @@ void register_irq_proc(unsigned int irq,
 	proc_create_data("affinity_hint", 0400, desc->dir,
 			 &irq_affinity_hint_proc_fops, (void *)(long)irq);
 
+	/* create /proc/irq/<irq>/smp_affinity_list */
+	proc_create_data("smp_affinity_list", 0600, desc->dir,
+			 &irq_affinity_list_proc_fops, (void *)(long)irq);
+
 	proc_create_data("node", 0444, desc->dir,
 			 &irq_node_proc_fops, (void *)(long)irq);
 #endif
--- linux.orig/lib/bitmap.c
+++ linux/lib/bitmap.c
@@ -571,8 +571,11 @@ int bitmap_scnlistprintf(char *buf, unsi
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
@@ -587,20 +590,63 @@ EXPORT_SYMBOL(bitmap_scnlistprintf);
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
@@ -610,13 +656,52 @@ int bitmap_parselist(const char *bp, uns
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
  * bitmap_pos_to_ord - find ordinal of set bit at given position in bitmap
  *	@buf: pointer to a bitmap

