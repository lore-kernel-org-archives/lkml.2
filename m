Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879Ab1JSAV0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 20:21:26 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48128 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269Ab1JSAVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 20:21:22 -0400
Message-ID: <4E9E17F4.7080306@gmail.com>
Date: Wed, 19 Oct 2011 02:21:08 +0200
From: =?UTF-8?B?xYF1a2FzeiBTb3dh?= <luksow@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20111001 Thunderbird/7.0.1
MIME-Version: 1.0
To: containers@lists.linux-foundation.org
CC: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: [RFC] cgroup: syscalls limiting subsystem
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Currently, I'm writing BSc thesis about security in modern Linux.
Together with my thesis mentor, I decided that as practical part of my
work I'll implement cgroup subsystem that allows to limit particular
(defined by number) syscalls for groups of processes. The patch is ready
for first review and we decided that I may try to push it to the
mainline - so here it is.

The syscalls cgroup subsystem is designed to improve security of
specified container (or simply process under cgroup) by limiting actions
that malicious application or potential attacker can do (for example by
code injection). It's of course more flexible than seccomp because it
gives far more possibilities, more fine-grained than capabilities and
it's different from syscall auditing - it's prevention, not only
detection. It's similar to the, left unmaintained, systrace patch for
Linux.
Recently, I came across article @ LWN https://lwn.net/Articles/458805/
and I noticed that my subsystem addresses some of the problems expressed
under 'API/ABI restrictions' and it would be my rationale for merging
this subsystem into mainline.

Usage of the subsystem is quite simple. To disallow a syscall for given
cgroup you have to echo its number to syscalls.deny. To allow a syscall
you have to echo its number to syscalls.allow (and parent cgroup also
have to have it allowed). Doing 'cat syscalls.allow' or 'cat
syscalls.deny' shows allowed/disallowed syscalls of given cgroup (with
respect of the parents' settings).

Things that I dislike or particularly need comments are:
1. The asm parts where I push/pop callee-modified registers are ugly.
I'm aware of macros (for x64) like SAVE_ARGS and RESTORE_ARGS but they
simply don't work for me because they modify EFLAGS registers (because
of sub instruction I suppose), forcing me to write uglier and less
efficient code (additional jump needed). I can elaborate on this, if
someone's in doubt. Maybe another version of the SAVE_ARGS/RESTORE_ARGS
macro is needed?
2. Performance. It's not that bad: I measured 5% more sys time for
process on root level, and 8% more sys time for processes on first
level. However, I think it may and should be improved but currently
I have no idea how to do it.
3. Naming convention - it's not bad either but I don't like the names -
'scs' abbreviation sound a little bit silly but full form (syscalls)
makes lines far too long.
4. Lack of documentation - I promise I'll write it, as soon as first RFC
will succeed.
5. Last but not least, it's only for x86 and x86-64. I don't know other
archs so I won't be able to port it, though it should be easy.

Please, let me know what you think.

Best Regards,
Lukasz Sowa

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index f3f6f53..7b57e0a 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -425,6 +425,17 @@ sysenter_past_esp:
 sysenter_do_call:
 	cmpl $(nr_syscalls), %eax
 	jae syscall_badsys
+#ifdef CONFIG_CGROUP_SYSCALLS
+	push %eax
+	push %ecx
+	push %edx
+	call scs_cgroup_perm
+	cmpl $0, %eax
+	pop %edx
+	pop %ecx
+	pop %eax
+	je syscall_badsys
+#endif
 	call *sys_call_table(,%eax,4)
 	movl %eax,PT_EAX(%esp)
 	LOCKDEP_SYS_EXIT
@@ -507,6 +518,17 @@ ENTRY(system_call)
 	cmpl $(nr_syscalls), %eax
 	jae syscall_badsys
 syscall_call:
