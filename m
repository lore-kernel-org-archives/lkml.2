Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751815Ab1CLGRT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 01:17:19 -0500
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:40008 "HELO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750912Ab1CLGRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 01:17:17 -0500
From: Cliff Frey <cliff@meraki.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] profile: add support for modules and make output human readable
Date: Fri, 11 Mar 2011 22:17:12 -0800
Message-Id: <1299910632-9970-1-git-send-email-cliff@meraki.com>
X-Mailer: git-send-email 1.7.4.1.203.g07873
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This changes /proc/profile to include kernel modules and also print out data in
human readable form (it does symbol lookups of all kernel addresses).  It also
adds /proc/profile_m which gives a high level summary of samples in
userspace/kernel/each module.

This makes it easy to profile the kernel and kernel modules on embedded systems
where cross compiling oprofile is too difficult.  It is necessary to compile the
kernel with ksyms_all for this change to be useful.

Example usage:
    router:/# sysctl -w kernel.profiler_enabled=1
    router:/# sha1sum /dev/urandom
    ^C
    router:/# cat /proc/profile
    c1007468    759 default_idle
    c10fad98    183 sha_transform
    c10fe248      6 copy_to_user
    c11524d8     33 mix_pool_bytes_extract
    c1152968     12 extract_buf
    c116e608      1 serial8250_handle_port

This change is relative to v2.6.32.  This change is not cleaned up or ready for
the mainline kernel, but I believe that it is useful for cases where one wants
profiling information about kernel modules, but does not have oprofile
available.

I am open to changing/improving the patch if there is interest in getting it
into mainline.  I will understand if there is no enthusiasm for this change as
it is imaginable that improving oprofile to the point where it is easily used on
cross compiled/embedded systems would be a better long term direction.  However,
I'd appreciate any feedback about the change, and this patch has allowed me to
greatly improve the performance of systems that I work on.

Some specific areas for improvement in the patch include:

 - Add support for SMP.
 - Leave the /proc/profile interface untouched, and just add a new handler
   for human-readable output.
 - Change human-readable output to be done incrementally instead of using
   seq_file, so that it does not stall the kernel for seconds at a time (because
   of all the symbol lookups)
 - Cleanup types/statics/enabled logic which is more complex than necessary.
 - Cleanup the profiler_enabled logic (this can probably just be removed)
 - Make this a separate kernel config option.

Signed-off-by: Cliff Frey <cliff@meraki.com>
---
 include/linux/kernel.h |    3 +
 include/linux/module.h |    6 ++
 kernel/module.c        |   20 ++++-
 kernel/profile.c       |  228 +++++++++++++++++++++++++++++++++++++++--------
 kernel/sysctl.c        |   10 ++
 5 files changed, 226 insertions(+), 41 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index f4e3184..ded869d 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -307,6 +307,9 @@ extern int panic_timeout;
 extern int panic_on_oops;
 extern int panic_on_unrecovered_nmi;
 extern int panic_on_io_nmi;
+#ifdef CONFIG_PROFILING
+extern int profiler_enabled;
+#endif
 extern const char *print_tainted(void);
 extern void add_taint(unsigned flag);
 extern int test_taint(unsigned flag);
diff --git a/include/linux/module.h b/include/linux/module.h
index 482efc8..e350a8e 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -327,6 +327,12 @@ struct module
 	struct module_notes_attrs *notes_attrs;
 #endif
 
+#ifdef CONFIG_PROFILING
+	/* The number of ticks for this module */
+	atomic_t ticks;
+	atomic_t *prof_buffer;
+#endif
+
 	/* Per-cpu data. */
 	void *percpu;
 
diff --git a/kernel/module.c b/kernel/module.c
index 5842a71..9eb36b5 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -78,7 +78,7 @@ EXPORT_TRACEPOINT_SYMBOL(module_get);
  * (delete uses stop_machine/add uses RCU list operations). */
 DEFINE_MUTEX(module_mutex);
 EXPORT_SYMBOL_GPL(module_mutex);
-static LIST_HEAD(modules);
+LIST_HEAD(modules);
 
 /* Block module loading/unloading? */
 int modules_disabled = 0;
@@ -1540,6 +1540,13 @@ static void free_module(struct module *mod)
 	/* Finally, free the core (containing the module structure) */
 	module_free(mod, mod->module_core);
 
+#ifdef CONFIG_PROFILING
+	if (mod->prof_buffer) {
+		vfree(mod->prof_buffer);
+		mod->prof_buffer = 0;
+	}
+#endif
+
 #ifdef CONFIG_MPU
 	update_protections(current->mm);
 #endif
