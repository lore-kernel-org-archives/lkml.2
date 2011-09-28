Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755010Ab1I1U6s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 16:58:48 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:54021 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752733Ab1I1U6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 16:58:37 -0400
X-Sasl-enc: ZVmqyp3VUVTRKbA+OvC+qQ/OvJ5tFf5JoGekRUrDbYA1 1317243512
Date: Wed, 28 Sep 2011 13:58:27 -0700
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org
Subject: Linux 3.0.4 in patch form
Message-ID: <20110928205827.GA16167@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0/kgSOzhNoDC5T3a"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0/kgSOzhNoDC5T3a
Content-Type: multipart/mixed; boundary="1ccMZA6j1vT5UqiK"
Content-Disposition: inline


--1ccMZA6j1vT5UqiK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi all,

As I'm getting more and more requests every day for the latest stable
kernel patch, I figured it's best if I just email it out to the list, so
that everyone can have a copy of it without having to dig for the past 4
patches to have something that works.

So here's the 3.0.4 patch, which can be applied on top of the 3.0
release from Linus.  You can get a copy of the 3.0 release from various
places around the web, I'll not be able to mail that to the whole list.

I'm also signing this message, with my "traditional" GPG key, which is
in the web of trust, so as to try to provide a bit of validity to this
message.

If anyone has any questions about this, please let me know.

thanks,

greg k-h

--1ccMZA6j1vT5UqiK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="patch-3.0.4"
Content-Transfer-Encoding: quoted-printable

diff --git a/Documentation/virtual/lguest/lguest.c b/Documentation/virtual/=
lguest/lguest.c
index cd9d6af..aec80e5 100644
--- a/Documentation/virtual/lguest/lguest.c
+++ b/Documentation/virtual/lguest/lguest.c
@@ -2008,6 +2008,9 @@ int main(int argc, char *argv[])
 	/* We use a simple helper to copy the arguments separated by spaces. */
 	concat((char *)(boot + 1), argv+optind+2);
=20
+	/* Set kernel alignment to 16M (CONFIG_PHYSICAL_ALIGN) */
+	boot->hdr.kernel_alignment =3D 0x1000000;
+
 	/* Boot protocol version: 2.07 supports the fields for lguest. */
 	boot->hdr.version =3D 0x207;
=20
diff --git a/Makefile b/Makefile
index 6a5bdad..7d2192c 100644
--- a/Makefile
+++ b/Makefile
@@ -1,6 +1,6 @@
 VERSION =3D 3
 PATCHLEVEL =3D 0
-SUBLEVEL =3D 0
+SUBLEVEL =3D 4
 EXTRAVERSION =3D
 NAME =3D Sneaky Weasel
=20
diff --git a/arch/alpha/kernel/time.c b/arch/alpha/kernel/time.c
index 818e74e..f20d1b5 100644
--- a/arch/alpha/kernel/time.c
+++ b/arch/alpha/kernel/time.c
@@ -91,7 +91,7 @@ DEFINE_PER_CPU(u8, irq_work_pending);
 #define test_irq_work_pending()      __get_cpu_var(irq_work_pending)
 #define clear_irq_work_pending()     __get_cpu_var(irq_work_pending) =3D 0
=20
-void set_irq_work_pending(void)
+void arch_irq_work_raise(void)
 {
 	set_irq_work_pending_flag();
 }
diff --git a/arch/arm/mach-pxa/cm-x300.c b/arch/arm/mach-pxa/cm-x300.c
index b2248e7..8a03487 100644
--- a/arch/arm/mach-pxa/cm-x300.c
+++ b/arch/arm/mach-pxa/cm-x300.c
@@ -161,10 +161,10 @@ static mfp_cfg_t cm_x3xx_mfp_cfg[] __initdata =3D {
 	GPIO99_GPIO,			/* Ethernet IRQ */
=20
 	/* RTC GPIOs */
-	GPIO95_GPIO,			/* RTC CS */
-	GPIO96_GPIO,			/* RTC WR */
-	GPIO97_GPIO,			/* RTC RD */
-	GPIO98_GPIO,			/* RTC IO */
+	GPIO95_GPIO | MFP_LPM_DRIVE_HIGH,	/* RTC CS */
+	GPIO96_GPIO | MFP_LPM_DRIVE_HIGH,	/* RTC WR */
+	GPIO97_GPIO | MFP_LPM_DRIVE_HIGH,	/* RTC RD */
+	GPIO98_GPIO,				/* RTC IO */
=20
 	/* Standard I2C */
 	GPIO21_I2C_SCL,
diff --git a/arch/cris/arch-v10/drivers/sync_serial.c b/arch/cris/arch-v10/=
drivers/sync_serial.c
index 85026537..466af40 100644
--- a/arch/cris/arch-v10/drivers/sync_serial.c
+++ b/arch/cris/arch-v10/drivers/sync_serial.c
@@ -158,7 +158,7 @@ static int sync_serial_open(struct inode *inode, struct=
 file *file);
 static int sync_serial_release(struct inode *inode, struct file *file);
 static unsigned int sync_serial_poll(struct file *filp, poll_table *wait);
=20
-static int sync_serial_ioctl(struct file *file,
+static long sync_serial_ioctl(struct file *file,
 	unsigned int cmd, unsigned long arg);
 static ssize_t sync_serial_write(struct file *file, const char *buf,
 	size_t count, loff_t *ppos);
@@ -625,11 +625,11 @@ static int sync_serial_open(struct inode *inode, stru=
ct file *file)
 			*R_IRQ_MASK1_SET =3D 1 << port->data_avail_bit;
 		DEBUG(printk(KERN_DEBUG "sser%d rec started\n", dev));
 	}
-	ret =3D 0;
+	err =3D 0;
 =09
 out:
 	mutex_unlock(&sync_serial_mutex);
-	return ret;
+	return err;
 }
=20
 static int sync_serial_release(struct inode *inode, struct file *file)
diff --git a/arch/cris/arch-v10/kernel/irq.c b/arch/cris/arch-v10/kernel/ir=
q.c
index 907cfb5..ba0e596 100644
--- a/arch/cris/arch-v10/kernel/irq.c
+++ b/arch/cris/arch-v10/kernel/irq.c
@@ -20,6 +20,9 @@
 #define crisv10_mask_irq(irq_nr) (*R_VECT_MASK_CLR =3D 1 << (irq_nr));
 #define crisv10_unmask_irq(irq_nr) (*R_VECT_MASK_SET =3D 1 << (irq_nr));
=20
+extern void kgdb_init(void);
+extern void breakpoint(void);
+
 /* don't use set_int_vector, it bypasses the linux interrupt handlers. it =
is
  * global just so that the kernel gdb can use it.
  */
diff --git a/arch/cris/include/asm/thread_info.h b/arch/cris/include/asm/th=
read_info.h
index 29b74a1..332f19c 100644
--- a/arch/cris/include/asm/thread_info.h
+++ b/arch/cris/include/asm/thread_info.h
@@ -11,8 +11,6 @@
=20
 #ifdef __KERNEL__
=20
-#define __HAVE_ARCH_THREAD_INFO_ALLOCATOR
-
 #ifndef __ASSEMBLY__
 #include <asm/types.h>
 #include <asm/processor.h>
@@ -67,8 +65,10 @@ struct thread_info {
=20
 #define init_thread_info	(init_thread_union.thread_info)
=20
+#define __HAVE_ARCH_THREAD_INFO_ALLOCATOR
 /* thread information allocation */
-#define alloc_thread_info(tsk, node) ((struct thread_info *) __get_free_pa=
ges(GFP_KERNEL,1))
+#define alloc_thread_info_node(tsk, node)	\
+	((struct thread_info *) __get_free_pages(GFP_KERNEL, 1))
 #define free_thread_info(ti) free_pages((unsigned long) (ti), 1)
=20
 #endif /* !__ASSEMBLY__ */
diff --git a/arch/parisc/include/asm/atomic.h b/arch/parisc/include/asm/ato=
mic.h
index f819559..26fd114 100644
--- a/arch/parisc/include/asm/atomic.h
+++ b/arch/parisc/include/asm/atomic.h
@@ -259,10 +259,10 @@ static __inline__ int atomic_add_unless(atomic_t *v, =
int a, int u)
=20
 #define ATOMIC64_INIT(i) ((atomic64_t) { (i) })
=20
-static __inline__ int
+static __inline__ s64
 __atomic64_add_return(s64 i, atomic64_t *v)
 {
-	int ret;
+	s64 ret;
 	unsigned long flags;
 	_atomic_spin_lock_irqsave(v, flags);
=20
diff --git a/arch/parisc/include/asm/futex.h b/arch/parisc/include/asm/fute=
x.h
index 67a33cc..2388bdb 100644
--- a/arch/parisc/include/asm/futex.h
+++ b/arch/parisc/include/asm/futex.h
@@ -5,11 +5,14 @@
=20
 #include <linux/futex.h>
 #include <linux/uaccess.h>
+#include <asm/atomic.h>
 #include <asm/errno.h>
=20
 static inline int
 futex_atomic_op_inuser (int encoded_op, u32 __user *uaddr)
 {
+	unsigned long int flags;
+	u32 val;
 	int op =3D (encoded_op >> 28) & 7;
 	int cmp =3D (encoded_op >> 24) & 15;
 	int oparg =3D (encoded_op << 8) >> 20;
@@ -18,21 +21,58 @@ futex_atomic_op_inuser (int encoded_op, u32 __user *uad=
dr)
 	if (encoded_op & (FUTEX_OP_OPARG_SHIFT << 28))
 		oparg =3D 1 << oparg;
=20
-	if (! access_ok (VERIFY_WRITE, uaddr, sizeof(u32)))
+	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(*uaddr)))
 		return -EFAULT;
=20
 	pagefault_disable();
=20
+	_atomic_spin_lock_irqsave(uaddr, flags);
+
 	switch (op) {
 	case FUTEX_OP_SET:
+		/* *(int *)UADDR2 =3D OPARG; */
+		ret =3D get_user(oldval, uaddr);
+		if (!ret)
+			ret =3D put_user(oparg, uaddr);
+		break;
 	case FUTEX_OP_ADD:
+		/* *(int *)UADDR2 +=3D OPARG; */
+		ret =3D get_user(oldval, uaddr);
+		if (!ret) {
+			val =3D oldval + oparg;
+			ret =3D put_user(val, uaddr);
+		}
+		break;
 	case FUTEX_OP_OR:
+		/* *(int *)UADDR2 |=3D OPARG; */
+		ret =3D get_user(oldval, uaddr);
+		if (!ret) {
+			val =3D oldval | oparg;
+			ret =3D put_user(val, uaddr);
+		}
+		break;
 	case FUTEX_OP_ANDN:
+		/* *(int *)UADDR2 &=3D ~OPARG; */
+		ret =3D get_user(oldval, uaddr);
+		if (!ret) {
+			val =3D oldval & ~oparg;
+			ret =3D put_user(val, uaddr);
+		}
+		break;
 	case FUTEX_OP_XOR:
+		/* *(int *)UADDR2 ^=3D OPARG; */
+		ret =3D get_user(oldval, uaddr);
+		if (!ret) {
+			val =3D oldval ^ oparg;
+			ret =3D put_user(val, uaddr);
+		}
+		break;
 	default:
 		ret =3D -ENOSYS;
 	}
=20
+	_atomic_spin_unlock_irqrestore(uaddr, flags);
+
 	pagefault_enable();
=20
 	if (!ret) {
@@ -54,7 +94,9 @@ static inline int
 futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
 			      u32 oldval, u32 newval)
 {
+	int ret;
 	u32 val;
+	unsigned long flags;
=20
 	/* futex.c wants to do a cmpxchg_inatomic on kernel NULL, which is
 	 * our gateway page, and causes no end of trouble...
@@ -65,12 +107,24 @@ futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *u=
addr,
 	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(u32)))
 		return -EFAULT;
=20
-	if (get_user(val, uaddr))
-		return -EFAULT;
-	if (val =3D=3D oldval && put_user(newval, uaddr))
-		return -EFAULT;
+	/* HPPA has no cmpxchg in hardware and therefore the
+	 * best we can do here is use an array of locks. The
+	 * lock selected is based on a hash of the userspace
+	 * address. This should scale to a couple of CPUs.
+	 */
+
+	_atomic_spin_lock_irqsave(uaddr, flags);
+
+	ret =3D get_user(val, uaddr);
+
+	if (!ret && val =3D=3D oldval)
+		ret =3D put_user(newval, uaddr);
+
 	*uval =3D val;
-	return 0;
+
+	_atomic_spin_unlock_irqrestore(uaddr, flags);
+
+	return ret;
 }
=20
 #endif /*__KERNEL__*/
diff --git a/arch/parisc/include/asm/unistd.h b/arch/parisc/include/asm/uni=
std.h
index 3392de3..d61de64 100644
--- a/arch/parisc/include/asm/unistd.h
+++ b/arch/parisc/include/asm/unistd.h
@@ -821,8 +821,9 @@
 #define __NR_open_by_handle_at	(__NR_Linux + 326)
 #define __NR_syncfs		(__NR_Linux + 327)
 #define __NR_setns		(__NR_Linux + 328)
+#define __NR_sendmmsg		(__NR_Linux + 329)
=20
-#define __NR_Linux_syscalls	(__NR_setns + 1)
+#define __NR_Linux_syscalls	(__NR_sendmmsg + 1)
=20
=20
 #define __IGNORE_select		/* newselect */
diff --git a/arch/parisc/kernel/syscall_table.S b/arch/parisc/kernel/syscal=
l_table.S
index 34a4f5a..e66366f 100644
--- a/arch/parisc/kernel/syscall_table.S
+++ b/arch/parisc/kernel/syscall_table.S
@@ -427,6 +427,7 @@
 	ENTRY_COMP(open_by_handle_at)
 	ENTRY_SAME(syncfs)
 	ENTRY_SAME(setns)
+	ENTRY_COMP(sendmmsg)
=20
 	/* Nothing yet */
=20
diff --git a/arch/powerpc/kernel/crash.c b/arch/powerpc/kernel/crash.c
index 4e6ee94..cc6a9d5 100644
--- a/arch/powerpc/kernel/crash.c
+++ b/arch/powerpc/kernel/crash.c
@@ -242,12 +242,8 @@ static void crash_kexec_wait_realmode(int cpu)
=20
 		while (paca[i].kexec_state < KEXEC_STATE_REAL_MODE) {
 			barrier();
-			if (!cpu_possible(i)) {
+			if (!cpu_possible(i) || !cpu_online(i) || (msecs <=3D 0))
 				break;
-			}
-			if (!cpu_online(i)) {
-				break;
-			}
 			msecs--;
 			mdelay(1);
 		}
diff --git a/arch/powerpc/kernel/prom_init.c b/arch/powerpc/kernel/prom_ini=
t.c
index c016033..3b22142 100644
--- a/arch/powerpc/kernel/prom_init.c
+++ b/arch/powerpc/kernel/prom_init.c
@@ -1020,7 +1020,7 @@ static unsigned long __init alloc_up(unsigned long si=
ze, unsigned long align)
 	}
 	if (addr =3D=3D 0)
 		return 0;
-	RELOC(alloc_bottom) =3D addr;
+	RELOC(alloc_bottom) =3D addr + size;
=20
 	prom_debug(" -> %x\n", addr);
 	prom_debug("  alloc_bottom : %x\n", RELOC(alloc_bottom));
@@ -1834,7 +1834,7 @@ static void __init *make_room(unsigned long *mem_star=
t, unsigned long *mem_end,
 		chunk =3D alloc_up(room, 0);
 		if (chunk =3D=3D 0)
 			prom_panic("No memory for flatten_device_tree (claim failed)");
-		*mem_end =3D RELOC(alloc_top);
+		*mem_end =3D chunk + room;
 	}
=20
 	ret =3D (void *)*mem_start;
@@ -2053,7 +2053,7 @@ static void __init flatten_device_tree(void)
 	mem_start =3D (unsigned long)alloc_up(room, PAGE_SIZE);
 	if (mem_start =3D=3D 0)
 		prom_panic("Can't allocate initial device-tree chunk\n");
-	mem_end =3D RELOC(alloc_top);
+	mem_end =3D mem_start + room;
=20
 	/* Get root of tree */
 	root =3D call_prom("peer", 1, 1, (phandle)0);
diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index f33acfd..03b29a6 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -544,7 +544,7 @@ DEFINE_PER_CPU(u8, irq_work_pending);
=20
 #endif /* 32 vs 64 bit */
=20
-void set_irq_work_pending(void)
+void arch_irq_work_raise(void)
 {
 	preempt_disable();
 	set_irq_work_pending_flag();
diff --git a/arch/powerpc/platforms/pseries/dtl.c b/arch/powerpc/platforms/=
pseries/dtl.c
index e919007..0e86563 100644
--- a/arch/powerpc/platforms/pseries/dtl.c
+++ b/arch/powerpc/platforms/pseries/dtl.c
@@ -181,7 +181,7 @@ static void dtl_stop(struct dtl *dtl)
=20
 	lppaca_of(dtl->cpu).dtl_enable_mask =3D 0x0;
=20
-	unregister_dtl(hwcpu, __pa(dtl->buf));
+	unregister_dtl(hwcpu);
 }
=20
 static u64 dtl_current_index(struct dtl *dtl)
diff --git a/arch/powerpc/platforms/pseries/hvconsole.c b/arch/powerpc/plat=
forms/pseries/hvconsole.c
index 3f6a89b..041e87c 100644
--- a/arch/powerpc/platforms/pseries/hvconsole.c
+++ b/arch/powerpc/platforms/pseries/hvconsole.c
@@ -73,7 +73,7 @@ int hvc_put_chars(uint32_t vtermno, const char *buf, int =
count)
 	if (ret =3D=3D H_SUCCESS)
 		return count;
 	if (ret =3D=3D H_BUSY)
-		return 0;
+		return -EAGAIN;
 	return -EIO;
 }
=20
diff --git a/arch/powerpc/platforms/pseries/kexec.c b/arch/powerpc/platform=
s/pseries/kexec.c
index 54cf3a4..1118cb7 100644
--- a/arch/powerpc/platforms/pseries/kexec.c
+++ b/arch/powerpc/platforms/pseries/kexec.c
@@ -26,6 +26,17 @@ static void pseries_kexec_cpu_down(int crash_shutdown, i=
nt secondary)
 	/* Don't risk a hypervisor call if we're crashing */
 	if (firmware_has_feature(FW_FEATURE_SPLPAR) && !crash_shutdown) {
 		unsigned long addr;
+		int ret;
+
+		if (get_lppaca()->dtl_enable_mask) {
+			ret =3D unregister_dtl(hard_smp_processor_id());
+			if (ret) {
+				pr_err("WARNING: DTL deregistration for cpu "
+				       "%d (hw %d) failed with %d\n",
+				       smp_processor_id(),
+				       hard_smp_processor_id(), ret);
+			}
+		}
=20
 		addr =3D __pa(get_slb_shadow());
 		if (unregister_slb_shadow(hard_smp_processor_id(), addr))
diff --git a/arch/powerpc/platforms/pseries/lpar.c b/arch/powerpc/platforms=
/pseries/lpar.c
index 39e6e0a..ed96b37 100644
--- a/arch/powerpc/platforms/pseries/lpar.c
+++ b/arch/powerpc/platforms/pseries/lpar.c
@@ -395,7 +395,7 @@ static void pSeries_lpar_hptab_clear(void)
 		unsigned long ptel;
 	} ptes[4];
 	long lpar_rc;
-	int i, j;
+	unsigned long i, j;
=20
 	/* Read in batches of 4,
 	 * invalidate only valid entries not in the VRMA
diff --git a/arch/powerpc/platforms/pseries/plpar_wrappers.h b/arch/powerpc=
/platforms/pseries/plpar_wrappers.h
index 4bf2120..a6921ae 100644
--- a/arch/powerpc/platforms/pseries/plpar_wrappers.h
+++ b/arch/powerpc/platforms/pseries/plpar_wrappers.h
@@ -73,9 +73,9 @@ static inline long register_slb_shadow(unsigned long cpu,=
 unsigned long vpa)
 	return vpa_call(0x3, cpu, vpa);
 }
=20
-static inline long unregister_dtl(unsigned long cpu, unsigned long vpa)
+static inline long unregister_dtl(unsigned long cpu)
 {
-	return vpa_call(0x6, cpu, vpa);
+	return vpa_call(0x6, cpu, 0);
 }
=20
 static inline long register_dtl(unsigned long cpu, unsigned long vpa)
diff --git a/arch/sparc/include/asm/bitops_64.h b/arch/sparc/include/asm/bi=
tops_64.h
index 38e9aa1..3fc595a 100644
--- a/arch/sparc/include/asm/bitops_64.h
+++ b/arch/sparc/include/asm/bitops_64.h
@@ -26,61 +26,28 @@ extern void change_bit(unsigned long nr, volatile unsig=
ned long *addr);
 #define smp_mb__before_clear_bit()	barrier()
 #define smp_mb__after_clear_bit()	barrier()
=20
-#include <asm-generic/bitops/ffz.h>
-#include <asm-generic/bitops/__ffs.h>
 #include <asm-generic/bitops/fls.h>
 #include <asm-generic/bitops/__fls.h>
 #include <asm-generic/bitops/fls64.h>
=20
 #ifdef __KERNEL__
=20
+extern int ffs(int x);
+extern unsigned long __ffs(unsigned long);
+
+#include <asm-generic/bitops/ffz.h>
 #include <asm-generic/bitops/sched.h>
-#include <asm-generic/bitops/ffs.h>
=20
 /*
  * hweightN: returns the hamming weight (i.e. the number
  * of bits set) of a N-bit word
  */
=20
-#ifdef ULTRA_HAS_POPULATION_COUNT
-
-static inline unsigned int __arch_hweight64(unsigned long w)
-{
-	unsigned int res;
-
-	__asm__ ("popc %1,%0" : "=3Dr" (res) : "r" (w));
-	return res;
-}
-
-static inline unsigned int __arch_hweight32(unsigned int w)
-{
-	unsigned int res;
-
-	__asm__ ("popc %1,%0" : "=3Dr" (res) : "r" (w & 0xffffffff));
-	return res;
-}
+extern unsigned long __arch_hweight64(__u64 w);
+extern unsigned int __arch_hweight32(unsigned int w);
+extern unsigned int __arch_hweight16(unsigned int w);
+extern unsigned int __arch_hweight8(unsigned int w);
=20
-static inline unsigned int __arch_hweight16(unsigned int w)
-{
-	unsigned int res;
-
-	__asm__ ("popc %1,%0" : "=3Dr" (res) : "r" (w & 0xffff));
-	return res;
-}
-
-static inline unsigned int __arch_hweight8(unsigned int w)
-{
-	unsigned int res;
-
-	__asm__ ("popc %1,%0" : "=3Dr" (res) : "r" (w & 0xff));
-	return res;
-}
-
-#else
-
-#include <asm-generic/bitops/arch_hweight.h>
-
-#endif
 #include <asm-generic/bitops/const_hweight.h>
 #include <asm-generic/bitops/lock.h>
 #endif /* __KERNEL__ */
diff --git a/arch/sparc/include/asm/elf_64.h b/arch/sparc/include/asm/elf_6=
4.h
index e678803..7df8b7f 100644
--- a/arch/sparc/include/asm/elf_64.h
+++ b/arch/sparc/include/asm/elf_64.h
@@ -59,15 +59,33 @@
 #define R_SPARC_6		45
=20
 /* Bits present in AT_HWCAP, primarily for Sparc32.  */
-
-#define HWCAP_SPARC_FLUSH       1    /* CPU supports flush instruction. */
-#define HWCAP_SPARC_STBAR       2
-#define HWCAP_SPARC_SWAP        4
-#define HWCAP_SPARC_MULDIV      8
-#define HWCAP_SPARC_V9		16
-#define HWCAP_SPARC_ULTRA3	32
-#define HWCAP_SPARC_BLKINIT	64
-#define HWCAP_SPARC_N2		128
+#define HWCAP_SPARC_FLUSH       0x00000001
+#define HWCAP_SPARC_STBAR       0x00000002
+#define HWCAP_SPARC_SWAP        0x00000004
+#define HWCAP_SPARC_MULDIV      0x00000008
+#define HWCAP_SPARC_V9		0x00000010
+#define HWCAP_SPARC_ULTRA3	0x00000020
+#define HWCAP_SPARC_BLKINIT	0x00000040
+#define HWCAP_SPARC_N2		0x00000080
+
+/* Solaris compatible AT_HWCAP bits. */
+#define AV_SPARC_MUL32		0x00000100 /* 32x32 multiply is efficient */
+#define AV_SPARC_DIV32		0x00000200 /* 32x32 divide is efficient */
+#define AV_SPARC_FSMULD		0x00000400 /* 'fsmuld' is efficient */
+#define AV_SPARC_V8PLUS		0x00000800 /* v9 insn available to 32bit */
+#define AV_SPARC_POPC		0x00001000 /* 'popc' is efficient */
+#define AV_SPARC_VIS		0x00002000 /* VIS insns available */
+#define AV_SPARC_VIS2		0x00004000 /* VIS2 insns available */
+#define AV_SPARC_ASI_BLK_INIT	0x00008000 /* block init ASIs available */
+#define AV_SPARC_FMAF		0x00010000 /* fused multiply-add */
+#define AV_SPARC_VIS3		0x00020000 /* VIS3 insns available */
+#define AV_SPARC_HPC		0x00040000 /* HPC insns available */
+#define AV_SPARC_RANDOM		0x00080000 /* 'random' insn available */
+#define AV_SPARC_TRANS		0x00100000 /* transaction insns available */
+#define AV_SPARC_FJFMAU		0x00200000 /* unfused multiply-add */
+#define AV_SPARC_IMA		0x00400000 /* integer multiply-add */
+#define AV_SPARC_ASI_CACHE_SPARING \
+				0x00800000 /* cache sparing ASIs available */
=20
 #define CORE_DUMP_USE_REGSET
=20
@@ -162,31 +180,8 @@ typedef struct {
 #define ELF_ET_DYN_BASE		0x0000010000000000UL
 #define COMPAT_ELF_ET_DYN_BASE	0x0000000070000000UL
=20
-
-/* This yields a mask that user programs can use to figure out what
-   instruction set this cpu supports.  */
-
-/* On Ultra, we support all of the v8 capabilities. */
-static inline unsigned int sparc64_elf_hwcap(void)
-{
-	unsigned int cap =3D (HWCAP_SPARC_FLUSH | HWCAP_SPARC_STBAR |
-			    HWCAP_SPARC_SWAP | HWCAP_SPARC_MULDIV |
-			    HWCAP_SPARC_V9);
-
-	if (tlb_type =3D=3D cheetah || tlb_type =3D=3D cheetah_plus)
-		cap |=3D HWCAP_SPARC_ULTRA3;
-	else if (tlb_type =3D=3D hypervisor) {
-		if (sun4v_chip_type =3D=3D SUN4V_CHIP_NIAGARA1 ||
-		    sun4v_chip_type =3D=3D SUN4V_CHIP_NIAGARA2)
-			cap |=3D HWCAP_SPARC_BLKINIT;
-		if (sun4v_chip_type =3D=3D SUN4V_CHIP_NIAGARA2)
-			cap |=3D HWCAP_SPARC_N2;
-	}
-
-	return cap;
-}
-
-#define ELF_HWCAP	sparc64_elf_hwcap();
+extern unsigned long sparc64_elf_hwcap;
+#define ELF_HWCAP	sparc64_elf_hwcap
=20
 /* This yields a string that ld.so will use to load implementation
    specific libraries for optimization.  This is more specific in
diff --git a/arch/sparc/include/asm/hypervisor.h b/arch/sparc/include/asm/h=
ypervisor.h
index 7568640..015a761 100644
--- a/arch/sparc/include/asm/hypervisor.h
+++ b/arch/sparc/include/asm/hypervisor.h
@@ -2927,6 +2927,13 @@ extern unsigned long sun4v_ncs_request(unsigned long=
 request,
 #define HV_FAST_FIRE_GET_PERFREG	0x120
 #define HV_FAST_FIRE_SET_PERFREG	0x121
=20
+#define HV_FAST_REBOOT_DATA_SET		0x172
+
+#ifndef __ASSEMBLY__
+extern unsigned long sun4v_reboot_data_set(unsigned long ra,
+					   unsigned long len);
+#endif
+
 /* Function numbers for HV_CORE_TRAP.  */
 #define HV_CORE_SET_VER			0x00
 #define HV_CORE_PUTCHAR			0x01
@@ -2940,16 +2947,23 @@ extern unsigned long sun4v_ncs_request(unsigned lon=
g request,
 #define HV_GRP_CORE			0x0001
 #define HV_GRP_INTR			0x0002
 #define HV_GRP_SOFT_STATE		0x0003
+#define HV_GRP_TM			0x0080
 #define HV_GRP_PCI			0x0100
 #define HV_GRP_LDOM			0x0101
 #define HV_GRP_SVC_CHAN			0x0102
 #define HV_GRP_NCS			0x0103
 #define HV_GRP_RNG			0x0104
+#define HV_GRP_PBOOT			0x0105
+#define HV_GRP_TPM			0x0107
+#define HV_GRP_SDIO			0x0108
+#define HV_GRP_SDIO_ERR			0x0109
+#define HV_GRP_REBOOT_DATA		0x0110
 #define HV_GRP_NIAG_PERF		0x0200
 #define HV_GRP_FIRE_PERF		0x0201
 #define HV_GRP_N2_CPU			0x0202
 #define HV_GRP_NIU			0x0204
 #define HV_GRP_VF_CPU			0x0205
+#define HV_GRP_KT_CPU			0x0209
 #define HV_GRP_DIAG			0x0300
=20
 #ifndef __ASSEMBLY__
diff --git a/arch/sparc/include/asm/spitfire.h b/arch/sparc/include/asm/spi=
tfire.h
index f0d0c40..55a17c6 100644
--- a/arch/sparc/include/asm/spitfire.h
+++ b/arch/sparc/include/asm/spitfire.h
@@ -42,6 +42,7 @@
 #define SUN4V_CHIP_INVALID	0x00
 #define SUN4V_CHIP_NIAGARA1	0x01
 #define SUN4V_CHIP_NIAGARA2	0x02
+#define SUN4V_CHIP_NIAGARA3	0x03
 #define SUN4V_CHIP_UNKNOWN	0xff
=20
 #ifndef __ASSEMBLY__
diff --git a/arch/sparc/include/asm/tsb.h b/arch/sparc/include/asm/tsb.h
index 83c571d..1a8afd1 100644
--- a/arch/sparc/include/asm/tsb.h
+++ b/arch/sparc/include/asm/tsb.h
@@ -133,29 +133,6 @@ extern struct tsb_phys_patch_entry __tsb_phys_patch, _=
_tsb_phys_patch_end;
 	sub	TSB, 0x8, TSB;   \
 	TSB_STORE(TSB, TAG);
=20
-#define KTSB_LOAD_QUAD(TSB, REG) \
-	ldda		[TSB] ASI_NUCLEUS_QUAD_LDD, REG;
-
-#define KTSB_STORE(ADDR, VAL) \
-	stxa		VAL, [ADDR] ASI_N;
-
-#define KTSB_LOCK_TAG(TSB, REG1, REG2)	\
-99:	lduwa	[TSB] ASI_N, REG1;	\
-	sethi	%hi(TSB_TAG_LOCK_HIGH), REG2;\
-	andcc	REG1, REG2, %g0;	\
-	bne,pn	%icc, 99b;		\
-	 nop;				\
-	casa	[TSB] ASI_N, REG1, REG2;\
-	cmp	REG1, REG2;		\
-	bne,pn	%icc, 99b;		\
-	 nop;				\
-
-#define KTSB_WRITE(TSB, TTE, TAG) \
-	add	TSB, 0x8, TSB;   \
-	stxa	TTE, [TSB] ASI_N;     \
-	sub	TSB, 0x8, TSB;   \
-	stxa	TAG, [TSB] ASI_N;
-
 	/* Do a kernel page table walk.  Leaves physical PTE pointer in
 	 * REG1.  Jumps to FAIL_LABEL on early page table walk termination.
 	 * VADDR will not be clobbered, but REG2 will.
@@ -239,6 +216,8 @@ extern struct tsb_phys_patch_entry __tsb_phys_patch, __=
tsb_phys_patch_end;
 	(KERNEL_TSB_SIZE_BYTES / 16)
 #define KERNEL_TSB4M_NENTRIES	4096
=20
+#define KTSB_PHYS_SHIFT		15
+
 	/* Do a kernel TSB lookup at tl>0 on VADDR+TAG, branch to OK_LABEL
 	 * on TSB hit.  REG1, REG2, REG3, and REG4 are used as temporaries
 	 * and the found TTE will be left in REG1.  REG3 and REG4 must
@@ -247,13 +226,22 @@ extern struct tsb_phys_patch_entry __tsb_phys_patch, =
__tsb_phys_patch_end;
 	 * VADDR and TAG will be preserved and not clobbered by this macro.
 	 */
 #define KERN_TSB_LOOKUP_TL1(VADDR, TAG, REG1, REG2, REG3, REG4, OK_LABEL) \
-	sethi		%hi(swapper_tsb), REG1; \
+661:	sethi		%hi(swapper_tsb), REG1;			\
 	or		REG1, %lo(swapper_tsb), REG1; \
+	.section	.swapper_tsb_phys_patch, "ax"; \
+	.word		661b; \
+	.previous; \
+661:	nop; \
+	.section	.tsb_ldquad_phys_patch, "ax"; \
+	.word		661b; \
+	sllx		REG1, KTSB_PHYS_SHIFT, REG1; \
+	sllx		REG1, KTSB_PHYS_SHIFT, REG1; \
+	.previous; \
 	srlx		VADDR, PAGE_SHIFT, REG2; \
 	and		REG2, (KERNEL_TSB_NENTRIES - 1), REG2; \
 	sllx		REG2, 4, REG2; \
 	add		REG1, REG2, REG2; \
-	KTSB_LOAD_QUAD(REG2, REG3); \
+	TSB_LOAD_QUAD(REG2, REG3); \
 	cmp		REG3, TAG; \
 	be,a,pt		%xcc, OK_LABEL; \
 	 mov		REG4, REG1;
@@ -263,12 +251,21 @@ extern struct tsb_phys_patch_entry __tsb_phys_patch, =
__tsb_phys_patch_end;
 	 * we can make use of that for the index computation.
 	 */
 #define KERN_TSB4M_LOOKUP_TL1(TAG, REG1, REG2, REG3, REG4, OK_LABEL) \
-	sethi		%hi(swapper_4m_tsb), REG1; \
+661:	sethi		%hi(swapper_4m_tsb), REG1;	     \
 	or		REG1, %lo(swapper_4m_tsb), REG1; \
+	.section	.swapper_4m_tsb_phys_patch, "ax"; \
+	.word		661b; \
+	.previous; \
+661:	nop; \
+	.section	.tsb_ldquad_phys_patch, "ax"; \
+	.word		661b; \
+	sllx		REG1, KTSB_PHYS_SHIFT, REG1; \
+	sllx		REG1, KTSB_PHYS_SHIFT, REG1; \
+	.previous; \
 	and		TAG, (KERNEL_TSB4M_NENTRIES - 1), REG2; \
 	sllx		REG2, 4, REG2; \
 	add		REG1, REG2, REG2; \
-	KTSB_LOAD_QUAD(REG2, REG3); \
+	TSB_LOAD_QUAD(REG2, REG3); \
 	cmp		REG3, TAG; \
 	be,a,pt		%xcc, OK_LABEL; \
 	 mov		REG4, REG1;
diff --git a/arch/sparc/include/asm/xor_64.h b/arch/sparc/include/asm/xor_6=
4.h
index bee4bf4..9ed6ff6 100644
--- a/arch/sparc/include/asm/xor_64.h
+++ b/arch/sparc/include/asm/xor_64.h
@@ -65,6 +65,7 @@ static struct xor_block_template xor_block_niagara =3D {
 #define XOR_SELECT_TEMPLATE(FASTEST) \
 	((tlb_type =3D=3D hypervisor && \
 	  (sun4v_chip_type =3D=3D SUN4V_CHIP_NIAGARA1 || \
-	   sun4v_chip_type =3D=3D SUN4V_CHIP_NIAGARA2)) ? \
+	   sun4v_chip_type =3D=3D SUN4V_CHIP_NIAGARA2 || \
+	   sun4v_chip_type =3D=3D SUN4V_CHIP_NIAGARA3)) ? \
 	 &xor_block_niagara : \
 	 &xor_block_VIS)
diff --git a/arch/sparc/kernel/cpu.c b/arch/sparc/kernel/cpu.c
index 138dbbc..9810fd8 100644
--- a/arch/sparc/kernel/cpu.c
+++ b/arch/sparc/kernel/cpu.c
@@ -396,6 +396,7 @@ static int show_cpuinfo(struct seq_file *m, void *__unu=
sed)
 		   , cpu_data(0).clock_tick
 #endif
 		);
+	cpucap_info(m);
 #ifdef CONFIG_SMP
 	smp_bogo(m);
 #endif
@@ -474,11 +475,18 @@ static void __init sun4v_cpu_probe(void)
 		sparc_pmu_type =3D "niagara2";
 		break;
=20
+	case SUN4V_CHIP_NIAGARA3:
+		sparc_cpu_type =3D "UltraSparc T3 (Niagara3)";
+		sparc_fpu_type =3D "UltraSparc T3 integrated FPU";
+		sparc_pmu_type =3D "niagara3";
+		break;
+
 	default:
 		printk(KERN_WARNING "CPU: Unknown sun4v cpu type [%s]\n",
 		       prom_cpu_compatible);
 		sparc_cpu_type =3D "Unknown SUN4V CPU";
 		sparc_fpu_type =3D "Unknown SUN4V FPU";
+		sparc_pmu_type =3D "Unknown SUN4V PMU";
 		break;
 	}
 }
diff --git a/arch/sparc/kernel/cpumap.c b/arch/sparc/kernel/cpumap.c
index d91fd78..4197e8d 100644
--- a/arch/sparc/kernel/cpumap.c
+++ b/arch/sparc/kernel/cpumap.c
@@ -324,6 +324,7 @@ static int iterate_cpu(struct cpuinfo_tree *t, unsigned=
 int root_index)
 	switch (sun4v_chip_type) {
 	case SUN4V_CHIP_NIAGARA1:
 	case SUN4V_CHIP_NIAGARA2:
+	case SUN4V_CHIP_NIAGARA3:
 		rover_inc_table =3D niagara_iterate_method;
 		break;
 	default:
diff --git a/arch/sparc/kernel/ds.c b/arch/sparc/kernel/ds.c
index dd1342c..7429b47 100644
--- a/arch/sparc/kernel/ds.c
+++ b/arch/sparc/kernel/ds.c
@@ -15,12 +15,15 @@
 #include <linux/reboot.h>
 #include <linux/cpu.h>
=20
+#include <asm/hypervisor.h>
 #include <asm/ldc.h>
 #include <asm/vio.h>
 #include <asm/mdesc.h>
 #include <asm/head.h>
 #include <asm/irq.h>
=20
+#include "kernel.h"
+
 #define DRV_MODULE_NAME		"ds"
 #define PFX DRV_MODULE_NAME	": "
 #define DRV_MODULE_VERSION	"1.0"
@@ -828,18 +831,32 @@ void ldom_set_var(const char *var, const char *value)
 	}
 }
=20
+static char full_boot_str[256] __attribute__((aligned(32)));
+static int reboot_data_supported;
+
 void ldom_reboot(const char *boot_command)
 {
 	/* Don't bother with any of this if the boot_command
 	 * is empty.
 	 */
 	if (boot_command && strlen(boot_command)) {
-		char full_boot_str[256];
+		unsigned long len;
=20
 		strcpy(full_boot_str, "boot ");
 		strcpy(full_boot_str + strlen("boot "), boot_command);
+		len =3D strlen(full_boot_str);
=20
-		ldom_set_var("reboot-command", full_boot_str);
+		if (reboot_data_supported) {
+			unsigned long ra =3D kimage_addr_to_ra(full_boot_str);
+			unsigned long hv_ret;
+
+			hv_ret =3D sun4v_reboot_data_set(ra, len);
+			if (hv_ret !=3D HV_EOK)
+				pr_err("SUN4V: Unable to set reboot data "
+				       "hv_ret=3D%lu\n", hv_ret);
+		} else {
+			ldom_set_var("reboot-command", full_boot_str);
+		}
 	}
 	sun4v_mach_sir();
 }
@@ -1237,6 +1254,16 @@ static struct vio_driver ds_driver =3D {
=20
 static int __init ds_init(void)
 {
+	unsigned long hv_ret, major, minor;
+
+	if (tlb_type =3D=3D hypervisor) {
+		hv_ret =3D sun4v_get_version(HV_GRP_REBOOT_DATA, &major, &minor);
+		if (hv_ret =3D=3D HV_EOK) {
+			pr_info("SUN4V: Reboot data supported (maj=3D%lu,min=3D%lu).\n",
+				major, minor);
+			reboot_data_supported =3D 1;
+		}
+	}
 	kthread_run(ds_thread, NULL, "kldomd");
=20
 	return vio_register_driver(&ds_driver);
diff --git a/arch/sparc/kernel/entry.h b/arch/sparc/kernel/entry.h
index d1f1361..e27f8ea 100644
--- a/arch/sparc/kernel/entry.h
+++ b/arch/sparc/kernel/entry.h
@@ -42,6 +42,20 @@ extern void fpsave(unsigned long *fpregs, unsigned long =
*fsr,
 extern void fpload(unsigned long *fpregs, unsigned long *fsr);
=20
 #else /* CONFIG_SPARC32 */
+struct popc_3insn_patch_entry {
+	unsigned int	addr;
+	unsigned int	insns[3];
+};
+extern struct popc_3insn_patch_entry __popc_3insn_patch,
+	__popc_3insn_patch_end;
+
+struct popc_6insn_patch_entry {
+	unsigned int	addr;
+	unsigned int	insns[6];
+};
+extern struct popc_6insn_patch_entry __popc_6insn_patch,
+	__popc_6insn_patch_end;
+
 extern void __init per_cpu_patch(void);
 extern void __init sun4v_patch(void);
 extern void __init boot_cpu_id_too_large(int cpu);
diff --git a/arch/sparc/kernel/head_64.S b/arch/sparc/kernel/head_64.S
index aa594c7..0cbab31 100644
--- a/arch/sparc/kernel/head_64.S
+++ b/arch/sparc/kernel/head_64.S
@@ -132,6 +132,8 @@ prom_sun4v_name:
 	.asciz	"sun4v"
 prom_niagara_prefix:
 	.asciz	"SUNW,UltraSPARC-T"
+prom_sparc_prefix:
+	.asciz	"SPARC-T"
 	.align	4
 prom_root_compatible:
 	.skip	64
@@ -382,6 +384,22 @@ sun4v_chip_type:
 90:	ldub	[%g7], %g2
 	ldub	[%g1], %g4
 	cmp	%g2, %g4
+	bne,pn	%icc, 89f
+	 add	%g7, 1, %g7
+	subcc	%g3, 1, %g3
+	bne,pt	%xcc, 90b
+	 add	%g1, 1, %g1
+	ba,pt	%xcc, 91f
+	 nop
+
+89:	sethi	%hi(prom_cpu_compatible), %g1
+	or	%g1, %lo(prom_cpu_compatible), %g1
+	sethi	%hi(prom_sparc_prefix), %g7
+	or	%g7, %lo(prom_sparc_prefix), %g7
+	mov	7, %g3
+90:	ldub	[%g7], %g2
+	ldub	[%g1], %g4
+	cmp	%g2, %g4
 	bne,pn	%icc, 4f
 	 add	%g7, 1, %g7
 	subcc	%g3, 1, %g3
@@ -390,6 +408,15 @@ sun4v_chip_type:
=20
 	sethi	%hi(prom_cpu_compatible), %g1
 	or	%g1, %lo(prom_cpu_compatible), %g1
+	ldub	[%g1 + 7], %g2
+	cmp	%g2, '3'
+	be,pt	%xcc, 5f
+	 mov	SUN4V_CHIP_NIAGARA3, %g4
+	ba,pt	%xcc, 4f
+	 nop
+
+91:	sethi	%hi(prom_cpu_compatible), %g1
+	or	%g1, %lo(prom_cpu_compatible), %g1
 	ldub	[%g1 + 17], %g2
 	cmp	%g2, '1'
 	be,pt	%xcc, 5f
@@ -397,6 +424,7 @@ sun4v_chip_type:
 	cmp	%g2, '2'
 	be,pt	%xcc, 5f
 	 mov	SUN4V_CHIP_NIAGARA2, %g4
+
 4:
 	mov	SUN4V_CHIP_UNKNOWN, %g4
 5:	sethi	%hi(sun4v_chip_type), %g2
@@ -514,6 +542,9 @@ niagara_tlb_fixup:
 	 cmp	%g1, SUN4V_CHIP_NIAGARA2
 	be,pt	%xcc, niagara2_patch
 	 nop
+	cmp	%g1, SUN4V_CHIP_NIAGARA3
+	be,pt	%xcc, niagara2_patch
+	 nop
=20
 	call	generic_patch_copyops
 	 nop
@@ -528,7 +559,7 @@ niagara2_patch:
 	 nop
 	call	niagara_patch_bzero
 	 nop
-	call	niagara2_patch_pageops
+	call	niagara_patch_pageops
 	 nop
=20
 	ba,a,pt	%xcc, 80f
diff --git a/arch/sparc/kernel/hvapi.c b/arch/sparc/kernel/hvapi.c
index 7c60afb..c2d055d 100644
--- a/arch/sparc/kernel/hvapi.c
+++ b/arch/sparc/kernel/hvapi.c
@@ -28,16 +28,23 @@ static struct api_info api_table[] =3D {
 	{ .group =3D HV_GRP_CORE,		.flags =3D FLAG_PRE_API	},
 	{ .group =3D HV_GRP_INTR,					},
 	{ .group =3D HV_GRP_SOFT_STATE,				},
+	{ .group =3D HV_GRP_TM,					},
 	{ .group =3D HV_GRP_PCI,		.flags =3D FLAG_PRE_API	},
 	{ .group =3D HV_GRP_LDOM,					},
 	{ .group =3D HV_GRP_SVC_CHAN,	.flags =3D FLAG_PRE_API	},
 	{ .group =3D HV_GRP_NCS,		.flags =3D FLAG_PRE_API	},
 	{ .group =3D HV_GRP_RNG,					},
+	{ .group =3D HV_GRP_PBOOT,				},
+	{ .group =3D HV_GRP_TPM,					},
+	{ .group =3D HV_GRP_SDIO,					},
+	{ .group =3D HV_GRP_SDIO_ERR,				},
+	{ .group =3D HV_GRP_REBOOT_DATA,				},
 	{ .group =3D HV_GRP_NIAG_PERF,	.flags =3D FLAG_PRE_API	},
 	{ .group =3D HV_GRP_FIRE_PERF,				},
 	{ .group =3D HV_GRP_N2_CPU,				},
 	{ .group =3D HV_GRP_NIU,					},
 	{ .group =3D HV_GRP_VF_CPU,				},
+	{ .group =3D HV_GRP_KT_CPU,				},
 	{ .group =3D HV_GRP_DIAG,		.flags =3D FLAG_PRE_API	},
 };
=20
diff --git a/arch/sparc/kernel/hvcalls.S b/arch/sparc/kernel/hvcalls.S
index 8a5f35f..58d60de 100644
--- a/arch/sparc/kernel/hvcalls.S
+++ b/arch/sparc/kernel/hvcalls.S
@@ -798,3 +798,10 @@ ENTRY(sun4v_niagara2_setperf)
 	retl
 	 nop
 ENDPROC(sun4v_niagara2_setperf)
+
+ENTRY(sun4v_reboot_data_set)
+	mov	HV_FAST_REBOOT_DATA_SET, %o5
+	ta	HV_FAST_TRAP
+	retl
+	 nop
+ENDPROC(sun4v_reboot_data_set)
diff --git a/arch/sparc/kernel/kernel.h b/arch/sparc/kernel/kernel.h
index 6f6544c..fd6c36b 100644
--- a/arch/sparc/kernel/kernel.h
+++ b/arch/sparc/kernel/kernel.h
@@ -4,12 +4,27 @@
 #include <linux/interrupt.h>
=20
 #include <asm/traps.h>
+#include <asm/head.h>
+#include <asm/io.h>
=20
 /* cpu.c */
 extern const char *sparc_pmu_type;
 extern unsigned int fsr_storage;
 extern int ncpus_probed;
=20
+#ifdef CONFIG_SPARC64
+/* setup_64.c */
+struct seq_file;
+extern void cpucap_info(struct seq_file *);
+
+static inline unsigned long kimage_addr_to_ra(const char *p)
+{
+	unsigned long val =3D (unsigned long) p;
+
+	return kern_base + (val - KERNBASE);
+}
+#endif
+
 #ifdef CONFIG_SPARC32
 /* cpu.c */
 extern void cpu_probe(void);
diff --git a/arch/sparc/kernel/ktlb.S b/arch/sparc/kernel/ktlb.S
index 1d36147..79f3103 100644
--- a/arch/sparc/kernel/ktlb.S
+++ b/arch/sparc/kernel/ktlb.S
@@ -47,16 +47,16 @@ kvmap_itlb_tsb_miss:
 kvmap_itlb_vmalloc_addr:
 	KERN_PGTABLE_WALK(%g4, %g5, %g2, kvmap_itlb_longpath)
=20
-	KTSB_LOCK_TAG(%g1, %g2, %g7)
+	TSB_LOCK_TAG(%g1, %g2, %g7)
=20
 	/* Load and check PTE.  */
 	ldxa		[%g5] ASI_PHYS_USE_EC, %g5
 	mov		1, %g7
 	sllx		%g7, TSB_TAG_INVALID_BIT, %g7
 	brgez,a,pn	%g5, kvmap_itlb_longpath
-	 KTSB_STORE(%g1, %g7)
+	 TSB_STORE(%g1, %g7)
=20
-	KTSB_WRITE(%g1, %g5, %g6)
+	TSB_WRITE(%g1, %g5, %g6)
=20
 	/* fallthrough to TLB load */
=20
@@ -102,9 +102,9 @@ kvmap_itlb_longpath:
 kvmap_itlb_obp:
 	OBP_TRANS_LOOKUP(%g4, %g5, %g2, %g3, kvmap_itlb_longpath)
=20
-	KTSB_LOCK_TAG(%g1, %g2, %g7)
+	TSB_LOCK_TAG(%g1, %g2, %g7)
=20
-	KTSB_WRITE(%g1, %g5, %g6)
+	TSB_WRITE(%g1, %g5, %g6)
=20
 	ba,pt		%xcc, kvmap_itlb_load
 	 nop
@@ -112,17 +112,17 @@ kvmap_itlb_obp:
 kvmap_dtlb_obp:
 	OBP_TRANS_LOOKUP(%g4, %g5, %g2, %g3, kvmap_dtlb_longpath)
=20
-	KTSB_LOCK_TAG(%g1, %g2, %g7)
+	TSB_LOCK_TAG(%g1, %g2, %g7)
=20
-	KTSB_WRITE(%g1, %g5, %g6)
+	TSB_WRITE(%g1, %g5, %g6)
=20
 	ba,pt		%xcc, kvmap_dtlb_load
 	 nop
=20
 	.align		32
 kvmap_dtlb_tsb4m_load:
-	KTSB_LOCK_TAG(%g1, %g2, %g7)
-	KTSB_WRITE(%g1, %g5, %g6)
+	TSB_LOCK_TAG(%g1, %g2, %g7)
+	TSB_WRITE(%g1, %g5, %g6)
 	ba,pt		%xcc, kvmap_dtlb_load
 	 nop
=20
@@ -222,16 +222,16 @@ kvmap_linear_patch:
 kvmap_dtlb_vmalloc_addr:
 	KERN_PGTABLE_WALK(%g4, %g5, %g2, kvmap_dtlb_longpath)
=20
-	KTSB_LOCK_TAG(%g1, %g2, %g7)
+	TSB_LOCK_TAG(%g1, %g2, %g7)
=20
 	/* Load and check PTE.  */
 	ldxa		[%g5] ASI_PHYS_USE_EC, %g5
 	mov		1, %g7
 	sllx		%g7, TSB_TAG_INVALID_BIT, %g7
 	brgez,a,pn	%g5, kvmap_dtlb_longpath
-	 KTSB_STORE(%g1, %g7)
+	 TSB_STORE(%g1, %g7)
=20
-	KTSB_WRITE(%g1, %g5, %g6)
+	TSB_WRITE(%g1, %g5, %g6)
=20
 	/* fallthrough to TLB load */
=20
diff --git a/arch/sparc/kernel/mdesc.c b/arch/sparc/kernel/mdesc.c
index 42f28c7..acaebb6 100644
--- a/arch/sparc/kernel/mdesc.c
+++ b/arch/sparc/kernel/mdesc.c
@@ -508,6 +508,8 @@ const char *mdesc_node_name(struct mdesc_handle *hp, u6=
4 node)
 }
 EXPORT_SYMBOL(mdesc_node_name);
=20
+static u64 max_cpus =3D 64;
+
 static void __init report_platform_properties(void)
 {
 	struct mdesc_handle *hp =3D mdesc_grab();
@@ -543,8 +545,10 @@ static void __init report_platform_properties(void)
 	if (v)
 		printk("PLATFORM: watchdog-max-timeout [%llu ms]\n", *v);
 	v =3D mdesc_get_property(hp, pn, "max-cpus", NULL);
-	if (v)
-		printk("PLATFORM: max-cpus [%llu]\n", *v);
+	if (v) {
+		max_cpus =3D *v;
+		printk("PLATFORM: max-cpus [%llu]\n", max_cpus);
+	}
=20
 #ifdef CONFIG_SMP
 	{
@@ -715,7 +719,7 @@ static void __cpuinit set_proc_ids(struct mdesc_handle =
*hp)
 }
=20
 static void __cpuinit get_one_mondo_bits(const u64 *p, unsigned int *mask,
-					 unsigned char def)
+					 unsigned long def, unsigned long max)
 {
 	u64 val;
=20
@@ -726,6 +730,9 @@ static void __cpuinit get_one_mondo_bits(const u64 *p, =
unsigned int *mask,
 	if (!val || val >=3D 64)
 		goto use_default;
=20
+	if (val > max)
+		val =3D max;
+
 	*mask =3D ((1U << val) * 64U) - 1U;
 	return;
=20
@@ -736,19 +743,28 @@ use_default:
 static void __cpuinit get_mondo_data(struct mdesc_handle *hp, u64 mp,
 				     struct trap_per_cpu *tb)
 {
+	static int printed;
 	const u64 *val;
=20
 	val =3D mdesc_get_property(hp, mp, "q-cpu-mondo-#bits", NULL);
-	get_one_mondo_bits(val, &tb->cpu_mondo_qmask, 7);
+	get_one_mondo_bits(val, &tb->cpu_mondo_qmask, 7, ilog2(max_cpus * 2));
=20
 	val =3D mdesc_get_property(hp, mp, "q-dev-mondo-#bits", NULL);
-	get_one_mondo_bits(val, &tb->dev_mondo_qmask, 7);
+	get_one_mondo_bits(val, &tb->dev_mondo_qmask, 7, 8);
=20
 	val =3D mdesc_get_property(hp, mp, "q-resumable-#bits", NULL);
-	get_one_mondo_bits(val, &tb->resum_qmask, 6);
+	get_one_mondo_bits(val, &tb->resum_qmask, 6, 7);
=20
 	val =3D mdesc_get_property(hp, mp, "q-nonresumable-#bits", NULL);
-	get_one_mondo_bits(val, &tb->nonresum_qmask, 2);
+	get_one_mondo_bits(val, &tb->nonresum_qmask, 2, 2);
+	if (!printed++) {
+		pr_info("SUN4V: Mondo queue sizes "
+			"[cpu(%u) dev(%u) r(%u) nr(%u)]\n",
+			tb->cpu_mondo_qmask + 1,
+			tb->dev_mondo_qmask + 1,
+			tb->resum_qmask + 1,
+			tb->nonresum_qmask + 1);
+	}
 }
=20
 static void * __cpuinit mdesc_iterate_over_cpus(void *(*func)(struct mdesc=
_handle *, u64, int, void *), void *arg, cpumask_t *mask)
diff --git a/arch/sparc/kernel/pcr.c b/arch/sparc/kernel/pcr.c
index 8ac23e6..343b0f9 100644
--- a/arch/sparc/kernel/pcr.c
+++ b/arch/sparc/kernel/pcr.c
@@ -80,8 +80,11 @@ static void n2_pcr_write(u64 val)
 {
 	unsigned long ret;
=20
-	ret =3D sun4v_niagara2_setperf(HV_N2_PERF_SPARC_CTL, val);
-	if (ret !=3D HV_EOK)
+	if (val & PCR_N2_HTRACE) {
+		ret =3D sun4v_niagara2_setperf(HV_N2_PERF_SPARC_CTL, val);
+		if (ret !=3D HV_EOK)
+			write_pcr(val);
+	} else
 		write_pcr(val);
 }
=20
@@ -106,6 +109,10 @@ static int __init register_perf_hsvc(void)
 			perf_hsvc_group =3D HV_GRP_N2_CPU;
 			break;
=20
+		case SUN4V_CHIP_NIAGARA3:
+			perf_hsvc_group =3D HV_GRP_KT_CPU;
+			break;
+
 		default:
 			return -ENODEV;
 		}
diff --git a/arch/sparc/kernel/perf_event.c b/arch/sparc/kernel/perf_event.c
index 2cb0e1c..6860d40 100644
--- a/arch/sparc/kernel/perf_event.c
+++ b/arch/sparc/kernel/perf_event.c
@@ -1301,7 +1301,8 @@ static bool __init supported_pmu(void)
 		sparc_pmu =3D &niagara1_pmu;
 		return true;
 	}
-	if (!strcmp(sparc_pmu_type, "niagara2")) {
+	if (!strcmp(sparc_pmu_type, "niagara2") ||
+	    !strcmp(sparc_pmu_type, "niagara3")) {
 		sparc_pmu =3D &niagara2_pmu;
 		return true;
 	}
diff --git a/arch/sparc/kernel/setup_64.c b/arch/sparc/kernel/setup_64.c
index c4dd099..3e9daea 100644
--- a/arch/sparc/kernel/setup_64.c
+++ b/arch/sparc/kernel/setup_64.c
@@ -29,6 +29,7 @@
 #include <linux/interrupt.h>
 #include <linux/cpu.h>
 #include <linux/initrd.h>
+#include <linux/module.h>
=20
 #include <asm/system.h>
 #include <asm/io.h>
@@ -46,6 +47,8 @@
 #include <asm/mmu.h>
 #include <asm/ns87303.h>
 #include <asm/btext.h>
+#include <asm/elf.h>
+#include <asm/mdesc.h>
=20
 #ifdef CONFIG_IP_PNP
 #include <net/ipconfig.h>
@@ -269,6 +272,40 @@ void __init sun4v_patch(void)
 	sun4v_hvapi_init();
 }
=20
+static void __init popc_patch(void)
+{
+	struct popc_3insn_patch_entry *p3;
+	struct popc_6insn_patch_entry *p6;
+
+	p3 =3D &__popc_3insn_patch;
+	while (p3 < &__popc_3insn_patch_end) {
+		unsigned long i, addr =3D p3->addr;
+
+		for (i =3D 0; i < 3; i++) {
+			*(unsigned int *) (addr +  (i * 4)) =3D p3->insns[i];
+			wmb();
+			__asm__ __volatile__("flush	%0"
+					     : : "r" (addr +  (i * 4)));
+		}
+
+		p3++;
+	}
+
+	p6 =3D &__popc_6insn_patch;
+	while (p6 < &__popc_6insn_patch_end) {
+		unsigned long i, addr =3D p6->addr;
+
+		for (i =3D 0; i < 6; i++) {
+			*(unsigned int *) (addr +  (i * 4)) =3D p6->insns[i];
+			wmb();
+			__asm__ __volatile__("flush	%0"
+					     : : "r" (addr +  (i * 4)));
+		}
+
+		p6++;
+	}
+}
+
 #ifdef CONFIG_SMP
 void __init boot_cpu_id_too_large(int cpu)
 {
@@ -278,6 +315,154 @@ void __init boot_cpu_id_too_large(int cpu)
 }
 #endif
=20
+/* On Ultra, we support all of the v8 capabilities. */
+unsigned long sparc64_elf_hwcap =3D (HWCAP_SPARC_FLUSH | HWCAP_SPARC_STBAR=
 |
+				   HWCAP_SPARC_SWAP | HWCAP_SPARC_MULDIV |
+				   HWCAP_SPARC_V9);
+EXPORT_SYMBOL(sparc64_elf_hwcap);
+
+static const char *hwcaps[] =3D {
+	"flush", "stbar", "swap", "muldiv", "v9",
+	"ultra3", "blkinit", "n2",
+
+	/* These strings are as they appear in the machine description
+	 * 'hwcap-list' property for cpu nodes.
+	 */
+	"mul32", "div32", "fsmuld", "v8plus", "popc", "vis", "vis2",
+	"ASIBlkInit", "fmaf", "vis3", "hpc", "random", "trans", "fjfmau",
+	"ima", "cspare",
+};
+
+void cpucap_info(struct seq_file *m)
+{
+	unsigned long caps =3D sparc64_elf_hwcap;
+	int i, printed =3D 0;
+
+	seq_puts(m, "cpucaps\t\t: ");
+	for (i =3D 0; i < ARRAY_SIZE(hwcaps); i++) {
+		unsigned long bit =3D 1UL << i;
+		if (caps & bit) {
+			seq_printf(m, "%s%s",
+				   printed ? "," : "", hwcaps[i]);
+			printed++;
+		}
+	}
+	seq_putc(m, '\n');
+}
+
+static void __init report_hwcaps(unsigned long caps)
+{
+	int i, printed =3D 0;
+
+	printk(KERN_INFO "CPU CAPS: [");
+	for (i =3D 0; i < ARRAY_SIZE(hwcaps); i++) {
+		unsigned long bit =3D 1UL << i;
+		if (caps & bit) {
+			printk(KERN_CONT "%s%s",
+			       printed ? "," : "", hwcaps[i]);
+			if (++printed =3D=3D 8) {
+				printk(KERN_CONT "]\n");
+				printk(KERN_INFO "CPU CAPS: [");
+				printed =3D 0;
+			}
+		}
+	}
+	printk(KERN_CONT "]\n");
+}
+
+static unsigned long __init mdesc_cpu_hwcap_list(void)
+{
+	struct mdesc_handle *hp;
+	unsigned long caps =3D 0;
+	const char *prop;
+	int len;
+	u64 pn;
+
+	hp =3D mdesc_grab();
+	if (!hp)
+		return 0;
+
+	pn =3D mdesc_node_by_name(hp, MDESC_NODE_NULL, "cpu");
+	if (pn =3D=3D MDESC_NODE_NULL)
+		goto out;
+
+	prop =3D mdesc_get_property(hp, pn, "hwcap-list", &len);
+	if (!prop)
+		goto out;
+
+	while (len) {
+		int i, plen;
+
+		for (i =3D 0; i < ARRAY_SIZE(hwcaps); i++) {
+			unsigned long bit =3D 1UL << i;
+
+			if (!strcmp(prop, hwcaps[i])) {
+				caps |=3D bit;
+				break;
+			}
+		}
+
+		plen =3D strlen(prop) + 1;
+		prop +=3D plen;
+		len -=3D plen;
+	}
+
+out:
+	mdesc_release(hp);
+	return caps;
+}
+
+/* This yields a mask that user programs can use to figure out what
+ * instruction set this cpu supports.
+ */
+static void __init init_sparc64_elf_hwcap(void)
+{
+	unsigned long cap =3D sparc64_elf_hwcap;
+	unsigned long mdesc_caps;
+
+	if (tlb_type =3D=3D cheetah || tlb_type =3D=3D cheetah_plus)
+		cap |=3D HWCAP_SPARC_ULTRA3;
+	else if (tlb_type =3D=3D hypervisor) {
+		if (sun4v_chip_type =3D=3D SUN4V_CHIP_NIAGARA1 ||
+		    sun4v_chip_type =3D=3D SUN4V_CHIP_NIAGARA2 ||
+		    sun4v_chip_type =3D=3D SUN4V_CHIP_NIAGARA3)
+			cap |=3D HWCAP_SPARC_BLKINIT;
+		if (sun4v_chip_type =3D=3D SUN4V_CHIP_NIAGARA2 ||
+		    sun4v_chip_type =3D=3D SUN4V_CHIP_NIAGARA3)
+			cap |=3D HWCAP_SPARC_N2;
+	}
+
+	cap |=3D (AV_SPARC_MUL32 | AV_SPARC_DIV32 | AV_SPARC_V8PLUS);
+
+	mdesc_caps =3D mdesc_cpu_hwcap_list();
+	if (!mdesc_caps) {
+		if (tlb_type =3D=3D spitfire)
+			cap |=3D AV_SPARC_VIS;
+		if (tlb_type =3D=3D cheetah || tlb_type =3D=3D cheetah_plus)
+			cap |=3D AV_SPARC_VIS | AV_SPARC_VIS2;
+		if (tlb_type =3D=3D cheetah_plus)
+			cap |=3D AV_SPARC_POPC;
+		if (tlb_type =3D=3D hypervisor) {
+			if (sun4v_chip_type =3D=3D SUN4V_CHIP_NIAGARA1)
+				cap |=3D AV_SPARC_ASI_BLK_INIT;
+			if (sun4v_chip_type =3D=3D SUN4V_CHIP_NIAGARA2 ||
+			    sun4v_chip_type =3D=3D SUN4V_CHIP_NIAGARA3)
+				cap |=3D (AV_SPARC_VIS | AV_SPARC_VIS2 |
+					AV_SPARC_ASI_BLK_INIT |
+					AV_SPARC_POPC);
+			if (sun4v_chip_type =3D=3D SUN4V_CHIP_NIAGARA3)
+				cap |=3D (AV_SPARC_VIS3 | AV_SPARC_HPC |
+					AV_SPARC_FMAF);
+		}
+	}
+	sparc64_elf_hwcap =3D cap | mdesc_caps;
+
+	report_hwcaps(sparc64_elf_hwcap);
+
+	if (sparc64_elf_hwcap & AV_SPARC_POPC)
+		popc_patch();
+}
+
 void __init setup_arch(char **cmdline_p)
 {
 	/* Initialize PROM console and command line. */
@@ -337,6 +522,7 @@ void __init setup_arch(char **cmdline_p)
 	init_cur_cpu_trap(current_thread_info());
=20
 	paging_init();
+	init_sparc64_elf_hwcap();
 }
=20
 extern int stop_a_enabled;
diff --git a/arch/sparc/kernel/sparc_ksyms_64.c b/arch/sparc/kernel/sparc_k=
syms_64.c
index 372ad59..83b47ab 100644
--- a/arch/sparc/kernel/sparc_ksyms_64.c
+++ b/arch/sparc/kernel/sparc_ksyms_64.c
@@ -8,6 +8,7 @@
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/init.h>
+#include <linux/bitops.h>
=20
 #include <asm/system.h>
 #include <asm/cpudata.h>
@@ -38,5 +39,15 @@ EXPORT_SYMBOL(sun4v_niagara_setperf);
 EXPORT_SYMBOL(sun4v_niagara2_getperf);
 EXPORT_SYMBOL(sun4v_niagara2_setperf);
=20
+/* from hweight.S */
+EXPORT_SYMBOL(__arch_hweight8);
+EXPORT_SYMBOL(__arch_hweight16);
+EXPORT_SYMBOL(__arch_hweight32);
+EXPORT_SYMBOL(__arch_hweight64);
+
+/* from ffs_ffz.S */
+EXPORT_SYMBOL(ffs);
+EXPORT_SYMBOL(__ffs);
+
 /* Exporting a symbol from /init/main.c */
 EXPORT_SYMBOL(saved_command_line);
diff --git a/arch/sparc/kernel/sstate.c b/arch/sparc/kernel/sstate.c
index 8cdbe59..c59af54 100644
--- a/arch/sparc/kernel/sstate.c
+++ b/arch/sparc/kernel/sstate.c
@@ -14,14 +14,9 @@
 #include <asm/head.h>
 #include <asm/io.h>
=20
-static int hv_supports_soft_state;
-
-static unsigned long kimage_addr_to_ra(const char *p)
-{
-	unsigned long val =3D (unsigned long) p;
+#include "kernel.h"
=20
-	return kern_base + (val - KERNBASE);
-}
+static int hv_supports_soft_state;
=20
 static void do_set_sstate(unsigned long state, const char *msg)
 {
diff --git a/arch/sparc/kernel/unaligned_64.c b/arch/sparc/kernel/unaligned=
_64.c
index b2b019e..9043106 100644
--- a/arch/sparc/kernel/unaligned_64.c
+++ b/arch/sparc/kernel/unaligned_64.c
@@ -22,6 +22,7 @@
 #include <linux/bitops.h>
 #include <linux/perf_event.h>
 #include <linux/ratelimit.h>
+#include <linux/bitops.h>
 #include <asm/fpumacro.h>
=20
 enum direction {
@@ -373,16 +374,11 @@ asmlinkage void kernel_unaligned_trap(struct pt_regs =
*regs, unsigned int insn)
 	}
 }
=20
-static char popc_helper[] =3D {
-0, 1, 1, 2, 1, 2, 2, 3,
-1, 2, 2, 3, 2, 3, 3, 4,=20
-};
-
 int handle_popc(u32 insn, struct pt_regs *regs)
 {
-	u64 value;
-	int ret, i, rd =3D ((insn >> 25) & 0x1f);
 	int from_kernel =3D (regs->tstate & TSTATE_PRIV) !=3D 0;
+	int ret, rd =3D ((insn >> 25) & 0x1f);
+	u64 value;
 	                       =20
 	perf_sw_event(PERF_COUNT_SW_EMULATION_FAULTS, 1, 0, regs, 0);
 	if (insn & 0x2000) {
@@ -392,10 +388,7 @@ int handle_popc(u32 insn, struct pt_regs *regs)
 		maybe_flush_windows(0, insn & 0x1f, rd, from_kernel);
 		value =3D fetch_reg(insn & 0x1f, regs);
 	}
-	for (ret =3D 0, i =3D 0; i < 16; i++) {
-		ret +=3D popc_helper[value & 0xf];
-		value >>=3D 4;
-	}
+	ret =3D hweight64(value);
 	if (rd < 16) {
 		if (rd)
 			regs->u_regs[rd] =3D ret;
diff --git a/arch/sparc/kernel/vmlinux.lds.S b/arch/sparc/kernel/vmlinux.ld=
s.S
index c022075..0e16056 100644
--- a/arch/sparc/kernel/vmlinux.lds.S
+++ b/arch/sparc/kernel/vmlinux.lds.S
@@ -107,7 +107,26 @@ SECTIONS
 		*(.sun4v_2insn_patch)
 		__sun4v_2insn_patch_end =3D .;
 	}
-
+	.swapper_tsb_phys_patch : {
+		__swapper_tsb_phys_patch =3D .;
+		*(.swapper_tsb_phys_patch)
+		__swapper_tsb_phys_patch_end =3D .;
+	}
+	.swapper_4m_tsb_phys_patch : {
+		__swapper_4m_tsb_phys_patch =3D .;
+		*(.swapper_4m_tsb_phys_patch)
+		__swapper_4m_tsb_phys_patch_end =3D .;
+	}
+	.popc_3insn_patch : {
+		__popc_3insn_patch =3D .;
+		*(.popc_3insn_patch)
+		__popc_3insn_patch_end =3D .;
+	}
+	.popc_6insn_patch : {
+		__popc_6insn_patch =3D .;
+		*(.popc_6insn_patch)
+		__popc_6insn_patch_end =3D .;
+	}
 	PERCPU_SECTION(SMP_CACHE_BYTES)
=20
 	. =3D ALIGN(PAGE_SIZE);
diff --git a/arch/sparc/lib/Makefile b/arch/sparc/lib/Makefile
index 7f01b8f..a3fc437 100644
--- a/arch/sparc/lib/Makefile
+++ b/arch/sparc/lib/Makefile
@@ -31,13 +31,13 @@ lib-$(CONFIG_SPARC64) +=3D NGmemcpy.o NGcopy_from_user.=
o NGcopy_to_user.o
 lib-$(CONFIG_SPARC64) +=3D NGpatch.o NGpage.o NGbzero.o
=20
 lib-$(CONFIG_SPARC64) +=3D NG2memcpy.o NG2copy_from_user.o NG2copy_to_user=
=2Eo
-lib-$(CONFIG_SPARC64) +=3D  NG2patch.o NG2page.o
+lib-$(CONFIG_SPARC64) +=3D  NG2patch.o
=20
 lib-$(CONFIG_SPARC64) +=3D GENmemcpy.o GENcopy_from_user.o GENcopy_to_user=
=2Eo
 lib-$(CONFIG_SPARC64) +=3D GENpatch.o GENpage.o GENbzero.o
=20
 lib-$(CONFIG_SPARC64) +=3D copy_in_user.o user_fixup.o memmove.o
-lib-$(CONFIG_SPARC64) +=3D mcount.o ipcsum.o xor.o
+lib-$(CONFIG_SPARC64) +=3D mcount.o ipcsum.o xor.o hweight.o ffs.o
=20
 obj-y                 +=3D iomap.o
 obj-$(CONFIG_SPARC32) +=3D atomic32.o
diff --git a/arch/sparc/lib/NG2page.S b/arch/sparc/lib/NG2page.S
deleted file mode 100644
index 73b6b7c..0000000
--- a/arch/sparc/lib/NG2page.S
+++ /dev/null
@@ -1,61 +0,0 @@
-/* NG2page.S: Niagara-2 optimized clear and copy page.
- *
- * Copyright (C) 2007 (davem@davemloft.net)
- */
-
-#include <asm/asi.h>
-#include <asm/page.h>
-#include <asm/visasm.h>
-
-	.text
-	.align	32
-
-	/* This is heavily simplified from the sun4u variants
-	 * because Niagara-2 does not have any D-cache aliasing issues.
-	 */
-NG2copy_user_page:	/* %o0=3Ddest, %o1=3Dsrc, %o2=3Dvaddr */
-	prefetch	[%o1 + 0x00], #one_read
-	prefetch	[%o1 + 0x40], #one_read
-	VISEntryHalf
-	set		PAGE_SIZE, %g7
-	sub		%o0, %o1, %g3
-1:	stxa		%g0, [%o1 + %g3] ASI_BLK_INIT_QUAD_LDD_P
-	subcc		%g7, 64, %g7
-	ldda		[%o1] ASI_BLK_P, %f0
-	stda		%f0, [%o1 + %g3] ASI_BLK_P
-	add		%o1, 64, %o1
-	bne,pt		%xcc, 1b
-	 prefetch	[%o1 + 0x40], #one_read
-	membar		#Sync
-	VISExitHalf
-	retl
-	 nop
-
-#define BRANCH_ALWAYS	0x10680000
-#define NOP		0x01000000
-#define NG_DO_PATCH(OLD, NEW)	\
-	sethi	%hi(NEW), %g1; \
-	or	%g1, %lo(NEW), %g1; \
-	sethi	%hi(OLD), %g2; \
-	or	%g2, %lo(OLD), %g2; \
-	sub	%g1, %g2, %g1; \
-	sethi	%hi(BRANCH_ALWAYS), %g3; \
-	sll	%g1, 11, %g1; \
-	srl	%g1, 11 + 2, %g1; \
-	or	%g3, %lo(BRANCH_ALWAYS), %g3; \
-	or	%g3, %g1, %g3; \
-	stw	%g3, [%g2]; \
-	sethi	%hi(NOP), %g3; \
-	or	%g3, %lo(NOP), %g3; \
-	stw	%g3, [%g2 + 0x4]; \
-	flush	%g2;
-
-	.globl	niagara2_patch_pageops
-	.type	niagara2_patch_pageops,#function
-niagara2_patch_pageops:
-	NG_DO_PATCH(copy_user_page, NG2copy_user_page)
-	NG_DO_PATCH(_clear_page, NGclear_page)
-	NG_DO_PATCH(clear_user_page, NGclear_user_page)
-	retl
-	 nop
-	.size	niagara2_patch_pageops,.-niagara2_patch_pageops
diff --git a/arch/sparc/lib/NGpage.S b/arch/sparc/lib/NGpage.S
index 428920d..b9e790b 100644
--- a/arch/sparc/lib/NGpage.S
+++ b/arch/sparc/lib/NGpage.S
@@ -16,55 +16,91 @@
 	 */
=20
 NGcopy_user_page:	/* %o0=3Ddest, %o1=3Dsrc, %o2=3Dvaddr */
-	prefetch	[%o1 + 0x00], #one_read
-	mov		8, %g1
-	mov		16, %g2
-	mov		24, %g3
+	save		%sp, -192, %sp
+	rd		%asi, %g3
+	wr		%g0, ASI_BLK_INIT_QUAD_LDD_P, %asi
 	set		PAGE_SIZE, %g7
+	prefetch	[%i1 + 0x00], #one_read
+	prefetch	[%i1 + 0x40], #one_read
=20
-1:	ldda		[%o1 + %g0] ASI_BLK_INIT_QUAD_LDD_P, %o2
-	ldda		[%o1 + %g2] ASI_BLK_INIT_QUAD_LDD_P, %o4
-	prefetch	[%o1 + 0x40], #one_read
-	add		%o1, 32, %o1
-	stxa		%o2, [%o0 + %g0] ASI_BLK_INIT_QUAD_LDD_P
-	stxa		%o3, [%o0 + %g1] ASI_BLK_INIT_QUAD_LDD_P
-	ldda		[%o1 + %g0] ASI_BLK_INIT_QUAD_LDD_P, %o2
-	stxa		%o4, [%o0 + %g2] ASI_BLK_INIT_QUAD_LDD_P
-	stxa		%o5, [%o0 + %g3] ASI_BLK_INIT_QUAD_LDD_P
-	ldda		[%o1 + %g2] ASI_BLK_INIT_QUAD_LDD_P, %o4
-	add		%o1, 32, %o1
-	add		%o0, 32, %o0
-	stxa		%o2, [%o0 + %g0] ASI_BLK_INIT_QUAD_LDD_P
-	stxa		%o3, [%o0 + %g1] ASI_BLK_INIT_QUAD_LDD_P
-	stxa		%o4, [%o0 + %g2] ASI_BLK_INIT_QUAD_LDD_P
-	stxa		%o5, [%o0 + %g3] ASI_BLK_INIT_QUAD_LDD_P
-	subcc		%g7, 64, %g7
+1:	prefetch	[%i1 + 0x80], #one_read
+	prefetch	[%i1 + 0xc0], #one_read
+	ldda		[%i1 + 0x00] %asi, %o2
+	ldda		[%i1 + 0x10] %asi, %o4
+	ldda		[%i1 + 0x20] %asi, %l2
+	ldda		[%i1 + 0x30] %asi, %l4
+	stxa		%o2, [%i0 + 0x00] %asi
+	stxa		%o3, [%i0 + 0x08] %asi
+	stxa		%o4, [%i0 + 0x10] %asi
+	stxa		%o5, [%i0 + 0x18] %asi
+	stxa		%l2, [%i0 + 0x20] %asi
+	stxa		%l3, [%i0 + 0x28] %asi
+	stxa		%l4, [%i0 + 0x30] %asi
+	stxa		%l5, [%i0 + 0x38] %asi
+	ldda		[%i1 + 0x40] %asi, %o2
+	ldda		[%i1 + 0x50] %asi, %o4
+	ldda		[%i1 + 0x60] %asi, %l2
+	ldda		[%i1 + 0x70] %asi, %l4
+	stxa		%o2, [%i0 + 0x40] %asi
+	stxa		%o3, [%i0 + 0x48] %asi
+	stxa		%o4, [%i0 + 0x50] %asi
+	stxa		%o5, [%i0 + 0x58] %asi
+	stxa		%l2, [%i0 + 0x60] %asi
+	stxa		%l3, [%i0 + 0x68] %asi
+	stxa		%l4, [%i0 + 0x70] %asi
+	stxa		%l5, [%i0 + 0x78] %asi
+	add		%i1, 128, %i1
+	subcc		%g7, 128, %g7
 	bne,pt		%xcc, 1b
-	 add		%o0, 32, %o0
+	 add		%i0, 128, %i0
+	wr		%g3, 0x0, %asi
 	membar		#Sync
-	retl
-	 nop
+	ret
+	 restore
=20
-	.globl		NGclear_page, NGclear_user_page
+	.align		32
 NGclear_page:		/* %o0=3Ddest */
 NGclear_user_page:	/* %o0=3Ddest, %o1=3Dvaddr */
-	mov		8, %g1
-	mov		16, %g2
-	mov		24, %g3
+	rd		%asi, %g3
+	wr		%g0, ASI_BLK_INIT_QUAD_LDD_P, %asi
 	set		PAGE_SIZE, %g7
=20
-1:	stxa		%g0, [%o0 + %g0] ASI_BLK_INIT_QUAD_LDD_P
-	stxa		%g0, [%o0 + %g1] ASI_BLK_INIT_QUAD_LDD_P
-	stxa		%g0, [%o0 + %g2] ASI_BLK_INIT_QUAD_LDD_P
-	stxa		%g0, [%o0 + %g3] ASI_BLK_INIT_QUAD_LDD_P
-	add		%o0, 32, %o0
-	stxa		%g0, [%o0 + %g0] ASI_BLK_INIT_QUAD_LDD_P
-	stxa		%g0, [%o0 + %g1] ASI_BLK_INIT_QUAD_LDD_P
-	stxa		%g0, [%o0 + %g2] ASI_BLK_INIT_QUAD_LDD_P
-	stxa		%g0, [%o0 + %g3] ASI_BLK_INIT_QUAD_LDD_P
-	subcc		%g7, 64, %g7
+1:	stxa		%g0, [%o0 + 0x00] %asi
+	stxa		%g0, [%o0 + 0x08] %asi
+	stxa		%g0, [%o0 + 0x10] %asi
+	stxa		%g0, [%o0 + 0x18] %asi
+	stxa		%g0, [%o0 + 0x20] %asi
+	stxa		%g0, [%o0 + 0x28] %asi
+	stxa		%g0, [%o0 + 0x30] %asi
+	stxa		%g0, [%o0 + 0x38] %asi
+	stxa		%g0, [%o0 + 0x40] %asi
+	stxa		%g0, [%o0 + 0x48] %asi
+	stxa		%g0, [%o0 + 0x50] %asi
+	stxa		%g0, [%o0 + 0x58] %asi
+	stxa		%g0, [%o0 + 0x60] %asi
+	stxa		%g0, [%o0 + 0x68] %asi
+	stxa		%g0, [%o0 + 0x70] %asi
+	stxa		%g0, [%o0 + 0x78] %asi
+	stxa		%g0, [%o0 + 0x80] %asi
+	stxa		%g0, [%o0 + 0x88] %asi
+	stxa		%g0, [%o0 + 0x90] %asi
+	stxa		%g0, [%o0 + 0x98] %asi
+	stxa		%g0, [%o0 + 0xa0] %asi
+	stxa		%g0, [%o0 + 0xa8] %asi
+	stxa		%g0, [%o0 + 0xb0] %asi
+	stxa		%g0, [%o0 + 0xb8] %asi
+	stxa		%g0, [%o0 + 0xc0] %asi
+	stxa		%g0, [%o0 + 0xc8] %asi
+	stxa		%g0, [%o0 + 0xd0] %asi
+	stxa		%g0, [%o0 + 0xd8] %asi
+	stxa		%g0, [%o0 + 0xe0] %asi
+	stxa		%g0, [%o0 + 0xe8] %asi
+	stxa		%g0, [%o0 + 0xf0] %asi
+	stxa		%g0, [%o0 + 0xf8] %asi
+	subcc		%g7, 256, %g7
 	bne,pt		%xcc, 1b
-	 add		%o0, 32, %o0
+	 add		%o0, 256, %o0
+	wr		%g3, 0x0, %asi
 	membar		#Sync
 	retl
 	 nop
diff --git a/arch/sparc/lib/ffs.S b/arch/sparc/lib/ffs.S
new file mode 100644
index 0000000..b39389f
--- /dev/null
+++ b/arch/sparc/lib/ffs.S
@@ -0,0 +1,84 @@
+#include <linux/linkage.h>
+
+	.register	%g2,#scratch
+
+	.text
+	.align	32
+
+ENTRY(ffs)
+	brnz,pt	%o0, 1f
+	 mov	1, %o1
+	retl
+	 clr	%o0
+	nop
+	nop
+ENTRY(__ffs)
+	sllx	%o0, 32, %g1		/* 1  */
+	srlx	%o0, 32, %g2
+
+	clr	%o1			/* 2  */
+	movrz	%g1, %g2, %o0
+
+	movrz	%g1, 32, %o1		/* 3  */
+1:	clr	%o2
+
+	sllx	%o0, (64 - 16), %g1	/* 4  */
+	srlx	%o0, 16, %g2
+
+	movrz	%g1, %g2, %o0		/* 5  */
+	clr	%o3
+
+	movrz	%g1, 16, %o2		/* 6  */
+	clr	%o4
+
+	and	%o0, 0xff, %g1		/* 7  */
+	srlx	%o0, 8, %g2
+
+	movrz	%g1, %g2, %o0		/* 8  */
+	clr	%o5
+
+	movrz	%g1, 8, %o3		/* 9  */
+	add	%o2, %o1, %o2
+
+	and	%o0, 0xf, %g1		/* 10 */
+	srlx	%o0, 4, %g2
+
+	movrz	%g1, %g2, %o0		/* 11 */
+	add	%o2, %o3, %o2
+
+	movrz	%g1, 4, %o4		/* 12 */
+
+	and	%o0, 0x3, %g1		/* 13 */
+	srlx	%o0, 2, %g2
+
+	movrz	%g1, %g2, %o0		/* 14 */
+	add	%o2, %o4, %o2
+
+	movrz	%g1, 2, %o5		/* 15 */
+
+	and	%o0, 0x1, %g1		/* 16 */
+
+	add	%o2, %o5, %o2		/* 17 */
+	xor	%g1, 0x1, %g1
+
+	retl				/* 18 */
+	 add	%o2, %g1, %o0
+ENDPROC(ffs)
+ENDPROC(__ffs)
+
+	.section	.popc_6insn_patch, "ax"
+	.word		ffs
+	brz,pn	%o0, 98f
+	 neg	%o0, %g1
+	xnor	%o0, %g1, %o1
+	popc	%o1, %o0
+98:	retl
+	 nop
+	.word		__ffs
+	neg	%o0, %g1
+	xnor	%o0, %g1, %o1
+	popc	%o1, %o0
+	retl
+	 sub	%o0, 1, %o0
+	nop
+	.previous
diff --git a/arch/sparc/lib/hweight.S b/arch/sparc/lib/hweight.S
new file mode 100644
index 0000000..95414e0
--- /dev/null
+++ b/arch/sparc/lib/hweight.S
@@ -0,0 +1,51 @@
+#include <linux/linkage.h>
+
+	.text
+	.align	32
+ENTRY(__arch_hweight8)
+	ba,pt	%xcc, __sw_hweight8
+	 nop
+	nop
+ENDPROC(__arch_hweight8)
+	.section	.popc_3insn_patch, "ax"
+	.word		__arch_hweight8
+	sllx		%o0, 64-8, %g1
+	retl
+	 popc		%g1, %o0
+	.previous
+
+ENTRY(__arch_hweight16)
+	ba,pt	%xcc, __sw_hweight16
+	 nop
+	nop
+ENDPROC(__arch_hweight16)
+	.section	.popc_3insn_patch, "ax"
+	.word		__arch_hweight16
+	sllx		%o0, 64-16, %g1
+	retl
+	 popc		%g1, %o0
+	.previous
+
+ENTRY(__arch_hweight32)
+	ba,pt	%xcc, __sw_hweight32
+	 nop
+	nop
+ENDPROC(__arch_hweight32)
+	.section	.popc_3insn_patch, "ax"
+	.word		__arch_hweight32
+	sllx		%o0, 64-32, %g1
+	retl
+	 popc		%g1, %o0
+	.previous
+
+ENTRY(__arch_hweight64)
+	ba,pt	%xcc, __sw_hweight64
+	 nop
+	nop
+ENDPROC(__arch_hweight64)
+	.section	.popc_3insn_patch, "ax"
+	.word		__arch_hweight64
+	retl
+	 popc		%o0, %o0
+	nop
+	.previous
diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
index 3fd8e18..581531d 100644
--- a/arch/sparc/mm/init_64.c
+++ b/arch/sparc/mm/init_64.c
@@ -1597,6 +1597,44 @@ static void __init tsb_phys_patch(void)
 static struct hv_tsb_descr ktsb_descr[NUM_KTSB_DESCR];
 extern struct tsb swapper_tsb[KERNEL_TSB_NENTRIES];
=20
+static void patch_one_ktsb_phys(unsigned int *start, unsigned int *end, un=
signed long pa)
+{
+	pa >>=3D KTSB_PHYS_SHIFT;
+
+	while (start < end) {
+		unsigned int *ia =3D (unsigned int *)(unsigned long)*start;
+
+		ia[0] =3D (ia[0] & ~0x3fffff) | (pa >> 10);
+		__asm__ __volatile__("flush	%0" : : "r" (ia));
+
+		ia[1] =3D (ia[1] & ~0x3ff) | (pa & 0x3ff);
+		__asm__ __volatile__("flush	%0" : : "r" (ia + 1));
+
+		start++;
+	}
+}
+
+static void ktsb_phys_patch(void)
+{
+	extern unsigned int __swapper_tsb_phys_patch;
+	extern unsigned int __swapper_tsb_phys_patch_end;
+	unsigned long ktsb_pa;
+
+	ktsb_pa =3D kern_base + ((unsigned long)&swapper_tsb[0] - KERNBASE);
+	patch_one_ktsb_phys(&__swapper_tsb_phys_patch,
+			    &__swapper_tsb_phys_patch_end, ktsb_pa);
+#ifndef CONFIG_DEBUG_PAGEALLOC
+	{
+	extern unsigned int __swapper_4m_tsb_phys_patch;
+	extern unsigned int __swapper_4m_tsb_phys_patch_end;
+	ktsb_pa =3D (kern_base +
+		   ((unsigned long)&swapper_4m_tsb[0] - KERNBASE));
+	patch_one_ktsb_phys(&__swapper_4m_tsb_phys_patch,
+			    &__swapper_4m_tsb_phys_patch_end, ktsb_pa);
+	}
+#endif
+}
+
 static void __init sun4v_ktsb_init(void)
 {
 	unsigned long ktsb_pa;
@@ -1716,8 +1754,10 @@ void __init paging_init(void)
 		sun4u_pgprot_init();
=20
 	if (tlb_type =3D=3D cheetah_plus ||
-	    tlb_type =3D=3D hypervisor)
+	    tlb_type =3D=3D hypervisor) {
 		tsb_phys_patch();
+		ktsb_phys_patch();
+	}
=20
 	if (tlb_type =3D=3D hypervisor) {
 		sun4v_patch_tlb_handlers();
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-in=
dex.h
index 485b4f1..23a9d89 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -259,6 +259,9 @@
 #define MSR_IA32_TEMPERATURE_TARGET	0x000001a2
=20
 #define MSR_IA32_ENERGY_PERF_BIAS	0x000001b0
+#define ENERGY_PERF_BIAS_PERFORMANCE	0
+#define ENERGY_PERF_BIAS_NORMAL		6
+#define ENERGY_PERF_BIAS_POWERSWAVE	15
=20
 #define MSR_IA32_PACKAGE_THERM_STATUS		0x000001b1
=20
diff --git a/arch/x86/include/asm/xen/page.h b/arch/x86/include/asm/xen/pag=
e.h
index 64a619d..7ff4669 100644
--- a/arch/x86/include/asm/xen/page.h
+++ b/arch/x86/include/asm/xen/page.h
@@ -39,7 +39,7 @@ typedef struct xpaddr {
     ((unsigned long)((u64)CONFIG_XEN_MAX_DOMAIN_MEMORY * 1024 * 1024 * 102=
4 / PAGE_SIZE))
=20
 extern unsigned long *machine_to_phys_mapping;
-extern unsigned int   machine_to_phys_order;
+extern unsigned long  machine_to_phys_nr;
=20
 extern unsigned long get_phys_to_machine(unsigned long pfn);
 extern bool set_phys_to_machine(unsigned long pfn, unsigned long mfn);
@@ -87,7 +87,7 @@ static inline unsigned long mfn_to_pfn(unsigned long mfn)
 	if (xen_feature(XENFEAT_auto_translated_physmap))
 		return mfn;
=20
-	if (unlikely((mfn >> machine_to_phys_order) !=3D 0)) {
+	if (unlikely(mfn >=3D machine_to_phys_nr)) {
 		pfn =3D ~0;
 		goto try_override;
 	}
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2ap=
ic_uv_x.c
index adc66c3..34b1859 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -207,7 +207,6 @@ static int __cpuinit uv_wakeup_secondary(int phys_apici=
d, unsigned long start_ri
 	    ((start_rip << UVH_IPI_INT_VECTOR_SHFT) >> 12) |
 	    APIC_DM_INIT;
 	uv_write_global_mmr64(pnode, UVH_IPI_INT, val);
-	mdelay(10);
=20
 	val =3D (1UL << UVH_IPI_INT_SEND_SHFT) |
 	    (phys_apicid << UVH_IPI_INT_APIC_ID_SHFT) |
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 1edf5ba..ed6086e 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -456,6 +456,24 @@ static void __cpuinit init_intel(struct cpuinfo_x86 *c)
=20
 	if (cpu_has(c, X86_FEATURE_VMX))
 		detect_vmx_virtcap(c);
+
+	/*
+	 * Initialize MSR_IA32_ENERGY_PERF_BIAS if BIOS did not.
+	 * x86_energy_perf_policy(8) is available to change it at run-time
+	 */
+	if (cpu_has(c, X86_FEATURE_EPB)) {
+		u64 epb;
+
+		rdmsrl(MSR_IA32_ENERGY_PERF_BIAS, epb);
+		if ((epb & 0xF) =3D=3D ENERGY_PERF_BIAS_PERFORMANCE) {
+			printk_once(KERN_WARNING "ENERGY_PERF_BIAS:"
+				" Set to 'normal', was 'performance'\n"
+				"ENERGY_PERF_BIAS: View and update with"
+				" x86_energy_perf_policy(8)\n");
+			epb =3D (epb & ~0xF) | ENERGY_PERF_BIAS_NORMAL;
+			wrmsrl(MSR_IA32_ENERGY_PERF_BIAS, epb);
+		}
+	}
 }
=20
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/kernel/cpu/mtrr/main.c b/arch/x86/kernel/cpu/mtrr/mai=
n.c
index 929739a..3d17bc7 100644
--- a/arch/x86/kernel/cpu/mtrr/main.c
+++ b/arch/x86/kernel/cpu/mtrr/main.c
@@ -248,6 +248,25 @@ set_mtrr(unsigned int reg, unsigned long base, unsigne=
d long size, mtrr_type typ
 	unsigned long flags;
 	int cpu;
=20
+#ifdef CONFIG_SMP
+	/*
+	 * If this cpu is not yet active, we are in the cpu online path. There
+	 * can be no stop_machine() in parallel, as stop machine ensures this
+	 * by using get_online_cpus(). We can skip taking the stop_cpus_mutex,
+	 * as we don't need it and also we can't afford to block while waiting
+	 * for the mutex.
+	 *
+	 * If this cpu is active, we need to prevent stop_machine() happening
+	 * in parallel by taking the stop cpus mutex.
+	 *
+	 * Also, this is called in the context of cpu online path or in the
+	 * context where cpu hotplug is prevented. So checking the active status
+	 * of the raw_smp_processor_id() is safe.
+	 */
+	if (cpu_active(raw_smp_processor_id()))
+		mutex_lock(&stop_cpus_mutex);
+#endif
+
 	preempt_disable();
=20
 	data.smp_reg =3D reg;
@@ -330,6 +349,10 @@ set_mtrr(unsigned int reg, unsigned long base, unsigne=
d long size, mtrr_type typ
=20
 	local_irq_restore(flags);
 	preempt_enable();
+#ifdef CONFIG_SMP
+	if (cpu_active(raw_smp_processor_id()))
+		mutex_unlock(&stop_cpus_mutex);
+#endif
 }
=20
 /**
diff --git a/arch/x86/kernel/relocate_kernel_32.S b/arch/x86/kernel/relocat=
e_kernel_32.S
index 4123553..36818f8 100644
--- a/arch/x86/kernel/relocate_kernel_32.S
+++ b/arch/x86/kernel/relocate_kernel_32.S
@@ -97,6 +97,8 @@ relocate_kernel:
 	ret
=20
 identity_mapped:
+	/* set return address to 0 if not preserving context */
+	pushl	$0
 	/* store the start address on the stack */
 	pushl   %edx
=20
diff --git a/arch/x86/kernel/relocate_kernel_64.S b/arch/x86/kernel/relocat=
e_kernel_64.S
index 4de8f5b..7a6f3b3 100644
--- a/arch/x86/kernel/relocate_kernel_64.S
+++ b/arch/x86/kernel/relocate_kernel_64.S
@@ -100,6 +100,8 @@ relocate_kernel:
 	ret
=20
 identity_mapped:
+	/* set return address to 0 if not preserving context */
+	pushq	$0
 	/* store the start address on the stack */
 	pushq   %rdx
=20
diff --git a/arch/x86/oprofile/backtrace.c b/arch/x86/oprofile/backtrace.c
index a5b64ab..32f78eb 100644
--- a/arch/x86/oprofile/backtrace.c
+++ b/arch/x86/oprofile/backtrace.c
@@ -11,10 +11,12 @@
 #include <linux/oprofile.h>
 #include <linux/sched.h>
 #include <linux/mm.h>
+#include <linux/compat.h>
+#include <linux/highmem.h>
+
 #include <asm/ptrace.h>
 #include <asm/uaccess.h>
 #include <asm/stacktrace.h>
-#include <linux/compat.h>
=20
 static int backtrace_stack(void *data, char *name)
 {
@@ -36,17 +38,53 @@ static struct stacktrace_ops backtrace_ops =3D {
 	.walk_stack	=3D print_context_stack,
 };
=20
+/* from arch/x86/kernel/cpu/perf_event.c: */
+
+/*
+ * best effort, GUP based copy_from_user() that assumes IRQ or NMI context
+ */
+static unsigned long
+copy_from_user_nmi(void *to, const void __user *from, unsigned long n)
+{
+	unsigned long offset, addr =3D (unsigned long)from;
+	unsigned long size, len =3D 0;
+	struct page *page;
+	void *map;
+	int ret;
+
+	do {
+		ret =3D __get_user_pages_fast(addr, 1, 0, &page);
+		if (!ret)
+			break;
+
+		offset =3D addr & (PAGE_SIZE - 1);
+		size =3D min(PAGE_SIZE - offset, n - len);
+
+		map =3D kmap_atomic(page);
+		memcpy(to, map+offset, size);
+		kunmap_atomic(map);
+		put_page(page);
+
+		len  +=3D size;
+		to   +=3D size;
+		addr +=3D size;
+
+	} while (len < n);
+
+	return len;
+}
+
 #ifdef CONFIG_COMPAT
 static struct stack_frame_ia32 *
 dump_user_backtrace_32(struct stack_frame_ia32 *head)
 {
+	/* Also check accessibility of one struct frame_head beyond: */
 	struct stack_frame_ia32 bufhead[2];
 	struct stack_frame_ia32 *fp;
+	unsigned long bytes;
=20
-	/* Also check accessibility of one struct frame_head beyond */
-	if (!access_ok(VERIFY_READ, head, sizeof(bufhead)))
-		return NULL;
-	if (__copy_from_user_inatomic(bufhead, head, sizeof(bufhead)))
+	bytes =3D copy_from_user_nmi(bufhead, head, sizeof(bufhead));
+	if (bytes !=3D sizeof(bufhead))
 		return NULL;
=20
 	fp =3D (struct stack_frame_ia32 *) compat_ptr(bufhead[0].next_frame);
@@ -87,12 +125,12 @@ x86_backtrace_32(struct pt_regs * const regs, unsigned=
 int depth)
=20
 static struct stack_frame *dump_user_backtrace(struct stack_frame *head)
 {
+	/* Also check accessibility of one struct frame_head beyond: */
 	struct stack_frame bufhead[2];
+	unsigned long bytes;
=20
-	/* Also check accessibility of one struct stack_frame beyond */
-	if (!access_ok(VERIFY_READ, head, sizeof(bufhead)))
-		return NULL;
-	if (__copy_from_user_inatomic(bufhead, head, sizeof(bufhead)))
+	bytes =3D copy_from_user_nmi(bufhead, head, sizeof(bufhead));
+	if (bytes !=3D sizeof(bufhead))
 		return NULL;
=20
 	oprofile_add_trace(bufhead[0].return_address);
diff --git a/arch/x86/platform/olpc/olpc.c b/arch/x86/platform/olpc/olpc.c
index 0060fd5..02e3934 100644
--- a/arch/x86/platform/olpc/olpc.c
+++ b/arch/x86/platform/olpc/olpc.c
@@ -157,13 +157,13 @@ restart:
 	if (inbuf && inlen) {
 		/* write data to EC */
 		for (i =3D 0; i < inlen; i++) {
+			pr_devel("olpc-ec:  sending cmd arg 0x%x\n", inbuf[i]);
+			outb(inbuf[i], 0x68);
 			if (wait_on_ibf(0x6c, 0)) {
 				printk(KERN_ERR "olpc-ec:  timeout waiting for"
 						" EC accept data!\n");
 				goto err;
 			}
-			pr_devel("olpc-ec:  sending cmd arg 0x%x\n", inbuf[i]);
-			outb(inbuf[i], 0x68);
 		}
 	}
 	if (outbuf && outlen) {
diff --git a/arch/x86/vdso/vdso32/sysenter.S b/arch/x86/vdso/vdso32/sysente=
r.S
index e2800af..e354bce 100644
--- a/arch/x86/vdso/vdso32/sysenter.S
+++ b/arch/x86/vdso/vdso32/sysenter.S
@@ -43,7 +43,7 @@ __kernel_vsyscall:
 	.space 7,0x90
=20
 	/* 14: System call restart point is here! (SYSENTER_RETURN-2) */
-	jmp .Lenter_kernel
+	int $0x80
 	/* 16: System call normal return point is here! */
 VDSO32_SYSENTER_RETURN:	/* Symbol used by sysenter.c via vdso32-syms.h */
 	pop %ebp
diff --git a/arch/x86/xen/Makefile b/arch/x86/xen/Makefile
index 17c565d..a6575b9 100644
--- a/arch/x86/xen/Makefile
+++ b/arch/x86/xen/Makefile
@@ -18,5 +18,5 @@ obj-y		:=3D enlighten.o setup.o multicalls.o mmu.o irq.o \
 obj-$(CONFIG_SMP)		+=3D smp.o
 obj-$(CONFIG_PARAVIRT_SPINLOCKS)+=3D spinlock.o
 obj-$(CONFIG_XEN_DEBUG_FS)	+=3D debugfs.o
-
+obj-$(CONFIG_XEN_DOM0)		+=3D vga.o
 obj-$(CONFIG_SWIOTLB_XEN)	+=3D pci-swiotlb-xen.o
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 5525163..67d69f1 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -77,8 +77,8 @@ EXPORT_SYMBOL_GPL(xen_domain_type);
=20
 unsigned long *machine_to_phys_mapping =3D (void *)MACH2PHYS_VIRT_START;
 EXPORT_SYMBOL(machine_to_phys_mapping);
-unsigned int   machine_to_phys_order;
-EXPORT_SYMBOL(machine_to_phys_order);
+unsigned long  machine_to_phys_nr;
+EXPORT_SYMBOL(machine_to_phys_nr);
=20
 struct start_info *xen_start_info;
 EXPORT_SYMBOL_GPL(xen_start_info);
@@ -1248,6 +1248,14 @@ asmlinkage void __init xen_start_kernel(void)
 		if (pci_xen)
 			x86_init.pci.arch_init =3D pci_xen_init;
 	} else {
+		const struct dom0_vga_console_info *info =3D
+			(void *)((char *)xen_start_info +
+				 xen_start_info->console.dom0.info_off);
+
+		xen_init_vga(info, xen_start_info->console.dom0.info_size);
+		xen_start_info->console.domU.mfn =3D 0;
+		xen_start_info->console.domU.evtchn =3D 0;
+
 		/* Make sure ACS will be enabled */
 		pci_request_acs();
 	}
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 0ccccb6..5f76c0a 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1626,15 +1626,19 @@ static void __init xen_map_identity_early(pmd_t *pm=
d, unsigned long max_pfn)
 void __init xen_setup_machphys_mapping(void)
 {
 	struct xen_machphys_mapping mapping;
-	unsigned long machine_to_phys_nr_ents;
=20
 	if (HYPERVISOR_memory_op(XENMEM_machphys_mapping, &mapping) =3D=3D 0) {
 		machine_to_phys_mapping =3D (unsigned long *)mapping.v_start;
-		machine_to_phys_nr_ents =3D mapping.max_mfn + 1;
+		machine_to_phys_nr =3D mapping.max_mfn + 1;
 	} else {
-		machine_to_phys_nr_ents =3D MACH2PHYS_NR_ENTRIES;
+		machine_to_phys_nr =3D MACH2PHYS_NR_ENTRIES;
 	}
-	machine_to_phys_order =3D fls(machine_to_phys_nr_ents - 1);
+#ifdef CONFIG_X86_32
+	if ((machine_to_phys_mapping + machine_to_phys_nr)
+	    < machine_to_phys_mapping)
+		machine_to_phys_nr =3D (unsigned long *)NULL
+				     - machine_to_phys_mapping;
+#endif
 }
=20
 #ifdef CONFIG_X86_64
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index b4533a8..e79dbb9 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -521,8 +521,6 @@ static void __init xen_hvm_smp_prepare_cpus(unsigned in=
t max_cpus)
 	native_smp_prepare_cpus(max_cpus);
 	WARN_ON(xen_smp_intr_init(0));
=20
-	if (!xen_have_vector_callback)
-		return;
 	xen_init_lock_cpu(0);
 	xen_init_spinlocks();
 }
@@ -546,6 +544,8 @@ static void xen_hvm_cpu_die(unsigned int cpu)
=20
 void __init xen_hvm_smp_init(void)
 {
+	if (!xen_have_vector_callback)
+		return;
 	smp_ops.smp_prepare_cpus =3D xen_hvm_smp_prepare_cpus;
 	smp_ops.smp_send_reschedule =3D xen_smp_send_reschedule;
 	smp_ops.cpu_up =3D xen_hvm_cpu_up;
diff --git a/arch/x86/xen/vga.c b/arch/x86/xen/vga.c
new file mode 100644
index 0000000..1cd7f4d
--- /dev/null
+++ b/arch/x86/xen/vga.c
@@ -0,0 +1,67 @@
+#include <linux/screen_info.h>
+#include <linux/init.h>
+
+#include <asm/bootparam.h>
+#include <asm/setup.h>
+
+#include <xen/interface/xen.h>
+
+#include "xen-ops.h"
+
+void __init xen_init_vga(const struct dom0_vga_console_info *info, size_t =
size)
+{
+	struct screen_info *screen_info =3D &boot_params.screen_info;
+
+	/* This is drawn from a dump from vgacon:startup in
+	 * standard Linux. */
+	screen_info->orig_video_mode =3D 3;
+	screen_info->orig_video_isVGA =3D 1;
+	screen_info->orig_video_lines =3D 25;
+	screen_info->orig_video_cols =3D 80;
+	screen_info->orig_video_ega_bx =3D 3;
+	screen_info->orig_video_points =3D 16;
+	screen_info->orig_y =3D screen_info->orig_video_lines - 1;
+
+	switch (info->video_type) {
+	case XEN_VGATYPE_TEXT_MODE_3:
+		if (size < offsetof(struct dom0_vga_console_info, u.text_mode_3)
+		    + sizeof(info->u.text_mode_3))
+			break;
+		screen_info->orig_video_lines =3D info->u.text_mode_3.rows;
+		screen_info->orig_video_cols =3D info->u.text_mode_3.columns;
+		screen_info->orig_x =3D info->u.text_mode_3.cursor_x;
+		screen_info->orig_y =3D info->u.text_mode_3.cursor_y;
+		screen_info->orig_video_points =3D
+			info->u.text_mode_3.font_height;
+		break;
+
+	case XEN_VGATYPE_VESA_LFB:
+		if (size < offsetof(struct dom0_vga_console_info,
+				    u.vesa_lfb.gbl_caps))
+			break;
+		screen_info->orig_video_isVGA =3D VIDEO_TYPE_VLFB;
+		screen_info->lfb_width =3D info->u.vesa_lfb.width;
+		screen_info->lfb_height =3D info->u.vesa_lfb.height;
+		screen_info->lfb_depth =3D info->u.vesa_lfb.bits_per_pixel;
+		screen_info->lfb_base =3D info->u.vesa_lfb.lfb_base;
+		screen_info->lfb_size =3D info->u.vesa_lfb.lfb_size;
+		screen_info->lfb_linelength =3D info->u.vesa_lfb.bytes_per_line;
+		screen_info->red_size =3D info->u.vesa_lfb.red_size;
+		screen_info->red_pos =3D info->u.vesa_lfb.red_pos;
+		screen_info->green_size =3D info->u.vesa_lfb.green_size;
+		screen_info->green_pos =3D info->u.vesa_lfb.green_pos;
+		screen_info->blue_size =3D info->u.vesa_lfb.blue_size;
+		screen_info->blue_pos =3D info->u.vesa_lfb.blue_pos;
+		screen_info->rsvd_size =3D info->u.vesa_lfb.rsvd_size;
+		screen_info->rsvd_pos =3D info->u.vesa_lfb.rsvd_pos;
+		if (size >=3D offsetof(struct dom0_vga_console_info,
+				     u.vesa_lfb.gbl_caps)
+		    + sizeof(info->u.vesa_lfb.gbl_caps))
+			screen_info->capabilities =3D info->u.vesa_lfb.gbl_caps;
+		if (size >=3D offsetof(struct dom0_vga_console_info,
+				     u.vesa_lfb.mode_attrs)
+		    + sizeof(info->u.vesa_lfb.mode_attrs))
+			screen_info->vesa_attributes =3D info->u.vesa_lfb.mode_attrs;
+		break;
+	}
+}
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
index 97dfdc8..b095739 100644
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -88,6 +88,17 @@ static inline void xen_uninit_lock_cpu(int cpu)
 }
 #endif
=20
+struct dom0_vga_console_info;
+
+#ifdef CONFIG_XEN_DOM0
+void __init xen_init_vga(const struct dom0_vga_console_info *, size_t size=
);
+#else
+static inline void __init xen_init_vga(const struct dom0_vga_console_info =
*info,
+				       size_t size)
+{
+}
+#endif
+
 /* Declare an asm function, along with symbols needed to make it
    inlineable */
 #define DECL_ASM(ret, name, ...)		\
diff --git a/arch/xtensa/kernel/ptrace.c b/arch/xtensa/kernel/ptrace.c
index c72c947..a0d042a 100644
--- a/arch/xtensa/kernel/ptrace.c
+++ b/arch/xtensa/kernel/ptrace.c
@@ -147,6 +147,9 @@ int ptrace_setxregs(struct task_struct *child, void __u=
ser *uregs)
 	elf_xtregs_t *xtregs =3D uregs;
 	int ret =3D 0;
=20
+	if (!access_ok(VERIFY_READ, uregs, sizeof(elf_xtregs_t)))
+		return -EFAULT;
+
 #if XTENSA_HAVE_COPROCESSORS
 	/* Flush all coprocessors before we overwrite them. */
 	coprocessor_flush_all(ti);
diff --git a/block/blk-core.c b/block/blk-core.c
index d2f8f40..1d49e1c 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -839,6 +839,9 @@ struct request *blk_get_request(struct request_queue *q=
, int rw, gfp_t gfp_mask)
 {
 	struct request *rq;
=20
+	if (unlikely(test_bit(QUEUE_FLAG_DEAD, &q->queue_flags)))
+		return NULL;
+
 	BUG_ON(rw !=3D READ && rw !=3D WRITE);
=20
 	spin_lock_irq(q->queue_lock);
diff --git a/block/blk-exec.c b/block/blk-exec.c
index 8a0e7ec..a1ebceb 100644
--- a/block/blk-exec.c
+++ b/block/blk-exec.c
@@ -50,6 +50,13 @@ void blk_execute_rq_nowait(struct request_queue *q, stru=
ct gendisk *bd_disk,
 {
 	int where =3D at_head ? ELEVATOR_INSERT_FRONT : ELEVATOR_INSERT_BACK;
=20
+	if (unlikely(test_bit(QUEUE_FLAG_DEAD, &q->queue_flags))) {
+		rq->errors =3D -ENXIO;
+		if (rq->end_io)
+			rq->end_io(rq, rq->errors);
+		return;
+	}
+
 	rq->rq_disk =3D bd_disk;
 	rq->end_io =3D done;
 	WARN_ON(irqs_disabled());
diff --git a/crypto/md5.c b/crypto/md5.c
index 30efc7d..7febeaa 100644
--- a/crypto/md5.c
+++ b/crypto/md5.c
@@ -21,99 +21,9 @@
 #include <linux/module.h>
 #include <linux/string.h>
 #include <linux/types.h>
+#include <linux/cryptohash.h>
 #include <asm/byteorder.h>
=20
-#define F1(x, y, z)	(z ^ (x & (y ^ z)))
-#define F2(x, y, z)	F1(z, x, y)
-#define F3(x, y, z)	(x ^ y ^ z)
-#define F4(x, y, z)	(y ^ (x | ~z))
-
-#define MD5STEP(f, w, x, y, z, in, s) \
-	(w +=3D f(x, y, z) + in, w =3D (w<<s | w>>(32-s)) + x)
-
-static void md5_transform(u32 *hash, u32 const *in)
-{
-	u32 a, b, c, d;
-
-	a =3D hash[0];
-	b =3D hash[1];
-	c =3D hash[2];
-	d =3D hash[3];
-
-	MD5STEP(F1, a, b, c, d, in[0] + 0xd76aa478, 7);
-	MD5STEP(F1, d, a, b, c, in[1] + 0xe8c7b756, 12);
-	MD5STEP(F1, c, d, a, b, in[2] + 0x242070db, 17);
-	MD5STEP(F1, b, c, d, a, in[3] + 0xc1bdceee, 22);
-	MD5STEP(F1, a, b, c, d, in[4] + 0xf57c0faf, 7);
-	MD5STEP(F1, d, a, b, c, in[5] + 0x4787c62a, 12);
-	MD5STEP(F1, c, d, a, b, in[6] + 0xa8304613, 17);
-	MD5STEP(F1, b, c, d, a, in[7] + 0xfd469501, 22);
-	MD5STEP(F1, a, b, c, d, in[8] + 0x698098d8, 7);
-	MD5STEP(F1, d, a, b, c, in[9] + 0x8b44f7af, 12);
-	MD5STEP(F1, c, d, a, b, in[10] + 0xffff5bb1, 17);
-	MD5STEP(F1, b, c, d, a, in[11] + 0x895cd7be, 22);
-	MD5STEP(F1, a, b, c, d, in[12] + 0x6b901122, 7);
-	MD5STEP(F1, d, a, b, c, in[13] + 0xfd987193, 12);
-	MD5STEP(F1, c, d, a, b, in[14] + 0xa679438e, 17);
-	MD5STEP(F1, b, c, d, a, in[15] + 0x49b40821, 22);
-
-	MD5STEP(F2, a, b, c, d, in[1] + 0xf61e2562, 5);
-	MD5STEP(F2, d, a, b, c, in[6] + 0xc040b340, 9);
-	MD5STEP(F2, c, d, a, b, in[11] + 0x265e5a51, 14);
-	MD5STEP(F2, b, c, d, a, in[0] + 0xe9b6c7aa, 20);
-	MD5STEP(F2, a, b, c, d, in[5] + 0xd62f105d, 5);
-	MD5STEP(F2, d, a, b, c, in[10] + 0x02441453, 9);
-	MD5STEP(F2, c, d, a, b, in[15] + 0xd8a1e681, 14);
-	MD5STEP(F2, b, c, d, a, in[4] + 0xe7d3fbc8, 20);
-	MD5STEP(F2, a, b, c, d, in[9] + 0x21e1cde6, 5);
-	MD5STEP(F2, d, a, b, c, in[14] + 0xc33707d6, 9);
-	MD5STEP(F2, c, d, a, b, in[3] + 0xf4d50d87, 14);
-	MD5STEP(F2, b, c, d, a, in[8] + 0x455a14ed, 20);
-	MD5STEP(F2, a, b, c, d, in[13] + 0xa9e3e905, 5);
-	MD5STEP(F2, d, a, b, c, in[2] + 0xfcefa3f8, 9);
-	MD5STEP(F2, c, d, a, b, in[7] + 0x676f02d9, 14);
-	MD5STEP(F2, b, c, d, a, in[12] + 0x8d2a4c8a, 20);
-
-	MD5STEP(F3, a, b, c, d, in[5] + 0xfffa3942, 4);
-	MD5STEP(F3, d, a, b, c, in[8] + 0x8771f681, 11);
-	MD5STEP(F3, c, d, a, b, in[11] + 0x6d9d6122, 16);
-	MD5STEP(F3, b, c, d, a, in[14] + 0xfde5380c, 23);
-	MD5STEP(F3, a, b, c, d, in[1] + 0xa4beea44, 4);
-	MD5STEP(F3, d, a, b, c, in[4] + 0x4bdecfa9, 11);
-	MD5STEP(F3, c, d, a, b, in[7] + 0xf6bb4b60, 16);
-	MD5STEP(F3, b, c, d, a, in[10] + 0xbebfbc70, 23);
-	MD5STEP(F3, a, b, c, d, in[13] + 0x289b7ec6, 4);
-	MD5STEP(F3, d, a, b, c, in[0] + 0xeaa127fa, 11);
-	MD5STEP(F3, c, d, a, b, in[3] + 0xd4ef3085, 16);
-	MD5STEP(F3, b, c, d, a, in[6] + 0x04881d05, 23);
-	MD5STEP(F3, a, b, c, d, in[9] + 0xd9d4d039, 4);
-	MD5STEP(F3, d, a, b, c, in[12] + 0xe6db99e5, 11);
-	MD5STEP(F3, c, d, a, b, in[15] + 0x1fa27cf8, 16);
-	MD5STEP(F3, b, c, d, a, in[2] + 0xc4ac5665, 23);
-
-	MD5STEP(F4, a, b, c, d, in[0] + 0xf4292244, 6);
-	MD5STEP(F4, d, a, b, c, in[7] + 0x432aff97, 10);
-	MD5STEP(F4, c, d, a, b, in[14] + 0xab9423a7, 15);
-	MD5STEP(F4, b, c, d, a, in[5] + 0xfc93a039, 21);
-	MD5STEP(F4, a, b, c, d, in[12] + 0x655b59c3, 6);
-	MD5STEP(F4, d, a, b, c, in[3] + 0x8f0ccc92, 10);
-	MD5STEP(F4, c, d, a, b, in[10] + 0xffeff47d, 15);
-	MD5STEP(F4, b, c, d, a, in[1] + 0x85845dd1, 21);
-	MD5STEP(F4, a, b, c, d, in[8] + 0x6fa87e4f, 6);
-	MD5STEP(F4, d, a, b, c, in[15] + 0xfe2ce6e0, 10);
-	MD5STEP(F4, c, d, a, b, in[6] + 0xa3014314, 15);
-	MD5STEP(F4, b, c, d, a, in[13] + 0x4e0811a1, 21);
-	MD5STEP(F4, a, b, c, d, in[4] + 0xf7537e82, 6);
-	MD5STEP(F4, d, a, b, c, in[11] + 0xbd3af235, 10);
-	MD5STEP(F4, c, d, a, b, in[2] + 0x2ad7d2bb, 15);
-	MD5STEP(F4, b, c, d, a, in[9] + 0xeb86d391, 21);
-
-	hash[0] +=3D a;
-	hash[1] +=3D b;
-	hash[2] +=3D c;
-	hash[3] +=3D d;
-}
-
 /* XXX: this stuff can be optimized */
 static inline void le32_to_cpu_array(u32 *buf, unsigned int words)
 {
diff --git a/drivers/block/cciss.h b/drivers/block/cciss.h
index 16b4d58..c049548 100644
--- a/drivers/block/cciss.h
+++ b/drivers/block/cciss.h
@@ -223,7 +223,7 @@ static void SA5_submit_command( ctlr_info_t *h, Command=
List_struct *c)
 			h->ctlr, c->busaddr);
 #endif /* CCISS_DEBUG */
          writel(c->busaddr, h->vaddr + SA5_REQUEST_PORT_OFFSET);
-	readl(h->vaddr + SA5_REQUEST_PORT_OFFSET);
+	readl(h->vaddr + SA5_SCRATCHPAD_OFFSET);
 	 h->commands_outstanding++;
 	 if ( h->commands_outstanding > h->max_outstanding)
 		h->max_outstanding =3D h->commands_outstanding;
diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 76c8da7..2ebacf0 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -750,10 +750,10 @@ static ssize_t loop_attr_backing_file_show(struct loo=
p_device *lo, char *buf)
 	ssize_t ret;
 	char *p =3D NULL;
=20
-	mutex_lock(&lo->lo_ctl_mutex);
+	spin_lock_irq(&lo->lo_lock);
 	if (lo->lo_backing_file)
 		p =3D d_path(&lo->lo_backing_file->f_path, buf, PAGE_SIZE - 1);
-	mutex_unlock(&lo->lo_ctl_mutex);
+	spin_unlock_irq(&lo->lo_lock);
=20
 	if (IS_ERR_OR_NULL(p))
 		ret =3D PTR_ERR(p);
@@ -1007,7 +1007,9 @@ static int loop_clr_fd(struct loop_device *lo, struct=
 block_device *bdev)
=20
 	kthread_stop(lo->lo_thread);
=20
+	spin_lock_irq(&lo->lo_lock);
 	lo->lo_backing_file =3D NULL;
+	spin_unlock_irq(&lo->lo_lock);
=20
 	loop_release_xfer(lo);
 	lo->transfer =3D NULL;
diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index b536a9c..9ea8c25 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -123,8 +123,8 @@ static DEFINE_SPINLOCK(minor_lock);
 #define BLKIF_MINOR_EXT(dev) ((dev)&(~EXTENDED))
 #define EMULATED_HD_DISK_MINOR_OFFSET (0)
 #define EMULATED_HD_DISK_NAME_OFFSET (EMULATED_HD_DISK_MINOR_OFFSET / 256)
-#define EMULATED_SD_DISK_MINOR_OFFSET (EMULATED_HD_DISK_MINOR_OFFSET + (4 =
* 16))
-#define EMULATED_SD_DISK_NAME_OFFSET (EMULATED_HD_DISK_NAME_OFFSET + 4)
+#define EMULATED_SD_DISK_MINOR_OFFSET (0)
+#define EMULATED_SD_DISK_NAME_OFFSET (EMULATED_SD_DISK_MINOR_OFFSET / 256)
=20
 #define DEV_NAME	"xvd"	/* name in /dev */
=20
@@ -529,7 +529,7 @@ static int xlvbd_alloc_gendisk(blkif_sector_t capacity,
 		minor =3D BLKIF_MINOR_EXT(info->vdevice);
 		nr_parts =3D PARTS_PER_EXT_DISK;
 		offset =3D minor / nr_parts;
-		if (xen_hvm_domain() && offset <=3D EMULATED_HD_DISK_NAME_OFFSET + 4)
+		if (xen_hvm_domain() && offset < EMULATED_HD_DISK_NAME_OFFSET + 4)
 			printk(KERN_WARNING "blkfront: vdevice 0x%x might conflict with "
 					"emulated IDE disks,\n\t choose an xvd device name"
 					"from xvde on\n", info->vdevice);
diff --git a/drivers/char/random.c b/drivers/char/random.c
index d4ddeba..c35a785 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1300,330 +1300,14 @@ ctl_table random_table[] =3D {
 };
 #endif 	/* CONFIG_SYSCTL */
=20
-/********************************************************************
- *
- * Random functions for networking
- *
- ********************************************************************/
-
-/*
- * TCP initial sequence number picking.  This uses the random number
- * generator to pick an initial secret value.  This value is hashed
- * along with the TCP endpoint information to provide a unique
- * starting point for each pair of TCP endpoints.  This defeats
- * attacks which rely on guessing the initial TCP sequence number.
- * This algorithm was suggested by Steve Bellovin.
- *
- * Using a very strong hash was taking an appreciable amount of the total
- * TCP connection establishment time, so this is a weaker hash,
- * compensated for by changing the secret periodically.
- */
-
-/* F, G and H are basic MD4 functions: selection, majority, parity */
-#define F(x, y, z) ((z) ^ ((x) & ((y) ^ (z))))
-#define G(x, y, z) (((x) & (y)) + (((x) ^ (y)) & (z)))
-#define H(x, y, z) ((x) ^ (y) ^ (z))
-
-/*
- * The generic round function.  The application is so specific that
- * we don't bother protecting all the arguments with parens, as is general=
ly
- * good macro practice, in favor of extra legibility.
- * Rotation is separate from addition to prevent recomputation
- */
-#define ROUND(f, a, b, c, d, x, s)	\
-	(a +=3D f(b, c, d) + x, a =3D (a << s) | (a >> (32 - s)))
-#define K1 0
-#define K2 013240474631UL
-#define K3 015666365641UL
+static u32 random_int_secret[MD5_MESSAGE_BYTES / 4] ____cacheline_aligned;
=20
-#if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
-
-static __u32 twothirdsMD4Transform(__u32 const buf[4], __u32 const in[12])
+static int __init random_int_secret_init(void)
 {
-	__u32 a =3D buf[0], b =3D buf[1], c =3D buf[2], d =3D buf[3];
-
-	/* Round 1 */
-	ROUND(F, a, b, c, d, in[ 0] + K1,  3);
-	ROUND(F, d, a, b, c, in[ 1] + K1,  7);
-	ROUND(F, c, d, a, b, in[ 2] + K1, 11);
-	ROUND(F, b, c, d, a, in[ 3] + K1, 19);
-	ROUND(F, a, b, c, d, in[ 4] + K1,  3);
-	ROUND(F, d, a, b, c, in[ 5] + K1,  7);
-	ROUND(F, c, d, a, b, in[ 6] + K1, 11);
-	ROUND(F, b, c, d, a, in[ 7] + K1, 19);
-	ROUND(F, a, b, c, d, in[ 8] + K1,  3);
-	ROUND(F, d, a, b, c, in[ 9] + K1,  7);
-	ROUND(F, c, d, a, b, in[10] + K1, 11);
-	ROUND(F, b, c, d, a, in[11] + K1, 19);
-
-	/* Round 2 */
-	ROUND(G, a, b, c, d, in[ 1] + K2,  3);
-	ROUND(G, d, a, b, c, in[ 3] + K2,  5);
-	ROUND(G, c, d, a, b, in[ 5] + K2,  9);
-	ROUND(G, b, c, d, a, in[ 7] + K2, 13);
-	ROUND(G, a, b, c, d, in[ 9] + K2,  3);
-	ROUND(G, d, a, b, c, in[11] + K2,  5);
-	ROUND(G, c, d, a, b, in[ 0] + K2,  9);
-	ROUND(G, b, c, d, a, in[ 2] + K2, 13);
-	ROUND(G, a, b, c, d, in[ 4] + K2,  3);
-	ROUND(G, d, a, b, c, in[ 6] + K2,  5);
-	ROUND(G, c, d, a, b, in[ 8] + K2,  9);
-	ROUND(G, b, c, d, a, in[10] + K2, 13);
-
-	/* Round 3 */
-	ROUND(H, a, b, c, d, in[ 3] + K3,  3);
-	ROUND(H, d, a, b, c, in[ 7] + K3,  9);
-	ROUND(H, c, d, a, b, in[11] + K3, 11);
-	ROUND(H, b, c, d, a, in[ 2] + K3, 15);
-	ROUND(H, a, b, c, d, in[ 6] + K3,  3);
-	ROUND(H, d, a, b, c, in[10] + K3,  9);
-	ROUND(H, c, d, a, b, in[ 1] + K3, 11);
-	ROUND(H, b, c, d, a, in[ 5] + K3, 15);
-	ROUND(H, a, b, c, d, in[ 9] + K3,  3);
-	ROUND(H, d, a, b, c, in[ 0] + K3,  9);
-	ROUND(H, c, d, a, b, in[ 4] + K3, 11);
-	ROUND(H, b, c, d, a, in[ 8] + K3, 15);
-
-	return buf[1] + b; /* "most hashed" word */
-	/* Alternative: return sum of all words? */
-}
-#endif
-
-#undef ROUND
-#undef F
-#undef G
-#undef H
-#undef K1
-#undef K2
-#undef K3
-
-/* This should not be decreased so low that ISNs wrap too fast. */
-#define REKEY_INTERVAL (300 * HZ)
-/*
- * Bit layout of the tcp sequence numbers (before adding current time):
- * bit 24-31: increased after every key exchange
- * bit 0-23: hash(source,dest)
- *
- * The implementation is similar to the algorithm described
- * in the Appendix of RFC 1185, except that
- * - it uses a 1 MHz clock instead of a 250 kHz clock
- * - it performs a rekey every 5 minutes, which is equivalent
- * 	to a (source,dest) tulple dependent forward jump of the
- * 	clock by 0..2^(HASH_BITS+1)
- *
- * Thus the average ISN wraparound time is 68 minutes instead of
- * 4.55 hours.
- *
- * SMP cleanup and lock avoidance with poor man's RCU.
- * 			Manfred Spraul <manfred@colorfullife.com>
- *
- */
-#define COUNT_BITS 8
-#define COUNT_MASK ((1 << COUNT_BITS) - 1)
-#define HASH_BITS 24
-#define HASH_MASK ((1 << HASH_BITS) - 1)
-
-static struct keydata {
-	__u32 count; /* already shifted to the final position */
-	__u32 secret[12];
-} ____cacheline_aligned ip_keydata[2];
-
-static unsigned int ip_cnt;
-
-static void rekey_seq_generator(struct work_struct *work);
-
-static DECLARE_DELAYED_WORK(rekey_work, rekey_seq_generator);
-
-/*
- * Lock avoidance:
- * The ISN generation runs lockless - it's just a hash over random data.
- * State changes happen every 5 minutes when the random key is replaced.
- * Synchronization is performed by having two copies of the hash function
- * state and rekey_seq_generator always updates the inactive copy.
- * The copy is then activated by updating ip_cnt.
- * The implementation breaks down if someone blocks the thread
- * that processes SYN requests for more than 5 minutes. Should never
- * happen, and even if that happens only a not perfectly compliant
- * ISN is generated, nothing fatal.
- */
-static void rekey_seq_generator(struct work_struct *work)
-{
-	struct keydata *keyptr =3D &ip_keydata[1 ^ (ip_cnt & 1)];
-
-	get_random_bytes(keyptr->secret, sizeof(keyptr->secret));
-	keyptr->count =3D (ip_cnt & COUNT_MASK) << HASH_BITS;
-	smp_wmb();
-	ip_cnt++;
-	schedule_delayed_work(&rekey_work,
-			      round_jiffies_relative(REKEY_INTERVAL));
-}
-
-static inline struct keydata *get_keyptr(void)
-{
-	struct keydata *keyptr =3D &ip_keydata[ip_cnt & 1];
-
-	smp_rmb();
-
-	return keyptr;
-}
-
-static __init int seqgen_init(void)
-{
-	rekey_seq_generator(NULL);
+	get_random_bytes(random_int_secret, sizeof(random_int_secret));
 	return 0;
 }
-late_initcall(seqgen_init);
-
-#if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
-__u32 secure_tcpv6_sequence_number(__be32 *saddr, __be32 *daddr,
-				   __be16 sport, __be16 dport)
-{
-	__u32 seq;
-	__u32 hash[12];
-	struct keydata *keyptr =3D get_keyptr();
-
-	/* The procedure is the same as for IPv4, but addresses are longer.
-	 * Thus we must use twothirdsMD4Transform.
-	 */
-
-	memcpy(hash, saddr, 16);
-	hash[4] =3D ((__force u16)sport << 16) + (__force u16)dport;
-	memcpy(&hash[5], keyptr->secret, sizeof(__u32) * 7);
-
-	seq =3D twothirdsMD4Transform((const __u32 *)daddr, hash) & HASH_MASK;
-	seq +=3D keyptr->count;
-
-	seq +=3D ktime_to_ns(ktime_get_real());
-
-	return seq;
-}
-EXPORT_SYMBOL(secure_tcpv6_sequence_number);
-#endif
-
-/*  The code below is shamelessly stolen from secure_tcp_sequence_number().
- *  All blames to Andrey V. Savochkin <saw@msu.ru>.
- */
-__u32 secure_ip_id(__be32 daddr)
-{
-	struct keydata *keyptr;
-	__u32 hash[4];
-
-	keyptr =3D get_keyptr();
-
-	/*
-	 *  Pick a unique starting offset for each IP destination.
-	 *  The dest ip address is placed in the starting vector,
-	 *  which is then hashed with random data.
-	 */
-	hash[0] =3D (__force __u32)daddr;
-	hash[1] =3D keyptr->secret[9];
-	hash[2] =3D keyptr->secret[10];
-	hash[3] =3D keyptr->secret[11];
-
-	return half_md4_transform(hash, keyptr->secret);
-}
-
-#ifdef CONFIG_INET
-
-__u32 secure_tcp_sequence_number(__be32 saddr, __be32 daddr,
-				 __be16 sport, __be16 dport)
-{
-	__u32 seq;
-	__u32 hash[4];
-	struct keydata *keyptr =3D get_keyptr();
-
-	/*
-	 *  Pick a unique starting offset for each TCP connection endpoints
-	 *  (saddr, daddr, sport, dport).
-	 *  Note that the words are placed into the starting vector, which is
-	 *  then mixed with a partial MD4 over random data.
-	 */
-	hash[0] =3D (__force u32)saddr;
-	hash[1] =3D (__force u32)daddr;
-	hash[2] =3D ((__force u16)sport << 16) + (__force u16)dport;
-	hash[3] =3D keyptr->secret[11];
-
-	seq =3D half_md4_transform(hash, keyptr->secret) & HASH_MASK;
-	seq +=3D keyptr->count;
-	/*
-	 *	As close as possible to RFC 793, which
-	 *	suggests using a 250 kHz clock.
-	 *	Further reading shows this assumes 2 Mb/s networks.
-	 *	For 10 Mb/s Ethernet, a 1 MHz clock is appropriate.
-	 *	For 10 Gb/s Ethernet, a 1 GHz clock should be ok, but
-	 *	we also need to limit the resolution so that the u32 seq
-	 *	overlaps less than one time per MSL (2 minutes).
-	 *	Choosing a clock of 64 ns period is OK. (period of 274 s)
-	 */
-	seq +=3D ktime_to_ns(ktime_get_real()) >> 6;
-
-	return seq;
-}
-
-/* Generate secure starting point for ephemeral IPV4 transport port search=
 */
-u32 secure_ipv4_port_ephemeral(__be32 saddr, __be32 daddr, __be16 dport)
-{
-	struct keydata *keyptr =3D get_keyptr();
-	u32 hash[4];
-
-	/*
-	 *  Pick a unique starting offset for each ephemeral port search
-	 *  (saddr, daddr, dport) and 48bits of random data.
-	 */
-	hash[0] =3D (__force u32)saddr;
-	hash[1] =3D (__force u32)daddr;
-	hash[2] =3D (__force u32)dport ^ keyptr->secret[10];
-	hash[3] =3D keyptr->secret[11];
-
-	return half_md4_transform(hash, keyptr->secret);
-}
-EXPORT_SYMBOL_GPL(secure_ipv4_port_ephemeral);
-
-#if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
-u32 secure_ipv6_port_ephemeral(const __be32 *saddr, const __be32 *daddr,
-			       __be16 dport)
-{
-	struct keydata *keyptr =3D get_keyptr();
-	u32 hash[12];
-
-	memcpy(hash, saddr, 16);
-	hash[4] =3D (__force u32)dport;
-	memcpy(&hash[5], keyptr->secret, sizeof(__u32) * 7);
-
-	return twothirdsMD4Transform((const __u32 *)daddr, hash);
-}
-#endif
-
-#if defined(CONFIG_IP_DCCP) || defined(CONFIG_IP_DCCP_MODULE)
-/* Similar to secure_tcp_sequence_number but generate a 48 bit value
- * bit's 32-47 increase every key exchange
- *       0-31  hash(source, dest)
- */
-u64 secure_dccp_sequence_number(__be32 saddr, __be32 daddr,
-				__be16 sport, __be16 dport)
-{
-	u64 seq;
-	__u32 hash[4];
-	struct keydata *keyptr =3D get_keyptr();
-
-	hash[0] =3D (__force u32)saddr;
-	hash[1] =3D (__force u32)daddr;
-	hash[2] =3D ((__force u16)sport << 16) + (__force u16)dport;
-	hash[3] =3D keyptr->secret[11];
-
-	seq =3D half_md4_transform(hash, keyptr->secret);
-	seq |=3D ((u64)keyptr->count) << (32 - HASH_BITS);
-
-	seq +=3D ktime_to_ns(ktime_get_real());
-	seq &=3D (1ull << 48) - 1;
-
-	return seq;
-}
-EXPORT_SYMBOL(secure_dccp_sequence_number);
-#endif
-
-#endif /* CONFIG_INET */
-
+late_initcall(random_int_secret_init);
=20
 /*
  * Get a random word for internal kernel use only. Similar to urandom but
@@ -1631,17 +1315,15 @@ EXPORT_SYMBOL(secure_dccp_sequence_number);
  * value is not cryptographically secure but for several uses the cost of
  * depleting entropy is too high
  */
-DEFINE_PER_CPU(__u32 [4], get_random_int_hash);
+DEFINE_PER_CPU(__u32 [MD5_DIGEST_WORDS], get_random_int_hash);
 unsigned int get_random_int(void)
 {
-	struct keydata *keyptr;
 	__u32 *hash =3D get_cpu_var(get_random_int_hash);
-	int ret;
+	unsigned int ret;
=20
-	keyptr =3D get_keyptr();
 	hash[0] +=3D current->pid + jiffies + get_cycles();
-
-	ret =3D half_md4_transform(hash, keyptr->secret);
+	md5_transform(hash, random_int_secret);
+	ret =3D hash[0];
 	put_cpu_var(get_random_int_hash);
=20
 	return ret;
diff --git a/drivers/edac/i7core_edac.c b/drivers/edac/i7core_edac.c
index 04f1e7c..f6cf448 100644
--- a/drivers/edac/i7core_edac.c
+++ b/drivers/edac/i7core_edac.c
@@ -1670,7 +1670,7 @@ static void i7core_mce_output_error(struct mem_ctl_in=
fo *mci,
 	char *type, *optype, *err, *msg;
 	unsigned long error =3D m->status & 0x1ff0000l;
 	u32 optypenum =3D (m->status >> 4) & 0x07;
-	u32 core_err_cnt =3D (m->status >> 38) && 0x7fff;
+	u32 core_err_cnt =3D (m->status >> 38) & 0x7fff;
 	u32 dimm =3D (m->misc >> 16) & 0x3;
 	u32 channel =3D (m->misc >> 18) & 0x3;
 	u32 syndrome =3D m->misc >> 32;
diff --git a/drivers/firewire/core-cdev.c b/drivers/firewire/core-cdev.c
index b1c1177..e6ad3bb 100644
--- a/drivers/firewire/core-cdev.c
+++ b/drivers/firewire/core-cdev.c
@@ -253,14 +253,11 @@ static int fw_device_op_open(struct inode *inode, str=
uct file *file)
 	init_waitqueue_head(&client->wait);
 	init_waitqueue_head(&client->tx_flush_wait);
 	INIT_LIST_HEAD(&client->phy_receiver_link);
+	INIT_LIST_HEAD(&client->link);
 	kref_init(&client->kref);
=20
 	file->private_data =3D client;
=20
-	mutex_lock(&device->client_list_mutex);
-	list_add_tail(&client->link, &device->client_list);
-	mutex_unlock(&device->client_list_mutex);
-
 	return nonseekable_open(inode, file);
 }
=20
@@ -451,15 +448,20 @@ static int ioctl_get_info(struct client *client, unio=
n ioctl_arg *arg)
 	if (ret !=3D 0)
 		return -EFAULT;
=20
+	mutex_lock(&client->device->client_list_mutex);
+
 	client->bus_reset_closure =3D a->bus_reset_closure;
 	if (a->bus_reset !=3D 0) {
 		fill_bus_reset_event(&bus_reset, client);
-		if (copy_to_user(u64_to_uptr(a->bus_reset),
-				 &bus_reset, sizeof(bus_reset)))
-			return -EFAULT;
+		ret =3D copy_to_user(u64_to_uptr(a->bus_reset),
+				   &bus_reset, sizeof(bus_reset));
 	}
+	if (ret =3D=3D 0 && list_empty(&client->link))
+		list_add_tail(&client->link, &client->device->client_list);
=20
-	return 0;
+	mutex_unlock(&client->device->client_list_mutex);
+
+	return ret ? -EFAULT : 0;
 }
=20
 static int add_client_resource(struct client *client,
@@ -1583,7 +1585,7 @@ static int dispatch_ioctl(struct client *client,
 	if (_IOC_TYPE(cmd) !=3D '#' ||
 	    _IOC_NR(cmd) >=3D ARRAY_SIZE(ioctl_handlers) ||
 	    _IOC_SIZE(cmd) > sizeof(buffer))
-		return -EINVAL;
+		return -ENOTTY;
=20
 	if (_IOC_DIR(cmd) =3D=3D _IOC_READ)
 		memset(&buffer, 0, _IOC_SIZE(cmd));
diff --git a/drivers/firmware/sigma.c b/drivers/firmware/sigma.c
index c19cd2c..f10fc52 100644
--- a/drivers/firmware/sigma.c
+++ b/drivers/firmware/sigma.c
@@ -11,6 +11,7 @@
 #include <linux/firmware.h>
 #include <linux/kernel.h>
 #include <linux/i2c.h>
+#include <linux/module.h>
 #include <linux/sigma.h>
=20
 /* Return: 0=3D=3DOK, <0=3D=3Derror, =3D1 =3D=3Dno more actions */
@@ -113,3 +114,5 @@ int process_sigma_firmware(struct i2c_client *client, c=
onst char *name)
 	return ret;
 }
 EXPORT_SYMBOL(process_sigma_firmware);
+
+MODULE_LICENSE("GPL");
diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
index 0929219..1bbb85b 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -127,6 +127,23 @@ static const u8 edid_header[] =3D {
 	0x00, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x00
 };
=20
+ /*
+ * Sanity check the header of the base EDID block.  Return 8 if the header
+ * is perfect, down to 0 if it's totally wrong.
+ */
+int drm_edid_header_is_valid(const u8 *raw_edid)
+{
+	int i, score =3D 0;
+
+	for (i =3D 0; i < sizeof(edid_header); i++)
+		if (raw_edid[i] =3D=3D edid_header[i])
+			score++;
+
+	return score;
+}
+EXPORT_SYMBOL(drm_edid_header_is_valid);
+
+
 /*
  * Sanity check the EDID block (base or extension).  Return 0 if the block
  * doesn't check out, or 1 if it's valid.
@@ -139,12 +156,7 @@ drm_edid_block_valid(u8 *raw_edid)
 	struct edid *edid =3D (struct edid *)raw_edid;
=20
 	if (raw_edid[0] =3D=3D 0x00) {
-		int score =3D 0;
-
-		for (i =3D 0; i < sizeof(edid_header); i++)
-			if (raw_edid[i] =3D=3D edid_header[i])
-				score++;
-
+		int score =3D drm_edid_header_is_valid(raw_edid);
 		if (score =3D=3D 8) ;
 		else if (score >=3D 6) {
 			DRM_DEBUG("Fixing EDID header, your hardware may be failing\n");
diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dm=
a.c
index 296fbd6..7eef6e1 100644
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -61,7 +61,6 @@ static void i915_write_hws_pga(struct drm_device *dev)
 static int i915_init_phys_hws(struct drm_device *dev)
 {
 	drm_i915_private_t *dev_priv =3D dev->dev_private;
-	struct intel_ring_buffer *ring =3D LP_RING(dev_priv);
=20
 	/* Program Hardware Status Page */
 	dev_priv->status_page_dmah =3D
@@ -71,10 +70,9 @@ static int i915_init_phys_hws(struct drm_device *dev)
 		DRM_ERROR("Can not allocate hardware status page\n");
 		return -ENOMEM;
 	}
-	ring->status_page.page_addr =3D
-		(void __force __iomem *)dev_priv->status_page_dmah->vaddr;
=20
-	memset_io(ring->status_page.page_addr, 0, PAGE_SIZE);
+	memset_io((void __force __iomem *)dev_priv->status_page_dmah->vaddr,
+		  0, PAGE_SIZE);
=20
 	i915_write_hws_pga(dev);
=20
diff --git a/drivers/gpu/drm/i915/i915_irq.c b/drivers/gpu/drm/i915/i915_ir=
q.c
index 3b03f85..9b1d669 100644
--- a/drivers/gpu/drm/i915/i915_irq.c
+++ b/drivers/gpu/drm/i915/i915_irq.c
@@ -306,12 +306,15 @@ static void i915_hotplug_work_func(struct work_struct=
 *work)
 	struct drm_mode_config *mode_config =3D &dev->mode_config;
 	struct intel_encoder *encoder;
=20
+	mutex_lock(&mode_config->mutex);
 	DRM_DEBUG_KMS("running encoder hotplug functions\n");
=20
 	list_for_each_entry(encoder, &mode_config->encoder_list, base.head)
 		if (encoder->hot_plug)
 			encoder->hot_plug(encoder);
=20
+	mutex_unlock(&mode_config->mutex);
+
 	/* Just fire off a uevent and let userspace tell us what to do */
 	drm_helper_hpd_irq_event(dev);
 }
diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/in=
tel_display.c
index 0f1c799..5609c06 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -2699,14 +2699,18 @@ static void ironlake_crtc_enable(struct drm_crtc *c=
rtc)
 		I915_WRITE(PF_WIN_SZ(pipe), dev_priv->pch_pf_size);
 	}
=20
+	/*
+	 * On ILK+ LUT must be loaded before the pipe is running but with
+	 * clocks enabled
+	 */
+	intel_crtc_load_lut(crtc);
+
 	intel_enable_pipe(dev_priv, pipe, is_pch_port);
 	intel_enable_plane(dev_priv, plane, pipe);
=20
 	if (is_pch_port)
 		ironlake_pch_enable(crtc);
=20
-	intel_crtc_load_lut(crtc);
-
 	mutex_lock(&dev->struct_mutex);
 	intel_update_fbc(dev);
 	mutex_unlock(&dev->struct_mutex);
diff --git a/drivers/gpu/drm/i915/intel_panel.c b/drivers/gpu/drm/i915/inte=
l_panel.c
index a06ff07..05f500c 100644
--- a/drivers/gpu/drm/i915/intel_panel.c
+++ b/drivers/gpu/drm/i915/intel_panel.c
@@ -83,11 +83,15 @@ intel_pch_panel_fitting(struct drm_device *dev,
 			u32 scaled_height =3D mode->hdisplay * adjusted_mode->vdisplay;
 			if (scaled_width > scaled_height) { /* pillar */
 				width =3D scaled_height / mode->vdisplay;
+				if (width & 1)
+				    	width++;
 				x =3D (adjusted_mode->hdisplay - width + 1) / 2;
 				y =3D 0;
 				height =3D adjusted_mode->vdisplay;
 			} else if (scaled_width < scaled_height) { /* letter */
 				height =3D scaled_width / mode->hdisplay;
+				if (height & 1)
+				    height++;
 				y =3D (adjusted_mode->vdisplay - height + 1) / 2;
 				x =3D 0;
 				width =3D adjusted_mode->hdisplay;
diff --git a/drivers/gpu/drm/i915/intel_ringbuffer.c b/drivers/gpu/drm/i915=
/intel_ringbuffer.c
index 95c4b14..1f61fc7 100644
--- a/drivers/gpu/drm/i915/intel_ringbuffer.c
+++ b/drivers/gpu/drm/i915/intel_ringbuffer.c
@@ -1319,6 +1319,9 @@ int intel_render_ring_init_dri(struct drm_device *dev=
, u64 start, u32 size)
 		ring->get_seqno =3D pc_render_get_seqno;
 	}
=20
+	if (!I915_NEED_GFX_HWS(dev))
+		ring->status_page.page_addr =3D dev_priv->status_page_dmah->vaddr;
+
 	ring->dev =3D dev;
 	INIT_LIST_HEAD(&ring->active_list);
 	INIT_LIST_HEAD(&ring->request_list);
diff --git a/drivers/gpu/drm/radeon/atombios_dp.c b/drivers/gpu/drm/radeon/=
atombios_dp.c
index 8c0f9e3..7ad43c6 100644
--- a/drivers/gpu/drm/radeon/atombios_dp.c
+++ b/drivers/gpu/drm/radeon/atombios_dp.c
@@ -613,6 +613,18 @@ static bool radeon_dp_get_link_status(struct radeon_co=
nnector *radeon_connector,
 	return true;
 }
=20
+bool radeon_dp_needs_link_train(struct radeon_connector *radeon_connector)
+{
+	u8 link_status[DP_LINK_STATUS_SIZE];
+	struct radeon_connector_atom_dig *dig =3D radeon_connector->con_priv;
+
+	if (!radeon_dp_get_link_status(radeon_connector, link_status))
+		return false;
+	if (dp_channel_eq_ok(link_status, dig->dp_lane_count))
+		return false;
+	return true;
+}
+
 struct radeon_dp_link_train_info {
 	struct radeon_device *rdev;
 	struct drm_encoder *encoder;
@@ -627,6 +639,7 @@ struct radeon_dp_link_train_info {
 	u8 train_set[4];
 	u8 link_status[DP_LINK_STATUS_SIZE];
 	u8 tries;
+	bool use_dpencoder;
 };
=20
 static void radeon_dp_update_vs_emph(struct radeon_dp_link_train_info *dp_=
info)
@@ -646,7 +659,7 @@ static void radeon_dp_set_tp(struct radeon_dp_link_trai=
n_info *dp_info, int tp)
 	int rtp =3D 0;
=20
 	/* set training pattern on the source */
-	if (ASIC_IS_DCE4(dp_info->rdev)) {
+	if (ASIC_IS_DCE4(dp_info->rdev) || !dp_info->use_dpencoder) {
 		switch (tp) {
 		case DP_TRAINING_PATTERN_1:
 			rtp =3D ATOM_ENCODER_CMD_DP_LINK_TRAINING_PATTERN1;
@@ -706,7 +719,7 @@ static int radeon_dp_link_train_init(struct radeon_dp_l=
ink_train_info *dp_info)
 	radeon_write_dpcd_reg(dp_info->radeon_connector, DP_LINK_BW_SET, tmp);
=20
 	/* start training on the source */
-	if (ASIC_IS_DCE4(dp_info->rdev))
+	if (ASIC_IS_DCE4(dp_info->rdev) || !dp_info->use_dpencoder)
 		atombios_dig_encoder_setup(dp_info->encoder,
 					   ATOM_ENCODER_CMD_DP_LINK_TRAINING_START, 0);
 	else
@@ -731,7 +744,7 @@ static int radeon_dp_link_train_finish(struct radeon_dp=
_link_train_info *dp_info
 			      DP_TRAINING_PATTERN_DISABLE);
=20
 	/* disable the training pattern on the source */
-	if (ASIC_IS_DCE4(dp_info->rdev))
+	if (ASIC_IS_DCE4(dp_info->rdev) || !dp_info->use_dpencoder)
 		atombios_dig_encoder_setup(dp_info->encoder,
 					   ATOM_ENCODER_CMD_DP_LINK_TRAINING_COMPLETE, 0);
 	else
@@ -869,7 +882,8 @@ void radeon_dp_link_train(struct drm_encoder *encoder,
 	struct radeon_connector *radeon_connector;
 	struct radeon_connector_atom_dig *dig_connector;
 	struct radeon_dp_link_train_info dp_info;
- 	u8 tmp;
+	int index;
+	u8 tmp, frev, crev;
=20
 	if (!radeon_encoder->enc_priv)
 		return;
@@ -884,6 +898,18 @@ void radeon_dp_link_train(struct drm_encoder *encoder,
 	    (dig_connector->dp_sink_type !=3D CONNECTOR_OBJECT_ID_eDP))
 		return;
=20
+	/* DPEncoderService newer than 1.1 can't program properly the
+	 * training pattern. When facing such version use the
+	 * DIGXEncoderControl (X=3D=3D 1 | 2)
+	 */
+	dp_info.use_dpencoder =3D true;
+	index =3D GetIndexIntoMasterTable(COMMAND, DPEncoderService);
+	if (atom_parse_cmd_header(rdev->mode_info.atom_context, index, &frev, &cr=
ev)) {
+		if (crev > 1) {
+			dp_info.use_dpencoder =3D false;
+		}
+	}
+
 	dp_info.enc_id =3D 0;
 	if (dig->dig_encoder)
 		dp_info.enc_id |=3D ATOM_DP_CONFIG_DIG2_ENCODER;
diff --git a/drivers/gpu/drm/radeon/radeon_combios.c b/drivers/gpu/drm/rade=
on/radeon_combios.c
index e459467..a74217c 100644
--- a/drivers/gpu/drm/radeon/radeon_combios.c
+++ b/drivers/gpu/drm/radeon/radeon_combios.c
@@ -779,7 +779,8 @@ void radeon_combios_i2c_init(struct radeon_device *rdev)
 				}
 			}
 		}
-	} else if (rdev->family >=3D CHIP_R200) {
+	} else if ((rdev->family =3D=3D CHIP_R200) ||
+		   (rdev->family >=3D CHIP_R300)) {
 		/* 0x68 */
 		i2c =3D combios_setup_i2c_bus(rdev, DDC_MONID, 0, 0);
 		rdev->i2c_bus[3] =3D radeon_i2c_create(dev, &i2c, "MONID");
diff --git a/drivers/gpu/drm/radeon/radeon_connectors.c b/drivers/gpu/drm/r=
adeon/radeon_connectors.c
index 9792d4f..d1b36f8 100644
--- a/drivers/gpu/drm/radeon/radeon_connectors.c
+++ b/drivers/gpu/drm/radeon/radeon_connectors.c
@@ -60,18 +60,20 @@ void radeon_connector_hotplug(struct drm_connector *con=
nector)
=20
 	radeon_hpd_set_polarity(rdev, radeon_connector->hpd.hpd);
=20
-	/* powering up/down the eDP panel generates hpd events which
-	 * can interfere with modesetting.
-	 */
-	if (connector->connector_type =3D=3D DRM_MODE_CONNECTOR_eDP)
+	/* if the connector is already off, don't turn it back on */
+	if (connector->dpms !=3D DRM_MODE_DPMS_ON)
 		return;
=20
-	/* pre-r600 did not always have the hpd pins mapped accurately to connect=
ors */
-	if (rdev->family >=3D CHIP_R600) {
-		if (radeon_hpd_sense(rdev, radeon_connector->hpd.hpd))
+	/* just deal with DP (not eDP) here. */
+	if (connector->connector_type =3D=3D DRM_MODE_CONNECTOR_DisplayPort) {
+		int saved_dpms =3D connector->dpms;
+
+		if (radeon_hpd_sense(rdev, radeon_connector->hpd.hpd) &&
+		    radeon_dp_needs_link_train(radeon_connector))
 			drm_helper_connector_dpms(connector, DRM_MODE_DPMS_ON);
 		else
 			drm_helper_connector_dpms(connector, DRM_MODE_DPMS_OFF);
+		connector->dpms =3D saved_dpms;
 	}
 }
=20
@@ -430,6 +432,55 @@ int radeon_connector_set_property(struct drm_connector=
 *connector, struct drm_pr
 	return 0;
 }
=20
+/*
+ * Some integrated ATI Radeon chipset implementations (e. g.
+ * Asus M2A-VM HDMI) may indicate the availability of a DDC,
+ * even when there's no monitor connected. For these connectors
+ * following DDC probe extension will be applied: check also for the
+ * availability of EDID with at least a correct EDID header. Only then,
+ * DDC is assumed to be available. This prevents drm_get_edid() and
+ * drm_edid_block_valid() from periodically dumping data and kernel
+ * errors into the logs and onto the terminal.
+ */
+static bool radeon_connector_needs_extended_probe(struct radeon_device *de=
v,
+				     uint32_t supported_device,
+				     int connector_type)
+{
+	/* Asus M2A-VM HDMI board sends data to i2c bus even,
+	 * if HDMI add-on card is not plugged in or HDMI is disabled in
+	 * BIOS. Valid DDC can only be assumed, if also a valid EDID header
+	 * can be retrieved via i2c bus during DDC probe */
+	if ((dev->pdev->device =3D=3D 0x791e) &&
+	    (dev->pdev->subsystem_vendor =3D=3D 0x1043) &&
+	    (dev->pdev->subsystem_device =3D=3D 0x826d)) {
+		if ((connector_type =3D=3D DRM_MODE_CONNECTOR_HDMIA) &&
+		    (supported_device =3D=3D ATOM_DEVICE_DFP2_SUPPORT))
+			return true;
+	}
+	/* ECS A740GM-M with ATI RADEON 2100 sends data to i2c bus
+	 * for a DVI connector that is not implemented */
+	if ((dev->pdev->device =3D=3D 0x796e) &&
+	    (dev->pdev->subsystem_vendor =3D=3D 0x1019) &&
+	    (dev->pdev->subsystem_device =3D=3D 0x2615)) {
+		if ((connector_type =3D=3D DRM_MODE_CONNECTOR_DVID) &&
+		    (supported_device =3D=3D ATOM_DEVICE_DFP2_SUPPORT))
+			return true;
+	}
+	/* TOSHIBA Satellite L300D with ATI Mobility Radeon x1100
+	 * (RS690M) sends data to i2c bus for a HDMI connector that
+	 * is not implemented */
+	if ((dev->pdev->device =3D=3D 0x791f) &&
+	    (dev->pdev->subsystem_vendor =3D=3D 0x1179) &&
+	    (dev->pdev->subsystem_device =3D=3D 0xff68)) {
+		if ((connector_type =3D=3D DRM_MODE_CONNECTOR_HDMIA) &&
+		    (supported_device =3D=3D ATOM_DEVICE_DFP2_SUPPORT))
+			return true;
+	}
+
+	/* Default: no EDID header probe required for DDC probing */
+	return false;
+}
+
 static void radeon_fixup_lvds_native_mode(struct drm_encoder *encoder,
 					  struct drm_connector *connector)
 {
@@ -661,7 +712,8 @@ radeon_vga_detect(struct drm_connector *connector, bool=
 force)
 		ret =3D connector_status_disconnected;
=20
 	if (radeon_connector->ddc_bus)
-		dret =3D radeon_ddc_probe(radeon_connector);
+		dret =3D radeon_ddc_probe(radeon_connector,
+					radeon_connector->requires_extended_probe);
 	if (dret) {
 		if (radeon_connector->edid) {
 			kfree(radeon_connector->edid);
@@ -833,7 +885,8 @@ radeon_dvi_detect(struct drm_connector *connector, bool=
 force)
 	bool dret =3D false;
=20
 	if (radeon_connector->ddc_bus)
-		dret =3D radeon_ddc_probe(radeon_connector);
+		dret =3D radeon_ddc_probe(radeon_connector,
+					radeon_connector->requires_extended_probe);
 	if (dret) {
 		if (radeon_connector->edid) {
 			kfree(radeon_connector->edid);
@@ -1251,7 +1304,8 @@ radeon_dp_detect(struct drm_connector *connector, boo=
l force)
 				if (radeon_dp_getdpcd(radeon_connector))
 					ret =3D connector_status_connected;
 			} else {
-				if (radeon_ddc_probe(radeon_connector))
+				if (radeon_ddc_probe(radeon_connector,
+						     radeon_connector->requires_extended_probe))
 					ret =3D connector_status_connected;
 			}
 		}
@@ -1406,6 +1460,9 @@ radeon_add_atom_connector(struct drm_device *dev,
 	radeon_connector->shared_ddc =3D shared_ddc;
 	radeon_connector->connector_object_id =3D connector_object_id;
 	radeon_connector->hpd =3D *hpd;
+	radeon_connector->requires_extended_probe =3D
+		radeon_connector_needs_extended_probe(rdev, supported_device,
+							connector_type);
 	radeon_connector->router =3D *router;
 	if (router->ddc_valid || router->cd_valid) {
 		radeon_connector->router_bus =3D radeon_i2c_lookup(rdev, &router->i2c_in=
fo);
@@ -1752,6 +1809,9 @@ radeon_add_legacy_connector(struct drm_device *dev,
 	radeon_connector->devices =3D supported_device;
 	radeon_connector->connector_object_id =3D connector_object_id;
 	radeon_connector->hpd =3D *hpd;
+	radeon_connector->requires_extended_probe =3D
+		radeon_connector_needs_extended_probe(rdev, supported_device,
+							connector_type);
 	switch (connector_type) {
 	case DRM_MODE_CONNECTOR_VGA:
 		drm_connector_init(dev, &radeon_connector->base, &radeon_vga_connector_f=
uncs, connector_type);
diff --git a/drivers/gpu/drm/radeon/radeon_device.c b/drivers/gpu/drm/radeo=
n/radeon_device.c
index 7cfaa7e..440e6ec 100644
--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -704,8 +704,9 @@ int radeon_device_init(struct radeon_device *rdev,
 	rdev->gpu_lockup =3D false;
 	rdev->accel_working =3D false;
=20
-	DRM_INFO("initializing kernel modesetting (%s 0x%04X:0x%04X).\n",
-		radeon_family_name[rdev->family], pdev->vendor, pdev->device);
+	DRM_INFO("initializing kernel modesetting (%s 0x%04X:0x%04X 0x%04X:0x%04X=
).\n",
+		radeon_family_name[rdev->family], pdev->vendor, pdev->device,
+		pdev->subsystem_vendor, pdev->subsystem_device);
=20
 	/* mutex initialization are all done here so we
 	 * can recall function without having locking issues */
diff --git a/drivers/gpu/drm/radeon/radeon_display.c b/drivers/gpu/drm/rade=
on/radeon_display.c
index 292f73f..ed085ce 100644
--- a/drivers/gpu/drm/radeon/radeon_display.c
+++ b/drivers/gpu/drm/radeon/radeon_display.c
@@ -777,8 +777,17 @@ static int radeon_ddc_dump(struct drm_connector *conne=
ctor)
 	if (!radeon_connector->ddc_bus)
 		return -1;
 	edid =3D drm_get_edid(connector, &radeon_connector->ddc_bus->adapter);
+	/* Log EDID retrieval status here. In particular with regard to
+	 * connectors with requires_extended_probe flag set, that will prevent
+	 * function radeon_dvi_detect() to fetch EDID on this connector,
+	 * as long as there is no valid EDID header found */
 	if (edid) {
+		DRM_INFO("Radeon display connector %s: Found valid EDID",
+				drm_get_connector_name(connector));
 		kfree(edid);
+	} else {
+		DRM_INFO("Radeon display connector %s: No monitor connected or invalid E=
DID",
+				drm_get_connector_name(connector));
 	}
 	return ret;
 }
diff --git a/drivers/gpu/drm/radeon/radeon_encoders.c b/drivers/gpu/drm/rad=
eon/radeon_encoders.c
index b293487..319d85d 100644
--- a/drivers/gpu/drm/radeon/radeon_encoders.c
+++ b/drivers/gpu/drm/radeon/radeon_encoders.c
@@ -2323,6 +2323,9 @@ radeon_add_atom_encoder(struct drm_device *dev,
 	default:
 		encoder->possible_crtcs =3D 0x3;
 		break;
+	case 4:
+		encoder->possible_crtcs =3D 0xf;
+		break;
 	case 6:
 		encoder->possible_crtcs =3D 0x3f;
 		break;
diff --git a/drivers/gpu/drm/radeon/radeon_i2c.c b/drivers/gpu/drm/radeon/r=
adeon_i2c.c
index 781196d..6c111c1 100644
--- a/drivers/gpu/drm/radeon/radeon_i2c.c
+++ b/drivers/gpu/drm/radeon/radeon_i2c.c
@@ -32,17 +32,17 @@
  * radeon_ddc_probe
  *
  */
-bool radeon_ddc_probe(struct radeon_connector *radeon_connector)
+bool radeon_ddc_probe(struct radeon_connector *radeon_connector, bool requ=
ires_extended_probe)
 {
-	u8 out_buf[] =3D { 0x0, 0x0};
-	u8 buf[2];
+	u8 out =3D 0x0;
+	u8 buf[8];
 	int ret;
 	struct i2c_msg msgs[] =3D {
 		{
 			.addr =3D 0x50,
 			.flags =3D 0,
 			.len =3D 1,
-			.buf =3D out_buf,
+			.buf =3D &out,
 		},
 		{
 			.addr =3D 0x50,
@@ -52,15 +52,31 @@ bool radeon_ddc_probe(struct radeon_connector *radeon_c=
onnector)
 		}
 	};
=20
+	/* Read 8 bytes from i2c for extended probe of EDID header */
+	if (requires_extended_probe)
+		msgs[1].len =3D 8;
+
 	/* on hw with routers, select right port */
 	if (radeon_connector->router.ddc_valid)
 		radeon_router_select_ddc_port(radeon_connector);
=20
 	ret =3D i2c_transfer(&radeon_connector->ddc_bus->adapter, msgs, 2);
-	if (ret =3D=3D 2)
-		return true;
-
-	return false;
+	if (ret !=3D 2)
+		/* Couldn't find an accessible DDC on this connector */
+		return false;
+	if (requires_extended_probe) {
+		/* Probe also for valid EDID header
+		 * EDID header starts with:
+		 * 0x00,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0x00.
+		 * Only the first 6 bytes must be valid as
+		 * drm_edid_block_valid() can fix the last 2 bytes */
+		if (drm_edid_header_is_valid(buf) < 6) {
+			/* Couldn't find an accessible EDID on this
+			 * connector */
+			return false;
+		}
+	}
+	return true;
 }
=20
 /* bit banging i2c */
diff --git a/drivers/gpu/drm/radeon/radeon_mode.h b/drivers/gpu/drm/radeon/=
radeon_mode.h
index 6df4e3c..68820f5 100644
--- a/drivers/gpu/drm/radeon/radeon_mode.h
+++ b/drivers/gpu/drm/radeon/radeon_mode.h
@@ -438,6 +438,9 @@ struct radeon_connector {
 	struct radeon_i2c_chan *ddc_bus;
 	/* some systems have an hdmi and vga port with a shared ddc line */
 	bool shared_ddc;
+	/* for some Radeon chip families we apply an additional EDID header
+	   check as part of the DDC probe */
+	bool requires_extended_probe;
 	bool use_digital;
 	/* we need to mind the EDID between detect
 	   and get modes due to analog/digital/tvencoder */
@@ -476,6 +479,7 @@ extern void radeon_dp_set_link_config(struct drm_connec=
tor *connector,
 				      struct drm_display_mode *mode);
 extern void radeon_dp_link_train(struct drm_encoder *encoder,
 				 struct drm_connector *connector);
+extern bool radeon_dp_needs_link_train(struct radeon_connector *radeon_con=
nector);
 extern u8 radeon_dp_getsinktype(struct radeon_connector *radeon_connector);
 extern bool radeon_dp_getdpcd(struct radeon_connector *radeon_connector);
 extern void atombios_dig_encoder_setup(struct drm_encoder *encoder, int ac=
tion, int panel_mode);
@@ -514,7 +518,8 @@ extern void radeon_i2c_put_byte(struct radeon_i2c_chan =
*i2c,
 				u8 val);
 extern void radeon_router_select_ddc_port(struct radeon_connector *radeon_=
connector);
 extern void radeon_router_select_cd_port(struct radeon_connector *radeon_c=
onnector);
-extern bool radeon_ddc_probe(struct radeon_connector *radeon_connector);
+extern bool radeon_ddc_probe(struct radeon_connector *radeon_connector,
+			bool requires_extended_probe);
 extern int radeon_ddc_get_modes(struct radeon_connector *radeon_connector);
=20
 extern struct drm_encoder *radeon_best_encoder(struct drm_connector *conne=
ctor);
diff --git a/drivers/gpu/drm/radeon/radeon_pm.c b/drivers/gpu/drm/radeon/ra=
deon_pm.c
index aaa19dc..6fabe89 100644
--- a/drivers/gpu/drm/radeon/radeon_pm.c
+++ b/drivers/gpu/drm/radeon/radeon_pm.c
@@ -594,6 +594,9 @@ int radeon_pm_init(struct radeon_device *rdev)
 			if (rdev->pm.default_vddc)
 				radeon_atom_set_voltage(rdev, rdev->pm.default_vddc,
 							SET_VOLTAGE_TYPE_ASIC_VDDC);
+			if (rdev->pm.default_vddci)
+				radeon_atom_set_voltage(rdev, rdev->pm.default_vddci,
+							SET_VOLTAGE_TYPE_ASIC_VDDCI);
 			if (rdev->pm.default_sclk)
 				radeon_set_engine_clock(rdev, rdev->pm.default_sclk);
 			if (rdev->pm.default_mclk)
diff --git a/drivers/gpu/drm/ttm/ttm_bo.c b/drivers/gpu/drm/ttm/ttm_bo.c
index 2e618b5..b7f0726 100644
--- a/drivers/gpu/drm/ttm/ttm_bo.c
+++ b/drivers/gpu/drm/ttm/ttm_bo.c
@@ -353,8 +353,10 @@ static int ttm_bo_add_ttm(struct ttm_buffer_object *bo=
, bool zero_alloc)
=20
 		ret =3D ttm_tt_set_user(bo->ttm, current,
 				      bo->buffer_start, bo->num_pages);
-		if (unlikely(ret !=3D 0))
+		if (unlikely(ret !=3D 0)) {
 			ttm_tt_destroy(bo->ttm);
+			bo->ttm =3D NULL;
+		}
 		break;
 	default:
 		printk(KERN_ERR TTM_PFX "Illegal buffer object type\n");
diff --git a/drivers/hwmon/ibmaem.c b/drivers/hwmon/ibmaem.c
index 1a409c5..c316294 100644
--- a/drivers/hwmon/ibmaem.c
+++ b/drivers/hwmon/ibmaem.c
@@ -432,13 +432,15 @@ static int aem_read_sensor(struct aem_data *data, u8 =
elt, u8 reg,
 	aem_send_message(ipmi);
=20
 	res =3D wait_for_completion_timeout(&ipmi->read_complete, IPMI_TIMEOUT);
-	if (!res)
-		return -ETIMEDOUT;
+	if (!res) {
+		res =3D -ETIMEDOUT;
+		goto out;
+	}
=20
 	if (ipmi->rx_result || ipmi->rx_msg_len !=3D rs_size ||
 	    memcmp(&rs_resp->id, &system_x_id, sizeof(system_x_id))) {
-		kfree(rs_resp);
-		return -ENOENT;
+		res =3D -ENOENT;
+		goto out;
 	}
=20
 	switch (size) {
@@ -463,8 +465,11 @@ static int aem_read_sensor(struct aem_data *data, u8 e=
lt, u8 reg,
 		break;
 	}
 	}
+	res =3D 0;
=20
-	return 0;
+out:
+	kfree(rs_resp);
+	return res;
 }
=20
 /* Update AEM energy registers */
diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/s=
rp/ib_srp.c
index ee165fd..7d5109b 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -2127,6 +2127,8 @@ static ssize_t srp_create_target(struct device *dev,
 		return -ENOMEM;
=20
 	target_host->transportt  =3D ib_srp_transport_template;
+	target_host->max_channel =3D 0;
+	target_host->max_id      =3D 1;
 	target_host->max_lun     =3D SRP_MAX_LUN;
 	target_host->max_cmd_len =3D sizeof ((struct srp_cmd *) (void *) 0L)->cdb;
=20
diff --git a/drivers/isdn/i4l/isdn_net.c b/drivers/isdn/i4l/isdn_net.c
index 9798811..b145b5a 100644
--- a/drivers/isdn/i4l/isdn_net.c
+++ b/drivers/isdn/i4l/isdn_net.c
@@ -2531,6 +2531,9 @@ static void _isdn_setup(struct net_device *dev)
=20
 	/* Setup the generic properties */
 	dev->flags =3D IFF_NOARP|IFF_POINTOPOINT;
+
+	/* isdn prepends a header in the tx path, can't share skbs */
+	dev->priv_flags &=3D ~IFF_TX_SKB_SHARING;
 	dev->header_ops =3D NULL;
 	dev->netdev_ops =3D &isdn_netdev_ops;
=20
diff --git a/drivers/md/dm-io.c b/drivers/md/dm-io.c
index 2067288..ad2eba4 100644
--- a/drivers/md/dm-io.c
+++ b/drivers/md/dm-io.c
@@ -38,6 +38,8 @@ struct io {
 	struct dm_io_client *client;
 	io_notify_fn callback;
 	void *context;
+	void *vma_invalidate_address;
+	unsigned long vma_invalidate_size;
 } __attribute__((aligned(DM_IO_MAX_REGIONS)));
=20
 static struct kmem_cache *_dm_io_cache;
@@ -116,6 +118,10 @@ static void dec_count(struct io *io, unsigned int regi=
on, int error)
 		set_bit(region, &io->error_bits);
=20
 	if (atomic_dec_and_test(&io->count)) {
+		if (io->vma_invalidate_size)
+			invalidate_kernel_vmap_range(io->vma_invalidate_address,
+						     io->vma_invalidate_size);
+
 		if (io->sleeper)
 			wake_up_process(io->sleeper);
=20
@@ -159,6 +165,9 @@ struct dpages {
=20
 	unsigned context_u;
 	void *context_ptr;
+
+	void *vma_invalidate_address;
+	unsigned long vma_invalidate_size;
 };
=20
 /*
@@ -377,6 +386,9 @@ static int sync_io(struct dm_io_client *client, unsigne=
d int num_regions,
 	io->sleeper =3D current;
 	io->client =3D client;
=20
+	io->vma_invalidate_address =3D dp->vma_invalidate_address;
+	io->vma_invalidate_size =3D dp->vma_invalidate_size;
+
 	dispatch_io(rw, num_regions, where, dp, io, 1);
=20
 	while (1) {
@@ -415,13 +427,21 @@ static int async_io(struct dm_io_client *client, unsi=
gned int num_regions,
 	io->callback =3D fn;
 	io->context =3D context;
=20
+	io->vma_invalidate_address =3D dp->vma_invalidate_address;
+	io->vma_invalidate_size =3D dp->vma_invalidate_size;
+
 	dispatch_io(rw, num_regions, where, dp, io, 0);
 	return 0;
 }
=20
-static int dp_init(struct dm_io_request *io_req, struct dpages *dp)
+static int dp_init(struct dm_io_request *io_req, struct dpages *dp,
+		   unsigned long size)
 {
 	/* Set up dpages based on memory type */
+
+	dp->vma_invalidate_address =3D NULL;
+	dp->vma_invalidate_size =3D 0;
+
 	switch (io_req->mem.type) {
 	case DM_IO_PAGE_LIST:
 		list_dp_init(dp, io_req->mem.ptr.pl, io_req->mem.offset);
@@ -432,6 +452,11 @@ static int dp_init(struct dm_io_request *io_req, struc=
t dpages *dp)
 		break;
=20
 	case DM_IO_VMA:
+		flush_kernel_vmap_range(io_req->mem.ptr.vma, size);
+		if ((io_req->bi_rw & RW_MASK) =3D=3D READ) {
+			dp->vma_invalidate_address =3D io_req->mem.ptr.vma;
+			dp->vma_invalidate_size =3D size;
+		}
 		vm_dp_init(dp, io_req->mem.ptr.vma);
 		break;
=20
@@ -460,7 +485,7 @@ int dm_io(struct dm_io_request *io_req, unsigned num_re=
gions,
 	int r;
 	struct dpages dp;
=20
-	r =3D dp_init(io_req, &dp);
+	r =3D dp_init(io_req, &dp, (unsigned long)where->count << SECTOR_SHIFT);
 	if (r)
 		return r;
=20
diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index aa4e570..209991b 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -807,6 +807,11 @@ static int parse_features(struct arg_set *as, struct m=
ultipath *m)
 	if (!argc)
 		return 0;
=20
+	if (argc > as->argc) {
+		ti->error =3D "not enough arguments for features";
+		return -EINVAL;
+	}
+
 	do {
 		param_name =3D shift(as);
 		argc--;
diff --git a/drivers/md/dm-snap-persistent.c b/drivers/md/dm-snap-persisten=
t.c
index 135c2f1..e4ecadf 100644
--- a/drivers/md/dm-snap-persistent.c
+++ b/drivers/md/dm-snap-persistent.c
@@ -753,7 +753,7 @@ static int persistent_commit_merge(struct dm_exception_=
store *store,
 	for (i =3D 0; i < nr_merged; i++)
 		clear_exception(ps, ps->current_committed - 1 - i);
=20
-	r =3D area_io(ps, WRITE);
+	r =3D area_io(ps, WRITE_FLUSH_FUA);
 	if (r < 0)
 		return r;
=20
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 0cf68b4..41abc6d 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -37,6 +37,8 @@ static const char *_name =3D DM_NAME;
 static unsigned int major =3D 0;
 static unsigned int _major =3D 0;
=20
+static DEFINE_IDR(_minor_idr);
+
 static DEFINE_SPINLOCK(_minor_lock);
 /*
  * For bio-based dm.
@@ -313,6 +315,12 @@ static void __exit dm_exit(void)
=20
 	while (i--)
 		_exits[i]();
+
+	/*
+	 * Should be empty by this point.
+	 */
+	idr_remove_all(&_minor_idr);
+	idr_destroy(&_minor_idr);
 }
=20
 /*
@@ -1705,8 +1713,6 @@ static int dm_any_congested(void *congested_data, int=
 bdi_bits)
 /*-----------------------------------------------------------------
  * An IDR is used to keep track of allocated minor numbers.
  *---------------------------------------------------------------*/
-static DEFINE_IDR(_minor_idr);
-
 static void free_minor(int minor)
 {
 	spin_lock(&_minor_lock);
diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 4e349cd..3546474 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -245,8 +245,7 @@ config SGI_XP
=20
 config CS5535_MFGPT
 	tristate "CS5535/CS5536 Geode Multi-Function General Purpose Timer (MFGPT=
) support"
-	depends on PCI
-	depends on X86
+	depends on PCI && X86 && MFD_CS5535
 	default n
 	help
 	  This driver provides access to MFGPT functionality for other
diff --git a/drivers/mmc/host/sdhci-esdhc-imx.c b/drivers/mmc/host/sdhci-es=
dhc-imx.c
index a19967d..ba31abe 100644
--- a/drivers/mmc/host/sdhci-esdhc-imx.c
+++ b/drivers/mmc/host/sdhci-esdhc-imx.c
@@ -74,7 +74,7 @@ static u32 esdhc_readl_le(struct sdhci_host *host, int re=
g)
 		if (boarddata && gpio_is_valid(boarddata->cd_gpio)
 				&& gpio_get_value(boarddata->cd_gpio))
 			/* no card, if a valid gpio says so... */
-			val &=3D SDHCI_CARD_PRESENT;
+			val &=3D ~SDHCI_CARD_PRESENT;
 		else
 			/* ... in all other cases assume card is present */
 			val |=3D SDHCI_CARD_PRESENT;
diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 58d5436..6d3de08 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1863,9 +1863,6 @@ static void sdhci_tasklet_finish(unsigned long param)
=20
 	del_timer(&host->timer);
=20
-	if (host->version >=3D SDHCI_SPEC_300)
-		del_timer(&host->tuning_timer);
-
 	mrq =3D host->mrq;
=20
 	/*
diff --git a/drivers/net/Makefile b/drivers/net/Makefile
index 776a478..d5ce011 100644
--- a/drivers/net/Makefile
+++ b/drivers/net/Makefile
@@ -283,6 +283,7 @@ obj-$(CONFIG_USB_HSO)		+=3D usb/
 obj-$(CONFIG_USB_USBNET)        +=3D usb/
 obj-$(CONFIG_USB_ZD1201)        +=3D usb/
 obj-$(CONFIG_USB_IPHETH)        +=3D usb/
+obj-$(CONFIG_USB_CDC_PHONET)   +=3D usb/
=20
 obj-$(CONFIG_WLAN) +=3D wireless/
 obj-$(CONFIG_NET_TULIP) +=3D tulip/
diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_mai=
n.c
index 63c22b0..9ea2f21 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1625,8 +1625,10 @@ int bond_enslave(struct net_device *bond_dev, struct=
 net_device *slave_dev)
=20
 			if (slave_dev->type !=3D ARPHRD_ETHER)
 				bond_setup_by_slave(bond_dev, slave_dev);
-			else
+			else {
 				ether_setup(bond_dev);
+				bond_dev->priv_flags &=3D ~IFF_TX_SKB_SHARING;
+			}
=20
 			netdev_bonding_change(bond_dev,
 					      NETDEV_POST_TYPE_CHANGE);
@@ -4398,7 +4400,7 @@ static void bond_setup(struct net_device *bond_dev)
 	bond_dev->tx_queue_len =3D 0;
 	bond_dev->flags |=3D IFF_MASTER|IFF_MULTICAST;
 	bond_dev->priv_flags |=3D IFF_BONDING;
-	bond_dev->priv_flags &=3D ~IFF_XMIT_DST_RELEASE;
+	bond_dev->priv_flags &=3D ~(IFF_XMIT_DST_RELEASE | IFF_TX_SKB_SHARING);
=20
 	/* At first, we block adding VLANs. That's the only way to
 	 * prevent problems that occur when adding VLANs over an
diff --git a/drivers/net/bonding/bond_sysfs.c b/drivers/net/bonding/bond_sy=
sfs.c
index 88fcb25..0624610 100644
--- a/drivers/net/bonding/bond_sysfs.c
+++ b/drivers/net/bonding/bond_sysfs.c
@@ -992,6 +992,7 @@ static ssize_t bonding_store_primary(struct device *d,
 	int i;
 	struct slave *slave;
 	struct bonding *bond =3D to_bond(d);
+	char ifname[IFNAMSIZ];
=20
 	if (!rtnl_trylock())
 		return restart_syscall();
@@ -1002,32 +1003,33 @@ static ssize_t bonding_store_primary(struct device =
*d,
 	if (!USES_PRIMARY(bond->params.mode)) {
 		pr_info("%s: Unable to set primary slave; %s is in mode %d\n",
 			bond->dev->name, bond->dev->name, bond->params.mode);
-	} else {
-		bond_for_each_slave(bond, slave, i) {
-			if (strnicmp
-			    (slave->dev->name, buf,
-			     strlen(slave->dev->name)) =3D=3D 0) {
-				pr_info("%s: Setting %s as primary slave.\n",
-					bond->dev->name, slave->dev->name);
-				bond->primary_slave =3D slave;
-				strcpy(bond->params.primary, slave->dev->name);
-				bond_select_active_slave(bond);
-				goto out;
-			}
-		}
+		goto out;
+	}
=20
-		/* if we got here, then we didn't match the name of any slave */
+	sscanf(buf, "%16s", ifname); /* IFNAMSIZ */
=20
-		if (strlen(buf) =3D=3D 0 || buf[0] =3D=3D '\n') {
-			pr_info("%s: Setting primary slave to None.\n",
-				bond->dev->name);
-			bond->primary_slave =3D NULL;
-				bond_select_active_slave(bond);
-		} else {
-			pr_info("%s: Unable to set %.*s as primary slave as it is not a slave.\=
n",
-				bond->dev->name, (int)strlen(buf) - 1, buf);
+	/* check to see if we are clearing primary */
+	if (!strlen(ifname) || buf[0] =3D=3D '\n') {
+		pr_info("%s: Setting primary slave to None.\n",
+			bond->dev->name);
+		bond->primary_slave =3D NULL;
+		bond_select_active_slave(bond);
+		goto out;
+	}
+
+	bond_for_each_slave(bond, slave, i) {
+		if (strncmp(slave->dev->name, ifname, IFNAMSIZ) =3D=3D 0) {
+			pr_info("%s: Setting %s as primary slave.\n",
+				bond->dev->name, slave->dev->name);
+			bond->primary_slave =3D slave;
+			strcpy(bond->params.primary, slave->dev->name);
+			bond_select_active_slave(bond);
+			goto out;
 		}
 	}
+
+	pr_info("%s: Unable to set %.*s as primary slave.\n",
+		bond->dev->name, (int)strlen(buf) - 1, buf);
 out:
 	write_unlock_bh(&bond->curr_slave_lock);
 	read_unlock(&bond->lock);
@@ -1162,6 +1164,7 @@ static ssize_t bonding_store_active_slave(struct devi=
ce *d,
 	struct slave *old_active =3D NULL;
 	struct slave *new_active =3D NULL;
 	struct bonding *bond =3D to_bond(d);
+	char ifname[IFNAMSIZ];
=20
 	if (!rtnl_trylock())
 		return restart_syscall();
@@ -1170,56 +1173,62 @@ static ssize_t bonding_store_active_slave(struct de=
vice *d,
 	read_lock(&bond->lock);
 	write_lock_bh(&bond->curr_slave_lock);
=20
-	if (!USES_PRIMARY(bond->params.mode))
+	if (!USES_PRIMARY(bond->params.mode)) {
 		pr_info("%s: Unable to change active slave; %s is in mode %d\n",
 			bond->dev->name, bond->dev->name, bond->params.mode);
-	else {
-		bond_for_each_slave(bond, slave, i) {
-			if (strnicmp
-			    (slave->dev->name, buf,
-			     strlen(slave->dev->name)) =3D=3D 0) {
-        			old_active =3D bond->curr_active_slave;
-        			new_active =3D slave;
-        			if (new_active =3D=3D old_active) {
-					/* do nothing */
-					pr_info("%s: %s is already the current active slave.\n",
+		goto out;
+	}
+
+	sscanf(buf, "%16s", ifname); /* IFNAMSIZ */
+
+	/* check to see if we are clearing active */
+	if (!strlen(ifname) || buf[0] =3D=3D '\n') {
+		pr_info("%s: Clearing current active slave.\n",
+			bond->dev->name);
+		bond->curr_active_slave =3D NULL;
+		bond_select_active_slave(bond);
+		goto out;
+	}
+
+	bond_for_each_slave(bond, slave, i) {
+		if (strncmp(slave->dev->name, ifname, IFNAMSIZ) =3D=3D 0) {
+			old_active =3D bond->curr_active_slave;
+			new_active =3D slave;
+			if (new_active =3D=3D old_active) {
+				/* do nothing */
+				pr_info("%s: %s is already the current"
+					" active slave.\n",
+					bond->dev->name,
+					slave->dev->name);
+				goto out;
+			}
+			else {
+				if ((new_active) &&
+				    (old_active) &&
+				    (new_active->link =3D=3D BOND_LINK_UP) &&
+				    IS_UP(new_active->dev)) {
+					pr_info("%s: Setting %s as active"
+						" slave.\n",
 						bond->dev->name,
 						slave->dev->name);
-					goto out;
+					bond_change_active_slave(bond,
+								 new_active);
 				}
 				else {
-        				if ((new_active) &&
-            				    (old_active) &&
-				            (new_active->link =3D=3D BOND_LINK_UP) &&
-				            IS_UP(new_active->dev)) {
-						pr_info("%s: Setting %s as active slave.\n",
-							bond->dev->name,
-							slave->dev->name);
-							bond_change_active_slave(bond, new_active);
-        				}
-					else {
-						pr_info("%s: Could not set %s as active slave; either %s is down or =
the link is down.\n",
-							bond->dev->name,
-							slave->dev->name,
-							slave->dev->name);
-					}
-					goto out;
+					pr_info("%s: Could not set %s as"
+						" active slave; either %s is"
+						" down or the link is down.\n",
+						bond->dev->name,
+						slave->dev->name,
+						slave->dev->name);
 				}
+				goto out;
 			}
 		}
-
-		/* if we got here, then we didn't match the name of any slave */
-
-		if (strlen(buf) =3D=3D 0 || buf[0] =3D=3D '\n') {
-			pr_info("%s: Setting active slave to None.\n",
-				bond->dev->name);
-			bond->primary_slave =3D NULL;
-			bond_select_active_slave(bond);
-		} else {
-			pr_info("%s: Unable to set %.*s as active slave as it is not a slave.\n=
",
-				bond->dev->name, (int)strlen(buf) - 1, buf);
-		}
 	}
+
+	pr_info("%s: Unable to set %.*s as active slave.\n",
+		bond->dev->name, (int)strlen(buf) - 1, buf);
  out:
 	write_unlock_bh(&bond->curr_slave_lock);
 	read_unlock(&bond->lock);
diff --git a/drivers/net/e1000e/lib.c b/drivers/net/e1000e/lib.c
index dd8ab05..8d28602 100644
--- a/drivers/net/e1000e/lib.c
+++ b/drivers/net/e1000e/lib.c
@@ -190,7 +190,8 @@ s32 e1000_check_alt_mac_addr_generic(struct e1000_hw *h=
w)
 	/* Check for LOM (vs. NIC) or one of two valid mezzanine cards */
 	if (!((nvm_data & NVM_COMPAT_LOM) ||
 	      (hw->adapter->pdev->device =3D=3D E1000_DEV_ID_82571EB_SERDES_DUAL)=
 ||
-	      (hw->adapter->pdev->device =3D=3D E1000_DEV_ID_82571EB_SERDES_QUAD)=
))
+	      (hw->adapter->pdev->device =3D=3D E1000_DEV_ID_82571EB_SERDES_QUAD)=
 ||
+	      (hw->adapter->pdev->device =3D=3D E1000_DEV_ID_82571EB_SERDES)))
 		goto out;
=20
 	ret_val =3D e1000_read_nvm(hw, NVM_ALT_MAC_ADDR_PTR, 1,
diff --git a/drivers/net/gianfar_ptp.c b/drivers/net/gianfar_ptp.c
index d8e1753..c413479 100644
--- a/drivers/net/gianfar_ptp.c
+++ b/drivers/net/gianfar_ptp.c
@@ -193,14 +193,9 @@ static void set_alarm(struct etsects *etsects)
 /* Caller must hold etsects->lock. */
 static void set_fipers(struct etsects *etsects)
 {
-	u32 tmr_ctrl =3D gfar_read(&etsects->regs->tmr_ctrl);
-
-	gfar_write(&etsects->regs->tmr_ctrl,   tmr_ctrl & (~TE));
-	gfar_write(&etsects->regs->tmr_prsc,   etsects->tmr_prsc);
+	set_alarm(etsects);
 	gfar_write(&etsects->regs->tmr_fiper1, etsects->tmr_fiper1);
 	gfar_write(&etsects->regs->tmr_fiper2, etsects->tmr_fiper2);
-	set_alarm(etsects);
-	gfar_write(&etsects->regs->tmr_ctrl,   tmr_ctrl|TE);
 }
=20
 /*
@@ -511,7 +506,7 @@ static int gianfar_ptp_probe(struct platform_device *de=
v)
 	gfar_write(&etsects->regs->tmr_fiper1, etsects->tmr_fiper1);
 	gfar_write(&etsects->regs->tmr_fiper2, etsects->tmr_fiper2);
 	set_alarm(etsects);
-	gfar_write(&etsects->regs->tmr_ctrl,   tmr_ctrl|FS|RTPE|TE);
+	gfar_write(&etsects->regs->tmr_ctrl,   tmr_ctrl|FS|RTPE|TE|FRD);
=20
 	spin_unlock_irqrestore(&etsects->lock, flags);
=20
diff --git a/drivers/net/ifb.c b/drivers/net/ifb.c
index 4fecaed..2b98461 100644
--- a/drivers/net/ifb.c
+++ b/drivers/net/ifb.c
@@ -145,7 +145,7 @@ static void ifb_setup(struct net_device *dev)
=20
 	dev->flags |=3D IFF_NOARP;
 	dev->flags &=3D ~IFF_MULTICAST;
-	dev->priv_flags &=3D ~IFF_XMIT_DST_RELEASE;
+	dev->priv_flags &=3D ~(IFF_XMIT_DST_RELEASE | IFF_TX_SKB_SHARING);
 	random_ether_addr(dev->dev_addr);
 }
=20
diff --git a/drivers/net/igb/e1000_82575.c b/drivers/net/igb/e1000_82575.c
index 0f563c8..493e331 100644
--- a/drivers/net/igb/e1000_82575.c
+++ b/drivers/net/igb/e1000_82575.c
@@ -1735,6 +1735,7 @@ static s32 igb_reset_hw_82580(struct e1000_hw *hw)
 		ctrl |=3D E1000_CTRL_RST;
=20
 	wr32(E1000_CTRL, ctrl);
+	wrfl();
=20
 	/* Add delay to insure DEV_RST has time to complete */
 	if (global_device_reset)
diff --git a/drivers/net/jme.c b/drivers/net/jme.c
index b5b174a..1973814 100644
--- a/drivers/net/jme.c
+++ b/drivers/net/jme.c
@@ -753,20 +753,28 @@ jme_make_new_rx_buf(struct jme_adapter *jme, int i)
 	struct jme_ring *rxring =3D &(jme->rxring[0]);
 	struct jme_buffer_info *rxbi =3D rxring->bufinf + i;
 	struct sk_buff *skb;
+	dma_addr_t mapping;
=20
 	skb =3D netdev_alloc_skb(jme->dev,
 		jme->dev->mtu + RX_EXTRA_LEN);
 	if (unlikely(!skb))
 		return -ENOMEM;
=20
+	mapping =3D pci_map_page(jme->pdev, virt_to_page(skb->data),
+			       offset_in_page(skb->data), skb_tailroom(skb),
+			       PCI_DMA_FROMDEVICE);
+	if (unlikely(pci_dma_mapping_error(jme->pdev, mapping))) {
+		dev_kfree_skb(skb);
+		return -ENOMEM;
+	}
+
+	if (likely(rxbi->mapping))
+		pci_unmap_page(jme->pdev, rxbi->mapping,
+			       rxbi->len, PCI_DMA_FROMDEVICE);
+
 	rxbi->skb =3D skb;
 	rxbi->len =3D skb_tailroom(skb);
-	rxbi->mapping =3D pci_map_page(jme->pdev,
-					virt_to_page(skb->data),
-					offset_in_page(skb->data),
-					rxbi->len,
-					PCI_DMA_FROMDEVICE);
-
+	rxbi->mapping =3D mapping;
 	return 0;
 }
=20
diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index d6aeaa5..2f3c48d 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -547,7 +547,7 @@ void macvlan_common_setup(struct net_device *dev)
 {
 	ether_setup(dev);
=20
-	dev->priv_flags	       &=3D ~IFF_XMIT_DST_RELEASE;
+	dev->priv_flags	       &=3D ~(IFF_XMIT_DST_RELEASE | IFF_TX_SKB_SHARING);
 	dev->netdev_ops		=3D &macvlan_netdev_ops;
 	dev->destructor		=3D free_netdev;
 	dev->header_ops		=3D &macvlan_hard_header_ops,
diff --git a/drivers/net/niu.c b/drivers/net/niu.c
index cc25bff..2f8c351 100644
--- a/drivers/net/niu.c
+++ b/drivers/net/niu.c
@@ -9196,7 +9196,7 @@ static int __devinit niu_ldg_init(struct niu *np)
=20
 	first_chan =3D 0;
 	for (i =3D 0; i < port; i++)
-		first_chan +=3D parent->rxchan_per_port[port];
+		first_chan +=3D parent->rxchan_per_port[i];
 	num_chan =3D parent->rxchan_per_port[port];
=20
 	for (i =3D first_chan; i < (first_chan + num_chan); i++) {
@@ -9212,7 +9212,7 @@ static int __devinit niu_ldg_init(struct niu *np)
=20
 	first_chan =3D 0;
 	for (i =3D 0; i < port; i++)
-		first_chan +=3D parent->txchan_per_port[port];
+		first_chan +=3D parent->txchan_per_port[i];
 	num_chan =3D parent->txchan_per_port[port];
 	for (i =3D first_chan; i < (first_chan + num_chan); i++) {
 		err =3D niu_ldg_assign_ldn(np, parent,
diff --git a/drivers/net/phy/dp83640.c b/drivers/net/phy/dp83640.c
index 2cd8dc5..cb6e0b4 100644
--- a/drivers/net/phy/dp83640.c
+++ b/drivers/net/phy/dp83640.c
@@ -34,8 +34,7 @@
 #define PAGESEL		0x13
 #define LAYER4		0x02
 #define LAYER2		0x01
-#define MAX_RXTS	4
-#define MAX_TXTS	4
+#define MAX_RXTS	64
 #define N_EXT_TS	1
 #define PSF_PTPVER	2
 #define PSF_EVNT	0x4000
@@ -218,7 +217,7 @@ static void phy2rxts(struct phy_rxts *p, struct rxts *r=
xts)
 	rxts->seqid =3D p->seqid;
 	rxts->msgtype =3D (p->msgtype >> 12) & 0xf;
 	rxts->hash =3D p->msgtype & 0x0fff;
-	rxts->tmo =3D jiffies + HZ;
+	rxts->tmo =3D jiffies + 2;
 }
=20
 static u64 phy2txts(struct phy_txts *p)
diff --git a/drivers/net/r8169.c b/drivers/net/r8169.c
index 5990621..5f838ef 100644
--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -236,6 +236,7 @@ static DEFINE_PCI_DEVICE_TABLE(rtl8169_pci_tbl) =3D {
 	{ PCI_DEVICE(PCI_VENDOR_ID_REALTEK,	0x8168), 0, 0, RTL_CFG_1 },
 	{ PCI_DEVICE(PCI_VENDOR_ID_REALTEK,	0x8169), 0, 0, RTL_CFG_0 },
 	{ PCI_DEVICE(PCI_VENDOR_ID_DLINK,	0x4300), 0, 0, RTL_CFG_0 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_DLINK,	0x4302), 0, 0, RTL_CFG_0 },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AT,		0xc107), 0, 0, RTL_CFG_0 },
 	{ PCI_DEVICE(0x16ec,			0x0116), 0, 0, RTL_CFG_0 },
 	{ PCI_VENDOR_ID_LINKSYS,		0x1032,
diff --git a/drivers/net/sis190.c b/drivers/net/sis190.c
index b436e00..f6d26ab 100644
--- a/drivers/net/sis190.c
+++ b/drivers/net/sis190.c
@@ -1824,6 +1824,16 @@ static int sis190_ioctl(struct net_device *dev, stru=
ct ifreq *ifr, int cmd)
 		generic_mii_ioctl(&tp->mii_if, if_mii(ifr), cmd, NULL);
 }
=20
+static int sis190_mac_addr(struct net_device  *dev, void *p)
+{
+	int rc;
+
+	rc =3D eth_mac_addr(dev, p);
+	if (!rc)
+		sis190_init_rxfilter(dev);
+	return rc;
+}
+
 static const struct net_device_ops sis190_netdev_ops =3D {
 	.ndo_open		=3D sis190_open,
 	.ndo_stop		=3D sis190_close,
@@ -1832,7 +1842,7 @@ static const struct net_device_ops sis190_netdev_ops =
=3D {
 	.ndo_tx_timeout		=3D sis190_tx_timeout,
 	.ndo_set_multicast_list =3D sis190_set_rx_mode,
 	.ndo_change_mtu		=3D eth_change_mtu,
-	.ndo_set_mac_address 	=3D eth_mac_addr,
+	.ndo_set_mac_address	=3D sis190_mac_addr,
 	.ndo_validate_addr	=3D eth_validate_addr,
 #ifdef CONFIG_NET_POLL_CONTROLLER
 	.ndo_poll_controller	 =3D sis190_netpoll,
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 5235f48..fb50e5a 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -528,6 +528,7 @@ static void tun_net_init(struct net_device *dev)
 		dev->netdev_ops =3D &tap_netdev_ops;
 		/* Ethernet TAP Device */
 		ether_setup(dev);
+		dev->priv_flags &=3D ~IFF_TX_SKB_SHARING;
=20
 		random_ether_addr(dev->dev_addr);
=20
diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 8461576..4bf7c6d 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -262,6 +262,8 @@ static void veth_setup(struct net_device *dev)
 {
 	ether_setup(dev);
=20
+	dev->priv_flags &=3D ~IFF_TX_SKB_SHARING;
+
 	dev->netdev_ops =3D &veth_netdev_ops;
 	dev->ethtool_ops =3D &veth_ethtool_ops;
 	dev->features |=3D NETIF_F_LLTX;
diff --git a/drivers/net/wan/hdlc_fr.c b/drivers/net/wan/hdlc_fr.c
index fc433f2..13f9997 100644
--- a/drivers/net/wan/hdlc_fr.c
+++ b/drivers/net/wan/hdlc_fr.c
@@ -1083,9 +1083,10 @@ static int fr_add_pvc(struct net_device *frad, unsig=
ned int dlci, int type)
=20
 	used =3D pvc_is_used(pvc);
=20
-	if (type =3D=3D ARPHRD_ETHER)
+	if (type =3D=3D ARPHRD_ETHER) {
 		dev =3D alloc_netdev(0, "pvceth%d", ether_setup);
-	else
+		dev->priv_flags &=3D ~IFF_TX_SKB_SHARING;
+	} else
 		dev =3D alloc_netdev(0, "pvc%d", pvc_setup);
=20
 	if (!dev) {
diff --git a/drivers/net/wireless/airo.c b/drivers/net/wireless/airo.c
index 55cf71f..e1b3e3c 100644
--- a/drivers/net/wireless/airo.c
+++ b/drivers/net/wireless/airo.c
@@ -2823,6 +2823,7 @@ static struct net_device *_init_airo_card( unsigned s=
hort irq, int port,
 	dev->wireless_data =3D &ai->wireless_data;
 	dev->irq =3D irq;
 	dev->base_addr =3D port;
+	dev->priv_flags &=3D ~IFF_TX_SKB_SHARING;
=20
 	SET_NETDEV_DEV(dev, dmdev);
=20
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/a=
th/ath5k/base.c
index b6c5d37..1ae8913 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -1748,6 +1748,8 @@ ath5k_beacon_setup(struct ath5k_softc *sc, struct ath=
5k_buf *bf)
=20
 	if (dma_mapping_error(sc->dev, bf->skbaddr)) {
 		ATH5K_ERR(sc, "beacon DMA mapping failed\n");
+		dev_kfree_skb_any(skb);
+		bf->skb =3D NULL;
 		return -EIO;
 	}
=20
@@ -1832,8 +1834,6 @@ ath5k_beacon_update(struct ieee80211_hw *hw, struct i=
eee80211_vif *vif)
 	ath5k_txbuf_free_skb(sc, avf->bbuf);
 	avf->bbuf->skb =3D skb;
 	ret =3D ath5k_beacon_setup(sc, avf->bbuf);
-	if (ret)
-		avf->bbuf->skb =3D NULL;
 out:
 	return ret;
 }
@@ -1854,6 +1854,7 @@ ath5k_beacon_send(struct ath5k_softc *sc)
 	struct ath5k_vif *avf;
 	struct ath5k_buf *bf;
 	struct sk_buff *skb;
+	int err;
=20
 	ATH5K_DBG_UNLIMIT(sc, ATH5K_DEBUG_BEACON, "in beacon_send\n");
=20
@@ -1902,11 +1903,6 @@ ath5k_beacon_send(struct ath5k_softc *sc)
=20
 	avf =3D (void *)vif->drv_priv;
 	bf =3D avf->bbuf;
-	if (unlikely(bf->skb =3D=3D NULL || sc->opmode =3D=3D NL80211_IFTYPE_STAT=
ION ||
-			sc->opmode =3D=3D NL80211_IFTYPE_MONITOR)) {
-		ATH5K_WARN(sc, "bf=3D%p bf_skb=3D%p\n", bf, bf ? bf->skb : NULL);
-		return;
-	}
=20
 	/*
 	 * Stop any current dma and put the new frame on the queue.
@@ -1920,8 +1916,17 @@ ath5k_beacon_send(struct ath5k_softc *sc)
=20
 	/* refresh the beacon for AP or MESH mode */
 	if (sc->opmode =3D=3D NL80211_IFTYPE_AP ||
-			sc->opmode =3D=3D NL80211_IFTYPE_MESH_POINT)
-		ath5k_beacon_update(sc->hw, vif);
+			sc->opmode =3D=3D NL80211_IFTYPE_MESH_POINT) {
+		err =3D ath5k_beacon_update(sc->hw, vif);
+		if (err)
+			return;
+	}
+
+	if (unlikely(bf->skb =3D=3D NULL || sc->opmode =3D=3D NL80211_IFTYPE_STAT=
ION ||
+			sc->opmode =3D=3D NL80211_IFTYPE_MONITOR)) {
+		ATH5K_WARN(sc, "bf=3D%p bf_skb=3D%p\n", bf, bf->skb);
+		return;
+	}
=20
 	trace_ath5k_tx(sc, bf->skb, &sc->txqs[sc->bhalq]);
=20
diff --git a/drivers/net/wireless/ath/ath9k/ar9002_hw.c b/drivers/net/wirel=
ess/ath/ath9k/ar9002_hw.c
index f344cc2..c32f9d1 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
@@ -309,11 +309,7 @@ static void ar9002_hw_configpcipowersave(struct ath_hw=
 *ah,
 	u8 i;
 	u32 val;
=20
-	if (ah->is_pciexpress !=3D true)
-		return;
-
-	/* Do not touch SerDes registers */
-	if (ah->config.pcie_powersave_enable =3D=3D 2)
+	if (ah->is_pciexpress !=3D true || ah->aspm_enabled !=3D true)
 		return;
=20
 	/* Nothing to do on restore for 11N */
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/w=
ireless/ath/ath9k/ar9003_eeprom.c
index ff8150e..7e07f0f 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -306,7 +306,7 @@ static const struct ar9300_eeprom ar9300_default =3D {
 		 { { CTL(60, 0), CTL(60, 1), CTL(60, 0), CTL(60, 0) } },
 		 { { CTL(60, 1), CTL(60, 0), CTL(60, 0), CTL(60, 1) } },
=20
-		 { { CTL(60, 1), CTL(60, 0), CTL(0, 0), CTL(0, 0) } },
+		 { { CTL(60, 1), CTL(60, 0), CTL(60, 0), CTL(60, 0) } },
 		 { { CTL(60, 0), CTL(60, 1), CTL(60, 0), CTL(60, 0) } },
 		 { { CTL(60, 0), CTL(60, 1), CTL(60, 0), CTL(60, 0) } },
=20
@@ -883,7 +883,7 @@ static const struct ar9300_eeprom ar9300_x113 =3D {
 		 { { CTL(60, 0), CTL(60, 1), CTL(60, 0), CTL(60, 0) } },
 		 { { CTL(60, 1), CTL(60, 0), CTL(60, 0), CTL(60, 1) } },
=20
-		 { { CTL(60, 1), CTL(60, 0), CTL(0, 0), CTL(0, 0) } },
+		 { { CTL(60, 1), CTL(60, 0), CTL(60, 0), CTL(60, 0) } },
 		 { { CTL(60, 0), CTL(60, 1), CTL(60, 0), CTL(60, 0) } },
 		 { { CTL(60, 0), CTL(60, 1), CTL(60, 0), CTL(60, 0) } },
=20
@@ -2039,7 +2039,7 @@ static const struct ar9300_eeprom ar9300_x112 =3D {
 		{ { CTL(60, 0), CTL(60, 1), CTL(60, 0), CTL(60, 0) } },
 		{ { CTL(60, 1), CTL(60, 0), CTL(60, 0), CTL(60, 1) } },
=20
-		{ { CTL(60, 1), CTL(60, 0), CTL(0, 0), CTL(0, 0) } },
+		{ { CTL(60, 1), CTL(60, 0), CTL(60, 0), CTL(60, 0) } },
 		{ { CTL(60, 0), CTL(60, 1), CTL(60, 0), CTL(60, 0) } },
 		{ { CTL(60, 0), CTL(60, 1), CTL(60, 0), CTL(60, 0) } },
=20
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_hw.c b/drivers/net/wirel=
ess/ath/ath9k/ar9003_hw.c
index 392bf0f..7e02fb4 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
@@ -351,11 +351,7 @@ static void ar9003_hw_configpcipowersave(struct ath_hw=
 *ah,
 					 int restore,
 					 int power_off)
 {
-	if (ah->is_pciexpress !=3D true)
-		return;
-
-	/* Do not touch SerDes registers */
-	if (ah->config.pcie_powersave_enable =3D=3D 2)
+	if (ah->is_pciexpress !=3D true || ah->aspm_enabled !=3D true)
 		return;
=20
 	/* Nothing to do on restore for 11N */
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mac.c b/drivers/net/wire=
less/ath/ath9k/ar9003_mac.c
index 10d71f7..1f99249 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
@@ -629,8 +629,7 @@ int ath9k_hw_process_rxdesc_edma(struct ath_hw *ah, str=
uct ath_rx_status *rxs,
 			rxs->rs_status |=3D ATH9K_RXERR_DECRYPT;
 		else if (rxsp->status11 & AR_MichaelErr)
 			rxs->rs_status |=3D ATH9K_RXERR_MIC;
-
-		if (rxsp->status11 & AR_KeyMiss)
+		else if (rxsp->status11 & AR_KeyMiss)
 			rxs->rs_status |=3D ATH9K_RXERR_DECRYPT;
 	}
=20
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.h b/drivers/net/wire=
less/ath/ath9k/ar9003_phy.h
index 443090d..efdbe98 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
@@ -848,7 +848,7 @@
 #define AR_PHY_TPC_11_B1         (AR_SM1_BASE + 0x220)
 #define AR_PHY_PDADC_TAB_1       (AR_SM1_BASE + 0x240)
 #define AR_PHY_TX_IQCAL_STATUS_B1   (AR_SM1_BASE + 0x48c)
-#define AR_PHY_TX_IQCAL_CORR_COEFF_B1(_i)    (AR_SM_BASE + 0x450 + ((_i) <=
< 2))
+#define AR_PHY_TX_IQCAL_CORR_COEFF_B1(_i)    (AR_SM1_BASE + 0x450 + ((_i) =
<< 2))
=20
 /*
  * Channel 2 Register Map
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath=
/ath9k/hw.c
index 1be7c8b..03900ca 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -299,6 +299,14 @@ static void ath9k_hw_disablepcie(struct ath_hw *ah)
 	REG_WRITE(ah, AR_PCIE_SERDES2, 0x00000000);
 }
=20
+static void ath9k_hw_aspm_init(struct ath_hw *ah)
+{
+	struct ath_common *common =3D ath9k_hw_common(ah);
+
+	if (common->bus_ops->aspm_init)
+		common->bus_ops->aspm_init(common);
+}
+
 /* This should work for all families including legacy */
 static bool ath9k_hw_chip_test(struct ath_hw *ah)
 {
@@ -359,7 +367,6 @@ static void ath9k_hw_init_config(struct ath_hw *ah)
 	ah->config.additional_swba_backoff =3D 0;
 	ah->config.ack_6mb =3D 0x0;
 	ah->config.cwm_ignore_extcca =3D 0;
-	ah->config.pcie_powersave_enable =3D 0;
 	ah->config.pcie_clock_req =3D 0;
 	ah->config.pcie_waen =3D 0;
 	ah->config.analog_shiftreg =3D 1;
@@ -577,7 +584,7 @@ static int __ath9k_hw_init(struct ath_hw *ah)
=20
=20
 	if (ah->is_pciexpress)
-		ath9k_hw_configpcipowersave(ah, 0, 0);
+		ath9k_hw_aspm_init(ah);
 	else
 		ath9k_hw_disablepcie(ah);
=20
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath=
/ath9k/hw.h
index 4b157c5..939cc9d 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -215,7 +215,6 @@ struct ath9k_ops_config {
 	int additional_swba_backoff;
 	int ack_6mb;
 	u32 cwm_ignore_extcca;
-	u8 pcie_powersave_enable;
 	bool pcieSerDesWrite;
 	u8 pcie_clock_req;
 	u32 pcie_waen;
@@ -671,6 +670,7 @@ struct ath_hw {
=20
 	bool sw_mgmt_crypto;
 	bool is_pciexpress;
+	bool aspm_enabled;
 	bool is_monitoring;
 	bool need_an_top2_fixup;
 	u16 tx_trig_level;
@@ -870,6 +870,7 @@ struct ath_bus_ops {
 	bool (*eeprom_read)(struct ath_common *common, u32 off, u16 *data);
 	void (*bt_coex_prep)(struct ath_common *common);
 	void (*extn_synch_en)(struct ath_common *common);
+	void (*aspm_init)(struct ath_common *common);
 };
=20
 static inline struct ath_common *ath9k_hw_common(struct ath_hw *ah)
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/a=
th/ath9k/init.c
index 45c585a..5a9fd21 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -665,8 +665,10 @@ static void ath9k_init_band_txpower(struct ath_softc *=
sc, int band)
 static void ath9k_init_txpower_limits(struct ath_softc *sc)
 {
 	struct ath_hw *ah =3D sc->sc_ah;
+	struct ath_common *common =3D ath9k_hw_common(sc->sc_ah);
 	struct ath9k_channel *curchan =3D ah->curchan;
=20
+	ah->txchainmask =3D common->tx_chainmask;
 	if (ah->caps.hw_caps & ATH9K_HW_CAP_2GHZ)
 		ath9k_init_band_txpower(sc, IEEE80211_BAND_2GHZ);
 	if (ah->caps.hw_caps & ATH9K_HW_CAP_5GHZ)
diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/at=
h/ath9k/mac.c
index c2091f1..b6b523a 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -645,8 +645,7 @@ int ath9k_hw_rxprocdesc(struct ath_hw *ah, struct ath_d=
esc *ds,
 			rs->rs_status |=3D ATH9K_RXERR_DECRYPT;
 		else if (ads.ds_rxstatus8 & AR_MichaelErr)
 			rs->rs_status |=3D ATH9K_RXERR_MIC;
-
-		if (ads.ds_rxstatus8 & AR_KeyMiss)
+		else if (ads.ds_rxstatus8 & AR_KeyMiss)
 			rs->rs_status |=3D ATH9K_RXERR_DECRYPT;
 	}
=20
diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/at=
h/ath9k/pci.c
index 3bad0b2..be4ea13 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -16,6 +16,7 @@
=20
 #include <linux/nl80211.h>
 #include <linux/pci.h>
+#include <linux/pci-aspm.h>
 #include <linux/ath9k_platform.h>
 #include "ath9k.h"
=20
@@ -115,12 +116,38 @@ static void ath_pci_extn_synch_enable(struct ath_comm=
on *common)
 	pci_write_config_byte(pdev, sc->sc_ah->caps.pcie_lcr_offset, lnkctl);
 }
=20
+static void ath_pci_aspm_init(struct ath_common *common)
+{
+	struct ath_softc *sc =3D (struct ath_softc *) common->priv;
+	struct ath_hw *ah =3D sc->sc_ah;
+	struct pci_dev *pdev =3D to_pci_dev(sc->dev);
+	struct pci_dev *parent;
+	int pos;
+	u8 aspm;
+
+	if (!pci_is_pcie(pdev))
+		return;
+
+	parent =3D pdev->bus->self;
+	if (WARN_ON(!parent))
+		return;
+
+	pos =3D pci_pcie_cap(parent);
+	pci_read_config_byte(parent, pos +  PCI_EXP_LNKCTL, &aspm);
+	if (aspm & (PCIE_LINK_STATE_L0S | PCIE_LINK_STATE_L1)) {
+		ah->aspm_enabled =3D true;
+		/* Initialize PCIe PM and SERDES registers. */
+		ath9k_hw_configpcipowersave(ah, 0, 0);
+	}
+}
+
 static const struct ath_bus_ops ath_pci_bus_ops =3D {
 	.ath_bus_type =3D ATH_PCI,
 	.read_cachesize =3D ath_pci_read_cachesize,
 	.eeprom_read =3D ath_pci_eeprom_read,
 	.bt_coex_prep =3D ath_pci_bt_coex_prep,
 	.extn_synch_en =3D ath_pci_extn_synch_enable,
+	.aspm_init =3D ath_pci_aspm_init,
 };
=20
 static int ath_pci_probe(struct pci_dev *pdev, const struct pci_device_id =
*id)
diff --git a/drivers/net/wireless/hostap/hostap_main.c b/drivers/net/wirele=
ss/hostap/hostap_main.c
index d508482..89a116f 100644
--- a/drivers/net/wireless/hostap/hostap_main.c
+++ b/drivers/net/wireless/hostap/hostap_main.c
@@ -855,6 +855,7 @@ void hostap_setup_dev(struct net_device *dev, local_inf=
o_t *local,
=20
 	iface =3D netdev_priv(dev);
 	ether_setup(dev);
+	dev->priv_flags &=3D ~IFF_TX_SKB_SHARING;
=20
 	/* kernel callbacks */
 	if (iface) {
diff --git a/drivers/net/wireless/iwlegacy/iwl-3945.c b/drivers/net/wireles=
s/iwlegacy/iwl-3945.c
index d096dc2..dcc1552 100644
--- a/drivers/net/wireless/iwlegacy/iwl-3945.c
+++ b/drivers/net/wireless/iwlegacy/iwl-3945.c
@@ -1747,7 +1747,11 @@ int iwl3945_commit_rxon(struct iwl_priv *priv, struc=
t iwl_rxon_context *ctx)
 		}
=20
 		memcpy(active_rxon, staging_rxon, sizeof(*active_rxon));
-
+		/*
+		 * We do not commit tx power settings while channel changing,
+		 * do it now if tx power changed.
+		 */
+		iwl_legacy_set_tx_power(priv, priv->tx_power_next, false);
 		return 0;
 	}
=20
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965.c b/drivers/net/wireles=
s/iwlegacy/iwl-4965.c
index facc94e..0a1babb 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965.c
@@ -1237,7 +1237,12 @@ static int iwl4965_commit_rxon(struct iwl_priv *priv=
, struct iwl_rxon_context *c
=20
 		memcpy(active_rxon, &ctx->staging, sizeof(*active_rxon));
 		iwl_legacy_print_rx_config_cmd(priv, ctx);
-		goto set_tx_power;
+		/*
+		 * We do not commit tx power settings while channel changing,
+		 * do it now if tx power changed.
+		 */
+		iwl_legacy_set_tx_power(priv, priv->tx_power_next, false);
+		return 0;
 	}
=20
 	/* If we are currently associated and the new config requires
@@ -1317,7 +1322,6 @@ static int iwl4965_commit_rxon(struct iwl_priv *priv,=
 struct iwl_rxon_context *c
=20
 	iwl4965_init_sensitivity(priv);
=20
-set_tx_power:
 	/* If we issue a new RXON command which required a tune then we must
 	 * send a new TXPOWER command or we won't be able to Tx any frames */
 	ret =3D iwl_legacy_set_tx_power(priv, priv->tx_power_next, true);
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless=
/iwlwifi/iwl-5000.c
index e816c27..f1c3f49 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -421,6 +421,7 @@ static struct iwl_base_params iwl5000_base_params =3D {
 	.chain_noise_scale =3D 1000,
 	.wd_timeout =3D IWL_LONG_WD_TIMEOUT,
 	.max_event_log_size =3D 512,
+	.no_idle_support =3D true,
 };
 static struct iwl_ht_params iwl5000_ht_params =3D {
 	.ht_greenfield_support =3D true,
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless=
/iwlwifi/iwl-core.h
index a54d416..b76996a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -195,6 +195,7 @@ struct iwl_mod_params {
  * @temperature_kelvin: temperature report by uCode in kelvin
  * @max_event_log_size: size of event log buffer size for ucode event logg=
ing
  * @shadow_reg_enable: HW shadhow register bit
+ * @no_idle_support: do not support idle mode
  */
 struct iwl_base_params {
 	int eeprom_size;
@@ -216,6 +217,7 @@ struct iwl_base_params {
 	bool temperature_kelvin;
 	u32 max_event_log_size;
 	const bool shadow_reg_enable;
+	const bool no_idle_support;
 };
 /*
  * @advanced_bt_coexist: support advanced bt coexist
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.c b/drivers/net/wireles=
s/iwlwifi/iwl-power.c
index 595c930..4a05a6a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.c
+++ b/drivers/net/wireless/iwlwifi/iwl-power.c
@@ -355,7 +355,8 @@ static void iwl_power_build_cmd(struct iwl_priv *priv,
=20
 	dtimper =3D priv->hw->conf.ps_dtim_period ?: 1;
=20
-	if (priv->hw->conf.flags & IEEE80211_CONF_IDLE)
+	if (!priv->cfg->base_params->no_idle_support &&
+		 priv->hw->conf.flags & IEEE80211_CONF_IDLE)
 		iwl_static_sleep_cmd(priv, cmd, IWL_POWER_INDEX_5, 20);
 	else if (iwl_tt_is_low_power_state(priv)) {
 		/* in thermal throttling low power state */
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless=
/rt2x00/rt2800lib.c
index 2a6aa85..5a45228 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -784,8 +784,7 @@ void rt2800_write_beacon(struct queue_entry *entry, str=
uct txentry_desc *txdesc)
 	/*
 	 * Add space for the TXWI in front of the skb.
 	 */
-	skb_push(entry->skb, TXWI_DESC_SIZE);
-	memset(entry->skb, 0, TXWI_DESC_SIZE);
+	memset(skb_push(entry->skb, TXWI_DESC_SIZE), 0, TXWI_DESC_SIZE);
=20
 	/*
 	 * Register descriptor details in skb frame descriptor.
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless=
/rt2x00/rt2800pci.c
index cc4a54f..55cd3e1 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -1158,6 +1158,7 @@ static DEFINE_PCI_DEVICE_TABLE(rt2800pci_device_table=
) =3D {
 #endif
 #ifdef CONFIG_RT2800PCI_RT53XX
 	{ PCI_DEVICE(0x1814, 0x5390) },
+	{ PCI_DEVICE(0x1814, 0x539f) },
 #endif
 	{ 0, }
 };
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless=
/rt2x00/rt2x00mac.c
index 93bec14..a76fdbe 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -113,7 +113,7 @@ void rt2x00mac_tx(struct ieee80211_hw *hw, struct sk_bu=
ff *skb)
 	 * due to possible race conditions in mac80211.
 	 */
 	if (!test_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags))
-		goto exit_fail;
+		goto exit_free_skb;
=20
 	/*
 	 * Use the ATIM queue if appropriate and present.
@@ -127,7 +127,7 @@ void rt2x00mac_tx(struct ieee80211_hw *hw, struct sk_bu=
ff *skb)
 		ERROR(rt2x00dev,
 		      "Attempt to send packet over invalid queue %d.\n"
 		      "Please file bug report to %s.\n", qid, DRV_PROJECT);
-		goto exit_fail;
+		goto exit_free_skb;
 	}
=20
 	/*
@@ -159,6 +159,7 @@ void rt2x00mac_tx(struct ieee80211_hw *hw, struct sk_bu=
ff *skb)
=20
  exit_fail:
 	rt2x00queue_pause_queue(queue);
+ exit_free_skb:
 	dev_kfree_skb_any(skb);
 }
 EXPORT_SYMBOL_GPL(rt2x00mac_tx);
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless=
/rt2x00/rt2x00usb.c
index 8f90f62..241a099 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -262,23 +262,20 @@ static void rt2x00usb_interrupt_txdone(struct urb *ur=
b)
 	struct queue_entry *entry =3D (struct queue_entry *)urb->context;
 	struct rt2x00_dev *rt2x00dev =3D entry->queue->rt2x00dev;
=20
-	if (!test_and_clear_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags))
+	if (!test_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags))
 		return;
-
-	if (rt2x00dev->ops->lib->tx_dma_done)
-		rt2x00dev->ops->lib->tx_dma_done(entry);
-
-	/*
-	 * Report the frame as DMA done
-	 */
-	rt2x00lib_dmadone(entry);
-
 	/*
 	 * Check if the frame was correctly uploaded
 	 */
 	if (urb->status)
 		set_bit(ENTRY_DATA_IO_FAILED, &entry->flags);
+	/*
+	 * Report the frame as DMA done
+	 */
+	rt2x00lib_dmadone(entry);
=20
+	if (rt2x00dev->ops->lib->tx_dma_done)
+		rt2x00dev->ops->lib->tx_dma_done(entry);
 	/*
 	 * Schedule the delayed work for reading the TX status
 	 * from the device.
diff --git a/drivers/net/wireless/rtlwifi/pci.c b/drivers/net/wireless/rtlw=
ifi/pci.c
index 254b64b..c872a23 100644
--- a/drivers/net/wireless/rtlwifi/pci.c
+++ b/drivers/net/wireless/rtlwifi/pci.c
@@ -1709,15 +1709,17 @@ static bool _rtl_pci_find_adapter(struct pci_dev *p=
dev,
 	pcipriv->ndis_adapter.devnumber =3D PCI_SLOT(pdev->devfn);
 	pcipriv->ndis_adapter.funcnumber =3D PCI_FUNC(pdev->devfn);
=20
-	/*find bridge info */
-	pcipriv->ndis_adapter.pcibridge_vendorid =3D bridge_pdev->vendor;
-	for (tmp =3D 0; tmp < PCI_BRIDGE_VENDOR_MAX; tmp++) {
-		if (bridge_pdev->vendor =3D=3D pcibridge_vendors[tmp]) {
-			pcipriv->ndis_adapter.pcibridge_vendor =3D tmp;
-			RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-				 ("Pci Bridge Vendor is found index: %d\n",
-				  tmp));
-			break;
+	if (bridge_pdev) {
+		/*find bridge info if available */
+		pcipriv->ndis_adapter.pcibridge_vendorid =3D bridge_pdev->vendor;
+		for (tmp =3D 0; tmp < PCI_BRIDGE_VENDOR_MAX; tmp++) {
+			if (bridge_pdev->vendor =3D=3D pcibridge_vendors[tmp]) {
+				pcipriv->ndis_adapter.pcibridge_vendor =3D tmp;
+				RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
+					 ("Pci Bridge Vendor is found index:"
+					 " %d\n", tmp));
+				break;
+			}
 		}
 	}
=20
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/rf.c b/drivers/net/wire=
less/rtlwifi/rtl8192cu/rf.c
index c7576ec..3bee79e 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/rf.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/rf.c
@@ -104,7 +104,7 @@ void rtl92cu_phy_rf6052_set_cck_txpower(struct ieee8021=
1_hw *hw,
 			tx_agc[RF90_PATH_A] =3D 0x10101010;
 			tx_agc[RF90_PATH_B] =3D 0x10101010;
 		} else if (rtlpriv->dm.dynamic_txhighpower_lvl =3D=3D
-			   TXHIGHPWRLEVEL_LEVEL1) {
+			   TXHIGHPWRLEVEL_LEVEL2) {
 			tx_agc[RF90_PATH_A] =3D 0x00000000;
 			tx_agc[RF90_PATH_B] =3D 0x00000000;
 		} else{
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 692671b..d549bbc 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1905,7 +1905,7 @@ void pci_enable_ari(struct pci_dev *dev)
 {
 	int pos;
 	u32 cap;
-	u16 ctrl;
+	u16 flags, ctrl;
 	struct pci_dev *bridge;
=20
 	if (!pci_is_pcie(dev) || dev->devfn)
@@ -1923,6 +1923,11 @@ void pci_enable_ari(struct pci_dev *dev)
 	if (!pos)
 		return;
=20
+	/* ARI is a PCIe v2 feature */
+	pci_read_config_word(bridge, pos + PCI_EXP_FLAGS, &flags);
+	if ((flags & PCI_EXP_FLAGS_VERS) < 2)
+		return;
+
 	pci_read_config_dword(bridge, pos + PCI_EXP_DEVCAP2, &cap);
 	if (!(cap & PCI_EXP_DEVCAP2_ARI))
 		return;
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 02145e9..1196f61 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -2758,6 +2758,29 @@ static void ricoh_mmc_fixup_r5c832(struct pci_dev *d=
ev)
=20
 	dev_notice(&dev->dev, "proprietary Ricoh MMC controller disabled (via fir=
ewire function)\n");
 	dev_notice(&dev->dev, "MMC cards are now supported by standard SDHCI cont=
roller\n");
+
+	/*
+	 * RICOH 0xe823 SD/MMC card reader fails to recognize
+	 * certain types of SD/MMC cards. Lowering the SD base
+	 * clock frequency from 200Mhz to 50Mhz fixes this issue.
+	 *
+	 * 0x150 - SD2.0 mode enable for changing base clock
+	 *	   frequency to 50Mhz
+	 * 0xe1  - Base clock frequency
+	 * 0x32  - 50Mhz new clock frequency
+	 * 0xf9  - Key register for 0x150
+	 * 0xfc  - key register for 0xe1
+	 */
+	if (dev->device =3D=3D PCI_DEVICE_ID_RICOH_R5CE823) {
+		pci_write_config_byte(dev, 0xf9, 0xfc);
+		pci_write_config_byte(dev, 0x150, 0x10);
+		pci_write_config_byte(dev, 0xf9, 0x00);
+		pci_write_config_byte(dev, 0xfc, 0x01);
+		pci_write_config_byte(dev, 0xe1, 0x32);
+		pci_write_config_byte(dev, 0xfc, 0x00);
+
+		dev_notice(&dev->dev, "MMC controller base frequency changed to 50Mhz.\n=
");
+	}
 }
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_RICOH, PCI_DEVICE_ID_RICOH_R5C832, r=
icoh_mmc_fixup_r5c832);
 DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_RICOH, PCI_DEVICE_ID_RICOH_R5=
C832, ricoh_mmc_fixup_r5c832);
diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wm=
i.c
index 3c7857c..e1678b9 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -797,8 +797,8 @@ exit:
  * Hwmon device
  */
 static ssize_t asus_hwmon_pwm1(struct device *dev,
-			    struct device_attribute *attr,
-			    char *buf)
+			       struct device_attribute *attr,
+			       char *buf)
 {
 	struct asus_wmi *asus =3D dev_get_drvdata(dev);
 	u32 value;
@@ -809,7 +809,7 @@ static ssize_t asus_hwmon_pwm1(struct device *dev,
 	if (err < 0)
 		return err;
=20
-	value |=3D 0xFF;
+	value &=3D 0xFF;
=20
 	if (value =3D=3D 1) /* Low Speed */
 		value =3D 85;
@@ -869,7 +869,7 @@ static mode_t asus_hwmon_sysfs_is_visible(struct kobjec=
t *kobj,
 		 * - reverved bits are non-zero
 		 * - sfun and presence bit are not set
 		 */
-		if (value !=3D ASUS_WMI_UNSUPPORTED_METHOD || value & 0xFFF80000
+		if (value =3D=3D ASUS_WMI_UNSUPPORTED_METHOD || value & 0xFFF80000
 		    || (!asus->sfun && !(value & ASUS_WMI_DSTS_PRESENCE_BIT)))
 			ok =3D false;
 	}
@@ -904,6 +904,7 @@ static int asus_wmi_hwmon_init(struct asus_wmi *asus)
 		pr_err("Could not register asus hwmon device\n");
 		return PTR_ERR(hwmon);
 	}
+	dev_set_drvdata(hwmon, asus);
 	asus->hwmon_device =3D hwmon;
 	result =3D sysfs_create_group(&hwmon->kobj, &hwmon_attribute_group);
 	if (result)
@@ -1164,14 +1165,18 @@ ASUS_WMI_CREATE_DEVICE_ATTR(cardr, 0644, ASUS_WMI_D=
EVID_CARDREADER);
 static ssize_t store_cpufv(struct device *dev, struct device_attribute *at=
tr,
 			   const char *buf, size_t count)
 {
-	int value;
+	int value, rv;
=20
 	if (!count || sscanf(buf, "%i", &value) !=3D 1)
 		return -EINVAL;
 	if (value < 0 || value > 2)
 		return -EINVAL;
=20
-	return asus_wmi_evaluate_method(ASUS_WMI_METHODID_CFVS, value, 0, NULL);
+	rv =3D asus_wmi_evaluate_method(ASUS_WMI_METHODID_CFVS, value, 0, NULL);
+	if (rv < 0)
+		return rv;
+
+	return count;
 }
=20
 static DEVICE_ATTR(cpufv, S_IRUGO | S_IWUSR, NULL, store_cpufv);
diff --git a/drivers/rtc/interface.c b/drivers/rtc/interface.c
index df68618..3195dbd 100644
--- a/drivers/rtc/interface.c
+++ b/drivers/rtc/interface.c
@@ -636,6 +636,29 @@ void rtc_irq_unregister(struct rtc_device *rtc, struct=
 rtc_task *task)
 }
 EXPORT_SYMBOL_GPL(rtc_irq_unregister);
=20
+static int rtc_update_hrtimer(struct rtc_device *rtc, int enabled)
+{
+	/*
+	 * We unconditionally cancel the timer here, because otherwise
+	 * we could run into BUG_ON(timer->state !=3D HRTIMER_STATE_CALLBACK);
+	 * when we manage to start the timer before the callback
+	 * returns HRTIMER_RESTART.
+	 *
+	 * We cannot use hrtimer_cancel() here as a running callback
+	 * could be blocked on rtc->irq_task_lock and hrtimer_cancel()
+	 * would spin forever.
+	 */
+	if (hrtimer_try_to_cancel(&rtc->pie_timer) < 0)
+		return -1;
+
+	if (enabled) {
+		ktime_t period =3D ktime_set(0, NSEC_PER_SEC / rtc->irq_freq);
+
+		hrtimer_start(&rtc->pie_timer, period, HRTIMER_MODE_REL);
+	}
+	return 0;
+}
+
 /**
  * rtc_irq_set_state - enable/disable 2^N Hz periodic IRQs
  * @rtc: the rtc device
@@ -651,21 +674,21 @@ int rtc_irq_set_state(struct rtc_device *rtc, struct =
rtc_task *task, int enabled
 	int err =3D 0;
 	unsigned long flags;
=20
+retry:
 	spin_lock_irqsave(&rtc->irq_task_lock, flags);
 	if (rtc->irq_task !=3D NULL && task =3D=3D NULL)
 		err =3D -EBUSY;
 	if (rtc->irq_task !=3D task)
 		err =3D -EACCES;
-
-	if (enabled) {
-		ktime_t period =3D ktime_set(0, NSEC_PER_SEC/rtc->irq_freq);
-		hrtimer_start(&rtc->pie_timer, period, HRTIMER_MODE_REL);
-	} else {
-		hrtimer_cancel(&rtc->pie_timer);
+	if (!err) {
+		if (rtc_update_hrtimer(rtc, enabled) < 0) {
+			spin_unlock_irqrestore(&rtc->irq_task_lock, flags);
+			cpu_relax();
+			goto retry;
+		}
+		rtc->pie_enabled =3D enabled;
 	}
-	rtc->pie_enabled =3D enabled;
 	spin_unlock_irqrestore(&rtc->irq_task_lock, flags);
-
 	return err;
 }
 EXPORT_SYMBOL_GPL(rtc_irq_set_state);
@@ -685,22 +708,20 @@ int rtc_irq_set_freq(struct rtc_device *rtc, struct r=
tc_task *task, int freq)
 	int err =3D 0;
 	unsigned long flags;
=20
-	if (freq <=3D 0)
+	if (freq <=3D 0 || freq > 5000)
 		return -EINVAL;
-
+retry:
 	spin_lock_irqsave(&rtc->irq_task_lock, flags);
 	if (rtc->irq_task !=3D NULL && task =3D=3D NULL)
 		err =3D -EBUSY;
 	if (rtc->irq_task !=3D task)
 		err =3D -EACCES;
-	if (err =3D=3D 0) {
+	if (!err) {
 		rtc->irq_freq =3D freq;
-		if (rtc->pie_enabled) {
-			ktime_t period;
-			hrtimer_cancel(&rtc->pie_timer);
-			period =3D ktime_set(0, NSEC_PER_SEC/rtc->irq_freq);
-			hrtimer_start(&rtc->pie_timer, period,
-					HRTIMER_MODE_REL);
+		if (rtc->pie_enabled && rtc_update_hrtimer(rtc, 1) < 0) {
+			spin_unlock_irqrestore(&rtc->irq_task_lock, flags);
+			cpu_relax();
+			goto retry;
 		}
 	}
 	spin_unlock_irqrestore(&rtc->irq_task_lock, flags);
diff --git a/drivers/rtc/rtc-tegra.c b/drivers/rtc/rtc-tegra.c
index 2fc31aa..75259fe 100644
--- a/drivers/rtc/rtc-tegra.c
+++ b/drivers/rtc/rtc-tegra.c
@@ -343,7 +343,7 @@ static int __devinit tegra_rtc_probe(struct platform_de=
vice *pdev)
=20
 	/* set context info. */
 	info->pdev =3D pdev;
-	info->tegra_rtc_lock =3D __SPIN_LOCK_UNLOCKED(info->tegra_rtc_lock);
+	spin_lock_init(&info->tegra_rtc_lock);
=20
 	platform_set_drvdata(pdev, info);
=20
diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index 6d8dcd4..7f53cea 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -214,7 +214,7 @@ static void SA5_submit_command(struct ctlr_info *h,
 	dev_dbg(&h->pdev->dev, "Sending %x, tag =3D %x\n", c->busaddr,
 		c->Header.Tag.lower);
 	writel(c->busaddr, h->vaddr + SA5_REQUEST_PORT_OFFSET);
-	(void) readl(h->vaddr + SA5_REQUEST_PORT_OFFSET);
+	(void) readl(h->vaddr + SA5_SCRATCHPAD_OFFSET);
 	h->commands_outstanding++;
 	if (h->commands_outstanding > h->max_outstanding)
 		h->max_outstanding =3D h->commands_outstanding;
diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_e=
xpander.c
index 874e29d..f84084b 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -849,6 +849,9 @@ static struct domain_device *sas_ex_discover_expander(
=20
 	res =3D sas_discover_expander(child);
 	if (res) {
+		spin_lock_irq(&parent->port->dev_list_lock);
+		list_del(&child->dev_list_node);
+		spin_unlock_irq(&parent->port->dev_list_lock);
 		kfree(child);
 		return NULL;
 	}
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt=
2sas_base.c
index efa0255..1da606c 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -94,7 +94,7 @@ module_param(diag_buffer_enable, int, 0);
 MODULE_PARM_DESC(diag_buffer_enable, " post diag buffers "
     "(TRACE=3D1/SNAPSHOT=3D2/EXTENDED=3D4/default=3D0)");
=20
-int mpt2sas_fwfault_debug;
+static int mpt2sas_fwfault_debug;
 MODULE_PARM_DESC(mpt2sas_fwfault_debug, " enable detection of firmware fau=
lt "
     "and halt firmware - (default=3D0)");
=20
@@ -857,7 +857,7 @@ _base_interrupt(int irq, void *bus_id)
 	completed_cmds =3D 0;
 	cb_idx =3D 0xFF;
 	do {
-		rd.word =3D rpf->Words;
+		rd.word =3D le64_to_cpu(rpf->Words);
 		if (rd.u.low =3D=3D UINT_MAX || rd.u.high =3D=3D UINT_MAX)
 			goto out;
 		reply =3D 0;
@@ -906,7 +906,7 @@ _base_interrupt(int irq, void *bus_id)
=20
  next:
=20
-		rpf->Words =3D ULLONG_MAX;
+		rpf->Words =3D cpu_to_le64(ULLONG_MAX);
 		ioc->reply_post_host_index =3D (ioc->reply_post_host_index =3D=3D
 		    (ioc->reply_post_queue_depth - 1)) ? 0 :
 		    ioc->reply_post_host_index + 1;
@@ -1817,7 +1817,9 @@ _base_display_ioc_capabilities(struct MPT2SAS_ADAPTER=
 *ioc)
 	char desc[16];
 	u8 revision;
 	u32 iounit_pg1_flags;
+	u32 bios_version;
=20
+	bios_version =3D le32_to_cpu(ioc->bios_pg3.BiosVersion);
 	pci_read_config_byte(ioc->pdev, PCI_CLASS_REVISION, &revision);
 	strncpy(desc, ioc->manu_pg0.ChipName, 16);
 	printk(MPT2SAS_INFO_FMT "%s: FWVersion(%02d.%02d.%02d.%02d), "
@@ -1828,10 +1830,10 @@ _base_display_ioc_capabilities(struct MPT2SAS_ADAPT=
ER *ioc)
 	   (ioc->facts.FWVersion.Word & 0x0000FF00) >> 8,
 	   ioc->facts.FWVersion.Word & 0x000000FF,
 	   revision,
-	   (ioc->bios_pg3.BiosVersion & 0xFF000000) >> 24,
-	   (ioc->bios_pg3.BiosVersion & 0x00FF0000) >> 16,
-	   (ioc->bios_pg3.BiosVersion & 0x0000FF00) >> 8,
-	    ioc->bios_pg3.BiosVersion & 0x000000FF);
+	   (bios_version & 0xFF000000) >> 24,
+	   (bios_version & 0x00FF0000) >> 16,
+	   (bios_version & 0x0000FF00) >> 8,
+	    bios_version & 0x000000FF);
=20
 	_base_display_dell_branding(ioc);
 	_base_display_intel_branding(ioc);
@@ -2150,7 +2152,7 @@ _base_release_memory_pools(struct MPT2SAS_ADAPTER *io=
c)
 static int
 _base_allocate_memory_pools(struct MPT2SAS_ADAPTER *ioc,  int sleep_flag)
 {
-	Mpi2IOCFactsReply_t *facts;
+	struct mpt2sas_facts *facts;
 	u32 queue_size, queue_diff;
 	u16 max_sge_elements;
 	u16 num_of_reply_frames;
@@ -2783,7 +2785,7 @@ _base_handshake_req_reply_wait(struct MPT2SAS_ADAPTER=
 *ioc, int request_bytes,
 	int i;
 	u8 failed;
 	u16 dummy;
-	u32 *mfp;
+	__le32 *mfp;
=20
 	/* make sure doorbell is not in use */
 	if ((readl(&ioc->chip->Doorbell) & MPI2_DOORBELL_USED)) {
@@ -2871,7 +2873,7 @@ _base_handshake_req_reply_wait(struct MPT2SAS_ADAPTER=
 *ioc, int request_bytes,
 	writel(0, &ioc->chip->HostInterruptStatus);
=20
 	if (ioc->logging_level & MPT_DEBUG_INIT) {
-		mfp =3D (u32 *)reply;
+		mfp =3D (__le32 *)reply;
 		printk(KERN_INFO "\toffset:data\n");
 		for (i =3D 0; i < reply_bytes/4; i++)
 			printk(KERN_INFO "\t[0x%02x]:%08x\n", i*4,
@@ -3097,7 +3099,8 @@ static int
 _base_get_port_facts(struct MPT2SAS_ADAPTER *ioc, int port, int sleep_flag)
 {
 	Mpi2PortFactsRequest_t mpi_request;
-	Mpi2PortFactsReply_t mpi_reply, *pfacts;
+	Mpi2PortFactsReply_t mpi_reply;
+	struct mpt2sas_port_facts *pfacts;
 	int mpi_reply_sz, mpi_request_sz, r;
=20
 	dinitprintk(ioc, printk(MPT2SAS_INFO_FMT "%s\n", ioc->name,
@@ -3139,7 +3142,8 @@ static int
 _base_get_ioc_facts(struct MPT2SAS_ADAPTER *ioc, int sleep_flag)
 {
 	Mpi2IOCFactsRequest_t mpi_request;
-	Mpi2IOCFactsReply_t mpi_reply, *facts;
+	Mpi2IOCFactsReply_t mpi_reply;
+	struct mpt2sas_facts *facts;
 	int mpi_reply_sz, mpi_request_sz, r;
=20
 	dinitprintk(ioc, printk(MPT2SAS_INFO_FMT "%s\n", ioc->name,
@@ -3225,17 +3229,6 @@ _base_send_ioc_init(struct MPT2SAS_ADAPTER *ioc, int=
 sleep_flag)
 	mpi_request.MsgVersion =3D cpu_to_le16(MPI2_VERSION);
 	mpi_request.HeaderVersion =3D cpu_to_le16(MPI2_HEADER_VERSION);
=20
-	/* In MPI Revision I (0xA), the SystemReplyFrameSize(offset 0x18) was
-	 * removed and made reserved.  For those with older firmware will need
-	 * this fix. It was decided that the Reply and Request frame sizes are
-	 * the same.
-	 */
-	if ((ioc->facts.HeaderVersion >> 8) < 0xA) {
-		mpi_request.Reserved7 =3D cpu_to_le16(ioc->reply_sz);
-/*		mpi_request.SystemReplyFrameSize =3D
- *		 cpu_to_le16(ioc->reply_sz);
- */
-	}
=20
 	mpi_request.SystemRequestFrameSize =3D cpu_to_le16(ioc->request_sz/4);
 	mpi_request.ReplyDescriptorPostQueueDepth =3D
@@ -3243,25 +3236,17 @@ _base_send_ioc_init(struct MPT2SAS_ADAPTER *ioc, in=
t sleep_flag)
 	mpi_request.ReplyFreeQueueDepth =3D
 	    cpu_to_le16(ioc->reply_free_queue_depth);
=20
-#if BITS_PER_LONG > 32
 	mpi_request.SenseBufferAddressHigh =3D
-	    cpu_to_le32(ioc->sense_dma >> 32);
+	    cpu_to_le32((u64)ioc->sense_dma >> 32);
 	mpi_request.SystemReplyAddressHigh =3D
-	    cpu_to_le32(ioc->reply_dma >> 32);
+	    cpu_to_le32((u64)ioc->reply_dma >> 32);
 	mpi_request.SystemRequestFrameBaseAddress =3D
-	    cpu_to_le64(ioc->request_dma);
+	    cpu_to_le64((u64)ioc->request_dma);
 	mpi_request.ReplyFreeQueueAddress =3D
-	    cpu_to_le64(ioc->reply_free_dma);
+	    cpu_to_le64((u64)ioc->reply_free_dma);
 	mpi_request.ReplyDescriptorPostQueueAddress =3D
-	    cpu_to_le64(ioc->reply_post_free_dma);
-#else
-	mpi_request.SystemRequestFrameBaseAddress =3D
-	    cpu_to_le32(ioc->request_dma);
-	mpi_request.ReplyFreeQueueAddress =3D
-	    cpu_to_le32(ioc->reply_free_dma);
-	mpi_request.ReplyDescriptorPostQueueAddress =3D
-	    cpu_to_le32(ioc->reply_post_free_dma);
-#endif
+	    cpu_to_le64((u64)ioc->reply_post_free_dma);
+
=20
 	/* This time stamp specifies number of milliseconds
 	 * since epoch ~ midnight January 1, 1970.
@@ -3271,10 +3256,10 @@ _base_send_ioc_init(struct MPT2SAS_ADAPTER *ioc, in=
t sleep_flag)
 	    (current_time.tv_usec / 1000));
=20
 	if (ioc->logging_level & MPT_DEBUG_INIT) {
-		u32 *mfp;
+		__le32 *mfp;
 		int i;
=20
-		mfp =3D (u32 *)&mpi_request;
+		mfp =3D (__le32 *)&mpi_request;
 		printk(KERN_INFO "\toffset:data\n");
 		for (i =3D 0; i < sizeof(Mpi2IOCInitRequest_t)/4; i++)
 			printk(KERN_INFO "\t[0x%02x]:%08x\n", i*4,
@@ -3759,7 +3744,7 @@ _base_make_ioc_operational(struct MPT2SAS_ADAPTER *io=
c, int sleep_flag)
=20
 	/* initialize Reply Post Free Queue */
 	for (i =3D 0; i < ioc->reply_post_queue_depth; i++)
-		ioc->reply_post_free[i].Words =3D ULLONG_MAX;
+		ioc->reply_post_free[i].Words =3D cpu_to_le64(ULLONG_MAX);
=20
 	r =3D _base_send_ioc_init(ioc, sleep_flag);
 	if (r)
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt=
2sas_base.h
index dcc289c..451dc1c 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
@@ -541,6 +541,53 @@ struct _tr_list {
=20
 typedef void (*MPT_ADD_SGE)(void *paddr, u32 flags_length, dma_addr_t dma_=
addr);
=20
+/* IOC Facts and Port Facts converted from little endian to cpu */
+union mpi2_version_union {
+	MPI2_VERSION_STRUCT		Struct;
+	u32				Word;
+};
+
+struct mpt2sas_facts {
+	u16			MsgVersion;
+	u16			HeaderVersion;
+	u8			IOCNumber;
+	u8			VP_ID;
+	u8			VF_ID;
+	u16			IOCExceptions;
+	u16			IOCStatus;
+	u32			IOCLogInfo;
+	u8			MaxChainDepth;
+	u8			WhoInit;
+	u8			NumberOfPorts;
+	u8			MaxMSIxVectors;
+	u16			RequestCredit;
+	u16			ProductID;
+	u32			IOCCapabilities;
+	union mpi2_version_union	FWVersion;
+	u16			IOCRequestFrameSize;
+	u16			Reserved3;
+	u16			MaxInitiators;
+	u16			MaxTargets;
+	u16			MaxSasExpanders;
+	u16			MaxEnclosures;
+	u16			ProtocolFlags;
+	u16			HighPriorityCredit;
+	u16			MaxReplyDescriptorPostQueueDepth;
+	u8			ReplyFrameSize;
+	u8			MaxVolumes;
+	u16			MaxDevHandle;
+	u16			MaxPersistentEntries;
+	u16			MinDevHandle;
+};
+
+struct mpt2sas_port_facts {
+	u8			PortNumber;
+	u8			VP_ID;
+	u8			VF_ID;
+	u8			PortType;
+	u16			MaxPostedCmdBuffers;
+};
+
 /**
  * struct MPT2SAS_ADAPTER - per adapter struct
  * @list: ioc_list
@@ -749,8 +796,8 @@ struct MPT2SAS_ADAPTER {
 	u32		event_masks[MPI2_EVENT_NOTIFY_EVENTMASK_WORDS];
=20
 	/* static config pages */
-	Mpi2IOCFactsReply_t facts;
-	Mpi2PortFactsReply_t *pfacts;
+	struct mpt2sas_facts facts;
+	struct mpt2sas_port_facts *pfacts;
 	Mpi2ManufacturingPage0_t manu_pg0;
 	Mpi2BiosPage2_t	bios_pg2;
 	Mpi2BiosPage3_t	bios_pg3;
@@ -840,7 +887,7 @@ struct MPT2SAS_ADAPTER {
=20
 	/* reply free queue */
 	u16 		reply_free_queue_depth;
-	u32		*reply_free;
+	__le32		*reply_free;
 	dma_addr_t	reply_free_dma;
 	struct dma_pool *reply_free_dma_pool;
 	u32		reply_free_host_index;
diff --git a/drivers/scsi/mpt2sas/mpt2sas_ctl.c b/drivers/scsi/mpt2sas/mpt2=
sas_ctl.c
index 437c2d9..d1c3bba 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_ctl.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
@@ -2706,13 +2706,13 @@ static DEVICE_ATTR(ioc_reset_count, S_IRUGO,
     _ctl_ioc_reset_count_show, NULL);
=20
 struct DIAG_BUFFER_START {
-	u32 Size;
-	u32 DiagVersion;
+	__le32 Size;
+	__le32 DiagVersion;
 	u8 BufferType;
 	u8 Reserved[3];
-	u32 Reserved1;
-	u32 Reserved2;
-	u32 Reserved3;
+	__le32 Reserved1;
+	__le32 Reserved2;
+	__le32 Reserved3;
 };
 /**
  * _ctl_host_trace_buffer_size_show - host buffer size (trace only)
diff --git a/drivers/scsi/mpt2sas/mpt2sas_debug.h b/drivers/scsi/mpt2sas/mp=
t2sas_debug.h
index 3dcddfe..9731f8e 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_debug.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_debug.h
@@ -164,7 +164,7 @@ static inline void
 _debug_dump_mf(void *mpi_request, int sz)
 {
 	int i;
-	u32 *mfp =3D (u32 *)mpi_request;
+	__le32 *mfp =3D (__le32 *)mpi_request;
=20
 	printk(KERN_INFO "mf:\n\t");
 	for (i =3D 0; i < sz; i++) {
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mp=
t2sas_scsih.c
index a7dbc68..e327a3c 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -1956,7 +1956,7 @@ _scsih_slave_configure(struct scsi_device *sdev)
 		case MPI2_RAID_VOL_TYPE_RAID1E:
 			qdepth =3D MPT2SAS_RAID_QUEUE_DEPTH;
 			if (ioc->manu_pg10.OEMIdentifier &&
-			    (ioc->manu_pg10.GenericFlags0 &
+			    (le32_to_cpu(ioc->manu_pg10.GenericFlags0) &
 			    MFG10_GF0_R10_DISPLAY) &&
 			    !(raid_device->num_pds % 2))
 				r_level =3D "RAID10";
@@ -4598,7 +4598,7 @@ _scsih_expander_add(struct MPT2SAS_ADAPTER *ioc, u16 =
handle)
 	Mpi2SasEnclosurePage0_t enclosure_pg0;
 	u32 ioc_status;
 	u16 parent_handle;
-	__le64 sas_address, sas_address_parent =3D 0;
+	u64 sas_address, sas_address_parent =3D 0;
 	int i;
 	unsigned long flags;
 	struct _sas_port *mpt2sas_port =3D NULL;
@@ -5404,7 +5404,7 @@ _scsih_sas_device_status_change_event(struct MPT2SAS_=
ADAPTER *ioc,
 {
 	struct MPT2SAS_TARGET *target_priv_data;
 	struct _sas_device *sas_device;
-	__le64 sas_address;
+	u64 sas_address;
 	unsigned long flags;
 	Mpi2EventDataSasDeviceStatusChange_t *event_data =3D
 	    fw_event->event_data;
@@ -6566,7 +6566,7 @@ _scsih_search_responding_expanders(struct MPT2SAS_ADA=
PTER *ioc)
 	Mpi2ExpanderPage0_t expander_pg0;
 	Mpi2ConfigReply_t mpi_reply;
 	u16 ioc_status;
-	__le64 sas_address;
+	u64 sas_address;
 	u16 handle;
=20
 	printk(MPT2SAS_INFO_FMT "%s\n", ioc->name, __func__);
@@ -7505,7 +7505,7 @@ _scsih_suspend(struct pci_dev *pdev, pm_message_t sta=
te)
 {
 	struct Scsi_Host *shost =3D pci_get_drvdata(pdev);
 	struct MPT2SAS_ADAPTER *ioc =3D shost_priv(shost);
-	u32 device_state;
+	pci_power_t device_state;
=20
 	mpt2sas_base_stop_watchdog(ioc);
 	scsi_block_requests(shost);
@@ -7532,7 +7532,7 @@ _scsih_resume(struct pci_dev *pdev)
 {
 	struct Scsi_Host *shost =3D pci_get_drvdata(pdev);
 	struct MPT2SAS_ADAPTER *ioc =3D shost_priv(shost);
-	u32 device_state =3D pdev->current_state;
+	pci_power_t device_state =3D pdev->current_state;
 	int r;
=20
 	printk(MPT2SAS_INFO_FMT "pdev=3D0x%p, slot=3D%s, previous "
diff --git a/drivers/scsi/mpt2sas/mpt2sas_transport.c b/drivers/scsi/mpt2sa=
s/mpt2sas_transport.c
index cb1cdec..15c7980 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_transport.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_transport.c
@@ -299,7 +299,6 @@ _transport_expander_report_manufacture(struct MPT2SAS_A=
DAPTER *ioc,
 	void *data_out =3D NULL;
 	dma_addr_t data_out_dma;
 	u32 sz;
-	u64 *sas_address_le;
 	u16 wait_state_count;
=20
 	if (ioc->shost_recovery || ioc->pci_error_recovery) {
@@ -372,8 +371,7 @@ _transport_expander_report_manufacture(struct MPT2SAS_A=
DAPTER *ioc,
 	mpi_request->PhysicalPort =3D 0xFF;
 	mpi_request->VF_ID =3D 0; /* TODO */
 	mpi_request->VP_ID =3D 0;
-	sas_address_le =3D (u64 *)&mpi_request->SASAddress;
-	*sas_address_le =3D cpu_to_le64(sas_address);
+	mpi_request->SASAddress =3D cpu_to_le64(sas_address);
 	mpi_request->RequestDataLength =3D
 	    cpu_to_le16(sizeof(struct rep_manu_request));
 	psge =3D &mpi_request->SGL;
@@ -1049,14 +1047,14 @@ struct phy_error_log_reply{
 	u8 function; /* 0x11 */
 	u8 function_result;
 	u8 response_length;
-	u16 expander_change_count;
+	__be16 expander_change_count;
 	u8 reserved_1[3];
 	u8 phy_identifier;
 	u8 reserved_2[2];
-	u32 invalid_dword;
-	u32 running_disparity_error;
-	u32 loss_of_dword_sync;
-	u32 phy_reset_problem;
+	__be32 invalid_dword;
+	__be32 running_disparity_error;
+	__be32 loss_of_dword_sync;
+	__be32 phy_reset_problem;
 };
=20
 /**
@@ -1085,7 +1083,6 @@ _transport_get_expander_phy_error_log(struct MPT2SAS_=
ADAPTER *ioc,
 	void *data_out =3D NULL;
 	dma_addr_t data_out_dma;
 	u32 sz;
-	u64 *sas_address_le;
 	u16 wait_state_count;
=20
 	if (ioc->shost_recovery || ioc->pci_error_recovery) {
@@ -1160,8 +1157,7 @@ _transport_get_expander_phy_error_log(struct MPT2SAS_=
ADAPTER *ioc,
 	mpi_request->PhysicalPort =3D 0xFF;
 	mpi_request->VF_ID =3D 0; /* TODO */
 	mpi_request->VP_ID =3D 0;
-	sas_address_le =3D (u64 *)&mpi_request->SASAddress;
-	*sas_address_le =3D cpu_to_le64(phy->identify.sas_address);
+	mpi_request->SASAddress =3D cpu_to_le64(phy->identify.sas_address);
 	mpi_request->RequestDataLength =3D
 	    cpu_to_le16(sizeof(struct phy_error_log_request));
 	psge =3D &mpi_request->SGL;
@@ -1406,7 +1402,6 @@ _transport_expander_phy_control(struct MPT2SAS_ADAPTE=
R *ioc,
 	void *data_out =3D NULL;
 	dma_addr_t data_out_dma;
 	u32 sz;
-	u64 *sas_address_le;
 	u16 wait_state_count;
=20
 	if (ioc->shost_recovery) {
@@ -1486,8 +1481,7 @@ _transport_expander_phy_control(struct MPT2SAS_ADAPTE=
R *ioc,
 	mpi_request->PhysicalPort =3D 0xFF;
 	mpi_request->VF_ID =3D 0; /* TODO */
 	mpi_request->VP_ID =3D 0;
-	sas_address_le =3D (u64 *)&mpi_request->SASAddress;
-	*sas_address_le =3D cpu_to_le64(phy->identify.sas_address);
+	mpi_request->SASAddress =3D cpu_to_le64(phy->identify.sas_address);
 	mpi_request->RequestDataLength =3D
 	    cpu_to_le16(sizeof(struct phy_error_log_request));
 	psge =3D &mpi_request->SGL;
@@ -1914,7 +1908,7 @@ _transport_smp_handler(struct Scsi_Host *shost, struc=
t sas_rphy *rphy,
 	mpi_request->PhysicalPort =3D 0xFF;
 	mpi_request->VF_ID =3D 0; /* TODO */
 	mpi_request->VP_ID =3D 0;
-	*((u64 *)&mpi_request->SASAddress) =3D (rphy) ?
+	mpi_request->SASAddress =3D (rphy) ?
 	    cpu_to_le64(rphy->identify.sas_address) :
 	    cpu_to_le64(ioc->sas_hba.sas_address);
 	mpi_request->RequestDataLength =3D cpu_to_le16(blk_rq_bytes(req) - 4);
diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index fca6a89..d079f9a 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -3871,6 +3871,9 @@ static long pmcraid_ioctl_passthrough(
 			pmcraid_err("couldn't build passthrough ioadls\n");
 			goto out_free_buffer;
 		}
+	} else if (request_size < 0) {
+		rc =3D -EINVAL;
+		goto out_free_buffer;
 	}
=20
 	/* If data is being written into the device, copy the data from user
diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index 82e9e5c..cf8dfab 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -197,6 +197,7 @@ static struct {
 	{"IBM", "ProFibre 4000R", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
 	{"IBM", "2105", NULL, BLIST_RETRY_HWERROR},
 	{"iomega", "jaz 1GB", "J.86", BLIST_NOTQ | BLIST_NOLUN},
+	{"IOMEGA", "ZIP", NULL, BLIST_NOTQ | BLIST_NOLUN},
 	{"IOMEGA", "Io20S         *F", NULL, BLIST_KEY},
 	{"INSITE", "Floptical   F*8I", NULL, BLIST_KEY},
 	{"INSITE", "I325VM", NULL, BLIST_KEY},
@@ -243,6 +244,7 @@ static struct {
 	{"Tornado-", "F4", "*", BLIST_NOREPORTLUN},
 	{"TOSHIBA", "CDROM", NULL, BLIST_ISROM},
 	{"TOSHIBA", "CD-ROM", NULL, BLIST_ISROM},
+	{"Traxdata", "CDR4120", NULL, BLIST_NOLUN},	/* locks up */
 	{"USB2.0", "SMARTMEDIA/XD", NULL, BLIST_FORCELUN | BLIST_INQUIRY_36},
 	{"WangDAT", "Model 2600", "01.7", BLIST_SELECT_NO_ATN},
 	{"WangDAT", "Model 3200", "02.2", BLIST_SELECT_NO_ATN},
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index ec1803a..28d9c9d 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -213,6 +213,8 @@ int scsi_execute(struct scsi_device *sdev, const unsign=
ed char *cmd,
 	int ret =3D DRIVER_ERROR << 24;
=20
 	req =3D blk_get_request(sdev->request_queue, write, __GFP_WAIT);
+	if (!req)
+		return ret;
=20
 	if (bufflen &&	blk_rq_map_kern(sdev->request_queue, req,
 					buffer, bufflen, __GFP_WAIT))
diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index eb7a3e8..eba183c 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -160,6 +160,10 @@ static unsigned char *ses_get_page2_descriptor(struct =
enclosure_device *edev,
 	return NULL;
 }
=20
+/* For device slot and array device slot elements, byte 3 bit 6
+ * is "fault sensed" while byte 3 bit 5 is "fault reqstd". As this
+ * code stands these bits are shifted 4 positions right so in
+ * sysfs they will appear as bits 2 and 1 respectively. Strange. */
 static void ses_get_fault(struct enclosure_device *edev,
 			  struct enclosure_component *ecomp)
 {
@@ -181,7 +185,7 @@ static int ses_set_fault(struct enclosure_device *edev,
 		/* zero is disabled */
 		break;
 	case ENCLOSURE_SETTING_ENABLED:
-		desc[2] =3D 0x02;
+		desc[3] =3D 0x20;
 		break;
 	default:
 		/* SES doesn't do the SGPIO blink settings */
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 4778e27..5fc97d2 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -221,14 +221,33 @@ static unsigned int sr_check_events(struct cdrom_devi=
ce_info *cdi,
 		return 0;
=20
 	events =3D sr_get_events(cd->device);
+	cd->get_event_changed |=3D events & DISK_EVENT_MEDIA_CHANGE;
+
+	/*
+	 * If earlier GET_EVENT_STATUS_NOTIFICATION and TUR did not agree
+	 * for several times in a row.  We rely on TUR only for this likely
+	 * broken device, to prevent generating incorrect media changed
+	 * events for every open().
+	 */
+	if (cd->ignore_get_event) {
+		events &=3D ~DISK_EVENT_MEDIA_CHANGE;
+		goto do_tur;
+	}
+
 	/*
 	 * GET_EVENT_STATUS_NOTIFICATION is enough unless MEDIA_CHANGE
 	 * is being cleared.  Note that there are devices which hang
 	 * if asked to execute TUR repeatedly.
 	 */
-	if (!(clearing & DISK_EVENT_MEDIA_CHANGE))
-		goto skip_tur;
+	if (cd->device->changed) {
+		events |=3D DISK_EVENT_MEDIA_CHANGE;
+		cd->device->changed =3D 0;
+		cd->tur_changed =3D true;
+	}
=20
+	if (!(clearing & DISK_EVENT_MEDIA_CHANGE))
+		return events;
+do_tur:
 	/* let's see whether the media is there with TUR */
 	last_present =3D cd->media_present;
 	ret =3D scsi_test_unit_ready(cd->device, SR_TIMEOUT, MAX_RETRIES, &sshdr);
@@ -242,12 +261,31 @@ static unsigned int sr_check_events(struct cdrom_devi=
ce_info *cdi,
 		(scsi_sense_valid(&sshdr) && sshdr.asc !=3D 0x3a);
=20
 	if (last_present !=3D cd->media_present)
-		events |=3D DISK_EVENT_MEDIA_CHANGE;
-skip_tur:
+		cd->device->changed =3D 1;
+
 	if (cd->device->changed) {
 		events |=3D DISK_EVENT_MEDIA_CHANGE;
 		cd->device->changed =3D 0;
+		cd->tur_changed =3D true;
+	}
+
+	if (cd->ignore_get_event)
+		return events;
+
+	/* check whether GET_EVENT is reporting spurious MEDIA_CHANGE */
+	if (!cd->tur_changed) {
+		if (cd->get_event_changed) {
+			if (cd->tur_mismatch++ > 8) {
+				sdev_printk(KERN_WARNING, cd->device,
+					    "GET_EVENT and TUR disagree continuously, suppress GET_EVENT even=
ts\n");
+				cd->ignore_get_event =3D true;
+			}
+		} else {
+			cd->tur_mismatch =3D 0;
+		}
 	}
+	cd->tur_changed =3D false;
+	cd->get_event_changed =3D false;
=20
 	return events;
 }
diff --git a/drivers/scsi/sr.h b/drivers/scsi/sr.h
index e036f1d..37c8f6b 100644
--- a/drivers/scsi/sr.h
+++ b/drivers/scsi/sr.h
@@ -41,6 +41,13 @@ typedef struct scsi_cd {
 	unsigned readcd_known:1;	/* drive supports READ_CD (0xbe) */
 	unsigned readcd_cdda:1;	/* reading audio data using READ_CD */
 	unsigned media_present:1;	/* media is present */
+
+	/* GET_EVENT spurious event handling, blk layer guarantees exclusion */
+	int tur_mismatch;		/* nr of get_event TUR mismatches */
+	bool tur_changed:1;		/* changed according to TUR */
+	bool get_event_changed:1;	/* changed according to GET_EVENT */
+	bool ignore_get_event:1;	/* GET_EVENT is unreliable, use TUR */
+
 	struct cdrom_device_info cdi;
 	/* We hold gendisk and scsi_device references on probe and use
 	 * the refs on this kref to decide when to release them */
diff --git a/drivers/staging/ath6kl/os/linux/ar6000_drv.c b/drivers/staging=
/ath6kl/os/linux/ar6000_drv.c
index 48dd9e3..62487a7 100644
--- a/drivers/staging/ath6kl/os/linux/ar6000_drv.c
+++ b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
@@ -954,9 +954,13 @@ ar6000_transfer_bin_file(struct ar6_softc *ar, AR6K_BI=
N_FILE file, u32 address,
     const char *filename;
     const struct firmware *fw_entry;
     u32 fw_entry_size;
+    u8 **buf;
+    size_t *buf_len;
=20
     switch (file) {
         case AR6K_OTP_FILE:
+		buf =3D &ar->fw_otp;
+		buf_len =3D &ar->fw_otp_len;
             if (ar->arVersion.target_ver =3D=3D AR6003_REV1_VERSION) {
                 filename =3D AR6003_REV1_OTP_FILE;
             } else if (ar->arVersion.target_ver =3D=3D AR6003_REV2_VERSION=
) {
@@ -970,6 +974,8 @@ ar6000_transfer_bin_file(struct ar6_softc *ar, AR6K_BIN=
_FILE file, u32 address,
             break;
=20
         case AR6K_FIRMWARE_FILE:
+		buf =3D &ar->fw;
+		buf_len =3D &ar->fw_len;
             if (ar->arVersion.target_ver =3D=3D AR6003_REV1_VERSION) {
                 filename =3D AR6003_REV1_FIRMWARE_FILE;
             } else if (ar->arVersion.target_ver =3D=3D AR6003_REV2_VERSION=
) {
@@ -1028,6 +1034,8 @@ ar6000_transfer_bin_file(struct ar6_softc *ar, AR6K_B=
IN_FILE file, u32 address,
             break;
=20
         case AR6K_PATCH_FILE:
+		buf =3D &ar->fw_patch;
+		buf_len =3D &ar->fw_patch_len;
             if (ar->arVersion.target_ver =3D=3D AR6003_REV1_VERSION) {
                 filename =3D AR6003_REV1_PATCH_FILE;
             } else if (ar->arVersion.target_ver =3D=3D AR6003_REV2_VERSION=
) {
@@ -1041,6 +1049,8 @@ ar6000_transfer_bin_file(struct ar6_softc *ar, AR6K_B=
IN_FILE file, u32 address,
             break;
=20
         case AR6K_BOARD_DATA_FILE:
+		buf =3D &ar->fw_data;
+		buf_len =3D &ar->fw_data_len;
             if (ar->arVersion.target_ver =3D=3D AR6003_REV1_VERSION) {
                 filename =3D AR6003_REV1_BOARD_DATA_FILE;
             } else if (ar->arVersion.target_ver =3D=3D AR6003_REV2_VERSION=
) {
@@ -1057,23 +1067,29 @@ ar6000_transfer_bin_file(struct ar6_softc *ar, AR6K=
_BIN_FILE file, u32 address,
             AR_DEBUG_PRINTF(ATH_DEBUG_ERR, ("Unknown file type: %d\n", fil=
e));
             return A_ERROR;
     }
-    if ((A_REQUEST_FIRMWARE(&fw_entry, filename, ((struct device *)ar->osD=
evInfo.pOSDevice))) !=3D 0)
-    {
-        AR_DEBUG_PRINTF(ATH_DEBUG_ERR, ("Failed to get %s\n", filename));
-        return A_ENOENT;
+
+    if (*buf =3D=3D NULL) {
+	    if ((A_REQUEST_FIRMWARE(&fw_entry, filename, ((struct device *)ar->os=
DevInfo.pOSDevice))) !=3D 0) {
+		    AR_DEBUG_PRINTF(ATH_DEBUG_ERR, ("Failed to get %s\n", filename));
+		    return A_ENOENT;
+	    }
+
+	    *buf =3D kmemdup(fw_entry->data, fw_entry->size, GFP_KERNEL);
+	    *buf_len =3D fw_entry->size;
+	    A_RELEASE_FIRMWARE(fw_entry);
     }
=20
 #ifdef SOFTMAC_FILE_USED
-    if (file=3D=3DAR6K_BOARD_DATA_FILE && fw_entry->data) {
-        ar6000_softmac_update(ar, (u8 *)fw_entry->data, fw_entry->size);
+    if (file=3D=3DAR6K_BOARD_DATA_FILE && *buf_len) {
+        ar6000_softmac_update(ar, *buf, *buf_len);
     }
 #endif=20
=20
=20
-    fw_entry_size =3D fw_entry->size;
+    fw_entry_size =3D *buf_len;
=20
     /* Load extended board data for AR6003 */
-    if ((file=3D=3DAR6K_BOARD_DATA_FILE) && (fw_entry->data)) {
+    if ((file=3D=3DAR6K_BOARD_DATA_FILE) && *buf) {
         u32 board_ext_address;
         u32 board_ext_data_size;
         u32 board_data_size;
@@ -1089,14 +1105,13 @@ ar6000_transfer_bin_file(struct ar6_softc *ar, AR6K=
_BIN_FILE file, u32 address,
         AR_DEBUG_PRINTF(ATH_DEBUG_INFO, ("Board extended Data download add=
ress: 0x%x\n", board_ext_address));
=20
         /* check whether the target has allocated memory for extended boar=
d data and file contains extended board data */
-        if ((board_ext_address) && (fw_entry->size =3D=3D (board_data_size=
 + board_ext_data_size))) {
+        if ((board_ext_address) && (*buf_len =3D=3D (board_data_size + boa=
rd_ext_data_size))) {
             u32 param;
=20
-            status =3D BMIWriteMemory(ar->arHifDevice, board_ext_address, =
(u8 *)(fw_entry->data + board_data_size), board_ext_data_size);
+            status =3D BMIWriteMemory(ar->arHifDevice, board_ext_address, =
(u8 *)(*buf + board_data_size), board_ext_data_size);
=20
             if (status) {
                 AR_DEBUG_PRINTF(ATH_DEBUG_ERR, ("BMI operation failed: %d\=
n", __LINE__));
-                A_RELEASE_FIRMWARE(fw_entry);
                 return A_ERROR;
             }
=20
@@ -1110,17 +1125,16 @@ ar6000_transfer_bin_file(struct ar6_softc *ar, AR6K=
_BIN_FILE file, u32 address,
     }
=20
     if (compressed) {
-        status =3D BMIFastDownload(ar->arHifDevice, address, (u8 *)fw_entr=
y->data, fw_entry_size);
+        status =3D BMIFastDownload(ar->arHifDevice, address, *buf, fw_entr=
y_size);
     } else {
-        status =3D BMIWriteMemory(ar->arHifDevice, address, (u8 *)fw_entry=
->data, fw_entry_size);
+        status =3D BMIWriteMemory(ar->arHifDevice, address, *buf, fw_entry=
_size);
     }
=20
     if (status) {
         AR_DEBUG_PRINTF(ATH_DEBUG_ERR, ("BMI operation failed: %d\n", __LI=
NE__));
-        A_RELEASE_FIRMWARE(fw_entry);
         return A_ERROR;
     }
-    A_RELEASE_FIRMWARE(fw_entry);
+
     return 0;
 }
=20
@@ -2088,6 +2102,11 @@ ar6000_destroy(struct net_device *dev, unsigned int =
unregister)
     ar6000_remove_ap_interface();
 #endif /*CONFIG_AP_VIRTUAL_ADAPTER_SUPPORT */
=20
+    kfree(ar->fw_otp);
+    kfree(ar->fw);
+    kfree(ar->fw_patch);
+    kfree(ar->fw_data);
+
     AR_DEBUG_PRINTF(ATH_DEBUG_INFO,("-ar6000_destroy \n"));
 }
=20
@@ -6179,6 +6198,7 @@ int ar6000_create_ap_interface(struct ar6_softc *ar, =
char *ap_ifname)
    =20
     ether_setup(dev);
     init_netdev(dev, ap_ifname);
+    dev->priv_flags &=3D ~IFF_TX_SKB_SHARING;
=20
     if (register_netdev(dev)) {
         AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("ar6000_create_ap_interface: regist=
er_netdev failed\n"));
diff --git a/drivers/staging/ath6kl/os/linux/cfg80211.c b/drivers/staging/a=
th6kl/os/linux/cfg80211.c
index d3a774d..32e3197 100644
--- a/drivers/staging/ath6kl/os/linux/cfg80211.c
+++ b/drivers/staging/ath6kl/os/linux/cfg80211.c
@@ -867,26 +867,31 @@ ar6k_cfg80211_scanComplete_event(struct ar6_softc *ar=
, int status)
=20
     AR_DEBUG_PRINTF(ATH_DEBUG_INFO, ("%s: status %d\n", __func__, status));
=20
-    if(ar->scan_request)
-    {
-        /* Translate data to cfg80211 mgmt format */
-	if (ar->arWmi)
-		wmi_iterate_nodes(ar->arWmi, ar6k_cfg80211_scan_node, ar->wdev->wiphy);
+    if (!ar->scan_request)
+	    return;
+
+    if ((status =3D=3D A_ECANCELED) || (status =3D=3D A_EBUSY)) {
+	    cfg80211_scan_done(ar->scan_request, true);
+	    goto out;
+    }
+
+    /* Translate data to cfg80211 mgmt format */
+    wmi_iterate_nodes(ar->arWmi, ar6k_cfg80211_scan_node, ar->wdev->wiphy);
=20
-        cfg80211_scan_done(ar->scan_request,
-            ((status & A_ECANCELED) || (status & A_EBUSY)) ? true : false);
+    cfg80211_scan_done(ar->scan_request, false);
=20
-        if(ar->scan_request->n_ssids &&
-           ar->scan_request->ssids[0].ssid_len) {
+    if(ar->scan_request->n_ssids &&
+       ar->scan_request->ssids[0].ssid_len) {
             u8 i;
=20
             for (i =3D 0; i < ar->scan_request->n_ssids; i++) {
-                wmi_probedSsid_cmd(ar->arWmi, i+1, DISABLE_SSID_FLAG,
-                                   0, NULL);
+		    wmi_probedSsid_cmd(ar->arWmi, i+1, DISABLE_SSID_FLAG,
+				       0, NULL);
             }
-        }
-        ar->scan_request =3D NULL;
     }
+
+out:
+    ar->scan_request =3D NULL;
 }
=20
 static int
diff --git a/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h b/drivers=
/staging/ath6kl/os/linux/include/ar6000_drv.h
index 22453b0..2911ea0 100644
--- a/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h
+++ b/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h
@@ -651,6 +651,15 @@ struct ar6_softc {
     void                    *arApDev;
 #endif
     u8 arAutoAuthStage;
+
+	u8 *fw_otp;
+	size_t fw_otp_len;
+	u8 *fw;
+	size_t fw_len;
+	u8 *fw_patch;
+	size_t fw_patch_len;
+	u8 *fw_data;
+	size_t fw_data_len;
 };
=20
 #ifdef CONFIG_AP_VIRTUAL_ADAPTER_SUPPORT
diff --git a/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c b/drivers/sta=
ging/brcm80211/brcmsmac/wl_mac80211.c
index 6c6236c..aa0d127 100644
--- a/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
+++ b/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
@@ -449,11 +449,6 @@ wl_ops_bss_info_changed(struct ieee80211_hw *hw,
 		wiphy_err(wiphy, "%s: qos enabled: %s (implement)\n", __func__,
 			  info->qos ? "true" : "false");
 	}
-	if (changed & BSS_CHANGED_IDLE) {
-		/* Idle changed for this BSS/interface */
-		wiphy_err(wiphy, "%s: BSS idle: %s (implement)\n", __func__,
-			  info->idle ? "true" : "false");
-	}
 	return;
 }
=20
diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/=
comedi_fops.c
index e7e72b8..c20694e 100644
--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -383,8 +383,8 @@ static int do_devinfo_ioctl(struct comedi_device *dev,
 	/* fill devinfo structure */
 	devinfo.version_code =3D COMEDI_VERSION_CODE;
 	devinfo.n_subdevs =3D dev->n_subdevices;
-	memcpy(devinfo.driver_name, dev->driver->driver_name, COMEDI_NAMELEN);
-	memcpy(devinfo.board_name, dev->board_name, COMEDI_NAMELEN);
+	strlcpy(devinfo.driver_name, dev->driver->driver_name, COMEDI_NAMELEN);
+	strlcpy(devinfo.board_name, dev->board_name, COMEDI_NAMELEN);
=20
 	if (read_subdev)
 		devinfo.read_subdevice =3D read_subdev - dev->subdevices;
diff --git a/drivers/staging/hv/channel.c b/drivers/staging/hv/channel.c
index f655e59..d971bab 100644
--- a/drivers/staging/hv/channel.c
+++ b/drivers/staging/hv/channel.c
@@ -212,7 +212,7 @@ int vmbus_open(struct vmbus_channel *newchannel, u32 se=
nd_ringbuffer_size,
 	if (ret !=3D 0)
 		goto Cleanup;
=20
-	t =3D wait_for_completion_timeout(&openInfo->waitevent, HZ);
+	t =3D wait_for_completion_timeout(&openInfo->waitevent, 5*HZ);
 	if (t =3D=3D 0) {
 		err =3D -ETIMEDOUT;
 		goto errorout;
diff --git a/drivers/staging/hv/channel_mgmt.c b/drivers/staging/hv/channel=
_mgmt.c
index 957d61e..e2e7d05 100644
--- a/drivers/staging/hv/channel_mgmt.c
+++ b/drivers/staging/hv/channel_mgmt.c
@@ -773,7 +773,7 @@ int vmbus_request_offers(void)
 		goto cleanup;
 	}
=20
-	t =3D wait_for_completion_timeout(&msginfo->waitevent, HZ);
+	t =3D wait_for_completion_timeout(&msginfo->waitevent, 5*HZ);
 	if (t =3D=3D 0) {
 		ret =3D -ETIMEDOUT;
 		goto cleanup;
diff --git a/drivers/staging/hv/connection.c b/drivers/staging/hv/connectio=
n.c
index 37bbf77..91c65ad 100644
--- a/drivers/staging/hv/connection.c
+++ b/drivers/staging/hv/connection.c
@@ -135,7 +135,7 @@ int vmbus_connect(void)
 	}
=20
 	/* Wait for the connection response */
-	t =3D  wait_for_completion_timeout(&msginfo->waitevent, HZ);
+	t =3D  wait_for_completion_timeout(&msginfo->waitevent, 5*HZ);
 	if (t =3D=3D 0) {
 		spin_lock_irqsave(&vmbus_connection.channelmsg_lock,
 				flags);
diff --git a/drivers/staging/hv/netvsc.c b/drivers/staging/hv/netvsc.c
index 41cbb26..4742b68 100644
--- a/drivers/staging/hv/netvsc.c
+++ b/drivers/staging/hv/netvsc.c
@@ -270,7 +270,7 @@ static int netvsc_init_recv_buf(struct hv_device *devic=
e)
 		goto cleanup;
 	}
=20
-	t =3D wait_for_completion_timeout(&net_device->channel_init_wait, HZ);
+	t =3D wait_for_completion_timeout(&net_device->channel_init_wait, 5*HZ);
 	BUG_ON(t =3D=3D 0);
=20
=20
@@ -513,7 +513,7 @@ static int netvsc_connect_vsp(struct hv_device *device)
 	if (ret !=3D 0)
 		goto cleanup;
=20
-	t =3D wait_for_completion_timeout(&net_device->channel_init_wait, HZ);
+	t =3D wait_for_completion_timeout(&net_device->channel_init_wait, 5*HZ);
=20
 	if (t =3D=3D 0) {
 		ret =3D -ETIMEDOUT;
diff --git a/drivers/staging/hv/rndis_filter.c b/drivers/staging/hv/rndis_f=
ilter.c
index 60ebdb1..b47ebb3 100644
--- a/drivers/staging/hv/rndis_filter.c
+++ b/drivers/staging/hv/rndis_filter.c
@@ -467,7 +467,7 @@ static int rndis_filter_query_device(struct rndis_devic=
e *dev, u32 oid,
 	if (ret !=3D 0)
 		goto Cleanup;
=20
-	t =3D wait_for_completion_timeout(&request->wait_event, HZ);
+	t =3D wait_for_completion_timeout(&request->wait_event, 5*HZ);
 	if (t =3D=3D 0) {
 		ret =3D -ETIMEDOUT;
 		goto Cleanup;
@@ -543,7 +543,7 @@ static int rndis_filter_set_packet_filter(struct rndis_=
device *dev,
 	if (ret !=3D 0)
 		goto Cleanup;
=20
-	t =3D wait_for_completion_timeout(&request->wait_event, HZ);
+	t =3D wait_for_completion_timeout(&request->wait_event, 5*HZ);
=20
 	if (t =3D=3D 0) {
 		ret =3D -1;
@@ -600,7 +600,7 @@ static int rndis_filter_init_device(struct rndis_device=
 *dev)
 	}
=20
=20
-	t =3D wait_for_completion_timeout(&request->wait_event, HZ);
+	t =3D wait_for_completion_timeout(&request->wait_event, 5*HZ);
=20
 	if (t =3D=3D 0) {
 		ret =3D -ETIMEDOUT;
diff --git a/drivers/staging/hv/storvsc.c b/drivers/staging/hv/storvsc.c
index 06cd327..3029786 100644
--- a/drivers/staging/hv/storvsc.c
+++ b/drivers/staging/hv/storvsc.c
@@ -135,7 +135,7 @@ static int storvsc_channel_init(struct hv_device *devic=
e)
 	if (ret !=3D 0)
 		goto cleanup;
=20
-	t =3D wait_for_completion_timeout(&request->wait_event, HZ);
+	t =3D wait_for_completion_timeout(&request->wait_event, 5*HZ);
 	if (t =3D=3D 0) {
 		ret =3D -ETIMEDOUT;
 		goto cleanup;
@@ -163,7 +163,7 @@ static int storvsc_channel_init(struct hv_device *devic=
e)
 	if (ret !=3D 0)
 		goto cleanup;
=20
-	t =3D wait_for_completion_timeout(&request->wait_event, HZ);
+	t =3D wait_for_completion_timeout(&request->wait_event, 5*HZ);
 	if (t =3D=3D 0) {
 		ret =3D -ETIMEDOUT;
 		goto cleanup;
@@ -192,7 +192,7 @@ static int storvsc_channel_init(struct hv_device *devic=
e)
 	if (ret !=3D 0)
 		goto cleanup;
=20
-	t =3D wait_for_completion_timeout(&request->wait_event, HZ);
+	t =3D wait_for_completion_timeout(&request->wait_event, 5*HZ);
 	if (t =3D=3D 0) {
 		ret =3D -ETIMEDOUT;
 		goto cleanup;
@@ -222,7 +222,7 @@ static int storvsc_channel_init(struct hv_device *devic=
e)
 	if (ret !=3D 0)
 		goto cleanup;
=20
-	t =3D wait_for_completion_timeout(&request->wait_event, HZ);
+	t =3D wait_for_completion_timeout(&request->wait_event, 5*HZ);
 	if (t =3D=3D 0) {
 		ret =3D -ETIMEDOUT;
 		goto cleanup;
diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_=
drv.c
index 942cc5f..cb4a25b 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -393,7 +393,7 @@ static int storvsc_host_reset(struct hv_device *device)
 	if (ret !=3D 0)
 		goto cleanup;
=20
-	t =3D wait_for_completion_timeout(&request->wait_event, HZ);
+	t =3D wait_for_completion_timeout(&request->wait_event, 5*HZ);
 	if (t =3D=3D 0) {
 		ret =3D -ETIMEDOUT;
 		goto cleanup;
diff --git a/drivers/staging/rtl8192e/r8192E_core.c b/drivers/staging/rtl81=
92e/r8192E_core.c
index 58d800f..cd98f89 100644
--- a/drivers/staging/rtl8192e/r8192E_core.c
+++ b/drivers/staging/rtl8192e/r8192E_core.c
@@ -4532,6 +4532,7 @@ static int __devinit rtl8192_pci_probe(struct pci_dev=
 *pdev,
 	u8 unit =3D 0;
 	int ret =3D -ENODEV;
 	unsigned long pmem_start, pmem_len, pmem_flags;
+	u8 revisionid;
=20
 	RT_TRACE(COMP_INIT,"Configuring chip resources\n");
=20
@@ -4592,6 +4593,11 @@ static int __devinit rtl8192_pci_probe(struct pci_de=
v *pdev,
          pci_write_config_byte(pdev, 0x41, 0x00);
=20
=20
+	pci_read_config_byte(pdev, 0x08, &revisionid);
+	/* If the revisionid is 0x10, the device uses rtl8192se. */
+	if (pdev->device =3D=3D 0x8192 && revisionid =3D=3D 0x10)
+		goto fail1;
+
 	pci_read_config_byte(pdev, 0x05, &unit);
 	pci_write_config_byte(pdev, 0x05, unit & (~0x04));
=20
diff --git a/drivers/staging/rtl8192u/r819xU_firmware.c b/drivers/staging/r=
tl8192u/r819xU_firmware.c
index 6766f46..4bb5fff 100644
--- a/drivers/staging/rtl8192u/r819xU_firmware.c
+++ b/drivers/staging/rtl8192u/r819xU_firmware.c
@@ -399,10 +399,7 @@ download_firmware_fail:
=20
 }
=20
-
-
-
-
-
-
+MODULE_FIRMWARE("RTL8192U/boot.img");
+MODULE_FIRMWARE("RTL8192U/main.img");
+MODULE_FIRMWARE("RTL8192U/data.img");
=20
diff --git a/drivers/staging/usbip/vhci_hcd.c b/drivers/staging/usbip/vhci_=
hcd.c
index a76e8fa..76d7485 100644
--- a/drivers/staging/usbip/vhci_hcd.c
+++ b/drivers/staging/usbip/vhci_hcd.c
@@ -846,9 +846,9 @@ static void vhci_shutdown_connection(struct usbip_devic=
e *ud)
 	}
=20
 	/* kill threads related to this sdev, if v.c. exists */
-	if (vdev->ud.tcp_rx)
+	if (vdev->ud.tcp_rx && !task_is_dead(vdev->ud.tcp_rx))
 		kthread_stop(vdev->ud.tcp_rx);
-	if (vdev->ud.tcp_tx)
+	if (vdev->ud.tcp_tx && !task_is_dead(vdev->ud.tcp_tx))
 		kthread_stop(vdev->ud.tcp_tx);
=20
 	pr_info("stop threads\n");
diff --git a/drivers/tty/hvc/hvc_console.c b/drivers/tty/hvc/hvc_console.c
index e9cba13..aa84555 100644
--- a/drivers/tty/hvc/hvc_console.c
+++ b/drivers/tty/hvc/hvc_console.c
@@ -163,8 +163,10 @@ static void hvc_console_print(struct console *co, cons=
t char *b,
 		} else {
 			r =3D cons_ops[index]->put_chars(vtermnos[index], c, i);
 			if (r <=3D 0) {
-				/* throw away chars on error */
-				i =3D 0;
+				/* throw away characters on error
+				 * but spin in case of -EAGAIN */
+				if (r !=3D -EAGAIN)
+					i =3D 0;
 			} else if (r > 0) {
 				i -=3D r;
 				if (i > 0)
@@ -448,7 +450,7 @@ static int hvc_push(struct hvc_struct *hp)
=20
 	n =3D hp->ops->put_chars(hp->vtermno, hp->outbuf, hp->n_outbuf);
 	if (n <=3D 0) {
-		if (n =3D=3D 0) {
+		if (n =3D=3D 0 || n =3D=3D -EAGAIN) {
 			hp->do_wakeup =3D 1;
 			return 0;
 		}
diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index 19b4ae0..c0d34ad 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -1823,10 +1823,6 @@ static void gsm0_receive(struct gsm_mux *gsm, unsign=
ed char c)
 		break;
 	case GSM_FCS:		/* FCS follows the packet */
 		gsm->received_fcs =3D c;
-		if (c =3D=3D GSM0_SOF) {
-			gsm->state =3D GSM_SEARCH;
-			break;
-		}
 		gsm_queue(gsm);
 		gsm->state =3D GSM_SSOF;
 		break;
diff --git a/drivers/tty/serial/8250.c b/drivers/tty/serial/8250.c
index b4129f5..d32b5bb 100644
--- a/drivers/tty/serial/8250.c
+++ b/drivers/tty/serial/8250.c
@@ -1107,7 +1107,7 @@ static void autoconfig_16550a(struct uart_8250_port *=
up)
 			 */
 			DEBUG_AUTOCONF("Xscale ");
 			up->port.type =3D PORT_XSCALE;
-			up->capabilities |=3D UART_CAP_UUE;
+			up->capabilities |=3D UART_CAP_UUE | UART_CAP_RTOIE;
 			return;
 		}
 	} else {
diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
index 636144c..b3692e6 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -1419,7 +1419,7 @@ config SERIAL_SC26XX
=20
 config SERIAL_SC26XX_CONSOLE
 	bool "Console on SC2681/SC2692 serial port"
-	depends on SERIAL_SC26XX
+	depends on SERIAL_SC26XX=3Dy
 	select SERIAL_CORE_CONSOLE
 	help
 	  Support for Console on SC2681/SC2692 serial ports.
diff --git a/drivers/usb/class/usbtmc.c b/drivers/usb/class/usbtmc.c
index 385acb8..3f94ac3 100644
--- a/drivers/usb/class/usbtmc.c
+++ b/drivers/usb/class/usbtmc.c
@@ -268,7 +268,7 @@ usbtmc_abort_bulk_in_status:
 				dev_err(dev, "usb_bulk_msg returned %d\n", rv);
 				goto exit;
 			}
-		} while ((actual =3D max_size) &&
+		} while ((actual =3D=3D max_size) &&
 			 (n < USBTMC_MAX_READS_TO_CLEAR_BULK_IN));
=20
 	if (actual =3D=3D max_size) {
diff --git a/drivers/usb/core/config.c b/drivers/usb/core/config.c
index c962608..26678ca 100644
--- a/drivers/usb/core/config.c
+++ b/drivers/usb/core/config.c
@@ -123,10 +123,11 @@ static void usb_parse_ss_endpoint_companion(struct de=
vice *ddev, int cfgno,
 	}
=20
 	if (usb_endpoint_xfer_isoc(&ep->desc))
-		max_tx =3D ep->desc.wMaxPacketSize * (desc->bMaxBurst + 1) *
-			(desc->bmAttributes + 1);
+		max_tx =3D (desc->bMaxBurst + 1) * (desc->bmAttributes + 1) *
+			le16_to_cpu(ep->desc.wMaxPacketSize);
 	else if (usb_endpoint_xfer_int(&ep->desc))
-		max_tx =3D ep->desc.wMaxPacketSize * (desc->bMaxBurst + 1);
+		max_tx =3D le16_to_cpu(ep->desc.wMaxPacketSize) *
+			(desc->bMaxBurst + 1);
 	else
 		max_tx =3D 999999;
 	if (le16_to_cpu(desc->wBytesPerInterval) > max_tx) {
@@ -134,10 +135,10 @@ static void usb_parse_ss_endpoint_companion(struct de=
vice *ddev, int cfgno,
 				"config %d interface %d altsetting %d ep %d: "
 				"setting to %d\n",
 				usb_endpoint_xfer_isoc(&ep->desc) ? "Isoc" : "Int",
-				desc->wBytesPerInterval,
+				le16_to_cpu(desc->wBytesPerInterval),
 				cfgno, inum, asnum, ep->desc.bEndpointAddress,
 				max_tx);
-		ep->ss_ep_comp.wBytesPerInterval =3D max_tx;
+		ep->ss_ep_comp.wBytesPerInterval =3D cpu_to_le16(max_tx);
 	}
 }
=20
diff --git a/drivers/usb/host/ehci-hcd.c b/drivers/usb/host/ehci-hcd.c
index f8030ee..9ff9abc 100644
--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -94,7 +94,8 @@ static const char	hcd_name [] =3D "ehci_hcd";
 #define EHCI_IAA_MSECS		10		/* arbitrary */
 #define EHCI_IO_JIFFIES		(HZ/10)		/* io watchdog > irq_thresh */
 #define EHCI_ASYNC_JIFFIES	(HZ/20)		/* async idle timeout */
-#define EHCI_SHRINK_FRAMES	5		/* async qh unlink delay */
+#define EHCI_SHRINK_JIFFIES	(DIV_ROUND_UP(HZ, 200) + 1)
+						/* 200-ms async qh unlink delay */
=20
 /* Initial IRQ latency:  faster than hw default */
 static int log2_irq_thresh =3D 0;		// 0 to 6
@@ -152,10 +153,7 @@ timer_action(struct ehci_hcd *ehci, enum ehci_timer_ac=
tion action)
 			break;
 		/* case TIMER_ASYNC_SHRINK: */
 		default:
-			/* add a jiffie since we synch against the
-			 * 8 KHz uframe counter.
-			 */
-			t =3D DIV_ROUND_UP(EHCI_SHRINK_FRAMES * HZ, 1000) + 1;
+			t =3D EHCI_SHRINK_JIFFIES;
 			break;
 		}
 		mod_timer(&ehci->watchdog, t + jiffies);
diff --git a/drivers/usb/host/ehci-hub.c b/drivers/usb/host/ehci-hub.c
index ea6184b..88cfb8f 100644
--- a/drivers/usb/host/ehci-hub.c
+++ b/drivers/usb/host/ehci-hub.c
@@ -891,10 +891,11 @@ static int ehci_hub_control (
 			 * power switching; they're allowed to just limit the
 			 * current.  khubd will turn the power back on.
 			 */
-			if (HCS_PPC (ehci->hcs_params)){
+			if ((temp & PORT_OC) && HCS_PPC(ehci->hcs_params)) {
 				ehci_writel(ehci,
 					temp & ~(PORT_RWC_BITS | PORT_POWER),
 					status_reg);
+				temp =3D ehci_readl(ehci, status_reg);
 			}
 		}
=20
diff --git a/drivers/usb/host/ehci-q.c b/drivers/usb/host/ehci-q.c
index 5d6bc62..0917e3a 100644
--- a/drivers/usb/host/ehci-q.c
+++ b/drivers/usb/host/ehci-q.c
@@ -103,7 +103,7 @@ qh_update (struct ehci_hcd *ehci, struct ehci_qh *qh, s=
truct ehci_qtd *qtd)
 	if (!(hw->hw_info1 & cpu_to_hc32(ehci, 1 << 14))) {
 		unsigned	is_out, epnum;
=20
-		is_out =3D !(qtd->hw_token & cpu_to_hc32(ehci, 1 << 8));
+		is_out =3D qh->is_out;
 		epnum =3D (hc32_to_cpup(ehci, &hw->hw_info1) >> 8) & 0x0f;
 		if (unlikely (!usb_gettoggle (qh->dev, epnum, is_out))) {
 			hw->hw_token &=3D ~cpu_to_hc32(ehci, QTD_TOGGLE);
@@ -946,6 +946,7 @@ done:
 	hw =3D qh->hw;
 	hw->hw_info1 =3D cpu_to_hc32(ehci, info1);
 	hw->hw_info2 =3D cpu_to_hc32(ehci, info2);
+	qh->is_out =3D !is_input;
 	usb_settoggle (urb->dev, usb_pipeendpoint (urb->pipe), !is_input, 1);
 	qh_refresh (ehci, qh);
 	return qh;
@@ -1231,6 +1232,8 @@ static void start_unlink_async (struct ehci_hcd *ehci=
, struct ehci_qh *qh)
=20
 	prev->hw->hw_next =3D qh->hw->hw_next;
 	prev->qh_next =3D qh->qh_next;
+	if (ehci->qh_scan_next =3D=3D qh)
+		ehci->qh_scan_next =3D qh->qh_next.qh;
 	wmb ();
=20
 	/* If the controller isn't running, we don't have to wait for it */
@@ -1256,53 +1259,49 @@ static void scan_async (struct ehci_hcd *ehci)
 	struct ehci_qh		*qh;
 	enum ehci_timer_action	action =3D TIMER_IO_WATCHDOG;
=20
-	ehci->stamp =3D ehci_readl(ehci, &ehci->regs->frame_index);
 	timer_action_done (ehci, TIMER_ASYNC_SHRINK);
-rescan:
 	stopped =3D !HC_IS_RUNNING(ehci_to_hcd(ehci)->state);
-	qh =3D ehci->async->qh_next.qh;
-	if (likely (qh !=3D NULL)) {
-		do {
-			/* clean any finished work for this qh */
-			if (!list_empty(&qh->qtd_list) && (stopped ||
-					qh->stamp !=3D ehci->stamp)) {
-				int temp;
-
-				/* unlinks could happen here; completion
-				 * reporting drops the lock.  rescan using
-				 * the latest schedule, but don't rescan
-				 * qhs we already finished (no looping)
-				 * unless the controller is stopped.
-				 */
-				qh =3D qh_get (qh);
-				qh->stamp =3D ehci->stamp;
-				temp =3D qh_completions (ehci, qh);
-				if (qh->needs_rescan)
-					unlink_async(ehci, qh);
-				qh_put (qh);
-				if (temp !=3D 0) {
-					goto rescan;
-				}
-			}
=20
-			/* unlink idle entries, reducing DMA usage as well
-			 * as HCD schedule-scanning costs.  delay for any qh
-			 * we just scanned, there's a not-unusual case that it
-			 * doesn't stay idle for long.
-			 * (plus, avoids some kind of re-activation race.)
+	ehci->qh_scan_next =3D ehci->async->qh_next.qh;
+	while (ehci->qh_scan_next) {
+		qh =3D ehci->qh_scan_next;
+		ehci->qh_scan_next =3D qh->qh_next.qh;
+ rescan:
+		/* clean any finished work for this qh */
+		if (!list_empty(&qh->qtd_list)) {
+			int temp;
+
+			/*
+			 * Unlinks could happen here; completion reporting
+			 * drops the lock.  That's why ehci->qh_scan_next
+			 * always holds the next qh to scan; if the next qh
+			 * gets unlinked then ehci->qh_scan_next is adjusted
+			 * in start_unlink_async().
 			 */
-			if (list_empty(&qh->qtd_list)
-					&& qh->qh_state =3D=3D QH_STATE_LINKED) {
-				if (!ehci->reclaim && (stopped ||
-					((ehci->stamp - qh->stamp) & 0x1fff)
-						>=3D EHCI_SHRINK_FRAMES * 8))
-					start_unlink_async(ehci, qh);
-				else
-					action =3D TIMER_ASYNC_SHRINK;
-			}
+			qh =3D qh_get(qh);
+			temp =3D qh_completions(ehci, qh);
+			if (qh->needs_rescan)
+				unlink_async(ehci, qh);
+			qh->unlink_time =3D jiffies + EHCI_SHRINK_JIFFIES;
+			qh_put(qh);
+			if (temp !=3D 0)
+				goto rescan;
+		}
=20
-			qh =3D qh->qh_next.qh;
-		} while (qh);
+		/* unlink idle entries, reducing DMA usage as well
+		 * as HCD schedule-scanning costs.  delay for any qh
+		 * we just scanned, there's a not-unusual case that it
+		 * doesn't stay idle for long.
+		 * (plus, avoids some kind of re-activation race.)
+		 */
+		if (list_empty(&qh->qtd_list)
+				&& qh->qh_state =3D=3D QH_STATE_LINKED) {
+			if (!ehci->reclaim && (stopped ||
+					time_after_eq(jiffies, qh->unlink_time)))
+				start_unlink_async(ehci, qh);
+			else
+				action =3D TIMER_ASYNC_SHRINK;
+		}
 	}
 	if (action =3D=3D TIMER_ASYNC_SHRINK)
 		timer_action (ehci, TIMER_ASYNC_SHRINK);
diff --git a/drivers/usb/host/ehci.h b/drivers/usb/host/ehci.h
index bd6ff48..989e0a8 100644
--- a/drivers/usb/host/ehci.h
+++ b/drivers/usb/host/ehci.h
@@ -75,6 +75,7 @@ struct ehci_hcd {			/* one per controller */
 	struct ehci_qh		*async;
 	struct ehci_qh		*dummy;		/* For AMD quirk use */
 	struct ehci_qh		*reclaim;
+	struct ehci_qh		*qh_scan_next;
 	unsigned		scanning : 1;
=20
 	/* periodic schedule support */
@@ -117,7 +118,6 @@ struct ehci_hcd {			/* one per controller */
 	struct timer_list	iaa_watchdog;
 	struct timer_list	watchdog;
 	unsigned long		actions;
-	unsigned		stamp;
 	unsigned		periodic_stamp;
 	unsigned		random_frame;
 	unsigned long		next_statechange;
@@ -343,6 +343,7 @@ struct ehci_qh {
 	struct ehci_qh		*reclaim;	/* next to reclaim */
=20
 	struct ehci_hcd		*ehci;
+	unsigned long		unlink_time;
=20
 	/*
 	 * Do NOT use atomic operations for QH refcounting. On some CPUs
@@ -374,6 +375,7 @@ struct ehci_qh {
 #define NO_FRAME ((unsigned short)~0)			/* pick new start */
=20
 	struct usb_device	*dev;		/* access to TT */
+	unsigned		is_out:1;	/* bulk or intr OUT */
 	unsigned		clearing_tt:1;	/* Clear-TT-Buf in progress */
 };
=20
diff --git a/drivers/usb/host/pci-quirks.c b/drivers/usb/host/pci-quirks.c
index fd93061..e9f004e 100644
--- a/drivers/usb/host/pci-quirks.c
+++ b/drivers/usb/host/pci-quirks.c
@@ -35,6 +35,8 @@
 #define OHCI_INTRSTATUS		0x0c
 #define OHCI_INTRENABLE		0x10
 #define OHCI_INTRDISABLE	0x14
+#define OHCI_FMINTERVAL		0x34
+#define OHCI_HCR		(1 << 0)	/* host controller reset */
 #define OHCI_OCR		(1 << 3)	/* ownership change request */
 #define OHCI_CTRL_RWC		(1 << 9)	/* remote wakeup connected */
 #define OHCI_CTRL_IR		(1 << 8)	/* interrupt routing */
@@ -497,6 +499,32 @@ static void __devinit quirk_usb_handoff_ohci(struct pc=
i_dev *pdev)
=20
 	/* reset controller, preserving RWC (and possibly IR) */
 	writel(control & OHCI_CTRL_MASK, base + OHCI_CONTROL);
+	readl(base + OHCI_CONTROL);
+
+	/* Some NVIDIA controllers stop working if kept in RESET for too long */
+	if (pdev->vendor =3D=3D PCI_VENDOR_ID_NVIDIA) {
+		u32 fminterval;
+		int cnt;
+
+		/* drive reset for at least 50 ms (7.1.7.5) */
+		msleep(50);
+
+		/* software reset of the controller, preserving HcFmInterval */
+		fminterval =3D readl(base + OHCI_FMINTERVAL);
+		writel(OHCI_HCR, base + OHCI_CMDSTATUS);
+
+		/* reset requires max 10 us delay */
+		for (cnt =3D 30; cnt > 0; --cnt) {	/* ... allow extra time */
+			if ((readl(base + OHCI_CMDSTATUS) & OHCI_HCR) =3D=3D 0)
+				break;
+			udelay(1);
+		}
+		writel(fminterval, base + OHCI_FMINTERVAL);
+
+		/* Now we're in the SUSPEND state with all devices reset
+		 * and wakeups and interrupts disabled
+		 */
+	}
=20
 	/*
 	 * disable interrupts
@@ -775,7 +803,7 @@ static void __devinit quirk_usb_handoff_xhci(struct pci=
_dev *pdev)
=20
 	/* If the BIOS owns the HC, signal that the OS wants it, and wait */
 	if (val & XHCI_HC_BIOS_OWNED) {
-		writel(val & XHCI_HC_OS_OWNED, base + ext_cap_offset);
+		writel(val | XHCI_HC_OS_OWNED, base + ext_cap_offset);
=20
 		/* Wait for 5 seconds with 10 microsecond polling interval */
 		timeout =3D handshake(base + ext_cap_offset, XHCI_HC_BIOS_OWNED,
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index f5fe1ac..9824761 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -345,7 +345,8 @@ static void xhci_event_ring_work(unsigned long arg)
 	spin_lock_irqsave(&xhci->lock, flags);
 	temp =3D xhci_readl(xhci, &xhci->op_regs->status);
 	xhci_dbg(xhci, "op reg status =3D 0x%x\n", temp);
-	if (temp =3D=3D 0xffffffff || (xhci->xhc_state & XHCI_STATE_DYING)) {
+	if (temp =3D=3D 0xffffffff || (xhci->xhc_state & XHCI_STATE_DYING) ||
+			(xhci->xhc_state & XHCI_STATE_HALTED)) {
 		xhci_dbg(xhci, "HW died, polling stopped.\n");
 		spin_unlock_irqrestore(&xhci->lock, flags);
 		return;
@@ -939,8 +940,11 @@ static int xhci_check_args(struct usb_hcd *hcd, struct=
 usb_device *udev,
 		return 0;
 	}
=20
+	xhci =3D hcd_to_xhci(hcd);
+	if (xhci->xhc_state & XHCI_STATE_HALTED)
+		return -ENODEV;
+
 	if (check_virt_dev) {
-		xhci =3D hcd_to_xhci(hcd);
 		if (!udev->slot_id || !xhci->devs
 			|| !xhci->devs[udev->slot_id]) {
 			printk(KERN_DEBUG "xHCI %s called with unaddressed "
@@ -1242,7 +1246,8 @@ int xhci_urb_dequeue(struct usb_hcd *hcd, struct urb =
*urb, int status)
 		xhci_urb_free_priv(xhci, urb_priv);
 		return ret;
 	}
-	if (xhci->xhc_state & XHCI_STATE_DYING) {
+	if ((xhci->xhc_state & XHCI_STATE_DYING) ||
+			(xhci->xhc_state & XHCI_STATE_HALTED)) {
 		xhci_dbg(xhci, "Ep 0x%x: URB %p to be canceled on "
 				"non-responsive xHCI host.\n",
 				urb->ep->desc.bEndpointAddress, urb);
@@ -2667,7 +2672,10 @@ void xhci_free_dev(struct usb_hcd *hcd, struct usb_d=
evice *udev)
 	int i, ret;
=20
 	ret =3D xhci_check_args(hcd, udev, NULL, 0, true, __func__);
-	if (ret <=3D 0)
+	/* If the host is halted due to driver unload, we still need to free the
+	 * device.
+	 */
+	if (ret <=3D 0 && ret !=3D -ENODEV)
 		return;
=20
 	virt_dev =3D xhci->devs[udev->slot_id];
@@ -2681,7 +2689,8 @@ void xhci_free_dev(struct usb_hcd *hcd, struct usb_de=
vice *udev)
 	spin_lock_irqsave(&xhci->lock, flags);
 	/* Don't disable the slot if the host controller is dead. */
 	state =3D xhci_readl(xhci, &xhci->op_regs->status);
-	if (state =3D=3D 0xffffffff || (xhci->xhc_state & XHCI_STATE_DYING)) {
+	if (state =3D=3D 0xffffffff || (xhci->xhc_state & XHCI_STATE_DYING) ||
+			(xhci->xhc_state & XHCI_STATE_HALTED)) {
 		xhci_free_virt_device(xhci, udev->slot_id);
 		spin_unlock_irqrestore(&xhci->lock, flags);
 		return;
diff --git a/drivers/usb/musb/musb_core.c b/drivers/usb/musb/musb_core.c
index c71b037..dce7182 100644
--- a/drivers/usb/musb/musb_core.c
+++ b/drivers/usb/musb/musb_core.c
@@ -2329,6 +2329,7 @@ static void musb_restore_context(struct musb *musb)
 				musb->context.index_regs[i].rxhubport);
 		}
 	}
+	musb_writeb(musb_base, MUSB_INDEX, musb->context.index);
 }
=20
 static int musb_suspend(struct device *dev)
diff --git a/drivers/usb/musb/musb_gadget.c b/drivers/usb/musb/musb_gadget.c
index 6aeb363..548338c 100644
--- a/drivers/usb/musb/musb_gadget.c
+++ b/drivers/usb/musb/musb_gadget.c
@@ -1698,6 +1698,8 @@ static int musb_gadget_pullup(struct usb_gadget *gadg=
et, int is_on)
=20
 	is_on =3D !!is_on;
=20
+	pm_runtime_get_sync(musb->controller);
+
 	/* NOTE: this assumes we are sensing vbus; we'd rather
 	 * not pullup unless the B-session is active.
 	 */
@@ -1707,6 +1709,9 @@ static int musb_gadget_pullup(struct usb_gadget *gadg=
et, int is_on)
 		musb_pullup(musb, is_on);
 	}
 	spin_unlock_irqrestore(&musb->lock, flags);
+
+	pm_runtime_put(musb->controller);
+
 	return 0;
 }
=20
diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 2e06b90..9afb361 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -1171,7 +1171,7 @@ static __u32 get_ftdi_divisor(struct tty_struct *tty,
 	case FT2232H: /* FT2232H chip */
 	case FT4232H: /* FT4232H chip */
 	case FT232H:  /* FT232H chip */
-		if ((baud <=3D 12000000) & (baud >=3D 1200)) {
+		if ((baud <=3D 12000000) && (baud >=3D 1200)) {
 			div_value =3D ftdi_2232h_baud_to_divisor(baud);
 		} else if (baud < 1200) {
 			div_value =3D ftdi_232bm_baud_to_divisor(baud);
diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 60b25d8..8156561 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -148,6 +148,10 @@ static void option_instat_callback(struct urb *urb);
 #define HUAWEI_PRODUCT_K4505			0x1464
 #define HUAWEI_PRODUCT_K3765			0x1465
 #define HUAWEI_PRODUCT_E14AC			0x14AC
+#define HUAWEI_PRODUCT_K3770			0x14C9
+#define HUAWEI_PRODUCT_K3771			0x14CA
+#define HUAWEI_PRODUCT_K4510			0x14CB
+#define HUAWEI_PRODUCT_K4511			0x14CC
 #define HUAWEI_PRODUCT_ETS1220			0x1803
 #define HUAWEI_PRODUCT_E353			0x1506
=20
@@ -547,6 +551,14 @@ static const struct usb_device_id option_ids[] =3D {
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K3765, 0=
xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_ETS1220,=
 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E14AC, 0=
xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K3770, 0=
xff, 0x02, 0x31) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K3770, 0=
xff, 0x02, 0x32) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K3771, 0=
xff, 0x02, 0x31) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K3771, 0=
xff, 0x02, 0x32) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K4510, 0=
xff, 0x01, 0x31) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K4510, 0=
xff, 0x01, 0x32) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K4511, 0=
xff, 0x01, 0x31) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K4511, 0=
xff, 0x01, 0x32) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E353, 0x=
ff, 0x01, 0x01) },
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_V640) },
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_V620) },
diff --git a/drivers/usb/serial/pl2303.c b/drivers/usb/serial/pl2303.c
index 30461fc..0c20831 100644
--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -91,6 +91,7 @@ static const struct usb_device_id id_table[] =3D {
 	{ USB_DEVICE(SONY_VENDOR_ID, SONY_QN3USB_PRODUCT_ID) },
 	{ USB_DEVICE(SANWA_VENDOR_ID, SANWA_PRODUCT_ID) },
 	{ USB_DEVICE(ADLINK_VENDOR_ID, ADLINK_ND6530_PRODUCT_ID) },
+	{ USB_DEVICE(WINCHIPHEAD_VENDOR_ID, WINCHIPHEAD_USBSER_PRODUCT_ID) },
 	{ }					/* Terminating entry */
 };
=20
diff --git a/drivers/usb/serial/pl2303.h b/drivers/usb/serial/pl2303.h
index 1b025f7..ca0d237 100644
--- a/drivers/usb/serial/pl2303.h
+++ b/drivers/usb/serial/pl2303.h
@@ -144,3 +144,7 @@
 /* ADLINK ND-6530 RS232,RS485 and RS422 adapter */
 #define ADLINK_VENDOR_ID		0x0b63
 #define ADLINK_ND6530_PRODUCT_ID	0x6530
+
+/* WinChipHead USB->RS 232 adapter */
+#define WINCHIPHEAD_VENDOR_ID		0x4348
+#define WINCHIPHEAD_USBSER_PRODUCT_ID	0x5523
diff --git a/drivers/usb/serial/qcserial.c b/drivers/usb/serial/qcserial.c
index 54a9dab..27f9ae4 100644
--- a/drivers/usb/serial/qcserial.c
+++ b/drivers/usb/serial/qcserial.c
@@ -45,6 +45,7 @@ static const struct usb_device_id id_table[] =3D {
 	{USB_DEVICE(0x05c6, 0x9203)},	/* Generic Gobi Modem device */
 	{USB_DEVICE(0x05c6, 0x9222)},	/* Generic Gobi Modem device */
 	{USB_DEVICE(0x05c6, 0x9008)},	/* Generic Gobi QDL device */
+	{USB_DEVICE(0x05c6, 0x9009)},	/* Generic Gobi Modem device */
 	{USB_DEVICE(0x05c6, 0x9201)},	/* Generic Gobi QDL device */
 	{USB_DEVICE(0x05c6, 0x9221)},	/* Generic Gobi QDL device */
 	{USB_DEVICE(0x05c6, 0x9231)},	/* Generic Gobi QDL device */
diff --git a/drivers/usb/storage/unusual_devs.h b/drivers/usb/storage/unusu=
al_devs.h
index ccff348..3041a97 100644
--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -1988,6 +1988,16 @@ UNUSUAL_DEV(  0x4146, 0xba01, 0x0100, 0x0100,
 		"Micro Mini 1GB",
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL, US_FL_NOT_LOCKABLE ),
=20
+/*
+ * Nick Bowler <nbowler@elliptictech.com>
+ * SCSI stack spams (otherwise harmless) error messages.
+ */
+UNUSUAL_DEV(  0xc251, 0x4003, 0x0100, 0x0100,
+		"Keil Software, Inc.",
+		"V2M MotherBoard",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_NOT_LOCKABLE),
+
 /* Reported by Andrew Simmons <andrew.simmons@gmail.com> */
 UNUSUAL_DEV(  0xed06, 0x4500, 0x0001, 0x0001,
 		"DataStor",
diff --git a/drivers/watchdog/shwdt.c b/drivers/watchdog/shwdt.c
index db84f23..a267dc0 100644
--- a/drivers/watchdog/shwdt.c
+++ b/drivers/watchdog/shwdt.c
@@ -64,7 +64,7 @@
  * misses its deadline, the kernel timer will allow the WDT to overflow.
  */
 static int clock_division_ratio =3D WTCSR_CKS_4096;
-#define next_ping_period(cks)	msecs_to_jiffies(cks - 4)
+#define next_ping_period(cks)	(jiffies + msecs_to_jiffies(cks - 4))
=20
 static const struct watchdog_info sh_wdt_info;
 static struct platform_device *sh_wdt_dev;
diff --git a/fs/befs/linuxvfs.c b/fs/befs/linuxvfs.c
index 54b8c28..720d885 100644
--- a/fs/befs/linuxvfs.c
+++ b/fs/befs/linuxvfs.c
@@ -474,17 +474,22 @@ befs_follow_link(struct dentry *dentry, struct nameid=
ata *nd)
 		befs_data_stream *data =3D &befs_ino->i_data.ds;
 		befs_off_t len =3D data->size;
=20
-		befs_debug(sb, "Follow long symlink");
-
-		link =3D kmalloc(len, GFP_NOFS);
-		if (!link) {
-			link =3D ERR_PTR(-ENOMEM);
-		} else if (befs_read_lsymlink(sb, data, link, len) !=3D len) {
-			kfree(link);
-			befs_error(sb, "Failed to read entire long symlink");
+		if (len =3D=3D 0) {
+			befs_error(sb, "Long symlink with illegal length");
 			link =3D ERR_PTR(-EIO);
 		} else {
-			link[len - 1] =3D '\0';
+			befs_debug(sb, "Follow long symlink");
+
+			link =3D kmalloc(len, GFP_NOFS);
+			if (!link) {
+				link =3D ERR_PTR(-ENOMEM);
+			} else if (befs_read_lsymlink(sb, data, link, len) !=3D len) {
+				kfree(link);
+				befs_error(sb, "Failed to read entire long symlink");
+				link =3D ERR_PTR(-EIO);
+			} else {
+				link[len - 1] =3D '\0';
+			}
 		}
 	} else {
 		link =3D befs_ino->i_data.symlink;
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 71cd456..7e20a65 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1784,6 +1784,9 @@ static int btrfs_discard_extent(struct btrfs_root *ro=
ot, u64 bytenr,
=20
=20
 		for (i =3D 0; i < multi->num_stripes; i++, stripe++) {
+			if (!stripe->dev->can_discard)
+				continue;
+
 			ret =3D btrfs_issue_discard(stripe->dev->bdev,
 						  stripe->physical,
 						  stripe->length);
@@ -1791,11 +1794,16 @@ static int btrfs_discard_extent(struct btrfs_root *=
root, u64 bytenr,
 				discarded_bytes +=3D stripe->length;
 			else if (ret !=3D -EOPNOTSUPP)
 				break;
+
+			/*
+			 * Just in case we get back EOPNOTSUPP for some reason,
+			 * just ignore the return value so we don't screw up
+			 * people calling discard_extent.
+			 */
+			ret =3D 0;
 		}
 		kfree(multi);
 	}
-	if (discarded_bytes && ret =3D=3D -EOPNOTSUPP)
-		ret =3D 0;
=20
 	if (actual_bytes)
 		*actual_bytes =3D discarded_bytes;
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 4ce8a9f..7fa128d 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -799,14 +799,15 @@ static noinline int add_inode_ref(struct btrfs_trans_=
handle *trans,
 				  struct extent_buffer *eb, int slot,
 				  struct btrfs_key *key)
 {
-	struct inode *dir;
-	int ret;
 	struct btrfs_inode_ref *ref;
+	struct btrfs_dir_item *di;
+	struct inode *dir;
 	struct inode *inode;
-	char *name;
-	int namelen;
 	unsigned long ref_ptr;
 	unsigned long ref_end;
+	char *name;
+	int namelen;
+	int ret;
 	int search_done =3D 0;
=20
 	/*
@@ -909,6 +910,25 @@ again:
 	}
 	btrfs_release_path(path);
=20
+	/* look for a conflicting sequence number */
+	di =3D btrfs_lookup_dir_index_item(trans, root, path, btrfs_ino(dir),
+					 btrfs_inode_ref_index(eb, ref),
+					 name, namelen, 0);
+	if (di && !IS_ERR(di)) {
+		ret =3D drop_one_dir_item(trans, root, path, dir, di);
+		BUG_ON(ret);
+	}
+	btrfs_release_path(path);
+
+	/* look for a conflicing name */
+	di =3D btrfs_lookup_dir_item(trans, root, path, btrfs_ino(dir),
+				   name, namelen, 0);
+	if (di && !IS_ERR(di)) {
+		ret =3D drop_one_dir_item(trans, root, path, dir, di);
+		BUG_ON(ret);
+	}
+	btrfs_release_path(path);
+
 insert:
 	/* insert our name */
 	ret =3D btrfs_add_link(trans, dir, inode, name, namelen, 0,
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 19450bc..43baaf0 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -500,6 +500,9 @@ static int __btrfs_close_devices(struct btrfs_fs_device=
s *fs_devices)
 			fs_devices->rw_devices--;
 		}
=20
+		if (device->can_discard)
+			fs_devices->num_can_discard--;
+
 		new_device =3D kmalloc(sizeof(*new_device), GFP_NOFS);
 		BUG_ON(!new_device);
 		memcpy(new_device, device, sizeof(*new_device));
@@ -508,6 +511,7 @@ static int __btrfs_close_devices(struct btrfs_fs_device=
s *fs_devices)
 		new_device->bdev =3D NULL;
 		new_device->writeable =3D 0;
 		new_device->in_fs_metadata =3D 0;
+		new_device->can_discard =3D 0;
 		list_replace_rcu(&device->dev_list, &new_device->dev_list);
=20
 		call_rcu(&device->rcu, free_device);
@@ -547,6 +551,7 @@ int btrfs_close_devices(struct btrfs_fs_devices *fs_dev=
ices)
 static int __btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 				fmode_t flags, void *holder)
 {
+	struct request_queue *q;
 	struct block_device *bdev;
 	struct list_head *head =3D &fs_devices->devices;
 	struct btrfs_device *device;
@@ -603,6 +608,12 @@ static int __btrfs_open_devices(struct btrfs_fs_device=
s *fs_devices,
 			seeding =3D 0;
 		}
=20
+		q =3D bdev_get_queue(bdev);
+		if (blk_queue_discard(q)) {
+			device->can_discard =3D 1;
+			fs_devices->num_can_discard++;
+		}
+
 		device->bdev =3D bdev;
 		device->in_fs_metadata =3D 0;
 		device->mode =3D flags;
@@ -1542,6 +1553,7 @@ error:
=20
 int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 {
+	struct request_queue *q;
 	struct btrfs_trans_handle *trans;
 	struct btrfs_device *device;
 	struct block_device *bdev;
@@ -1611,6 +1623,9 @@ int btrfs_init_new_device(struct btrfs_root *root, ch=
ar *device_path)
=20
 	lock_chunks(root);
=20
+	q =3D bdev_get_queue(bdev);
+	if (blk_queue_discard(q))
+		device->can_discard =3D 1;
 	device->writeable =3D 1;
 	device->work.func =3D pending_bios_fn;
 	generate_random_uuid(device->uuid);
@@ -1646,6 +1661,8 @@ int btrfs_init_new_device(struct btrfs_root *root, ch=
ar *device_path)
 	root->fs_info->fs_devices->num_devices++;
 	root->fs_info->fs_devices->open_devices++;
 	root->fs_info->fs_devices->rw_devices++;
+	if (device->can_discard)
+		root->fs_info->fs_devices->num_can_discard++;
 	root->fs_info->fs_devices->total_rw_bytes +=3D device->total_bytes;
=20
 	if (!blk_queue_nonrot(bdev_get_queue(bdev)))
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 7c12d61..6d866db 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -48,6 +48,7 @@ struct btrfs_device {
 	int writeable;
 	int in_fs_metadata;
 	int missing;
+	int can_discard;
=20
 	spinlock_t io_lock;
=20
@@ -104,6 +105,7 @@ struct btrfs_fs_devices {
 	u64 rw_devices;
 	u64 missing_devices;
 	u64 total_rw_bytes;
+	u64 num_can_discard;
 	struct block_device *latest_bdev;
=20
 	/* all of the devices in the FS, protected by a mutex
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index bc4b12c..fc7e57b 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -581,6 +581,10 @@ cifs_get_root(struct smb_vol *vol, struct super_block =
*sb)
 		mutex_unlock(&dir->i_mutex);
 		dput(dentry);
 		dentry =3D child;
+		if (!dentry->d_inode) {
+			dput(dentry);
+			dentry =3D ERR_PTR(-ENOENT);
+		}
 	} while (!IS_ERR(dentry));
 	_FreeXid(xid);
 	kfree(full_path);
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index ccc1afa..e0ea721 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2838,7 +2838,8 @@ cleanup_volume_info_contents(struct smb_vol *volume_i=
nfo)
 	kfree(volume_info->username);
 	kzfree(volume_info->password);
 	kfree(volume_info->UNC);
-	kfree(volume_info->UNCip);
+	if (volume_info->UNCip !=3D volume_info->UNC + 2)
+		kfree(volume_info->UNCip);
 	kfree(volume_info->domainname);
 	kfree(volume_info->iocharset);
 	kfree(volume_info->prepath);
diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index fa8c21d..16cdd6d 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -110,8 +110,8 @@ cifs_bp_rename_retry:
 	}
 	rcu_read_unlock();
 	if (namelen !=3D dfsplen || read_seqretry(&rename_lock, seq)) {
-		cERROR(1, "did not end path lookup where expected namelen is %d",
-			namelen);
+		cFYI(1, "did not end path lookup where expected. namelen=3D%d "
+			"dfsplen=3D%d", namelen, dfsplen);
 		/* presumably this is only possible if racing with a rename
 		of one of the parent directories  (we can not lock the dentries
 		above us to prevent this, but retrying should be harmless) */
@@ -641,7 +641,7 @@ lookup_out:
 static int
 cifs_d_revalidate(struct dentry *direntry, struct nameidata *nd)
 {
-	if (nd->flags & LOOKUP_RCU)
+	if (nd && (nd->flags & LOOKUP_RCU))
 		return -ECHILD;
=20
 	if (direntry->d_inode) {
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 9b018c8..a7b2dcd 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -764,20 +764,10 @@ char *cifs_build_path_to_root(struct smb_vol *vol, st=
ruct cifs_sb_info *cifs_sb,
 	if (full_path =3D=3D NULL)
 		return full_path;
=20
-	if (dfsplen) {
+	if (dfsplen)
 		strncpy(full_path, tcon->treeName, dfsplen);
-		/* switch slash direction in prepath depending on whether
-		 * windows or posix style path names
-		 */
-		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIX_PATHS) {
-			int i;
-			for (i =3D 0; i < dfsplen; i++) {
-				if (full_path[i] =3D=3D '\\')
-					full_path[i] =3D '/';
-			}
-		}
-	}
 	strncpy(full_path + dfsplen, vol->prepath, pplen);
+	convert_delimiter(full_path, CIFS_DIR_SEP(cifs_sb));
 	full_path[dfsplen + pplen] =3D 0; /* add trailing null */
 	return full_path;
 }
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 147aa22..c1b9c4b 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -362,6 +362,8 @@ cifs_call_async(struct TCP_Server_Info *server, struct =
kvec *iov,
 	mid =3D AllocMidQEntry(hdr, server);
 	if (mid =3D=3D NULL) {
 		mutex_unlock(&server->srv_mutex);
+		atomic_dec(&server->inFlight);
+		wake_up(&server->request_q);
 		return -ENOMEM;
 	}
=20
diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index 7349ade..4a4fad7 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -69,6 +69,7 @@ static int ecryptfs_inode_set(struct inode *inode, void *=
opaque)
 	inode->i_ino =3D lower_inode->i_ino;
 	inode->i_version++;
 	inode->i_mapping->a_ops =3D &ecryptfs_aops;
+	inode->i_mapping->backing_dev_info =3D inode->i_sb->s_bdi;
=20
 	if (S_ISLNK(inode->i_mode))
 		inode->i_op =3D &ecryptfs_symlink_iops;
diff --git a/fs/ecryptfs/keystore.c b/fs/ecryptfs/keystore.c
index 27a7fef..89dc18e 100644
--- a/fs/ecryptfs/keystore.c
+++ b/fs/ecryptfs/keystore.c
@@ -1868,11 +1868,6 @@ int ecryptfs_parse_packet_set(struct ecryptfs_crypt_=
stat *crypt_stat,
 	 * just one will be sufficient to decrypt to get the FEK. */
 find_next_matching_auth_tok:
 	found_auth_tok =3D 0;
-	if (auth_tok_key) {
-		up_write(&(auth_tok_key->sem));
-		key_put(auth_tok_key);
-		auth_tok_key =3D NULL;
-	}
 	list_for_each_entry(auth_tok_list_item, &auth_tok_list, list) {
 		candidate_auth_tok =3D &auth_tok_list_item->auth_tok;
 		if (unlikely(ecryptfs_verbosity > 0)) {
@@ -1909,14 +1904,22 @@ found_matching_auth_tok:
 		memcpy(&(candidate_auth_tok->token.private_key),
 		       &(matching_auth_tok->token.private_key),
 		       sizeof(struct ecryptfs_private_key));
+		up_write(&(auth_tok_key->sem));
+		key_put(auth_tok_key);
 		rc =3D decrypt_pki_encrypted_session_key(candidate_auth_tok,
 						       crypt_stat);
 	} else if (candidate_auth_tok->token_type =3D=3D ECRYPTFS_PASSWORD) {
 		memcpy(&(candidate_auth_tok->token.password),
 		       &(matching_auth_tok->token.password),
 		       sizeof(struct ecryptfs_password));
+		up_write(&(auth_tok_key->sem));
+		key_put(auth_tok_key);
 		rc =3D decrypt_passphrase_encrypted_session_key(
 			candidate_auth_tok, crypt_stat);
+	} else {
+		up_write(&(auth_tok_key->sem));
+		key_put(auth_tok_key);
+		rc =3D -EINVAL;
 	}
 	if (rc) {
 		struct ecryptfs_auth_tok_list_item *auth_tok_list_item_tmp;
@@ -1956,15 +1959,12 @@ found_matching_auth_tok:
 out_wipe_list:
 	wipe_auth_tok_list(&auth_tok_list);
 out:
-	if (auth_tok_key) {
-		up_write(&(auth_tok_key->sem));
-		key_put(auth_tok_key);
-	}
 	return rc;
 }
=20
 static int
-pki_encrypt_session_key(struct ecryptfs_auth_tok *auth_tok,
+pki_encrypt_session_key(struct key *auth_tok_key,
+			struct ecryptfs_auth_tok *auth_tok,
 			struct ecryptfs_crypt_stat *crypt_stat,
 			struct ecryptfs_key_record *key_rec)
 {
@@ -1979,6 +1979,8 @@ pki_encrypt_session_key(struct ecryptfs_auth_tok *aut=
h_tok,
 					 crypt_stat->cipher,
 					 crypt_stat->key_size),
 				 crypt_stat, &payload, &payload_len);
+	up_write(&(auth_tok_key->sem));
+	key_put(auth_tok_key);
 	if (rc) {
 		ecryptfs_printk(KERN_ERR, "Error generating tag 66 packet\n");
 		goto out;
@@ -2008,6 +2010,8 @@ out:
  * write_tag_1_packet - Write an RFC2440-compatible tag 1 (public key) pac=
ket
  * @dest: Buffer into which to write the packet
  * @remaining_bytes: Maximum number of bytes that can be writtn
+ * @auth_tok_key: The authentication token key to unlock and put when done=
 with
+ *                @auth_tok
  * @auth_tok: The authentication token used for generating the tag 1 packet
  * @crypt_stat: The cryptographic context
  * @key_rec: The key record struct for the tag 1 packet
@@ -2018,7 +2022,7 @@ out:
  */
 static int
 write_tag_1_packet(char *dest, size_t *remaining_bytes,
-		   struct ecryptfs_auth_tok *auth_tok,
+		   struct key *auth_tok_key, struct ecryptfs_auth_tok *auth_tok,
 		   struct ecryptfs_crypt_stat *crypt_stat,
 		   struct ecryptfs_key_record *key_rec, size_t *packet_size)
 {
@@ -2039,12 +2043,15 @@ write_tag_1_packet(char *dest, size_t *remaining_by=
tes,
 		memcpy(key_rec->enc_key,
 		       auth_tok->session_key.encrypted_key,
 		       auth_tok->session_key.encrypted_key_size);
+		up_write(&(auth_tok_key->sem));
+		key_put(auth_tok_key);
 		goto encrypted_session_key_set;
 	}
 	if (auth_tok->session_key.encrypted_key_size =3D=3D 0)
 		auth_tok->session_key.encrypted_key_size =3D
 			auth_tok->token.private_key.key_size;
-	rc =3D pki_encrypt_session_key(auth_tok, crypt_stat, key_rec);
+	rc =3D pki_encrypt_session_key(auth_tok_key, auth_tok, crypt_stat,
+				     key_rec);
 	if (rc) {
 		printk(KERN_ERR "Failed to encrypt session key via a key "
 		       "module; rc =3D [%d]\n", rc);
@@ -2421,6 +2428,8 @@ ecryptfs_generate_key_packet_set(char *dest_base,
 						&max, auth_tok,
 						crypt_stat, key_rec,
 						&written);
+			up_write(&(auth_tok_key->sem));
+			key_put(auth_tok_key);
 			if (rc) {
 				ecryptfs_printk(KERN_WARNING, "Error "
 						"writing tag 3 packet\n");
@@ -2438,8 +2447,8 @@ ecryptfs_generate_key_packet_set(char *dest_base,
 			}
 			(*len) +=3D written;
 		} else if (auth_tok->token_type =3D=3D ECRYPTFS_PRIVATE_KEY) {
-			rc =3D write_tag_1_packet(dest_base + (*len),
-						&max, auth_tok,
+			rc =3D write_tag_1_packet(dest_base + (*len), &max,
+						auth_tok_key, auth_tok,
 						crypt_stat, key_rec, &written);
 			if (rc) {
 				ecryptfs_printk(KERN_WARNING, "Error "
@@ -2448,14 +2457,13 @@ ecryptfs_generate_key_packet_set(char *dest_base,
 			}
 			(*len) +=3D written;
 		} else {
+			up_write(&(auth_tok_key->sem));
+			key_put(auth_tok_key);
 			ecryptfs_printk(KERN_WARNING, "Unsupported "
 					"authentication token type\n");
 			rc =3D -EINVAL;
 			goto out_free;
 		}
-		up_write(&(auth_tok_key->sem));
-		key_put(auth_tok_key);
-		auth_tok_key =3D NULL;
 	}
 	if (likely(max > 0)) {
 		dest_base[(*len)] =3D 0x00;
@@ -2468,11 +2476,6 @@ out_free:
 out:
 	if (rc)
 		(*len) =3D 0;
-	if (auth_tok_key) {
-		up_write(&(auth_tok_key->sem));
-		key_put(auth_tok_key);
-	}
-
 	mutex_unlock(&crypt_stat->keysig_list_mutex);
 	return rc;
 }
diff --git a/fs/ecryptfs/main.c b/fs/ecryptfs/main.c
index 9f1bb74..b4a6bef 100644
--- a/fs/ecryptfs/main.c
+++ b/fs/ecryptfs/main.c
@@ -175,6 +175,7 @@ enum { ecryptfs_opt_sig, ecryptfs_opt_ecryptfs_sig,
        ecryptfs_opt_encrypted_view, ecryptfs_opt_fnek_sig,
        ecryptfs_opt_fn_cipher, ecryptfs_opt_fn_cipher_key_bytes,
        ecryptfs_opt_unlink_sigs, ecryptfs_opt_mount_auth_tok_only,
+       ecryptfs_opt_check_dev_ruid,
        ecryptfs_opt_err };
=20
 static const match_table_t tokens =3D {
@@ -191,6 +192,7 @@ static const match_table_t tokens =3D {
 	{ecryptfs_opt_fn_cipher_key_bytes, "ecryptfs_fn_key_bytes=3D%u"},
 	{ecryptfs_opt_unlink_sigs, "ecryptfs_unlink_sigs"},
 	{ecryptfs_opt_mount_auth_tok_only, "ecryptfs_mount_auth_tok_only"},
+	{ecryptfs_opt_check_dev_ruid, "ecryptfs_check_dev_ruid"},
 	{ecryptfs_opt_err, NULL}
 };
=20
@@ -236,6 +238,7 @@ static void ecryptfs_init_mount_crypt_stat(
  * ecryptfs_parse_options
  * @sb: The ecryptfs super block
  * @options: The options passed to the kernel
+ * @check_ruid: set to 1 if device uid should be checked against the ruid
  *
  * Parse mount options:
  * debug=3DN 	   - ecryptfs_verbosity level for debug output
@@ -251,7 +254,8 @@ static void ecryptfs_init_mount_crypt_stat(
  *
  * Returns zero on success; non-zero on error
  */
-static int ecryptfs_parse_options(struct ecryptfs_sb_info *sbi, char *opti=
ons)
+static int ecryptfs_parse_options(struct ecryptfs_sb_info *sbi, char *opti=
ons,
+				  uid_t *check_ruid)
 {
 	char *p;
 	int rc =3D 0;
@@ -276,6 +280,8 @@ static int ecryptfs_parse_options(struct ecryptfs_sb_in=
fo *sbi, char *options)
 	char *cipher_key_bytes_src;
 	char *fn_cipher_key_bytes_src;
=20
+	*check_ruid =3D 0;
+
 	if (!options) {
 		rc =3D -EINVAL;
 		goto out;
@@ -380,6 +386,9 @@ static int ecryptfs_parse_options(struct ecryptfs_sb_in=
fo *sbi, char *options)
 			mount_crypt_stat->flags |=3D
 				ECRYPTFS_GLOBAL_MOUNT_AUTH_TOK_ONLY;
 			break;
+		case ecryptfs_opt_check_dev_ruid:
+			*check_ruid =3D 1;
+			break;
 		case ecryptfs_opt_err:
 		default:
 			printk(KERN_WARNING
@@ -475,6 +484,7 @@ static struct dentry *ecryptfs_mount(struct file_system=
_type *fs_type, int flags
 	const char *err =3D "Getting sb failed";
 	struct inode *inode;
 	struct path path;
+	uid_t check_ruid;
 	int rc;
=20
 	sbi =3D kmem_cache_zalloc(ecryptfs_sb_info_cache, GFP_KERNEL);
@@ -483,7 +493,7 @@ static struct dentry *ecryptfs_mount(struct file_system=
_type *fs_type, int flags
 		goto out;
 	}
=20
-	rc =3D ecryptfs_parse_options(sbi, raw_data);
+	rc =3D ecryptfs_parse_options(sbi, raw_data, &check_ruid);
 	if (rc) {
 		err =3D "Error parsing options";
 		goto out;
@@ -521,6 +531,15 @@ static struct dentry *ecryptfs_mount(struct file_syste=
m_type *fs_type, int flags
 			"known incompatibilities\n");
 		goto out_free;
 	}
+
+	if (check_ruid && path.dentry->d_inode->i_uid !=3D current_uid()) {
+		rc =3D -EPERM;
+		printk(KERN_ERR "Mount of device (uid: %d) not owned by "
+		       "requested user (uid: %d)\n",
+		       path.dentry->d_inode->i_uid, current_uid());
+		goto out_free;
+	}
+
 	ecryptfs_set_superblock_lower(s, path.dentry->d_sb);
 	s->s_maxbytes =3D path.dentry->d_sb->s_maxbytes;
 	s->s_blocksize =3D path.dentry->d_sb->s_blocksize;
diff --git a/fs/ecryptfs/read_write.c b/fs/ecryptfs/read_write.c
index 85d4309..3745f7c 100644
--- a/fs/ecryptfs/read_write.c
+++ b/fs/ecryptfs/read_write.c
@@ -39,15 +39,16 @@
 int ecryptfs_write_lower(struct inode *ecryptfs_inode, char *data,
 			 loff_t offset, size_t size)
 {
-	struct ecryptfs_inode_info *inode_info;
+	struct file *lower_file;
 	mm_segment_t fs_save;
 	ssize_t rc;
=20
-	inode_info =3D ecryptfs_inode_to_private(ecryptfs_inode);
-	BUG_ON(!inode_info->lower_file);
+	lower_file =3D ecryptfs_inode_to_private(ecryptfs_inode)->lower_file;
+	if (!lower_file)
+		return -EIO;
 	fs_save =3D get_fs();
 	set_fs(get_ds());
-	rc =3D vfs_write(inode_info->lower_file, data, size, &offset);
+	rc =3D vfs_write(lower_file, data, size, &offset);
 	set_fs(fs_save);
 	mark_inode_dirty_sync(ecryptfs_inode);
 	return rc;
@@ -225,15 +226,16 @@ out:
 int ecryptfs_read_lower(char *data, loff_t offset, size_t size,
 			struct inode *ecryptfs_inode)
 {
-	struct ecryptfs_inode_info *inode_info =3D
-		ecryptfs_inode_to_private(ecryptfs_inode);
+	struct file *lower_file;
 	mm_segment_t fs_save;
 	ssize_t rc;
=20
-	BUG_ON(!inode_info->lower_file);
+	lower_file =3D ecryptfs_inode_to_private(ecryptfs_inode)->lower_file;
+	if (!lower_file)
+		return -EIO;
 	fs_save =3D get_fs();
 	set_fs(get_ds());
-	rc =3D vfs_read(inode_info->lower_file, data, size, &offset);
+	rc =3D vfs_read(lower_file, data, size, &offset);
 	set_fs(fs_save);
 	return rc;
 }
diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
index 34b6d9b..e5a7111 100644
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -2210,9 +2210,11 @@ static int ext3_symlink (struct inode * dir,
 		/*
 		 * For non-fast symlinks, we just allocate inode and put it on
 		 * orphan list in the first transaction =3D> we need bitmap,
-		 * group descriptor, sb, inode block, quota blocks.
+		 * group descriptor, sb, inode block, quota blocks, and
+		 * possibly selinux xattr blocks.
 		 */
-		credits =3D 4 + EXT3_MAXQUOTAS_INIT_BLOCKS(dir->i_sb);
+		credits =3D 4 + EXT3_MAXQUOTAS_INIT_BLOCKS(dir->i_sb) +
+			  EXT3_XATTR_TRANS_BLOCKS;
 	} else {
 		/*
 		 * Fast symlink. We have to add entry to directory
diff --git a/fs/ext3/xattr.c b/fs/ext3/xattr.c
index 32e6cc2..d565759 100644
--- a/fs/ext3/xattr.c
+++ b/fs/ext3/xattr.c
@@ -803,8 +803,16 @@ inserted:
 			/* We need to allocate a new block */
 			ext3_fsblk_t goal =3D ext3_group_first_block_no(sb,
 						EXT3_I(inode)->i_block_group);
-			ext3_fsblk_t block =3D ext3_new_block(handle, inode,
-							goal, &error);
+			ext3_fsblk_t block;
+
+			/*
+			 * Protect us agaist concurrent allocations to the
+			 * same inode from ext3_..._writepage(). Reservation
+			 * code does not expect racing allocations.
+			 */
+			mutex_lock(&EXT3_I(inode)->truncate_mutex);
+			block =3D ext3_new_block(handle, inode, goal, &error);
+			mutex_unlock(&EXT3_I(inode)->truncate_mutex);
 			if (error)
 				goto cleanup;
 			ea_idebug(inode, "creating block %d", block);
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 1921392..354619a 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -526,6 +526,7 @@ struct ext4_new_group_data {
 #define EXT4_FREE_BLOCKS_METADATA	0x0001
 #define EXT4_FREE_BLOCKS_FORGET		0x0002
 #define EXT4_FREE_BLOCKS_VALIDATED	0x0004
+#define EXT4_FREE_BLOCKS_NO_QUOT_UPDATE	0x0008
=20
 /*
  * ioctl commands
diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
index bb85757..5802fa1 100644
--- a/fs/ext4/ext4_jbd2.h
+++ b/fs/ext4/ext4_jbd2.h
@@ -289,10 +289,10 @@ static inline int ext4_should_order_data(struct inode=
 *inode)
=20
 static inline int ext4_should_writeback_data(struct inode *inode)
 {
-	if (!S_ISREG(inode->i_mode))
-		return 0;
 	if (EXT4_JOURNAL(inode) =3D=3D NULL)
 		return 1;
+	if (!S_ISREG(inode->i_mode))
+		return 0;
 	if (ext4_test_inode_flag(inode, EXT4_INODE_JOURNAL_DATA))
 		return 0;
 	if (test_opt(inode->i_sb, DATA_FLAGS) =3D=3D EXT4_MOUNT_WRITEBACK_DATA)
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index f815cc8..f3aacb3 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3596,17 +3596,18 @@ int ext4_ext_map_blocks(handle_t *handle, struct in=
ode *inode,
 	}
=20
 	err =3D check_eofblocks_fl(handle, inode, map->m_lblk, path, ar.len);
-	if (err)
-		goto out2;
-
-	err =3D ext4_ext_insert_extent(handle, inode, path, &newex, flags);
+	if (!err)
+		err =3D ext4_ext_insert_extent(handle, inode, path,
+					     &newex, flags);
 	if (err) {
+		int fb_flags =3D flags & EXT4_GET_BLOCKS_DELALLOC_RESERVE ?
+			EXT4_FREE_BLOCKS_NO_QUOT_UPDATE : 0;
 		/* free data blocks we just allocated */
 		/* not a good idea to call discard here directly,
 		 * but otherwise we'd need to call it every free() */
 		ext4_discard_preallocations(inode);
 		ext4_free_blocks(handle, inode, NULL, ext4_ext_pblock(&newex),
-				 ext4_ext_get_actual_len(&newex), 0);
+				 ext4_ext_get_actual_len(&newex), fb_flags);
 		goto out2;
 	}
=20
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index e3126c0..b864839 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -189,6 +189,12 @@ void ext4_evict_inode(struct inode *inode)
 	int err;
=20
 	trace_ext4_evict_inode(inode);
+
+	mutex_lock(&inode->i_mutex);
+	ext4_flush_completed_IO(inode);
+	mutex_unlock(&inode->i_mutex);
+	ext4_ioend_wait(inode);
+
 	if (inode->i_nlink) {
 		truncate_inode_pages(&inode->i_data, 0);
 		goto no_delete;
@@ -1849,6 +1855,8 @@ static int ext4_journalled_write_end(struct file *fil=
e,
 	from =3D pos & (PAGE_CACHE_SIZE - 1);
 	to =3D from + len;
=20
+	BUG_ON(!ext4_handle_valid(handle));
+
 	if (copied < len) {
 		if (!PageUptodate(page))
 			copied =3D 0;
@@ -2148,7 +2156,12 @@ static int mpage_da_submit_io(struct mpage_da_data *=
mpd,
 			else if (test_opt(inode->i_sb, MBLK_IO_SUBMIT))
 				err =3D ext4_bio_write_page(&io_submit, page,
 							  len, mpd->wbc);
-			else
+			else if (buffer_uninit(page_bufs)) {
+				ext4_set_bh_endio(page_bufs, inode);
+				err =3D block_write_full_page_endio(page,
+					noalloc_get_block_write,
+					mpd->wbc, ext4_end_io_buffer_write);
+			} else
 				err =3D block_write_full_page(page,
 					noalloc_get_block_write, mpd->wbc);
=20
@@ -2564,6 +2577,8 @@ static int __ext4_journalled_writepage(struct page *p=
age,
 		goto out;
 	}
=20
+	BUG_ON(!ext4_handle_valid(handle));
+
 	ret =3D walk_page_buffers(handle, page_bufs, 0, len, NULL,
 				do_journal_get_write_access);
=20
@@ -3635,8 +3650,15 @@ static void ext4_end_io_buffer_write(struct buffer_h=
ead *bh, int uptodate)
 		goto out;
 	}
=20
-	io_end->flag =3D EXT4_IO_END_UNWRITTEN;
+	/*
+	 * It may be over-defensive here to check EXT4_IO_END_UNWRITTEN now,
+	 * but being more careful is always safe for the future change.
+	 */
 	inode =3D io_end->inode;
+	if (!(io_end->flag & EXT4_IO_END_UNWRITTEN)) {
+		io_end->flag |=3D EXT4_IO_END_UNWRITTEN;
+		atomic_inc(&EXT4_I(inode)->i_aiodio_unwritten);
+	}
=20
 	/* Add the io_end to per-inode completed io list*/
 	spin_lock_irqsave(&EXT4_I(inode)->i_completed_io_lock, flags);
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 6ed859d..0f1be7f 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4637,7 +4637,7 @@ do_more:
 	}
 	ext4_mark_super_dirty(sb);
 error_return:
-	if (freed)
+	if (freed && !(flags & EXT4_FREE_BLOCKS_NO_QUOT_UPDATE))
 		dquot_free_block(inode, freed);
 	brelse(bitmap_bh);
 	ext4_std_error(sb, err);
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index b754b77..458a394 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2264,9 +2264,11 @@ static int ext4_symlink(struct inode *dir,
 		/*
 		 * For non-fast symlinks, we just allocate inode and put it on
 		 * orphan list in the first transaction =3D> we need bitmap,
-		 * group descriptor, sb, inode block, quota blocks.
+		 * group descriptor, sb, inode block, quota blocks, and
+		 * possibly selinux xattr blocks.
 		 */
-		credits =3D 4 + EXT4_MAXQUOTAS_INIT_BLOCKS(dir->i_sb);
+		credits =3D 4 + EXT4_MAXQUOTAS_INIT_BLOCKS(dir->i_sb) +
+			  EXT4_XATTR_TRANS_BLOCKS;
 	} else {
 		/*
 		 * Fast symlink. We have to add entry to directory
diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index 7bb8f76..97e5e98 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -338,8 +338,10 @@ submit_and_retry:
 	if ((io_end->num_io_pages >=3D MAX_IO_PAGES) &&
 	    (io_end->pages[io_end->num_io_pages-1] !=3D io_page))
 		goto submit_and_retry;
-	if (buffer_uninit(bh))
-		io->io_end->flag |=3D EXT4_IO_END_UNWRITTEN;
+	if (buffer_uninit(bh) && !(io_end->flag & EXT4_IO_END_UNWRITTEN)) {
+		io_end->flag |=3D EXT4_IO_END_UNWRITTEN;
+		atomic_inc(&EXT4_I(inode)->i_aiodio_unwritten);
+	}
 	io->io_end->size +=3D bh->b_size;
 	io->io_next_block++;
 	ret =3D bio_add_page(io->io_bio, bh->b_page, bh->b_size, bh_offset(bh));
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 9ea71aa..111ed9d 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -892,7 +892,6 @@ static void ext4_i_callback(struct rcu_head *head)
=20
 static void ext4_destroy_inode(struct inode *inode)
 {
-	ext4_ioend_wait(inode);
 	if (!list_empty(&(EXT4_I(inode)->i_orphan))) {
 		ext4_msg(inode->i_sb, KERN_ERR,
 			 "Inode %lu (%p): orphan list check failed!",
diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 640fc22..168a80f 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -1358,6 +1358,10 @@ static int fuse_notify_inval_entry(struct fuse_conn =
*fc, unsigned int size,
 	if (outarg.namelen > FUSE_NAME_MAX)
 		goto err;
=20
+	err =3D -EINVAL;
+	if (size !=3D sizeof(outarg) + outarg.namelen + 1)
+		goto err;
+
 	name.name =3D buf;
 	name.len =3D outarg.namelen;
 	err =3D fuse_copy_one(cs, buf, outarg.namelen + 1);
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 2a77071..fa780e6 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -1018,13 +1018,13 @@ hostdata_error:
 		fsname++;
 	if (lm->lm_mount =3D=3D NULL) {
 		fs_info(sdp, "Now mounting FS...\n");
-		complete(&sdp->sd_locking_init);
+		complete_all(&sdp->sd_locking_init);
 		return 0;
 	}
 	ret =3D lm->lm_mount(sdp, fsname);
 	if (ret =3D=3D 0)
 		fs_info(sdp, "Joined cluster. Now mounting FS...\n");
-	complete(&sdp->sd_locking_init);
+	complete_all(&sdp->sd_locking_init);
 	return ret;
 }
=20
diff --git a/fs/nfs/callback.h b/fs/nfs/callback.h
index b257383..07df5f1 100644
--- a/fs/nfs/callback.h
+++ b/fs/nfs/callback.h
@@ -38,6 +38,7 @@ enum nfs4_callback_opnum {
 struct cb_process_state {
 	__be32			drc_status;
 	struct nfs_client	*clp;
+	int			slotid;
 };
=20
 struct cb_compound_hdr_arg {
@@ -166,7 +167,6 @@ extern unsigned nfs4_callback_layoutrecall(
 	void *dummy, struct cb_process_state *cps);
=20
 extern void nfs4_check_drain_bc_complete(struct nfs4_session *ses);
-extern void nfs4_cb_take_slot(struct nfs_client *clp);
=20
 struct cb_devicenotifyitem {
 	uint32_t		cbd_notify_type;
diff --git a/fs/nfs/callback_proc.c b/fs/nfs/callback_proc.c
index d4d1954..aaa09e9 100644
--- a/fs/nfs/callback_proc.c
+++ b/fs/nfs/callback_proc.c
@@ -333,7 +333,7 @@ validate_seqid(struct nfs4_slot_table *tbl, struct cb_s=
equenceargs * args)
 	/* Normal */
 	if (likely(args->csa_sequenceid =3D=3D slot->seq_nr + 1)) {
 		slot->seq_nr++;
-		return htonl(NFS4_OK);
+		goto out_ok;
 	}
=20
 	/* Replay */
@@ -352,11 +352,14 @@ validate_seqid(struct nfs4_slot_table *tbl, struct cb=
_sequenceargs * args)
 	/* Wraparound */
 	if (args->csa_sequenceid =3D=3D 1 && (slot->seq_nr + 1) =3D=3D 0) {
 		slot->seq_nr =3D 1;
-		return htonl(NFS4_OK);
+		goto out_ok;
 	}
=20
 	/* Misordered request */
 	return htonl(NFS4ERR_SEQ_MISORDERED);
+out_ok:
+	tbl->highest_used_slotid =3D args->csa_slotid;
+	return htonl(NFS4_OK);
 }
=20
 /*
@@ -418,26 +421,37 @@ __be32 nfs4_callback_sequence(struct cb_sequenceargs =
*args,
 			      struct cb_sequenceres *res,
 			      struct cb_process_state *cps)
 {
+	struct nfs4_slot_table *tbl;
 	struct nfs_client *clp;
 	int i;
 	__be32 status =3D htonl(NFS4ERR_BADSESSION);
=20
-	cps->clp =3D NULL;
-
 	clp =3D nfs4_find_client_sessionid(args->csa_addr, &args->csa_sessionid);
 	if (clp =3D=3D NULL)
 		goto out;
=20
+	tbl =3D &clp->cl_session->bc_slot_table;
+
+	spin_lock(&tbl->slot_tbl_lock);
 	/* state manager is resetting the session */
 	if (test_bit(NFS4_SESSION_DRAINING, &clp->cl_session->session_state)) {
-		status =3D NFS4ERR_DELAY;
+		spin_unlock(&tbl->slot_tbl_lock);
+		status =3D htonl(NFS4ERR_DELAY);
+		/* Return NFS4ERR_BADSESSION if we're draining the session
+		 * in order to reset it.
+		 */
+		if (test_bit(NFS4CLNT_SESSION_RESET, &clp->cl_state))
+			status =3D htonl(NFS4ERR_BADSESSION);
 		goto out;
 	}
=20
 	status =3D validate_seqid(&clp->cl_session->bc_slot_table, args);
+	spin_unlock(&tbl->slot_tbl_lock);
 	if (status)
 		goto out;
=20
+	cps->slotid =3D args->csa_slotid;
+
 	/*
 	 * Check for pending referring calls.  If a match is found, a
 	 * related callback was received before the response to the original
@@ -454,7 +468,6 @@ __be32 nfs4_callback_sequence(struct cb_sequenceargs *a=
rgs,
 	res->csr_slotid =3D args->csa_slotid;
 	res->csr_highestslotid =3D NFS41_BC_MAX_CALLBACKS - 1;
 	res->csr_target_highestslotid =3D NFS41_BC_MAX_CALLBACKS - 1;
-	nfs4_cb_take_slot(clp);
=20
 out:
 	cps->clp =3D clp; /* put in nfs4_callback_compound */
diff --git a/fs/nfs/callback_xdr.c b/fs/nfs/callback_xdr.c
index c6c86a7..918ad64 100644
--- a/fs/nfs/callback_xdr.c
+++ b/fs/nfs/callback_xdr.c
@@ -754,26 +754,15 @@ static void nfs4_callback_free_slot(struct nfs4_sessi=
on *session)
 	 * Let the state manager know callback processing done.
 	 * A single slot, so highest used slotid is either 0 or -1
 	 */
-	tbl->highest_used_slotid--;
+	tbl->highest_used_slotid =3D -1;
 	nfs4_check_drain_bc_complete(session);
 	spin_unlock(&tbl->slot_tbl_lock);
 }
=20
-static void nfs4_cb_free_slot(struct nfs_client *clp)
+static void nfs4_cb_free_slot(struct cb_process_state *cps)
 {
-	if (clp && clp->cl_session)
-		nfs4_callback_free_slot(clp->cl_session);
-}
-
-/* A single slot, so highest used slotid is either 0 or -1 */
-void nfs4_cb_take_slot(struct nfs_client *clp)
-{
-	struct nfs4_slot_table *tbl =3D &clp->cl_session->bc_slot_table;
-
-	spin_lock(&tbl->slot_tbl_lock);
-	tbl->highest_used_slotid++;
-	BUG_ON(tbl->highest_used_slotid !=3D 0);
-	spin_unlock(&tbl->slot_tbl_lock);
+	if (cps->slotid !=3D -1)
+		nfs4_callback_free_slot(cps->clp->cl_session);
 }
=20
 #else /* CONFIG_NFS_V4_1 */
@@ -784,7 +773,7 @@ preprocess_nfs41_op(int nop, unsigned int op_nr, struct=
 callback_op **op)
 	return htonl(NFS4ERR_MINOR_VERS_MISMATCH);
 }
=20
-static void nfs4_cb_free_slot(struct nfs_client *clp)
+static void nfs4_cb_free_slot(struct cb_process_state *cps)
 {
 }
 #endif /* CONFIG_NFS_V4_1 */
@@ -866,6 +855,7 @@ static __be32 nfs4_callback_compound(struct svc_rqst *r=
qstp, void *argp, void *r
 	struct cb_process_state cps =3D {
 		.drc_status =3D 0,
 		.clp =3D NULL,
+		.slotid =3D -1,
 	};
 	unsigned int nops =3D 0;
=20
@@ -906,7 +896,7 @@ static __be32 nfs4_callback_compound(struct svc_rqst *r=
qstp, void *argp, void *r
=20
 	*hdr_res.status =3D status;
 	*hdr_res.nops =3D htonl(nops);
-	nfs4_cb_free_slot(cps.clp);
+	nfs4_cb_free_slot(&cps);
 	nfs_put_client(cps.clp);
 	dprintk("%s: done, status =3D %u\n", __func__, ntohl(status));
 	return rpc_success;
diff --git a/fs/nfs/delegation.c b/fs/nfs/delegation.c
index dd25c2a..321a66b 100644
--- a/fs/nfs/delegation.c
+++ b/fs/nfs/delegation.c
@@ -398,12 +398,11 @@ int nfs_inode_return_delegation(struct inode *inode)
 	return err;
 }
=20
-static void nfs_mark_return_delegation(struct nfs_delegation *delegation)
+static void nfs_mark_return_delegation(struct nfs_server *server,
+		struct nfs_delegation *delegation)
 {
-	struct nfs_client *clp =3D NFS_SERVER(delegation->inode)->nfs_client;
-
 	set_bit(NFS_DELEGATION_RETURN, &delegation->flags);
-	set_bit(NFS4CLNT_DELEGRETURN, &clp->cl_state);
+	set_bit(NFS4CLNT_DELEGRETURN, &server->nfs_client->cl_state);
 }
=20
 /**
@@ -441,7 +440,7 @@ static void nfs_mark_return_all_delegation_types(struct=
 nfs_server *server,
 		if ((delegation->type =3D=3D (FMODE_READ|FMODE_WRITE)) && !(flags & FMOD=
E_WRITE))
 			continue;
 		if (delegation->type & flags)
-			nfs_mark_return_delegation(delegation);
+			nfs_mark_return_delegation(server, delegation);
 	}
 }
=20
@@ -508,7 +507,7 @@ static void nfs_mark_return_unreferenced_delegations(st=
ruct nfs_server *server)
 	list_for_each_entry_rcu(delegation, &server->delegations, super_list) {
 		if (test_and_clear_bit(NFS_DELEGATION_REFERENCED, &delegation->flags))
 			continue;
-		nfs_mark_return_delegation(delegation);
+		nfs_mark_return_delegation(server, delegation);
 	}
 }
=20
@@ -539,7 +538,8 @@ void nfs_expire_unreferenced_delegations(struct nfs_cli=
ent *clp)
 int nfs_async_inode_return_delegation(struct inode *inode,
 				      const nfs4_stateid *stateid)
 {
-	struct nfs_client *clp =3D NFS_SERVER(inode)->nfs_client;
+	struct nfs_server *server =3D NFS_SERVER(inode);
+	struct nfs_client *clp =3D server->nfs_client;
 	struct nfs_delegation *delegation;
=20
 	rcu_read_lock();
@@ -549,7 +549,7 @@ int nfs_async_inode_return_delegation(struct inode *ino=
de,
 		rcu_read_unlock();
 		return -ENOENT;
 	}
-	nfs_mark_return_delegation(delegation);
+	nfs_mark_return_delegation(server, delegation);
 	rcu_read_unlock();
=20
 	nfs_delegation_run_state_manager(clp);
diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index ededdbd..f91c62d 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -134,18 +134,19 @@ const struct inode_operations nfs4_dir_inode_operatio=
ns =3D {
=20
 #endif /* CONFIG_NFS_V4 */
=20
-static struct nfs_open_dir_context *alloc_nfs_open_dir_context(struct rpc_=
cred *cred)
+static struct nfs_open_dir_context *alloc_nfs_open_dir_context(struct inod=
e *dir, struct rpc_cred *cred)
 {
 	struct nfs_open_dir_context *ctx;
 	ctx =3D kmalloc(sizeof(*ctx), GFP_KERNEL);
 	if (ctx !=3D NULL) {
 		ctx->duped =3D 0;
+		ctx->attr_gencount =3D NFS_I(dir)->attr_gencount;
 		ctx->dir_cookie =3D 0;
 		ctx->dup_cookie =3D 0;
 		ctx->cred =3D get_rpccred(cred);
-	} else
-		ctx =3D ERR_PTR(-ENOMEM);
-	return ctx;
+		return ctx;
+	}
+	return  ERR_PTR(-ENOMEM);
 }
=20
 static void put_nfs_open_dir_context(struct nfs_open_dir_context *ctx)
@@ -173,7 +174,7 @@ nfs_opendir(struct inode *inode, struct file *filp)
 	cred =3D rpc_lookup_cred();
 	if (IS_ERR(cred))
 		return PTR_ERR(cred);
-	ctx =3D alloc_nfs_open_dir_context(cred);
+	ctx =3D alloc_nfs_open_dir_context(inode, cred);
 	if (IS_ERR(ctx)) {
 		res =3D PTR_ERR(ctx);
 		goto out;
@@ -323,7 +324,6 @@ int nfs_readdir_search_for_pos(struct nfs_cache_array *=
array, nfs_readdir_descri
 {
 	loff_t diff =3D desc->file->f_pos - desc->current_index;
 	unsigned int index;
-	struct nfs_open_dir_context *ctx =3D desc->file->private_data;
=20
 	if (diff < 0)
 		goto out_eof;
@@ -336,7 +336,6 @@ int nfs_readdir_search_for_pos(struct nfs_cache_array *=
array, nfs_readdir_descri
 	index =3D (unsigned int)diff;
 	*desc->dir_cookie =3D array->array[index].cookie;
 	desc->cache_entry_index =3D index;
-	ctx->duped =3D 0;
 	return 0;
 out_eof:
 	desc->eof =3D 1;
@@ -349,14 +348,33 @@ int nfs_readdir_search_for_cookie(struct nfs_cache_ar=
ray *array, nfs_readdir_des
 	int i;
 	loff_t new_pos;
 	int status =3D -EAGAIN;
-	struct nfs_open_dir_context *ctx =3D desc->file->private_data;
=20
 	for (i =3D 0; i < array->size; i++) {
 		if (array->array[i].cookie =3D=3D *desc->dir_cookie) {
+			struct nfs_inode *nfsi =3D NFS_I(desc->file->f_path.dentry->d_inode);
+			struct nfs_open_dir_context *ctx =3D desc->file->private_data;
+
 			new_pos =3D desc->current_index + i;
-			if (new_pos < desc->file->f_pos) {
+			if (ctx->attr_gencount !=3D nfsi->attr_gencount
+			    || (nfsi->cache_validity & (NFS_INO_INVALID_ATTR|NFS_INO_INVALID_DA=
TA))) {
+				ctx->duped =3D 0;
+				ctx->attr_gencount =3D nfsi->attr_gencount;
+			} else if (new_pos < desc->file->f_pos) {
+				if (ctx->duped > 0
+				    && ctx->dup_cookie =3D=3D *desc->dir_cookie) {
+					if (printk_ratelimit()) {
+						pr_notice("NFS: directory %s/%s contains a readdir loop."
+								"Please contact your server vendor.  "
+								"Offending cookie: %llu\n",
+								desc->file->f_dentry->d_parent->d_name.name,
+								desc->file->f_dentry->d_name.name,
+								*desc->dir_cookie);
+					}
+					status =3D -ELOOP;
+					goto out;
+				}
 				ctx->dup_cookie =3D *desc->dir_cookie;
-				ctx->duped =3D 1;
+				ctx->duped =3D -1;
 			}
 			desc->file->f_pos =3D new_pos;
 			desc->cache_entry_index =3D i;
@@ -368,6 +386,7 @@ int nfs_readdir_search_for_cookie(struct nfs_cache_arra=
y *array, nfs_readdir_des
 		if (*desc->dir_cookie =3D=3D array->last_cookie)
 			desc->eof =3D 1;
 	}
+out:
 	return status;
 }
=20
@@ -740,19 +759,6 @@ int nfs_do_filldir(nfs_readdir_descriptor_t *desc, voi=
d *dirent,
 	struct nfs_cache_array *array =3D NULL;
 	struct nfs_open_dir_context *ctx =3D file->private_data;
=20
-	if (ctx->duped !=3D 0 && ctx->dup_cookie =3D=3D *desc->dir_cookie) {
-		if (printk_ratelimit()) {
-			pr_notice("NFS: directory %s/%s contains a readdir loop.  "
-				"Please contact your server vendor.  "
-				"Offending cookie: %llu\n",
-				file->f_dentry->d_parent->d_name.name,
-				file->f_dentry->d_name.name,
-				*desc->dir_cookie);
-		}
-		res =3D -ELOOP;
-		goto out;
-	}
-
 	array =3D nfs_readdir_get_array(desc->page);
 	if (IS_ERR(array)) {
 		res =3D PTR_ERR(array);
@@ -774,6 +780,8 @@ int nfs_do_filldir(nfs_readdir_descriptor_t *desc, void=
 *dirent,
 			*desc->dir_cookie =3D array->array[i+1].cookie;
 		else
 			*desc->dir_cookie =3D array->last_cookie;
+		if (ctx->duped !=3D 0)
+			ctx->duped =3D 1;
 	}
 	if (array->eof_index >=3D 0)
 		desc->eof =3D 1;
@@ -805,6 +813,7 @@ int uncached_readdir(nfs_readdir_descriptor_t *desc, vo=
id *dirent,
 	struct page	*page =3D NULL;
 	int		status;
 	struct inode *inode =3D desc->file->f_path.dentry->d_inode;
+	struct nfs_open_dir_context *ctx =3D desc->file->private_data;
=20
 	dfprintk(DIRCACHE, "NFS: uncached_readdir() searching for cookie %Lu\n",
 			(unsigned long long)*desc->dir_cookie);
@@ -818,6 +827,7 @@ int uncached_readdir(nfs_readdir_descriptor_t *desc, vo=
id *dirent,
 	desc->page_index =3D 0;
 	desc->last_cookie =3D *desc->dir_cookie;
 	desc->page =3D page;
+	ctx->duped =3D 0;
=20
 	status =3D nfs_readdir_xdr_to_array(desc, page, inode);
 	if (status < 0)
diff --git a/fs/nfs/nfs4filelayout.c b/fs/nfs/nfs4filelayout.c
index f9d03ab..614c4d2 100644
--- a/fs/nfs/nfs4filelayout.c
+++ b/fs/nfs/nfs4filelayout.c
@@ -170,7 +170,7 @@ filelayout_set_layoutcommit(struct nfs_write_data *wdat=
a)
=20
 	pnfs_set_layoutcommit(wdata);
 	dprintk("%s ionde %lu pls_end_pos %lu\n", __func__, wdata->inode->i_ino,
-		(unsigned long) wdata->lseg->pls_end_pos);
+		(unsigned long) NFS_I(wdata->inode)->layout->plh_lwb);
 }
=20
 /*
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 5879b23..92cfd2e 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -5850,9 +5850,15 @@ nfs4_layoutcommit_done(struct rpc_task *task, void *=
calldata)
 static void nfs4_layoutcommit_release(void *calldata)
 {
 	struct nfs4_layoutcommit_data *data =3D calldata;
+	struct pnfs_layout_segment *lseg, *tmp;
=20
 	/* Matched by references in pnfs_set_layoutcommit */
-	put_lseg(data->lseg);
+	list_for_each_entry_safe(lseg, tmp, &data->lseg_list, pls_lc_list) {
+		list_del_init(&lseg->pls_lc_list);
+		if (test_and_clear_bit(NFS_LSEG_LAYOUTCOMMIT,
+				       &lseg->pls_flags))
+			put_lseg(lseg);
+	}
 	put_rpccred(data->cred);
 	kfree(data);
 }
diff --git a/fs/nfs/nfs4xdr.c b/fs/nfs/nfs4xdr.c
index e6e8f3b..fc97fd5 100644
--- a/fs/nfs/nfs4xdr.c
+++ b/fs/nfs/nfs4xdr.c
@@ -1888,7 +1888,7 @@ encode_layoutcommit(struct xdr_stream *xdr,
 	*p++ =3D cpu_to_be32(OP_LAYOUTCOMMIT);
 	/* Only whole file layouts */
 	p =3D xdr_encode_hyper(p, 0); /* offset */
-	p =3D xdr_encode_hyper(p, NFS4_MAX_UINT64); /* length */
+	p =3D xdr_encode_hyper(p, args->lastbytewritten + 1);	/* length */
 	*p++ =3D cpu_to_be32(0); /* reclaim */
 	p =3D xdr_encode_opaque_fixed(p, args->stateid.data, NFS4_STATEID_SIZE);
 	*p++ =3D cpu_to_be32(1); /* newoffset =3D TRUE */
diff --git a/fs/nfs/objlayout/objio_osd.c b/fs/nfs/objlayout/objio_osd.c
index 8ff2ea3..1d1dc1e 100644
--- a/fs/nfs/objlayout/objio_osd.c
+++ b/fs/nfs/objlayout/objio_osd.c
@@ -479,7 +479,6 @@ static int _io_check(struct objio_state *ios, bool is_w=
rite)
 	for (i =3D 0; i <  ios->numdevs; i++) {
 		struct osd_sense_info osi;
 		struct osd_request *or =3D ios->per_dev[i].or;
-		unsigned dev;
 		int ret;
=20
 		if (!or)
@@ -500,9 +499,8 @@ static int _io_check(struct objio_state *ios, bool is_w=
rite)
=20
 			continue; /* we recovered */
 		}
-		dev =3D ios->per_dev[i].dev;
-		objlayout_io_set_result(&ios->ol_state, dev,
-					&ios->layout->comps[dev].oc_object_id,
+		objlayout_io_set_result(&ios->ol_state, i,
+					&ios->layout->comps[i].oc_object_id,
 					osd_pri_2_pnfs_err(osi.osd_err_pri),
 					ios->per_dev[i].offset,
 					ios->per_dev[i].length,
@@ -589,22 +587,19 @@ static void _calc_stripe_info(struct objio_state *ios=
, u64 file_offset,
 }
=20
 static int _add_stripe_unit(struct objio_state *ios,  unsigned *cur_pg,
-		unsigned pgbase, struct _objio_per_comp *per_dev, int cur_len,
+		unsigned pgbase, struct _objio_per_comp *per_dev, int len,
 		gfp_t gfp_flags)
 {
 	unsigned pg =3D *cur_pg;
+	int cur_len =3D len;
 	struct request_queue *q =3D
 			osd_request_queue(_io_od(ios, per_dev->dev));
=20
-	per_dev->length +=3D cur_len;
-
 	if (per_dev->bio =3D=3D NULL) {
-		unsigned stripes =3D ios->layout->num_comps /
-						     ios->layout->mirrors_p1;
-		unsigned pages_in_stripe =3D stripes *
+		unsigned pages_in_stripe =3D ios->layout->group_width *
 				      (ios->layout->stripe_unit / PAGE_SIZE);
 		unsigned bio_size =3D (ios->ol_state.nr_pages + pages_in_stripe) /
-				    stripes;
+				    ios->layout->group_width;
=20
 		if (BIO_MAX_PAGES_KMALLOC < bio_size)
 			bio_size =3D BIO_MAX_PAGES_KMALLOC;
@@ -632,6 +627,7 @@ static int _add_stripe_unit(struct objio_state *ios,  u=
nsigned *cur_pg,
 	}
 	BUG_ON(cur_len);
=20
+	per_dev->length +=3D len;
 	*cur_pg =3D pg;
 	return 0;
 }
@@ -650,7 +646,7 @@ static int _prepare_one_group(struct objio_state *ios, =
u64 length,
 	int ret =3D 0;
=20
 	while (length) {
-		struct _objio_per_comp *per_dev =3D &ios->per_dev[dev];
+		struct _objio_per_comp *per_dev =3D &ios->per_dev[dev - first_dev];
 		unsigned cur_len, page_off =3D 0;
=20
 		if (!per_dev->length) {
@@ -670,8 +666,8 @@ static int _prepare_one_group(struct objio_state *ios, =
u64 length,
 				cur_len =3D stripe_unit;
 			}
=20
-			if (max_comp < dev)
-				max_comp =3D dev;
+			if (max_comp < dev - first_dev)
+				max_comp =3D dev - first_dev;
 		} else {
 			cur_len =3D stripe_unit;
 		}
@@ -806,7 +802,7 @@ static int _read_mirrors(struct objio_state *ios, unsig=
ned cur_comp)
 	struct _objio_per_comp *per_dev =3D &ios->per_dev[cur_comp];
 	unsigned dev =3D per_dev->dev;
 	struct pnfs_osd_object_cred *cred =3D
-			&ios->layout->comps[dev];
+			&ios->layout->comps[cur_comp];
 	struct osd_obj_id obj =3D {
 		.partition =3D cred->oc_object_id.oid_partition_id,
 		.id =3D cred->oc_object_id.oid_object_id,
@@ -904,7 +900,7 @@ static int _write_mirrors(struct objio_state *ios, unsi=
gned cur_comp)
 	for (; cur_comp < last_comp; ++cur_comp, ++dev) {
 		struct osd_request *or =3D NULL;
 		struct pnfs_osd_object_cred *cred =3D
-					&ios->layout->comps[dev];
+					&ios->layout->comps[cur_comp];
 		struct osd_obj_id obj =3D {
 			.partition =3D cred->oc_object_id.oid_partition_id,
 			.id =3D cred->oc_object_id.oid_object_id,
diff --git a/fs/nfs/objlayout/pnfs_osd_xdr_cli.c b/fs/nfs/objlayout/pnfs_os=
d_xdr_cli.c
index 16fc758..b3918f7 100644
--- a/fs/nfs/objlayout/pnfs_osd_xdr_cli.c
+++ b/fs/nfs/objlayout/pnfs_osd_xdr_cli.c
@@ -170,6 +170,9 @@ int pnfs_osd_xdr_decode_layout_map(struct pnfs_osd_layo=
ut *layout,
 	p =3D _osd_xdr_decode_data_map(p, &layout->olo_map);
 	layout->olo_comps_index =3D be32_to_cpup(p++);
 	layout->olo_num_comps =3D be32_to_cpup(p++);
+	dprintk("%s: olo_comps_index=3D%d olo_num_comps=3D%d\n", __func__,
+		layout->olo_comps_index, layout->olo_num_comps);
+
 	iter->total_comps =3D layout->olo_num_comps;
 	return 0;
 }
diff --git a/fs/nfs/pnfs.c b/fs/nfs/pnfs.c
index 29c0ca7..a726c0a 100644
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -189,6 +189,7 @@ static void
 pnfs_free_layout_hdr(struct pnfs_layout_hdr *lo)
 {
 	struct pnfs_layoutdriver_type *ld =3D NFS_SERVER(lo->plh_inode)->pnfs_cur=
r_ld;
+	put_rpccred(lo->plh_lc_cred);
 	return ld->alloc_layout_hdr ? ld->free_layout_hdr(lo) : kfree(lo);
 }
=20
@@ -223,6 +224,7 @@ static void
 init_lseg(struct pnfs_layout_hdr *lo, struct pnfs_layout_segment *lseg)
 {
 	INIT_LIST_HEAD(&lseg->pls_list);
+	INIT_LIST_HEAD(&lseg->pls_lc_list);
 	atomic_set(&lseg->pls_refcount, 1);
 	smp_mb();
 	set_bit(NFS_LSEG_VALID, &lseg->pls_flags);
@@ -805,7 +807,9 @@ out:
 }
=20
 static struct pnfs_layout_hdr *
-alloc_init_layout_hdr(struct inode *ino, gfp_t gfp_flags)
+alloc_init_layout_hdr(struct inode *ino,
+		      struct nfs_open_context *ctx,
+		      gfp_t gfp_flags)
 {
 	struct pnfs_layout_hdr *lo;
=20
@@ -817,11 +821,14 @@ alloc_init_layout_hdr(struct inode *ino, gfp_t gfp_fl=
ags)
 	INIT_LIST_HEAD(&lo->plh_segs);
 	INIT_LIST_HEAD(&lo->plh_bulk_recall);
 	lo->plh_inode =3D ino;
+	lo->plh_lc_cred =3D get_rpccred(ctx->state->owner->so_cred);
 	return lo;
 }
=20
 static struct pnfs_layout_hdr *
-pnfs_find_alloc_layout(struct inode *ino, gfp_t gfp_flags)
+pnfs_find_alloc_layout(struct inode *ino,
+		       struct nfs_open_context *ctx,
+		       gfp_t gfp_flags)
 {
 	struct nfs_inode *nfsi =3D NFS_I(ino);
 	struct pnfs_layout_hdr *new =3D NULL;
@@ -836,7 +843,7 @@ pnfs_find_alloc_layout(struct inode *ino, gfp_t gfp_fla=
gs)
 			return nfsi->layout;
 	}
 	spin_unlock(&ino->i_lock);
-	new =3D alloc_init_layout_hdr(ino, gfp_flags);
+	new =3D alloc_init_layout_hdr(ino, ctx, gfp_flags);
 	spin_lock(&ino->i_lock);
=20
 	if (likely(nfsi->layout =3D=3D NULL))	/* Won the race? */
@@ -928,7 +935,7 @@ pnfs_update_layout(struct inode *ino,
 	if (!pnfs_enabled_sb(NFS_SERVER(ino)))
 		return NULL;
 	spin_lock(&ino->i_lock);
-	lo =3D pnfs_find_alloc_layout(ino, gfp_flags);
+	lo =3D pnfs_find_alloc_layout(ino, ctx, gfp_flags);
 	if (lo =3D=3D NULL) {
 		dprintk("%s ERROR: can't get pnfs_layout_hdr\n", __func__);
 		goto out_unlock;
@@ -1195,16 +1202,17 @@ pnfs_try_to_read_data(struct nfs_read_data *rdata,
 }
=20
 /*
- * Currently there is only one (whole file) write lseg.
+ * There can be multiple RW segments.
  */
-static struct pnfs_layout_segment *pnfs_list_write_lseg(struct inode *inod=
e)
+static void pnfs_list_write_lseg(struct inode *inode, struct list_head *li=
stp)
 {
-	struct pnfs_layout_segment *lseg, *rv =3D NULL;
+	struct pnfs_layout_segment *lseg;
=20
-	list_for_each_entry(lseg, &NFS_I(inode)->layout->plh_segs, pls_list)
-		if (lseg->pls_range.iomode =3D=3D IOMODE_RW)
-			rv =3D lseg;
-	return rv;
+	list_for_each_entry(lseg, &NFS_I(inode)->layout->plh_segs, pls_list) {
+		if (lseg->pls_range.iomode =3D=3D IOMODE_RW &&
+		    test_bit(NFS_LSEG_LAYOUTCOMMIT, &lseg->pls_flags))
+			list_add(&lseg->pls_lc_list, listp);
+	}
 }
=20
 void
@@ -1216,17 +1224,19 @@ pnfs_set_layoutcommit(struct nfs_write_data *wdata)
=20
 	spin_lock(&nfsi->vfs_inode.i_lock);
 	if (!test_and_set_bit(NFS_INO_LAYOUTCOMMIT, &nfsi->flags)) {
-		/* references matched in nfs4_layoutcommit_release */
-		get_lseg(wdata->lseg);
-		wdata->lseg->pls_lc_cred =3D
-			get_rpccred(wdata->args.context->state->owner->so_cred);
 		mark_as_dirty =3D true;
 		dprintk("%s: Set layoutcommit for inode %lu ",
 			__func__, wdata->inode->i_ino);
 	}
-	if (end_pos > wdata->lseg->pls_end_pos)
-		wdata->lseg->pls_end_pos =3D end_pos;
+	if (!test_and_set_bit(NFS_LSEG_LAYOUTCOMMIT, &wdata->lseg->pls_flags)) {
+		/* references matched in nfs4_layoutcommit_release */
+		get_lseg(wdata->lseg);
+	}
+	if (end_pos > nfsi->layout->plh_lwb)
+		nfsi->layout->plh_lwb =3D end_pos;
 	spin_unlock(&nfsi->vfs_inode.i_lock);
+	dprintk("%s: lseg %p end_pos %llu\n",
+		__func__, wdata->lseg, nfsi->layout->plh_lwb);
=20
 	/* if pnfs_layoutcommit_inode() runs between inode locks, the next one
 	 * will be a noop because NFS_INO_LAYOUTCOMMIT will not be set */
@@ -1248,8 +1258,6 @@ pnfs_layoutcommit_inode(struct inode *inode, bool syn=
c)
 {
 	struct nfs4_layoutcommit_data *data;
 	struct nfs_inode *nfsi =3D NFS_I(inode);
-	struct pnfs_layout_segment *lseg;
-	struct rpc_cred *cred;
 	loff_t end_pos;
 	int status =3D 0;
=20
@@ -1266,30 +1274,25 @@ pnfs_layoutcommit_inode(struct inode *inode, bool s=
ync)
 		goto out;
 	}
=20
+	INIT_LIST_HEAD(&data->lseg_list);
 	spin_lock(&inode->i_lock);
 	if (!test_and_clear_bit(NFS_INO_LAYOUTCOMMIT, &nfsi->flags)) {
 		spin_unlock(&inode->i_lock);
 		kfree(data);
 		goto out;
 	}
-	/*
-	 * Currently only one (whole file) write lseg which is referenced
-	 * in pnfs_set_layoutcommit and will be found.
-	 */
-	lseg =3D pnfs_list_write_lseg(inode);
=20
-	end_pos =3D lseg->pls_end_pos;
-	cred =3D lseg->pls_lc_cred;
-	lseg->pls_end_pos =3D 0;
-	lseg->pls_lc_cred =3D NULL;
+	pnfs_list_write_lseg(inode, &data->lseg_list);
+
+	end_pos =3D nfsi->layout->plh_lwb;
+	nfsi->layout->plh_lwb =3D 0;
=20
 	memcpy(&data->args.stateid.data, nfsi->layout->plh_stateid.data,
 		sizeof(nfsi->layout->plh_stateid.data));
 	spin_unlock(&inode->i_lock);
=20
 	data->args.inode =3D inode;
-	data->lseg =3D lseg;
-	data->cred =3D cred;
+	data->cred =3D get_rpccred(nfsi->layout->plh_lc_cred);
 	nfs_fattr_init(&data->fattr);
 	data->args.bitmask =3D NFS_SERVER(inode)->cache_consistency_bitmask;
 	data->res.fattr =3D &data->fattr;
diff --git a/fs/nfs/pnfs.h b/fs/nfs/pnfs.h
index 96bf4e6..9d147d9 100644
--- a/fs/nfs/pnfs.h
+++ b/fs/nfs/pnfs.h
@@ -36,16 +36,16 @@
 enum {
 	NFS_LSEG_VALID =3D 0,	/* cleared when lseg is recalled/returned */
 	NFS_LSEG_ROC,		/* roc bit received from server */
+	NFS_LSEG_LAYOUTCOMMIT,	/* layoutcommit bit set for layoutcommit */
 };
=20
 struct pnfs_layout_segment {
 	struct list_head pls_list;
+	struct list_head pls_lc_list;
 	struct pnfs_layout_range pls_range;
 	atomic_t pls_refcount;
 	unsigned long pls_flags;
 	struct pnfs_layout_hdr *pls_layout;
-	struct rpc_cred	*pls_lc_cred; /* LAYOUTCOMMIT credential */
-	loff_t pls_end_pos; /* LAYOUTCOMMIT write end */
 };
=20
 enum pnfs_try_status {
@@ -124,6 +124,8 @@ struct pnfs_layout_hdr {
 	unsigned long		plh_block_lgets; /* block LAYOUTGET if >0 */
 	u32			plh_barrier; /* ignore lower seqids */
 	unsigned long		plh_flags;
+	loff_t			plh_lwb; /* last write byte for layoutcommit */
+	struct rpc_cred		*plh_lc_cred; /* layoutcommit cred */
 	struct inode		*plh_inode;
 };
=20
diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index e98f3c2..3b8ad35 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -381,14 +381,6 @@ static int nfs4_access_to_omode(u32 access)
 	BUG();
 }
=20
-static int nfs4_access_bmap_to_omode(struct nfs4_stateid *stp)
-{
-	unsigned int access;
-
-	set_access(&access, stp->st_access_bmap);
-	return nfs4_access_to_omode(access);
-}
-
 static void unhash_generic_stateid(struct nfs4_stateid *stp)
 {
 	list_del(&stp->st_hash);
@@ -398,11 +390,14 @@ static void unhash_generic_stateid(struct nfs4_statei=
d *stp)
=20
 static void free_generic_stateid(struct nfs4_stateid *stp)
 {
-	int oflag;
+	int i;
=20
 	if (stp->st_access_bmap) {
-		oflag =3D nfs4_access_bmap_to_omode(stp);
-		nfs4_file_put_access(stp->st_file, oflag);
+		for (i =3D 1; i < 4; i++) {
+			if (test_bit(i, &stp->st_access_bmap))
+				nfs4_file_put_access(stp->st_file,
+						nfs4_access_to_omode(i));
+		}
 	}
 	put_nfs4_file(stp->st_file);
 	kmem_cache_free(stateid_slab, stp);
@@ -2337,15 +2332,6 @@ out:
 	return ret;
 }
=20
-static inline void
-nfs4_file_downgrade(struct nfs4_file *fp, unsigned int share_access)
-{
-	if (share_access & NFS4_SHARE_ACCESS_WRITE)
-		nfs4_file_put_access(fp, O_WRONLY);
-	if (share_access & NFS4_SHARE_ACCESS_READ)
-		nfs4_file_put_access(fp, O_RDONLY);
-}
-
 static void nfsd_break_one_deleg(struct nfs4_delegation *dp)
 {
 	/* We're assuming the state code never drops its reference
@@ -2556,12 +2542,18 @@ static inline int nfs4_access_to_access(u32 nfs4_ac=
cess)
 	return flags;
 }
=20
-static __be32 nfs4_get_vfs_file(struct svc_rqst *rqstp, struct nfs4_file
-*fp, struct svc_fh *cur_fh, u32 nfs4_access)
+static __be32 nfs4_get_vfs_file(struct svc_rqst *rqstp, struct nfs4_file *=
fp,
+		struct svc_fh *cur_fh, struct nfsd4_open *open)
 {
 	__be32 status;
-	int oflag =3D nfs4_access_to_omode(nfs4_access);
-	int access =3D nfs4_access_to_access(nfs4_access);
+	int oflag =3D nfs4_access_to_omode(open->op_share_access);
+	int access =3D nfs4_access_to_access(open->op_share_access);
+
+	/* CLAIM_DELEGATE_CUR is used in response to a broken lease;
+	 * allowing it to break the lease and return EAGAIN leaves the
+	 * client unable to make progress in returning the delegation */
+	if (open->op_claim_type =3D=3D NFS4_OPEN_CLAIM_DELEGATE_CUR)
+		access |=3D NFSD_MAY_NOT_BREAK_LEASE;
=20
 	if (!fp->fi_fds[oflag]) {
 		status =3D nfsd_open(rqstp, cur_fh, S_IFREG, access,
@@ -2586,7 +2578,7 @@ nfs4_new_open(struct svc_rqst *rqstp, struct nfs4_sta=
teid **stpp,
 	if (stp =3D=3D NULL)
 		return nfserr_resource;
=20
-	status =3D nfs4_get_vfs_file(rqstp, fp, cur_fh, open->op_share_access);
+	status =3D nfs4_get_vfs_file(rqstp, fp, cur_fh, open);
 	if (status) {
 		kmem_cache_free(stateid_slab, stp);
 		return status;
@@ -2619,14 +2611,14 @@ nfs4_upgrade_open(struct svc_rqst *rqstp, struct nf=
s4_file *fp, struct svc_fh *c
=20
 	new_access =3D !test_bit(op_share_access, &stp->st_access_bmap);
 	if (new_access) {
-		status =3D nfs4_get_vfs_file(rqstp, fp, cur_fh, op_share_access);
+		status =3D nfs4_get_vfs_file(rqstp, fp, cur_fh, open);
 		if (status)
 			return status;
 	}
 	status =3D nfsd4_truncate(rqstp, cur_fh, open);
 	if (status) {
 		if (new_access) {
-			int oflag =3D nfs4_access_to_omode(new_access);
+			int oflag =3D nfs4_access_to_omode(op_share_access);
 			nfs4_file_put_access(fp, oflag);
 		}
 		return status;
@@ -3384,18 +3376,15 @@ out:
 	return status;
 }
=20
-
-/*
- * unset all bits in union bitmap (bmap) that
- * do not exist in share (from successful OPEN_DOWNGRADE)
- */
-static void
-reset_union_bmap_access(unsigned long access, unsigned long *bmap)
+static inline void nfs4_file_downgrade(struct nfs4_stateid *stp, unsigned =
int to_access)
 {
 	int i;
+
 	for (i =3D 1; i < 4; i++) {
-		if ((i & access) !=3D i)
-			__clear_bit(i, bmap);
+		if (test_bit(i, &stp->st_access_bmap) && !(i & to_access)) {
+			nfs4_file_put_access(stp->st_file, i);
+			__clear_bit(i, &stp->st_access_bmap);
+		}
 	}
 }
=20
@@ -3416,7 +3405,6 @@ nfsd4_open_downgrade(struct svc_rqst *rqstp,
 {
 	__be32 status;
 	struct nfs4_stateid *stp;
-	unsigned int share_access;
=20
 	dprintk("NFSD: nfsd4_open_downgrade on file %.*s\n",=20
 			(int)cstate->current_fh.fh_dentry->d_name.len,
@@ -3445,10 +3433,8 @@ nfsd4_open_downgrade(struct svc_rqst *rqstp,
 			stp->st_deny_bmap, od->od_share_deny);
 		goto out;
 	}
-	set_access(&share_access, stp->st_access_bmap);
-	nfs4_file_downgrade(stp->st_file, share_access & ~od->od_share_access);
+	nfs4_file_downgrade(stp, od->od_share_access);
=20
-	reset_union_bmap_access(od->od_share_access, &stp->st_access_bmap);
 	reset_union_bmap_deny(od->od_share_deny, &stp->st_deny_bmap);
=20
 	update_stateid(&stp->st_stateid);
diff --git a/fs/proc/base.c b/fs/proc/base.c
index fc5bc27..5bff4c6 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2707,9 +2707,16 @@ static int do_io_accounting(struct task_struct *task=
, char *buffer, int whole)
 {
 	struct task_io_accounting acct =3D task->ioac;
 	unsigned long flags;
+	int result;
=20
-	if (!ptrace_may_access(task, PTRACE_MODE_READ))
-		return -EACCES;
+	result =3D mutex_lock_killable(&task->signal->cred_guard_mutex);
+	if (result)
+		return result;
+
+	if (!ptrace_may_access(task, PTRACE_MODE_READ)) {
+		result =3D -EACCES;
+		goto out_unlock;
+	}
=20
 	if (whole && lock_task_sighand(task, &flags)) {
 		struct task_struct *t =3D task;
@@ -2720,7 +2727,7 @@ static int do_io_accounting(struct task_struct *task,=
 char *buffer, int whole)
=20
 		unlock_task_sighand(task, &flags);
 	}
-	return sprintf(buffer,
+	result =3D sprintf(buffer,
 			"rchar: %llu\n"
 			"wchar: %llu\n"
 			"syscr: %llu\n"
@@ -2735,6 +2742,9 @@ static int do_io_accounting(struct task_struct *task,=
 char *buffer, int whole)
 			(unsigned long long)acct.read_bytes,
 			(unsigned long long)acct.write_bytes,
 			(unsigned long long)acct.cancelled_write_bytes);
+out_unlock:
+	mutex_unlock(&task->signal->cred_guard_mutex);
+	return result;
 }
=20
 static int proc_tid_io_accounting(struct task_struct *task, char *buffer)
diff --git a/include/drm/drm_crtc.h b/include/drm/drm_crtc.h
index 33d12f8..0ec3687 100644
--- a/include/drm/drm_crtc.h
+++ b/include/drm/drm_crtc.h
@@ -802,6 +802,7 @@ extern struct drm_display_mode *drm_gtf_mode_complex(st=
ruct drm_device *dev,
 extern int drm_add_modes_noedid(struct drm_connector *connector,
 				int hdisplay, int vdisplay);
=20
+extern int drm_edid_header_is_valid(const u8 *raw_edid);
 extern bool drm_edid_is_valid(struct edid *edid);
 struct drm_display_mode *drm_mode_find_dmt(struct drm_device *dev,
 					   int hsize, int vsize, int fresh);
diff --git a/include/drm/i915_drm.h b/include/drm/i915_drm.h
index c4d6dbf..28c0d11 100644
--- a/include/drm/i915_drm.h
+++ b/include/drm/i915_drm.h
@@ -237,7 +237,7 @@ typedef struct _drm_i915_sarea {
 #define DRM_IOCTL_I915_GEM_GET_APERTURE	DRM_IOR  (DRM_COMMAND_BASE + DRM_I=
915_GEM_GET_APERTURE, struct drm_i915_gem_get_aperture)
 #define DRM_IOCTL_I915_GET_PIPE_FROM_CRTC_ID DRM_IOWR(DRM_COMMAND_BASE + D=
RM_I915_GET_PIPE_FROM_CRTC_ID, struct drm_i915_get_pipe_from_crtc_id)
 #define DRM_IOCTL_I915_GEM_MADVISE	DRM_IOWR(DRM_COMMAND_BASE + DRM_I915_GE=
M_MADVISE, struct drm_i915_gem_madvise)
-#define DRM_IOCTL_I915_OVERLAY_PUT_IMAGE	DRM_IOW(DRM_COMMAND_BASE + DRM_IO=
CTL_I915_OVERLAY_ATTRS, struct drm_intel_overlay_put_image)
+#define DRM_IOCTL_I915_OVERLAY_PUT_IMAGE	DRM_IOW(DRM_COMMAND_BASE + DRM_I9=
15_OVERLAY_PUT_IMAGE, struct drm_intel_overlay_put_image)
 #define DRM_IOCTL_I915_OVERLAY_ATTRS	DRM_IOWR(DRM_COMMAND_BASE + DRM_I915_=
OVERLAY_ATTRS, struct drm_intel_overlay_attrs)
=20
 /* Allow drivers to submit batchbuffers directly to hardware, relying
diff --git a/include/linux/cryptohash.h b/include/linux/cryptohash.h
index ec78a4b..d2984fb 100644
--- a/include/linux/cryptohash.h
+++ b/include/linux/cryptohash.h
@@ -8,6 +8,11 @@
 void sha_init(__u32 *buf);
 void sha_transform(__u32 *digest, const char *data, __u32 *W);
=20
+#define MD5_DIGEST_WORDS 4
+#define MD5_MESSAGE_BYTES 64
+
+void md5_transform(__u32 *hash, __u32 const *in);
+
 __u32 half_md4_transform(__u32 buf[4], __u32 const in[8]);
=20
 #endif
diff --git a/include/linux/firewire-cdev.h b/include/linux/firewire-cdev.h
index 4ff0988..55814aa 100644
--- a/include/linux/firewire-cdev.h
+++ b/include/linux/firewire-cdev.h
@@ -475,6 +475,9 @@ union fw_cdev_event {
  *		of the bus.  This does not cause a bus reset to happen.
  * @bus_reset_closure: Value of &closure in this and subsequent bus reset =
events
  * @card:	The index of the card this device belongs to
+ *
+ * As a side effect, reception of %FW_CDEV_EVENT_BUS_RESET events to be re=
ad(2)
+ * is started by this ioctl.
  */
 struct fw_cdev_get_info {
 	__u32 version;
diff --git a/include/linux/if.h b/include/linux/if.h
index 3bc63e6..03489ca 100644
--- a/include/linux/if.h
+++ b/include/linux/if.h
@@ -76,6 +76,8 @@
 #define IFF_BRIDGE_PORT	0x4000		/* device used as bridge port */
 #define IFF_OVS_DATAPATH	0x8000	/* device used as Open vSwitch
 					 * datapath port */
+#define IFF_TX_SKB_SHARING	0x10000	/* The interface supports sharing
+					 * skbs on transmit */
=20
 #define IF_GET_IFACE	0x0001		/* for querying only */
 #define IF_GET_PROTO	0x0002
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 9670f71..ec6e33d 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -959,6 +959,8 @@ int invalidate_inode_page(struct page *page);
 #ifdef CONFIG_MMU
 extern int handle_mm_fault(struct mm_struct *mm, struct vm_area_struct *vm=
a,
 			unsigned long address, unsigned int flags);
+extern int fixup_user_fault(struct task_struct *tsk, struct mm_struct *mm,
+			    unsigned long address, unsigned int fault_flags);
 #else
 static inline int handle_mm_fault(struct mm_struct *mm,
 			struct vm_area_struct *vma, unsigned long address,
@@ -968,6 +970,14 @@ static inline int handle_mm_fault(struct mm_struct *mm,
 	BUG();
 	return VM_FAULT_SIGBUS;
 }
+static inline int fixup_user_fault(struct task_struct *tsk,
+		struct mm_struct *mm, unsigned long address,
+		unsigned int fault_flags)
+{
+	/* should never happen if there's no MMU */
+	BUG();
+	return -EFAULT;
+}
 #endif
=20
 extern int make_pages_present(unsigned long addr, unsigned long end);
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 9e19477..33b5968 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1688,9 +1688,12 @@ static inline int skb_gro_header_hard(struct sk_buff=
 *skb, unsigned int hlen)
 static inline void *skb_gro_header_slow(struct sk_buff *skb, unsigned int =
hlen,
 					unsigned int offset)
 {
+	if (!pskb_may_pull(skb, hlen))
+		return NULL;
+
 	NAPI_GRO_CB(skb)->frag0 =3D NULL;
 	NAPI_GRO_CB(skb)->frag0_len =3D 0;
-	return pskb_may_pull(skb, hlen) ? skb->data + offset : NULL;
+	return skb->data + offset;
 }
=20
 static inline void *skb_gro_mac_header(struct sk_buff *skb)
diff --git a/include/linux/nfs_fs.h b/include/linux/nfs_fs.h
index 1b93b9c..b522370 100644
--- a/include/linux/nfs_fs.h
+++ b/include/linux/nfs_fs.h
@@ -99,9 +99,10 @@ struct nfs_open_context {
=20
 struct nfs_open_dir_context {
 	struct rpc_cred *cred;
+	unsigned long attr_gencount;
 	__u64 dir_cookie;
 	__u64 dup_cookie;
-	int duped;
+	signed char duped;
 };
=20
 /*
diff --git a/include/linux/nfs_xdr.h b/include/linux/nfs_xdr.h
index 00848d8..be2eba7 100644
--- a/include/linux/nfs_xdr.h
+++ b/include/linux/nfs_xdr.h
@@ -262,7 +262,7 @@ struct nfs4_layoutcommit_res {
 struct nfs4_layoutcommit_data {
 	struct rpc_task task;
 	struct nfs_fattr fattr;
-	struct pnfs_layout_segment *lseg;
+	struct list_head lseg_list;
 	struct rpc_cred *cred;
 	struct nfs4_layoutcommit_args args;
 	struct nfs4_layoutcommit_res res;
diff --git a/include/linux/personality.h b/include/linux/personality.h
index eec3bae..8fc7dd1a 100644
--- a/include/linux/personality.h
+++ b/include/linux/personality.h
@@ -22,6 +22,7 @@ extern int		__set_personality(unsigned int);
  * These occupy the top three bytes.
  */
 enum {
+	UNAME26	=3D               0x0020000,
 	ADDR_NO_RANDOMIZE =3D 	0x0040000,	/* disable randomization of VA space */
 	FDPIC_FUNCPTRS =3D	0x0080000,	/* userspace function ptrs point to descrip=
tors
 						 * (signal handling)
diff --git a/include/linux/random.h b/include/linux/random.h
index fb7ab9d..d13059f 100644
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -57,17 +57,6 @@ extern void add_interrupt_randomness(int irq);
 extern void get_random_bytes(void *buf, int nbytes);
 void generate_random_uuid(unsigned char uuid_out[16]);
=20
-extern __u32 secure_ip_id(__be32 daddr);
-extern u32 secure_ipv4_port_ephemeral(__be32 saddr, __be32 daddr, __be16 d=
port);
-extern u32 secure_ipv6_port_ephemeral(const __be32 *saddr, const __be32 *d=
addr,
-				      __be16 dport);
-extern __u32 secure_tcp_sequence_number(__be32 saddr, __be32 daddr,
-					__be16 sport, __be16 dport);
-extern __u32 secure_tcpv6_sequence_number(__be32 *saddr, __be32 *daddr,
-					  __be16 sport, __be16 dport);
-extern u64 secure_dccp_sequence_number(__be32 saddr, __be32 daddr,
-				       __be16 sport, __be16 dport);
-
 #ifndef MODULE
 extern const struct file_operations random_fops, urandom_fops;
 #endif
diff --git a/include/linux/stop_machine.h b/include/linux/stop_machine.h
index 092dc9b..14d3524 100644
--- a/include/linux/stop_machine.h
+++ b/include/linux/stop_machine.h
@@ -27,6 +27,8 @@ struct cpu_stop_work {
 	struct cpu_stop_done	*done;
 };
=20
+extern struct mutex stop_cpus_mutex;
+
 int stop_one_cpu(unsigned int cpu, cpu_stop_fn_t fn, void *arg);
 void stop_one_cpu_nowait(unsigned int cpu, cpu_stop_fn_t fn, void *arg,
 			 struct cpu_stop_work *work_buf);
diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index c033ed0..3b5ac1f 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -463,17 +463,7 @@ static inline int ipv6_addr_diff(const struct in6_addr=
 *a1, const struct in6_add
 	return __ipv6_addr_diff(a1, a2, sizeof(struct in6_addr));
 }
=20
-static __inline__ void ipv6_select_ident(struct frag_hdr *fhdr)
-{
-	static u32 ipv6_fragmentation_id =3D 1;
-	static DEFINE_SPINLOCK(ip6_id_lock);
-
-	spin_lock_bh(&ip6_id_lock);
-	fhdr->identification =3D htonl(ipv6_fragmentation_id);
-	if (++ipv6_fragmentation_id =3D=3D 0)
-		ipv6_fragmentation_id =3D 1;
-	spin_unlock_bh(&ip6_id_lock);
-}
+extern void ipv6_select_ident(struct frag_hdr *fhdr, struct rt6_info *rt);
=20
 /*
  *	Prototypes exported by ipv6
diff --git a/include/net/secure_seq.h b/include/net/secure_seq.h
new file mode 100644
index 0000000..d97f689
--- /dev/null
+++ b/include/net/secure_seq.h
@@ -0,0 +1,20 @@
+#ifndef _NET_SECURE_SEQ
+#define _NET_SECURE_SEQ
+
+#include <linux/types.h>
+
+extern __u32 secure_ip_id(__be32 daddr);
+extern __u32 secure_ipv6_id(const __be32 daddr[4]);
+extern u32 secure_ipv4_port_ephemeral(__be32 saddr, __be32 daddr, __be16 d=
port);
+extern u32 secure_ipv6_port_ephemeral(const __be32 *saddr, const __be32 *d=
addr,
+				      __be16 dport);
+extern __u32 secure_tcp_sequence_number(__be32 saddr, __be32 daddr,
+					__be16 sport, __be16 dport);
+extern __u32 secure_tcpv6_sequence_number(__be32 *saddr, __be32 *daddr,
+					  __be16 sport, __be16 dport);
+extern u64 secure_dccp_sequence_number(__be32 saddr, __be32 daddr,
+				       __be16 sport, __be16 dport);
+extern u64 secure_dccpv6_sequence_number(__be32 *saddr, __be32 *daddr,
+					 __be16 sport, __be16 dport);
+
+#endif /* _NET_SECURE_SEQ */
diff --git a/include/net/transp_v6.h b/include/net/transp_v6.h
index 5271a74..45ce307 100644
--- a/include/net/transp_v6.h
+++ b/include/net/transp_v6.h
@@ -14,6 +14,8 @@ extern struct proto tcpv6_prot;
=20
 struct flowi6;
=20
+extern void initialize_hashidentrnd(void);
+
 /* extension headers */
 extern int				ipv6_exthdrs_init(void);
 extern void				ipv6_exthdrs_exit(void);
diff --git a/include/xen/interface/xen.h b/include/xen/interface/xen.h
index 70213b4..6acd9ce 100644
--- a/include/xen/interface/xen.h
+++ b/include/xen/interface/xen.h
@@ -450,6 +450,45 @@ struct start_info {
 	int8_t cmd_line[MAX_GUEST_CMDLINE];
 };
=20
+struct dom0_vga_console_info {
+	uint8_t video_type;
+#define XEN_VGATYPE_TEXT_MODE_3 0x03
+#define XEN_VGATYPE_VESA_LFB    0x23
+
+	union {
+		struct {
+			/* Font height, in pixels. */
+			uint16_t font_height;
+			/* Cursor location (column, row). */
+			uint16_t cursor_x, cursor_y;
+			/* Number of rows and columns (dimensions in characters). */
+			uint16_t rows, columns;
+		} text_mode_3;
+
+		struct {
+			/* Width and height, in pixels. */
+			uint16_t width, height;
+			/* Bytes per scan line. */
+			uint16_t bytes_per_line;
+			/* Bits per pixel. */
+			uint16_t bits_per_pixel;
+			/* LFB physical address, and size (in units of 64kB). */
+			uint32_t lfb_base;
+			uint32_t lfb_size;
+			/* RGB mask offsets and sizes, as defined by VBE 1.2+ */
+			uint8_t  red_pos, red_size;
+			uint8_t  green_pos, green_size;
+			uint8_t  blue_pos, blue_size;
+			uint8_t  rsvd_pos, rsvd_size;
+
+			/* VESA capabilities (offset 0xa, VESA command 0x4f00). */
+			uint32_t gbl_caps;
+			/* Mode attributes (offset 0x0, VESA command 0x4f01). */
+			uint16_t mode_attrs;
+		} vesa_lfb;
+	} u;
+};
+
 /* These flags are passed in the 'flags' field of start_info_t. */
 #define SIF_PRIVILEGED    (1<<0)  /* Is the domain privileged? */
 #define SIF_INITDOMAIN    (1<<1)  /* Is this the initial control domain? */
diff --git a/ipc/sem.c b/ipc/sem.c
index 34193ed..e68a8f5 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -1456,15 +1456,24 @@ SYSCALL_DEFINE4(semtimedop, int, semid, struct semb=
uf __user *, tsops,
 	}
=20
 	sma =3D sem_lock(ns, semid);
+
+	/*
+	 * Wait until it's guaranteed that no wakeup_sem_queue_do() is ongoing.
+	 */
+	error =3D get_queue_result(&queue);
+
+	/*
+	 * Array removed? If yes, leave without sem_unlock().
+	 */
 	if (IS_ERR(sma)) {
 		error =3D -EIDRM;
 		goto out_free;
 	}
=20
-	error =3D get_queue_result(&queue);
=20
 	/*
-	 * If queue.status !=3D -EINTR we are woken up by another process
+	 * If queue.status !=3D -EINTR we are woken up by another process.
+	 * Leave without unlink_queue(), but with sem_unlock().
 	 */
=20
 	if (error !=3D -EINTR) {
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 9efe710..32a6151 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5016,11 +5016,8 @@ static int __perf_event_overflow(struct perf_event *=
event, int nmi,
 	if (events && atomic_dec_and_test(&event->event_limit)) {
 		ret =3D 1;
 		event->pending_kill =3D POLL_HUP;
-		if (nmi) {
-			event->pending_disable =3D 1;
-			irq_work_queue(&event->pending);
-		} else
-			perf_event_disable(event);
+		event->pending_disable =3D 1;
+		irq_work_queue(&event->pending);
 	}
=20
 	if (event->overflow_handler)
diff --git a/kernel/futex.c b/kernel/futex.c
index fe28dc2..8b6da25 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -218,6 +218,8 @@ static void drop_futex_key_refs(union futex_key *key)
  * @uaddr:	virtual address of the futex
  * @fshared:	0 for a PROCESS_PRIVATE futex, 1 for PROCESS_SHARED
  * @key:	address where result is stored.
+ * @rw:		mapping needs to be read/write (values: VERIFY_READ,
+ *              VERIFY_WRITE)
  *
  * Returns a negative error code or 0
  * The key words are stored in *key on success.
@@ -229,12 +231,12 @@ static void drop_futex_key_refs(union futex_key *key)
  * lock_page() might sleep, the caller should not hold a spinlock.
  */
 static int
-get_futex_key(u32 __user *uaddr, int fshared, union futex_key *key)
+get_futex_key(u32 __user *uaddr, int fshared, union futex_key *key, int rw)
 {
 	unsigned long address =3D (unsigned long)uaddr;
 	struct mm_struct *mm =3D current->mm;
 	struct page *page, *page_head;
-	int err;
+	int err, ro =3D 0;
=20
 	/*
 	 * The futex address must be "naturally" aligned.
@@ -262,8 +264,18 @@ get_futex_key(u32 __user *uaddr, int fshared, union fu=
tex_key *key)
=20
 again:
 	err =3D get_user_pages_fast(address, 1, 1, &page);
+	/*
+	 * If write access is not required (eg. FUTEX_WAIT), try
+	 * and get read-only access.
+	 */
+	if (err =3D=3D -EFAULT && rw =3D=3D VERIFY_READ) {
+		err =3D get_user_pages_fast(address, 1, 0, &page);
+		ro =3D 1;
+	}
 	if (err < 0)
 		return err;
+	else
+		err =3D 0;
=20
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	page_head =3D page;
@@ -305,6 +317,13 @@ again:
 	if (!page_head->mapping) {
 		unlock_page(page_head);
 		put_page(page_head);
+		/*
+		* ZERO_PAGE pages don't have a mapping. Avoid a busy loop
+		* trying to find one. RW mapping would have COW'd (and thus
+		* have a mapping) so this page is RO and won't ever change.
+		*/
+		if ((page_head =3D=3D ZERO_PAGE(address)))
+			return -EFAULT;
 		goto again;
 	}
=20
@@ -316,6 +335,15 @@ again:
 	 * the object not the particular process.
 	 */
 	if (PageAnon(page_head)) {
+		/*
+		 * A RO anonymous page will never change and thus doesn't make
+		 * sense for futex operations.
+		 */
+		if (ro) {
+			err =3D -EFAULT;
+			goto out;
+		}
+
 		key->both.offset |=3D FUT_OFF_MMSHARED; /* ref taken on mm */
 		key->private.mm =3D mm;
 		key->private.address =3D address;
@@ -327,9 +355,10 @@ again:
=20
 	get_futex_key_refs(key);
=20
+out:
 	unlock_page(page_head);
 	put_page(page_head);
-	return 0;
+	return err;
 }
=20
 static inline void put_futex_key(union futex_key *key)
@@ -355,8 +384,8 @@ static int fault_in_user_writeable(u32 __user *uaddr)
 	int ret;
=20
 	down_read(&mm->mmap_sem);
-	ret =3D get_user_pages(current, mm, (unsigned long)uaddr,
-			     1, 1, 0, NULL, NULL);
+	ret =3D fixup_user_fault(current, mm, (unsigned long)uaddr,
+			       FAULT_FLAG_WRITE);
 	up_read(&mm->mmap_sem);
=20
 	return ret < 0 ? ret : 0;
@@ -940,7 +969,7 @@ futex_wake(u32 __user *uaddr, unsigned int flags, int n=
r_wake, u32 bitset)
 	if (!bitset)
 		return -EINVAL;
=20
-	ret =3D get_futex_key(uaddr, flags & FLAGS_SHARED, &key);
+	ret =3D get_futex_key(uaddr, flags & FLAGS_SHARED, &key, VERIFY_READ);
 	if (unlikely(ret !=3D 0))
 		goto out;
=20
@@ -986,10 +1015,10 @@ futex_wake_op(u32 __user *uaddr1, unsigned int flags=
, u32 __user *uaddr2,
 	int ret, op_ret;
=20
 retry:
-	ret =3D get_futex_key(uaddr1, flags & FLAGS_SHARED, &key1);
+	ret =3D get_futex_key(uaddr1, flags & FLAGS_SHARED, &key1, VERIFY_READ);
 	if (unlikely(ret !=3D 0))
 		goto out;
-	ret =3D get_futex_key(uaddr2, flags & FLAGS_SHARED, &key2);
+	ret =3D get_futex_key(uaddr2, flags & FLAGS_SHARED, &key2, VERIFY_WRITE);
 	if (unlikely(ret !=3D 0))
 		goto out_put_key1;
=20
@@ -1243,10 +1272,11 @@ retry:
 		pi_state =3D NULL;
 	}
=20
-	ret =3D get_futex_key(uaddr1, flags & FLAGS_SHARED, &key1);
+	ret =3D get_futex_key(uaddr1, flags & FLAGS_SHARED, &key1, VERIFY_READ);
 	if (unlikely(ret !=3D 0))
 		goto out;
-	ret =3D get_futex_key(uaddr2, flags & FLAGS_SHARED, &key2);
+	ret =3D get_futex_key(uaddr2, flags & FLAGS_SHARED, &key2,
+			    requeue_pi ? VERIFY_WRITE : VERIFY_READ);
 	if (unlikely(ret !=3D 0))
 		goto out_put_key1;
=20
@@ -1790,7 +1820,7 @@ static int futex_wait_setup(u32 __user *uaddr, u32 va=
l, unsigned int flags,
 	 * while the syscall executes.
 	 */
 retry:
-	ret =3D get_futex_key(uaddr, flags & FLAGS_SHARED, &q->key);
+	ret =3D get_futex_key(uaddr, flags & FLAGS_SHARED, &q->key, VERIFY_READ);
 	if (unlikely(ret !=3D 0))
 		return ret;
=20
@@ -1941,7 +1971,7 @@ static int futex_lock_pi(u32 __user *uaddr, unsigned =
int flags, int detect,
 	}
=20
 retry:
-	ret =3D get_futex_key(uaddr, flags & FLAGS_SHARED, &q.key);
+	ret =3D get_futex_key(uaddr, flags & FLAGS_SHARED, &q.key, VERIFY_WRITE);
 	if (unlikely(ret !=3D 0))
 		goto out;
=20
@@ -2060,7 +2090,7 @@ retry:
 	if ((uval & FUTEX_TID_MASK) !=3D vpid)
 		return -EPERM;
=20
-	ret =3D get_futex_key(uaddr, flags & FLAGS_SHARED, &key);
+	ret =3D get_futex_key(uaddr, flags & FLAGS_SHARED, &key, VERIFY_WRITE);
 	if (unlikely(ret !=3D 0))
 		goto out;
=20
@@ -2249,7 +2279,7 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, u=
nsigned int flags,
 	debug_rt_mutex_init_waiter(&rt_waiter);
 	rt_waiter.task =3D NULL;
=20
-	ret =3D get_futex_key(uaddr2, flags & FLAGS_SHARED, &key2);
+	ret =3D get_futex_key(uaddr2, flags & FLAGS_SHARED, &key2, VERIFY_WRITE);
 	if (unlikely(ret !=3D 0))
 		goto out;
=20
diff --git a/kernel/irq/generic-chip.c b/kernel/irq/generic-chip.c
index 3a2cab4..e38544d 100644
--- a/kernel/irq/generic-chip.c
+++ b/kernel/irq/generic-chip.c
@@ -246,7 +246,7 @@ void irq_setup_generic_chip(struct irq_chip_generic *gc=
, u32 msk,
 		gc->mask_cache =3D irq_reg_readl(gc->reg_base + ct->regs.mask);
=20
 	for (i =3D gc->irq_base; msk; msk >>=3D 1, i++) {
-		if (!msk & 0x01)
+		if (!(msk & 0x01))
 			continue;
=20
 		if (flags & IRQ_GC_INIT_NESTED_LOCK)
@@ -301,7 +301,7 @@ void irq_remove_generic_chip(struct irq_chip_generic *g=
c, u32 msk,
 	raw_spin_unlock(&gc_lock);
=20
 	for (; msk; msk >>=3D 1, i++) {
-		if (!msk & 0x01)
+		if (!(msk & 0x01))
 			continue;
=20
 		/* Remove handler first. That will mask the irq line */
diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
index e3516b2..0cae1cc 100644
--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
@@ -132,8 +132,8 @@ void stop_one_cpu_nowait(unsigned int cpu, cpu_stop_fn_=
t fn, void *arg,
 	cpu_stop_queue_work(&per_cpu(cpu_stopper, cpu), work_buf);
 }
=20
+DEFINE_MUTEX(stop_cpus_mutex);
 /* static data for stop_cpus */
-static DEFINE_MUTEX(stop_cpus_mutex);
 static DEFINE_PER_CPU(struct cpu_stop_work, stop_cpus_work);
=20
 int __stop_cpus(const struct cpumask *cpumask, cpu_stop_fn_t fn, void *arg)
diff --git a/kernel/sys.c b/kernel/sys.c
index e4128b2..5c942cf 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -38,6 +38,8 @@
 #include <linux/fs_struct.h>
 #include <linux/gfp.h>
 #include <linux/syscore_ops.h>
+#include <linux/version.h>
+#include <linux/ctype.h>
=20
 #include <linux/compat.h>
 #include <linux/syscalls.h>
@@ -45,6 +47,8 @@
 #include <linux/user_namespace.h>
=20
 #include <linux/kmsg_dump.h>
+/* Move somewhere else to avoid recompiling? */
+#include <generated/utsrelease.h>
=20
 #include <asm/uaccess.h>
 #include <asm/io.h>
@@ -1124,6 +1128,34 @@ DECLARE_RWSEM(uts_sem);
 #define override_architecture(name)	0
 #endif
=20
+/*
+ * Work around broken programs that cannot handle "Linux 3.0".
+ * Instead we map 3.x to 2.6.40+x, so e.g. 3.0 would be 2.6.40
+ */
+static int override_release(char __user *release, int len)
+{
+	int ret =3D 0;
+	char buf[len];
+
+	if (current->personality & UNAME26) {
+		char *rest =3D UTS_RELEASE;
+		int ndots =3D 0;
+		unsigned v;
+
+		while (*rest) {
+			if (*rest =3D=3D '.' && ++ndots >=3D 3)
+				break;
+			if (!isdigit(*rest) && *rest !=3D '.')
+				break;
+			rest++;
+		}
+		v =3D ((LINUX_VERSION_CODE >> 8) & 0xff) + 40;
+		snprintf(buf, len, "2.6.%u%s", v, rest);
+		ret =3D copy_to_user(release, buf, len);
+	}
+	return ret;
+}
+
 SYSCALL_DEFINE1(newuname, struct new_utsname __user *, name)
 {
 	int errno =3D 0;
@@ -1133,6 +1165,8 @@ SYSCALL_DEFINE1(newuname, struct new_utsname __user *=
, name)
 		errno =3D -EFAULT;
 	up_read(&uts_sem);
=20
+	if (!errno && override_release(name->release, sizeof(name->release)))
+		errno =3D -EFAULT;
 	if (!errno && override_architecture(name))
 		errno =3D -EFAULT;
 	return errno;
@@ -1154,6 +1188,8 @@ SYSCALL_DEFINE1(uname, struct old_utsname __user *, n=
ame)
 		error =3D -EFAULT;
 	up_read(&uts_sem);
=20
+	if (!error && override_release(name->release, sizeof(name->release)))
+		error =3D -EFAULT;
 	if (!error && override_architecture(name))
 		error =3D -EFAULT;
 	return error;
@@ -1188,6 +1224,8 @@ SYSCALL_DEFINE1(olduname, struct oldold_utsname __use=
r *, name)
=20
 	if (!error && override_architecture(name))
 		error =3D -EFAULT;
+	if (!error && override_release(name->release, sizeof(name->release)))
+		error =3D -EFAULT;
 	return error ? -EFAULT : 0;
 }
 #endif
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 229f859..f807407 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -677,6 +677,7 @@ struct event_subsystem {
 	struct dentry		*entry;
 	struct event_filter	*filter;
 	int			nr_events;
+	int			ref_count;
 };
=20
 #define FILTER_PRED_INVALID	((unsigned short)-1)
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 686ec39..3e2a7c9 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -244,6 +244,35 @@ static void ftrace_clear_events(void)
 	mutex_unlock(&event_mutex);
 }
=20
+static void __put_system(struct event_subsystem *system)
+{
+	struct event_filter *filter =3D system->filter;
+
+	WARN_ON_ONCE(system->ref_count =3D=3D 0);
+	if (--system->ref_count)
+		return;
+
+	if (filter) {
+		kfree(filter->filter_string);
+		kfree(filter);
+	}
+	kfree(system->name);
+	kfree(system);
+}
+
+static void __get_system(struct event_subsystem *system)
+{
+	WARN_ON_ONCE(system->ref_count =3D=3D 0);
+	system->ref_count++;
+}
+
+static void put_system(struct event_subsystem *system)
+{
+	mutex_lock(&event_mutex);
+	__put_system(system);
+	mutex_unlock(&event_mutex);
+}
+
 /*
  * __ftrace_set_clr_event(NULL, NULL, NULL, set) will set/unset all events.
  */
@@ -528,7 +557,7 @@ system_enable_read(struct file *filp, char __user *ubuf=
, size_t cnt,
 		   loff_t *ppos)
 {
 	const char set_to_char[4] =3D { '?', '0', '1', 'X' };
-	const char *system =3D filp->private_data;
+	struct event_subsystem *system =3D filp->private_data;
 	struct ftrace_event_call *call;
 	char buf[2];
 	int set =3D 0;
@@ -539,7 +568,7 @@ system_enable_read(struct file *filp, char __user *ubuf=
, size_t cnt,
 		if (!call->name || !call->class || !call->class->reg)
 			continue;
=20
-		if (system && strcmp(call->class->system, system) !=3D 0)
+		if (system && strcmp(call->class->system, system->name) !=3D 0)
 			continue;
=20
 		/*
@@ -569,7 +598,8 @@ static ssize_t
 system_enable_write(struct file *filp, const char __user *ubuf, size_t cnt,
 		    loff_t *ppos)
 {
-	const char *system =3D filp->private_data;
+	struct event_subsystem *system =3D filp->private_data;
+	const char *name =3D NULL;
 	unsigned long val;
 	char buf[64];
 	ssize_t ret;
@@ -593,7 +623,14 @@ system_enable_write(struct file *filp, const char __us=
er *ubuf, size_t cnt,
 	if (val !=3D 0 && val !=3D 1)
 		return -EINVAL;
=20
-	ret =3D __ftrace_set_clr_event(NULL, system, NULL, val);
+	/*
+	 * Opening of "enable" adds a ref count to system,
+	 * so the name is safe to use.
+	 */
+	if (system)
+		name =3D system->name;
+
+	ret =3D __ftrace_set_clr_event(NULL, name, NULL, val);
 	if (ret)
 		goto out;
=20
@@ -826,6 +863,52 @@ event_filter_write(struct file *filp, const char __use=
r *ubuf, size_t cnt,
 	return cnt;
 }
=20
+static LIST_HEAD(event_subsystems);
+
+static int subsystem_open(struct inode *inode, struct file *filp)
+{
+	struct event_subsystem *system =3D NULL;
+	int ret;
+
+	if (!inode->i_private)
+		goto skip_search;
+
+	/* Make sure the system still exists */
+	mutex_lock(&event_mutex);
+	list_for_each_entry(system, &event_subsystems, list) {
+		if (system =3D=3D inode->i_private) {
+			/* Don't open systems with no events */
+			if (!system->nr_events) {
+				system =3D NULL;
+				break;
+			}
+			__get_system(system);
+			break;
+		}
+	}
+	mutex_unlock(&event_mutex);
+
+	if (system !=3D inode->i_private)
+		return -ENODEV;
+
+ skip_search:
+	ret =3D tracing_open_generic(inode, filp);
+	if (ret < 0 && system)
+		put_system(system);
+
+	return ret;
+}
+
+static int subsystem_release(struct inode *inode, struct file *file)
+{
+	struct event_subsystem *system =3D inode->i_private;
+
+	if (system)
+		put_system(system);
+
+	return 0;
+}
+
 static ssize_t
 subsystem_filter_read(struct file *filp, char __user *ubuf, size_t cnt,
 		      loff_t *ppos)
@@ -963,17 +1046,19 @@ static const struct file_operations ftrace_event_fil=
ter_fops =3D {
 };
=20
 static const struct file_operations ftrace_subsystem_filter_fops =3D {
-	.open =3D tracing_open_generic,
+	.open =3D subsystem_open,
 	.read =3D subsystem_filter_read,
 	.write =3D subsystem_filter_write,
 	.llseek =3D default_llseek,
+	.release =3D subsystem_release,
 };
=20
 static const struct file_operations ftrace_system_enable_fops =3D {
-	.open =3D tracing_open_generic,
+	.open =3D subsystem_open,
 	.read =3D system_enable_read,
 	.write =3D system_enable_write,
 	.llseek =3D default_llseek,
+	.release =3D subsystem_release,
 };
=20
 static const struct file_operations ftrace_show_header_fops =3D {
@@ -1002,8 +1087,6 @@ static struct dentry *event_trace_events_dir(void)
 	return d_events;
 }
=20
-static LIST_HEAD(event_subsystems);
-
 static struct dentry *
 event_subsystem_dir(const char *name, struct dentry *d_events)
 {
@@ -1013,6 +1096,7 @@ event_subsystem_dir(const char *name, struct dentry *=
d_events)
 	/* First see if we did not already create this dir */
 	list_for_each_entry(system, &event_subsystems, list) {
 		if (strcmp(system->name, name) =3D=3D 0) {
+			__get_system(system);
 			system->nr_events++;
 			return system->entry;
 		}
@@ -1035,6 +1119,7 @@ event_subsystem_dir(const char *name, struct dentry *=
d_events)
 	}
=20
 	system->nr_events =3D 1;
+	system->ref_count =3D 1;
 	system->name =3D kstrdup(name, GFP_KERNEL);
 	if (!system->name) {
 		debugfs_remove(system->entry);
@@ -1062,8 +1147,7 @@ event_subsystem_dir(const char *name, struct dentry *=
d_events)
 			   "'%s/filter' entry\n", name);
 	}
=20
-	trace_create_file("enable", 0644, system->entry,
-			  (void *)system->name,
+	trace_create_file("enable", 0644, system->entry, system,
 			  &ftrace_system_enable_fops);
=20
 	return system->entry;
@@ -1184,16 +1268,9 @@ static void remove_subsystem_dir(const char *name)
 	list_for_each_entry(system, &event_subsystems, list) {
 		if (strcmp(system->name, name) =3D=3D 0) {
 			if (!--system->nr_events) {
-				struct event_filter *filter =3D system->filter;
-
 				debugfs_remove_recursive(system->entry);
 				list_del(&system->list);
-				if (filter) {
-					kfree(filter->filter_string);
-					kfree(filter);
-				}
-				kfree(system->name);
-				kfree(system);
+				__put_system(system);
 			}
 			break;
 		}
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events=
_filter.c
index 8008ddc..256764e 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -1886,6 +1886,12 @@ int apply_subsystem_event_filter(struct event_subsys=
tem *system,
=20
 	mutex_lock(&event_mutex);
=20
+	/* Make sure the system still has events */
+	if (!system->nr_events) {
+		err =3D -ENODEV;
+		goto out_unlock;
+	}
+
 	if (!strcmp(strstrip(filter_string), "0")) {
 		filter_free_subsystem_preds(system);
 		remove_filter_string(system->filter);
diff --git a/lib/Makefile b/lib/Makefile
index 6b597fd..578414a 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -10,7 +10,7 @@ endif
 lib-y :=3D ctype.o string.o vsprintf.o cmdline.o \
 	 rbtree.o radix-tree.o dump_stack.o timerqueue.o\
 	 idr.o int_sqrt.o extable.o prio_tree.o \
-	 sha1.o irq_regs.o reciprocal_div.o argv_split.o \
+	 sha1.o md5.o irq_regs.o reciprocal_div.o argv_split.o \
 	 proportions.o prio_heap.o ratelimit.o show_mem.o \
 	 is_single_threaded.o plist.o decompress.o find_next_bit.o
=20
diff --git a/lib/md5.c b/lib/md5.c
new file mode 100644
index 0000000..c777180
--- /dev/null
+++ b/lib/md5.c
@@ -0,0 +1,95 @@
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/cryptohash.h>
+
+#define F1(x, y, z)	(z ^ (x & (y ^ z)))
+#define F2(x, y, z)	F1(z, x, y)
+#define F3(x, y, z)	(x ^ y ^ z)
+#define F4(x, y, z)	(y ^ (x | ~z))
+
+#define MD5STEP(f, w, x, y, z, in, s) \
+	(w +=3D f(x, y, z) + in, w =3D (w<<s | w>>(32-s)) + x)
+
+void md5_transform(__u32 *hash, __u32 const *in)
+{
+	u32 a, b, c, d;
+
+	a =3D hash[0];
+	b =3D hash[1];
+	c =3D hash[2];
+	d =3D hash[3];
+
+	MD5STEP(F1, a, b, c, d, in[0] + 0xd76aa478, 7);
+	MD5STEP(F1, d, a, b, c, in[1] + 0xe8c7b756, 12);
+	MD5STEP(F1, c, d, a, b, in[2] + 0x242070db, 17);
+	MD5STEP(F1, b, c, d, a, in[3] + 0xc1bdceee, 22);
+	MD5STEP(F1, a, b, c, d, in[4] + 0xf57c0faf, 7);
+	MD5STEP(F1, d, a, b, c, in[5] + 0x4787c62a, 12);
+	MD5STEP(F1, c, d, a, b, in[6] + 0xa8304613, 17);
+	MD5STEP(F1, b, c, d, a, in[7] + 0xfd469501, 22);
+	MD5STEP(F1, a, b, c, d, in[8] + 0x698098d8, 7);
+	MD5STEP(F1, d, a, b, c, in[9] + 0x8b44f7af, 12);
+	MD5STEP(F1, c, d, a, b, in[10] + 0xffff5bb1, 17);
+	MD5STEP(F1, b, c, d, a, in[11] + 0x895cd7be, 22);
+	MD5STEP(F1, a, b, c, d, in[12] + 0x6b901122, 7);
+	MD5STEP(F1, d, a, b, c, in[13] + 0xfd987193, 12);
+	MD5STEP(F1, c, d, a, b, in[14] + 0xa679438e, 17);
+	MD5STEP(F1, b, c, d, a, in[15] + 0x49b40821, 22);
+
+	MD5STEP(F2, a, b, c, d, in[1] + 0xf61e2562, 5);
+	MD5STEP(F2, d, a, b, c, in[6] + 0xc040b340, 9);
+	MD5STEP(F2, c, d, a, b, in[11] + 0x265e5a51, 14);
+	MD5STEP(F2, b, c, d, a, in[0] + 0xe9b6c7aa, 20);
+	MD5STEP(F2, a, b, c, d, in[5] + 0xd62f105d, 5);
+	MD5STEP(F2, d, a, b, c, in[10] + 0x02441453, 9);
+	MD5STEP(F2, c, d, a, b, in[15] + 0xd8a1e681, 14);
+	MD5STEP(F2, b, c, d, a, in[4] + 0xe7d3fbc8, 20);
+	MD5STEP(F2, a, b, c, d, in[9] + 0x21e1cde6, 5);
+	MD5STEP(F2, d, a, b, c, in[14] + 0xc33707d6, 9);
+	MD5STEP(F2, c, d, a, b, in[3] + 0xf4d50d87, 14);
+	MD5STEP(F2, b, c, d, a, in[8] + 0x455a14ed, 20);
+	MD5STEP(F2, a, b, c, d, in[13] + 0xa9e3e905, 5);
+	MD5STEP(F2, d, a, b, c, in[2] + 0xfcefa3f8, 9);
+	MD5STEP(F2, c, d, a, b, in[7] + 0x676f02d9, 14);
+	MD5STEP(F2, b, c, d, a, in[12] + 0x8d2a4c8a, 20);
+
+	MD5STEP(F3, a, b, c, d, in[5] + 0xfffa3942, 4);
+	MD5STEP(F3, d, a, b, c, in[8] + 0x8771f681, 11);
+	MD5STEP(F3, c, d, a, b, in[11] + 0x6d9d6122, 16);
+	MD5STEP(F3, b, c, d, a, in[14] + 0xfde5380c, 23);
+	MD5STEP(F3, a, b, c, d, in[1] + 0xa4beea44, 4);
+	MD5STEP(F3, d, a, b, c, in[4] + 0x4bdecfa9, 11);
+	MD5STEP(F3, c, d, a, b, in[7] + 0xf6bb4b60, 16);
+	MD5STEP(F3, b, c, d, a, in[10] + 0xbebfbc70, 23);
+	MD5STEP(F3, a, b, c, d, in[13] + 0x289b7ec6, 4);
+	MD5STEP(F3, d, a, b, c, in[0] + 0xeaa127fa, 11);
+	MD5STEP(F3, c, d, a, b, in[3] + 0xd4ef3085, 16);
+	MD5STEP(F3, b, c, d, a, in[6] + 0x04881d05, 23);
+	MD5STEP(F3, a, b, c, d, in[9] + 0xd9d4d039, 4);
+	MD5STEP(F3, d, a, b, c, in[12] + 0xe6db99e5, 11);
+	MD5STEP(F3, c, d, a, b, in[15] + 0x1fa27cf8, 16);
+	MD5STEP(F3, b, c, d, a, in[2] + 0xc4ac5665, 23);
+
+	MD5STEP(F4, a, b, c, d, in[0] + 0xf4292244, 6);
+	MD5STEP(F4, d, a, b, c, in[7] + 0x432aff97, 10);
+	MD5STEP(F4, c, d, a, b, in[14] + 0xab9423a7, 15);
+	MD5STEP(F4, b, c, d, a, in[5] + 0xfc93a039, 21);
+	MD5STEP(F4, a, b, c, d, in[12] + 0x655b59c3, 6);
+	MD5STEP(F4, d, a, b, c, in[3] + 0x8f0ccc92, 10);
+	MD5STEP(F4, c, d, a, b, in[10] + 0xffeff47d, 15);
+	MD5STEP(F4, b, c, d, a, in[1] + 0x85845dd1, 21);
+	MD5STEP(F4, a, b, c, d, in[8] + 0x6fa87e4f, 6);
+	MD5STEP(F4, d, a, b, c, in[15] + 0xfe2ce6e0, 10);
+	MD5STEP(F4, c, d, a, b, in[6] + 0xa3014314, 15);
+	MD5STEP(F4, b, c, d, a, in[13] + 0x4e0811a1, 21);
+	MD5STEP(F4, a, b, c, d, in[4] + 0xf7537e82, 6);
+	MD5STEP(F4, d, a, b, c, in[11] + 0xbd3af235, 10);
+	MD5STEP(F4, c, d, a, b, in[2] + 0x2ad7d2bb, 15);
+	MD5STEP(F4, b, c, d, a, in[9] + 0xeb86d391, 21);
+
+	hash[0] +=3D a;
+	hash[1] +=3D b;
+	hash[2] +=3D c;
+	hash[3] +=3D d;
+}
+EXPORT_SYMBOL(md5_transform);
diff --git a/lib/xz/xz_private.h b/lib/xz/xz_private.h
index a65633e..482b90f 100644
--- a/lib/xz/xz_private.h
+++ b/lib/xz/xz_private.h
@@ -12,7 +12,7 @@
=20
 #ifdef __KERNEL__
 #	include <linux/xz.h>
-#	include <asm/byteorder.h>
+#	include <linux/kernel.h>
 #	include <asm/unaligned.h>
 	/* XZ_PREBOOT may be defined only via decompress_unxz.c. */
 #	ifndef XZ_PREBOOT
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index f032e6e..e56fe35 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -606,6 +606,7 @@ static void bdi_prune_sb(struct backing_dev_info *bdi)
 void bdi_unregister(struct backing_dev_info *bdi)
 {
 	if (bdi->dev) {
+		bdi_set_min_ratio(bdi, 0);
 		trace_writeback_bdi_unregister(bdi);
 		bdi_prune_sb(bdi);
 		del_timer_sync(&bdi->wb.wakeup_timer);
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index e013b8e..59ac5d6 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1730,7 +1730,7 @@ static int mem_cgroup_hierarchical_reclaim(struct mem=
_cgroup *root_mem,
 	excess =3D res_counter_soft_limit_excess(&root_mem->res) >> PAGE_SHIFT;
=20
 	/* If memsw_is_minimum=3D=3D1, swap-out is of-no-use. */
-	if (!check_soft && root_mem->memsw_is_minimum)
+	if (!check_soft && !shrink && root_mem->memsw_is_minimum)
 		noswap =3D true;
=20
 	while (1) {
diff --git a/mm/memory.c b/mm/memory.c
index 9b8a01d..d961e19 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1816,7 +1816,63 @@ next_page:
 }
 EXPORT_SYMBOL(__get_user_pages);
=20
-/**
+/*
+ * fixup_user_fault() - manually resolve a user page fault
+ * @tsk:	the task_struct to use for page fault accounting, or
+ *		NULL if faults are not to be recorded.
+ * @mm:		mm_struct of target mm
+ * @address:	user address
+ * @fault_flags:flags to pass down to handle_mm_fault()
+ *
+ * This is meant to be called in the specific scenario where for locking r=
easons
+ * we try to access user memory in atomic context (within a pagefault_disa=
ble()
+ * section), this returns -EFAULT, and we want to resolve the user fault b=
efore
+ * trying again.
+ *
+ * Typically this is meant to be used by the futex code.
+ *
+ * The main difference with get_user_pages() is that this function will
+ * unconditionally call handle_mm_fault() which will in turn perform all t=
he
+ * necessary SW fixup of the dirty and young bits in the PTE, while
+ * handle_mm_fault() only guarantees to update these in the struct page.
+ *
+ * This is important for some architectures where those bits also gate the
+ * access permission to the page because they are maintained in software. =
 On
+ * such architectures, gup() will not be enough to make a subsequent access
+ * succeed.
+ *
+ * This should be called with the mm_sem held for read.
+ */
+int fixup_user_fault(struct task_struct *tsk, struct mm_struct *mm,
+		     unsigned long address, unsigned int fault_flags)
+{
+	struct vm_area_struct *vma;
+	int ret;
+
+	vma =3D find_extend_vma(mm, address);
+	if (!vma || address < vma->vm_start)
+		return -EFAULT;
+
+	ret =3D handle_mm_fault(mm, vma, address, fault_flags);
+	if (ret & VM_FAULT_ERROR) {
+		if (ret & VM_FAULT_OOM)
+			return -ENOMEM;
+		if (ret & (VM_FAULT_HWPOISON | VM_FAULT_HWPOISON_LARGE))
+			return -EHWPOISON;
+		if (ret & VM_FAULT_SIGBUS)
+			return -EFAULT;
+		BUG();
+	}
+	if (tsk) {
+		if (ret & VM_FAULT_MAJOR)
+			tsk->maj_flt++;
+		else
+			tsk->min_flt++;
+	}
+	return 0;
+}
+
+/*
  * get_user_pages() - pin user pages in memory
  * @tsk:	the task_struct to use for page fault accounting, or
  *		NULL if faults are not to be recorded.
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index e4b0991..8093fc7 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -303,7 +303,7 @@ static struct task_struct *select_bad_process(unsigned =
int *ppoints,
 	do_each_thread(g, p) {
 		unsigned int points;
=20
-		if (!p->mm)
+		if (p->exit_state)
 			continue;
 		if (oom_unkillable_task(p, mem, nodemask))
 			continue;
@@ -319,6 +319,8 @@ static struct task_struct *select_bad_process(unsigned =
int *ppoints,
 		 */
 		if (test_tsk_thread_flag(p, TIF_MEMDIE))
 			return ERR_PTR(-1UL);
+		if (!p->mm)
+			continue;
=20
 		if (p->flags & PF_EXITING) {
 			/*
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 1d34d75..d3d451b 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -732,9 +732,10 @@ static void free_unmap_vmap_area_addr(unsigned long ad=
dr)
 #define VMAP_BBMAP_BITS_MIN	(VMAP_MAX_ALLOC*2)
 #define VMAP_MIN(x, y)		((x) < (y) ? (x) : (y)) /* can't use min() */
 #define VMAP_MAX(x, y)		((x) > (y) ? (x) : (y)) /* can't use max() */
-#define VMAP_BBMAP_BITS		VMAP_MIN(VMAP_BBMAP_BITS_MAX,		\
-					VMAP_MAX(VMAP_BBMAP_BITS_MIN,	\
-						VMALLOC_PAGES / NR_CPUS / 16))
+#define VMAP_BBMAP_BITS		\
+		VMAP_MIN(VMAP_BBMAP_BITS_MAX,	\
+		VMAP_MAX(VMAP_BBMAP_BITS_MIN,	\
+			VMALLOC_PAGES / roundup_pow_of_two(NR_CPUS) / 16))
=20
 #define VMAP_BLOCK_SIZE		(VMAP_BBMAP_BITS * PAGE_SIZE)
=20
diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index 6e82148..5b4f51d 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -694,7 +694,7 @@ void vlan_setup(struct net_device *dev)
 	ether_setup(dev);
=20
 	dev->priv_flags		|=3D IFF_802_1Q_VLAN;
-	dev->priv_flags		&=3D ~IFF_XMIT_DST_RELEASE;
+	dev->priv_flags		&=3D ~(IFF_XMIT_DST_RELEASE | IFF_TX_SKB_SHARING);
 	dev->tx_queue_len	=3D 0;
=20
 	dev->netdev_ops		=3D &vlan_netdev_ops;
diff --git a/net/atm/br2684.c b/net/atm/br2684.c
index 2252c20..52cfd0c 100644
--- a/net/atm/br2684.c
+++ b/net/atm/br2684.c
@@ -242,8 +242,6 @@ static int br2684_xmit_vcc(struct sk_buff *skb, struct =
net_device *dev,
 		if (brdev->payload =3D=3D p_bridged) {
 			skb_push(skb, 2);
 			memset(skb->data, 0, 2);
-		} else { /* p_routed */
-			skb_pull(skb, ETH_HLEN);
 		}
 	}
 	skb_debug(skb);
diff --git a/net/bluetooth/bnep/netdev.c b/net/bluetooth/bnep/netdev.c
index 8c100c9..d4f5dff 100644
--- a/net/bluetooth/bnep/netdev.c
+++ b/net/bluetooth/bnep/netdev.c
@@ -231,6 +231,7 @@ void bnep_net_setup(struct net_device *dev)
 	dev->addr_len =3D ETH_ALEN;
=20
 	ether_setup(dev);
+	dev->priv_flags &=3D ~IFF_TX_SKB_SHARING;
 	dev->netdev_ops =3D &bnep_netdev_ops;
=20
 	dev->watchdog_timeo  =3D HZ * 2;
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 54578f2..78cc364 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -124,6 +124,7 @@ struct net_bridge_port
 	bridge_id			designated_bridge;
 	u32				path_cost;
 	u32				designated_cost;
+	unsigned long			designated_age;
=20
 	struct timer_list		forward_delay_timer;
 	struct timer_list		hold_timer;
diff --git a/net/bridge/br_stp.c b/net/bridge/br_stp.c
index bb4383e..fcff622 100644
--- a/net/bridge/br_stp.c
+++ b/net/bridge/br_stp.c
@@ -164,8 +164,7 @@ void br_transmit_config(struct net_bridge_port *p)
 	else {
 		struct net_bridge_port *root
 			=3D br_get_port(br, br->root_port);
-		bpdu.message_age =3D br->max_age
-			- (root->message_age_timer.expires - jiffies)
+		bpdu.message_age =3D (jiffies - root->designated_age)
 			+ MESSAGE_AGE_INCR;
 	}
 	bpdu.max_age =3D br->max_age;
@@ -189,6 +188,7 @@ static inline void br_record_config_information(struct =
net_bridge_port *p,
 	p->designated_cost =3D bpdu->root_path_cost;
 	p->designated_bridge =3D bpdu->bridge_id;
 	p->designated_port =3D bpdu->port_id;
+	p->designated_age =3D jiffies + bpdu->message_age;
=20
 	mod_timer(&p->message_age_timer, jiffies
 		  + (p->br->max_age - bpdu->message_age));
diff --git a/net/core/Makefile b/net/core/Makefile
index 8a04dd2..0d357b1 100644
--- a/net/core/Makefile
+++ b/net/core/Makefile
@@ -3,7 +3,7 @@
 #
=20
 obj-y :=3D sock.o request_sock.o skbuff.o iovec.o datagram.o stream.o scm.=
o \
-	 gen_stats.o gen_estimator.o net_namespace.o
+	 gen_stats.o gen_estimator.o net_namespace.o secure_seq.o
=20
 obj-$(CONFIG_SYSCTL) +=3D sysctl_net_core.o
=20
diff --git a/net/core/ethtool.c b/net/core/ethtool.c
index fd14116..4fb7704 100644
--- a/net/core/ethtool.c
+++ b/net/core/ethtool.c
@@ -1227,7 +1227,7 @@ static int ethtool_get_regs(struct net_device *dev, c=
har __user *useraddr)
 		regs.len =3D reglen;
=20
 	regbuf =3D vzalloc(reglen);
-	if (!regbuf)
+	if (reglen && !regbuf)
 		return -ENOMEM;
=20
 	ops->get_regs(dev, &regs, regbuf);
@@ -1236,7 +1236,7 @@ static int ethtool_get_regs(struct net_device *dev, c=
har __user *useraddr)
 	if (copy_to_user(useraddr, &regs, sizeof(regs)))
 		goto out;
 	useraddr +=3D offsetof(struct ethtool_regs, data);
-	if (copy_to_user(useraddr, regbuf, regs.len))
+	if (regbuf && copy_to_user(useraddr, regbuf, regs.len))
 		goto out;
 	ret =3D 0;
=20
diff --git a/net/core/link_watch.c b/net/core/link_watch.c
index a7b3421..357bd4e 100644
--- a/net/core/link_watch.c
+++ b/net/core/link_watch.c
@@ -126,7 +126,7 @@ static void linkwatch_schedule_work(int urgent)
 		return;
=20
 	/* It's already running which is good enough. */
-	if (!cancel_delayed_work(&linkwatch_work))
+	if (!__cancel_delayed_work(&linkwatch_work))
 		return;
=20
 	/* Otherwise we reschedule it again for immediate execution. */
diff --git a/net/core/pktgen.c b/net/core/pktgen.c
index f76079c..e35a6fb 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -1070,7 +1070,9 @@ static ssize_t pktgen_if_write(struct file *file,
 		len =3D num_arg(&user_buffer[i], 10, &value);
 		if (len < 0)
 			return len;
-
+		if ((value > 0) &&
+		    (!(pkt_dev->odev->priv_flags & IFF_TX_SKB_SHARING)))
+			return -ENOTSUPP;
 		i +=3D len;
 		pkt_dev->clone_skb =3D value;
=20
@@ -3555,7 +3557,6 @@ static int pktgen_add_device(struct pktgen_thread *t,=
 const char *ifname)
 	pkt_dev->min_pkt_size =3D ETH_ZLEN;
 	pkt_dev->max_pkt_size =3D ETH_ZLEN;
 	pkt_dev->nfrags =3D 0;
-	pkt_dev->clone_skb =3D pg_clone_skb_d;
 	pkt_dev->delay =3D pg_delay_d;
 	pkt_dev->count =3D pg_count_d;
 	pkt_dev->sofar =3D 0;
@@ -3563,7 +3564,6 @@ static int pktgen_add_device(struct pktgen_thread *t,=
 const char *ifname)
 	pkt_dev->udp_src_max =3D 9;
 	pkt_dev->udp_dst_min =3D 9;
 	pkt_dev->udp_dst_max =3D 9;
-
 	pkt_dev->vlan_p =3D 0;
 	pkt_dev->vlan_cfi =3D 0;
 	pkt_dev->vlan_id =3D 0xffff;
@@ -3575,6 +3575,8 @@ static int pktgen_add_device(struct pktgen_thread *t,=
 const char *ifname)
 	err =3D pktgen_setup_dev(pkt_dev, ifname);
 	if (err)
 		goto out1;
+	if (pkt_dev->odev->priv_flags & IFF_TX_SKB_SHARING)
+		pkt_dev->clone_skb =3D pg_clone_skb_d;
=20
 	pkt_dev->entry =3D proc_create_data(ifname, 0600, pg_proc_dir,
 					  &pktgen_if_fops, pkt_dev);
diff --git a/net/core/secure_seq.c b/net/core/secure_seq.c
new file mode 100644
index 0000000..45329d7
--- /dev/null
+++ b/net/core/secure_seq.c
@@ -0,0 +1,184 @@
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/cryptohash.h>
+#include <linux/module.h>
+#include <linux/cache.h>
+#include <linux/random.h>
+#include <linux/hrtimer.h>
+#include <linux/ktime.h>
+#include <linux/string.h>
+
+#include <net/secure_seq.h>
+
+static u32 net_secret[MD5_MESSAGE_BYTES / 4] ____cacheline_aligned;
+
+static int __init net_secret_init(void)
+{
+	get_random_bytes(net_secret, sizeof(net_secret));
+	return 0;
+}
+late_initcall(net_secret_init);
+
+static u32 seq_scale(u32 seq)
+{
+	/*
+	 *	As close as possible to RFC 793, which
+	 *	suggests using a 250 kHz clock.
+	 *	Further reading shows this assumes 2 Mb/s networks.
+	 *	For 10 Mb/s Ethernet, a 1 MHz clock is appropriate.
+	 *	For 10 Gb/s Ethernet, a 1 GHz clock should be ok, but
+	 *	we also need to limit the resolution so that the u32 seq
+	 *	overlaps less than one time per MSL (2 minutes).
+	 *	Choosing a clock of 64 ns period is OK. (period of 274 s)
+	 */
+	return seq + (ktime_to_ns(ktime_get_real()) >> 6);
+}
+
+#if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
+__u32 secure_tcpv6_sequence_number(__be32 *saddr, __be32 *daddr,
+				   __be16 sport, __be16 dport)
+{
+	u32 secret[MD5_MESSAGE_BYTES / 4];
+	u32 hash[MD5_DIGEST_WORDS];
+	u32 i;
+
+	memcpy(hash, saddr, 16);
+	for (i =3D 0; i < 4; i++)
+		secret[i] =3D net_secret[i] + daddr[i];
+	secret[4] =3D net_secret[4] +
+		(((__force u16)sport << 16) + (__force u16)dport);
+	for (i =3D 5; i < MD5_MESSAGE_BYTES / 4; i++)
+		secret[i] =3D net_secret[i];
+
+	md5_transform(hash, secret);
+
+	return seq_scale(hash[0]);
+}
+EXPORT_SYMBOL(secure_tcpv6_sequence_number);
+
+u32 secure_ipv6_port_ephemeral(const __be32 *saddr, const __be32 *daddr,
+			       __be16 dport)
+{
+	u32 secret[MD5_MESSAGE_BYTES / 4];
+	u32 hash[MD5_DIGEST_WORDS];
+	u32 i;
+
+	memcpy(hash, saddr, 16);
+	for (i =3D 0; i < 4; i++)
+		secret[i] =3D net_secret[i] + (__force u32) daddr[i];
+	secret[4] =3D net_secret[4] + (__force u32)dport;
+	for (i =3D 5; i < MD5_MESSAGE_BYTES / 4; i++)
+		secret[i] =3D net_secret[i];
+
+	md5_transform(hash, secret);
+
+	return hash[0];
+}
+#endif
+
+#ifdef CONFIG_INET
+__u32 secure_ip_id(__be32 daddr)
+{
+	u32 hash[MD5_DIGEST_WORDS];
+
+	hash[0] =3D (__force __u32) daddr;
+	hash[1] =3D net_secret[13];
+	hash[2] =3D net_secret[14];
+	hash[3] =3D net_secret[15];
+
+	md5_transform(hash, net_secret);
+
+	return hash[0];
+}
+
+__u32 secure_ipv6_id(const __be32 daddr[4])
+{
+	__u32 hash[4];
+
+	memcpy(hash, daddr, 16);
+	md5_transform(hash, net_secret);
+
+	return hash[0];
+}
+
+__u32 secure_tcp_sequence_number(__be32 saddr, __be32 daddr,
+				 __be16 sport, __be16 dport)
+{
+	u32 hash[MD5_DIGEST_WORDS];
+
+	hash[0] =3D (__force u32)saddr;
+	hash[1] =3D (__force u32)daddr;
+	hash[2] =3D ((__force u16)sport << 16) + (__force u16)dport;
+	hash[3] =3D net_secret[15];
+
+	md5_transform(hash, net_secret);
+
+	return seq_scale(hash[0]);
+}
+
+u32 secure_ipv4_port_ephemeral(__be32 saddr, __be32 daddr, __be16 dport)
+{
+	u32 hash[MD5_DIGEST_WORDS];
+
+	hash[0] =3D (__force u32)saddr;
+	hash[1] =3D (__force u32)daddr;
+	hash[2] =3D (__force u32)dport ^ net_secret[14];
+	hash[3] =3D net_secret[15];
+
+	md5_transform(hash, net_secret);
+
+	return hash[0];
+}
+EXPORT_SYMBOL_GPL(secure_ipv4_port_ephemeral);
+#endif
+
+#if defined(CONFIG_IP_DCCP) || defined(CONFIG_IP_DCCP_MODULE)
+u64 secure_dccp_sequence_number(__be32 saddr, __be32 daddr,
+				__be16 sport, __be16 dport)
+{
+	u32 hash[MD5_DIGEST_WORDS];
+	u64 seq;
+
+	hash[0] =3D (__force u32)saddr;
+	hash[1] =3D (__force u32)daddr;
+	hash[2] =3D ((__force u16)sport << 16) + (__force u16)dport;
+	hash[3] =3D net_secret[15];
+
+	md5_transform(hash, net_secret);
+
+	seq =3D hash[0] | (((u64)hash[1]) << 32);
+	seq +=3D ktime_to_ns(ktime_get_real());
+	seq &=3D (1ull << 48) - 1;
+
+	return seq;
+}
+EXPORT_SYMBOL(secure_dccp_sequence_number);
+
+#if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
+u64 secure_dccpv6_sequence_number(__be32 *saddr, __be32 *daddr,
+				  __be16 sport, __be16 dport)
+{
+	u32 secret[MD5_MESSAGE_BYTES / 4];
+	u32 hash[MD5_DIGEST_WORDS];
+	u64 seq;
+	u32 i;
+
+	memcpy(hash, saddr, 16);
+	for (i =3D 0; i < 4; i++)
+		secret[i] =3D net_secret[i] + daddr[i];
+	secret[4] =3D net_secret[4] +
+		(((__force u16)sport << 16) + (__force u16)dport);
+	for (i =3D 5; i < MD5_MESSAGE_BYTES / 4; i++)
+		secret[i] =3D net_secret[i];
+
+	md5_transform(hash, secret);
+
+	seq =3D hash[0] | (((u64)hash[1]) << 32);
+	seq +=3D ktime_to_ns(ktime_get_real());
+	seq &=3D (1ull << 48) - 1;
+
+	return seq;
+}
+EXPORT_SYMBOL(secure_dccpv6_sequence_number);
+#endif
+#endif
diff --git a/net/dccp/ipv4.c b/net/dccp/ipv4.c
index 8c36adf..332639b 100644
--- a/net/dccp/ipv4.c
+++ b/net/dccp/ipv4.c
@@ -26,6 +26,7 @@
 #include <net/timewait_sock.h>
 #include <net/tcp_states.h>
 #include <net/xfrm.h>
+#include <net/secure_seq.h>
=20
 #include "ackvec.h"
 #include "ccid.h"
diff --git a/net/dccp/ipv6.c b/net/dccp/ipv6.c
index 8dc4348..b74f761 100644
--- a/net/dccp/ipv6.c
+++ b/net/dccp/ipv6.c
@@ -29,6 +29,7 @@
 #include <net/transp_v6.h>
 #include <net/ip6_checksum.h>
 #include <net/xfrm.h>
+#include <net/secure_seq.h>
=20
 #include "dccp.h"
 #include "ipv6.h"
@@ -69,13 +70,7 @@ static inline void dccp_v6_send_check(struct sock *sk, s=
truct sk_buff *skb)
 	dh->dccph_checksum =3D dccp_v6_csum_finish(skb, &np->saddr, &np->daddr);
 }
=20
-static inline __u32 secure_dccpv6_sequence_number(__be32 *saddr, __be32 *d=
addr,
-						  __be16 sport, __be16 dport   )
-{
-	return secure_tcpv6_sequence_number(saddr, daddr, sport, dport);
-}
-
-static inline __u32 dccp_v6_init_sequence(struct sk_buff *skb)
+static inline __u64 dccp_v6_init_sequence(struct sk_buff *skb)
 {
 	return secure_dccpv6_sequence_number(ipv6_hdr(skb)->daddr.s6_addr32,
 					     ipv6_hdr(skb)->saddr.s6_addr32,
diff --git a/net/ethernet/eth.c b/net/ethernet/eth.c
index 44d2b42..2780e9b 100644
--- a/net/ethernet/eth.c
+++ b/net/ethernet/eth.c
@@ -340,6 +340,7 @@ void ether_setup(struct net_device *dev)
 	dev->addr_len		=3D ETH_ALEN;
 	dev->tx_queue_len	=3D 1000;	/* Ethernet wants good queues */
 	dev->flags		=3D IFF_BROADCAST|IFF_MULTICAST;
+	dev->priv_flags		=3D IFF_TX_SKB_SHARING;
=20
 	memset(dev->broadcast, 0xFF, ETH_ALEN);
=20
diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index 0d4a184..4155abc 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -1134,15 +1134,15 @@ static void inetdev_send_gratuitous_arp(struct net_=
device *dev,
 					struct in_device *in_dev)
=20
 {
-	struct in_ifaddr *ifa =3D in_dev->ifa_list;
-
-	if (!ifa)
-		return;
+	struct in_ifaddr *ifa;
=20
-	arp_send(ARPOP_REQUEST, ETH_P_ARP,
-		 ifa->ifa_local, dev,
-		 ifa->ifa_local, NULL,
-		 dev->dev_addr, NULL);
+	for (ifa =3D in_dev->ifa_list; ifa;
+	     ifa =3D ifa->ifa_next) {
+		arp_send(ARPOP_REQUEST, ETH_P_ARP,
+			 ifa->ifa_local, dev,
+			 ifa->ifa_local, NULL,
+			 dev->dev_addr, NULL);
+	}
 }
=20
 /* Called only under RTNL semaphore */
diff --git a/net/ipv4/gre.c b/net/ipv4/gre.c
index c6933f2..3e3f75d 100644
--- a/net/ipv4/gre.c
+++ b/net/ipv4/gre.c
@@ -15,6 +15,7 @@
 #include <linux/kmod.h>
 #include <linux/skbuff.h>
 #include <linux/in.h>
+#include <linux/ip.h>
 #include <linux/netdevice.h>
 #include <linux/version.h>
 #include <linux/spinlock.h>
@@ -97,27 +98,17 @@ drop:
 static void gre_err(struct sk_buff *skb, u32 info)
 {
 	const struct gre_protocol *proto;
-	u8 ver;
-
-	if (!pskb_may_pull(skb, 12))
-		goto drop;
+	const struct iphdr *iph =3D (const struct iphdr *)skb->data;
+	u8 ver =3D skb->data[(iph->ihl<<2) + 1]&0x7f;
=20
-	ver =3D skb->data[1]&0x7f;
 	if (ver >=3D GREPROTO_MAX)
-		goto drop;
+		return;
=20
 	rcu_read_lock();
 	proto =3D rcu_dereference(gre_proto[ver]);
-	if (!proto || !proto->err_handler)
-		goto drop_unlock;
-	proto->err_handler(skb, info);
-	rcu_read_unlock();
-	return;
-
-drop_unlock:
+	if (proto && proto->err_handler)
+		proto->err_handler(skb, info);
 	rcu_read_unlock();
-drop:
-	kfree_skb(skb);
 }
=20
 static const struct net_protocol net_gre_protocol =3D {
diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index 5395e45..23ef31b 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -380,6 +380,7 @@ static struct rtable *icmp_route_lookup(struct net *net,
 					struct icmp_bxm *param)
 {
 	struct rtable *rt, *rt2;
+	struct flowi4 fl4_dec;
 	int err;
=20
 	memset(fl4, 0, sizeof(*fl4));
@@ -408,19 +409,19 @@ static struct rtable *icmp_route_lookup(struct net *n=
et,
 	} else
 		return rt;
=20
-	err =3D xfrm_decode_session_reverse(skb_in, flowi4_to_flowi(fl4), AF_INET=
);
+	err =3D xfrm_decode_session_reverse(skb_in, flowi4_to_flowi(&fl4_dec), AF=
_INET);
 	if (err)
 		goto relookup_failed;
=20
-	if (inet_addr_type(net, fl4->saddr) =3D=3D RTN_LOCAL) {
-		rt2 =3D __ip_route_output_key(net, fl4);
+	if (inet_addr_type(net, fl4_dec.saddr) =3D=3D RTN_LOCAL) {
+		rt2 =3D __ip_route_output_key(net, &fl4_dec);
 		if (IS_ERR(rt2))
 			err =3D PTR_ERR(rt2);
 	} else {
 		struct flowi4 fl4_2 =3D {};
 		unsigned long orefdst;
=20
-		fl4_2.daddr =3D fl4->saddr;
+		fl4_2.daddr =3D fl4_dec.saddr;
 		rt2 =3D ip_route_output_key(net, &fl4_2);
 		if (IS_ERR(rt2)) {
 			err =3D PTR_ERR(rt2);
@@ -428,7 +429,7 @@ static struct rtable *icmp_route_lookup(struct net *net,
 		}
 		/* Ugh! */
 		orefdst =3D skb_in->_skb_refdst; /* save old refdst */
-		err =3D ip_route_input(skb_in, fl4->daddr, fl4->saddr,
+		err =3D ip_route_input(skb_in, fl4_dec.daddr, fl4_dec.saddr,
 				     RT_TOS(tos), rt2->dst.dev);
=20
 		dst_release(&rt2->dst);
@@ -440,10 +441,11 @@ static struct rtable *icmp_route_lookup(struct net *n=
et,
 		goto relookup_failed;
=20
 	rt2 =3D (struct rtable *) xfrm_lookup(net, &rt2->dst,
-					    flowi4_to_flowi(fl4), NULL,
+					    flowi4_to_flowi(&fl4_dec), NULL,
 					    XFRM_LOOKUP_ICMP);
 	if (!IS_ERR(rt2)) {
 		dst_release(&rt->dst);
+		memcpy(fl4, &fl4_dec, sizeof(*fl4));
 		rt =3D rt2;
 	} else if (PTR_ERR(rt2) =3D=3D -EPERM) {
 		if (rt)
diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
index f1d27f6..283c0a2 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -1718,7 +1718,7 @@ static int ip_mc_add_src(struct in_device *in_dev, __=
be32 *pmca, int sfmode,
=20
 		pmc->sfcount[sfmode]--;
 		for (j=3D0; j<i; j++)
-			(void) ip_mc_del1_src(pmc, sfmode, &psfsrc[i]);
+			(void) ip_mc_del1_src(pmc, sfmode, &psfsrc[j]);
 	} else if (isexclude !=3D (pmc->sfcount[MCAST_EXCLUDE] !=3D 0)) {
 #ifdef CONFIG_IP_MULTICAST
 		struct ip_sf_list *psf;
diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index 3c0369a..984ec65 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -21,6 +21,7 @@
=20
 #include <net/inet_connection_sock.h>
 #include <net/inet_hashtables.h>
+#include <net/secure_seq.h>
 #include <net/ip.h>
=20
 /*
diff --git a/net/ipv4/inetpeer.c b/net/ipv4/inetpeer.c
index ce616d9..6877645 100644
--- a/net/ipv4/inetpeer.c
+++ b/net/ipv4/inetpeer.c
@@ -19,6 +19,7 @@
 #include <linux/net.h>
 #include <net/ip.h>
 #include <net/inetpeer.h>
+#include <net/secure_seq.h>
=20
 /*
  *  Theory of operations.
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 84f26e8..0c99db4 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -734,7 +734,7 @@ static inline int ip_ufo_append_data(struct sock *sk,
 			int getfrag(void *from, char *to, int offset, int len,
 			       int odd, struct sk_buff *skb),
 			void *from, int length, int hh_len, int fragheaderlen,
-			int transhdrlen, int mtu, unsigned int flags)
+			int transhdrlen, int maxfraglen, unsigned int flags)
 {
 	struct sk_buff *skb;
 	int err;
@@ -767,7 +767,7 @@ static inline int ip_ufo_append_data(struct sock *sk,
 		skb->csum =3D 0;
=20
 		/* specify the length of each IP datagram fragment */
-		skb_shinfo(skb)->gso_size =3D mtu - fragheaderlen;
+		skb_shinfo(skb)->gso_size =3D maxfraglen - fragheaderlen;
 		skb_shinfo(skb)->gso_type =3D SKB_GSO_UDP;
 		__skb_queue_tail(queue, skb);
 	}
@@ -831,7 +831,7 @@ static int __ip_append_data(struct sock *sk,
 	    (rt->dst.dev->features & NETIF_F_UFO) && !rt->dst.header_len) {
 		err =3D ip_ufo_append_data(sk, queue, getfrag, from, length,
 					 hh_len, fragheaderlen, transhdrlen,
-					 mtu, flags);
+					 maxfraglen, flags);
 		if (err)
 			goto error;
 		return 0;
diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index 30a7763..f81af8d 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -1796,7 +1796,7 @@ static struct mr_table *ipmr_rt_fib_lookup(struct net=
 *net, struct sk_buff *skb)
 	struct flowi4 fl4 =3D {
 		.daddr =3D iph->daddr,
 		.saddr =3D iph->saddr,
-		.flowi4_tos =3D iph->tos,
+		.flowi4_tos =3D RT_TOS(iph->tos),
 		.flowi4_oif =3D rt->rt_oif,
 		.flowi4_iif =3D rt->rt_iif,
 		.flowi4_mark =3D rt->rt_mark,
diff --git a/net/ipv4/netfilter/nf_nat_proto_common.c b/net/ipv4/netfilter/=
nf_nat_proto_common.c
index 3e61faf..f52d41e 100644
--- a/net/ipv4/netfilter/nf_nat_proto_common.c
+++ b/net/ipv4/netfilter/nf_nat_proto_common.c
@@ -12,6 +12,7 @@
 #include <linux/ip.h>
=20
 #include <linux/netfilter.h>
+#include <net/secure_seq.h>
 #include <net/netfilter/nf_nat.h>
 #include <net/netfilter/nf_nat_core.h>
 #include <net/netfilter/nf_nat_rule.h>
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index aa13ef1..cdabdbf 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -108,6 +108,7 @@
 #ifdef CONFIG_SYSCTL
 #include <linux/sysctl.h>
 #endif
+#include <net/secure_seq.h>
=20
 #define RT_FL_TOS(oldflp4) \
     ((u32)(oldflp4->flowi4_tos & (IPTOS_RT_MASK | RTO_ONLINK)))
@@ -725,6 +726,7 @@ static inline int compare_keys(struct rtable *rt1, stru=
ct rtable *rt2)
 		((__force u32)rt1->rt_key_src ^ (__force u32)rt2->rt_key_src) |
 		(rt1->rt_mark ^ rt2->rt_mark) |
 		(rt1->rt_key_tos ^ rt2->rt_key_tos) |
+		(rt1->rt_route_iif ^ rt2->rt_route_iif) |
 		(rt1->rt_oif ^ rt2->rt_oif) |
 		(rt1->rt_iif ^ rt2->rt_iif)) =3D=3D 0;
 }
@@ -1703,7 +1705,7 @@ void ip_rt_get_source(u8 *addr, struct sk_buff *skb, =
struct rtable *rt)
 		memset(&fl4, 0, sizeof(fl4));
 		fl4.daddr =3D iph->daddr;
 		fl4.saddr =3D iph->saddr;
-		fl4.flowi4_tos =3D iph->tos;
+		fl4.flowi4_tos =3D RT_TOS(iph->tos);
 		fl4.flowi4_oif =3D rt->dst.dev->ifindex;
 		fl4.flowi4_iif =3D skb->dev->ifindex;
 		fl4.flowi4_mark =3D skb->mark;
@@ -2281,8 +2283,8 @@ int ip_route_input_common(struct sk_buff *skb, __be32=
 daddr, __be32 saddr,
 		if ((((__force u32)rth->rt_key_dst ^ (__force u32)daddr) |
 		     ((__force u32)rth->rt_key_src ^ (__force u32)saddr) |
 		     (rth->rt_iif ^ iif) |
-		     rth->rt_oif |
 		     (rth->rt_key_tos ^ tos)) =3D=3D 0 &&
+		    rt_is_input_route(rth) &&
 		    rth->rt_mark =3D=3D skb->mark &&
 		    net_eq(dev_net(rth->dst.dev), net) &&
 		    !rt_is_expired(rth)) {
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 708dc20..b3e6956 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -72,6 +72,7 @@
 #include <net/timewait_sock.h>
 #include <net/xfrm.h>
 #include <net/netdma.h>
+#include <net/secure_seq.h>
=20
 #include <linux/inet.h>
 #include <linux/ipv6.h>
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index 3b5669a..5591236 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -1078,6 +1078,8 @@ static int __init inet6_init(void)
 		goto out;
 	}
=20
+	initialize_hashidentrnd();
+
 	err =3D proto_register(&tcpv6_prot, 1);
 	if (err)
 		goto out;
diff --git a/net/ipv6/inet6_hashtables.c b/net/ipv6/inet6_hashtables.c
index b531972..73f1a00 100644
--- a/net/ipv6/inet6_hashtables.c
+++ b/net/ipv6/inet6_hashtables.c
@@ -20,6 +20,7 @@
 #include <net/inet_connection_sock.h>
 #include <net/inet_hashtables.h>
 #include <net/inet6_hashtables.h>
+#include <net/secure_seq.h>
 #include <net/ip.h>
=20
 int __inet6_hash(struct sock *sk, struct inet_timewait_sock *tw)
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 9d4b165..1661296 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -596,6 +596,35 @@ int ip6_find_1stfragopt(struct sk_buff *skb, u8 **next=
hdr)
 	return offset;
 }
=20
+static u32 hashidentrnd __read_mostly;
+#define FID_HASH_SZ 16
+static u32 ipv6_fragmentation_id[FID_HASH_SZ];
+
+void __init initialize_hashidentrnd(void)
+{
+	get_random_bytes(&hashidentrnd, sizeof(hashidentrnd));
+}
+
+static u32 __ipv6_select_ident(const struct in6_addr *addr)
+{
+	u32 newid, oldid, hash =3D jhash2((u32 *)addr, 4, hashidentrnd);
+	u32 *pid =3D &ipv6_fragmentation_id[hash % FID_HASH_SZ];
+
+	do {
+		oldid =3D *pid;
+		newid =3D oldid + 1;
+		if (!(hash + newid))
+			newid++;
+	} while (cmpxchg(pid, oldid, newid) !=3D oldid);
+
+	return hash + newid;
+}
+
+void ipv6_select_ident(struct frag_hdr *fhdr, struct rt6_info *rt)
+{
+	fhdr->identification =3D htonl(__ipv6_select_ident(&rt->rt6i_dst.addr));
+}
+
 int ip6_fragment(struct sk_buff *skb, int (*output)(struct sk_buff *))
 {
 	struct sk_buff *frag;
@@ -680,7 +709,7 @@ int ip6_fragment(struct sk_buff *skb, int (*output)(str=
uct sk_buff *))
 		skb_reset_network_header(skb);
 		memcpy(skb_network_header(skb), tmp_hdr, hlen);
=20
-		ipv6_select_ident(fh);
+		ipv6_select_ident(fh, rt);
 		fh->nexthdr =3D nexthdr;
 		fh->reserved =3D 0;
 		fh->frag_off =3D htons(IP6_MF);
@@ -826,7 +855,7 @@ slow_path:
 		fh->nexthdr =3D nexthdr;
 		fh->reserved =3D 0;
 		if (!frag_id) {
-			ipv6_select_ident(fh);
+			ipv6_select_ident(fh, rt);
 			frag_id =3D fh->identification;
 		} else
 			fh->identification =3D frag_id;
@@ -1072,7 +1101,8 @@ static inline int ip6_ufo_append_data(struct sock *sk,
 			int getfrag(void *from, char *to, int offset, int len,
 			int odd, struct sk_buff *skb),
 			void *from, int length, int hh_len, int fragheaderlen,
-			int transhdrlen, int mtu,unsigned int flags)
+			int transhdrlen, int mtu,unsigned int flags,
+			struct rt6_info *rt)
=20
 {
 	struct sk_buff *skb;
@@ -1116,7 +1146,7 @@ static inline int ip6_ufo_append_data(struct sock *sk,
 		skb_shinfo(skb)->gso_size =3D (mtu - fragheaderlen -
 					     sizeof(struct frag_hdr)) & ~7;
 		skb_shinfo(skb)->gso_type =3D SKB_GSO_UDP;
-		ipv6_select_ident(&fhdr);
+		ipv6_select_ident(&fhdr, rt);
 		skb_shinfo(skb)->ip6_frag_id =3D fhdr.identification;
 		__skb_queue_tail(&sk->sk_write_queue, skb);
=20
@@ -1282,7 +1312,7 @@ int ip6_append_data(struct sock *sk, int getfrag(void=
 *from, char *to,
=20
 			err =3D ip6_ufo_append_data(sk, getfrag, from, length,
 						  hh_len, fragheaderlen,
-						  transhdrlen, mtu, flags);
+						  transhdrlen, mtu, flags, rt);
 			if (err)
 				goto error;
 			return 0;
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 87551ca..7c43e86 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -61,6 +61,7 @@
 #include <net/timewait_sock.h>
 #include <net/netdma.h>
 #include <net/inet_common.h>
+#include <net/secure_seq.h>
=20
 #include <asm/uaccess.h>
=20
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 328985c..29213b5 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1359,7 +1359,7 @@ static struct sk_buff *udp6_ufo_fragment(struct sk_bu=
ff *skb, u32 features)
 	fptr =3D (struct frag_hdr *)(skb_network_header(skb) + unfrag_ip6hlen);
 	fptr->nexthdr =3D nexthdr;
 	fptr->reserved =3D 0;
-	ipv6_select_ident(fptr);
+	ipv6_select_ident(fptr, (struct rt6_info *)skb_dst(skb));
=20
 	/* Fragment the skb. ipv6 header and the remaining fields of the
 	 * fragment header are updated in ipv6_gso_segment()
diff --git a/net/l2tp/l2tp_eth.c b/net/l2tp/l2tp_eth.c
index a8193f5..d2726a7 100644
--- a/net/l2tp/l2tp_eth.c
+++ b/net/l2tp/l2tp_eth.c
@@ -103,7 +103,7 @@ static struct net_device_ops l2tp_eth_netdev_ops =3D {
 static void l2tp_eth_dev_setup(struct net_device *dev)
 {
 	ether_setup(dev);
-
+	dev->priv_flags &=3D ~IFF_TX_SKB_SHARING;
 	dev->netdev_ops		=3D &l2tp_eth_netdev_ops;
 	dev->destructor		=3D free_netdev;
 }
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index dee30ae..895eec1 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -699,6 +699,7 @@ static const struct net_device_ops ieee80211_monitorif_=
ops =3D {
 static void ieee80211_if_setup(struct net_device *dev)
 {
 	ether_setup(dev);
+	dev->priv_flags &=3D ~IFF_TX_SKB_SHARING;
 	dev->netdev_ops =3D &ieee80211_dataif_ops;
 	dev->destructor =3D free_netdev;
 }
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index d595265..7a334fd 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2200,6 +2200,9 @@ void ieee80211_sta_restart(struct ieee80211_sub_if_da=
ta *sdata)
 {
 	struct ieee80211_if_managed *ifmgd =3D &sdata->u.mgd;
=20
+	if (!ifmgd->associated)
+		return;
+
 	if (test_and_clear_bit(TMR_RUNNING_TIMER, &ifmgd->timers_running))
 		add_timer(&ifmgd->timer);
 	if (test_and_clear_bit(TMR_RUNNING_CHANSW, &ifmgd->timers_running))
diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index 699c79a..a178cb3 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -3771,6 +3771,7 @@ err_sock:
 void ip_vs_control_cleanup(void)
 {
 	EnterFunction(2);
+	unregister_netdevice_notifier(&ip_vs_dst_notifier);
 	ip_vs_genl_unregister();
 	nf_unregister_sockopt(&ip_vs_sockopts);
 	LeaveFunction(2);
diff --git a/net/sched/sch_sfq.c b/net/sched/sch_sfq.c
index b6ea6af..69400e3 100644
--- a/net/sched/sch_sfq.c
+++ b/net/sched/sch_sfq.c
@@ -410,7 +410,12 @@ sfq_enqueue(struct sk_buff *skb, struct Qdisc *sch)
 	/* Return Congestion Notification only if we dropped a packet
 	 * from this flow.
 	 */
-	return (qlen !=3D slot->qlen) ? NET_XMIT_CN : NET_XMIT_SUCCESS;
+	if (qlen !=3D slot->qlen)
+		return NET_XMIT_CN;
+
+	/* As we dropped a packet, better let upper stack know this */
+	qdisc_tree_decrease_qlen(sch, 1);
+	return NET_XMIT_SUCCESS;
 }
=20
 static struct sk_buff *
diff --git a/net/socket.c b/net/socket.c
index 02dc82d..ed46dbb 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -1871,8 +1871,14 @@ SYSCALL_DEFINE2(shutdown, int, fd, int, how)
 #define COMPAT_NAMELEN(msg)	COMPAT_MSG(msg, msg_namelen)
 #define COMPAT_FLAGS(msg)	COMPAT_MSG(msg, msg_flags)
=20
+struct used_address {
+	struct sockaddr_storage name;
+	unsigned int name_len;
+};
+
 static int __sys_sendmsg(struct socket *sock, struct msghdr __user *msg,
-			 struct msghdr *msg_sys, unsigned flags, int nosec)
+			 struct msghdr *msg_sys, unsigned flags,
+			 struct used_address *used_address)
 {
 	struct compat_msghdr __user *msg_compat =3D
 	    (struct compat_msghdr __user *)msg;
@@ -1953,8 +1959,28 @@ static int __sys_sendmsg(struct socket *sock, struct=
 msghdr __user *msg,
=20
 	if (sock->file->f_flags & O_NONBLOCK)
 		msg_sys->msg_flags |=3D MSG_DONTWAIT;
-	err =3D (nosec ? sock_sendmsg_nosec : sock_sendmsg)(sock, msg_sys,
-							  total_len);
+	/*
+	 * If this is sendmmsg() and current destination address is same as
+	 * previously succeeded address, omit asking LSM's decision.
+	 * used_address->name_len is initialized to UINT_MAX so that the first
+	 * destination address never matches.
+	 */
+	if (used_address && used_address->name_len =3D=3D msg_sys->msg_namelen &&
+	    !memcmp(&used_address->name, msg->msg_name,
+		    used_address->name_len)) {
+		err =3D sock_sendmsg_nosec(sock, msg_sys, total_len);
+		goto out_freectl;
+	}
+	err =3D sock_sendmsg(sock, msg_sys, total_len);
+	/*
+	 * If this is sendmmsg() and sending to current destination address was
+	 * successful, remember it.
+	 */
+	if (used_address && err >=3D 0) {
+		used_address->name_len =3D msg_sys->msg_namelen;
+		memcpy(&used_address->name, msg->msg_name,
+		       used_address->name_len);
+	}
=20
 out_freectl:
 	if (ctl_buf !=3D ctl)
@@ -1979,7 +2005,7 @@ SYSCALL_DEFINE3(sendmsg, int, fd, struct msghdr __use=
r *, msg, unsigned, flags)
 	if (!sock)
 		goto out;
=20
-	err =3D __sys_sendmsg(sock, msg, &msg_sys, flags, 0);
+	err =3D __sys_sendmsg(sock, msg, &msg_sys, flags, NULL);
=20
 	fput_light(sock->file, fput_needed);
 out:
@@ -1998,6 +2024,10 @@ int __sys_sendmmsg(int fd, struct mmsghdr __user *mm=
sg, unsigned int vlen,
 	struct mmsghdr __user *entry;
 	struct compat_mmsghdr __user *compat_entry;
 	struct msghdr msg_sys;
+	struct used_address used_address;
+
+	if (vlen > UIO_MAXIOV)
+		vlen =3D UIO_MAXIOV;
=20
 	datagrams =3D 0;
=20
@@ -2005,27 +2035,22 @@ int __sys_sendmmsg(int fd, struct mmsghdr __user *m=
msg, unsigned int vlen,
 	if (!sock)
 		return err;
=20
-	err =3D sock_error(sock->sk);
-	if (err)
-		goto out_put;
-
+	used_address.name_len =3D UINT_MAX;
 	entry =3D mmsg;
 	compat_entry =3D (struct compat_mmsghdr __user *)mmsg;
+	err =3D 0;
=20
 	while (datagrams < vlen) {
-		/*
-		 * No need to ask LSM for more than the first datagram.
-		 */
 		if (MSG_CMSG_COMPAT & flags) {
 			err =3D __sys_sendmsg(sock, (struct msghdr __user *)compat_entry,
-					    &msg_sys, flags, datagrams);
+					    &msg_sys, flags, &used_address);
 			if (err < 0)
 				break;
 			err =3D __put_user(err, &compat_entry->msg_len);
 			++compat_entry;
 		} else {
 			err =3D __sys_sendmsg(sock, (struct msghdr __user *)entry,
-					    &msg_sys, flags, datagrams);
+					    &msg_sys, flags, &used_address);
 			if (err < 0)
 				break;
 			err =3D put_user(err, &entry->msg_len);
@@ -2037,29 +2062,11 @@ int __sys_sendmmsg(int fd, struct mmsghdr __user *m=
msg, unsigned int vlen,
 		++datagrams;
 	}
=20
-out_put:
 	fput_light(sock->file, fput_needed);
=20
-	if (err =3D=3D 0)
-		return datagrams;
-
-	if (datagrams !=3D 0) {
-		/*
-		 * We may send less entries than requested (vlen) if the
-		 * sock is non blocking...
-		 */
-		if (err !=3D -EAGAIN) {
-			/*
-			 * ... or if sendmsg returns an error after we
-			 * send some datagrams, where we record the
-			 * error to return on the next call or if the
-			 * app asks about it using getsockopt(SO_ERROR).
-			 */
-			sock->sk->sk_err =3D -err;
-		}
-
+	/* We only return an error if no datagrams were able to be sent */
+	if (datagrams !=3D 0)
 		return datagrams;
-	}
=20
 	return err;
 }
diff --git a/net/sunrpc/svc_xprt.c b/net/sunrpc/svc_xprt.c
index ab86b79..bd31208 100644
--- a/net/sunrpc/svc_xprt.c
+++ b/net/sunrpc/svc_xprt.c
@@ -902,12 +902,13 @@ void svc_delete_xprt(struct svc_xprt *xprt)
 	if (!test_and_set_bit(XPT_DETACHED, &xprt->xpt_flags))
 		list_del_init(&xprt->xpt_list);
 	/*
-	 * We used to delete the transport from whichever list
-	 * it's sk_xprt.xpt_ready node was on, but we don't actually
-	 * need to.  This is because the only time we're called
-	 * while still attached to a queue, the queue itself
-	 * is about to be destroyed (in svc_destroy).
+	 * The only time we're called while xpt_ready is still on a list
+	 * is while the list itself is about to be destroyed (in
+	 * svc_destroy).  BUT svc_xprt_enqueue could still be attempting
+	 * to add new entries to the sp_sockets list, so we can't leave
+	 * a freed xprt on it.
 	 */
+	list_del_init(&xprt->xpt_ready);
 	if (test_bit(XPT_TEMP, &xprt->xpt_flags))
 		serv->sv_tmpcnt--;
 	spin_unlock_bh(&serv->sv_lock);
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 1ad0f39..4453eb7 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1125,12 +1125,13 @@ void wiphy_update_regulatory(struct wiphy *wiphy,
 	enum ieee80211_band band;
=20
 	if (ignore_reg_update(wiphy, initiator))
-		goto out;
+		return;
+
 	for (band =3D 0; band < IEEE80211_NUM_BANDS; band++) {
 		if (wiphy->bands[band])
 			handle_band(wiphy, band, initiator);
 	}
-out:
+
 	reg_process_beacons(wiphy);
 	reg_process_ht_flags(wiphy);
 	if (wiphy->reg_notifier)
diff --git a/net/xfrm/xfrm_algo.c b/net/xfrm/xfrm_algo.c
index 58064d9..791ab2e 100644
--- a/net/xfrm/xfrm_algo.c
+++ b/net/xfrm/xfrm_algo.c
@@ -462,8 +462,8 @@ static struct xfrm_algo_desc ealg_list[] =3D {
 	.desc =3D {
 		.sadb_alg_id =3D SADB_X_EALG_AESCTR,
 		.sadb_alg_ivlen	=3D 8,
-		.sadb_alg_minbits =3D 128,
-		.sadb_alg_maxbits =3D 256
+		.sadb_alg_minbits =3D 160,
+		.sadb_alg_maxbits =3D 288
 	}
 },
 };
diff --git a/security/apparmor/domain.c b/security/apparmor/domain.c
index c825c6e..78adc43 100644
--- a/security/apparmor/domain.c
+++ b/security/apparmor/domain.c
@@ -73,7 +73,6 @@ static int may_change_ptraced_domain(struct task_struct *=
task,
 		cred =3D get_task_cred(tracer);
 		tracerp =3D aa_cred_profile(cred);
 	}
-	rcu_read_unlock();
=20
 	/* not ptraced */
 	if (!tracer || unconfined(tracerp))
@@ -82,6 +81,7 @@ static int may_change_ptraced_domain(struct task_struct *=
task,
 	error =3D aa_may_ptrace(tracer, tracerp, to_profile, PTRACE_MODE_ATTACH);
=20
 out:
+	rcu_read_unlock();
 	if (cred)
 		put_cred(cred);
=20
diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
index 3d2fd14..3783202 100644
--- a/security/apparmor/lsm.c
+++ b/security/apparmor/lsm.c
@@ -127,7 +127,7 @@ static int apparmor_capget(struct task_struct *target, =
kernel_cap_t *effective,
 	*inheritable =3D cred->cap_inheritable;
 	*permitted =3D cred->cap_permitted;
=20
-	if (!unconfined(profile)) {
+	if (!unconfined(profile) && !COMPLAIN_MODE(profile)) {
 		*effective =3D cap_intersect(*effective, profile->caps.allow);
 		*permitted =3D cap_intersect(*permitted, profile->caps.allow);
 	}
diff --git a/sound/core/pcm_compat.c b/sound/core/pcm_compat.c
index 5fb2e28..91cdf94 100644
--- a/sound/core/pcm_compat.c
+++ b/sound/core/pcm_compat.c
@@ -342,7 +342,7 @@ static int snd_pcm_ioctl_xfern_compat(struct snd_pcm_su=
bstream *substream,
 			kfree(bufs);
 			return -EFAULT;
 		}
-		bufs[ch] =3D compat_ptr(ptr);
+		bufs[i] =3D compat_ptr(ptr);
 		bufptr++;
 	}
 	if (dir =3D=3D SNDRV_PCM_STREAM_PLAYBACK)
diff --git a/sound/core/timer.c b/sound/core/timer.c
index 7c1cbf0..950eed0 100644
--- a/sound/core/timer.c
+++ b/sound/core/timer.c
@@ -531,6 +531,8 @@ int snd_timer_stop(struct snd_timer_instance *timeri)
 	if (err < 0)
 		return err;
 	timer =3D timeri->timer;
+	if (!timer)
+		return -EINVAL;
 	spin_lock_irqsave(&timer->lock, flags);
 	timeri->cticks =3D timeri->ticks;
 	timeri->pticks =3D 0;
diff --git a/sound/pci/ac97/ac97_patch.c b/sound/pci/ac97/ac97_patch.c
index 200c9a1..a872d0a 100644
--- a/sound/pci/ac97/ac97_patch.c
+++ b/sound/pci/ac97/ac97_patch.c
@@ -1909,6 +1909,7 @@ static unsigned int ad1981_jacks_whitelist[] =3D {
 	0x103c0944, /* HP nc6220 */
 	0x103c0934, /* HP nc8220 */
 	0x103c006d, /* HP nx9105 */
+	0x103c300d, /* HP Compaq dc5100 SFF(PT003AW) */
 	0x17340088, /* FSC Scenic-W */
 	0 /* end */
 };
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index b48fb43..524ff26 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -1578,13 +1578,15 @@ static void alc_init_auto_hp(struct hda_codec *code=
c)
 	if (present =3D=3D 3)
 		spec->automute_hp_lo =3D 1; /* both HP and LO automute */
=20
-	if (!cfg->speaker_pins[0]) {
+	if (!cfg->speaker_pins[0] &&
+	    cfg->line_out_type =3D=3D AUTO_PIN_SPEAKER_OUT) {
 		memcpy(cfg->speaker_pins, cfg->line_out_pins,
 		       sizeof(cfg->speaker_pins));
 		cfg->speaker_outs =3D cfg->line_outs;
 	}
=20
-	if (!cfg->hp_pins[0]) {
+	if (!cfg->hp_pins[0] &&
+	    cfg->line_out_type =3D=3D AUTO_PIN_HP_OUT) {
 		memcpy(cfg->hp_pins, cfg->line_out_pins,
 		       sizeof(cfg->hp_pins));
 		cfg->hp_outs =3D cfg->line_outs;
@@ -1603,6 +1605,7 @@ static void alc_init_auto_hp(struct hda_codec *codec)
 		spec->automute_mode =3D ALC_AUTOMUTE_PIN;
 	}
 	if (spec->automute && cfg->line_out_pins[0] &&
+	    cfg->speaker_pins[0] &&
 	    cfg->line_out_pins[0] !=3D cfg->hp_pins[0] &&
 	    cfg->line_out_pins[0] !=3D cfg->speaker_pins[0]) {
 		for (i =3D 0; i < cfg->line_outs; i++) {
diff --git a/sound/pci/oxygen/xonar_pcm179x.c b/sound/pci/oxygen/xonar_pcm1=
79x.c
index 54cad38..32d096c 100644
--- a/sound/pci/oxygen/xonar_pcm179x.c
+++ b/sound/pci/oxygen/xonar_pcm179x.c
@@ -327,8 +327,10 @@ static void pcm1796_init(struct oxygen *chip)
 {
 	struct xonar_pcm179x *data =3D chip->model_data;
=20
-	data->pcm1796_regs[0][18 - PCM1796_REG_BASE] =3D PCM1796_MUTE |
+	data->pcm1796_regs[0][18 - PCM1796_REG_BASE] =3D
 		PCM1796_DMF_DISABLED | PCM1796_FMT_24_I2S | PCM1796_ATLD;
+	if (!data->broken_i2c)
+		data->pcm1796_regs[0][18 - PCM1796_REG_BASE] |=3D PCM1796_MUTE;
 	data->pcm1796_regs[0][19 - PCM1796_REG_BASE] =3D
 		PCM1796_FLT_SHARP | PCM1796_ATS_1;
 	data->pcm1796_regs[0][20 - PCM1796_REG_BASE] =3D
@@ -1123,6 +1125,7 @@ int __devinit get_xonar_pcm179x_model(struct oxygen *=
chip,
 			chip->model.control_filter =3D xonar_st_h6_control_filter;
 			chip->model.dac_channels_pcm =3D 8;
 			chip->model.dac_channels_mixer =3D 8;
+			chip->model.dac_volume_min =3D 255;
 			chip->model.dac_mclks =3D OXYGEN_MCLKS(256, 128, 128);
 			break;
 		}
diff --git a/sound/soc/codecs/sgtl5000.c b/sound/soc/codecs/sgtl5000.c
index ff29380..c49317c 100644
--- a/sound/soc/codecs/sgtl5000.c
+++ b/sound/soc/codecs/sgtl5000.c
@@ -33,73 +33,31 @@
 #define SGTL5000_DAP_REG_OFFSET	0x0100
 #define SGTL5000_MAX_REG_OFFSET	0x013A
=20
-/* default value of sgtl5000 registers except DAP */
-static const u16 sgtl5000_regs[SGTL5000_MAX_REG_OFFSET >> 1] =3D  {
-	0xa011, /* 0x0000, CHIP_ID. 11 stand for revison 17 */
-	0x0000, /* 0x0002, CHIP_DIG_POWER. */
-	0x0008, /* 0x0004, CHIP_CKL_CTRL */
-	0x0010, /* 0x0006, CHIP_I2S_CTRL */
-	0x0000, /* 0x0008, reserved */
-	0x0008, /* 0x000A, CHIP_SSS_CTRL */
-	0x0000, /* 0x000C, reserved */
-	0x020c, /* 0x000E, CHIP_ADCDAC_CTRL */
-	0x3c3c, /* 0x0010, CHIP_DAC_VOL */
-	0x0000, /* 0x0012, reserved */
-	0x015f, /* 0x0014, CHIP_PAD_STRENGTH */
-	0x0000, /* 0x0016, reserved */
-	0x0000, /* 0x0018, reserved */
-	0x0000, /* 0x001A, reserved */
-	0x0000, /* 0x001E, reserved */
-	0x0000, /* 0x0020, CHIP_ANA_ADC_CTRL */
-	0x1818, /* 0x0022, CHIP_ANA_HP_CTRL */
-	0x0111, /* 0x0024, CHIP_ANN_CTRL */
-	0x0000, /* 0x0026, CHIP_LINREG_CTRL */
-	0x0000, /* 0x0028, CHIP_REF_CTRL */
-	0x0000, /* 0x002A, CHIP_MIC_CTRL */
-	0x0000, /* 0x002C, CHIP_LINE_OUT_CTRL */
-	0x0404, /* 0x002E, CHIP_LINE_OUT_VOL */
-	0x7060, /* 0x0030, CHIP_ANA_POWER */
-	0x5000, /* 0x0032, CHIP_PLL_CTRL */
-	0x0000, /* 0x0034, CHIP_CLK_TOP_CTRL */
-	0x0000, /* 0x0036, CHIP_ANA_STATUS */
-	0x0000, /* 0x0038, reserved */
-	0x0000, /* 0x003A, CHIP_ANA_TEST2 */
-	0x0000, /* 0x003C, CHIP_SHORT_CTRL */
-	0x0000, /* reserved */
-};
-
-/* default value of dap registers */
-static const u16 sgtl5000_dap_regs[] =3D {
-	0x0000, /* 0x0100, DAP_CONTROL */
-	0x0000, /* 0x0102, DAP_PEQ */
-	0x0040, /* 0x0104, DAP_BASS_ENHANCE */
-	0x051f, /* 0x0106, DAP_BASS_ENHANCE_CTRL */
-	0x0000, /* 0x0108, DAP_AUDIO_EQ */
-	0x0040, /* 0x010A, DAP_SGTL_SURROUND */
-	0x0000, /* 0x010C, DAP_FILTER_COEF_ACCESS */
-	0x0000, /* 0x010E, DAP_COEF_WR_B0_MSB */
-	0x0000, /* 0x0110, DAP_COEF_WR_B0_LSB */
-	0x0000, /* 0x0112, reserved */
-	0x0000, /* 0x0114, reserved */
-	0x002f, /* 0x0116, DAP_AUDIO_EQ_BASS_BAND0 */
-	0x002f, /* 0x0118, DAP_AUDIO_EQ_BAND0 */
-	0x002f, /* 0x011A, DAP_AUDIO_EQ_BAND2 */
-	0x002f, /* 0x011C, DAP_AUDIO_EQ_BAND3 */
-	0x002f, /* 0x011E, DAP_AUDIO_EQ_TREBLE_BAND4 */
-	0x8000, /* 0x0120, DAP_MAIN_CHAN */
-	0x0000, /* 0x0122, DAP_MIX_CHAN */
-	0x0510, /* 0x0124, DAP_AVC_CTRL */
-	0x1473, /* 0x0126, DAP_AVC_THRESHOLD */
-	0x0028, /* 0x0128, DAP_AVC_ATTACK */
-	0x0050, /* 0x012A, DAP_AVC_DECAY */
-	0x0000, /* 0x012C, DAP_COEF_WR_B1_MSB */
-	0x0000, /* 0x012E, DAP_COEF_WR_B1_LSB */
-	0x0000, /* 0x0130, DAP_COEF_WR_B2_MSB */
-	0x0000, /* 0x0132, DAP_COEF_WR_B2_LSB */
-	0x0000, /* 0x0134, DAP_COEF_WR_A1_MSB */
-	0x0000, /* 0x0136, DAP_COEF_WR_A1_LSB */
-	0x0000, /* 0x0138, DAP_COEF_WR_A2_MSB */
-	0x0000, /* 0x013A, DAP_COEF_WR_A2_LSB */
+/* default value of sgtl5000 registers */
+static const u16 sgtl5000_regs[SGTL5000_MAX_REG_OFFSET] =3D  {
+	[SGTL5000_CHIP_CLK_CTRL] =3D 0x0008,
+	[SGTL5000_CHIP_I2S_CTRL] =3D 0x0010,
+	[SGTL5000_CHIP_SSS_CTRL] =3D 0x0008,
+	[SGTL5000_CHIP_DAC_VOL] =3D 0x3c3c,
+	[SGTL5000_CHIP_PAD_STRENGTH] =3D 0x015f,
+	[SGTL5000_CHIP_ANA_HP_CTRL] =3D 0x1818,
+	[SGTL5000_CHIP_ANA_CTRL] =3D 0x0111,
+	[SGTL5000_CHIP_LINE_OUT_VOL] =3D 0x0404,
+	[SGTL5000_CHIP_ANA_POWER] =3D 0x7060,
+	[SGTL5000_CHIP_PLL_CTRL] =3D 0x5000,
+	[SGTL5000_DAP_BASS_ENHANCE] =3D 0x0040,
+	[SGTL5000_DAP_BASS_ENHANCE_CTRL] =3D 0x051f,
+	[SGTL5000_DAP_SURROUND] =3D 0x0040,
+	[SGTL5000_DAP_EQ_BASS_BAND0] =3D 0x002f,
+	[SGTL5000_DAP_EQ_BASS_BAND1] =3D 0x002f,
+	[SGTL5000_DAP_EQ_BASS_BAND2] =3D 0x002f,
+	[SGTL5000_DAP_EQ_BASS_BAND3] =3D 0x002f,
+	[SGTL5000_DAP_EQ_BASS_BAND4] =3D 0x002f,
+	[SGTL5000_DAP_MAIN_CHAN] =3D 0x8000,
+	[SGTL5000_DAP_AVC_CTRL] =3D 0x0510,
+	[SGTL5000_DAP_AVC_THRESHOLD] =3D 0x1473,
+	[SGTL5000_DAP_AVC_ATTACK] =3D 0x0028,
+	[SGTL5000_DAP_AVC_DECAY] =3D 0x0050,
 };
=20
 /* regulator supplies for sgtl5000, VDDD is an optional external supply */
@@ -1022,12 +980,10 @@ static int sgtl5000_suspend(struct snd_soc_codec *co=
dec, pm_message_t state)
 static int sgtl5000_restore_regs(struct snd_soc_codec *codec)
 {
 	u16 *cache =3D codec->reg_cache;
-	int i;
-	int regular_regs =3D SGTL5000_CHIP_SHORT_CTRL >> 1;
+	u16 reg;
=20
 	/* restore regular registers */
-	for (i =3D 0; i < regular_regs; i++) {
-		int reg =3D i << 1;
+	for (reg =3D 0; reg <=3D SGTL5000_CHIP_SHORT_CTRL; reg +=3D 2) {
=20
 		/* this regs depends on the others */
 		if (reg =3D=3D SGTL5000_CHIP_ANA_POWER ||
@@ -1037,35 +993,31 @@ static int sgtl5000_restore_regs(struct snd_soc_code=
c *codec)
 			reg =3D=3D SGTL5000_CHIP_CLK_CTRL)
 			continue;
=20
-		snd_soc_write(codec, reg, cache[i]);
+		snd_soc_write(codec, reg, cache[reg]);
 	}
=20
 	/* restore dap registers */
-	for (i =3D SGTL5000_DAP_REG_OFFSET >> 1;
-			i < SGTL5000_MAX_REG_OFFSET >> 1; i++) {
-		int reg =3D i << 1;
-
-		snd_soc_write(codec, reg, cache[i]);
-	}
+	for (reg =3D SGTL5000_DAP_REG_OFFSET; reg < SGTL5000_MAX_REG_OFFSET; reg =
+=3D 2)
+		snd_soc_write(codec, reg, cache[reg]);
=20
 	/*
 	 * restore power and other regs according
 	 * to set_power() and set_clock()
 	 */
 	snd_soc_write(codec, SGTL5000_CHIP_LINREG_CTRL,
-			cache[SGTL5000_CHIP_LINREG_CTRL >> 1]);
+			cache[SGTL5000_CHIP_LINREG_CTRL]);
=20
 	snd_soc_write(codec, SGTL5000_CHIP_ANA_POWER,
-			cache[SGTL5000_CHIP_ANA_POWER >> 1]);
+			cache[SGTL5000_CHIP_ANA_POWER]);
=20
 	snd_soc_write(codec, SGTL5000_CHIP_CLK_CTRL,
-			cache[SGTL5000_CHIP_CLK_CTRL >> 1]);
+			cache[SGTL5000_CHIP_CLK_CTRL]);
=20
 	snd_soc_write(codec, SGTL5000_CHIP_REF_CTRL,
-			cache[SGTL5000_CHIP_REF_CTRL >> 1]);
+			cache[SGTL5000_CHIP_REF_CTRL]);
=20
 	snd_soc_write(codec, SGTL5000_CHIP_LINE_OUT_CTRL,
-			cache[SGTL5000_CHIP_LINE_OUT_CTRL >> 1]);
+			cache[SGTL5000_CHIP_LINE_OUT_CTRL]);
 	return 0;
 }
=20
@@ -1460,16 +1412,6 @@ static __devinit int sgtl5000_i2c_probe(struct i2c_c=
lient *client,
 	if (!sgtl5000)
 		return -ENOMEM;
=20
-	/*
-	 * copy DAP default values to default value array.
-	 * sgtl5000 register space has a big hole, merge it
-	 * at init phase makes life easy.
-	 * FIXME: should we drop 'const' of sgtl5000_regs?
-	 */
-	memcpy((void *)(&sgtl5000_regs[0] + (SGTL5000_DAP_REG_OFFSET >> 1)),
-			sgtl5000_dap_regs,
-			SGTL5000_MAX_REG_OFFSET - SGTL5000_DAP_REG_OFFSET);
-
 	i2c_set_clientdata(client, sgtl5000);
=20
 	ret =3D snd_soc_register_codec(&client->dev,
diff --git a/sound/soc/davinci/davinci-vcif.c b/sound/soc/davinci/davinci-v=
cif.c
index 9259f1f..1f11525 100644
--- a/sound/soc/davinci/davinci-vcif.c
+++ b/sound/soc/davinci/davinci-vcif.c
@@ -62,9 +62,9 @@ static void davinci_vcif_start(struct snd_pcm_substream *=
substream)
 	w =3D readl(davinci_vc->base + DAVINCI_VC_CTRL);
=20
 	if (substream->stream =3D=3D SNDRV_PCM_STREAM_PLAYBACK)
-		MOD_REG_BIT(w, DAVINCI_VC_CTRL_RSTDAC, 1);
+		MOD_REG_BIT(w, DAVINCI_VC_CTRL_RSTDAC, 0);
 	else
-		MOD_REG_BIT(w, DAVINCI_VC_CTRL_RSTADC, 1);
+		MOD_REG_BIT(w, DAVINCI_VC_CTRL_RSTADC, 0);
=20
 	writel(w, davinci_vc->base + DAVINCI_VC_CTRL);
 }
@@ -80,9 +80,9 @@ static void davinci_vcif_stop(struct snd_pcm_substream *s=
ubstream)
 	/* Reset transmitter/receiver and sample rate/frame sync generators */
 	w =3D readl(davinci_vc->base + DAVINCI_VC_CTRL);
 	if (substream->stream =3D=3D SNDRV_PCM_STREAM_PLAYBACK)
-		MOD_REG_BIT(w, DAVINCI_VC_CTRL_RSTDAC, 0);
+		MOD_REG_BIT(w, DAVINCI_VC_CTRL_RSTDAC, 1);
 	else
-		MOD_REG_BIT(w, DAVINCI_VC_CTRL_RSTADC, 0);
+		MOD_REG_BIT(w, DAVINCI_VC_CTRL_RSTADC, 1);
=20
 	writel(w, davinci_vc->base + DAVINCI_VC_CTRL);
 }
@@ -159,6 +159,7 @@ static int davinci_vcif_trigger(struct snd_pcm_substrea=
m *substream, int cmd,
 	case SNDRV_PCM_TRIGGER_RESUME:
 	case SNDRV_PCM_TRIGGER_PAUSE_RELEASE:
 		davinci_vcif_start(substream);
+		break;
 	case SNDRV_PCM_TRIGGER_STOP:
 	case SNDRV_PCM_TRIGGER_SUSPEND:
 	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
diff --git a/sound/soc/samsung/jive_wm8750.c b/sound/soc/samsung/jive_wm875=
0.c
index 3b53ad5..14eb6ea 100644
--- a/sound/soc/samsung/jive_wm8750.c
+++ b/sound/soc/samsung/jive_wm8750.c
@@ -131,7 +131,7 @@ static struct snd_soc_dai_link jive_dai =3D {
 	.cpu_dai_name	=3D "s3c2412-i2s",
 	.codec_dai_name =3D "wm8750-hifi",
 	.platform_name	=3D "samsung-audio",
-	.codec_name	=3D "wm8750-codec.0-0x1a",
+	.codec_name	=3D "wm8750-codec.0-001a",
 	.init		=3D jive_wm8750_init,
 	.ops		=3D &jive_ops,
 };
diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index b194be0..59abd84 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -1124,6 +1124,7 @@ int snd_soc_suspend(struct device *dev)
 			case SND_SOC_BIAS_OFF:
 				codec->driver->suspend(codec, PMSG_SUSPEND);
 				codec->suspended =3D 1;
+				codec->cache_sync =3D 1;
 				break;
 			default:
 				dev_dbg(codec->dev, "CODEC is on over suspend\n");
diff --git a/sound/soc/tegra/tegra_pcm.c b/sound/soc/tegra/tegra_pcm.c
index 3c271f9..6201710 100644
--- a/sound/soc/tegra/tegra_pcm.c
+++ b/sound/soc/tegra/tegra_pcm.c
@@ -309,9 +309,14 @@ static int tegra_pcm_preallocate_dma_buffer(struct snd=
_pcm *pcm, int stream)
=20
 static void tegra_pcm_deallocate_dma_buffer(struct snd_pcm *pcm, int strea=
m)
 {
-	struct snd_pcm_substream *substream =3D pcm->streams[stream].substream;
-	struct snd_dma_buffer *buf =3D &substream->dma_buffer;
+	struct snd_pcm_substream *substream;
+	struct snd_dma_buffer *buf;
+
+	substream =3D pcm->streams[stream].substream;
+	if (!substream)
+		return;
=20
+	buf =3D &substream->dma_buffer;
 	if (!buf->area)
 		return;
=20
diff --git a/sound/soc/tegra/tegra_wm8903.c b/sound/soc/tegra/tegra_wm8903.c
index 0d6738a..7766478 100644
--- a/sound/soc/tegra/tegra_wm8903.c
+++ b/sound/soc/tegra/tegra_wm8903.c
@@ -56,6 +56,7 @@
 #define GPIO_HP_MUTE    BIT(1)
 #define GPIO_INT_MIC_EN BIT(2)
 #define GPIO_EXT_MIC_EN BIT(3)
+#define GPIO_HP_DET     BIT(4)
=20
 struct tegra_wm8903 {
 	struct tegra_asoc_utils_data util_data;
@@ -304,6 +305,7 @@ static int tegra_wm8903_init(struct snd_soc_pcm_runtime=
 *rtd)
 		snd_soc_jack_add_gpios(&tegra_wm8903_hp_jack,
 					1,
 					&tegra_wm8903_hp_jack_gpio);
+		machine->gpio_requested |=3D GPIO_HP_DET;
 	}
=20
 	snd_soc_jack_new(codec, "Mic Jack", SND_JACK_MICROPHONE,
@@ -429,10 +431,10 @@ static int __devexit tegra_wm8903_driver_remove(struc=
t platform_device *pdev)
 	struct tegra_wm8903 *machine =3D snd_soc_card_get_drvdata(card);
 	struct tegra_wm8903_platform_data *pdata =3D machine->pdata;
=20
-	snd_soc_unregister_card(card);
-
-	tegra_asoc_utils_fini(&machine->util_data);
-
+	if (machine->gpio_requested & GPIO_HP_DET)
+		snd_soc_jack_free_gpios(&tegra_wm8903_hp_jack,
+					1,
+					&tegra_wm8903_hp_jack_gpio);
 	if (machine->gpio_requested & GPIO_EXT_MIC_EN)
 		gpio_free(pdata->gpio_ext_mic_en);
 	if (machine->gpio_requested & GPIO_INT_MIC_EN)
@@ -441,6 +443,11 @@ static int __devexit tegra_wm8903_driver_remove(struct=
 platform_device *pdev)
 		gpio_free(pdata->gpio_hp_mute);
 	if (machine->gpio_requested & GPIO_SPKR_EN)
 		gpio_free(pdata->gpio_spkr_en);
+	machine->gpio_requested =3D 0;
+
+	snd_soc_unregister_card(card);
+
+	tegra_asoc_utils_fini(&machine->util_data);
=20
 	kfree(machine);
=20
diff --git a/sound/usb/caiaq/audio.c b/sound/usb/caiaq/audio.c
index d0d493c..2cf87f5 100644
--- a/sound/usb/caiaq/audio.c
+++ b/sound/usb/caiaq/audio.c
@@ -139,8 +139,12 @@ static void stream_stop(struct snd_usb_caiaqdev *dev)
=20
 	for (i =3D 0; i < N_URBS; i++) {
 		usb_kill_urb(dev->data_urbs_in[i]);
-		usb_kill_urb(dev->data_urbs_out[i]);
+
+		if (test_bit(i, &dev->outurb_active_mask))
+			usb_kill_urb(dev->data_urbs_out[i]);
 	}
+
+	dev->outurb_active_mask =3D 0;
 }
=20
 static int snd_usb_caiaq_substream_open(struct snd_pcm_substream *substrea=
m)
@@ -612,8 +616,9 @@ static void read_completed(struct urb *urb)
 {
 	struct snd_usb_caiaq_cb_info *info =3D urb->context;
 	struct snd_usb_caiaqdev *dev;
-	struct urb *out;
-	int frame, len, send_it =3D 0, outframe =3D 0;
+	struct urb *out =3D NULL;
+	int i, frame, len, send_it =3D 0, outframe =3D 0;
+	size_t offset =3D 0;
=20
 	if (urb->status || !info)
 		return;
@@ -623,7 +628,17 @@ static void read_completed(struct urb *urb)
 	if (!dev->streaming)
 		return;
=20
-	out =3D dev->data_urbs_out[info->index];
+	/* find an unused output urb that is unused */
+	for (i =3D 0; i < N_URBS; i++)
+		if (test_and_set_bit(i, &dev->outurb_active_mask) =3D=3D 0) {
+			out =3D dev->data_urbs_out[i];
+			break;
+		}
+
+	if (!out) {
+		log("Unable to find an output urb to use\n");
+		goto requeue;
+	}
=20
 	/* read the recently received packet and send back one which has
 	 * the same layout */
@@ -634,7 +649,8 @@ static void read_completed(struct urb *urb)
 		len =3D urb->iso_frame_desc[outframe].actual_length;
 		out->iso_frame_desc[outframe].length =3D len;
 		out->iso_frame_desc[outframe].actual_length =3D 0;
-		out->iso_frame_desc[outframe].offset =3D BYTES_PER_FRAME * frame;
+		out->iso_frame_desc[outframe].offset =3D offset;
+		offset +=3D len;
=20
 		if (len > 0) {
 			spin_lock(&dev->spinlock);
@@ -650,11 +666,15 @@ static void read_completed(struct urb *urb)
 	}
=20
 	if (send_it) {
-		out->number_of_packets =3D FRAMES_PER_URB;
+		out->number_of_packets =3D outframe;
 		out->transfer_flags =3D URB_ISO_ASAP;
 		usb_submit_urb(out, GFP_ATOMIC);
+	} else {
+		struct snd_usb_caiaq_cb_info *oinfo =3D out->context;
+		clear_bit(oinfo->index, &dev->outurb_active_mask);
 	}
=20
+requeue:
 	/* re-submit inbound urb */
 	for (frame =3D 0; frame < FRAMES_PER_URB; frame++) {
 		urb->iso_frame_desc[frame].offset =3D BYTES_PER_FRAME * frame;
@@ -676,6 +696,8 @@ static void write_completed(struct urb *urb)
 		dev->output_running =3D 1;
 		wake_up(&dev->prepare_wait_queue);
 	}
+
+	clear_bit(info->index, &dev->outurb_active_mask);
 }
=20
 static struct urb **alloc_urbs(struct snd_usb_caiaqdev *dev, int dir, int =
*ret)
@@ -827,6 +849,9 @@ int snd_usb_caiaq_audio_init(struct snd_usb_caiaqdev *d=
ev)
 	if (!dev->data_cb_info)
 		return -ENOMEM;
=20
+	dev->outurb_active_mask =3D 0;
+	BUILD_BUG_ON(N_URBS > (sizeof(dev->outurb_active_mask) * 8));
+
 	for (i =3D 0; i < N_URBS; i++) {
 		dev->data_cb_info[i].dev =3D dev;
 		dev->data_cb_info[i].index =3D i;
diff --git a/sound/usb/caiaq/device.h b/sound/usb/caiaq/device.h
index b2b3101..3f9c633 100644
--- a/sound/usb/caiaq/device.h
+++ b/sound/usb/caiaq/device.h
@@ -96,6 +96,7 @@ struct snd_usb_caiaqdev {
 	int input_panic, output_panic, warned;
 	char *audio_in_buf, *audio_out_buf;
 	unsigned int samplerates, bpp;
+	unsigned long outurb_active_mask;
=20
 	struct snd_pcm_substream *sub_playback[MAX_STREAMS];
 	struct snd_pcm_substream *sub_capture[MAX_STREAMS];
diff --git a/sound/usb/caiaq/input.c b/sound/usb/caiaq/input.c
index 4432ef7..a213813 100644
--- a/sound/usb/caiaq/input.c
+++ b/sound/usb/caiaq/input.c
@@ -30,7 +30,7 @@ static unsigned short keycode_ak1[] =3D  { KEY_C, KEY_B, =
KEY_A };
 static unsigned short keycode_rk2[] =3D  { KEY_1, KEY_2, KEY_3, KEY_4,
 					 KEY_5, KEY_6, KEY_7 };
 static unsigned short keycode_rk3[] =3D  { KEY_1, KEY_2, KEY_3, KEY_4,
-					 KEY_5, KEY_6, KEY_7, KEY_5, KEY_6 };
+					 KEY_5, KEY_6, KEY_7, KEY_8, KEY_9 };
=20
 static unsigned short keycode_kore[] =3D {
 	KEY_FN_F1,      /* "menu"               */
diff --git a/sound/usb/endpoint.c b/sound/usb/endpoint.c
index b0ef9f5..05842c8 100644
--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -352,7 +352,7 @@ int snd_usb_parse_audio_endpoints(struct snd_usb_audio =
*chip, int iface_no)
 			continue;
 		}
 		if (((protocol =3D=3D UAC_VERSION_1) && (fmt->bLength < 8)) ||
-		    ((protocol =3D=3D UAC_VERSION_2) && (fmt->bLength !=3D 6))) {
+		    ((protocol =3D=3D UAC_VERSION_2) && (fmt->bLength < 6))) {
 			snd_printk(KERN_ERR "%d:%u:%d : invalid UAC_FORMAT_TYPE desc\n",
 				   dev->devnum, iface_no, altno);
 			continue;
diff --git a/sound/usb/mixer.c b/sound/usb/mixer.c
index c22fa76..cdd19d7 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -152,6 +152,7 @@ static inline void check_mapped_dB(const struct usbmix_=
name_map *p,
 	if (p && p->dB) {
 		cval->dBmin =3D p->dB->min;
 		cval->dBmax =3D p->dB->max;
+		cval->initialized =3D 1;
 	}
 }
=20
@@ -1092,7 +1093,7 @@ static void build_feature_ctl(struct mixer_build *sta=
te, void *raw_desc,
 				" Switch" : " Volume");
 		if (control =3D=3D UAC_FU_VOLUME) {
 			check_mapped_dB(map, cval);
-			if (cval->dBmin < cval->dBmax) {
+			if (cval->dBmin < cval->dBmax || !cval->initialized) {
 				kctl->tlv.c =3D mixer_vol_tlv;
 				kctl->vd[0].access |=3D=20
 					SNDRV_CTL_ELEM_ACCESS_TLV_READ |
@@ -1191,6 +1192,11 @@ static int parse_audio_feature_unit(struct mixer_bui=
ld *state, int unitid, void
=20
 	if (state->mixer->protocol =3D=3D UAC_VERSION_1) {
 		csize =3D hdr->bControlSize;
+		if (!csize) {
+			snd_printdd(KERN_ERR "usbaudio: unit %u: "
+				    "invalid bControlSize =3D=3D 0\n", unitid);
+			return -EINVAL;
+		}
 		channels =3D (hdr->bLength - 7) / csize - 1;
 		bmaControls =3D hdr->bmaControls;
 	} else {
@@ -1934,15 +1940,13 @@ static int snd_usb_mixer_controls(struct usb_mixer_=
interface *mixer)
 	struct mixer_build state;
 	int err;
 	const struct usbmix_ctl_map *map;
-	struct usb_host_interface *hostif;
 	void *p;
=20
-	hostif =3D mixer->chip->ctrl_intf;
 	memset(&state, 0, sizeof(state));
 	state.chip =3D mixer->chip;
 	state.mixer =3D mixer;
-	state.buffer =3D hostif->extra;
-	state.buflen =3D hostif->extralen;
+	state.buffer =3D mixer->hostif->extra;
+	state.buflen =3D mixer->hostif->extralen;
=20
 	/* check the mapping table */
 	for (map =3D usbmix_ctl_maps; map->id; map++) {
@@ -1955,7 +1959,8 @@ static int snd_usb_mixer_controls(struct usb_mixer_in=
terface *mixer)
 	}
=20
 	p =3D NULL;
-	while ((p =3D snd_usb_find_csint_desc(hostif->extra, hostif->extralen, p,=
 UAC_OUTPUT_TERMINAL)) !=3D NULL) {
+	while ((p =3D snd_usb_find_csint_desc(mixer->hostif->extra, mixer->hostif=
->extralen,
+					    p, UAC_OUTPUT_TERMINAL)) !=3D NULL) {
 		if (mixer->protocol =3D=3D UAC_VERSION_1) {
 			struct uac1_output_terminal_descriptor *desc =3D p;
=20
@@ -2162,17 +2167,15 @@ int snd_usb_mixer_activate(struct usb_mixer_interfa=
ce *mixer)
 /* create the handler for the optional status interrupt endpoint */
 static int snd_usb_mixer_status_create(struct usb_mixer_interface *mixer)
 {
-	struct usb_host_interface *hostif;
 	struct usb_endpoint_descriptor *ep;
 	void *transfer_buffer;
 	int buffer_length;
 	unsigned int epnum;
=20
-	hostif =3D mixer->chip->ctrl_intf;
 	/* we need one interrupt input endpoint */
-	if (get_iface_desc(hostif)->bNumEndpoints < 1)
+	if (get_iface_desc(mixer->hostif)->bNumEndpoints < 1)
 		return 0;
-	ep =3D get_endpoint(hostif, 0);
+	ep =3D get_endpoint(mixer->hostif, 0);
 	if (!usb_endpoint_dir_in(ep) || !usb_endpoint_xfer_int(ep))
 		return 0;
=20
@@ -2202,7 +2205,6 @@ int snd_usb_create_mixer(struct snd_usb_audio *chip, =
int ctrlif,
 	};
 	struct usb_mixer_interface *mixer;
 	struct snd_info_entry *entry;
-	struct usb_host_interface *host_iface;
 	int err;
=20
 	strcpy(chip->card->mixername, "USB Mixer");
@@ -2219,8 +2221,8 @@ int snd_usb_create_mixer(struct snd_usb_audio *chip, =
int ctrlif,
 		return -ENOMEM;
 	}
=20
-	host_iface =3D &usb_ifnum_to_if(chip->dev, ctrlif)->altsetting[0];
-	switch (get_iface_desc(host_iface)->bInterfaceProtocol) {
+	mixer->hostif =3D &usb_ifnum_to_if(chip->dev, ctrlif)->altsetting[0];
+	switch (get_iface_desc(mixer->hostif)->bInterfaceProtocol) {
 	case UAC_VERSION_1:
 	default:
 		mixer->protocol =3D UAC_VERSION_1;
diff --git a/sound/usb/mixer.h b/sound/usb/mixer.h
index ae1a14d..81b2d8a 100644
--- a/sound/usb/mixer.h
+++ b/sound/usb/mixer.h
@@ -3,6 +3,7 @@
=20
 struct usb_mixer_interface {
 	struct snd_usb_audio *chip;
+	struct usb_host_interface *hostif;
 	struct list_head list;
 	unsigned int ignore_ctl_error;
 	struct urb *urb;
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 940257b..c168366 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -52,7 +52,10 @@ ifeq ($(ARCH),i386)
 endif
 ifeq ($(ARCH),x86_64)
 	ARCH :=3D x86
-	IS_X86_64 :=3D $(shell echo __x86_64__ | ${CC} -E -xc - | tail -n 1)
+	IS_X86_64 :=3D 0
+	ifeq (, $(findstring m32,$(EXTRA_CFLAGS)))
+		IS_X86_64 :=3D $(shell echo __x86_64__ | ${CC} -E -xc - | tail -n 1)
+	endif
 	ifeq (${IS_X86_64}, 1)
 		RAW_ARCH :=3D x86_64
 		ARCH_CFLAGS :=3D -DARCH_X86_64
diff --git a/tools/perf/util/config.c b/tools/perf/util/config.c
index e02d78c..6c86eca 100644
--- a/tools/perf/util/config.c
+++ b/tools/perf/util/config.c
@@ -399,7 +399,6 @@ static int perf_config_global(void)
 int perf_config(config_fn_t fn, void *data)
 {
 	int ret =3D 0, found =3D 0;
-	char *repo_config =3D NULL;
 	const char *home =3D NULL;
=20
 	/* Setting $PERF_CONFIG makes perf read _only_ the given config file. */
@@ -421,12 +420,6 @@ int perf_config(config_fn_t fn, void *data)
 		free(user_config);
 	}
=20
-	repo_config =3D perf_pathdup("config");
-	if (!access(repo_config, R_OK)) {
-		ret +=3D perf_config_from_file(fn, repo_config, data);
-		found +=3D 1;
-	}
-	free(repo_config);
 	if (found =3D=3D 0)
 		return -1;
 	return ret;
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index afb0849..cb2959a 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -877,9 +877,12 @@ int perf_session__read_header(struct perf_session *ses=
sion, int fd)
 		struct perf_evsel *evsel;
 		off_t tmp;
=20
-		if (perf_header__getbuffer64(header, fd, &f_attr, sizeof(f_attr)))
+		if (readn(fd, &f_attr, sizeof(f_attr)) <=3D 0)
 			goto out_errno;
=20
+		if (header->needs_swap)
+			perf_event__attr_swap(&f_attr.attr);
+
 		tmp =3D lseek(fd, 0, SEEK_CUR);
 		evsel =3D perf_evsel__new(&f_attr.attr, i);
=20
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index f5a8fbd..2dbf0ab 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -407,20 +407,26 @@ static void perf_event__read_swap(union perf_event *e=
vent)
 	event->read.id		 =3D bswap_64(event->read.id);
 }
=20
-static void perf_event__attr_swap(union perf_event *event)
+/* exported for swapping attributes in file header */
+void perf_event__attr_swap(struct perf_event_attr *attr)
+{
+	attr->type		=3D bswap_32(attr->type);
+	attr->size		=3D bswap_32(attr->size);
+	attr->config		=3D bswap_64(attr->config);
+	attr->sample_period	=3D bswap_64(attr->sample_period);
+	attr->sample_type	=3D bswap_64(attr->sample_type);
+	attr->read_format	=3D bswap_64(attr->read_format);
+	attr->wakeup_events	=3D bswap_32(attr->wakeup_events);
+	attr->bp_type		=3D bswap_32(attr->bp_type);
+	attr->bp_addr		=3D bswap_64(attr->bp_addr);
+	attr->bp_len		=3D bswap_64(attr->bp_len);
+}
+
+static void perf_event__hdr_attr_swap(union perf_event *event)
 {
 	size_t size;
=20
-	event->attr.attr.type		=3D bswap_32(event->attr.attr.type);
-	event->attr.attr.size		=3D bswap_32(event->attr.attr.size);
-	event->attr.attr.config		=3D bswap_64(event->attr.attr.config);
-	event->attr.attr.sample_period	=3D bswap_64(event->attr.attr.sample_perio=
d);
-	event->attr.attr.sample_type	=3D bswap_64(event->attr.attr.sample_type);
-	event->attr.attr.read_format	=3D bswap_64(event->attr.attr.read_format);
-	event->attr.attr.wakeup_events	=3D bswap_32(event->attr.attr.wakeup_event=
s);
-	event->attr.attr.bp_type	=3D bswap_32(event->attr.attr.bp_type);
-	event->attr.attr.bp_addr	=3D bswap_64(event->attr.attr.bp_addr);
-	event->attr.attr.bp_len		=3D bswap_64(event->attr.attr.bp_len);
+	perf_event__attr_swap(&event->attr.attr);
=20
 	size =3D event->header.size;
 	size -=3D (void *)&event->attr.id - (void *)event;
@@ -448,7 +454,7 @@ static perf_event__swap_op perf_event__swap_ops[] =3D {
 	[PERF_RECORD_LOST]		  =3D perf_event__all64_swap,
 	[PERF_RECORD_READ]		  =3D perf_event__read_swap,
 	[PERF_RECORD_SAMPLE]		  =3D perf_event__all64_swap,
-	[PERF_RECORD_HEADER_ATTR]	  =3D perf_event__attr_swap,
+	[PERF_RECORD_HEADER_ATTR]	  =3D perf_event__hdr_attr_swap,
 	[PERF_RECORD_HEADER_EVENT_TYPE]	  =3D perf_event__event_type_swap,
 	[PERF_RECORD_HEADER_TRACING_DATA] =3D perf_event__tracing_data_swap,
 	[PERF_RECORD_HEADER_BUILD_ID]	  =3D NULL,
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 66d4e14..b84c003 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -112,6 +112,7 @@ int perf_session__set_kallsyms_ref_reloc_sym(struct map=
 **maps,
 					     u64 addr);
=20
 void mem_bswap_64(void *src, int byte_size);
+void perf_event__attr_swap(struct perf_event_attr *attr);
=20
 int perf_session__create_kernel_maps(struct perf_session *self);
=20

--1ccMZA6j1vT5UqiK--

--0/kgSOzhNoDC5T3a
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iEYEARECAAYFAk6DinMACgkQMUfUDdst+ylHSwCgozDk2FFF/CtYSSm/+2hDIw+j
tQwAniNosoJOYQRvgBnpyP2roQeyKkM5
=pJ4I
-----END PGP SIGNATURE-----

--0/kgSOzhNoDC5T3a--