+#ifdef CONFIG_CGROUP_SYSCALLS
+	push %eax
+	push %ecx
+	push %edx
+	call scs_cgroup_perm
+	cmpl $0, %eax
+	pop %edx
+	pop %ecx
+	pop %eax
+	je syscall_badsys
+#endif
 	call *sys_call_table(,%eax,4)
 	movl %eax,PT_EAX(%esp)		# store the return value
 syscall_exit:
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 6419bb0..4f21a00 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -479,6 +479,30 @@ ENTRY(system_call_after_swapgs)
 system_call_fastpath:
 	cmpq $__NR_syscall_max,%rax
 	ja badsys
+#ifdef CONFIG_CGROUP_SYSCALLS
+	pushq %rax
+	pushq %rdi
+	pushq %rsi
+	pushq %rdx
+	pushq %rcx
+	pushq %r8
+	pushq %r9
+	pushq %r10
+	pushq %r11
+	movq %rax, %rdi
+	call scs_cgroup_perm
+	cmpl $0, %eax
+	popq %r11
+	popq %r10
+	popq %r9
+	popq %r8
+	popq %rcx
+	popq %rdx
+	popq %rsi
+	popq %rdi
+	popq %rax
+	je badsys
+#endif
 	movq %r10,%rcx
 	call *sys_call_table(,%rax,8)  # XXX:	 rip relative
 	movq %rax,RAX-ARGOFFSET(%rsp)
@@ -595,6 +619,30 @@ tracesys:
 	RESTORE_REST
 	cmpq $__NR_syscall_max,%rax
 	ja   int_ret_from_sys_call	/* RAX(%rsp) set to -ENOSYS above */
+#ifdef CONFIG_CGROUP_SYSCALLS
+	pushq %rax
+	pushq %rdi
+	pushq %rsi
+	pushq %rdx
+	pushq %rcx
+	pushq %r8
+	pushq %r9
+	pushq %r10
+	pushq %r11
+	movq %rax, %rdi
+	call scs_cgroup_perm
+	cmpl $0, %eax
+	popq %r11
+	popq %r10
+	popq %r9
+	popq %r8
+	popq %rcx
+	popq %rdx
+	popq %rsi
+	popq %rdi
+	popq %rax
+	je int_ret_from_sys_call
+#endif
 	movq %r10,%rcx	/* fixup for C */
 	call *sys_call_table(,%rax,8)
 	movq %rax,RAX-ARGOFFSET(%rsp)
diff --git a/include/linux/cgroup_subsys.h b/include/linux/cgroup_subsys.h
index ac663c1..ad6b600 100644
--- a/include/linux/cgroup_subsys.h
+++ b/include/linux/cgroup_subsys.h
@@ -64,3 +64,9 @@ SUBSYS(perf)
 #endif
  /* */
+
+#ifdef CONFIG_CGROUP_SYSCALLS
+SUBSYS(syscalls)
+#endif
+
+/* */
diff --git a/init/Kconfig b/init/Kconfig
index d627783..a03c16e 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -609,6 +609,13 @@ config CGROUP_DEVICE
 	  Provides a cgroup implementing whitelists for devices which
 	  a process in the cgroup can mknod or open.
 +config CGROUP_SYSCALLS
+	bool "Syscalls controller for cgroups"
+	depends on X86
+	help
+	  Provides a way to limit access to specified syscalls for
+	  tasks in a cgroup.
+
 config CPUSETS
 	bool "Cpuset support"
 	help
diff --git a/security/Makefile b/security/Makefile
index 8bb0fe9..6db6d88 100644
--- a/security/Makefile
+++ b/security/Makefile
@@ -22,6 +22,7 @@ obj-$(CONFIG_AUDIT)			+= lsm_audit.o
 obj-$(CONFIG_SECURITY_TOMOYO)		+= tomoyo/built-in.o
 obj-$(CONFIG_SECURITY_APPARMOR)		+= apparmor/built-in.o
 obj-$(CONFIG_CGROUP_DEVICE)		+= device_cgroup.o