@@ -2409,7 +2416,16 @@ static noinline struct module *load_module(void __user *umod,
 			goto cleanup;
 	}
 #endif
-
+#ifdef CONFIG_PROFILING
+	{
+		extern unsigned prof_shift;
+		int alloc_size = (mod->core_text_size >> prof_shift) * sizeof(atomic_t);
+		mod->prof_buffer = vmalloc(alloc_size);
+		if (mod->prof_buffer)
+			memset(mod->prof_buffer, 0, alloc_size);
+		atomic_set(&mod->ticks, 0);
+	}
+#endif
 	/* Now do relocations. */
 	for (i = 1; i < hdr->e_shnum; i++) {
 		const char *strtab = (char *)sechdrs[strindex].sh_addr;
diff --git a/kernel/profile.c b/kernel/profile.c
index a55d3a3..511b9b9 100644
--- a/kernel/profile.c
+++ b/kernel/profile.c
@@ -24,6 +24,9 @@
 #include <linux/mutex.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
+#include <linux/module.h>
+#include <linux/seq_file.h>
+#include <linux/kallsyms.h>
 #include <asm/sections.h>
 #include <asm/irq_regs.h>
 #include <asm/ptrace.h>
@@ -38,9 +41,17 @@ struct profile_hit {
 
 /* Oprofile timer tick hook */
 static int (*timer_hook)(struct pt_regs *) __read_mostly;
-
+static int user_hits = 0;
+static atomic_t unknown_kernel_hits = ATOMIC_INIT(0);
+static atomic_t known_kernel_hits = ATOMIC_INIT(0);
+static int nopid_hits = 0;
+int profiler_enabled = 0;
+static volatile int profiling_is_on = 1;
+
+extern struct list_head modules;
 static atomic_t *prof_buffer;
-static unsigned long prof_len, prof_shift;
+static unsigned long prof_len;
+unsigned prof_shift;
 
 int prof_on __read_mostly;
 EXPORT_SYMBOL_GPL(prof_on);
@@ -80,7 +91,7 @@ int profile_setup(char *str)
 		if (get_option(&str, &par))
 			prof_shift = par;
 		printk(KERN_INFO
-			"kernel schedule profiling enabled (shift: %ld)\n",
+			"kernel schedule profiling enabled (shift: %d)\n",
 			prof_shift);
 	} else if (!strncmp(str, kvmstr, strlen(kvmstr))) {
 		prof_on = KVM_PROFILING;
@@ -89,12 +100,12 @@ int profile_setup(char *str)
 		if (get_option(&str, &par))
 			prof_shift = par;
 		printk(KERN_INFO
-			"kernel KVM profiling enabled (shift: %ld)\n",
+			"kernel KVM profiling enabled (shift: %d)\n",
 			prof_shift);
 	} else if (get_option(&str, &par)) {
 		prof_shift = par;
 		prof_on = CPU_PROFILING;
-		printk(KERN_INFO "kernel profiling enabled (shift: %ld)\n",
+		printk(KERN_INFO "kernel profiling enabled (shift: %d)\n",
 			prof_shift);
 	}
 	return 1;
@@ -105,6 +116,11 @@ __setup("profile=", profile_setup);
 int __ref profile_init(void)
 {
 	int buffer_bytes;
+
+	// XXX turn on profiling
+	prof_shift = 4;
+	prof_on = CPU_PROFILING;
+
 	if (!prof_on)
 		return 0;
 
@@ -225,8 +241,13 @@ void unregister_timer_hook(int (*hook)(struct pt_regs *))
 }
 EXPORT_SYMBOL_GPL(unregister_timer_hook);
 
+static inline int within(unsigned long addr, void *start, unsigned long size)
+{
+	return ((void *)addr >= start && (void *)addr < start + size);
+}
 
 #ifdef CONFIG_SMP
+#error "Meraki has not added SMP profiling support yet"
 /*
  * Each cpu has a pair of open-addressed hashtables for pending
  * profile hits. read_profile() IPI's all cpus to request them
@@ -420,23 +441,53 @@ out_free:
 void profile_hits(int type, void *__pc, unsigned int nr_hits)
 {
 	unsigned long pc;
+	unsigned long pc_kernel_offset;
+	struct module *mod = NULL;
 
+	pc = (unsigned long) __pc;
 	if (prof_on != type || !prof_buffer)
 		return;
-	pc = ((unsigned long)__pc - (unsigned long)_stext) >> prof_shift;
-	atomic_add(nr_hits, &prof_buffer[min(pc, prof_len - 1)]);
+	pc_kernel_offset = (pc - (unsigned long)_stext) >> prof_shift;
+	if (pc_kernel_offset < prof_len) {
+		atomic_add(nr_hits, &prof_buffer[pc_kernel_offset]);
+		atomic_add(nr_hits, &known_kernel_hits);
+		return;
+	}
+
+	list_for_each_entry(mod, &modules, list)
+		if (mod->prof_buffer &&
+		    within(pc, mod->module_core, mod->core_text_size)) {
+			int mod_offset = (pc - (unsigned long)mod->module_core) >> prof_shift;
+			atomic_add(nr_hits, &mod->ticks);
+			atomic_add(nr_hits, &mod->prof_buffer[mod_offset]);
+			return;
+		}
+
+	atomic_add(nr_hits, &unknown_kernel_hits);
 }
 #endif /* !CONFIG_SMP */
 EXPORT_SYMBOL_GPL(profile_hits);
 
 void profile_tick(int type)
 {
-	struct pt_regs *regs = get_irq_regs();
+	struct pt_regs *regs;
+	if (!profiler_enabled)
+		return;
+
+	regs = get_irq_regs();
 
 	if (type == CPU_PROFILING && timer_hook)
 		timer_hook(regs);
-	if (!user_mode(regs) && prof_cpu_mask != NULL &&
-	    cpumask_test_cpu(smp_processor_id(), prof_cpu_mask))
+
+	if (!profiling_is_on)
+		return;
+
+	if (!current || !current->pid)
+		nopid_hits++;
+
+	if (user_mode(regs))
+		user_hits++;
+	else if (prof_cpu_mask != NULL && cpumask_test_cpu(smp_processor_id(), prof_cpu_mask))
 		profile_hit(type, (void *)profile_pc(regs));
 }
 
@@ -489,38 +540,105 @@ void create_prof_cpu_mask(struct proc_dir_entry *root_irq_dir)
 	proc_create("prof_cpu_mask", 0600, root_irq_dir, &prof_cpu_mask_proc_fops);
 }
 
-/*
- * This function accesses profiling information. The returned data is
- * binary: the sampling step and the actual contents of the profile
- * buffer. Use of the program readprofile is recommended in order to
- * get meaningful info out of these data.
- */
-static ssize_t
-read_profile(struct file *file, char __user *buf, size_t count, loff_t *ppos)
+static void
+do_seq_profile(struct seq_file *m, unsigned long base_pc, atomic_t *buf, int count, int module)
 {
-	unsigned long p = *ppos;
-	ssize_t read;
-	char *pnt;
-	unsigned int sample_step = 1 << prof_shift;
+	int i;
+	int lastcount = 0;
+	unsigned long lastpc = 0;
+	char lastname[KSYM_NAME_LEN+1];
+	lastname[0] = '\0';
+
+	for (i = 0; i < count; i++)
+		if (atomic_read(&buf[i])) {
+			unsigned long pc;
+			char *modname;
+			const char *name;
+			unsigned long offset, size;
+			char namebuf[KSYM_NAME_LEN+1];
+			namebuf[0] = '\0';
+			namebuf[KSYM_NAME_LEN] = '\0';
+			pc = base_pc + (i << prof_shift);
+			name = kallsyms_lookup(pc, &size, &offset, &modname, namebuf);
+			(void)module;
+			if (strncmp(name, lastname, KSYM_NAME_LEN) != 0) {
+				if (lastcount > 5)
+					seq_printf(m, "%08lx % 6d %s\n", lastpc, lastcount, lastname);
+				lastcount = 0;
+				lastpc = pc;
+				strncpy(lastname, namebuf, KSYM_NAME_LEN);
+			}
+			lastcount += atomic_read(&buf[i]);
+		}
+
+	if (lastcount)
+		seq_printf(m, "%08lx % 6d %s\n", lastpc, lastcount, lastname);
+}
 
+static int
+show_profile(struct seq_file *m, void *v)
+{
+	struct module *mod;
+	(void) v;
+	if (!prof_buffer)
+		return 1;
 	profile_flip_buffers();
-	if (p >= (prof_len+1)*sizeof(unsigned int))
-		return 0;
-	if (count > (prof_len+1)*sizeof(unsigned int) - p)
-		count = (prof_len+1)*sizeof(unsigned int) - p;
-	read = 0;
 
-	while (p < sizeof(unsigned int) && count > 0) {
-		if (put_user(*((char *)(&sample_step)+p), buf))
-			return -EFAULT;
-		buf++; p++; count--; read++;
+	profiling_is_on = 0;
+	do_seq_profile(m, (unsigned long)_stext, prof_buffer, prof_len, 0);
+
+	mutex_lock(&module_mutex);
+	list_for_each_entry(mod, &modules, list) {
+		if (mod->state == MODULE_STATE_LIVE && mod->prof_buffer) {
+			do_seq_profile(m, (unsigned long)mod->module_core,
+				       mod->prof_buffer, mod->core_text_size >> prof_shift, 1);
+		}
 	}
-	pnt = (char *)prof_buffer + p - sizeof(atomic_t);
-	if (copy_to_user(buf, (void *)pnt, count))
-		return -EFAULT;
-	read += count;
-	*ppos += read;
-	return read;
+
+	mutex_unlock(&module_mutex);
+
+	profiling_is_on = 1;
+
+	return 0;
+}
+
+static int
+show_profile_m(struct seq_file *m, void *v)
+{
+	struct module *mod;
+	unsigned long total = 0;
+	(void) v;
+
+	seq_printf(m, "%d idle?\n\n", nopid_hits);
+	seq_printf(m, "below should add up to 100%%\n");
+	seq_printf(m, "%d userlevel\n", user_hits);
+	seq_printf(m, "%d unknown_kernel_hits\n", atomic_read(&unknown_kernel_hits));
+	seq_printf(m, "%d vmlinux\n", atomic_read(&known_kernel_hits));
+	total = user_hits + atomic_read(&unknown_kernel_hits) + atomic_read(&known_kernel_hits);
+	mutex_lock(&module_mutex);
+	list_for_each_entry(mod, &modules, list) {
+		if (mod->state != MODULE_STATE_LIVE) {
+			continue;
+		}
+		total += atomic_read(&mod->ticks);
+		seq_printf(m, "%d %s\n", atomic_read(&mod->ticks), mod->name);
+	}
+
+	seq_printf(m, "\n%lu total\n", total);
+	mutex_unlock(&module_mutex);
+
+	return 0;
+}
+
+static int open_profile(struct inode *inode, struct file *file)
+{
+	return single_open(file, show_profile, NULL);
+}
+
+static int open_profile_m(struct inode *inode, struct file *file)
+{
+	struct proc_dir_entry *dp = PDE(inode);
+	return single_open(file, show_profile_m, dp->data);
 }
 
 /*
@@ -532,6 +650,8 @@ read_profile(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 static ssize_t write_profile(struct file *file, const char __user *buf,
 			     size_t count, loff_t *ppos)
 {
+	struct module *mod = NULL;
+	profiling_is_on = 0;
 #ifdef CONFIG_SMP
 	extern int setup_profiling_timer(unsigned int multiplier);
 
@@ -547,11 +667,36 @@ static ssize_t write_profile(struct file *file, const char __user *buf,
 #endif
 	profile_discard_flip_buffers();
 	memset(prof_buffer, 0, prof_len * sizeof(atomic_t));
+
+	mutex_lock(&module_mutex);
+	list_for_each_entry(mod, &modules, list) {
+		atomic_set(&mod->ticks, 0);
+		if (mod->prof_buffer)
+			memset(mod->prof_buffer, 0,
+			       (mod->core_text_size >> prof_shift) * sizeof(atomic_t));
+	}
+	mutex_unlock(&module_mutex);
+	user_hits = nopid_hits = 0;
+	atomic_set(&unknown_kernel_hits, 0);
+	atomic_set(&known_kernel_hits, 0);
+
+	profiling_is_on = 1;
 	return count;
 }
 
 static const struct file_operations proc_profile_operations = {
-	.read		= read_profile,
+	.open		= open_profile,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+	.write		= write_profile,
+};
+
+static const struct file_operations proc_profile_m_operations = {
+	.open		= open_profile_m,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
 	.write		= write_profile,
 };
 
@@ -620,7 +765,12 @@ int __ref create_proc_profile(void) /* false positive from hotcpu_notifier */
 			    NULL, &proc_profile_operations);
 	if (!entry)
 		return 0;
-	entry->size = (1+prof_len) * sizeof(atomic_t);
+
+	entry = proc_create("profile_m", S_IWUSR | S_IRUGO,
+			    NULL, &proc_profile_m_operations);
+	if (!entry)
+		return 0;
+
 	hotcpu_notifier(profile_cpu_callback, 0);
 	return 0;
 }
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 0d949c5..b7d16e5 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1032,6 +1032,16 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 #endif
+#ifdef CONFIG_PROFILING
+	{
+		.ctl_name       = CTL_UNNUMBERED,
+		.procname       = "profiler_enabled",
+		.data           = &profiler_enabled,
+		.maxlen         = sizeof(int),
+		.mode           = 0644,
+		.proc_handler   = &proc_dointvec,
+	},
+#endif
 /*
  * NOTE: do not add new entries to this table unless you have read
  * Documentation/sysctl/ctl_unnumbered.txt
-- 
1.7.4.1.203.g07873

