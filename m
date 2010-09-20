Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757817Ab0ITVpc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 17:45:32 -0400
Received: from kroah.org ([198.145.64.141]:45335 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757779Ab0ITVpa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 17:45:30 -0400
Date: Mon, 20 Sep 2010 14:40:39 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org, lwn@lwn.net
Subject: Re: Linux 2.6.27.53
Message-ID: <20100920214039.GB26264@kroah.com>
References: <20100920214027.GA26264@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100920214027.GA26264@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index 9447d9d..1f60819 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 27
-EXTRAVERSION = .53
+EXTRAVERSION = .54
 NAME = Trembling Tortoise
 
 # *DOCUMENTATION*
diff --git a/arch/ia64/include/asm/compat.h b/arch/ia64/include/asm/compat.h
index dfcf75b..c8662cd 100644
--- a/arch/ia64/include/asm/compat.h
+++ b/arch/ia64/include/asm/compat.h
@@ -198,7 +198,7 @@ ptr_to_compat(void __user *uptr)
 }
 
 static __inline__ void __user *
-compat_alloc_user_space (long len)
+arch_compat_alloc_user_space (long len)
 {
 	struct pt_regs *regs = task_pt_regs(current);
 	return (void __user *) (((regs->r12 & 0xffffffff) & -16) - len);
diff --git a/arch/powerpc/include/asm/compat.h b/arch/powerpc/include/asm/compat.h
index 4774c2f..8d0fff3 100644
--- a/arch/powerpc/include/asm/compat.h
+++ b/arch/powerpc/include/asm/compat.h
@@ -133,7 +133,7 @@ static inline compat_uptr_t ptr_to_compat(void __user *uptr)
 	return (u32)(unsigned long)uptr;
 }
 
-static inline void __user *compat_alloc_user_space(long len)
+static inline void __user *arch_compat_alloc_user_space(long len)
 {
 	struct pt_regs *regs = current->thread.regs;
 	unsigned long usp = regs->gpr[1];
diff --git a/arch/s390/include/asm/compat.h b/arch/s390/include/asm/compat.h
index de065b3..307cac1 100644
--- a/arch/s390/include/asm/compat.h
+++ b/arch/s390/include/asm/compat.h
@@ -163,7 +163,7 @@ static inline compat_uptr_t ptr_to_compat(void __user *uptr)
 	return (u32)(unsigned long)uptr;
 }
 
-static inline void __user *compat_alloc_user_space(long len)
+static inline void __user *arch_compat_alloc_user_space(long len)
 {
 	unsigned long stack;
 
diff --git a/arch/sparc/include/asm/compat.h b/arch/sparc/include/asm/compat.h
index 0e70625..612bb38 100644
--- a/arch/sparc/include/asm/compat.h
+++ b/arch/sparc/include/asm/compat.h
@@ -166,7 +166,7 @@ static inline compat_uptr_t ptr_to_compat(void __user *uptr)
 	return (u32)(unsigned long)uptr;
 }
 