+obj-$(CONFIG_CGROUP_SYSCALLS)	+= syscalls_cgroup.o
  # Object integrity file lists
 subdir-$(CONFIG_IMA)			+= integrity/ima
diff --git a/security/syscalls_cgroup.c b/security/syscalls_cgroup.c
new file mode 100644
index 0000000..cfd0ea0
--- /dev/null
+++ b/security/syscalls_cgroup.c
@@ -0,0 +1,223 @@
+/*
+ * security/syscalls_cgroup.c - syscalls cgroup subsystem
+ *
+ * Copyright (C) 2011 Lukasz Sowa <luksow@gmail.com>
+ */
+
+#include <linux/bitmap.h>
+#include <linux/bitops.h>
+#include <linux/cgroup.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/seq_file.h>
+#include <linux/seqlock.h>
+#include <linux/slab.h>
+
+struct scs_cgroup {
+	unsigned long *syscalls_bitmap;
+	struct cgroup_subsys_state css;
+	seqlock_t seqlock;
+};
+
+static inline struct scs_cgroup *css_to_scs_cgroup(struct cgroup_subsys_state *subsys_state)
+{
+	return container_of(subsys_state, struct scs_cgroup, css);
+}
+
+static inline struct scs_cgroup *cgroup_to_scs_cgroup(struct cgroup *cgroup)
+{
+	if (!cgroup)
+		return NULL;
+
+	return css_to_scs_cgroup(cgroup_subsys_state(cgroup,
+							 syscalls_subsys_id));
+}
+
+static inline struct scs_cgroup *task_to_scs_cgroup(struct task_struct *task)
+{
+	return css_to_scs_cgroup(task_subsys_state(task, syscalls_subsys_id));
+}
+
+/*
+ * The range of syscall number is not checked here, because it is done
+ * in low level assembly code.
+ */
+static int __scs_cgroup_perm(struct scs_cgroup *scg, int number)
+{
+	int ret = 1;
+	unsigned int seq;
+
+	if (scg) {
+		do {
+			seq = read_seqbegin(&scg->seqlock);
+			ret = test_bit(number, scg->syscalls_bitmap) &&
+				__scs_cgroup_perm(cgroup_to_scs_cgroup(scg->css.cgroup->parent),
+								number);
+		} while (read_seqretry(&scg->seqlock, seq));
+	}
+
+	return ret;
+}
+
+inline int scs_cgroup_perm(int number)
+{
+	return __scs_cgroup_perm(task_to_scs_cgroup(current), number);
+}
+
+/*
+ * On cgroup creation, syscalls bitmap is simply inherited from parent. In case
+ * of root cgroup, we set all bits.
+ */
+static struct cgroup_subsys_state *scs_cgroup_create(struct cgroup_subsys *subsys, struct cgroup *cgroup)
+{
+	struct scs_cgroup *scg;
+	struct scs_cgroup *parent_scg;
+	unsigned int seq;
+
+	scg = kmalloc(sizeof(*scg), GFP_KERNEL);
+	if (!scg)
+		return ERR_PTR(-ENOMEM);
+	scg->syscalls_bitmap = kmalloc(BITS_TO_LONGS(NR_syscalls) * sizeof(unsigned long),
+								GFP_KERNEL);
+	if (!scg->syscalls_bitmap) {
+		kfree(scg);
+		return ERR_PTR(-ENOMEM);
+	}
+	seqlock_init(&scg->seqlock);
+
+	parent_scg = cgroup_to_scs_cgroup(cgroup->parent);
+	if (parent_scg) {
+		do {
+			seq = read_seqbegin(&parent_scg->seqlock);
+			bitmap_copy(scg->syscalls_bitmap, parent_scg->syscalls_bitmap,
+					NR_syscalls);
+		} while (read_seqretry(&parent_scg->seqlock, seq));
+	} else {
+		bitmap_fill(scg->syscalls_bitmap, NR_syscalls);
+	}
+
+	return &scg->css;
+}
+
+static void scs_cgroup_destroy(struct cgroup_subsys *subsys,
+							struct cgroup *cgroup)
+{
+	struct scs_cgroup *scg = cgroup_to_scs_cgroup(cgroup);
+	kfree(scg->syscalls_bitmap);
+	kfree(scg);
+}
+
+#define SCS_CGROUP_ALLOW 0
+#define SCS_CGROUP_DENY 1
+
+static int scs_cgroup_read(struct cgroup *cgroup, struct cftype *cftype,
+						struct seq_file *seq_file)
+{
+	struct scs_cgroup *scg = cgroup_to_scs_cgroup(cgroup);
+	int bit;
+
+	switch (cftype->private) {
+	case SCS_CGROUP_ALLOW:
+		for (bit = 0; bit < NR_syscalls; ++bit) {
+			if (__scs_cgroup_perm(scg, bit))
+				seq_printf(seq_file, "%d\n", bit);
+		}
+		break;
+	case SCS_CGROUP_DENY:
+		for (bit = 0; bit < NR_syscalls; ++bit) {
+			if (!__scs_cgroup_perm(scg, bit))
+				seq_printf(seq_file, "%d\n", bit);
+		}
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+/*
+ * It is always possible to blacklist specified syscall but whitelisting
+ * requires that all ancestors have the syscall on their whitelist.
+ */
+static int scs_cgroup_write(struct cgroup *cgroup, struct cftype *cftype,
+							const char *buffer)
+{
+	struct scs_cgroup *scg = cgroup_to_scs_cgroup(cgroup);
+	struct scs_cgroup *parent_scg = cgroup_to_scs_cgroup(cgroup->parent);
+	int number;
+	int ret;
+
+	ret = kstrtoint(buffer, 0, &number);
+	if (ret)
+		return ret;
+
+	if (number < 0 || number >= NR_syscalls)
+		return -ERANGE;
+
+	switch (cftype->private) {
+	case SCS_CGROUP_ALLOW:
+		if (__scs_cgroup_perm(parent_scg, number)) {
+			write_seqlock(&scg->seqlock);
+			set_bit(number, scg->syscalls_bitmap);
+			write_sequnlock(&scg->seqlock);
+		} else {
+			return -EPERM;
+		}
+		break;
+	case SCS_CGROUP_DENY:
+		write_seqlock(&scg->seqlock);
+		clear_bit(number, scg->syscalls_bitmap);
+		write_sequnlock(&scg->seqlock);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static struct cftype scs_cgroup_files[] = {
+	{
+		.name = "allow",
+		.read_seq_string = scs_cgroup_read,
+		.write_string = scs_cgroup_write,
+		.private = SCS_CGROUP_ALLOW,
+	},
+	{
+		.name = "deny",
+		.read_seq_string = scs_cgroup_read,
+		.write_string = scs_cgroup_write,
+		.private = SCS_CGROUP_DENY,
+	}
+};
+
+static int scs_cgroup_populate(struct cgroup_subsys *subsys,
+							struct cgroup *cgroup)
+{
+	return cgroup_add_files(cgroup, subsys, scs_cgroup_files,
+						ARRAY_SIZE(scs_cgroup_files));
+}
+
+struct cgroup_subsys syscalls_subsys = {
+	.name = "syscalls",
+	.create = scs_cgroup_create,
+	.destroy = scs_cgroup_destroy,
+	.populate = scs_cgroup_populate,
+	.subsys_id = syscalls_subsys_id,
+	.module = THIS_MODULE,
+};
+
+static int __init init_syscalls_subsys(void)
+{
+	return cgroup_load_subsys(&syscalls_subsys);
+}
+
+static void __exit exit_syscalls_subsys(void)
+{
+	cgroup_unload_subsys(&syscalls_subsys);
+}
+
+module_init(init_syscalls_subsys);
+module_exit(exit_syscalls_subsys);
+MODULE_LICENSE("GPL");
+