-static inline void __user *compat_alloc_user_space(long len)
+static inline void __user *arch_compat_alloc_user_space(long len)
 {
 	struct pt_regs *regs = current_thread_info()->kregs;
 	unsigned long usp = regs->u_regs[UREG_I6];
diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index 5d7f4af..745bab2 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -50,7 +50,12 @@
 	/*
 	 * Reload arg registers from stack in case ptrace changed them.
 	 * We don't reload %eax because syscall_trace_enter() returned
-	 * the value it wants us to use in the table lookup.
+	 * the %rax value we should see.  Instead, we just truncate that
+	 * value to 32 bits again as we did on entry from user mode.
+	 * If it's a new value set by user_regset during entry tracing,
+	 * this matches the normal truncation of the user-mode value.
+	 * If it's -1 to make us punt the syscall, then (u32)-1 is still
+	 * an appropriately invalid value.
 	 */
 	.macro LOAD_ARGS32 offset, _r9=0
 	.if \_r9
@@ -60,6 +65,7 @@
 	movl \offset+48(%rsp),%edx
 	movl \offset+56(%rsp),%esi
 	movl \offset+64(%rsp),%edi
+	movl %eax,%eax			/* zero extension */
 	.endm
 	
 	.macro CFI_STARTPROC32 simple
@@ -153,7 +159,7 @@ ENTRY(ia32_sysenter_target)
 	testl  $_TIF_WORK_SYSCALL_ENTRY,TI_flags(%r10)
 	CFI_REMEMBER_STATE
 	jnz  sysenter_tracesys
-	cmpl	$(IA32_NR_syscalls-1),%eax
+	cmpq	$(IA32_NR_syscalls-1),%rax
 	ja	ia32_badsys
 sysenter_do_call:
 	IA32_ARG_FIXUP
@@ -195,7 +201,7 @@ sysexit_from_sys_call:
 	movl $AUDIT_ARCH_I386,%edi	/* 1st arg: audit arch */
 	call audit_syscall_entry
 	movl RAX-ARGOFFSET(%rsp),%eax	/* reload syscall number */
-	cmpl $(IA32_NR_syscalls-1),%eax
+	cmpq $(IA32_NR_syscalls-1),%rax
 	ja ia32_badsys
 	movl %ebx,%edi			/* reload 1st syscall arg */
 	movl RCX-ARGOFFSET(%rsp),%esi	/* reload 2nd syscall arg */
@@ -248,7 +254,7 @@ sysenter_tracesys:
 	call	syscall_trace_enter
 	LOAD_ARGS32 ARGOFFSET  /* reload args from stack in case ptrace changed it */
 	RESTORE_REST
-	cmpl	$(IA32_NR_syscalls-1),%eax
+	cmpq	$(IA32_NR_syscalls-1),%rax
 	ja	int_ret_from_sys_call /* sysenter_tracesys has set RAX(%rsp) */
 	jmp	sysenter_do_call
 	CFI_ENDPROC
@@ -314,7 +320,7 @@ ENTRY(ia32_cstar_target)
 	testl $_TIF_WORK_SYSCALL_ENTRY,TI_flags(%r10)
 	CFI_REMEMBER_STATE
 	jnz   cstar_tracesys
-	cmpl $IA32_NR_syscalls-1,%eax
+	cmpq $IA32_NR_syscalls-1,%rax
 	ja  ia32_badsys
 cstar_do_call:
 	IA32_ARG_FIXUP 1
@@ -367,7 +373,7 @@ cstar_tracesys:
 	LOAD_ARGS32 ARGOFFSET, 1  /* reload args from stack in case ptrace changed it */
 	RESTORE_REST
 	xchgl %ebp,%r9d
-	cmpl $(IA32_NR_syscalls-1),%eax
+	cmpq $(IA32_NR_syscalls-1),%rax
 	ja int_ret_from_sys_call /* cstar_tracesys has set RAX(%rsp) */
 	jmp cstar_do_call
 END(ia32_cstar_target)
@@ -425,7 +431,7 @@ ENTRY(ia32_syscall)
 	orl   $TS_COMPAT,TI_status(%r10)
 	testl $_TIF_WORK_SYSCALL_ENTRY,TI_flags(%r10)
 	jnz ia32_tracesys
-	cmpl $(IA32_NR_syscalls-1),%eax
+	cmpq $(IA32_NR_syscalls-1),%rax
 	ja ia32_badsys
 ia32_do_call:
 	IA32_ARG_FIXUP
@@ -444,7 +450,7 @@ ia32_tracesys:
 	call syscall_trace_enter
 	LOAD_ARGS32 ARGOFFSET  /* reload args from stack in case ptrace changed it */
 	RESTORE_REST
-	cmpl $(IA32_NR_syscalls-1),%eax
+	cmpq $(IA32_NR_syscalls-1),%rax
 	ja  int_ret_from_sys_call	/* ia32_tracesys has set RAX(%rsp) */
 	jmp ia32_do_call
 END(ia32_syscall)
diff --git a/drivers/hwmon/f75375s.c b/drivers/hwmon/f75375s.c
index 1692de3..195aea4 100644
--- a/drivers/hwmon/f75375s.c
+++ b/drivers/hwmon/f75375s.c
@@ -79,7 +79,7 @@ I2C_CLIENT_INSMOD_2(f75373, f75375);
 #define F75375_REG_PWM2_DROP_DUTY	0x6C
 
 #define FAN_CTRL_LINEAR(nr)		(4 + nr)
-#define FAN_CTRL_MODE(nr)		(5 + ((nr) * 2))
+#define FAN_CTRL_MODE(nr)		(4 + ((nr) * 2))
 
 /*
  * Data structures and manipulation thereof
@@ -298,7 +298,7 @@ static int set_pwm_enable_direct(struct i2c_client *client, int nr, int val)
 		return -EINVAL;
 
 	fanmode = f75375_read8(client, F75375_REG_FAN_TIMER);
-	fanmode = ~(3 << FAN_CTRL_MODE(nr));
+	fanmode &= ~(3 << FAN_CTRL_MODE(nr));
 
 	switch (val) {
 	case 0: /* Full speed */
@@ -350,7 +350,7 @@ static ssize_t set_pwm_mode(struct device *dev, struct device_attribute *attr,
 
 	mutex_lock(&data->update_lock);
 	conf = f75375_read8(client, F75375_REG_CONFIG1);
-	conf = ~(1 << FAN_CTRL_LINEAR(nr));
+	conf &= ~(1 << FAN_CTRL_LINEAR(nr));
 
 	if (val == 0)
 		conf |= (1 << FAN_CTRL_LINEAR(nr)) ;
diff --git a/drivers/net/wireless/ath9k/ath9k.h b/drivers/net/wireless/ath9k/ath9k.h
index 8ccf374..e4babfb 100644
--- a/drivers/net/wireless/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath9k/ath9k.h
@@ -554,7 +554,7 @@ enum ath9k_cipher {
 
 #define SD_NO_CTL               0xE0
 #define NO_CTL                  0xff
-#define CTL_MODE_M              7
+#define CTL_MODE_M              0xf
 #define CTL_11A                 0
 #define CTL_11B                 1
 #define CTL_11G                 2
diff --git a/drivers/power/apm_power.c b/drivers/power/apm_power.c
index 936bae5..dc628cb 100644
--- a/drivers/power/apm_power.c
+++ b/drivers/power/apm_power.c
@@ -233,6 +233,7 @@ static int calculate_capacity(enum apm_source source)
 		empty_design_prop = POWER_SUPPLY_PROP_ENERGY_EMPTY_DESIGN;
 		now_prop = POWER_SUPPLY_PROP_ENERGY_NOW;
 		avg_prop = POWER_SUPPLY_PROP_ENERGY_AVG;
+		break;
 	case SOURCE_VOLTAGE:
 		full_prop = POWER_SUPPLY_PROP_VOLTAGE_MAX;
 		empty_prop = POWER_SUPPLY_PROP_VOLTAGE_MIN;
diff --git a/include/asm-mips/compat.h b/include/asm-mips/compat.h
index 6c5b409..8df5cee 100644
--- a/include/asm-mips/compat.h
+++ b/include/asm-mips/compat.h
@@ -145,7 +145,7 @@ static inline compat_uptr_t ptr_to_compat(void __user *uptr)
 	return (u32)(unsigned long)uptr;
 }
 
-static inline void __user *compat_alloc_user_space(long len)
+static inline void __user *arch_compat_alloc_user_space(long len)
 {
 	struct pt_regs *regs = (struct pt_regs *)
 		((unsigned long) current_thread_info() + THREAD_SIZE - 32) - 1;
diff --git a/include/asm-parisc/compat.h b/include/asm-parisc/compat.h
index 7f32611..7c77fa9 100644
--- a/include/asm-parisc/compat.h
+++ b/include/asm-parisc/compat.h
@@ -146,7 +146,7 @@ static inline compat_uptr_t ptr_to_compat(void __user *uptr)
 	return (u32)(unsigned long)uptr;
 }
 
-static __inline__ void __user *compat_alloc_user_space(long len)
+static __inline__ void __user *arch_compat_alloc_user_space(long len)
 {
 	struct pt_regs *regs = &current->thread.regs;
 	return (void __user *)regs->gr[30];
diff --git a/include/asm-x86/compat.h b/include/asm-x86/compat.h
index 1793ac3..8b1b00e 100644
--- a/include/asm-x86/compat.h
+++ b/include/asm-x86/compat.h
@@ -204,7 +204,7 @@ static inline compat_uptr_t ptr_to_compat(void __user *uptr)
 	return (u32)(unsigned long)uptr;
 }
 
-static inline void __user *compat_alloc_user_space(long len)
+static inline void __user *arch_compat_alloc_user_space(long len)
 {
 	struct pt_regs *regs = task_pt_regs(current);
 	return (void __user *)regs->sp - len;
diff --git a/include/linux/compat.h b/include/linux/compat.h
index 275b9bd..8cb2fcf 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -291,5 +291,7 @@ asmlinkage long compat_sys_newfstatat(unsigned int dfd, char __user * filename,
 asmlinkage long compat_sys_openat(unsigned int dfd, const char __user *filename,
 				  int flags, int mode);
 
+extern void __user *compat_alloc_user_space(unsigned long len);
+
 #endif /* CONFIG_COMPAT */
 #endif /* _LINUX_COMPAT_H */
diff --git a/kernel/compat.c b/kernel/compat.c
index 32c254a..e0cdde9 100644
--- a/kernel/compat.c
+++ b/kernel/compat.c
@@ -23,6 +23,7 @@
 #include <linux/timex.h>
 #include <linux/migrate.h>
 #include <linux/posix-timers.h>
+#include <linux/module.h>
 
 #include <asm/uaccess.h>
 
@@ -1081,3 +1082,24 @@ compat_sys_sysinfo(struct compat_sysinfo __user *info)
 
 	return 0;
 }
+
+/*
+ * Allocate user-space memory for the duration of a single system call,
+ * in order to marshall parameters inside a compat thunk.
+ */
+void __user *compat_alloc_user_space(unsigned long len)
+{
+	void __user *ptr;
+
+	/* If len would occupy more than half of the entire compat space... */
+	if (unlikely(len > (((compat_uptr_t)~0) >> 1)))
+		return NULL;
+
+	ptr = arch_compat_alloc_user_space(len);
+
+	if (unlikely(!access_ok(VERIFY_WRITE, ptr, len)))
+		return NULL;
+
+	return ptr;
+}
+EXPORT_SYMBOL_GPL(compat_alloc_user_space);
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index f6e3af3..c8b8105 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1456,7 +1456,7 @@ static struct file_operations ftrace_filter_fops = {
 	.open = ftrace_filter_open,
 	.read = ftrace_regex_read,
 	.write = ftrace_filter_write,
-	.llseek = ftrace_regex_lseek,
+	.llseek = no_llseek,
 	.release = ftrace_filter_release,
 };
 
diff --git a/mm/bounce.c b/mm/bounce.c
index b6d2d0f..e83e280 100644
--- a/mm/bounce.c
+++ b/mm/bounce.c
@@ -114,8 +114,8 @@ static void copy_to_high_bio_irq(struct bio *to, struct bio *from)
 		 */
 		vfrom = page_address(fromvec->bv_page) + tovec->bv_offset;
 
-		flush_dcache_page(tovec->bv_page);
 		bounce_copy_vec(tovec, vfrom);
+		flush_dcache_page(tovec->bv_page);
 	}
 }
 
diff --git a/net/irda/irlan/irlan_common.c b/net/irda/irlan/irlan_common.c
index 9a1cd87..b00f5d1 100644
--- a/net/irda/irlan/irlan_common.c
+++ b/net/irda/irlan/irlan_common.c
@@ -1100,7 +1100,7 @@ int irlan_extract_param(__u8 *buf, char *name, char *value, __u16 *len)
 	memcpy(&val_len, buf+n, 2); /* To avoid alignment problems */
 	le16_to_cpus(&val_len); n+=2;
 
-	if (val_len > 1016) {
+	if (val_len >= 1016) {
 		IRDA_DEBUG(2, "%s(), parameter length to long\n", __func__ );
 		return -RSP_INVALID_COMMAND_FORMAT;
 	}
diff --git a/sound/core/seq/oss/seq_oss_init.c b/sound/core/seq/oss/seq_oss_init.c
index d0d721c..1f133fe 100644
--- a/sound/core/seq/oss/seq_oss_init.c
+++ b/sound/core/seq/oss/seq_oss_init.c
@@ -280,13 +280,10 @@ snd_seq_oss_open(struct file *file, int level)
 	return 0;
 
  _error:
-	snd_seq_oss_writeq_delete(dp->writeq);
-	snd_seq_oss_readq_delete(dp->readq);
 	snd_seq_oss_synth_cleanup(dp);
 	snd_seq_oss_midi_cleanup(dp);
-	delete_port(dp);
 	delete_seq_queue(dp->queue);
-	kfree(dp);
+	delete_port(dp);
 
 	return rc;
 }
@@ -349,8 +346,10 @@ create_port(struct seq_oss_devinfo *dp)
 static int
 delete_port(struct seq_oss_devinfo *dp)
 {
-	if (dp->port < 0)
+	if (dp->port < 0) {
+		kfree(dp);
 		return 0;
+	}
 
 	debug_printk(("delete_port %i\n", dp->port));
 	return snd_seq_event_port_detach(dp->cseq, dp->port);
