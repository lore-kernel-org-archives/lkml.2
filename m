Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829Ab3ADBT4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 20:19:56 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57198 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753796Ab3ADBTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 20:19:44 -0500
Message-ID: <1357262361.31299.64.camel@deadeye.wl.decadent.org.uk>
Subject: Re: Linux 3.2.36
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, Jiri Slaby <jslaby@suse.cz>,
        stable@vger.kernel.org
Cc: lwn@lwn.net
Date: Fri, 04 Jan 2013 01:19:21 +0000
In-Reply-To: <1357262262.31299.63.camel@deadeye.wl.decadent.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-Jednz7RuyNwCxbQOx9Ff"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Jednz7RuyNwCxbQOx9Ff
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

diff --git a/Documentation/hwmon/coretemp b/Documentation/hwmon/coretemp
index 84d46c0..eb5502e 100644
--- a/Documentation/hwmon/coretemp
+++ b/Documentation/hwmon/coretemp
@@ -6,7 +6,9 @@ Supported chips:
     Prefix: 'coretemp'
     CPUID: family 0x6, models 0xe (Pentium M DC), 0xf (Core 2 DC 65nm),
                               0x16 (Core 2 SC 65nm), 0x17 (Penryn 45nm),
-                              0x1a (Nehalem), 0x1c (Atom), 0x1e (Lynnfield=
)
+                              0x1a (Nehalem), 0x1c (Atom), 0x1e (Lynnfield=
),
+                              0x26 (Tunnel Creek Atom), 0x27 (Medfield Ato=
m),
+                              0x36 (Cedar Trail Atom)
     Datasheet: Intel 64 and IA-32 Architectures Software Developer's Manua=
l
                Volume 3A: System Programming Guide
                http://softwarecommunity.intel.com/Wiki/Mobility/720.htm
@@ -65,6 +67,11 @@ Process		Processor					TjMax(C)
 		U3400						105
 		P4505/P4500 					90
=20
+32nm		Atom Processors
+		Z2460						90
+		D2700/2550/2500					100
+		N2850/2800/2650/2600				100
+
 45nm		Xeon Processors 5400 Quad-Core
 		X5492, X5482, X5472, X5470, X5460, X5450	85
 		E5472, E5462, E5450/40/30/20/10/05		85
@@ -85,6 +92,9 @@ Process		Processor					TjMax(C)
 		N475/470/455/450				100
 		N280/270					90
 		330/230						125
+		E680/660/640/620				90
+		E680T/660T/640T/620T				110
+		CE4170/4150/4110				110
=20
 45nm		Core2 Processors
 		Solo ULV SU3500/3300				100
diff --git a/Makefile b/Makefile
index d985af0..2052c29 100644
--- a/Makefile
+++ b/Makefile
@@ -1,6 +1,6 @@
 VERSION =3D 3
 PATCHLEVEL =3D 2
-SUBLEVEL =3D 35
+SUBLEVEL =3D 36
 EXTRAVERSION =3D
 NAME =3D Saber-toothed Squirrel
=20
diff --git a/arch/arm/include/asm/hwcap.h b/arch/arm/include/asm/hwcap.h
index c93a22a..3a925fb 100644
--- a/arch/arm/include/asm/hwcap.h
+++ b/arch/arm/include/asm/hwcap.h
@@ -18,11 +18,12 @@
 #define HWCAP_THUMBEE	(1 << 11)
 #define HWCAP_NEON	(1 << 12)
 #define HWCAP_VFPv3	(1 << 13)
-#define HWCAP_VFPv3D16	(1 << 14)
+#define HWCAP_VFPv3D16	(1 << 14)	/* also set for VFPv4-D16 */
 #define HWCAP_TLS	(1 << 15)
 #define HWCAP_VFPv4	(1 << 16)
 #define HWCAP_IDIVA	(1 << 17)
 #define HWCAP_IDIVT	(1 << 18)
+#define HWCAP_VFPD32	(1 << 19)	/* set if VFP has 32 regs (not 16) */
 #define HWCAP_IDIV	(HWCAP_IDIVA | HWCAP_IDIVT)
=20
 #if defined(__KERNEL__) && !defined(__ASSEMBLY__)
diff --git a/arch/arm/include/asm/vfpmacros.h b/arch/arm/include/asm/vfpmac=
ros.h
index bf53047..c49c8f7 100644
--- a/arch/arm/include/asm/vfpmacros.h
+++ b/arch/arm/include/asm/vfpmacros.h
@@ -27,9 +27,9 @@
 #if __LINUX_ARM_ARCH__ <=3D 6
 	ldr	\tmp, =3Delf_hwcap		    @ may not have MVFR regs
 	ldr	\tmp, [\tmp, #0]
-	tst	\tmp, #HWCAP_VFPv3D16
-	ldceql	p11, cr0, [\base],#32*4		    @ FLDMIAD \base!, {d16-d31}
-	addne	\base, \base, #32*4		    @ step over unused register space
+	tst	\tmp, #HWCAP_VFPD32
+	ldcnel	p11, cr0, [\base],#32*4		    @ FLDMIAD \base!, {d16-d31}
+	addeq	\base, \base, #32*4		    @ step over unused register space
 #else
 	VFPFMRX	\tmp, MVFR0			    @ Media and VFP Feature Register 0
 	and	\tmp, \tmp, #MVFR0_A_SIMD_MASK	    @ A_SIMD field
@@ -51,9 +51,9 @@
 #if __LINUX_ARM_ARCH__ <=3D 6
 	ldr	\tmp, =3Delf_hwcap		    @ may not have MVFR regs
 	ldr	\tmp, [\tmp, #0]
-	tst	\tmp, #HWCAP_VFPv3D16
-	stceql	p11, cr0, [\base],#32*4		    @ FSTMIAD \base!, {d16-d31}
-	addne	\base, \base, #32*4		    @ step over unused register space
+	tst	\tmp, #HWCAP_VFPD32
+	stcnel	p11, cr0, [\base],#32*4		    @ FSTMIAD \base!, {d16-d31}
+	addeq	\base, \base, #32*4		    @ step over unused register space
 #else
 	VFPFMRX	\tmp, MVFR0			    @ Media and VFP Feature Register 0
 	and	\tmp, \tmp, #MVFR0_A_SIMD_MASK	    @ A_SIMD field
diff --git a/arch/arm/kernel/swp_emulate.c b/arch/arm/kernel/swp_emulate.c
index 5f452f8..5d9b1ee 100644
--- a/arch/arm/kernel/swp_emulate.c
+++ b/arch/arm/kernel/swp_emulate.c
@@ -108,10 +108,12 @@ static void set_segfault(struct pt_regs *regs, unsign=
ed long addr)
 {
 	siginfo_t info;
=20
+	down_read(&current->mm->mmap_sem);
 	if (find_vma(current->mm, addr) =3D=3D NULL)
 		info.si_code =3D SEGV_MAPERR;
 	else
 		info.si_code =3D SEGV_ACCERR;
+	up_read(&current->mm->mmap_sem);
=20
 	info.si_signo =3D SIGSEGV;
 	info.si_errno =3D 0;
diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index dc8c550..9e28fdb 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -475,7 +475,7 @@ static void __init build_mem_type_table(void)
 	}
=20
 	for (i =3D 0; i < 16; i++) {
-		unsigned long v =3D pgprot_val(protection_map[i]);
+		pteval_t v =3D pgprot_val(protection_map[i]);
 		protection_map[i] =3D __pgprot(v | user_pgprot);
 	}
=20
diff --git a/arch/arm/vfp/vfpmodule.c b/arch/arm/vfp/vfpmodule.c
index f0702f3..7c815b2 100644
--- a/arch/arm/vfp/vfpmodule.c
+++ b/arch/arm/vfp/vfpmodule.c
@@ -610,11 +610,14 @@ static int __init vfp_init(void)
 			elf_hwcap |=3D HWCAP_VFPv3;
=20
 			/*
-			 * Check for VFPv3 D16. CPUs in this configuration
-			 * only have 16 x 64bit registers.
+			 * Check for VFPv3 D16 and VFPv4 D16.  CPUs in
+			 * this configuration only have 16 x 64bit
+			 * registers.
 			 */
 			if (((fmrx(MVFR0) & MVFR0_A_SIMD_MASK)) =3D=3D 1)
-				elf_hwcap |=3D HWCAP_VFPv3D16;
+				elf_hwcap |=3D HWCAP_VFPv3D16; /* also v4-D16 */
+			else
+				elf_hwcap |=3D HWCAP_VFPD32;
 		}
 #endif
 		/*
diff --git a/arch/cris/include/asm/io.h b/arch/cris/include/asm/io.h
index 32567bc..ac12ae2 100644
--- a/arch/cris/include/asm/io.h
+++ b/arch/cris/include/asm/io.h
@@ -133,12 +133,39 @@ static inline void writel(unsigned int b, volatile vo=
id __iomem *addr)
 #define insb(port,addr,count) (cris_iops ? cris_iops->read_io(port,addr,1,=
count) : 0)
 #define insw(port,addr,count) (cris_iops ? cris_iops->read_io(port,addr,2,=
count) : 0)
 #define insl(port,addr,count) (cris_iops ? cris_iops->read_io(port,addr,4,=
count) : 0)
-#define outb(data,port) if (cris_iops) cris_iops->write_io(port,(void*)(un=
signed)data,1,1)
-#define outw(data,port) if (cris_iops) cris_iops->write_io(port,(void*)(un=
signed)data,2,1)
-#define outl(data,port) if (cris_iops) cris_iops->write_io(port,(void*)(un=
signed)data,4,1)
-#define outsb(port,addr,count) if(cris_iops) cris_iops->write_io(port,(voi=
d*)addr,1,count)
-#define outsw(port,addr,count) if(cris_iops) cris_iops->write_io(port,(voi=
d*)addr,2,count)
-#define outsl(port,addr,count) if(cris_iops) cris_iops->write_io(port,(voi=
d*)addr,3,count)
+static inline void outb(unsigned char data, unsigned int port)
+{
+	if (cris_iops)
+		cris_iops->write_io(port, (void *) &data, 1, 1);
+}
+static inline void outw(unsigned short data, unsigned int port)
+{
+	if (cris_iops)
+		cris_iops->write_io(port, (void *) &data, 2, 1);
+}
+static inline void outl(unsigned int data, unsigned int port)
+{
+	if (cris_iops)
+		cris_iops->write_io(port, (void *) &data, 4, 1);
+}
+static inline void outsb(unsigned int port, const void *addr,
+			 unsigned long count)
+{
+	if (cris_iops)
+		cris_iops->write_io(port, (void *)addr, 1, count);
+}
+static inline void outsw(unsigned int port, const void *addr,
+			 unsigned long count)
+{
+	if (cris_iops)
+		cris_iops->write_io(port, (void *)addr, 2, count);
+}
+static inline void outsl(unsigned int port, const void *addr,
+			 unsigned long count)
+{
+	if (cris_iops)
+		cris_iops->write_io(port, (void *)addr, 4, count);
+}
=20
 /*
  * Convert a physical pointer to a virtual kernel pointer for /dev/mem
diff --git a/arch/mips/kernel/process.c b/arch/mips/kernel/process.c
index c47f96e..bf128d7 100644
--- a/arch/mips/kernel/process.c
+++ b/arch/mips/kernel/process.c
@@ -72,9 +72,7 @@ void __noreturn cpu_idle(void)
 			}
 		}
 #ifdef CONFIG_HOTPLUG_CPU
-		if (!cpu_online(cpu) && !cpu_isset(cpu, cpu_callin_map) &&
-		    (system_state =3D=3D SYSTEM_RUNNING ||
-		     system_state =3D=3D SYSTEM_BOOTING))
+		if (!cpu_online(cpu) && !cpu_isset(cpu, cpu_callin_map))
 			play_dead();
 #endif
 		tick_nohz_restart_sched_tick();
diff --git a/arch/powerpc/kernel/head_64.S b/arch/powerpc/kernel/head_64.S
index 06c7251..cdf6b3f 100644
--- a/arch/powerpc/kernel/head_64.S
+++ b/arch/powerpc/kernel/head_64.S
@@ -435,7 +435,7 @@ _STATIC(__after_prom_start)
 	tovirt(r6,r6)			/* on booke, we already run at PAGE_OFFSET */
 #endif
=20
-#ifdef CONFIG_CRASH_DUMP
+#ifdef CONFIG_RELOCATABLE
 /*
  * Check if the kernel has to be running as relocatable kernel based on th=
e
  * variable __run_at_load, if it is set the kernel is treated as relocatab=
le
diff --git a/arch/powerpc/kvm/44x_emulate.c b/arch/powerpc/kvm/44x_emulate.=
c
index 549bb2c..ded8a1a 100644
--- a/arch/powerpc/kvm/44x_emulate.c
+++ b/arch/powerpc/kvm/44x_emulate.c
@@ -79,6 +79,7 @@ int kvmppc_core_emulate_op(struct kvm_run *run, struct kv=
m_vcpu *vcpu,
 				run->dcr.dcrn =3D dcrn;
 				run->dcr.data =3D  0;
 				run->dcr.is_write =3D 0;
+				vcpu->arch.dcr_is_write =3D 0;
 				vcpu->arch.io_gpr =3D rt;
 				vcpu->arch.dcr_needed =3D 1;
 				kvmppc_account_exit(vcpu, DCR_EXITS);
@@ -100,6 +101,7 @@ int kvmppc_core_emulate_op(struct kvm_run *run, struct =
kvm_vcpu *vcpu,
 				run->dcr.dcrn =3D dcrn;
 				run->dcr.data =3D kvmppc_get_gpr(vcpu, rs);
 				run->dcr.is_write =3D 1;
+				vcpu->arch.dcr_is_write =3D 1;
 				vcpu->arch.dcr_needed =3D 1;
 				kvmppc_account_exit(vcpu, DCR_EXITS);
 				emulated =3D EMULATE_DO_DCR;
diff --git a/arch/powerpc/platforms/embedded6xx/wii.c b/arch/powerpc/platfo=
rms/embedded6xx/wii.c
index 1b5dc1a..daf793b 100644
--- a/arch/powerpc/platforms/embedded6xx/wii.c
+++ b/arch/powerpc/platforms/embedded6xx/wii.c
@@ -85,9 +85,11 @@ void __init wii_memory_fixups(void)
 	wii_hole_start =3D p[0].base + p[0].size;
 	wii_hole_size =3D p[1].base - wii_hole_start;
=20
-	pr_info("MEM1: <%08llx %08llx>\n", p[0].base, p[0].size);
+	pr_info("MEM1: <%08llx %08llx>\n",
+		(unsigned long long) p[0].base, (unsigned long long) p[0].size);
 	pr_info("HOLE: <%08lx %08lx>\n", wii_hole_start, wii_hole_size);
-	pr_info("MEM2: <%08llx %08llx>\n", p[1].base, p[1].size);
+	pr_info("MEM2: <%08llx %08llx>\n",
+		(unsigned long long) p[1].base, (unsigned long long) p[1].size);
=20
 	p[0].size +=3D wii_hole_size + p[1].size;
=20
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index d3cb86c..dffcaa4 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -749,7 +749,7 @@ static int __init kvm_s390_init(void)
 	}
 	memcpy(facilities, S390_lowcore.stfle_fac_list, 16);
 	facilities[0] &=3D 0xff00fff3f47c0000ULL;
-	facilities[1] &=3D 0x201c000000000000ULL;
+	facilities[1] &=3D 0x001c000000000000ULL;
 	return 0;
 }
=20
diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 1bb0bf4..4970ef0 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -429,7 +429,7 @@ void hpet_msi_unmask(struct irq_data *data)
=20
 	/* unmask it */
 	cfg =3D hpet_readl(HPET_Tn_CFG(hdev->num));
-	cfg |=3D HPET_TN_FSB;
+	cfg |=3D HPET_TN_ENABLE | HPET_TN_FSB;
 	hpet_writel(cfg, HPET_Tn_CFG(hdev->num));
 }
=20
@@ -440,7 +440,7 @@ void hpet_msi_mask(struct irq_data *data)
=20
 	/* mask it */
 	cfg =3D hpet_readl(HPET_Tn_CFG(hdev->num));
-	cfg &=3D ~HPET_TN_FSB;
+	cfg &=3D ~(HPET_TN_ENABLE | HPET_TN_FSB);
 	hpet_writel(cfg, HPET_Tn_CFG(hdev->num));
 }
=20
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4fc5323..f4063fd 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -578,6 +578,9 @@ static bool guest_cpuid_has_xsave(struct kvm_vcpu *vcpu=
)
 {
 	struct kvm_cpuid_entry2 *best;
=20
+	if (!static_cpu_has(X86_FEATURE_XSAVE))
+		return 0;
+
 	best =3D kvm_find_cpuid_entry(vcpu, 1, 0);
 	return best && (best->ecx & bit(X86_FEATURE_XSAVE));
 }
@@ -6149,6 +6152,9 @@ int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vc=
pu,
 	int pending_vec, max_bits, idx;
 	struct desc_ptr dt;
=20
+	if (!guest_cpuid_has_xsave(vcpu) && (sregs->cr4 & X86_CR4_OSXSAVE))
+		return -EINVAL;
+
 	dt.size =3D sregs->idt.limit;
 	dt.address =3D sregs->idt.base;
 	kvm_x86_ops->set_idt(vcpu, &dt);
diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
index 5535477..a1a4b8e 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -34,6 +34,7 @@
 #include <linux/dmi.h>
 #include <linux/slab.h>
 #include <linux/suspend.h>
+#include <asm/unaligned.h>
=20
 #ifdef CONFIG_ACPI_PROCFS_POWER
 #include <linux/proc_fs.h>
@@ -95,6 +96,18 @@ enum {
 	ACPI_BATTERY_ALARM_PRESENT,
 	ACPI_BATTERY_XINFO_PRESENT,
 	ACPI_BATTERY_QUIRK_PERCENTAGE_CAPACITY,
+	/* On Lenovo Thinkpad models from 2010 and 2011, the power unit
+	   switches between mWh and mAh depending on whether the system
+	   is running on battery or not.  When mAh is the unit, most
+	   reported values are incorrect and need to be adjusted by
+	   10000/design_voltage.  Verified on x201, t410, t410s, and x220.
+	   Pre-2010 and 2012 models appear to always report in mWh and
+	   are thus unaffected (tested with t42, t61, t500, x200, x300,
+	   and x230).  Also, in mid-2012 Lenovo issued a BIOS update for
+	   the 2011 models that fixes the issue (tested on x220 with a
+	   post-1.29 BIOS), but as of Nov. 2012, no such update is
+	   available for the 2010 models.  */
+	ACPI_BATTERY_QUIRK_THINKPAD_MAH,
 };
=20
 struct acpi_battery {
@@ -429,6 +442,21 @@ static int acpi_battery_get_info(struct acpi_battery *=
battery)
 	kfree(buffer.pointer);
 	if (test_bit(ACPI_BATTERY_QUIRK_PERCENTAGE_CAPACITY, &battery->flags))
 		battery->full_charge_capacity =3D battery->design_capacity;
+	if (test_bit(ACPI_BATTERY_QUIRK_THINKPAD_MAH, &battery->flags) &&
+	    battery->power_unit && battery->design_voltage) {
+		battery->design_capacity =3D battery->design_capacity *
+		    10000 / battery->design_voltage;
+		battery->full_charge_capacity =3D battery->full_charge_capacity *
+		    10000 / battery->design_voltage;
+		battery->design_capacity_warning =3D
+		    battery->design_capacity_warning *
+		    10000 / battery->design_voltage;
+		/* Curiously, design_capacity_low, unlike the rest of them,
+		   is correct.  */
+		/* capacity_granularity_* equal 1 on the systems tested, so
+		   it's impossible to tell if they would need an adjustment
+		   or not if their values were higher.  */
+	}
 	return result;
 }
=20
@@ -477,6 +505,11 @@ static int acpi_battery_get_state(struct acpi_battery =
*battery)
 	    && battery->capacity_now >=3D 0 && battery->capacity_now <=3D 100)
 		battery->capacity_now =3D (battery->capacity_now *
 				battery->full_charge_capacity) / 100;
+	if (test_bit(ACPI_BATTERY_QUIRK_THINKPAD_MAH, &battery->flags) &&
+	    battery->power_unit && battery->design_voltage) {
+		battery->capacity_now =3D battery->capacity_now *
+		    10000 / battery->design_voltage;
+	}
 	return result;
 }
=20
@@ -586,6 +619,24 @@ static void sysfs_remove_battery(struct acpi_battery *=
battery)
 	mutex_unlock(&battery->sysfs_lock);
 }
=20
+static void find_battery(const struct dmi_header *dm, void *private)
+{
+	struct acpi_battery *battery =3D (struct acpi_battery *)private;
+	/* Note: the hardcoded offsets below have been extracted from
+	   the source code of dmidecode.  */
+	if (dm->type =3D=3D DMI_ENTRY_PORTABLE_BATTERY && dm->length >=3D 8) {
+		const u8 *dmi_data =3D (const u8 *)(dm + 1);
+		int dmi_capacity =3D get_unaligned((const u16 *)(dmi_data + 6));
+		if (dm->length >=3D 18)
+			dmi_capacity *=3D dmi_data[17];
+		if (battery->design_capacity * battery->design_voltage / 1000
+		    !=3D dmi_capacity &&
+		    battery->design_capacity * 10 =3D=3D dmi_capacity)
+			set_bit(ACPI_BATTERY_QUIRK_THINKPAD_MAH,
+				&battery->flags);
+	}
+}
+
 /*
  * According to the ACPI spec, some kinds of primary batteries can
  * report percentage battery remaining capacity directly to OS.
@@ -611,6 +662,32 @@ static void acpi_battery_quirks(struct acpi_battery *b=
attery)
 		battery->capacity_now =3D (battery->capacity_now *
 				battery->full_charge_capacity) / 100;
 	}
+
+	if (test_bit(ACPI_BATTERY_QUIRK_THINKPAD_MAH, &battery->flags))
+		return ;
+
+	if (battery->power_unit && dmi_name_in_vendors("LENOVO")) {
+		const char *s;
+		s =3D dmi_get_system_info(DMI_PRODUCT_VERSION);
+		if (s && !strnicmp(s, "ThinkPad", 8)) {
+			dmi_walk(find_battery, battery);
+			if (test_bit(ACPI_BATTERY_QUIRK_THINKPAD_MAH,
+				     &battery->flags) &&
+			    battery->design_voltage) {
+				battery->design_capacity =3D
+				    battery->design_capacity *
+				    10000 / battery->design_voltage;
+				battery->full_charge_capacity =3D
+				    battery->full_charge_capacity *
+				    10000 / battery->design_voltage;
+				battery->design_capacity_warning =3D
+				    battery->design_capacity_warning *
+				    10000 / battery->design_voltage;
+				battery->capacity_now =3D battery->capacity_now *
+				    10000 / battery->design_voltage;
+			}
+		}
+	}
 }
=20
 static int acpi_battery_update(struct acpi_battery *battery)
diff --git a/drivers/acpi/processor_driver.c b/drivers/acpi/processor_drive=
r.c
index 9d7bc9f..ac28db3 100644
--- a/drivers/acpi/processor_driver.c
+++ b/drivers/acpi/processor_driver.c
@@ -409,6 +409,7 @@ static void acpi_processor_notify(struct acpi_device *d=
evice, u32 event)
 		acpi_bus_generate_proc_event(device, event, 0);
 		acpi_bus_generate_netlink_event(device->pnp.device_class,
 						  dev_name(&device->dev), event, 0);
+		break;
 	default:
 		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
 				  "Unsupported event [0x%x]\n", event));
diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
index ed6bc52..d790791 100644
--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -108,6 +108,180 @@ void __init acpi_old_suspend_ordering(void)
 	old_suspend_ordering =3D true;
 }
=20
+static int __init init_old_suspend_ordering(const struct dmi_system_id *d)
+{
+	acpi_old_suspend_ordering();
+	return 0;
+}
+
+static int __init init_nvs_nosave(const struct dmi_system_id *d)
+{
+	acpi_nvs_nosave();
+	return 0;
+}
+
+static struct dmi_system_id __initdata acpisleep_dmi_table[] =3D {
+	{
+	.callback =3D init_old_suspend_ordering,
+	.ident =3D "Abit KN9 (nForce4 variant)",
+	.matches =3D {
+		DMI_MATCH(DMI_BOARD_VENDOR, "http://www.abit.com.tw/"),
+		DMI_MATCH(DMI_BOARD_NAME, "KN9 Series(NF-CK804)"),
+		},
+	},
+	{
+	.callback =3D init_old_suspend_ordering,
+	.ident =3D "HP xw4600 Workstation",
+	.matches =3D {
+		DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "HP xw4600 Workstation"),
+		},
+	},
+	{
+	.callback =3D init_old_suspend_ordering,
+	.ident =3D "Asus Pundit P1-AH2 (M2N8L motherboard)",
+	.matches =3D {
+		DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTek Computer INC."),
+		DMI_MATCH(DMI_BOARD_NAME, "M2N8L"),
+		},
+	},
+	{
+	.callback =3D init_old_suspend_ordering,
+	.ident =3D "Panasonic CF51-2L",
+	.matches =3D {
+		DMI_MATCH(DMI_BOARD_VENDOR,
+				"Matsushita Electric Industrial Co.,Ltd."),
+		DMI_MATCH(DMI_BOARD_NAME, "CF51-2L"),
+		},
+	},
+	{
+	.callback =3D init_nvs_nosave,
+	.ident =3D "Sony Vaio VGN-FW21E",
+	.matches =3D {
+		DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "VGN-FW21E"),
+		},
+	},
+	{
+	.callback =3D init_nvs_nosave,
+	.ident =3D "Sony Vaio VPCEB17FX",
+	.matches =3D {
+		DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "VPCEB17FX"),
+		},
+	},
+	{
+	.callback =3D init_nvs_nosave,
+	.ident =3D "Sony Vaio VGN-SR11M",
+	.matches =3D {
+		DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "VGN-SR11M"),
+		},
+	},
+	{
+	.callback =3D init_nvs_nosave,
+	.ident =3D "Everex StepNote Series",
+	.matches =3D {
+		DMI_MATCH(DMI_SYS_VENDOR, "Everex Systems, Inc."),
+		DMI_MATCH(DMI_PRODUCT_NAME, "Everex StepNote Series"),
+		},
+	},
+	{
+	.callback =3D init_nvs_nosave,
+	.ident =3D "Sony Vaio VPCEB1Z1E",
+	.matches =3D {
+		DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "VPCEB1Z1E"),
+		},
+	},
+	{
+	.callback =3D init_nvs_nosave,
+	.ident =3D "Sony Vaio VGN-NW130D",
+	.matches =3D {
+		DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "VGN-NW130D"),
+		},
+	},
+	{
+	.callback =3D init_nvs_nosave,
+	.ident =3D "Sony Vaio VPCCW29FX",
+	.matches =3D {
+		DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "VPCCW29FX"),
+		},
+	},
+	{
+	.callback =3D init_nvs_nosave,
+	.ident =3D "Averatec AV1020-ED2",
+	.matches =3D {
+		DMI_MATCH(DMI_SYS_VENDOR, "AVERATEC"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "1000 Series"),
+		},
+	},
+	{
+	.callback =3D init_old_suspend_ordering,
+	.ident =3D "Asus A8N-SLI DELUXE",
+	.matches =3D {
+		DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK Computer INC."),
+		DMI_MATCH(DMI_BOARD_NAME, "A8N-SLI DELUXE"),
+		},
+	},
+	{
+	.callback =3D init_old_suspend_ordering,
+	.ident =3D "Asus A8N-SLI Premium",
+	.matches =3D {
+		DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK Computer INC."),
+		DMI_MATCH(DMI_BOARD_NAME, "A8N-SLI Premium"),
+		},
+	},
+	{
+	.callback =3D init_nvs_nosave,
+	.ident =3D "Sony Vaio VGN-SR26GN_P",
+	.matches =3D {
+		DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "VGN-SR26GN_P"),
+		},
+	},
+	{
+	.callback =3D init_nvs_nosave,
+	.ident =3D "Sony Vaio VPCEB1S1E",
+	.matches =3D {
+		DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "VPCEB1S1E"),
+		},
+	},
+	{
+	.callback =3D init_nvs_nosave,
+	.ident =3D "Sony Vaio VGN-FW520F",
+	.matches =3D {
+		DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "VGN-FW520F"),
+		},
+	},
+	{
+	.callback =3D init_nvs_nosave,
+	.ident =3D "Asus K54C",
+	.matches =3D {
+		DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK Computer Inc."),
+		DMI_MATCH(DMI_PRODUCT_NAME, "K54C"),
+		},
+	},
+	{
+	.callback =3D init_nvs_nosave,
+	.ident =3D "Asus K54HR",
+	.matches =3D {
+		DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK Computer Inc."),
+		DMI_MATCH(DMI_PRODUCT_NAME, "K54HR"),
+		},
+	},
+	{},
+};
+
+static void acpi_sleep_dmi_check(void)
+{
+	dmi_check_system(acpisleep_dmi_table);
+}
+
 /**
  * acpi_pm_freeze - Disable the GPEs and suspend EC transactions.
  */
@@ -197,6 +371,7 @@ static void acpi_pm_end(void)
 }
 #else /* !CONFIG_ACPI_SLEEP */
 #define acpi_target_sleep_state	ACPI_STATE_S0
+static inline void acpi_sleep_dmi_check(void) {}
 #endif /* CONFIG_ACPI_SLEEP */
=20
 #ifdef CONFIG_SUSPEND
@@ -341,167 +516,6 @@ static const struct platform_suspend_ops acpi_suspend=
_ops_old =3D {
 	.end =3D acpi_pm_end,
 	.recover =3D acpi_pm_finish,
 };
-
-static int __init init_old_suspend_ordering(const struct dmi_system_id *d)
-{
-	old_suspend_ordering =3D true;
-	return 0;
-}
-
-static int __init init_nvs_nosave(const struct dmi_system_id *d)
-{
-	acpi_nvs_nosave();
-	return 0;
-}
-
-static struct dmi_system_id __initdata acpisleep_dmi_table[] =3D {
-	{
-	.callback =3D init_old_suspend_ordering,
-	.ident =3D "Abit KN9 (nForce4 variant)",
-	.matches =3D {
-		DMI_MATCH(DMI_BOARD_VENDOR, "http://www.abit.com.tw/"),
-		DMI_MATCH(DMI_BOARD_NAME, "KN9 Series(NF-CK804)"),
-		},
-	},
-	{
-	.callback =3D init_old_suspend_ordering,
-	.ident =3D "HP xw4600 Workstation",
-	.matches =3D {
-		DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
-		DMI_MATCH(DMI_PRODUCT_NAME, "HP xw4600 Workstation"),
-		},
-	},
-	{
-	.callback =3D init_old_suspend_ordering,
-	.ident =3D "Asus Pundit P1-AH2 (M2N8L motherboard)",
-	.matches =3D {
-		DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTek Computer INC."),
-		DMI_MATCH(DMI_BOARD_NAME, "M2N8L"),
-		},
-	},
-	{
-	.callback =3D init_old_suspend_ordering,
-	.ident =3D "Panasonic CF51-2L",
-	.matches =3D {
-		DMI_MATCH(DMI_BOARD_VENDOR,
-				"Matsushita Electric Industrial Co.,Ltd."),
-		DMI_MATCH(DMI_BOARD_NAME, "CF51-2L"),
-		},
-	},
-	{
-	.callback =3D init_nvs_nosave,
-	.ident =3D "Sony Vaio VGN-FW21E",
-	.matches =3D {
-		DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
-		DMI_MATCH(DMI_PRODUCT_NAME, "VGN-FW21E"),
-		},
-	},
-	{
-	.callback =3D init_nvs_nosave,
-	.ident =3D "Sony Vaio VPCEB17FX",
-	.matches =3D {
-		DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
-		DMI_MATCH(DMI_PRODUCT_NAME, "VPCEB17FX"),
-		},
-	},
-	{
-	.callback =3D init_nvs_nosave,
-	.ident =3D "Sony Vaio VGN-SR11M",
-	.matches =3D {
-		DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
-		DMI_MATCH(DMI_PRODUCT_NAME, "VGN-SR11M"),
-		},
-	},
-	{
-	.callback =3D init_nvs_nosave,
-	.ident =3D "Everex StepNote Series",
-	.matches =3D {
-		DMI_MATCH(DMI_SYS_VENDOR, "Everex Systems, Inc."),
-		DMI_MATCH(DMI_PRODUCT_NAME, "Everex StepNote Series"),
-		},
-	},
-	{
-	.callback =3D init_nvs_nosave,
-	.ident =3D "Sony Vaio VPCEB1Z1E",
-	.matches =3D {
-		DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
-		DMI_MATCH(DMI_PRODUCT_NAME, "VPCEB1Z1E"),
-		},
-	},
-	{
-	.callback =3D init_nvs_nosave,
-	.ident =3D "Sony Vaio VGN-NW130D",
-	.matches =3D {
-		DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
-		DMI_MATCH(DMI_PRODUCT_NAME, "VGN-NW130D"),
-		},
-	},
-	{
-	.callback =3D init_nvs_nosave,
-	.ident =3D "Sony Vaio VPCCW29FX",
-	.matches =3D {
-		DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
-		DMI_MATCH(DMI_PRODUCT_NAME, "VPCCW29FX"),
-		},
-	},
-	{
-	.callback =3D init_nvs_nosave,
-	.ident =3D "Averatec AV1020-ED2",
-	.matches =3D {
-		DMI_MATCH(DMI_SYS_VENDOR, "AVERATEC"),
-		DMI_MATCH(DMI_PRODUCT_NAME, "1000 Series"),
-		},
-	},
-	{
-	.callback =3D init_old_suspend_ordering,
-	.ident =3D "Asus A8N-SLI DELUXE",
-	.matches =3D {
-		DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK Computer INC."),
-		DMI_MATCH(DMI_BOARD_NAME, "A8N-SLI DELUXE"),
-		},
-	},
-	{
-	.callback =3D init_old_suspend_ordering,
-	.ident =3D "Asus A8N-SLI Premium",
-	.matches =3D {
-		DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK Computer INC."),
-		DMI_MATCH(DMI_BOARD_NAME, "A8N-SLI Premium"),
-		},
-	},
-	{
-	.callback =3D init_nvs_nosave,
-	.ident =3D "Sony Vaio VGN-SR26GN_P",
-	.matches =3D {
-		DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
-		DMI_MATCH(DMI_PRODUCT_NAME, "VGN-SR26GN_P"),
-		},
-	},
-	{
-	.callback =3D init_nvs_nosave,
-	.ident =3D "Sony Vaio VGN-FW520F",
-	.matches =3D {
-		DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
-		DMI_MATCH(DMI_PRODUCT_NAME, "VGN-FW520F"),
-		},
-	},
-	{
-	.callback =3D init_nvs_nosave,
-	.ident =3D "Asus K54C",
-	.matches =3D {
-		DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK Computer Inc."),
-		DMI_MATCH(DMI_PRODUCT_NAME, "K54C"),
-		},
-	},
-	{
-	.callback =3D init_nvs_nosave,
-	.ident =3D "Asus K54HR",
-	.matches =3D {
-		DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK Computer Inc."),
-		DMI_MATCH(DMI_PRODUCT_NAME, "K54HR"),
-		},
-	},
-	{},
-};
 #endif /* CONFIG_SUSPEND */
=20
 #ifdef CONFIG_HIBERNATION
@@ -808,13 +822,13 @@ int __init acpi_sleep_init(void)
 	u8 type_a, type_b;
 #ifdef CONFIG_SUSPEND
 	int i =3D 0;
-
-	dmi_check_system(acpisleep_dmi_table);
 #endif
=20
 	if (acpi_disabled)
 		return 0;
=20
+	acpi_sleep_dmi_check();
+
 	sleep_states[ACPI_STATE_S0] =3D 1;
 	printk(KERN_INFO PREFIX "(supports S0");
=20
diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
index 08a44b5..0e47949 100644
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -389,6 +389,12 @@ static int __init video_set_bqc_offset(const struct dm=
i_system_id *d)
 	return 0;
 }
=20
+static int video_ignore_initial_backlight(const struct dmi_system_id *d)
+{
+	use_bios_initial_backlight =3D 0;
+	return 0;
+}
+
 static struct dmi_system_id video_dmi_table[] __initdata =3D {
 	/*
 	 * Broken _BQC workaround http://bugzilla.kernel.org/show_bug.cgi?id=3D13=
121
@@ -433,6 +439,14 @@ static struct dmi_system_id video_dmi_table[] __initda=
ta =3D {
 		DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 7720"),
 		},
 	},
+	{
+	 .callback =3D video_ignore_initial_backlight,
+	 .ident =3D "HP Folio 13-2000",
+	 .matches =3D {
+		DMI_MATCH(DMI_BOARD_VENDOR, "Hewlett-Packard"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "HP Folio 13 - 2000 Notebook PC"),
+		},
+	},
 	{}
 };
=20
diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index f3f0fe7..d9c0199 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -132,6 +132,41 @@ find_video(acpi_handle handle, u32 lvl, void *context,=
 void **rv)
 	return AE_OK;
 }
=20
+/* Force to use vendor driver when the ACPI device is known to be
+ * buggy */
+static int video_detect_force_vendor(const struct dmi_system_id *d)
+{
+	acpi_video_support |=3D ACPI_VIDEO_BACKLIGHT_DMI_VENDOR;
+	return 0;
+}
+
+static struct dmi_system_id video_detect_dmi_table[] =3D {
+	/* On Samsung X360, the BIOS will set a flag (VDRV) if generic
+	 * ACPI backlight device is used. This flag will definitively break
+	 * the backlight interface (even the vendor interface) untill next
+	 * reboot. It's why we should prevent video.ko from being used here
+	 * and we can't rely on a later call to acpi_video_unregister().
+	 */
+	{
+	 .callback =3D video_detect_force_vendor,
+	 .ident =3D "X360",
+	 .matches =3D {
+		DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
+		DMI_MATCH(DMI_PRODUCT_NAME, "X360"),
+		DMI_MATCH(DMI_BOARD_NAME, "X360"),
+		},
+	},
+	{
+	.callback =3D video_detect_force_vendor,
+	.ident =3D "Asus UL30VT",
+	.matches =3D {
+		DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK Computer Inc."),
+		DMI_MATCH(DMI_PRODUCT_NAME, "UL30VT"),
+		},
+	},
+	{ },
+};
+
 /*
  * Returns the video capabilities of a specific ACPI graphics device
  *
@@ -164,6 +199,8 @@ long acpi_video_get_capabilities(acpi_handle graphics_h=
andle)
 		 *		ACPI_VIDEO_BACKLIGHT_DMI_VENDOR;
 		 *}
 		 */
+
+		dmi_check_system(video_detect_dmi_table);
 	} else {
 		status =3D acpi_bus_get_device(graphics_handle, &tmp_dev);
 		if (ACPI_FAILURE(status)) {
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 321e23e..c9540c0 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2529,6 +2529,7 @@ int ata_bus_probe(struct ata_port *ap)
 		 * bus as we may be talking too fast.
 		 */
 		dev->pio_mode =3D XFER_PIO_0;
+		dev->dma_mode =3D 0xff;
=20
 		/* If the controller has a pio mode setup function
 		 * then use it to set the chipset to rights. Don't
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 58db834..aea627e 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -2599,6 +2599,7 @@ int ata_eh_reset(struct ata_link *link, int classify,
 		 * bus as we may be talking too fast.
 		 */
 		dev->pio_mode =3D XFER_PIO_0;
+		dev->dma_mode =3D 0xff;
=20
 		/* If the controller has a pio mode setup function
 		 * then use it to set the chipset to rights. Don't
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 2a5412e..dd332e5 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -309,7 +309,8 @@ ata_scsi_activity_show(struct device *dev, struct devic=
e_attribute *attr,
 	struct ata_port *ap =3D ata_shost_to_port(sdev->host);
 	struct ata_device *atadev =3D ata_scsi_find_dev(ap, sdev);
=20
-	if (ap->ops->sw_activity_show && (ap->flags & ATA_FLAG_SW_ACTIVITY))
+	if (atadev && ap->ops->sw_activity_show &&
+	    (ap->flags & ATA_FLAG_SW_ACTIVITY))
 		return ap->ops->sw_activity_show(atadev, buf);
 	return -EINVAL;
 }
@@ -324,7 +325,8 @@ ata_scsi_activity_store(struct device *dev, struct devi=
ce_attribute *attr,
 	enum sw_activity val;
 	int rc;
=20
-	if (ap->ops->sw_activity_store && (ap->flags & ATA_FLAG_SW_ACTIVITY)) {
+	if (atadev && ap->ops->sw_activity_store &&
+	    (ap->flags & ATA_FLAG_SW_ACTIVITY)) {
 		val =3D simple_strtoul(buf, NULL, 0);
 		switch (val) {
 		case OFF: case BLINK_ON: case BLINK_OFF:
diff --git a/drivers/ata/sata_promise.c b/drivers/ata/sata_promise.c
index 000fcc9..ef6e328 100644
--- a/drivers/ata/sata_promise.c
+++ b/drivers/ata/sata_promise.c
@@ -147,6 +147,10 @@ struct pdc_port_priv {
 	dma_addr_t		pkt_dma;
 };
=20
+struct pdc_host_priv {
+	spinlock_t hard_reset_lock;
+};
+
 static int pdc_sata_scr_read(struct ata_link *link, unsigned int sc_reg, u=
32 *val);
 static int pdc_sata_scr_write(struct ata_link *link, unsigned int sc_reg, =
u32 val);
 static int pdc_ata_init_one(struct pci_dev *pdev, const struct pci_device_=
id *ent);
@@ -801,9 +805,10 @@ static void pdc_hard_reset_port(struct ata_port *ap)
 	void __iomem *host_mmio =3D ap->host->iomap[PDC_MMIO_BAR];
 	void __iomem *pcictl_b1_mmio =3D host_mmio + PDC_PCI_CTL + 1;
 	unsigned int ata_no =3D pdc_ata_port_to_ata_no(ap);
+	struct pdc_host_priv *hpriv =3D ap->host->private_data;
 	u8 tmp;
=20
-	spin_lock(&ap->host->lock);
+	spin_lock(&hpriv->hard_reset_lock);
=20
 	tmp =3D readb(pcictl_b1_mmio);
 	tmp &=3D ~(0x10 << ata_no);
@@ -814,7 +819,7 @@ static void pdc_hard_reset_port(struct ata_port *ap)
 	writeb(tmp, pcictl_b1_mmio);
 	readb(pcictl_b1_mmio); /* flush */
=20
-	spin_unlock(&ap->host->lock);
+	spin_unlock(&hpriv->hard_reset_lock);
 }
=20
 static int pdc_sata_hardreset(struct ata_link *link, unsigned int *class,
@@ -1182,6 +1187,7 @@ static int pdc_ata_init_one(struct pci_dev *pdev,
 	const struct ata_port_info *pi =3D &pdc_port_info[ent->driver_data];
 	const struct ata_port_info *ppi[PDC_MAX_PORTS];
 	struct ata_host *host;
+	struct pdc_host_priv *hpriv;
 	void __iomem *host_mmio;
 	int n_ports, i, rc;
 	int is_sataii_tx4;
@@ -1218,6 +1224,11 @@ static int pdc_ata_init_one(struct pci_dev *pdev,
 		dev_err(&pdev->dev, "failed to allocate host\n");
 		return -ENOMEM;
 	}
+	hpriv =3D devm_kzalloc(&pdev->dev, sizeof *hpriv, GFP_KERNEL);
+	if (!hpriv)
+		return -ENOMEM;
+	spin_lock_init(&hpriv->hard_reset_lock);
+	host->private_data =3D hpriv;
 	host->iomap =3D pcim_iomap_table(pdev);
=20
 	is_sataii_tx4 =3D pdc_is_sataii_tx4(pi->flags);
diff --git a/drivers/ata/sata_svw.c b/drivers/ata/sata_svw.c
index c646118..833607f 100644
--- a/drivers/ata/sata_svw.c
+++ b/drivers/ata/sata_svw.c
@@ -142,6 +142,39 @@ static int k2_sata_scr_write(struct ata_link *link,
 	return 0;
 }
=20
+static int k2_sata_softreset(struct ata_link *link,
+			     unsigned int *class, unsigned long deadline)
+{
+	u8 dmactl;
+	void __iomem *mmio =3D link->ap->ioaddr.bmdma_addr;
+
+	dmactl =3D readb(mmio + ATA_DMA_CMD);
+
+	/* Clear the start bit */
+	if (dmactl & ATA_DMA_START) {
+		dmactl &=3D ~ATA_DMA_START;
+		writeb(dmactl, mmio + ATA_DMA_CMD);
+	}
+
+	return ata_sff_softreset(link, class, deadline);
+}
+
+static int k2_sata_hardreset(struct ata_link *link,
+			     unsigned int *class, unsigned long deadline)
+{
+	u8 dmactl;
+	void __iomem *mmio =3D link->ap->ioaddr.bmdma_addr;
+
+	dmactl =3D readb(mmio + ATA_DMA_CMD);
+
+	/* Clear the start bit */
+	if (dmactl & ATA_DMA_START) {
+		dmactl &=3D ~ATA_DMA_START;
+		writeb(dmactl, mmio + ATA_DMA_CMD);
+	}
+
+	return sata_sff_hardreset(link, class, deadline);
+}
=20
 static void k2_sata_tf_load(struct ata_port *ap, const struct ata_taskfile=
 *tf)
 {
@@ -346,6 +379,8 @@ static struct scsi_host_template k2_sata_sht =3D {
=20
 static struct ata_port_operations k2_sata_ops =3D {
 	.inherits		=3D &ata_bmdma_port_ops,
+	.softreset              =3D k2_sata_softreset,
+	.hardreset              =3D k2_sata_hardreset,
 	.sff_tf_load		=3D k2_sata_tf_load,
 	.sff_tf_read		=3D k2_sata_tf_read,
 	.sff_check_status	=3D k2_stat_check_status,
diff --git a/drivers/atm/solos-pci.c b/drivers/atm/solos-pci.c
index d452592..adfce9f 100644
--- a/drivers/atm/solos-pci.c
+++ b/drivers/atm/solos-pci.c
@@ -967,10 +967,11 @@ static uint32_t fpga_tx(struct solos_card *card)
 	for (port =3D 0; tx_pending; tx_pending >>=3D 1, port++) {
 		if (tx_pending & 1) {
 			struct sk_buff *oldskb =3D card->tx_skb[port];
-			if (oldskb)
+			if (oldskb) {
 				pci_unmap_single(card->dev, SKB_CB(oldskb)->dma_addr,
 						 oldskb->len, PCI_DMA_TODEVICE);
-
+				card->tx_skb[port] =3D NULL;
+			}
 			spin_lock(&card->tx_queue_lock);
 			skb =3D skb_dequeue(&card->tx_queue[port]);
 			if (!skb)
diff --git a/drivers/base/regmap/regmap-debugfs.c b/drivers/base/regmap/reg=
map-debugfs.c
index 6f39747..cd252e0 100644
--- a/drivers/base/regmap/regmap-debugfs.c
+++ b/drivers/base/regmap/regmap-debugfs.c
@@ -67,7 +67,7 @@ static ssize_t regmap_map_read_file(struct file *file, ch=
ar __user *user_buf,
 		/* If we're in the region the user is trying to read */
 		if (p >=3D *ppos) {
 			/* ...but not beyond it */
-			if (buf_pos >=3D count - 1 - tot_len)
+			if (buf_pos + 1 + tot_len >=3D count)
 				break;
=20
 			/* Format the register */
diff --git a/drivers/bcma/driver_mips.c b/drivers/bcma/driver_mips.c
index c3e9dff..041fddf 100644
--- a/drivers/bcma/driver_mips.c
+++ b/drivers/bcma/driver_mips.c
@@ -115,7 +115,7 @@ static void bcma_core_mips_set_irq(struct bcma_device *=
dev, unsigned int irq)
 			    bcma_read32(mdev, BCMA_MIPS_MIPS74K_INTMASK(0)) &
 			    ~(1 << irqflag));
 	else
-		bcma_write32(mdev, BCMA_MIPS_MIPS74K_INTMASK(irq), 0);
+		bcma_write32(mdev, BCMA_MIPS_MIPS74K_INTMASK(oldirq), 0);
=20
 	/* assign the new one */
 	if (irq =3D=3D 0) {
diff --git a/drivers/bluetooth/ath3k.c b/drivers/bluetooth/ath3k.c
index 5c6709d..574ce73 100644
--- a/drivers/bluetooth/ath3k.c
+++ b/drivers/bluetooth/ath3k.c
@@ -66,6 +66,7 @@ static struct usb_device_id ath3k_table[] =3D {
 	{ USB_DEVICE(0x13d3, 0x3304) },
 	{ USB_DEVICE(0x0930, 0x0215) },
 	{ USB_DEVICE(0x0489, 0xE03D) },
+	{ USB_DEVICE(0x0489, 0xE027) },
=20
 	/* Atheros AR9285 Malbec with sflash firmware */
 	{ USB_DEVICE(0x03F0, 0x311D) },
diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 1f90dab..c5e44a3 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -104,6 +104,8 @@ static struct usb_device_id btusb_table[] =3D {
 	{ USB_DEVICE(0x0c10, 0x0000) },
=20
 	/* Broadcom BCM20702A0 */
+	{ USB_DEVICE(0x0b05, 0x17b5) },
+	{ USB_DEVICE(0x04ca, 0x2003) },
 	{ USB_DEVICE(0x0489, 0xe042) },
 	{ USB_DEVICE(0x413c, 0x8197) },
=20
@@ -131,6 +133,7 @@ static struct usb_device_id blacklist_table[] =3D {
 	{ USB_DEVICE(0x13d3, 0x3304), .driver_info =3D BTUSB_IGNORE },
 	{ USB_DEVICE(0x0930, 0x0215), .driver_info =3D BTUSB_IGNORE },
 	{ USB_DEVICE(0x0489, 0xe03d), .driver_info =3D BTUSB_IGNORE },
+	{ USB_DEVICE(0x0489, 0xe027), .driver_info =3D BTUSB_IGNORE },
=20
 	/* Atheros AR9285 Malbec with sflash firmware */
 	{ USB_DEVICE(0x03f0, 0x311d), .driver_info =3D BTUSB_IGNORE },
diff --git a/drivers/char/agp/intel-agp.h b/drivers/char/agp/intel-agp.h
index 6f24604..439d7e7 100644
--- a/drivers/char/agp/intel-agp.h
+++ b/drivers/char/agp/intel-agp.h
@@ -235,6 +235,7 @@
 #define PCI_DEVICE_ID_INTEL_IVYBRIDGE_M_GT2_IG		0x0166
 #define PCI_DEVICE_ID_INTEL_IVYBRIDGE_S_HB		0x0158  /* Server */
 #define PCI_DEVICE_ID_INTEL_IVYBRIDGE_S_GT1_IG		0x015A
+#define PCI_DEVICE_ID_INTEL_IVYBRIDGE_S_GT2_IG		0x016A
=20
 int intel_gmch_probe(struct pci_dev *pdev,
 			       struct agp_bridge_data *bridge);
diff --git a/drivers/char/agp/intel-gtt.c b/drivers/char/agp/intel-gtt.c
index c92424c..43c4ec3 100644
--- a/drivers/char/agp/intel-gtt.c
+++ b/drivers/char/agp/intel-gtt.c
@@ -1459,6 +1459,8 @@ static const struct intel_gtt_driver_description {
 	    "Ivybridge", &sandybridge_gtt_driver },
 	{ PCI_DEVICE_ID_INTEL_IVYBRIDGE_S_GT1_IG,
 	    "Ivybridge", &sandybridge_gtt_driver },
+	{ PCI_DEVICE_ID_INTEL_IVYBRIDGE_S_GT2_IG,
+	    "Ivybridge", &sandybridge_gtt_driver },
 	{ 0, NULL, NULL }
 };
=20
diff --git a/drivers/char/ramoops.c b/drivers/char/ramoops.c
index 7c7f42a1f8..9658116 100644
--- a/drivers/char/ramoops.c
+++ b/drivers/char/ramoops.c
@@ -126,8 +126,8 @@ static int __init ramoops_probe(struct platform_device =
*pdev)
 		goto fail3;
 	}
=20
-	rounddown_pow_of_two(pdata->mem_size);
-	rounddown_pow_of_two(pdata->record_size);
+	pdata->mem_size =3D rounddown_pow_of_two(pdata->mem_size);
+	pdata->record_size =3D rounddown_pow_of_two(pdata->record_size);
=20
 	/* Check for the minimum memory size */
 	if (pdata->mem_size < MIN_MEM_SIZE &&
diff --git a/drivers/edac/i7300_edac.c b/drivers/edac/i7300_edac.c
index 6104dba..2244df0 100644
--- a/drivers/edac/i7300_edac.c
+++ b/drivers/edac/i7300_edac.c
@@ -215,8 +215,8 @@ static const char *ferr_fat_fbd_name[] =3D {
 	[0]  =3D "Memory Write error on non-redundant retry or "
 	       "FBD configuration Write error on retry",
 };
-#define GET_FBD_FAT_IDX(fbderr)	(fbderr & (3 << 28))
-#define FERR_FAT_FBD_ERR_MASK ((1 << 0) | (1 << 1) | (1 << 2) | (1 << 3))
+#define GET_FBD_FAT_IDX(fbderr)	(((fbderr) >> 28) & 3)
+#define FERR_FAT_FBD_ERR_MASK ((1 << 0) | (1 << 1) | (1 << 2) | (1 << 22))
=20
 #define FERR_NF_FBD	0xa0
 static const char *ferr_nf_fbd_name[] =3D {
@@ -243,7 +243,7 @@ static const char *ferr_nf_fbd_name[] =3D {
 	[1]  =3D "Aliased Uncorrectable Non-Mirrored Demand Data ECC",
 	[0]  =3D "Uncorrectable Data ECC on Replay",
 };
-#define GET_FBD_NF_IDX(fbderr)	(fbderr & (3 << 28))
+#define GET_FBD_NF_IDX(fbderr)	(((fbderr) >> 28) & 3)
 #define FERR_NF_FBD_ERR_MASK ((1 << 24) | (1 << 23) | (1 << 22) | (1 << 21=
) |\
 			      (1 << 18) | (1 << 17) | (1 << 16) | (1 << 15) |\
 			      (1 << 14) | (1 << 13) | (1 << 11) | (1 << 10) |\
@@ -485,7 +485,7 @@ static void i7300_process_fbd_error(struct mem_ctl_info=
 *mci)
 		errnum =3D find_first_bit(&errors,
 					ARRAY_SIZE(ferr_nf_fbd_name));
 		specific =3D GET_ERR_FROM_TABLE(ferr_nf_fbd_name, errnum);
-		branch =3D (GET_FBD_FAT_IDX(error_reg) =3D=3D 2) ? 1 : 0;
+		branch =3D (GET_FBD_NF_IDX(error_reg) =3D=3D 2) ? 1 : 0;
=20
 		pci_read_config_dword(pvt->pci_dev_16_1_fsb_addr_map,
 			REDMEMA, &syndrome);
diff --git a/drivers/edac/i82975x_edac.c b/drivers/edac/i82975x_edac.c
index a5da732..01658ca 100644
--- a/drivers/edac/i82975x_edac.c
+++ b/drivers/edac/i82975x_edac.c
@@ -355,10 +355,6 @@ static enum dev_type i82975x_dram_type(void __iomem *m=
ch_window, int rank)
 static void i82975x_init_csrows(struct mem_ctl_info *mci,
 		struct pci_dev *pdev, void __iomem *mch_window)
 {
-	static const char *labels[4] =3D {
-							"DIMM A1", "DIMM A2",
-							"DIMM B1", "DIMM B2"
-						};
 	struct csrow_info *csrow;
 	unsigned long last_cumul_size;
 	u8 value;
@@ -399,9 +395,10 @@ static void i82975x_init_csrows(struct mem_ctl_info *m=
ci,
 		 *   [0-3] for dual-channel; i.e. csrow->nr_channels =3D 2
 		 */
 		for (chan =3D 0; chan < csrow->nr_channels; chan++)
-			strncpy(csrow->channels[chan].label,
-					labels[(index >> 1) + (chan * 2)],
-					EDAC_MC_LABEL_LEN);
+
+			snprintf(csrow->channels[chan].label, EDAC_MC_LABEL_LEN, "DIMM %c%d",
+				 (chan =3D=3D 0) ? 'A' : 'B',
+				 index);
=20
 		if (cumul_size =3D=3D last_cumul_size)
 			continue;	/* not populated */
diff --git a/drivers/firewire/net.c b/drivers/firewire/net.c
index a20f45b..7c869b7 100644
--- a/drivers/firewire/net.c
+++ b/drivers/firewire/net.c
@@ -860,8 +860,8 @@ static void fwnet_receive_broadcast(struct fw_iso_conte=
xt *context,
 	if (specifier_id =3D=3D IANA_SPECIFIER_ID && ver =3D=3D RFC2734_SW_VERSIO=
N) {
 		buf_ptr +=3D 2;
 		length -=3D IEEE1394_GASP_HDR_SIZE;
-		fwnet_incoming_packet(dev, buf_ptr, length,
-				      source_node_id, -1, true);
+		fwnet_incoming_packet(dev, buf_ptr, length, source_node_id,
+				      context->card->generation, true);
 	}
=20
 	packet.payload_length =3D dev->rcv_buffer_size;
@@ -956,7 +956,12 @@ static void fwnet_transmit_packet_done(struct fwnet_pa=
cket_task *ptask)
 			break;
 		}
=20
-		skb_pull(skb, ptask->max_payload);
+		if (ptask->dest_node =3D=3D IEEE1394_ALL_NODES) {
+			skb_pull(skb,
+				 ptask->max_payload + IEEE1394_GASP_HDR_SIZE);
+		} else {
+			skb_pull(skb, ptask->max_payload);
+		}
 		if (ptask->outstanding_pkts > 1) {
 			fwnet_make_sf_hdr(&ptask->hdr, RFC2374_HDR_INTFRAG,
 					  dg_size, fg_off, datagram_label);
@@ -1059,7 +1064,7 @@ static int fwnet_send_packet(struct fwnet_packet_task=
 *ptask)
 		smp_rmb();
 		node_id =3D dev->card->node_id;
=20
-		p =3D skb_push(ptask->skb, 8);
+		p =3D skb_push(ptask->skb, IEEE1394_GASP_HDR_SIZE);
 		put_unaligned_be32(node_id << 16 | IANA_SPECIFIER_ID >> 8, p);
 		put_unaligned_be32((IANA_SPECIFIER_ID & 0xff) << 24
 						| RFC2734_SW_VERSION, &p[4]);
diff --git a/drivers/gpu/drm/drm_crtc_helper.c b/drivers/gpu/drm/drm_crtc_h=
elper.c
index d2619d7..11788f7 100644
--- a/drivers/gpu/drm/drm_crtc_helper.c
+++ b/drivers/gpu/drm/drm_crtc_helper.c
@@ -321,8 +321,8 @@ drm_crtc_prepare_encoders(struct drm_device *dev)
  * drm_crtc_set_mode - set a mode
  * @crtc: CRTC to program
  * @mode: mode to use
- * @x: width of mode
- * @y: height of mode
+ * @x: horizontal offset into the surface
+ * @y: vertical offset into the surface
  *
  * LOCKING:
  * Caller must hold mode config lock.
diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
index 0c1a99b..bb95d59 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -274,6 +274,11 @@ drm_do_probe_ddc_edid(struct i2c_adapter *adapter, uns=
igned char *buf,
 			}
 		};
 		ret =3D i2c_transfer(adapter, msgs, 2);
+		if (ret =3D=3D -ENXIO) {
+			DRM_DEBUG_KMS("drm: skipping non-existent adapter %s\n",
+					adapter->name);
+			break;
+		}
 	} while (ret !=3D 2 && --retries);
=20
 	return ret =3D=3D 2 ? 0 : -1;
diff --git a/drivers/gpu/drm/i915/i915_debugfs.c b/drivers/gpu/drm/i915/i91=
5_debugfs.c
index b2e3c97..d00f905 100644
--- a/drivers/gpu/drm/i915/i915_debugfs.c
+++ b/drivers/gpu/drm/i915/i915_debugfs.c
@@ -339,7 +339,7 @@ static int i915_gem_pageflip_info(struct seq_file *m, v=
oid *data)
 			seq_printf(m, "No flip due on pipe %c (plane %c)\n",
 				   pipe, plane);
 		} else {
-			if (!work->pending) {
+			if (atomic_read(&work->pending) < INTEL_FLIP_COMPLETE) {
 				seq_printf(m, "Flip queued on pipe %c (plane %c)\n",
 					   pipe, plane);
 			} else {
@@ -350,7 +350,7 @@ static int i915_gem_pageflip_info(struct seq_file *m, v=
oid *data)
 				seq_printf(m, "Stall check enabled, ");
 			else
 				seq_printf(m, "Stall check waiting for page flip ioctl, ");
-			seq_printf(m, "%d prepares\n", work->pending);
+			seq_printf(m, "%d prepares\n", atomic_read(&work->pending));
=20
 			if (work->old_fb_obj) {
 				struct drm_i915_gem_object *obj =3D work->old_fb_obj;
diff --git a/drivers/gpu/drm/i915/i915_drv.c b/drivers/gpu/drm/i915/i915_dr=
v.c
index 3a1bfd7..452bc51 100644
--- a/drivers/gpu/drm/i915/i915_drv.c
+++ b/drivers/gpu/drm/i915/i915_drv.c
@@ -287,6 +287,7 @@ static const struct pci_device_id pciidlist[] =3D {		/*=
 aka */
 	INTEL_VGA_DEVICE(0x0152, &intel_ivybridge_d_info), /* GT1 desktop */
 	INTEL_VGA_DEVICE(0x0162, &intel_ivybridge_d_info), /* GT2 desktop */
 	INTEL_VGA_DEVICE(0x015a, &intel_ivybridge_d_info), /* GT1 server */
+	INTEL_VGA_DEVICE(0x016a, &intel_ivybridge_d_info), /* GT2 server */
 	{0, 0, 0}
 };
=20
diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_ge=
m.c
index dbe4dbe..5950ba3 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -1259,6 +1259,11 @@ out:
 	case 0:
 	case -ERESTARTSYS:
 	case -EINTR:
+	case -EBUSY:
+		/*
+		 * EBUSY is ok: this just means that another thread
+		 * already did the job.
+		 */
 		return VM_FAULT_NOPAGE;
 	case -ENOMEM:
 		return VM_FAULT_OOM;
diff --git a/drivers/gpu/drm/i915/i915_irq.c b/drivers/gpu/drm/i915/i915_ir=
q.c
index 2812d7b..93e74fb 100644
--- a/drivers/gpu/drm/i915/i915_irq.c
+++ b/drivers/gpu/drm/i915/i915_irq.c
@@ -1187,7 +1187,9 @@ static void i915_pageflip_stall_check(struct drm_devi=
ce *dev, int pipe)
 	spin_lock_irqsave(&dev->event_lock, flags);
 	work =3D intel_crtc->unpin_work;
=20
-	if (work =3D=3D NULL || work->pending || !work->enable_stall_check) {
+	if (work =3D=3D NULL ||
+	    atomic_read(&work->pending) >=3D INTEL_FLIP_COMPLETE ||
+	    !work->enable_stall_check) {
 		/* Either the pending flip IRQ arrived, or we're too early. Don't check =
*/
 		spin_unlock_irqrestore(&dev->event_lock, flags);
 		return;
diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_re=
g.h
index a294a32..7a10f5f 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -2816,6 +2816,8 @@
 #define _PFA_CTL_1               0x68080
 #define _PFB_CTL_1               0x68880
 #define  PF_ENABLE              (1<<31)
+#define  PF_PIPE_SEL_MASK_IVB	(3<<29)
+#define  PF_PIPE_SEL_IVB(pipe)	((pipe)<<29)
 #define  PF_FILTER_MASK		(3<<23)
 #define  PF_FILTER_PROGRAMMED	(0<<23)
 #define  PF_FILTER_MED_3x3	(1<<23)
diff --git a/drivers/gpu/drm/i915/intel_bios.c b/drivers/gpu/drm/i915/intel=
_bios.c
index 87bb87b..0016fee 100644
--- a/drivers/gpu/drm/i915/intel_bios.c
+++ b/drivers/gpu/drm/i915/intel_bios.c
@@ -495,12 +495,8 @@ parse_edp(struct drm_i915_private *dev_priv, struct bd=
b_header *bdb)
=20
 	edp =3D find_section(bdb, BDB_EDP);
 	if (!edp) {
-		if (SUPPORTS_EDP(dev_priv->dev) && dev_priv->edp.support) {
-			DRM_DEBUG_KMS("No eDP BDB found but eDP panel "
-				      "supported, assume %dbpp panel color "
-				      "depth.\n",
-				      dev_priv->edp.bpp);
-		}
+		if (SUPPORTS_EDP(dev_priv->dev) && dev_priv->edp.support)
+			DRM_DEBUG_KMS("No eDP BDB found but eDP panel supported.\n");
 		return;
 	}
=20
@@ -653,9 +649,6 @@ init_vbt_defaults(struct drm_i915_private *dev_priv)
 	dev_priv->lvds_use_ssc =3D 1;
 	dev_priv->lvds_ssc_freq =3D intel_bios_ssc_frequency(dev, 1);
 	DRM_DEBUG_KMS("Set default to SSC at %dMHz\n", dev_priv->lvds_ssc_freq);
-
-	/* eDP data */
-	dev_priv->edp.bpp =3D 18;
 }
=20
 static int __init intel_no_opregion_vbt_callback(const struct dmi_system_i=
d *id)
diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/in=
tel_display.c
index fdae61f..54acad3 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -2384,18 +2384,6 @@ static void intel_fdi_normal_train(struct drm_crtc *=
crtc)
 			   FDI_FE_ERRC_ENABLE);
 }
=20
-static void cpt_phase_pointer_enable(struct drm_device *dev, int pipe)
-{
-	struct drm_i915_private *dev_priv =3D dev->dev_private;
-	u32 flags =3D I915_READ(SOUTH_CHICKEN1);
-
-	flags |=3D FDI_PHASE_SYNC_OVR(pipe);
-	I915_WRITE(SOUTH_CHICKEN1, flags); /* once to unlock... */
-	flags |=3D FDI_PHASE_SYNC_EN(pipe);
-	I915_WRITE(SOUTH_CHICKEN1, flags); /* then again to enable */
-	POSTING_READ(SOUTH_CHICKEN1);
-}
-
 /* The FDI link training functions for ILK/Ibexpeak. */
 static void ironlake_fdi_link_train(struct drm_crtc *crtc)
 {
@@ -2439,11 +2427,9 @@ static void ironlake_fdi_link_train(struct drm_crtc =
*crtc)
 	udelay(150);
=20
 	/* Ironlake workaround, enable clock pointer after FDI enable*/
-	if (HAS_PCH_IBX(dev)) {
-		I915_WRITE(FDI_RX_CHICKEN(pipe), FDI_RX_PHASE_SYNC_POINTER_OVR);
-		I915_WRITE(FDI_RX_CHICKEN(pipe), FDI_RX_PHASE_SYNC_POINTER_OVR |
-			   FDI_RX_PHASE_SYNC_POINTER_EN);
-	}
+	I915_WRITE(FDI_RX_CHICKEN(pipe), FDI_RX_PHASE_SYNC_POINTER_OVR);
+	I915_WRITE(FDI_RX_CHICKEN(pipe), FDI_RX_PHASE_SYNC_POINTER_OVR |
+		   FDI_RX_PHASE_SYNC_POINTER_EN);
=20
 	reg =3D FDI_RX_IIR(pipe);
 	for (tries =3D 0; tries < 5; tries++) {
@@ -2546,9 +2532,6 @@ static void gen6_fdi_link_train(struct drm_crtc *crtc=
)
 	POSTING_READ(reg);
 	udelay(150);
=20
-	if (HAS_PCH_CPT(dev))
-		cpt_phase_pointer_enable(dev, pipe);
-
 	for (i =3D 0; i < 4; i++) {
 		reg =3D FDI_TX_CTL(pipe);
 		temp =3D I915_READ(reg);
@@ -2667,9 +2650,6 @@ static void ivb_manual_fdi_link_train(struct drm_crtc=
 *crtc)
 	POSTING_READ(reg);
 	udelay(150);
=20
-	if (HAS_PCH_CPT(dev))
-		cpt_phase_pointer_enable(dev, pipe);
-
 	for (i =3D 0; i < 4; i++) {
 		reg =3D FDI_TX_CTL(pipe);
 		temp =3D I915_READ(reg);
@@ -2779,17 +2759,6 @@ static void ironlake_fdi_pll_enable(struct drm_crtc =
*crtc)
 	}
 }
=20
-static void cpt_phase_pointer_disable(struct drm_device *dev, int pipe)
-{
-	struct drm_i915_private *dev_priv =3D dev->dev_private;
-	u32 flags =3D I915_READ(SOUTH_CHICKEN1);
-
-	flags &=3D ~(FDI_PHASE_SYNC_EN(pipe));
-	I915_WRITE(SOUTH_CHICKEN1, flags); /* once to disable... */
-	flags &=3D ~(FDI_PHASE_SYNC_OVR(pipe));
-	I915_WRITE(SOUTH_CHICKEN1, flags); /* then again to lock */
-	POSTING_READ(SOUTH_CHICKEN1);
-}
 static void ironlake_fdi_disable(struct drm_crtc *crtc)
 {
 	struct drm_device *dev =3D crtc->dev;
@@ -2819,8 +2788,6 @@ static void ironlake_fdi_disable(struct drm_crtc *crt=
c)
 		I915_WRITE(FDI_RX_CHICKEN(pipe),
 			   I915_READ(FDI_RX_CHICKEN(pipe) &
 				     ~FDI_RX_PHASE_SYNC_POINTER_EN));
-	} else if (HAS_PCH_CPT(dev)) {
-		cpt_phase_pointer_disable(dev, pipe);
 	}
=20
 	/* still set train pattern 1 */
@@ -3073,7 +3040,11 @@ static void ironlake_crtc_enable(struct drm_crtc *cr=
tc)
 		 * as some pre-programmed values are broken,
 		 * e.g. x201.
 		 */
-		I915_WRITE(PF_CTL(pipe), PF_ENABLE | PF_FILTER_MED_3x3);
+		if (IS_IVYBRIDGE(dev))
+			I915_WRITE(PF_CTL(pipe), PF_ENABLE | PF_FILTER_MED_3x3 |
+						 PF_PIPE_SEL_IVB(pipe));
+		else
+			I915_WRITE(PF_CTL(pipe), PF_ENABLE | PF_FILTER_MED_3x3);
 		I915_WRITE(PF_WIN_POS(pipe), dev_priv->pch_pf_pos);
 		I915_WRITE(PF_WIN_SZ(pipe), dev_priv->pch_pf_size);
 	}
@@ -4782,6 +4753,17 @@ static bool intel_choose_pipe_bpp_dither(struct drm_=
crtc *crtc,
 			}
 		}
=20
+		if (intel_encoder->type =3D=3D INTEL_OUTPUT_EDP) {
+			/* Use VBT settings if we have an eDP panel */
+			unsigned int edp_bpc =3D dev_priv->edp.bpp / 3;
+
+			if (edp_bpc && edp_bpc < display_bpc) {
+				DRM_DEBUG_KMS("clamping display bpc (was %d) to eDP (%d)\n", display_b=
pc, edp_bpc);
+				display_bpc =3D edp_bpc;
+			}
+			continue;
+		}
+
 		/*
 		 * HDMI is either 12 or 8, so if the display lets 10bpc sneak
 		 * through, clamp it down.  (Note: >12bpc will be caught below.)
@@ -6945,11 +6927,18 @@ static void do_intel_finish_page_flip(struct drm_de=
vice *dev,
=20
 	spin_lock_irqsave(&dev->event_lock, flags);
 	work =3D intel_crtc->unpin_work;
-	if (work =3D=3D NULL || !work->pending) {
+
+	/* Ensure we don't miss a work->pending update ... */
+	smp_rmb();
+
+	if (work =3D=3D NULL || atomic_read(&work->pending) < INTEL_FLIP_COMPLETE=
) {
 		spin_unlock_irqrestore(&dev->event_lock, flags);
 		return;
 	}
=20
+	/* and that the unpin work is consistent wrt ->pending. */
+	smp_rmb();
+
 	intel_crtc->unpin_work =3D NULL;
=20
 	if (work->event) {
@@ -7021,16 +7010,25 @@ void intel_prepare_page_flip(struct drm_device *dev=
, int plane)
 		to_intel_crtc(dev_priv->plane_to_crtc_mapping[plane]);
 	unsigned long flags;
=20
+	/* NB: An MMIO update of the plane base pointer will also
+	 * generate a page-flip completion irq, i.e. every modeset
+	 * is also accompanied by a spurious intel_prepare_page_flip().
+	 */
 	spin_lock_irqsave(&dev->event_lock, flags);
-	if (intel_crtc->unpin_work) {
-		if ((++intel_crtc->unpin_work->pending) > 1)
-			DRM_ERROR("Prepared flip multiple times\n");
-	} else {
-		DRM_DEBUG_DRIVER("preparing flip with no unpin work?\n");
-	}
+	if (intel_crtc->unpin_work)
+		atomic_inc_not_zero(&intel_crtc->unpin_work->pending);
 	spin_unlock_irqrestore(&dev->event_lock, flags);
 }
=20
+inline static void intel_mark_page_flip_active(struct intel_crtc *intel_cr=
tc)
+{
+	/* Ensure that the work item is consistent when activating it ... */
+	smp_wmb();
+	atomic_set(&intel_crtc->unpin_work->pending, INTEL_FLIP_PENDING);
+	/* and that it is marked active as soon as the irq could fire. */
+	smp_wmb();
+}
+
 static int intel_gen2_queue_flip(struct drm_device *dev,
 				 struct drm_crtc *crtc,
 				 struct drm_framebuffer *fb,
@@ -7067,6 +7065,8 @@ static int intel_gen2_queue_flip(struct drm_device *d=
ev,
 	OUT_RING(fb->pitch);
 	OUT_RING(obj->gtt_offset + offset);
 	OUT_RING(MI_NOOP);
+
+	intel_mark_page_flip_active(intel_crtc);
 	ADVANCE_LP_RING();
 	return 0;
=20
@@ -7110,6 +7110,7 @@ static int intel_gen3_queue_flip(struct drm_device *d=
ev,
 	OUT_RING(obj->gtt_offset + offset);
 	OUT_RING(MI_NOOP);
=20
+	intel_mark_page_flip_active(intel_crtc);
 	ADVANCE_LP_RING();
 	return 0;
=20
@@ -7153,6 +7154,10 @@ static int intel_gen4_queue_flip(struct drm_device *=
dev,
 	pf =3D 0;
 	pipesrc =3D I915_READ(PIPESRC(intel_crtc->pipe)) & 0x0fff0fff;
 	OUT_RING(pf | pipesrc);
+
+	intel_mark_page_flip_active(intel_crtc);
+
+	intel_mark_page_flip_active(intel_crtc);
 	ADVANCE_LP_RING();
 	return 0;
=20
@@ -7242,6 +7247,8 @@ static int intel_gen7_queue_flip(struct drm_device *d=
ev,
 	intel_ring_emit(ring, (fb->pitch | obj->tiling_mode));
 	intel_ring_emit(ring, (obj->gtt_offset));
 	intel_ring_emit(ring, (MI_NOOP));
+
+	intel_mark_page_flip_active(intel_crtc);
 	intel_ring_advance(ring);
 	return 0;
=20
diff --git a/drivers/gpu/drm/i915/intel_drv.h b/drivers/gpu/drm/i915/intel_=
drv.h
index bcadf74..5212284 100644
--- a/drivers/gpu/drm/i915/intel_drv.h
+++ b/drivers/gpu/drm/i915/intel_drv.h
@@ -257,7 +257,10 @@ struct intel_unpin_work {
 	struct drm_i915_gem_object *old_fb_obj;
 	struct drm_i915_gem_object *pending_flip_obj;
 	struct drm_pending_vblank_event *event;
-	int pending;
+	atomic_t pending;
+#define INTEL_FLIP_INACTIVE	0
+#define INTEL_FLIP_PENDING	1
+#define INTEL_FLIP_COMPLETE	2
 	bool enable_stall_check;
 };
=20
diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel=
_lvds.c
index 57152a7..cf5ea3d 100644
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -779,6 +779,22 @@ static const struct dmi_system_id intel_no_lvds[] =3D =
{
 			DMI_MATCH(DMI_BOARD_NAME, "ZBOXSD-ID12/ID13"),
 		},
 	},
+	{
+		.callback =3D intel_no_lvds_dmi_callback,
+		.ident =3D "Gigabyte GA-D525TUD",
+		.matches =3D {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Gigabyte Technology Co., Ltd."),
+			DMI_MATCH(DMI_BOARD_NAME, "D525TUD"),
+		},
+	},
+	{
+		.callback =3D intel_no_lvds_dmi_callback,
+		.ident =3D "Supermicro X7SPA-H",
+		.matches =3D {
+			DMI_MATCH(DMI_SYS_VENDOR, "Supermicro"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "X7SPA-H"),
+		},
+	},
=20
 	{ }	/* terminating entry */
 };
diff --git a/drivers/gpu/drm/radeon/atombios_crtc.c b/drivers/gpu/drm/radeo=
n/atombios_crtc.c
index a4011b0..a25d08a 100644
--- a/drivers/gpu/drm/radeon/atombios_crtc.c
+++ b/drivers/gpu/drm/radeon/atombios_crtc.c
@@ -541,6 +541,11 @@ static u32 atombios_adjust_pll(struct drm_crtc *crtc,
=20
 		if (rdev->family < CHIP_RV770)
 			pll->flags |=3D RADEON_PLL_PREFER_MINM_OVER_MAXP;
+		/* use frac fb div on APUs */
+		if (ASIC_IS_DCE41(rdev))
+			pll->flags |=3D RADEON_PLL_USE_FRAC_FB_DIV;
+		if (ASIC_IS_DCE32(rdev) && mode->clock > 165000)
+			pll->flags |=3D RADEON_PLL_USE_FRAC_FB_DIV;
 	} else {
 		pll->flags |=3D RADEON_PLL_LEGACY;
=20
diff --git a/drivers/gpu/drm/radeon/atombios_encoders.c b/drivers/gpu/drm/r=
adeon/atombios_encoders.c
index aca4755..f0dc04b 100644
--- a/drivers/gpu/drm/radeon/atombios_encoders.c
+++ b/drivers/gpu/drm/radeon/atombios_encoders.c
@@ -111,7 +111,7 @@ static bool radeon_atom_mode_fixup(struct drm_encoder *=
encoder,
 	    ((radeon_encoder->active_device & (ATOM_DEVICE_DFP_SUPPORT | ATOM_DEV=
ICE_LCD_SUPPORT)) ||
 	     (radeon_encoder_get_dp_bridge_encoder_id(encoder) !=3D ENCODER_OBJEC=
T_ID_NONE))) {
 		struct drm_connector *connector =3D radeon_get_connector_for_encoder(enc=
oder);
-		radeon_dp_set_link_config(connector, mode);
+		radeon_dp_set_link_config(connector, adjusted_mode);
 	}
=20
 	return true;
diff --git a/drivers/gpu/drm/radeon/evergreen.c b/drivers/gpu/drm/radeon/ev=
ergreen.c
index b919b11..0977849 100644
--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -1730,7 +1730,7 @@ static void evergreen_gpu_init(struct radeon_device *=
rdev)
 	case CHIP_SUMO:
 		rdev->config.evergreen.num_ses =3D 1;
 		rdev->config.evergreen.max_pipes =3D 4;
-		rdev->config.evergreen.max_tile_pipes =3D 2;
+		rdev->config.evergreen.max_tile_pipes =3D 4;
 		if (rdev->pdev->device =3D=3D 0x9648)
 			rdev->config.evergreen.max_simds =3D 3;
 		else if ((rdev->pdev->device =3D=3D 0x9647) ||
@@ -1819,7 +1819,7 @@ static void evergreen_gpu_init(struct radeon_device *=
rdev)
 		break;
 	case CHIP_CAICOS:
 		rdev->config.evergreen.num_ses =3D 1;
-		rdev->config.evergreen.max_pipes =3D 4;
+		rdev->config.evergreen.max_pipes =3D 2;
 		rdev->config.evergreen.max_tile_pipes =3D 2;
 		rdev->config.evergreen.max_simds =3D 2;
 		rdev->config.evergreen.max_backends =3D 1 * rdev->config.evergreen.num_s=
es;
diff --git a/drivers/hid/hid-apple.c b/drivers/hid/hid-apple.c
index 899c712..2da7335 100644
--- a/drivers/hid/hid-apple.c
+++ b/drivers/hid/hid-apple.c
@@ -458,6 +458,9 @@ static const struct hid_device_id apple_devices[] =3D {
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIREL=
ESS_2011_ISO),
 		.driver_data =3D APPLE_NUMLOCK_EMULATION | APPLE_HAS_FN |
 			APPLE_ISO_KEYBOARD },
+	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE,
+				USB_DEVICE_ID_APPLE_ALU_WIRELESS_2011_ANSI),
+		.driver_data =3D APPLE_NUMLOCK_EMULATION | APPLE_HAS_FN },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIREL=
ESS_JIS),
 		.driver_data =3D APPLE_NUMLOCK_EMULATION | APPLE_HAS_FN },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING_ANSI=
),
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index a21e763..279b863 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1386,6 +1386,7 @@ static const struct hid_device_id hid_have_special_dr=
iver[] =3D {
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIREL=
ESS_2009_ANSI) },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIREL=
ESS_2009_ISO) },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIREL=
ESS_2009_JIS) },
+	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIREL=
ESS_2011_ANSI) },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIREL=
ESS_2011_ISO) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_FOUNTAIN_TP_ONL=
Y) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER1_TP_ONLY=
) },
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 652f230..2d41336 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -131,6 +131,7 @@
 #define USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_ANSI  0x0239
 #define USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_ISO   0x023a
 #define USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_JIS   0x023b
+#define USB_DEVICE_ID_APPLE_ALU_WIRELESS_2011_ANSI  0x0255
 #define USB_DEVICE_ID_APPLE_ALU_WIRELESS_2011_ISO   0x0256
 #define USB_DEVICE_ID_APPLE_FOUNTAIN_TP_ONLY	0x030a
 #define USB_DEVICE_ID_APPLE_GEYSER1_TP_ONLY	0x030b
diff --git a/drivers/hid/hid-magicmouse.c b/drivers/hid/hid-magicmouse.c
index 2ab7175..7cf3ffe 100644
--- a/drivers/hid/hid-magicmouse.c
+++ b/drivers/hid/hid-magicmouse.c
@@ -418,6 +418,8 @@ static void magicmouse_setup_input(struct input_dev *in=
put, struct hid_device *h
 		__set_bit(BTN_TOOL_TRIPLETAP, input->keybit);
 		__set_bit(BTN_TOOL_QUADTAP, input->keybit);
 		__set_bit(BTN_TOUCH, input->keybit);
+		__set_bit(INPUT_PROP_POINTER, input->propbit);
+		__set_bit(INPUT_PROP_BUTTONPAD, input->propbit);
 	}
=20
 	if (report_touches) {
diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
index 19b4412..3d630bb 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -190,6 +190,27 @@ static ssize_t show_temp(struct device *dev,
 	return tdata->valid ? sprintf(buf, "%d\n", tdata->temp) : -EAGAIN;
 }
=20
+struct tjmax {
+	char const *id;
+	int tjmax;
+};
+
+static struct tjmax __cpuinitconst tjmax_table[] =3D {
+	{ "CPU D410", 100000 },
+	{ "CPU D425", 100000 },
+	{ "CPU D510", 100000 },
+	{ "CPU D525", 100000 },
+	{ "CPU N450", 100000 },
+	{ "CPU N455", 100000 },
+	{ "CPU N470", 100000 },
+	{ "CPU N475", 100000 },
+	{ "CPU  230", 100000 },		/* Model 0x1c, stepping 2	*/
+	{ "CPU  330", 125000 },		/* Model 0x1c, stepping 2	*/
+	{ "CPU CE4110", 110000 },	/* Model 0x1c, stepping 10	*/
+	{ "CPU CE4150", 110000 },	/* Model 0x1c, stepping 10	*/
+	{ "CPU CE4170", 110000 },	/* Model 0x1c, stepping 10	*/
+};
+
 static int adjust_tjmax(struct cpuinfo_x86 *c, u32 id, struct device *dev)
 {
 	/* The 100C is default for both mobile and non mobile CPUs */
@@ -200,6 +221,13 @@ static int adjust_tjmax(struct cpuinfo_x86 *c, u32 id,=
 struct device *dev)
 	int err;
 	u32 eax, edx;
 	struct pci_dev *host_bridge;
+	int i;
+
+	/* explicit tjmax table entries override heuristics */
+	for (i =3D 0; i < ARRAY_SIZE(tjmax_table); i++) {
+		if (strstr(c->x86_model_id, tjmax_table[i].id))
+			return tjmax_table[i].tjmax;
+	}
=20
 	/* Early chips have no MSR for TjMax */
=20
@@ -208,7 +236,8 @@ static int adjust_tjmax(struct cpuinfo_x86 *c, u32 id, =
struct device *dev)
=20
 	/* Atom CPUs */
=20
-	if (c->x86_model =3D=3D 0x1c) {
+	if (c->x86_model =3D=3D 0x1c || c->x86_model =3D=3D 0x26
+	    || c->x86_model =3D=3D 0x27) {
 		usemsr_ee =3D 0;
=20
 		host_bridge =3D pci_get_bus_and_slot(0, PCI_DEVFN(0, 0));
@@ -221,6 +250,9 @@ static int adjust_tjmax(struct cpuinfo_x86 *c, u32 id, =
struct device *dev)
 			tjmax =3D 90000;
=20
 		pci_dev_put(host_bridge);
+	} else if (c->x86_model =3D=3D 0x36) {
+		usemsr_ee =3D 0;
+		tjmax =3D 100000;
 	}
=20
 	if (c->x86_model > 0xe && usemsr_ee) {
diff --git a/drivers/hwmon/fam15h_power.c b/drivers/hwmon/fam15h_power.c
index ac2d6cb..770e959 100644
--- a/drivers/hwmon/fam15h_power.c
+++ b/drivers/hwmon/fam15h_power.c
@@ -31,6 +31,9 @@ MODULE_DESCRIPTION("AMD Family 15h CPU processor power mo=
nitor");
 MODULE_AUTHOR("Andreas Herrmann <andreas.herrmann3@amd.com>");
 MODULE_LICENSE("GPL");
=20
+/* Family 16h Northbridge's function 4 PCI ID */
+#define PCI_DEVICE_ID_AMD_16H_NB_F4	0x1534
+
 /* D18F3 */
 #define REG_NORTHBRIDGE_CAP		0xe8
=20
@@ -256,6 +259,7 @@ static void __devexit fam15h_power_remove(struct pci_de=
v *pdev)
=20
 static DEFINE_PCI_DEVICE_TABLE(fam15h_power_id_table) =3D {
 	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_15H_NB_F4) },
+	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_16H_NB_F4) },
 	{}
 };
 MODULE_DEVICE_TABLE(pci, fam15h_power_id_table);
diff --git a/drivers/input/joystick/walkera0701.c b/drivers/input/joystick/=
walkera0701.c
index 4dfa1ee..f8f892b 100644
--- a/drivers/input/joystick/walkera0701.c
+++ b/drivers/input/joystick/walkera0701.c
@@ -196,6 +196,7 @@ static void walkera0701_close(struct input_dev *dev)
 	struct walkera_dev *w =3D input_get_drvdata(dev);
=20
 	parport_disable_irq(w->parport);
+	hrtimer_cancel(&w->timer);
 }
=20
 static int walkera0701_connect(struct walkera_dev *w, int parport)
@@ -224,6 +225,9 @@ static int walkera0701_connect(struct walkera_dev *w, i=
nt parport)
 	if (parport_claim(w->pardevice))
 		goto init_err1;
=20
+	hrtimer_init(&w->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	w->timer.function =3D timer_handler;
+
 	w->input_dev =3D input_allocate_device();
 	if (!w->input_dev)
 		goto init_err2;
@@ -254,8 +258,6 @@ static int walkera0701_connect(struct walkera_dev *w, i=
nt parport)
 	if (err)
 		goto init_err3;
=20
-	hrtimer_init(&w->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
-	w->timer.function =3D timer_handler;
 	return 0;
=20
  init_err3:
@@ -271,7 +273,6 @@ static int walkera0701_connect(struct walkera_dev *w, i=
nt parport)
=20
 static void walkera0701_disconnect(struct walkera_dev *w)
 {
-	hrtimer_cancel(&w->timer);
 	input_unregister_device(w->input_dev);
 	parport_release(w->pardevice);
 	parport_unregister_device(w->pardevice);
diff --git a/drivers/input/serio/i8042-x86ia64io.h b/drivers/input/serio/i8=
042-x86ia64io.h
index cd1a843..031270c 100644
--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -914,6 +914,7 @@ static int __init i8042_platform_init(void)
 	int retval;
=20
 #ifdef CONFIG_X86
+	u8 a20_on =3D 0xdf;
 	/* Just return if pre-detection shows no i8042 controller exist */
 	if (!x86_platform.i8042_detect())
 		return -ENODEV;
@@ -953,6 +954,14 @@ static int __init i8042_platform_init(void)
=20
 	if (dmi_check_system(i8042_dmi_dritek_table))
 		i8042_dritek =3D true;
+
+	/*
+	 * A20 was already enabled during early kernel init. But some buggy
+	 * BIOSes (in MSI Laptops) require A20 to be enabled using 8042 to
+	 * resume from S3. So we do it here and hope that nothing breaks.
+	 */
+	i8042_command(&a20_on, 0x10d1);
+	i8042_command(NULL, 0x00ff);	/* Null command for SMM firmware */
 #endif /* CONFIG_X86 */
=20
 	return retval;
diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index b9062c0..9a6cc92 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -1801,10 +1801,17 @@ static int __domain_mapping(struct dmar_domain *dom=
ain, unsigned long iov_pfn,
 			if (!pte)
 				return -ENOMEM;
 			/* It is large page*/
-			if (largepage_lvl > 1)
+			if (largepage_lvl > 1) {
 				pteval |=3D DMA_PTE_LARGE_PAGE;
-			else
+				/* Ensure that old small page tables are removed to make room
+				   for superpage, if they exist. */
+				dma_pte_clear_range(domain, iov_pfn,
+						    iov_pfn + lvl_to_nr_pages(largepage_lvl) - 1);
+				dma_pte_free_pagetable(domain, iov_pfn,
+						       iov_pfn + lvl_to_nr_pages(largepage_lvl) - 1);
+			} else {
 				pteval &=3D ~(uint64_t)DMA_PTE_LARGE_PAGE;
+			}
=20
 		}
 		/* We don't need lock here, nobody else
diff --git a/drivers/leds/leds-lp5521.c b/drivers/leds/leds-lp5521.c
index cb641f1..bf5cfd7 100644
--- a/drivers/leds/leds-lp5521.c
+++ b/drivers/leds/leds-lp5521.c
@@ -198,9 +198,14 @@ static int lp5521_load_program(struct lp5521_engine *e=
ng, const u8 *pattern)
=20
 	/* move current engine to direct mode and remember the state */
 	ret =3D lp5521_set_engine_mode(eng, LP5521_CMD_DIRECT);
+	if (ret)
+		return ret;
+
 	/* Mode change requires min 500 us delay. 1 - 2 ms  with margin */
 	usleep_range(1000, 2000);
-	ret |=3D lp5521_read(client, LP5521_REG_OP_MODE, &mode);
+	ret =3D lp5521_read(client, LP5521_REG_OP_MODE, &mode);
+	if (ret)
+		return ret;
=20
 	/* For loading, all the engines to load mode */
 	lp5521_write(client, LP5521_REG_OP_MODE, LP5521_CMD_DIRECT);
@@ -216,8 +221,7 @@ static int lp5521_load_program(struct lp5521_engine *en=
g, const u8 *pattern)
 				LP5521_PROG_MEM_SIZE,
 				pattern);
=20
-	ret |=3D lp5521_write(client, LP5521_REG_OP_MODE, mode);
-	return ret;
+	return lp5521_write(client, LP5521_REG_OP_MODE, mode);
 }
=20
 static int lp5521_set_led_current(struct lp5521_chip *chip, int led, u8 cu=
rr)
@@ -692,9 +696,9 @@ static int __devinit lp5521_probe(struct i2c_client *cl=
ient,
 	 * otherwise further access to the R G B channels in the
 	 * LP5521_REG_ENABLE register will not have any effect - strange!
 	 */
-	lp5521_read(client, LP5521_REG_R_CURRENT, &buf);
-	if (buf !=3D LP5521_REG_R_CURR_DEFAULT) {
-		dev_err(&client->dev, "error in reseting chip\n");
+	ret =3D lp5521_read(client, LP5521_REG_R_CURRENT, &buf);
+	if (ret || buf !=3D LP5521_REG_R_CURR_DEFAULT) {
+		dev_err(&client->dev, "error in resetting chip\n");
 		goto fail2;
 	}
 	usleep_range(10000, 20000);
diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 1ce84ed..42c873f 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1562,6 +1562,14 @@ static int copy_params(struct dm_ioctl __user *user,=
 struct dm_ioctl **param)
 	if (copy_from_user(dmi, user, tmp.data_size))
 		goto bad;
=20
+	/*
+	 * Abort if something changed the ioctl data while it was being copied.
+	 */
+	if (dmi->data_size !=3D tmp.data_size) {
+		DMERR("rejecting ioctl: data size modified while processing parameters")=
;
+		goto bad;
+	}
+
 	/* Wipe the user buffer so we do not return it to userspace */
 	if (secure_data && clear_user(user, tmp.data_size))
 		goto bad;
diff --git a/drivers/md/persistent-data/dm-btree-internal.h b/drivers/md/pe=
rsistent-data/dm-btree-internal.h
index d279c76..acba54e 100644
--- a/drivers/md/persistent-data/dm-btree-internal.h
+++ b/drivers/md/persistent-data/dm-btree-internal.h
@@ -36,13 +36,13 @@ struct node_header {
 	__le32 padding;
 } __packed;
=20
-struct node {
+struct btree_node {
 	struct node_header header;
 	__le64 keys[0];
 } __packed;
=20

-void inc_children(struct dm_transaction_manager *tm, struct node *n,
+void inc_children(struct dm_transaction_manager *tm, struct btree_node *n,
 		  struct dm_btree_value_type *vt);
=20
 int new_block(struct dm_btree_info *info, struct dm_block **result);
@@ -64,7 +64,7 @@ struct ro_spine {
 void init_ro_spine(struct ro_spine *s, struct dm_btree_info *info);
 int exit_ro_spine(struct ro_spine *s);
 int ro_step(struct ro_spine *s, dm_block_t new_child);
-struct node *ro_node(struct ro_spine *s);
+struct btree_node *ro_node(struct ro_spine *s);
=20
 struct shadow_spine {
 	struct dm_btree_info *info;
@@ -98,12 +98,12 @@ int shadow_root(struct shadow_spine *s);
 /*
  * Some inlines.
  */
-static inline __le64 *key_ptr(struct node *n, uint32_t index)
+static inline __le64 *key_ptr(struct btree_node *n, uint32_t index)
 {
 	return n->keys + index;
 }
=20
-static inline void *value_base(struct node *n)
+static inline void *value_base(struct btree_node *n)
 {
 	return &n->keys[le32_to_cpu(n->header.max_entries)];
 }
@@ -111,7 +111,7 @@ static inline void *value_base(struct node *n)
 /*
  * FIXME: Now that value size is stored in node we don't need the third pa=
rm.
  */
-static inline void *value_ptr(struct node *n, uint32_t index, size_t value=
_size)
+static inline void *value_ptr(struct btree_node *n, uint32_t index, size_t=
 value_size)
 {
 	BUG_ON(value_size !=3D le32_to_cpu(n->header.value_size));
 	return value_base(n) + (value_size * index);
@@ -120,7 +120,7 @@ static inline void *value_ptr(struct node *n, uint32_t =
index, size_t value_size)
 /*
  * Assumes the values are suitably-aligned and converts to core format.
  */
-static inline uint64_t value64(struct node *n, uint32_t index)
+static inline uint64_t value64(struct btree_node *n, uint32_t index)
 {
 	__le64 *values_le =3D value_base(n);
=20
@@ -130,7 +130,7 @@ static inline uint64_t value64(struct node *n, uint32_t=
 index)
 /*
  * Searching for a key within a single node.
  */
-int lower_bound(struct node *n, uint64_t key);
+int lower_bound(struct btree_node *n, uint64_t key);
=20
 extern struct dm_block_validator btree_node_validator;
=20
diff --git a/drivers/md/persistent-data/dm-btree-remove.c b/drivers/md/pers=
istent-data/dm-btree-remove.c
index 1a35caf..e6cdfde 100644
--- a/drivers/md/persistent-data/dm-btree-remove.c
+++ b/drivers/md/persistent-data/dm-btree-remove.c
@@ -53,7 +53,7 @@
 /*
  * Some little utilities for moving node data around.
  */
-static void node_shift(struct node *n, int shift)
+static void node_shift(struct btree_node *n, int shift)
 {
 	uint32_t nr_entries =3D le32_to_cpu(n->header.nr_entries);
 	uint32_t value_size =3D le32_to_cpu(n->header.value_size);
@@ -79,7 +79,7 @@ static void node_shift(struct node *n, int shift)
 	}
 }
=20
-static void node_copy(struct node *left, struct node *right, int shift)
+static void node_copy(struct btree_node *left, struct btree_node *right, i=
nt shift)
 {
 	uint32_t nr_left =3D le32_to_cpu(left->header.nr_entries);
 	uint32_t value_size =3D le32_to_cpu(left->header.value_size);
@@ -108,7 +108,7 @@ static void node_copy(struct node *left, struct node *r=
ight, int shift)
 /*
  * Delete a specific entry from a leaf node.
  */
-static void delete_at(struct node *n, unsigned index)
+static void delete_at(struct btree_node *n, unsigned index)
 {
 	unsigned nr_entries =3D le32_to_cpu(n->header.nr_entries);
 	unsigned nr_to_copy =3D nr_entries - (index + 1);
@@ -128,7 +128,7 @@ static void delete_at(struct node *n, unsigned index)
 	n->header.nr_entries =3D cpu_to_le32(nr_entries - 1);
 }
=20
-static unsigned merge_threshold(struct node *n)
+static unsigned merge_threshold(struct btree_node *n)
 {
 	return le32_to_cpu(n->header.max_entries) / 3;
 }
@@ -136,7 +136,7 @@ static unsigned merge_threshold(struct node *n)
 struct child {
 	unsigned index;
 	struct dm_block *block;
-	struct node *n;
+	struct btree_node *n;
 };
=20
 static struct dm_btree_value_type le64_type =3D {
@@ -147,7 +147,7 @@ static struct dm_btree_value_type le64_type =3D {
 	.equal =3D NULL
 };
=20
-static int init_child(struct dm_btree_info *info, struct node *parent,
+static int init_child(struct dm_btree_info *info, struct btree_node *paren=
t,
 		      unsigned index, struct child *result)
 {
 	int r, inc;
@@ -177,7 +177,7 @@ static int exit_child(struct dm_btree_info *info, struc=
t child *c)
 	return dm_tm_unlock(info->tm, c->block);
 }
=20
-static void shift(struct node *left, struct node *right, int count)
+static void shift(struct btree_node *left, struct btree_node *right, int c=
ount)
 {
 	uint32_t nr_left =3D le32_to_cpu(left->header.nr_entries);
 	uint32_t nr_right =3D le32_to_cpu(right->header.nr_entries);
@@ -203,11 +203,11 @@ static void shift(struct node *left, struct node *rig=
ht, int count)
 	right->header.nr_entries =3D cpu_to_le32(nr_right + count);
 }
=20
-static void __rebalance2(struct dm_btree_info *info, struct node *parent,
+static void __rebalance2(struct dm_btree_info *info, struct btree_node *pa=
rent,
 			 struct child *l, struct child *r)
 {
-	struct node *left =3D l->n;
-	struct node *right =3D r->n;
+	struct btree_node *left =3D l->n;
+	struct btree_node *right =3D r->n;
 	uint32_t nr_left =3D le32_to_cpu(left->header.nr_entries);
 	uint32_t nr_right =3D le32_to_cpu(right->header.nr_entries);
 	unsigned threshold =3D 2 * merge_threshold(left) + 1;
@@ -239,7 +239,7 @@ static int rebalance2(struct shadow_spine *s, struct dm=
_btree_info *info,
 		      unsigned left_index)
 {
 	int r;
-	struct node *parent;
+	struct btree_node *parent;
 	struct child left, right;
=20
 	parent =3D dm_block_data(shadow_current(s));
@@ -270,9 +270,9 @@ static int rebalance2(struct shadow_spine *s, struct dm=
_btree_info *info,
  * in right, then rebalance2.  This wastes some cpu, but I want something
  * simple atm.
  */
-static void delete_center_node(struct dm_btree_info *info, struct node *pa=
rent,
+static void delete_center_node(struct dm_btree_info *info, struct btree_no=
de *parent,
 			       struct child *l, struct child *c, struct child *r,
-			       struct node *left, struct node *center, struct node *right,
+			       struct btree_node *left, struct btree_node *center, struct btree=
_node *right,
 			       uint32_t nr_left, uint32_t nr_center, uint32_t nr_right)
 {
 	uint32_t max_entries =3D le32_to_cpu(left->header.max_entries);
@@ -301,9 +301,9 @@ static void delete_center_node(struct dm_btree_info *in=
fo, struct node *parent,
 /*
  * Redistributes entries among 3 sibling nodes.
  */
-static void redistribute3(struct dm_btree_info *info, struct node *parent,
+static void redistribute3(struct dm_btree_info *info, struct btree_node *p=
arent,
 			  struct child *l, struct child *c, struct child *r,
-			  struct node *left, struct node *center, struct node *right,
+			  struct btree_node *left, struct btree_node *center, struct btree_node=
 *right,
 			  uint32_t nr_left, uint32_t nr_center, uint32_t nr_right)
 {
 	int s;
@@ -343,12 +343,12 @@ static void redistribute3(struct dm_btree_info *info,=
 struct node *parent,
 	*key_ptr(parent, r->index) =3D right->keys[0];
 }
=20
-static void __rebalance3(struct dm_btree_info *info, struct node *parent,
+static void __rebalance3(struct dm_btree_info *info, struct btree_node *pa=
rent,
 			 struct child *l, struct child *c, struct child *r)
 {
-	struct node *left =3D l->n;
-	struct node *center =3D c->n;
-	struct node *right =3D r->n;
+	struct btree_node *left =3D l->n;
+	struct btree_node *center =3D c->n;
+	struct btree_node *right =3D r->n;
=20
 	uint32_t nr_left =3D le32_to_cpu(left->header.nr_entries);
 	uint32_t nr_center =3D le32_to_cpu(center->header.nr_entries);
@@ -371,7 +371,7 @@ static int rebalance3(struct shadow_spine *s, struct dm=
_btree_info *info,
 		      unsigned left_index)
 {
 	int r;
-	struct node *parent =3D dm_block_data(shadow_current(s));
+	struct btree_node *parent =3D dm_block_data(shadow_current(s));
 	struct child left, center, right;
=20
 	/*
@@ -421,7 +421,7 @@ static int get_nr_entries(struct dm_transaction_manager=
 *tm,
 {
 	int r;
 	struct dm_block *block;
-	struct node *n;
+	struct btree_node *n;
=20
 	r =3D dm_tm_read_lock(tm, b, &btree_node_validator, &block);
 	if (r)
@@ -438,7 +438,7 @@ static int rebalance_children(struct shadow_spine *s,
 {
 	int i, r, has_left_sibling, has_right_sibling;
 	uint32_t child_entries;
-	struct node *n;
+	struct btree_node *n;
=20
 	n =3D dm_block_data(shadow_current(s));
=20
@@ -483,7 +483,7 @@ static int rebalance_children(struct shadow_spine *s,
 	return r;
 }
=20
-static int do_leaf(struct node *n, uint64_t key, unsigned *index)
+static int do_leaf(struct btree_node *n, uint64_t key, unsigned *index)
 {
 	int i =3D lower_bound(n, key);
=20
@@ -506,7 +506,7 @@ static int remove_raw(struct shadow_spine *s, struct dm=
_btree_info *info,
 		      uint64_t key, unsigned *index)
 {
 	int i =3D *index, r;
-	struct node *n;
+	struct btree_node *n;
=20
 	for (;;) {
 		r =3D shadow_step(s, root, vt);
@@ -556,7 +556,7 @@ int dm_btree_remove(struct dm_btree_info *info, dm_bloc=
k_t root,
 	unsigned level, last_level =3D info->levels - 1;
 	int index =3D 0, r =3D 0;
 	struct shadow_spine spine;
-	struct node *n;
+	struct btree_node *n;
=20
 	init_shadow_spine(&spine, info);
 	for (level =3D 0; level < info->levels; level++) {
diff --git a/drivers/md/persistent-data/dm-btree-spine.c b/drivers/md/persi=
stent-data/dm-btree-spine.c
index d9a7912..2f0805c 100644
--- a/drivers/md/persistent-data/dm-btree-spine.c
+++ b/drivers/md/persistent-data/dm-btree-spine.c
@@ -23,7 +23,7 @@ static void node_prepare_for_write(struct dm_block_valida=
tor *v,
 				   struct dm_block *b,
 				   size_t block_size)
 {
-	struct node *n =3D dm_block_data(b);
+	struct btree_node *n =3D dm_block_data(b);
 	struct node_header *h =3D &n->header;
=20
 	h->blocknr =3D cpu_to_le64(dm_block_location(b));
@@ -38,7 +38,7 @@ static int node_check(struct dm_block_validator *v,
 		      struct dm_block *b,
 		      size_t block_size)
 {
-	struct node *n =3D dm_block_data(b);
+	struct btree_node *n =3D dm_block_data(b);
 	struct node_header *h =3D &n->header;
 	size_t value_size;
 	__le32 csum_disk;
@@ -164,7 +164,7 @@ int ro_step(struct ro_spine *s, dm_block_t new_child)
 	return r;
 }
=20
-struct node *ro_node(struct ro_spine *s)
+struct btree_node *ro_node(struct ro_spine *s)
 {
 	struct dm_block *block;
=20
diff --git a/drivers/md/persistent-data/dm-btree.c b/drivers/md/persistent-=
data/dm-btree.c
index bd1e7ff..bbb2ec5 100644
--- a/drivers/md/persistent-data/dm-btree.c
+++ b/drivers/md/persistent-data/dm-btree.c
@@ -38,7 +38,7 @@ static void array_insert(void *base, size_t elt_size, uns=
igned nr_elts,
 /*----------------------------------------------------------------*/
=20
 /* makes the assumption that no two keys are the same. */
-static int bsearch(struct node *n, uint64_t key, int want_hi)
+static int bsearch(struct btree_node *n, uint64_t key, int want_hi)
 {
 	int lo =3D -1, hi =3D le32_to_cpu(n->header.nr_entries);
=20
@@ -58,12 +58,12 @@ static int bsearch(struct node *n, uint64_t key, int wa=
nt_hi)
 	return want_hi ? hi : lo;
 }
=20
-int lower_bound(struct node *n, uint64_t key)
+int lower_bound(struct btree_node *n, uint64_t key)
 {
 	return bsearch(n, key, 0);
 }
=20
-void inc_children(struct dm_transaction_manager *tm, struct node *n,
+void inc_children(struct dm_transaction_manager *tm, struct btree_node *n,
 		  struct dm_btree_value_type *vt)
 {
 	unsigned i;
@@ -78,7 +78,7 @@ void inc_children(struct dm_transaction_manager *tm, stru=
ct node *n,
 				value_ptr(n, i, vt->size));
 }
=20
-static int insert_at(size_t value_size, struct node *node, unsigned index,
+static int insert_at(size_t value_size, struct btree_node *node, unsigned =
index,
 		      uint64_t key, void *value)
 		      __dm_written_to_disk(value)
 {
@@ -123,7 +123,7 @@ int dm_btree_empty(struct dm_btree_info *info, dm_block=
_t *root)
 {
 	int r;
 	struct dm_block *b;
-	struct node *n;
+	struct btree_node *n;
 	size_t block_size;
 	uint32_t max_entries;
=20
@@ -155,7 +155,7 @@ EXPORT_SYMBOL_GPL(dm_btree_empty);
 #define MAX_SPINE_DEPTH 64
 struct frame {
 	struct dm_block *b;
-	struct node *n;
+	struct btree_node *n;
 	unsigned level;
 	unsigned nr_children;
 	unsigned current_child;
@@ -296,7 +296,7 @@ EXPORT_SYMBOL_GPL(dm_btree_del);
 /*----------------------------------------------------------------*/
=20
 static int btree_lookup_raw(struct ro_spine *s, dm_block_t block, uint64_t=
 key,
-			    int (*search_fn)(struct node *, uint64_t),
+			    int (*search_fn)(struct btree_node *, uint64_t),
 			    uint64_t *result_key, void *v, size_t value_size)
 {
 	int i, r;
@@ -407,7 +407,7 @@ static int btree_split_sibling(struct shadow_spine *s, =
dm_block_t root,
 	size_t size;
 	unsigned nr_left, nr_right;
 	struct dm_block *left, *right, *parent;
-	struct node *ln, *rn, *pn;
+	struct btree_node *ln, *rn, *pn;
 	__le64 location;
=20
 	left =3D shadow_current(s);
@@ -492,7 +492,7 @@ static int btree_split_beneath(struct shadow_spine *s, =
uint64_t key)
 	size_t size;
 	unsigned nr_left, nr_right;
 	struct dm_block *left, *right, *new_parent;
-	struct node *pn, *ln, *rn;
+	struct btree_node *pn, *ln, *rn;
 	__le64 val;
=20
 	new_parent =3D shadow_current(s);
@@ -577,7 +577,7 @@ static int btree_insert_raw(struct shadow_spine *s, dm_=
block_t root,
 			    uint64_t key, unsigned *index)
 {
 	int r, i =3D *index, top =3D 1;
-	struct node *node;
+	struct btree_node *node;
=20
 	for (;;) {
 		r =3D shadow_step(s, root, vt);
@@ -644,7 +644,7 @@ static int insert(struct dm_btree_info *info, dm_block_=
t root,
 	unsigned level, index =3D -1, last_level =3D info->levels - 1;
 	dm_block_t block =3D root;
 	struct shadow_spine spine;
-	struct node *n;
+	struct btree_node *n;
 	struct dm_btree_value_type le64_type;
=20
 	le64_type.context =3D NULL;
diff --git a/drivers/mfd/mfd-core.c b/drivers/mfd/mfd-core.c
index 411f523..6dad2ef 100644
--- a/drivers/mfd/mfd-core.c
+++ b/drivers/mfd/mfd-core.c
@@ -19,6 +19,10 @@
 #include <linux/slab.h>
 #include <linux/module.h>
=20
+static struct device_type mfd_dev_type =3D {
+	.name	=3D "mfd_device",
+};
+
 int mfd_cell_enable(struct platform_device *pdev)
 {
 	const struct mfd_cell *cell =3D mfd_get_cell(pdev);
@@ -88,6 +92,7 @@ static int mfd_add_device(struct device *parent, int id,
 		goto fail_device;
=20
 	pdev->dev.parent =3D parent;
+	pdev->dev.type =3D &mfd_dev_type;
=20
 	if (cell->pdata_size) {
 		ret =3D platform_device_add_data(pdev,
@@ -183,10 +188,16 @@ EXPORT_SYMBOL(mfd_add_devices);
=20
 static int mfd_remove_devices_fn(struct device *dev, void *c)
 {
-	struct platform_device *pdev =3D to_platform_device(dev);
-	const struct mfd_cell *cell =3D mfd_get_cell(pdev);
+	struct platform_device *pdev;
+	const struct mfd_cell *cell;
 	atomic_t **usage_count =3D c;
=20
+	if (dev->type !=3D &mfd_dev_type)
+		return 0;
+
+	pdev =3D to_platform_device(dev);
+	cell =3D mfd_get_cell(pdev);
+
 	/* find the base address of usage_count pointers (for freeing) */
 	if (!*usage_count || (cell->usage_count < *usage_count))
 		*usage_count =3D cell->usage_count;
diff --git a/drivers/misc/hpilo.c b/drivers/misc/hpilo.c
index fffc227..9c99680 100644
--- a/drivers/misc/hpilo.c
+++ b/drivers/misc/hpilo.c
@@ -735,7 +735,14 @@ static void ilo_remove(struct pci_dev *pdev)
 	free_irq(pdev->irq, ilo_hw);
 	ilo_unmap_device(pdev, ilo_hw);
 	pci_release_regions(pdev);
-	pci_disable_device(pdev);
+	/*
+	 * pci_disable_device(pdev) used to be here. But this PCI device has
+	 * two functions with interrupt lines connected to a single pin. The
+	 * other one is a USB host controller. So when we disable the PIN here
+	 * e.g. by rmmod hpilo, the controller stops working. It is because
+	 * the interrupt link is disabled in ACPI since it is not refcounted
+	 * yet. See acpi_pci_link_free_irq called from acpi_pci_irq_disable.
+	 */
 	kfree(ilo_hw);
 	ilo_hwdev[(minor / MAX_CCB)] =3D 0;
 }
@@ -820,7 +827,7 @@ unmap:
 free_regions:
 	pci_release_regions(pdev);
 disable:
-	pci_disable_device(pdev);
+/*	pci_disable_device(pdev);  see comment in ilo_remove */
 free:
 	kfree(ilo_hw);
 out:
diff --git a/drivers/misc/sgi-xp/xpc_main.c b/drivers/misc/sgi-xp/xpc_main.=
c
index 8d082b4..d971817 100644
--- a/drivers/misc/sgi-xp/xpc_main.c
+++ b/drivers/misc/sgi-xp/xpc_main.c
@@ -53,6 +53,10 @@
 #include <linux/kthread.h>
 #include "xpc.h"
=20
+#ifdef CONFIG_X86_64
+#include <asm/traps.h>
+#endif
+
 /* define two XPC debug device structures to be used with dev_dbg() et al =
*/
=20
 struct device_driver xpc_dbg_name =3D {
@@ -1079,6 +1083,9 @@ xpc_system_reboot(struct notifier_block *nb, unsigned=
 long event, void *unused)
 	return NOTIFY_DONE;
 }
=20
+/* Used to only allow one cpu to complete disconnect */
+static unsigned int xpc_die_disconnecting;
+
 /*
  * Notify other partitions to deactivate from us by first disengaging from=
 all
  * references to our memory.
@@ -1092,6 +1099,9 @@ xpc_die_deactivate(void)
 	long keep_waiting;
 	long wait_to_print;
=20
+	if (cmpxchg(&xpc_die_disconnecting, 0, 1))
+		return;
+
 	/* keep xpc_hb_checker thread from doing anything (just in case) */
 	xpc_exiting =3D 1;
=20
@@ -1159,7 +1169,7 @@ xpc_die_deactivate(void)
  * about the lack of a heartbeat.
  */
 static int
-xpc_system_die(struct notifier_block *nb, unsigned long event, void *unuse=
d)
+xpc_system_die(struct notifier_block *nb, unsigned long event, void *_die_=
args)
 {
 #ifdef CONFIG_IA64		/* !!! temporary kludge */
 	switch (event) {
@@ -1191,7 +1201,27 @@ xpc_system_die(struct notifier_block *nb, unsigned l=
ong event, void *unused)
 		break;
 	}
 #else
-	xpc_die_deactivate();
+	struct die_args *die_args =3D _die_args;
+
+	switch (event) {
+	case DIE_TRAP:
+		if (die_args->trapnr =3D=3D X86_TRAP_DF)
+			xpc_die_deactivate();
+
+		if (((die_args->trapnr =3D=3D X86_TRAP_MF) ||
+		     (die_args->trapnr =3D=3D X86_TRAP_XF)) &&
+		    !user_mode_vm(die_args->regs))
+			xpc_die_deactivate();
+
+		break;
+	case DIE_INT3:
+	case DIE_DEBUG:
+		break;
+	case DIE_OOPS:
+	case DIE_GPF:
+	default:
+		xpc_die_deactivate();
+	}
 #endif
=20
 	return NOTIFY_DONE;
diff --git a/drivers/mmc/host/sh_mmcif.c b/drivers/mmc/host/sh_mmcif.c
index 559d30d..d5505f3 100644
--- a/drivers/mmc/host/sh_mmcif.c
+++ b/drivers/mmc/host/sh_mmcif.c
@@ -1003,10 +1003,6 @@ static irqreturn_t sh_mmcif_intr(int irq, void *dev_=
id)
 		host->sd_error =3D true;
 		dev_dbg(&host->pd->dev, "int err state =3D %08x\n", state);
 	}
-	if (host->state =3D=3D STATE_IDLE) {
-		dev_info(&host->pd->dev, "Spurious IRQ status 0x%x", state);
-		return IRQ_HANDLED;
-	}
 	if (state & ~(INT_CMD12RBE | INT_CMD12CRE))
 		complete(&host->intr_wait);
 	else
diff --git a/drivers/mtd/nand/gpmi-nand/gpmi-lib.c b/drivers/mtd/nand/gpmi-=
nand/gpmi-lib.c
index bb2fe60..1d02ec9 100644
--- a/drivers/mtd/nand/gpmi-nand/gpmi-lib.c
+++ b/drivers/mtd/nand/gpmi-nand/gpmi-lib.c
@@ -135,6 +135,15 @@ int gpmi_init(struct gpmi_nand_data *this)
 	if (ret)
 		goto err_out;
=20
+	/*
+	 * Reset BCH here, too. We got failures otherwise :(
+	 * See later BCH reset for explanation of MX23 handling
+	 */
+	ret =3D gpmi_reset_block(r->bch_regs, GPMI_IS_MX23(this));
+	if (ret)
+		goto err_out;
+
+
 	/* Choose NAND mode. */
 	writel(BM_GPMI_CTRL1_GPMI_MODE, r->gpmi_regs + HW_GPMI_CTRL1_CLR);
=20
diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_mai=
n.c
index 6c284d1..202ae34 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1366,6 +1366,8 @@ static void bond_compute_features(struct bonding *bon=
d)
 	struct net_device *bond_dev =3D bond->dev;
 	u32 vlan_features =3D BOND_VLAN_FEATURES;
 	unsigned short max_hard_header_len =3D ETH_HLEN;
+	unsigned int gso_max_size =3D GSO_MAX_SIZE;
+	u16 gso_max_segs =3D GSO_MAX_SEGS;
 	int i;
=20
 	read_lock(&bond->lock);
@@ -1379,11 +1381,16 @@ static void bond_compute_features(struct bonding *b=
ond)
=20
 		if (slave->dev->hard_header_len > max_hard_header_len)
 			max_hard_header_len =3D slave->dev->hard_header_len;
+
+		gso_max_size =3D min(gso_max_size, slave->dev->gso_max_size);
+		gso_max_segs =3D min(gso_max_segs, slave->dev->gso_max_segs);
 	}
=20
 done:
 	bond_dev->vlan_features =3D vlan_features;
 	bond_dev->hard_header_len =3D max_hard_header_len;
+	bond_dev->gso_max_segs =3D gso_max_segs;
+	netif_set_gso_max_size(bond_dev, gso_max_size);
=20
 	read_unlock(&bond->lock);
=20
diff --git a/drivers/net/bonding/bond_sysfs.c b/drivers/net/bonding/bond_sy=
sfs.c
index 4ef7e2f..a03fde9 100644
--- a/drivers/net/bonding/bond_sysfs.c
+++ b/drivers/net/bonding/bond_sysfs.c
@@ -1579,6 +1579,7 @@ static ssize_t bonding_store_slaves_active(struct dev=
ice *d,
 		goto out;
 	}
=20
+	read_lock(&bond->lock);
 	bond_for_each_slave(bond, slave, i) {
 		if (!bond_is_active_slave(slave)) {
 			if (new_value)
@@ -1587,6 +1588,7 @@ static ssize_t bonding_store_slaves_active(struct dev=
ice *d,
 				slave->inactive =3D 1;
 		}
 	}
+	read_unlock(&bond->lock);
 out:
 	return ret;
 }
diff --git a/drivers/net/can/dev.c b/drivers/net/can/dev.c
index 25695bd..a319057 100644
--- a/drivers/net/can/dev.c
+++ b/drivers/net/can/dev.c
@@ -569,8 +569,7 @@ void close_candev(struct net_device *dev)
 {
 	struct can_priv *priv =3D netdev_priv(dev);
=20
-	if (del_timer_sync(&priv->restart_timer))
-		dev_put(dev);
+	del_timer_sync(&priv->restart_timer);
 	can_flush_echo_skb(dev);
 }
 EXPORT_SYMBOL_GPL(close_candev);
diff --git a/drivers/net/ethernet/8390/ne.c b/drivers/net/ethernet/8390/ne.=
c
index 1063093..e8ee2bc 100644
--- a/drivers/net/ethernet/8390/ne.c
+++ b/drivers/net/ethernet/8390/ne.c
@@ -814,6 +814,7 @@ static int __init ne_drv_probe(struct platform_device *=
pdev)
 		dev->irq =3D irq[this_dev];
 		dev->mem_end =3D bad[this_dev];
 	}
+	SET_NETDEV_DEV(dev, &pdev->dev);
 	err =3D do_ne_probe(dev);
 	if (err) {
 		free_netdev(dev);
diff --git a/drivers/net/irda/sir_dev.c b/drivers/net/irda/sir_dev.c
index 5039f08..43e9ab4 100644
--- a/drivers/net/irda/sir_dev.c
+++ b/drivers/net/irda/sir_dev.c
@@ -222,7 +222,7 @@ static void sirdev_config_fsm(struct work_struct *work)
 			break;
=20
 		case SIRDEV_STATE_DONGLE_SPEED:
-			if (dev->dongle_drv->reset) {
+			if (dev->dongle_drv->set_speed) {
 				ret =3D dev->dongle_drv->set_speed(dev, fsm->param);
 				if (ret < 0) {
 					fsm->result =3D ret;
diff --git a/drivers/net/usb/ipheth.c b/drivers/net/usb/ipheth.c
index 00ed9c1..ac53952 100644
--- a/drivers/net/usb/ipheth.c
+++ b/drivers/net/usb/ipheth.c
@@ -62,6 +62,7 @@
 #define USB_PRODUCT_IPAD 0x129a
 #define USB_PRODUCT_IPHONE_4_VZW 0x129c
 #define USB_PRODUCT_IPHONE_4S	0x12a0
+#define USB_PRODUCT_IPHONE_5	0x12a8
=20
 #define IPHETH_USBINTF_CLASS    255
 #define IPHETH_USBINTF_SUBCLASS 253
@@ -113,6 +114,10 @@ static struct usb_device_id ipheth_table[] =3D {
 		USB_VENDOR_APPLE, USB_PRODUCT_IPHONE_4S,
 		IPHETH_USBINTF_CLASS, IPHETH_USBINTF_SUBCLASS,
 		IPHETH_USBINTF_PROTO) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(
+		USB_VENDOR_APPLE, USB_PRODUCT_IPHONE_5,
+		IPHETH_USBINTF_CLASS, IPHETH_USBINTF_SUBCLASS,
+		IPHETH_USBINTF_PROTO) },
 	{ }
 };
 MODULE_DEVICE_TABLE(usb, ipheth_table);
diff --git a/drivers/net/wimax/i2400m/i2400m-usb.h b/drivers/net/wimax/i240=
0m/i2400m-usb.h
index 6650fde..9f1e947 100644
--- a/drivers/net/wimax/i2400m/i2400m-usb.h
+++ b/drivers/net/wimax/i2400m/i2400m-usb.h
@@ -152,6 +152,9 @@ enum {
 	/* Device IDs */
 	USB_DEVICE_ID_I6050 =3D 0x0186,
 	USB_DEVICE_ID_I6050_2 =3D 0x0188,
+	USB_DEVICE_ID_I6150 =3D 0x07d6,
+	USB_DEVICE_ID_I6150_2 =3D 0x07d7,
+	USB_DEVICE_ID_I6150_3 =3D 0x07d9,
 	USB_DEVICE_ID_I6250 =3D 0x0187,
 };
=20
diff --git a/drivers/net/wimax/i2400m/usb.c b/drivers/net/wimax/i2400m/usb.=
c
index 2c1b8b6..6bb7f3c 100644
--- a/drivers/net/wimax/i2400m/usb.c
+++ b/drivers/net/wimax/i2400m/usb.c
@@ -492,6 +492,9 @@ int i2400mu_probe(struct usb_interface *iface,
 	switch (id->idProduct) {
 	case USB_DEVICE_ID_I6050:
 	case USB_DEVICE_ID_I6050_2:
+	case USB_DEVICE_ID_I6150:
+	case USB_DEVICE_ID_I6150_2:
+	case USB_DEVICE_ID_I6150_3:
 	case USB_DEVICE_ID_I6250:
 		i2400mu->i6050 =3D 1;
 		break;
@@ -741,6 +744,9 @@ static
 struct usb_device_id i2400mu_id_table[] =3D {
 	{ USB_DEVICE(0x8086, USB_DEVICE_ID_I6050) },
 	{ USB_DEVICE(0x8086, USB_DEVICE_ID_I6050_2) },
+	{ USB_DEVICE(0x8087, USB_DEVICE_ID_I6150) },
+	{ USB_DEVICE(0x8087, USB_DEVICE_ID_I6150_2) },
+	{ USB_DEVICE(0x8087, USB_DEVICE_ID_I6150_3) },
 	{ USB_DEVICE(0x8086, USB_DEVICE_ID_I6250) },
 	{ USB_DEVICE(0x8086, 0x0181) },
 	{ USB_DEVICE(0x8086, 0x1403) },
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h b/drivers=
/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
index cc54153..498a3c1 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
@@ -835,98 +835,98 @@ static const u32 ar9300_2p2_baseband_core[][2] =3D {
=20
 static const u32 ar9300Modes_high_power_tx_gain_table_2p2[][5] =3D {
 	/* Addr      5G_HT20     5G_HT40     2G_HT40     2G_HT20   */
-	{0x0000a2dc, 0x00033800, 0x00033800, 0x03aaa352, 0x03aaa352},
-	{0x0000a2e0, 0x0003c000, 0x0003c000, 0x03ccc584, 0x03ccc584},
-	{0x0000a2e4, 0x03fc0000, 0x03fc0000, 0x03f0f800, 0x03f0f800},
+	{0x0000a2dc, 0x0380c7fc, 0x0380c7fc, 0x03aaa352, 0x03aaa352},
+	{0x0000a2e0, 0x0000f800, 0x0000f800, 0x03ccc584, 0x03ccc584},
+	{0x0000a2e4, 0x03ff0000, 0x03ff0000, 0x03f0f800, 0x03f0f800},
 	{0x0000a2e8, 0x00000000, 0x00000000, 0x03ff0000, 0x03ff0000},
-	{0x0000a410, 0x000050d9, 0x000050d9, 0x000050d9, 0x000050d9},
-	{0x0000a500, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
-	{0x0000a504, 0x06000003, 0x06000003, 0x04000002, 0x04000002},
-	{0x0000a508, 0x0a000020, 0x0a000020, 0x08000004, 0x08000004},
-	{0x0000a50c, 0x10000023, 0x10000023, 0x0b000200, 0x0b000200},
-	{0x0000a510, 0x16000220, 0x16000220, 0x0f000202, 0x0f000202},
-	{0x0000a514, 0x1c000223, 0x1c000223, 0x12000400, 0x12000400},
-	{0x0000a518, 0x21002220, 0x21002220, 0x16000402, 0x16000402},
-	{0x0000a51c, 0x27002223, 0x27002223, 0x19000404, 0x19000404},
-	{0x0000a520, 0x2b022220, 0x2b022220, 0x1c000603, 0x1c000603},
-	{0x0000a524, 0x2f022222, 0x2f022222, 0x21000a02, 0x21000a02},
-	{0x0000a528, 0x34022225, 0x34022225, 0x25000a04, 0x25000a04},
-	{0x0000a52c, 0x3a02222a, 0x3a02222a, 0x28000a20, 0x28000a20},
-	{0x0000a530, 0x3e02222c, 0x3e02222c, 0x2c000e20, 0x2c000e20},
-	{0x0000a534, 0x4202242a, 0x4202242a, 0x30000e22, 0x30000e22},
-	{0x0000a538, 0x4702244a, 0x4702244a, 0x34000e24, 0x34000e24},
-	{0x0000a53c, 0x4b02244c, 0x4b02244c, 0x38001640, 0x38001640},
-	{0x0000a540, 0x4e02246c, 0x4e02246c, 0x3c001660, 0x3c001660},
-	{0x0000a544, 0x52022470, 0x52022470, 0x3f001861, 0x3f001861},
-	{0x0000a548, 0x55022490, 0x55022490, 0x43001a81, 0x43001a81},
-	{0x0000a54c, 0x59022492, 0x59022492, 0x47001a83, 0x47001a83},
-	{0x0000a550, 0x5d022692, 0x5d022692, 0x4a001c84, 0x4a001c84},
-	{0x0000a554, 0x61022892, 0x61022892, 0x4e001ce3, 0x4e001ce3},
-	{0x0000a558, 0x65024890, 0x65024890, 0x52001ce5, 0x52001ce5},
-	{0x0000a55c, 0x69024892, 0x69024892, 0x56001ce9, 0x56001ce9},
-	{0x0000a560, 0x6e024c92, 0x6e024c92, 0x5a001ceb, 0x5a001ceb},
-	{0x0000a564, 0x74026e92, 0x74026e92, 0x5d001eec, 0x5d001eec},
-	{0x0000a568, 0x74026e92, 0x74026e92, 0x5d001eec, 0x5d001eec},
-	{0x0000a56c, 0x74026e92, 0x74026e92, 0x5d001eec, 0x5d001eec},
-	{0x0000a570, 0x74026e92, 0x74026e92, 0x5d001eec, 0x5d001eec},
-	{0x0000a574, 0x74026e92, 0x74026e92, 0x5d001eec, 0x5d001eec},
-	{0x0000a578, 0x74026e92, 0x74026e92, 0x5d001eec, 0x5d001eec},
-	{0x0000a57c, 0x74026e92, 0x74026e92, 0x5d001eec, 0x5d001eec},
-	{0x0000a580, 0x00800000, 0x00800000, 0x00800000, 0x00800000},
-	{0x0000a584, 0x06800003, 0x06800003, 0x04800002, 0x04800002},
-	{0x0000a588, 0x0a800020, 0x0a800020, 0x08800004, 0x08800004},
-	{0x0000a58c, 0x10800023, 0x10800023, 0x0b800200, 0x0b800200},
-	{0x0000a590, 0x16800220, 0x16800220, 0x0f800202, 0x0f800202},
-	{0x0000a594, 0x1c800223, 0x1c800223, 0x12800400, 0x12800400},
-	{0x0000a598, 0x21802220, 0x21802220, 0x16800402, 0x16800402},
-	{0x0000a59c, 0x27802223, 0x27802223, 0x19800404, 0x19800404},
-	{0x0000a5a0, 0x2b822220, 0x2b822220, 0x1c800603, 0x1c800603},
-	{0x0000a5a4, 0x2f822222, 0x2f822222, 0x21800a02, 0x21800a02},
-	{0x0000a5a8, 0x34822225, 0x34822225, 0x25800a04, 0x25800a04},
-	{0x0000a5ac, 0x3a82222a, 0x3a82222a, 0x28800a20, 0x28800a20},
-	{0x0000a5b0, 0x3e82222c, 0x3e82222c, 0x2c800e20, 0x2c800e20},
-	{0x0000a5b4, 0x4282242a, 0x4282242a, 0x30800e22, 0x30800e22},
-	{0x0000a5b8, 0x4782244a, 0x4782244a, 0x34800e24, 0x34800e24},
-	{0x0000a5bc, 0x4b82244c, 0x4b82244c, 0x38801640, 0x38801640},
-	{0x0000a5c0, 0x4e82246c, 0x4e82246c, 0x3c801660, 0x3c801660},
-	{0x0000a5c4, 0x52822470, 0x52822470, 0x3f801861, 0x3f801861},
-	{0x0000a5c8, 0x55822490, 0x55822490, 0x43801a81, 0x43801a81},
-	{0x0000a5cc, 0x59822492, 0x59822492, 0x47801a83, 0x47801a83},
-	{0x0000a5d0, 0x5d822692, 0x5d822692, 0x4a801c84, 0x4a801c84},
-	{0x0000a5d4, 0x61822892, 0x61822892, 0x4e801ce3, 0x4e801ce3},
-	{0x0000a5d8, 0x65824890, 0x65824890, 0x52801ce5, 0x52801ce5},
-	{0x0000a5dc, 0x69824892, 0x69824892, 0x56801ce9, 0x56801ce9},
-	{0x0000a5e0, 0x6e824c92, 0x6e824c92, 0x5a801ceb, 0x5a801ceb},
-	{0x0000a5e4, 0x74826e92, 0x74826e92, 0x5d801eec, 0x5d801eec},
-	{0x0000a5e8, 0x74826e92, 0x74826e92, 0x5d801eec, 0x5d801eec},
-	{0x0000a5ec, 0x74826e92, 0x74826e92, 0x5d801eec, 0x5d801eec},
-	{0x0000a5f0, 0x74826e92, 0x74826e92, 0x5d801eec, 0x5d801eec},
-	{0x0000a5f4, 0x74826e92, 0x74826e92, 0x5d801eec, 0x5d801eec},
-	{0x0000a5f8, 0x74826e92, 0x74826e92, 0x5d801eec, 0x5d801eec},
-	{0x0000a5fc, 0x74826e92, 0x74826e92, 0x5d801eec, 0x5d801eec},
+	{0x0000a410, 0x000050d8, 0x000050d8, 0x000050d9, 0x000050d9},
+	{0x0000a500, 0x00002220, 0x00002220, 0x00000000, 0x00000000},
+	{0x0000a504, 0x04002222, 0x04002222, 0x04000002, 0x04000002},
+	{0x0000a508, 0x09002421, 0x09002421, 0x08000004, 0x08000004},
+	{0x0000a50c, 0x0d002621, 0x0d002621, 0x0b000200, 0x0b000200},
+	{0x0000a510, 0x13004620, 0x13004620, 0x0f000202, 0x0f000202},
+	{0x0000a514, 0x19004a20, 0x19004a20, 0x11000400, 0x11000400},
+	{0x0000a518, 0x1d004e20, 0x1d004e20, 0x15000402, 0x15000402},
+	{0x0000a51c, 0x21005420, 0x21005420, 0x19000404, 0x19000404},
+	{0x0000a520, 0x26005e20, 0x26005e20, 0x1b000603, 0x1b000603},
+	{0x0000a524, 0x2b005e40, 0x2b005e40, 0x1f000a02, 0x1f000a02},
+	{0x0000a528, 0x2f005e42, 0x2f005e42, 0x23000a04, 0x23000a04},
+	{0x0000a52c, 0x33005e44, 0x33005e44, 0x26000a20, 0x26000a20},
+	{0x0000a530, 0x38005e65, 0x38005e65, 0x2a000e20, 0x2a000e20},
+	{0x0000a534, 0x3c005e69, 0x3c005e69, 0x2e000e22, 0x2e000e22},
+	{0x0000a538, 0x40005e6b, 0x40005e6b, 0x31000e24, 0x31000e24},
+	{0x0000a53c, 0x44005e6d, 0x44005e6d, 0x34001640, 0x34001640},
+	{0x0000a540, 0x49005e72, 0x49005e72, 0x38001660, 0x38001660},
+	{0x0000a544, 0x4e005eb2, 0x4e005eb2, 0x3b001861, 0x3b001861},
+	{0x0000a548, 0x53005f12, 0x53005f12, 0x3e001a81, 0x3e001a81},
+	{0x0000a54c, 0x59025eb2, 0x59025eb2, 0x42001a83, 0x42001a83},
+	{0x0000a550, 0x5e025f12, 0x5e025f12, 0x44001c84, 0x44001c84},
+	{0x0000a554, 0x61027f12, 0x61027f12, 0x48001ce3, 0x48001ce3},
+	{0x0000a558, 0x6702bf12, 0x6702bf12, 0x4c001ce5, 0x4c001ce5},
+	{0x0000a55c, 0x6b02bf14, 0x6b02bf14, 0x50001ce9, 0x50001ce9},
+	{0x0000a560, 0x6f02bf16, 0x6f02bf16, 0x54001ceb, 0x54001ceb},
+	{0x0000a564, 0x6f02bf16, 0x6f02bf16, 0x56001eec, 0x56001eec},
+	{0x0000a568, 0x6f02bf16, 0x6f02bf16, 0x56001eec, 0x56001eec},
+	{0x0000a56c, 0x6f02bf16, 0x6f02bf16, 0x56001eec, 0x56001eec},
+	{0x0000a570, 0x6f02bf16, 0x6f02bf16, 0x56001eec, 0x56001eec},
+	{0x0000a574, 0x6f02bf16, 0x6f02bf16, 0x56001eec, 0x56001eec},
+	{0x0000a578, 0x6f02bf16, 0x6f02bf16, 0x56001eec, 0x56001eec},
+	{0x0000a57c, 0x6f02bf16, 0x6f02bf16, 0x56001eec, 0x56001eec},
+	{0x0000a580, 0x00802220, 0x00802220, 0x00800000, 0x00800000},
+	{0x0000a584, 0x04802222, 0x04802222, 0x04800002, 0x04800002},
+	{0x0000a588, 0x09802421, 0x09802421, 0x08800004, 0x08800004},
+	{0x0000a58c, 0x0d802621, 0x0d802621, 0x0b800200, 0x0b800200},
+	{0x0000a590, 0x13804620, 0x13804620, 0x0f800202, 0x0f800202},
+	{0x0000a594, 0x19804a20, 0x19804a20, 0x11800400, 0x11800400},
+	{0x0000a598, 0x1d804e20, 0x1d804e20, 0x15800402, 0x15800402},
+	{0x0000a59c, 0x21805420, 0x21805420, 0x19800404, 0x19800404},
+	{0x0000a5a0, 0x26805e20, 0x26805e20, 0x1b800603, 0x1b800603},
+	{0x0000a5a4, 0x2b805e40, 0x2b805e40, 0x1f800a02, 0x1f800a02},
+	{0x0000a5a8, 0x2f805e42, 0x2f805e42, 0x23800a04, 0x23800a04},
+	{0x0000a5ac, 0x33805e44, 0x33805e44, 0x26800a20, 0x26800a20},
+	{0x0000a5b0, 0x38805e65, 0x38805e65, 0x2a800e20, 0x2a800e20},
+	{0x0000a5b4, 0x3c805e69, 0x3c805e69, 0x2e800e22, 0x2e800e22},
+	{0x0000a5b8, 0x40805e6b, 0x40805e6b, 0x31800e24, 0x31800e24},
+	{0x0000a5bc, 0x44805e6d, 0x44805e6d, 0x34801640, 0x34801640},
+	{0x0000a5c0, 0x49805e72, 0x49805e72, 0x38801660, 0x38801660},
+	{0x0000a5c4, 0x4e805eb2, 0x4e805eb2, 0x3b801861, 0x3b801861},
+	{0x0000a5c8, 0x53805f12, 0x53805f12, 0x3e801a81, 0x3e801a81},
+	{0x0000a5cc, 0x59825eb2, 0x59825eb2, 0x42801a83, 0x42801a83},
+	{0x0000a5d0, 0x5e825f12, 0x5e825f12, 0x44801c84, 0x44801c84},
+	{0x0000a5d4, 0x61827f12, 0x61827f12, 0x48801ce3, 0x48801ce3},
+	{0x0000a5d8, 0x6782bf12, 0x6782bf12, 0x4c801ce5, 0x4c801ce5},
+	{0x0000a5dc, 0x6b82bf14, 0x6b82bf14, 0x50801ce9, 0x50801ce9},
+	{0x0000a5e0, 0x6f82bf16, 0x6f82bf16, 0x54801ceb, 0x54801ceb},
+	{0x0000a5e4, 0x6f82bf16, 0x6f82bf16, 0x56801eec, 0x56801eec},
+	{0x0000a5e8, 0x6f82bf16, 0x6f82bf16, 0x56801eec, 0x56801eec},
+	{0x0000a5ec, 0x6f82bf16, 0x6f82bf16, 0x56801eec, 0x56801eec},
+	{0x0000a5f0, 0x6f82bf16, 0x6f82bf16, 0x56801eec, 0x56801eec},
+	{0x0000a5f4, 0x6f82bf16, 0x6f82bf16, 0x56801eec, 0x56801eec},
+	{0x0000a5f8, 0x6f82bf16, 0x6f82bf16, 0x56801eec, 0x56801eec},
+	{0x0000a5fc, 0x6f82bf16, 0x6f82bf16, 0x56801eec, 0x56801eec},
 	{0x0000a600, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
 	{0x0000a604, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
 	{0x0000a608, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
 	{0x0000a60c, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
-	{0x0000a610, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
-	{0x0000a614, 0x02004000, 0x02004000, 0x01404000, 0x01404000},
-	{0x0000a618, 0x02004801, 0x02004801, 0x01404501, 0x01404501},
-	{0x0000a61c, 0x02808a02, 0x02808a02, 0x02008501, 0x02008501},
-	{0x0000a620, 0x0380ce03, 0x0380ce03, 0x0280ca03, 0x0280ca03},
-	{0x0000a624, 0x04411104, 0x04411104, 0x03010c04, 0x03010c04},
-	{0x0000a628, 0x04411104, 0x04411104, 0x04014c04, 0x04014c04},
-	{0x0000a62c, 0x04411104, 0x04411104, 0x04015005, 0x04015005},
-	{0x0000a630, 0x04411104, 0x04411104, 0x04015005, 0x04015005},
-	{0x0000a634, 0x04411104, 0x04411104, 0x04015005, 0x04015005},
-	{0x0000a638, 0x04411104, 0x04411104, 0x04015005, 0x04015005},
-	{0x0000a63c, 0x04411104, 0x04411104, 0x04015005, 0x04015005},
-	{0x0000b2dc, 0x00033800, 0x00033800, 0x03aaa352, 0x03aaa352},
-	{0x0000b2e0, 0x0003c000, 0x0003c000, 0x03ccc584, 0x03ccc584},
-	{0x0000b2e4, 0x03fc0000, 0x03fc0000, 0x03f0f800, 0x03f0f800},
+	{0x0000a610, 0x00804000, 0x00804000, 0x00000000, 0x00000000},
+	{0x0000a614, 0x00804201, 0x00804201, 0x01404000, 0x01404000},
+	{0x0000a618, 0x0280c802, 0x0280c802, 0x01404501, 0x01404501},
+	{0x0000a61c, 0x0280ca03, 0x0280ca03, 0x02008501, 0x02008501},
+	{0x0000a620, 0x04c15104, 0x04c15104, 0x0280ca03, 0x0280ca03},
+	{0x0000a624, 0x04c15305, 0x04c15305, 0x03010c04, 0x03010c04},
+	{0x0000a628, 0x04c15305, 0x04c15305, 0x04014c04, 0x04014c04},
+	{0x0000a62c, 0x04c15305, 0x04c15305, 0x04015005, 0x04015005},
+	{0x0000a630, 0x04c15305, 0x04c15305, 0x04015005, 0x04015005},
+	{0x0000a634, 0x04c15305, 0x04c15305, 0x04015005, 0x04015005},
+	{0x0000a638, 0x04c15305, 0x04c15305, 0x04015005, 0x04015005},
+	{0x0000a63c, 0x04c15305, 0x04c15305, 0x04015005, 0x04015005},
+	{0x0000b2dc, 0x0380c7fc, 0x0380c7fc, 0x03aaa352, 0x03aaa352},
+	{0x0000b2e0, 0x0000f800, 0x0000f800, 0x03ccc584, 0x03ccc584},
+	{0x0000b2e4, 0x03ff0000, 0x03ff0000, 0x03f0f800, 0x03f0f800},
 	{0x0000b2e8, 0x00000000, 0x00000000, 0x03ff0000, 0x03ff0000},
-	{0x0000c2dc, 0x00033800, 0x00033800, 0x03aaa352, 0x03aaa352},
-	{0x0000c2e0, 0x0003c000, 0x0003c000, 0x03ccc584, 0x03ccc584},
-	{0x0000c2e4, 0x03fc0000, 0x03fc0000, 0x03f0f800, 0x03f0f800},
+	{0x0000c2dc, 0x0380c7fc, 0x0380c7fc, 0x03aaa352, 0x03aaa352},
+	{0x0000c2e0, 0x0000f800, 0x0000f800, 0x03ccc584, 0x03ccc584},
+	{0x0000c2e4, 0x03ff0000, 0x03ff0000, 0x03f0f800, 0x03f0f800},
 	{0x0000c2e8, 0x00000000, 0x00000000, 0x03ff0000, 0x03ff0000},
 	{0x00016044, 0x012492d4, 0x012492d4, 0x012492d4, 0x012492d4},
 	{0x00016048, 0x66480001, 0x66480001, 0x66480001, 0x66480001},
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h b/drivers/net/w=
ireless/ath/ath9k/ar9003_eeprom.h
index 6335a86..69bcdb6 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h
@@ -69,13 +69,13 @@
 #define AR9300_BASE_ADDR 0x3ff
 #define AR9300_BASE_ADDR_512 0x1ff
=20
-#define AR9300_OTP_BASE			0x14000
-#define AR9300_OTP_STATUS		0x15f18
+#define AR9300_OTP_BASE			(AR_SREV_9340(ah) ? 0x30000 : 0x14000)
+#define AR9300_OTP_STATUS		(AR_SREV_9340(ah) ? 0x30018 : 0x15f18)
 #define AR9300_OTP_STATUS_TYPE		0x7
 #define AR9300_OTP_STATUS_VALID		0x4
 #define AR9300_OTP_STATUS_ACCESS_BUSY	0x2
 #define AR9300_OTP_STATUS_SM_BUSY	0x1
-#define AR9300_OTP_READ_DATA		0x15f1c
+#define AR9300_OTP_READ_DATA		(AR_SREV_9340(ah) ? 0x3001c : 0x15f1c)
=20
 enum targetPowerHTRates {
 	HT_TARGET_RATE_0_8_16,
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_hw.c b/drivers/net/wirel=
ess/ath/ath9k/ar9003_hw.c
index fb937ba..e9d73e7 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
@@ -34,9 +34,6 @@
  */
 static void ar9003_hw_init_mode_regs(struct ath_hw *ah)
 {
-#define PCIE_PLL_ON_CREQ_DIS_L1_2P0 \
-		ar9462_pciephy_pll_on_clkreq_disable_L1_2p0
-
 #define AR9462_BB_CTX_COEFJ(x)	\
 		ar9462_##x##_baseband_core_txfir_coeff_japan_2484
=20
@@ -369,13 +366,13 @@ static void ar9003_hw_init_mode_regs(struct ath_hw *a=
h)
=20
 		/* Awake -> Sleep Setting */
 		INIT_INI_ARRAY(&ah->iniPcieSerdes,
-				PCIE_PLL_ON_CREQ_DIS_L1_2P0,
-				ARRAY_SIZE(PCIE_PLL_ON_CREQ_DIS_L1_2P0),
+				ar9462_pciephy_clkreq_disable_L1_2p0,
+				ARRAY_SIZE(ar9462_pciephy_clkreq_disable_L1_2p0),
 				2);
 		/* Sleep -> Awake Setting */
 		INIT_INI_ARRAY(&ah->iniPcieSerdesLowPower,
-				PCIE_PLL_ON_CREQ_DIS_L1_2P0,
-				ARRAY_SIZE(PCIE_PLL_ON_CREQ_DIS_L1_2P0),
+				ar9462_pciephy_clkreq_disable_L1_2p0,
+				ARRAY_SIZE(ar9462_pciephy_clkreq_disable_L1_2p0),
 				2);
=20
 		/* Fast clock modal settings */
diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/=
ath/ath9k/calib.c
index d771de5..bcabfbf 100644
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -69,6 +69,7 @@ s16 ath9k_hw_getchan_noise(struct ath_hw *ah, struct ath9=
k_channel *chan)
=20
 	if (chan && chan->noisefloor) {
 		s8 delta =3D chan->noisefloor -
+			   ATH9K_NF_CAL_NOISE_THRESH -
 			   ath9k_hw_get_default_nf(ah, chan);
 		if (delta > 0)
 			noise +=3D delta;
diff --git a/drivers/net/wireless/ath/ath9k/calib.h b/drivers/net/wireless/=
ath/ath9k/calib.h
index 05b9dbf..e300a73 100644
--- a/drivers/net/wireless/ath/ath9k/calib.h
+++ b/drivers/net/wireless/ath/ath9k/calib.h
@@ -22,6 +22,9 @@
 #define AR_PHY_CCA_FILTERWINDOW_LENGTH_INIT     3
 #define AR_PHY_CCA_FILTERWINDOW_LENGTH          5
=20
+/* Internal noise floor can vary by about 6db depending on the frequency *=
/
+#define ATH9K_NF_CAL_NOISE_THRESH		6
+
 #define NUM_NF_READINGS       6
 #define ATH9K_NF_CAL_HIST_MAX 5
=20
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c b/drivers/net=
/wireless/iwlwifi/iwl-trans-pcie-rx.c
index 17fb25d..9fefb56 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
@@ -311,6 +311,14 @@ static void iwlagn_rx_allocate(struct iwl_trans *trans=
, gfp_t priority)
 		rxb->page_dma =3D dma_map_page(bus(trans)->dev, page, 0,
 				PAGE_SIZE << hw_params(trans).rx_page_order,
 				DMA_FROM_DEVICE);
+		if (dma_mapping_error(bus(trans)->dev, rxb->page_dma)) {
+			rxb->page =3D NULL;
+			spin_lock_irqsave(&rxq->lock, flags);
+			list_add(&rxb->list, &rxq->rx_used);
+			spin_unlock_irqrestore(&rxq->lock, flags);
+			__free_pages(page, hw_params(trans).rx_page_order);
+			return;
+		}
 		/* dma address must be no more than 36 bits */
 		BUG_ON(rxb->page_dma & ~DMA_BIT_MASK(36));
 		/* and also 256 byte aligned! */
@@ -489,8 +497,19 @@ static void iwl_rx_handle(struct iwl_trans *trans)
 				0, PAGE_SIZE <<
 				    hw_params(trans).rx_page_order,
 				DMA_FROM_DEVICE);
-			list_add_tail(&rxb->list, &rxq->rx_free);
-			rxq->free_count++;
+			if (dma_mapping_error(bus(trans)->dev, rxb->page_dma)) {
+				/*
+				 * free the page(s) as well to not break
+				 * the invariant that the items on the used
+				 * list have no page(s)
+				 */
+				__free_pages(rxb->page, hw_params(trans).rx_page_order);
+				rxb->page =3D NULL;
+				list_add_tail(&rxb->list, &rxq->rx_used);
+			} else {
+				list_add_tail(&rxb->list, &rxq->rx_free);
+				rxq->free_count++;
+			}
 		} else
 			list_add_tail(&rxb->list, &rxq->rx_used);
=20
@@ -1263,12 +1282,20 @@ static irqreturn_t iwl_isr(int irq, void *data)
 	 *    back-to-back ISRs and sporadic interrupts from our NIC.
 	 * If we have something to service, the tasklet will re-enable ints.
 	 * If we *don't* have something, we'll re-enable before leaving here. */
-	inta_mask =3D iwl_read32(bus(trans), CSR_INT_MASK);  /* just for debug */
+	inta_mask =3D iwl_read32(bus(trans), CSR_INT_MASK);
 	iwl_write32(bus(trans), CSR_INT_MASK, 0x00000000);
=20
 	/* Discover which interrupts are active/pending */
 	inta =3D iwl_read32(bus(trans), CSR_INT);
=20
+	if (inta & (~inta_mask)) {
+		IWL_DEBUG_ISR(trans,
+			      "We got a masked interrupt (0x%08x)...Ack and ignore\n",
+			      inta & (~inta_mask));
+		iwl_write32(bus(trans), CSR_INT, inta & (~inta_mask));
+		inta &=3D inta_mask;
+	}
+
 	/* Ignore interrupt if there's nothing in NIC to service.
 	 * This may be due to IRQ shared with another device,
 	 * or due to sporadic interrupts thrown from our NIC. */
@@ -1349,7 +1376,7 @@ irqreturn_t iwl_isr_ict(int irq, void *data)
 	 * If we have something to service, the tasklet will re-enable ints.
 	 * If we *don't* have something, we'll re-enable before leaving here.
 	 */
-	inta_mask =3D iwl_read32(bus(trans), CSR_INT_MASK);  /* just for debug */
+	inta_mask =3D iwl_read32(bus(trans), CSR_INT_MASK);
 	iwl_write32(bus(trans), CSR_INT_MASK, 0x00000000);
=20

diff --git a/drivers/pnp/pnpacpi/core.c b/drivers/pnp/pnpacpi/core.c
index d21e8f5..291906e 100644
--- a/drivers/pnp/pnpacpi/core.c
+++ b/drivers/pnp/pnpacpi/core.c
@@ -58,7 +58,7 @@ static inline int __init is_exclusive_device(struct acpi_=
device *dev)
 	if (!(('0' <=3D (c) && (c) <=3D '9') || ('A' <=3D (c) && (c) <=3D 'F'))) =
\
 		return 0
 #define TEST_ALPHA(c) \
-	if (!('@' <=3D (c) || (c) <=3D 'Z')) \
+	if (!('A' <=3D (c) && (c) <=3D 'Z')) \
 		return 0
 static int __init ispnpidacpi(const char *id)
 {
@@ -95,6 +95,9 @@ static int pnpacpi_set_resources(struct pnp_dev *dev)
 		return -ENODEV;
 	}
=20
+	if (WARN_ON_ONCE(acpi_dev !=3D dev->data))
+		dev->data =3D acpi_dev;
+
 	ret =3D pnpacpi_build_resource_template(dev, &buffer);
 	if (ret)
 		return ret;
diff --git a/drivers/regulator/wm831x-dcdc.c b/drivers/regulator/wm831x-dcd=
c.c
index bd3531d..77a6faf 100644
--- a/drivers/regulator/wm831x-dcdc.c
+++ b/drivers/regulator/wm831x-dcdc.c
@@ -330,7 +330,7 @@ static int wm831x_buckv_set_voltage(struct regulator_de=
v *rdev,
 	if (vsel > dcdc->dvs_vsel) {
 		ret =3D wm831x_set_bits(wm831x, dvs_reg,
 				      WM831X_DC1_DVS_VSEL_MASK,
-				      dcdc->dvs_vsel);
+				      vsel);
 		if (ret =3D=3D 0)
 			dcdc->dvs_vsel =3D vsel;
 		else
diff --git a/drivers/s390/cio/device_pgid.c b/drivers/s390/cio/device_pgid.=
c
index 07a4fd2..daa6b90 100644
--- a/drivers/s390/cio/device_pgid.c
+++ b/drivers/s390/cio/device_pgid.c
@@ -234,7 +234,7 @@ static int pgid_cmp(struct pgid *p1, struct pgid *p2)
  * Determine pathgroup state from PGID data.
  */
 static void pgid_analyze(struct ccw_device *cdev, struct pgid **p,
-			 int *mismatch, int *reserved, u8 *reset)
+			 int *mismatch, u8 *reserved, u8 *reset)
 {
 	struct pgid *pgid =3D &cdev->private->pgid[0];
 	struct pgid *first =3D NULL;
@@ -248,7 +248,7 @@ static void pgid_analyze(struct ccw_device *cdev, struc=
t pgid **p,
 		if ((cdev->private->pgid_valid_mask & lpm) =3D=3D 0)
 			continue;
 		if (pgid->inf.ps.state2 =3D=3D SNID_STATE2_RESVD_ELSE)
-			*reserved =3D 1;
+			*reserved |=3D lpm;
 		if (pgid_is_reset(pgid)) {
 			*reset |=3D lpm;
 			continue;
@@ -316,14 +316,14 @@ static void snid_done(struct ccw_device *cdev, int rc=
)
 	struct subchannel *sch =3D to_subchannel(cdev->dev.parent);
 	struct pgid *pgid;
 	int mismatch =3D 0;
-	int reserved =3D 0;
+	u8 reserved =3D 0;
 	u8 reset =3D 0;
 	u8 donepm;
=20
 	if (rc)
 		goto out;
 	pgid_analyze(cdev, &pgid, &mismatch, &reserved, &reset);
-	if (reserved)
+	if (reserved =3D=3D cdev->private->pgid_valid_mask)
 		rc =3D -EUSERS;
 	else if (mismatch)
 		rc =3D -EOPNOTSUPP;
@@ -336,7 +336,7 @@ static void snid_done(struct ccw_device *cdev, int rc)
 	}
 out:
 	CIO_MSG_EVENT(2, "snid: device 0.%x.%04x: rc=3D%d pvm=3D%02x vpm=3D%02x "
-		      "todo=3D%02x mism=3D%d rsvd=3D%d reset=3D%02x\n", id->ssid,
+		      "todo=3D%02x mism=3D%d rsvd=3D%02x reset=3D%02x\n", id->ssid,
 		      id->devno, rc, cdev->private->pgid_valid_mask, sch->vpm,
 		      cdev->private->pgid_todo_mask, mismatch, reserved, reset);
 	switch (rc) {
diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index f17c92c..0fd5ea7 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -2985,8 +2985,8 @@ static int get_command(char *pos, Scsi_Cmnd * ptr)
 	char *start =3D pos;
 	int i;
=20
-	SPRINTF("0x%08x: target=3D%d; lun=3D%d; cmnd=3D( ",
-		(unsigned int) ptr, ptr->device->id, ptr->device->lun);
+	SPRINTF("%p: target=3D%d; lun=3D%d; cmnd=3D( ",
+		ptr, ptr->device->id, ptr->device->lun);
=20
 	for (i =3D 0; i < COMMAND_SIZE(ptr->cmnd[0]); i++)
 		SPRINTF("0x%02x ", ptr->cmnd[i]);
diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 22523aa..0f48550 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -98,6 +98,15 @@ static const struct pci_device_id hpsa_pci_device_id[] =
=3D {
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSF,     0x103C, 0x3354},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSF,     0x103C, 0x3355},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSF,     0x103C, 0x3356},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C, 0x1920},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C, 0x1921},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C, 0x1922},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C, 0x1923},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C, 0x1924},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C, 0x1925},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C, 0x1926},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C, 0x1928},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSF,     0x103C, 0x334d},
 	{PCI_VENDOR_ID_HP,     PCI_ANY_ID,	PCI_ANY_ID, PCI_ANY_ID,
 		PCI_CLASS_STORAGE_RAID << 8, 0xffff << 8, 0},
 	{0,}
@@ -117,13 +126,22 @@ static struct board_type products[] =3D {
 	{0x3249103C, "Smart Array P812", &SA5_access},
 	{0x324a103C, "Smart Array P712m", &SA5_access},
 	{0x324b103C, "Smart Array P711m", &SA5_access},
-	{0x3350103C, "Smart Array", &SA5_access},
-	{0x3351103C, "Smart Array", &SA5_access},
-	{0x3352103C, "Smart Array", &SA5_access},
-	{0x3353103C, "Smart Array", &SA5_access},
-	{0x3354103C, "Smart Array", &SA5_access},
-	{0x3355103C, "Smart Array", &SA5_access},
-	{0x3356103C, "Smart Array", &SA5_access},
+	{0x3350103C, "Smart Array P222", &SA5_access},
+	{0x3351103C, "Smart Array P420", &SA5_access},
+	{0x3352103C, "Smart Array P421", &SA5_access},
+	{0x3353103C, "Smart Array P822", &SA5_access},
+	{0x3354103C, "Smart Array P420i", &SA5_access},
+	{0x3355103C, "Smart Array P220i", &SA5_access},
+	{0x3356103C, "Smart Array P721m", &SA5_access},
+	{0x1920103C, "Smart Array", &SA5_access},
+	{0x1921103C, "Smart Array", &SA5_access},
+	{0x1922103C, "Smart Array", &SA5_access},
+	{0x1923103C, "Smart Array", &SA5_access},
+	{0x1924103C, "Smart Array", &SA5_access},
+	{0x1925103C, "Smart Array", &SA5_access},
+	{0x1926103C, "Smart Array", &SA5_access},
+	{0x1928103C, "Smart Array", &SA5_access},
+	{0x334d103C, "Smart Array P822se", &SA5_access},
 	{0xFFFF103C, "Unknown Smart Array", &SA5_access},
 };
=20
diff --git a/drivers/scsi/mvsas/mv_94xx.h b/drivers/scsi/mvsas/mv_94xx.h
index 8f7eb4f..487aa6f 100644
--- a/drivers/scsi/mvsas/mv_94xx.h
+++ b/drivers/scsi/mvsas/mv_94xx.h
@@ -258,21 +258,11 @@ enum sas_sata_phy_regs {
 #define SPI_ADDR_VLD_94XX         	(1U << 1)
 #define SPI_CTRL_SpiStart_94XX     	(1U << 0)
=20
-#define mv_ffc(x)   ffz(x)
-
 static inline int
 mv_ffc64(u64 v)
 {
-	int i;
-	i =3D mv_ffc((u32)v);
-	if (i >=3D 0)
-		return i;
-	i =3D mv_ffc((u32)(v>>32));
-
-	if (i !=3D 0)
-		return 32 + i;
-
-	return -1;
+	u64 x =3D ~v;
+	return x ? __ffs64(x) : -1;
 }
=20
 #define r_reg_set_enable(i) \
diff --git a/drivers/scsi/mvsas/mv_sas.h b/drivers/scsi/mvsas/mv_sas.h
index c04a4f5..da24955 100644
--- a/drivers/scsi/mvsas/mv_sas.h
+++ b/drivers/scsi/mvsas/mv_sas.h
@@ -69,7 +69,7 @@ extern struct kmem_cache *mvs_task_list_cache;
 #define DEV_IS_EXPANDER(type)	\
 	((type =3D=3D EDGE_DEV) || (type =3D=3D FANOUT_DEV))
=20
-#define bit(n) ((u32)1 << n)
+#define bit(n) ((u64)1 << n)
=20
 #define for_each_phy(__lseq_mask, __mc, __lseq)			\
 	for ((__mc) =3D (__lseq_mask), (__lseq) =3D 0;		\
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index f9e5b85..82a5ca6 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3541,9 +3541,9 @@ qla2x00_do_dpc(void *data)
 			    "ISP abort end.\n");
 		}
=20
-		if (test_bit(FCPORT_UPDATE_NEEDED, &base_vha->dpc_flags)) {
+		if (test_and_clear_bit(FCPORT_UPDATE_NEEDED,
+		    &base_vha->dpc_flags)) {
 			qla2x00_update_fcports(base_vha);
-			clear_bit(FCPORT_UPDATE_NEEDED, &base_vha->dpc_flags);
 		}
=20
 		if (test_bit(ISP_QUIESCE_NEEDED, &base_vha->dpc_flags)) {
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 08d48a3..72ca515 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -246,11 +246,11 @@ show_shost_active_mode(struct device *dev,
=20
 static DEVICE_ATTR(active_mode, S_IRUGO | S_IWUSR, show_shost_active_mode,=
 NULL);
=20
-static int check_reset_type(char *str)
+static int check_reset_type(const char *str)
 {
-	if (strncmp(str, "adapter", 10) =3D=3D 0)
+	if (sysfs_streq(str, "adapter"))
 		return SCSI_ADAPTER_RESET;
-	else if (strncmp(str, "firmware", 10) =3D=3D 0)
+	else if (sysfs_streq(str, "firmware"))
 		return SCSI_FIRMWARE_RESET;
 	else
 		return 0;
@@ -263,12 +263,9 @@ store_host_reset(struct device *dev, struct device_att=
ribute *attr,
 	struct Scsi_Host *shost =3D class_to_shost(dev);
 	struct scsi_host_template *sht =3D shost->hostt;
 	int ret =3D -EINVAL;
-	char str[10];
 	int type;
=20
-	sscanf(buf, "%s", str);
-	type =3D check_reset_type(str);
-
+	type =3D check_reset_type(buf);
 	if (!type)
 		goto exit_store_host_reset;
=20
diff --git a/drivers/staging/bcm/InterfaceInit.c b/drivers/staging/bcm/Inte=
rfaceInit.c
index a09d351..3582535 100644
--- a/drivers/staging/bcm/InterfaceInit.c
+++ b/drivers/staging/bcm/InterfaceInit.c
@@ -4,10 +4,12 @@ static struct usb_device_id InterfaceUsbtable[] =3D {
 	{ USB_DEVICE(BCM_USB_VENDOR_ID_T3, BCM_USB_PRODUCT_ID_T3) },
 	{ USB_DEVICE(BCM_USB_VENDOR_ID_T3, BCM_USB_PRODUCT_ID_T3B) },
 	{ USB_DEVICE(BCM_USB_VENDOR_ID_T3, BCM_USB_PRODUCT_ID_T3L) },
-	{ USB_DEVICE(BCM_USB_VENDOR_ID_T3, BCM_USB_PRODUCT_ID_SM250) },
+	{ USB_DEVICE(BCM_USB_VENDOR_ID_T3, BCM_USB_PRODUCT_ID_SYM) },
 	{ USB_DEVICE(BCM_USB_VENDOR_ID_ZTE, BCM_USB_PRODUCT_ID_226) },
 	{ USB_DEVICE(BCM_USB_VENDOR_ID_FOXCONN, BCM_USB_PRODUCT_ID_1901) },
 	{ USB_DEVICE(BCM_USB_VENDOR_ID_ZTE, BCM_USB_PRODUCT_ID_ZTE_TU25) },
+	{ USB_DEVICE(BCM_USB_VENDOR_ID_ZTE, BCM_USB_PRODUCT_ID_ZTE_226) },
+	{ USB_DEVICE(BCM_USB_VENDOR_ID_ZTE, BCM_USB_PRODUCT_ID_ZTE_326) },
 	{ }
 };
 MODULE_DEVICE_TABLE(usb, InterfaceUsbtable);
diff --git a/drivers/staging/bcm/InterfaceInit.h b/drivers/staging/bcm/Inte=
rfaceInit.h
index 058315a..6fa4f09 100644
--- a/drivers/staging/bcm/InterfaceInit.h
+++ b/drivers/staging/bcm/InterfaceInit.h
@@ -8,10 +8,11 @@
 #define BCM_USB_PRODUCT_ID_T3 	0x0300
 #define BCM_USB_PRODUCT_ID_T3B 	0x0210
 #define BCM_USB_PRODUCT_ID_T3L 	0x0220
-#define BCM_USB_PRODUCT_ID_SM250 	0xbccd
 #define BCM_USB_PRODUCT_ID_SYM  0x15E
 #define BCM_USB_PRODUCT_ID_1901 0xe017
-#define BCM_USB_PRODUCT_ID_226  0x0132
+#define BCM_USB_PRODUCT_ID_226	0x0132 /* not sure if this is valid */
+#define BCM_USB_PRODUCT_ID_ZTE_226 0x172
+#define BCM_USB_PRODUCT_ID_ZTE_326 0x173 /* ZTE AX326 */
 #define BCM_USB_PRODUCT_ID_ZTE_TU25 0x0007
=20
 #define BCM_USB_MINOR_BASE 		192
diff --git a/drivers/staging/vt6656/dpc.c b/drivers/staging/vt6656/dpc.c
index 08021f4..4664e9d 100644
--- a/drivers/staging/vt6656/dpc.c
+++ b/drivers/staging/vt6656/dpc.c
@@ -1238,7 +1238,7 @@ static BOOL s_bHandleRxEncryption (
=20
         PayloadLen -=3D (WLAN_HDR_ADDR3_LEN + 8 + 4); // 24 is 802.11 head=
er, 8 is IV&ExtIV, 4 is crc
         *pdwRxTSC47_16 =3D cpu_to_le32(*(PDWORD)(pbyIV + 4));
-        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"ExtIV: %lx\n",*pdwRxTSC47_16);
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"ExtIV: %x\n", *pdwRxTSC47_16);
         if (byDecMode =3D=3D KEY_CTL_TKIP) {
             *pwRxTSC15_0 =3D cpu_to_le16(MAKEWORD(*(pbyIV+2), *pbyIV));
         } else {
@@ -1349,7 +1349,7 @@ static BOOL s_bHostWepRxEncryption (
=20
         PayloadLen -=3D (WLAN_HDR_ADDR3_LEN + 8 + 4); // 24 is 802.11 head=
er, 8 is IV&ExtIV, 4 is crc
         *pdwRxTSC47_16 =3D cpu_to_le32(*(PDWORD)(pbyIV + 4));
-        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"ExtIV: %lx\n",*pdwRxTSC47_16);
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"ExtIV: %x\n", *pdwRxTSC47_16);
=20
         if (byDecMode =3D=3D KEY_CTL_TKIP) {
             *pwRxTSC15_0 =3D cpu_to_le16(MAKEWORD(*(pbyIV+2), *pbyIV));
diff --git a/drivers/staging/vt6656/key.c b/drivers/staging/vt6656/key.c
index 27bb523..fd93e83 100644
--- a/drivers/staging/vt6656/key.c
+++ b/drivers/staging/vt6656/key.c
@@ -223,7 +223,7 @@ BOOL KeybSetKey(
     PSKeyManagement pTable,
     PBYTE           pbyBSSID,
     DWORD           dwKeyIndex,
-    unsigned long           uKeyLength,
+	u32 uKeyLength,
     PQWORD          pKeyRSC,
     PBYTE           pbyKey,
     BYTE            byKeyDecMode
@@ -235,7 +235,8 @@ BOOL KeybSetKey(
     PSKeyItem   pKey;
     unsigned int        uKeyIdx;
=20
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Enter KeybSetKey: %lX\n", dwKeyInde=
x);
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
+		"Enter KeybSetKey: %X\n", dwKeyIndex);
=20
     j =3D (MAX_KEY_TABLE-1);
     for (i=3D0;i<(MAX_KEY_TABLE-1);i++) {
@@ -261,7 +262,9 @@ BOOL KeybSetKey(
                 if ((dwKeyIndex & TRANSMIT_KEY) !=3D 0)  {
                     // Group transmit key
                     pTable->KeyTable[i].dwGTKeyIndex =3D dwKeyIndex;
-                    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Group transmit key(=
R)[%lX]: %d\n", pTable->KeyTable[i].dwGTKeyIndex, i);
+			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
+				"Group transmit key(R)[%X]: %d\n",
+					pTable->KeyTable[i].dwGTKeyIndex, i);
                 }
                 pTable->KeyTable[i].wKeyCtl &=3D 0xFF0F;          // clear=
 group key control filed
                 pTable->KeyTable[i].wKeyCtl |=3D (byKeyDecMode << 4);
@@ -302,9 +305,12 @@ BOOL KeybSetKey(
             }
             DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"\n");
=20
-            DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"pKey->dwTSC47_16: %lx\n ", =
pKey->dwTSC47_16);
-            DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"pKey->wTSC15_0: %x\n ", pKe=
y->wTSC15_0);
-            DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"pKey->dwKeyIndex: %lx\n ", =
pKey->dwKeyIndex);
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"pKey->dwTSC47_16: %x\n ",
+			pKey->dwTSC47_16);
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"pKey->wTSC15_0: %x\n ",
+			pKey->wTSC15_0);
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"pKey->dwKeyIndex: %x\n ",
+			pKey->dwKeyIndex);
=20
             return (TRUE);
         }
@@ -326,7 +332,9 @@ BOOL KeybSetKey(
             if ((dwKeyIndex & TRANSMIT_KEY) !=3D 0)  {
                 // Group transmit key
                 pTable->KeyTable[j].dwGTKeyIndex =3D dwKeyIndex;
-                DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Group transmit key(N)[%=
lX]: %d\n", pTable->KeyTable[j].dwGTKeyIndex, j);
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
+			"Group transmit key(N)[%X]: %d\n",
+				pTable->KeyTable[j].dwGTKeyIndex, j);
             }
             pTable->KeyTable[j].wKeyCtl &=3D 0xFF0F;          // clear gro=
up key control filed
             pTable->KeyTable[j].wKeyCtl |=3D (byKeyDecMode << 4);
@@ -367,9 +375,11 @@ BOOL KeybSetKey(
         }
         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"\n");
=20
-        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"pKey->dwTSC47_16: %lx\n ", pKey=
->dwTSC47_16);
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"pKey->dwTSC47_16: %x\n ",
+		pKey->dwTSC47_16);
         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"pKey->wTSC15_0: %x\n ", pKey->w=
TSC15_0);
-        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"pKey->dwKeyIndex: %lx\n ", pKey=
->dwKeyIndex);
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"pKey->dwKeyIndex: %x\n ",
+		pKey->dwKeyIndex);
=20
         return (TRUE);
     }
@@ -597,7 +607,8 @@ BOOL KeybGetTransmitKey(PSKeyManagement pTable, PBYTE p=
byBSSID, DWORD dwKeyType,
                             DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"%x ", pTabl=
e->KeyTable[i].abyBSSID[ii]);
                         }
                         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"\n");
-                        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"dwGTKeyIndex: %=
lX\n", pTable->KeyTable[i].dwGTKeyIndex);
+			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"dwGTKeyIndex: %X\n",
+				pTable->KeyTable[i].dwGTKeyIndex);
=20
                     return (TRUE);
                 }
@@ -664,7 +675,7 @@ BOOL KeybSetDefaultKey(
     void *pDeviceHandler,
     PSKeyManagement pTable,
     DWORD           dwKeyIndex,
-    unsigned long           uKeyLength,
+	u32 uKeyLength,
     PQWORD          pKeyRSC,
     PBYTE           pbyKey,
     BYTE            byKeyDecMode
@@ -693,7 +704,10 @@ BOOL KeybSetDefaultKey(
     if ((dwKeyIndex & TRANSMIT_KEY) !=3D 0)  {
         // Group transmit key
         pTable->KeyTable[MAX_KEY_TABLE-1].dwGTKeyIndex =3D dwKeyIndex;
-        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Group transmit key(R)[%lX]: %d\=
n", pTable->KeyTable[MAX_KEY_TABLE-1].dwGTKeyIndex, MAX_KEY_TABLE-1);
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
+		"Group transmit key(R)[%X]: %d\n",
+		pTable->KeyTable[MAX_KEY_TABLE-1].dwGTKeyIndex,
+		MAX_KEY_TABLE-1);
=20
     }
     pTable->KeyTable[MAX_KEY_TABLE-1].wKeyCtl &=3D 0x7F00;          // cle=
ar all key control filed
@@ -744,9 +758,11 @@ BOOL KeybSetDefaultKey(
     }
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"\n");
=20
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"pKey->dwTSC47_16: %lx\n", pKey->dwT=
SC47_16);
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"pKey->dwTSC47_16: %x\n",
+		pKey->dwTSC47_16);
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"pKey->wTSC15_0: %x\n", pKey->wTSC15=
_0);
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"pKey->dwKeyIndex: %lx\n", pKey->dwK=
eyIndex);
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"pKey->dwKeyIndex: %x\n",
+		pKey->dwKeyIndex);
=20
     return (TRUE);
 }
@@ -772,7 +788,7 @@ BOOL KeybSetAllGroupKey(
     void *pDeviceHandler,
     PSKeyManagement pTable,
     DWORD           dwKeyIndex,
-    unsigned long           uKeyLength,
+	u32 uKeyLength,
     PQWORD          pKeyRSC,
     PBYTE           pbyKey,
     BYTE            byKeyDecMode
@@ -784,7 +800,8 @@ BOOL KeybSetAllGroupKey(
     PSKeyItem   pKey;
     unsigned int        uKeyIdx;
=20
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Enter KeybSetAllGroupKey: %lX\n", d=
wKeyIndex);
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Enter KeybSetAllGroupKey: %X\n",
+		dwKeyIndex);
=20

     if ((dwKeyIndex & PAIRWISE_KEY) !=3D 0) {                  // Pairwise=
 key
@@ -801,7 +818,9 @@ BOOL KeybSetAllGroupKey(
             if ((dwKeyIndex & TRANSMIT_KEY) !=3D 0)  {
                 // Group transmit key
                 pTable->KeyTable[i].dwGTKeyIndex =3D dwKeyIndex;
-                DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Group transmit key(R)[%=
lX]: %d\n", pTable->KeyTable[i].dwGTKeyIndex, i);
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
+			"Group transmit key(R)[%X]: %d\n",
+			pTable->KeyTable[i].dwGTKeyIndex, i);
=20
             }
             pTable->KeyTable[i].wKeyCtl &=3D 0xFF0F;          // clear gro=
up key control filed
diff --git a/drivers/staging/vt6656/key.h b/drivers/staging/vt6656/key.h
index f749c7a..bd35d39 100644
--- a/drivers/staging/vt6656/key.h
+++ b/drivers/staging/vt6656/key.h
@@ -58,7 +58,7 @@
 typedef struct tagSKeyItem
 {
     BOOL        bKeyValid;
-    unsigned long       uKeyLength;
+	u32 uKeyLength;
     BYTE        abyKey[MAX_KEY_LEN];
     QWORD       KeyRSC;
     DWORD       dwTSC47_16;
@@ -107,7 +107,7 @@ BOOL KeybSetKey(
     PSKeyManagement pTable,
     PBYTE           pbyBSSID,
     DWORD           dwKeyIndex,
-    unsigned long           uKeyLength,
+	u32 uKeyLength,
     PQWORD          pKeyRSC,
     PBYTE           pbyKey,
     BYTE            byKeyDecMode
@@ -146,7 +146,7 @@ BOOL KeybSetDefaultKey(
     void *pDeviceHandler,
     PSKeyManagement pTable,
     DWORD           dwKeyIndex,
-    unsigned long           uKeyLength,
+	u32 uKeyLength,
     PQWORD          pKeyRSC,
     PBYTE           pbyKey,
     BYTE            byKeyDecMode
@@ -156,7 +156,7 @@ BOOL KeybSetAllGroupKey(
     void *pDeviceHandler,
     PSKeyManagement pTable,
     DWORD           dwKeyIndex,
-    unsigned long           uKeyLength,
+	u32 uKeyLength,
     PQWORD          pKeyRSC,
     PBYTE           pbyKey,
     BYTE            byKeyDecMode
diff --git a/drivers/staging/vt6656/mac.c b/drivers/staging/vt6656/mac.c
index 26c19d1..0636d82 100644
--- a/drivers/staging/vt6656/mac.c
+++ b/drivers/staging/vt6656/mac.c
@@ -262,7 +262,8 @@ BYTE            pbyData[24];
     dwData1 <<=3D 16;
     dwData1 |=3D MAKEWORD(*(pbyAddr+4), *(pbyAddr+5));
=20
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"1. wOffset: %d, Data: %lX, KeyCtl:%=
X\n", wOffset, dwData1, wKeyCtl);
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"1. wOffset: %d, Data: %X,"\
+		" KeyCtl:%X\n", wOffset, dwData1, wKeyCtl);
=20
     //VNSvOutPortW(dwIoBase + MAC_REG_MISCFFNDEX, wOffset);
     //VNSvOutPortD(dwIoBase + MAC_REG_MISCFFDATA, dwData);
@@ -279,7 +280,8 @@ BYTE            pbyData[24];
     dwData2 <<=3D 8;
     dwData2 |=3D *(pbyAddr+0);
=20
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"2. wOffset: %d, Data: %lX\n", wOffs=
et, dwData2);
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"2. wOffset: %d, Data: %X\n",
+		wOffset, dwData2);
=20
     //VNSvOutPortW(dwIoBase + MAC_REG_MISCFFNDEX, wOffset);
     //VNSvOutPortD(dwIoBase + MAC_REG_MISCFFDATA, dwData);
diff --git a/drivers/staging/vt6656/rf.c b/drivers/staging/vt6656/rf.c
index 3fd0478..8cf0881 100644
--- a/drivers/staging/vt6656/rf.c
+++ b/drivers/staging/vt6656/rf.c
@@ -769,6 +769,9 @@ BYTE    byPwr =3D pDevice->byCCKPwr;
         return TRUE;
     }
=20
+	if (uCH =3D=3D 0)
+		return -EINVAL;
+
     switch (uRATE) {
     case RATE_1M:
     case RATE_2M:
diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index fe21868..3beb126 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -377,7 +377,8 @@ s_vFillTxKey (
         *(pbyIVHead+3) =3D (BYTE)(((pDevice->byKeyIndex << 6) & 0xc0) | 0x=
20); // 0x20 is ExtIV
         // Append IV&ExtIV after Mac Header
         *pdwExtIV =3D cpu_to_le32(pTransmitKey->dwTSC47_16);
-        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"vFillTxKey()---- pdwExtIV: %lx\=
n", *pdwExtIV);
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"vFillTxKey()---- pdwExtIV: %x\n",
+		*pdwExtIV);
=20
     } else if (pTransmitKey->byCipherSuite =3D=3D KEY_CTL_CCMP) {
         pTransmitKey->wTSC15_0++;
@@ -1753,7 +1754,8 @@ s_bPacketToWirelessUsb(
         MIC_vAppend((PBYTE)&(psEthHeader->abyDstAddr[0]), 12);
         dwMIC_Priority =3D 0;
         MIC_vAppend((PBYTE)&dwMIC_Priority, 4);
-        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"MIC KEY: %lX, %lX\n", dwMICKey0=
, dwMICKey1);
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"MIC KEY: %X, %X\n",
+		dwMICKey0, dwMICKey1);
=20
         //////////////////////////////////////////////////////////////////=
/
=20
@@ -2635,7 +2637,8 @@ vDMA0_tx_80211(PSDevice  pDevice, struct sk_buff *skb=
) {
             MIC_vAppend((PBYTE)&(sEthHeader.abyDstAddr[0]), 12);
             dwMIC_Priority =3D 0;
             MIC_vAppend((PBYTE)&dwMIC_Priority, 4);
-            DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"DMA0_tx_8021:MIC KEY: %lX, =
%lX\n", dwMICKey0, dwMICKey1);
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"DMA0_tx_8021:MIC KEY:"\
+			" %X, %X\n", dwMICKey0, dwMICKey1);
=20
             uLength =3D cbHeaderSize + cbMacHdLen + uPadding + cbIVlen;
=20
@@ -2655,7 +2658,8 @@ vDMA0_tx_80211(PSDevice  pDevice, struct sk_buff *skb=
) {
=20
             DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"uLength: %d, %d\n", uLength=
, cbFrameBodySize);
             DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"cbReqCount:%d, %d, %d, %d\n=
", cbReqCount, cbHeaderSize, uPadding, cbIVlen);
-            DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"MIC:%lx, %lx\n", *pdwMIC_L,=
 *pdwMIC_R);
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"MIC:%x, %x\n",
+			*pdwMIC_L, *pdwMIC_R);
=20
         }
=20
@@ -3029,7 +3033,8 @@ int nsDMA_tx_packet(PSDevice pDevice, unsigned int uD=
MAIdx, struct sk_buff *skb)
                         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"error: KEY is G=
TK!!~~\n");
                     }
                     else {
-                        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Find PTK [%lX]\=
n", pTransmitKey->dwKeyIndex);
+			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Find PTK [%X]\n",
+				pTransmitKey->dwKeyIndex);
                         bNeedEncryption =3D TRUE;
                     }
                 }
@@ -3043,7 +3048,8 @@ int nsDMA_tx_packet(PSDevice pDevice, unsigned int uD=
MAIdx, struct sk_buff *skb)
             if (pDevice->bEnableHostWEP) {
                 if ((uNodeIndex !=3D 0) &&
                     (pMgmt->sNodeDBTable[uNodeIndex].dwKeyIndex & PAIRWISE=
_KEY)) {
-                    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Find PTK [%lX]\n", =
pTransmitKey->dwKeyIndex);
+			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Find PTK [%X]\n",
+				pTransmitKey->dwKeyIndex);
                     bNeedEncryption =3D TRUE;
                  }
              }
diff --git a/drivers/staging/vt6656/ttype.h b/drivers/staging/vt6656/ttype.=
h
index 8e9450e..dfbf747 100644
--- a/drivers/staging/vt6656/ttype.h
+++ b/drivers/staging/vt6656/ttype.h
@@ -29,6 +29,8 @@
 #ifndef __TTYPE_H__
 #define __TTYPE_H__
=20
+#include <linux/types.h>
+
 /******* Common definitions and typedefs *********************************=
**/
=20
 typedef int             BOOL;
@@ -42,17 +44,17 @@ typedef int             BOOL;
=20
 /****** Simple typedefs  *************************************************=
**/
=20
-typedef unsigned char   BYTE;           //  8-bit
-typedef unsigned short  WORD;           // 16-bit
-typedef unsigned long   DWORD;          // 32-bit
+typedef u8 BYTE;
+typedef u16 WORD;
+typedef u32 DWORD;
=20
 // QWORD is for those situation that we want
 // an 8-byte-aligned 8 byte long structure
 // which is NOT really a floating point number.
 typedef union tagUQuadWord {
     struct {
-        DWORD   dwLowDword;
-        DWORD   dwHighDword;
+	u32 dwLowDword;
+	u32 dwHighDword;
     } u;
     double      DoNotUseThisField;
 } UQuadWord;
@@ -60,8 +62,8 @@ typedef UQuadWord       QWORD;          // 64-bit
=20
 /****** Common pointer types *********************************************=
**/
=20
-typedef unsigned long   ULONG_PTR;      // 32-bit
-typedef unsigned long   DWORD_PTR;      // 32-bit
+typedef u32 ULONG_PTR;
+typedef u32 DWORD_PTR;
=20
 // boolean pointer
=20
diff --git a/drivers/staging/vt6656/wcmd.c b/drivers/staging/vt6656/wcmd.c
index 78ea121..31fb96a 100644
--- a/drivers/staging/vt6656/wcmd.c
+++ b/drivers/staging/vt6656/wcmd.c
@@ -316,17 +316,19 @@ s_MgrMakeProbeRequest(
     return pTxPacket;
 }
=20
-void vCommandTimerWait(void *hDeviceContext, unsigned int MSecond)
+void vCommandTimerWait(void *hDeviceContext, unsigned long MSecond)
 {
-    PSDevice        pDevice =3D (PSDevice)hDeviceContext;
+	PSDevice pDevice =3D (PSDevice)hDeviceContext;
=20
-    init_timer(&pDevice->sTimerCommand);
-    pDevice->sTimerCommand.data =3D (unsigned long)pDevice;
-    pDevice->sTimerCommand.function =3D (TimerFunction)vRunCommand;
-    // RUN_AT :1 msec ~=3D (HZ/1024)
-    pDevice->sTimerCommand.expires =3D (unsigned int)RUN_AT((MSecond * HZ)=
 >> 10);
-    add_timer(&pDevice->sTimerCommand);
-    return;
+	init_timer(&pDevice->sTimerCommand);
+
+	pDevice->sTimerCommand.data =3D (unsigned long)pDevice;
+	pDevice->sTimerCommand.function =3D (TimerFunction)vRunCommand;
+	pDevice->sTimerCommand.expires =3D RUN_AT((MSecond * HZ) / 1000);
+
+	add_timer(&pDevice->sTimerCommand);
+
+	return;
 }
=20
 void vRunCommand(void *hDeviceContext)
diff --git a/drivers/staging/vt6656/wpa2.h b/drivers/staging/vt6656/wpa2.h
index 46c2959..c359252 100644
--- a/drivers/staging/vt6656/wpa2.h
+++ b/drivers/staging/vt6656/wpa2.h
@@ -45,8 +45,8 @@ typedef struct tagsPMKIDInfo {
 } PMKIDInfo, *PPMKIDInfo;
=20
 typedef struct tagSPMKIDCache {
-    unsigned long       BSSIDInfoCount;
-    PMKIDInfo   BSSIDInfo[MAX_PMKID_CACHE];
+	u32 BSSIDInfoCount;
+	PMKIDInfo BSSIDInfo[MAX_PMKID_CACHE];
 } SPMKIDCache, *PSPMKIDCache;
=20

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/isc=
si_target.c
index 6fa7222..3effde2 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -2367,7 +2367,7 @@ static void iscsit_build_conn_drop_async_message(stru=
ct iscsi_conn *conn)
 	if (!conn_p)
 		return;
=20
-	cmd =3D iscsit_allocate_cmd(conn_p, GFP_KERNEL);
+	cmd =3D iscsit_allocate_cmd(conn_p, GFP_ATOMIC);
 	if (!cmd) {
 		iscsit_dec_conn_usage_count(conn_p);
 		return;
diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/isc=
si/iscsi_target_login.c
index eb0c9fe..0df4a5f 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -130,13 +130,13 @@ int iscsi_check_for_session_reinstatement(struct iscs=
i_conn *conn)
=20
 	initiatorname_param =3D iscsi_find_param_from_key(
 			INITIATORNAME, conn->param_list);
-	if (!initiatorname_param)
-		return -1;
-
 	sessiontype_param =3D iscsi_find_param_from_key(
 			SESSIONTYPE, conn->param_list);
-	if (!sessiontype_param)
+	if (!initiatorname_param || !sessiontype_param) {
+		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
+			ISCSI_LOGIN_STATUS_MISSING_FIELDS);
 		return -1;
+	}
=20
 	sessiontype =3D (strncmp(sessiontype_param->value, NORMAL, 6)) ? 1 : 0;
=20
diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscs=
i/iscsi_target_nego.c
index 98936cb..7d85f88 100644
--- a/drivers/target/iscsi/iscsi_target_nego.c
+++ b/drivers/target/iscsi/iscsi_target_nego.c
@@ -632,8 +632,11 @@ static int iscsi_target_handle_csg_one(struct iscsi_co=
nn *conn, struct iscsi_log
 			login->req_buf,
 			payload_length,
 			conn->param_list);
-	if (ret < 0)
+	if (ret < 0) {
+		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
+				ISCSI_LOGIN_STATUS_INIT_ERR);
 		return -1;
+	}
=20
 	if (login->first_request)
 		if (iscsi_target_check_first_request(conn, login) < 0)
@@ -648,8 +651,11 @@ static int iscsi_target_handle_csg_one(struct iscsi_co=
nn *conn, struct iscsi_log
 			login->rsp_buf,
 			&login->rsp_length,
 			conn->param_list);
-	if (ret < 0)
+	if (ret < 0) {
+		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
+				ISCSI_LOGIN_STATUS_INIT_ERR);
 		return -1;
+	}
=20
 	if (!login->auth_complete &&
 	     ISCSI_TPG_ATTRIB(ISCSI_TPG_C(conn))->authentication) {
diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core=
_file.c
index cafa477..ea29eaf 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -300,7 +300,7 @@ static int fd_do_readv(struct se_task *task)
=20
 	for_each_sg(task->task_sg, sg, task->task_sg_nents, i) {
 		iov[i].iov_len =3D sg->length;
-		iov[i].iov_base =3D sg_virt(sg);
+		iov[i].iov_base =3D kmap(sg_page(sg)) + sg->offset;
 	}
=20
 	old_fs =3D get_fs();
@@ -308,6 +308,8 @@ static int fd_do_readv(struct se_task *task)
 	ret =3D vfs_readv(fd, &iov[0], task->task_sg_nents, &pos);
 	set_fs(old_fs);
=20
+	for_each_sg(task->task_sg, sg, task->task_sg_nents, i)
+		kunmap(sg_page(sg));
 	kfree(iov);
 	/*
 	 * Return zeros and GOOD status even if the READ did not return
@@ -353,7 +355,7 @@ static int fd_do_writev(struct se_task *task)
=20
 	for_each_sg(task->task_sg, sg, task->task_sg_nents, i) {
 		iov[i].iov_len =3D sg->length;
-		iov[i].iov_base =3D sg_virt(sg);
+		iov[i].iov_base =3D kmap(sg_page(sg)) + sg->offset;
 	}
=20
 	old_fs =3D get_fs();
@@ -361,6 +363,9 @@ static int fd_do_writev(struct se_task *task)
 	ret =3D vfs_writev(fd, &iov[0], task->task_sg_nents, &pos);
 	set_fs(old_fs);
=20
+	for_each_sg(task->task_sg, sg, task->task_sg_nents, i)
+		kunmap(sg_page(sg));
+
 	kfree(iov);
=20
 	if (ret < 0 || ret !=3D task->task_size) {
diff --git a/drivers/target/tcm_fc/tfc_sess.c b/drivers/target/tcm_fc/tfc_s=
ess.c
index 64ddb63..3f28fdb 100644
--- a/drivers/target/tcm_fc/tfc_sess.c
+++ b/drivers/target/tcm_fc/tfc_sess.c
@@ -465,7 +465,6 @@ static void ft_sess_rcu_free(struct rcu_head *rcu)
 {
 	struct ft_sess *sess =3D container_of(rcu, struct ft_sess, rcu);
=20
-	transport_deregister_session(sess->se_sess);
 	kfree(sess);
 }
=20
@@ -473,6 +472,7 @@ static void ft_sess_free(struct kref *kref)
 {
 	struct ft_sess *sess =3D container_of(kref, struct ft_sess, kref);
=20
+	transport_deregister_session(sess->se_sess);
 	call_rcu(&sess->rcu, ft_sess_rcu_free);
 }
=20
diff --git a/drivers/telephony/ixj.c b/drivers/telephony/ixj.c
index d5f923b..e1abb45 100644
--- a/drivers/telephony/ixj.c
+++ b/drivers/telephony/ixj.c
@@ -3190,12 +3190,12 @@ static void ixj_write_cid(IXJ *j)
=20
 	ixj_fsk_alloc(j);
=20
-	strcpy(sdmf1, j->cid_send.month);
-	strcat(sdmf1, j->cid_send.day);
-	strcat(sdmf1, j->cid_send.hour);
-	strcat(sdmf1, j->cid_send.min);
-	strcpy(sdmf2, j->cid_send.number);
-	strcpy(sdmf3, j->cid_send.name);
+	strlcpy(sdmf1, j->cid_send.month, sizeof(sdmf1));
+	strlcat(sdmf1, j->cid_send.day, sizeof(sdmf1));
+	strlcat(sdmf1, j->cid_send.hour, sizeof(sdmf1));
+	strlcat(sdmf1, j->cid_send.min, sizeof(sdmf1));
+	strlcpy(sdmf2, j->cid_send.number, sizeof(sdmf2));
+	strlcpy(sdmf3, j->cid_send.name, sizeof(sdmf3));
=20
 	len1 =3D strlen(sdmf1);
 	len2 =3D strlen(sdmf2);
@@ -3340,12 +3340,12 @@ static void ixj_write_cidcw(IXJ *j)
 		ixj_pre_cid(j);
 	}
 	j->flags.cidcw_ack =3D 0;
-	strcpy(sdmf1, j->cid_send.month);
-	strcat(sdmf1, j->cid_send.day);
-	strcat(sdmf1, j->cid_send.hour);
-	strcat(sdmf1, j->cid_send.min);
-	strcpy(sdmf2, j->cid_send.number);
-	strcpy(sdmf3, j->cid_send.name);
+	strlcpy(sdmf1, j->cid_send.month, sizeof(sdmf1));
+	strlcat(sdmf1, j->cid_send.day, sizeof(sdmf1));
+	strlcat(sdmf1, j->cid_send.hour, sizeof(sdmf1));
+	strlcat(sdmf1, j->cid_send.min, sizeof(sdmf1));
+	strlcpy(sdmf2, j->cid_send.number, sizeof(sdmf2));
+	strlcpy(sdmf3, j->cid_send.name, sizeof(sdmf3));
=20
 	len1 =3D strlen(sdmf1);
 	len2 =3D strlen(sdmf2);
diff --git a/drivers/usb/class/cdc-wdm.c b/drivers/usb/class/cdc-wdm.c
index 9aaed0d..97b2c55 100644
--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -301,7 +301,7 @@ static void cleanup(struct wdm_device *desc)
 			  desc->sbuf,
 			  desc->validity->transfer_dma);
 	usb_free_coherent(interface_to_usbdev(desc->intf),
-			  desc->bMaxPacketSize0,
+			  desc->wMaxCommand,
 			  desc->inbuf,
 			  desc->response->transfer_dma);
 	kfree(desc->orq);
@@ -788,7 +788,7 @@ out:
 err3:
 	usb_set_intfdata(intf, NULL);
 	usb_free_coherent(interface_to_usbdev(desc->intf),
-			  desc->bMaxPacketSize0,
+			  desc->wMaxCommand,
 			desc->inbuf,
 			desc->response->transfer_dma);
 err2:
diff --git a/drivers/usb/core/message.c b/drivers/usb/core/message.c
index ef116a5..ab11ca3c 100644
--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -1770,28 +1770,8 @@ free_interfaces:
 		goto free_interfaces;
 	}
=20
-	ret =3D usb_control_msg(dev, usb_sndctrlpipe(dev, 0),
-			      USB_REQ_SET_CONFIGURATION, 0, configuration, 0,
-			      NULL, 0, USB_CTRL_SET_TIMEOUT);
-	if (ret < 0) {
-		/* All the old state is gone, so what else can we do?
-		 * The device is probably useless now anyway.
-		 */
-		cp =3D NULL;
-	}
-
-	dev->actconfig =3D cp;
-	if (!cp) {
-		usb_set_device_state(dev, USB_STATE_ADDRESS);
-		usb_hcd_alloc_bandwidth(dev, NULL, NULL, NULL);
-		mutex_unlock(hcd->bandwidth_mutex);
-		usb_autosuspend_device(dev);
-		goto free_interfaces;
-	}
-	mutex_unlock(hcd->bandwidth_mutex);
-	usb_set_device_state(dev, USB_STATE_CONFIGURED);
-
-	/* Initialize the new interface structures and the
+	/*
+	 * Initialize the new interface structures and the
 	 * hc/hcd/usbcore interface/endpoint state.
 	 */
 	for (i =3D 0; i < nintf; ++i) {
@@ -1835,6 +1815,35 @@ free_interfaces:
 	}
 	kfree(new_interfaces);
=20
+	ret =3D usb_control_msg(dev, usb_sndctrlpipe(dev, 0),
+			      USB_REQ_SET_CONFIGURATION, 0, configuration, 0,
+			      NULL, 0, USB_CTRL_SET_TIMEOUT);
+	if (ret < 0 && cp) {
+		/*
+		 * All the old state is gone, so what else can we do?
+		 * The device is probably useless now anyway.
+		 */
+		usb_hcd_alloc_bandwidth(dev, NULL, NULL, NULL);
+		for (i =3D 0; i < nintf; ++i) {
+			usb_disable_interface(dev, cp->interface[i], true);
+			put_device(&cp->interface[i]->dev);
+			cp->interface[i] =3D NULL;
+		}
+		cp =3D NULL;
+	}
+
+	dev->actconfig =3D cp;
+	mutex_unlock(hcd->bandwidth_mutex);
+
+	if (!cp) {
+		usb_set_device_state(dev, USB_STATE_ADDRESS);
+
+		/* Leave LPM disabled while the device is unconfigured. */
+		usb_autosuspend_device(dev);
+		return ret;
+	}
+	usb_set_device_state(dev, USB_STATE_CONFIGURED);
+
 	if (cp->string =3D=3D NULL &&
 			!(dev->quirks & USB_QUIRK_CONFIG_INTF_STRINGS))
 		cp->string =3D usb_cache_string(dev, cp->desc.iConfiguration);
diff --git a/drivers/usb/gadget/f_ecm.c b/drivers/usb/gadget/f_ecm.c
index 11c07cb..72fd355 100644
--- a/drivers/usb/gadget/f_ecm.c
+++ b/drivers/usb/gadget/f_ecm.c
@@ -790,9 +790,9 @@ fail:
 	/* we might as well release our claims on endpoints */
 	if (ecm->notify)
 		ecm->notify->driver_data =3D NULL;
-	if (ecm->port.out_ep->desc)
+	if (ecm->port.out_ep)
 		ecm->port.out_ep->driver_data =3D NULL;
-	if (ecm->port.in_ep->desc)
+	if (ecm->port.in_ep)
 		ecm->port.in_ep->driver_data =3D NULL;
=20
 	ERROR(cdev, "%s: can't bind, err %d\n", f->name, status);
diff --git a/drivers/usb/gadget/f_eem.c b/drivers/usb/gadget/f_eem.c
index 1a7b2dd..a9cf2052 100644
--- a/drivers/usb/gadget/f_eem.c
+++ b/drivers/usb/gadget/f_eem.c
@@ -319,10 +319,9 @@ fail:
 	if (f->hs_descriptors)
 		usb_free_descriptors(f->hs_descriptors);
=20
-	/* we might as well release our claims on endpoints */
-	if (eem->port.out_ep->desc)
+	if (eem->port.out_ep)
 		eem->port.out_ep->driver_data =3D NULL;
-	if (eem->port.in_ep->desc)
+	if (eem->port.in_ep)
 		eem->port.in_ep->driver_data =3D NULL;
=20
 	ERROR(cdev, "%s: can't bind, err %d\n", f->name, status);
diff --git a/drivers/usb/gadget/f_midi.c b/drivers/usb/gadget/f_midi.c
index 3797b3d..dfd7b98 100644
--- a/drivers/usb/gadget/f_midi.c
+++ b/drivers/usb/gadget/f_midi.c
@@ -416,6 +416,7 @@ static void f_midi_unbind(struct usb_configuration *c, =
struct usb_function *f)
 	midi->id =3D NULL;
=20
 	usb_free_descriptors(f->descriptors);
+	usb_free_descriptors(f->hs_descriptors);
 	kfree(midi);
 }
=20
diff --git a/drivers/usb/gadget/f_ncm.c b/drivers/usb/gadget/f_ncm.c
index aab8ede..d7811ae 100644
--- a/drivers/usb/gadget/f_ncm.c
+++ b/drivers/usb/gadget/f_ncm.c
@@ -1259,9 +1259,9 @@ fail:
 	/* we might as well release our claims on endpoints */
 	if (ncm->notify)
 		ncm->notify->driver_data =3D NULL;
-	if (ncm->port.out_ep->desc)
+	if (ncm->port.out_ep)
 		ncm->port.out_ep->driver_data =3D NULL;
-	if (ncm->port.in_ep->desc)
+	if (ncm->port.in_ep)
 		ncm->port.in_ep->driver_data =3D NULL;
=20
 	ERROR(cdev, "%s: can't bind, err %d\n", f->name, status);
diff --git a/drivers/usb/gadget/f_phonet.c b/drivers/usb/gadget/f_phonet.c
index 16a509a..5431493 100644
--- a/drivers/usb/gadget/f_phonet.c
+++ b/drivers/usb/gadget/f_phonet.c
@@ -532,7 +532,7 @@ int pn_bind(struct usb_configuration *c, struct usb_fun=
ction *f)
=20
 		req =3D usb_ep_alloc_request(fp->out_ep, GFP_KERNEL);
 		if (!req)
-			goto err;
+			goto err_req;
=20
 		req->complete =3D pn_rx_complete;
 		fp->out_reqv[i] =3D req;
@@ -541,14 +541,18 @@ int pn_bind(struct usb_configuration *c, struct usb_f=
unction *f)
 	/* Outgoing USB requests */
 	fp->in_req =3D usb_ep_alloc_request(fp->in_ep, GFP_KERNEL);
 	if (!fp->in_req)
-		goto err;
+		goto err_req;
=20
 	INFO(cdev, "USB CDC Phonet function\n");
 	INFO(cdev, "using %s, OUT %s, IN %s\n", cdev->gadget->name,
 		fp->out_ep->name, fp->in_ep->name);
 	return 0;
=20
+err_req:
+	for (i =3D 0; i < phonet_rxq_size && fp->out_reqv[i]; i++)
+		usb_ep_free_request(fp->out_ep, fp->out_reqv[i]);
 err:
+
 	if (fp->out_ep)
 		fp->out_ep->driver_data =3D NULL;
 	if (fp->in_ep)
diff --git a/drivers/usb/gadget/f_rndis.c b/drivers/usb/gadget/f_rndis.c
index 704d1d9..817d611 100644
--- a/drivers/usb/gadget/f_rndis.c
+++ b/drivers/usb/gadget/f_rndis.c
@@ -802,9 +802,9 @@ fail:
 	/* we might as well release our claims on endpoints */
 	if (rndis->notify)
 		rndis->notify->driver_data =3D NULL;
-	if (rndis->port.out_ep->desc)
+	if (rndis->port.out_ep)
 		rndis->port.out_ep->driver_data =3D NULL;
-	if (rndis->port.in_ep->desc)
+	if (rndis->port.in_ep)
 		rndis->port.in_ep->driver_data =3D NULL;
=20
 	ERROR(cdev, "%s: can't bind, err %d\n", f->name, status);
diff --git a/drivers/usb/gadget/f_subset.c b/drivers/usb/gadget/f_subset.c
index 21ab474..e5bb966 100644
--- a/drivers/usb/gadget/f_subset.c
+++ b/drivers/usb/gadget/f_subset.c
@@ -370,9 +370,9 @@ fail:
 		usb_free_descriptors(f->hs_descriptors);
=20
 	/* we might as well release our claims on endpoints */
-	if (geth->port.out_ep->desc)
+	if (geth->port.out_ep)
 		geth->port.out_ep->driver_data =3D NULL;
-	if (geth->port.in_ep->desc)
+	if (geth->port.in_ep)
 		geth->port.in_ep->driver_data =3D NULL;
=20
 	ERROR(cdev, "%s: can't bind, err %d\n", f->name, status);
diff --git a/drivers/usb/gadget/f_uvc.c b/drivers/usb/gadget/f_uvc.c
index 2022fe49..a0abc65 100644
--- a/drivers/usb/gadget/f_uvc.c
+++ b/drivers/usb/gadget/f_uvc.c
@@ -335,7 +335,6 @@ uvc_register_video(struct uvc_device *uvc)
 		return -ENOMEM;
=20
 	video->parent =3D &cdev->gadget->dev;
-	video->minor =3D -1;
 	video->fops =3D &uvc_v4l2_fops;
 	video->release =3D video_device_release;
 	strncpy(video->name, cdev->gadget->name, sizeof(video->name));
@@ -462,23 +461,12 @@ uvc_function_unbind(struct usb_configuration *c, stru=
ct usb_function *f)
=20
 	INFO(cdev, "uvc_function_unbind\n");
=20
-	if (uvc->vdev) {
-		if (uvc->vdev->minor =3D=3D -1)
-			video_device_release(uvc->vdev);
-		else
-			video_unregister_device(uvc->vdev);
-		uvc->vdev =3D NULL;
-	}
-
-	if (uvc->control_ep)
-		uvc->control_ep->driver_data =3D NULL;
-	if (uvc->video.ep)
-		uvc->video.ep->driver_data =3D NULL;
+	video_unregister_device(uvc->vdev);
+	uvc->control_ep->driver_data =3D NULL;
+	uvc->video.ep->driver_data =3D NULL;
=20
-	if (uvc->control_req) {
-		usb_ep_free_request(cdev->gadget->ep0, uvc->control_req);
-		kfree(uvc->control_buf);
-	}
+	usb_ep_free_request(cdev->gadget->ep0, uvc->control_req);
+	kfree(uvc->control_buf);
=20
 	kfree(f->descriptors);
 	kfree(f->hs_descriptors);
@@ -563,7 +551,22 @@ uvc_function_bind(struct usb_configuration *c, struct =
usb_function *f)
 	return 0;
=20
 error:
-	uvc_function_unbind(c, f);
+	if (uvc->vdev)
+		video_device_release(uvc->vdev);
+
+	if (uvc->control_ep)
+		uvc->control_ep->driver_data =3D NULL;
+	if (uvc->video.ep)
+		uvc->video.ep->driver_data =3D NULL;
+
+	if (uvc->control_req) {
+		usb_ep_free_request(cdev->gadget->ep0, uvc->control_req);
+		kfree(uvc->control_buf);
+	}
+
+	kfree(f->descriptors);
+	kfree(f->hs_descriptors);
+	kfree(f->ss_descriptors);
 	return ret;
 }
=20
diff --git a/drivers/usb/host/ehci-pci.c b/drivers/usb/host/ehci-pci.c
index a79e64b..b71e22e 100644
--- a/drivers/usb/host/ehci-pci.c
+++ b/drivers/usb/host/ehci-pci.c
@@ -359,7 +359,8 @@ static bool usb_is_intel_switchable_ehci(struct pci_dev=
 *pdev)
 		pdev->vendor =3D=3D PCI_VENDOR_ID_INTEL &&
 		(pdev->device =3D=3D 0x1E26 ||
 		 pdev->device =3D=3D 0x8C2D ||
-		 pdev->device =3D=3D 0x8C26);
+		 pdev->device =3D=3D 0x8C26 ||
+		 pdev->device =3D=3D 0x9C26);
 }
=20
 static void ehci_enable_xhci_companion(void)
diff --git a/drivers/usb/host/ehci-q.c b/drivers/usb/host/ehci-q.c
index 2023733..5bb2dcb 100644
--- a/drivers/usb/host/ehci-q.c
+++ b/drivers/usb/host/ehci-q.c
@@ -264,18 +264,14 @@ ehci_urb_done(struct ehci_hcd *ehci, struct urb *urb,=
 int status)
 __releases(ehci->lock)
 __acquires(ehci->lock)
 {
-	if (likely (urb->hcpriv !=3D NULL)) {
-		struct ehci_qh	*qh =3D (struct ehci_qh *) urb->hcpriv;
-
-		/* S-mask in a QH means it's an interrupt urb */
-		if ((qh->hw->hw_info2 & cpu_to_hc32(ehci, QH_SMASK)) !=3D 0) {
-
-			/* ... update hc-wide periodic stats (for usbfs) */
-			ehci_to_hcd(ehci)->self.bandwidth_int_reqs--;
-		}
-		qh_put (qh);
+	if (usb_pipetype(urb->pipe) =3D=3D PIPE_INTERRUPT) {
+		/* ... update hc-wide periodic stats */
+		ehci_to_hcd(ehci)->self.bandwidth_int_reqs--;
 	}
=20
+	if (usb_pipetype(urb->pipe) !=3D PIPE_ISOCHRONOUS)
+		qh_put((struct ehci_qh *) urb->hcpriv);
+
 	if (unlikely(urb->unlinked)) {
 		COUNT(ehci->stats.unlink);
 	} else {
diff --git a/drivers/usb/host/ehci-sched.c b/drivers/usb/host/ehci-sched.c
index a60679c..34655d0 100644
--- a/drivers/usb/host/ehci-sched.c
+++ b/drivers/usb/host/ehci-sched.c
@@ -1684,7 +1684,7 @@ itd_link_urb (
=20
 	/* don't need that schedule data any more */
 	iso_sched_free (stream, iso_sched);
-	urb->hcpriv =3D NULL;
+	urb->hcpriv =3D stream;
=20
 	timer_action (ehci, TIMER_IO_WATCHDOG);
 	return enable_periodic(ehci);
@@ -2094,7 +2094,7 @@ sitd_link_urb (
=20
 	/* don't need that schedule data any more */
 	iso_sched_free (stream, sched);
-	urb->hcpriv =3D NULL;
+	urb->hcpriv =3D stream;
=20
 	timer_action (ehci, TIMER_IO_WATCHDOG);
 	return enable_periodic(ehci);
diff --git a/drivers/usb/host/ohci-q.c b/drivers/usb/host/ohci-q.c
index 15dc51d..e0ae777 100644
--- a/drivers/usb/host/ohci-q.c
+++ b/drivers/usb/host/ohci-q.c
@@ -1130,6 +1130,25 @@ dl_done_list (struct ohci_hcd *ohci)
=20
 	while (td) {
 		struct td	*td_next =3D td->next_dl_td;
+		struct ed	*ed =3D td->ed;
+
+		/*
+		 * Some OHCI controllers (NVIDIA for sure, maybe others)
+		 * occasionally forget to add TDs to the done queue.  Since
+		 * TDs for a given endpoint are always processed in order,
+		 * if we find a TD on the donelist then all of its
+		 * predecessors must be finished as well.
+		 */
+		for (;;) {
+			struct td	*td2;
+
+			td2 =3D list_first_entry(&ed->td_list, struct td,
+					td_list);
+			if (td2 =3D=3D td)
+				break;
+			takeback_td(ohci, td2);
+		}
+
 		takeback_td(ohci, td);
 		td =3D td_next;
 	}
diff --git a/drivers/usb/host/pci-quirks.c b/drivers/usb/host/pci-quirks.c
index c2815a5..5cc401b 100644
--- a/drivers/usb/host/pci-quirks.c
+++ b/drivers/usb/host/pci-quirks.c
@@ -723,6 +723,7 @@ static int handshake(void __iomem *ptr, u32 mask, u32 d=
one,
 }
=20
 #define PCI_DEVICE_ID_INTEL_LYNX_POINT_XHCI	0x8C31
+#define PCI_DEVICE_ID_INTEL_LYNX_POINT_LP_XHCI	0x9C31
=20
 bool usb_is_intel_ppt_switchable_xhci(struct pci_dev *pdev)
 {
@@ -736,7 +737,8 @@ bool usb_is_intel_lpt_switchable_xhci(struct pci_dev *p=
dev)
 {
 	return pdev->class =3D=3D PCI_CLASS_SERIAL_USB_XHCI &&
 		pdev->vendor =3D=3D PCI_VENDOR_ID_INTEL &&
-		pdev->device =3D=3D PCI_DEVICE_ID_INTEL_LYNX_POINT_XHCI;
+		(pdev->device =3D=3D PCI_DEVICE_ID_INTEL_LYNX_POINT_XHCI ||
+		 pdev->device =3D=3D PCI_DEVICE_ID_INTEL_LYNX_POINT_LP_XHCI);
 }
=20
 bool usb_is_intel_switchable_xhci(struct pci_dev *pdev)
diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
index 4cddbfc..5719c4d 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -178,8 +178,15 @@ static struct xhci_ring *xhci_ring_alloc(struct xhci_h=
cd *xhci,
 		struct xhci_segment	*next;
=20
 		next =3D xhci_segment_alloc(xhci, flags);
-		if (!next)
+		if (!next) {
+			prev =3D ring->first_seg;
+			while (prev) {
+				next =3D prev->next;
+				xhci_segment_free(xhci, prev);
+				prev =3D next;
+			}
 			goto fail;
+		}
 		xhci_link_segments(xhci, prev, next, link_trbs, isoc);
=20
 		prev =3D next;
@@ -199,7 +206,7 @@ static struct xhci_ring *xhci_ring_alloc(struct xhci_hc=
d *xhci,
 	return ring;
=20
 fail:
-	xhci_ring_free(xhci, ring);
+	kfree(ring);
 	return NULL;
 }
=20
diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index 4ed7572..aca647a 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -29,6 +29,7 @@
 /* Device for a quirk */
 #define PCI_VENDOR_ID_FRESCO_LOGIC	0x1b73
 #define PCI_DEVICE_ID_FRESCO_LOGIC_PDK	0x1000
+#define PCI_DEVICE_ID_FRESCO_LOGIC_FL1400	0x1400
=20
 #define PCI_VENDOR_ID_ETRON		0x1b6f
 #define PCI_DEVICE_ID_ASROCK_P67	0x7023
@@ -58,8 +59,10 @@ static void xhci_pci_quirks(struct device *dev, struct x=
hci_hcd *xhci)
=20
 	/* Look for vendor-specific quirks */
 	if (pdev->vendor =3D=3D PCI_VENDOR_ID_FRESCO_LOGIC &&
-			pdev->device =3D=3D PCI_DEVICE_ID_FRESCO_LOGIC_PDK) {
-		if (pdev->revision =3D=3D 0x0) {
+			(pdev->device =3D=3D PCI_DEVICE_ID_FRESCO_LOGIC_PDK ||
+			 pdev->device =3D=3D PCI_DEVICE_ID_FRESCO_LOGIC_FL1400)) {
+		if (pdev->device =3D=3D PCI_DEVICE_ID_FRESCO_LOGIC_PDK &&
+				pdev->revision =3D=3D 0x0) {
 			xhci->quirks |=3D XHCI_RESET_EP_QUIRK;
 			xhci_dbg(xhci, "QUIRK: Fresco Logic xHC needs configure"
 					" endpoint cmd after reset endpoint\n");
diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 7de9993..1ba98f5 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -2995,11 +2995,11 @@ static u32 xhci_td_remainder(unsigned int remainder=
)
 }
=20
 /*
- * For xHCI 1.0 host controllers, TD size is the number of packets remaini=
ng in
- * the TD (*not* including this TRB).
+ * For xHCI 1.0 host controllers, TD size is the number of max packet size=
d
+ * packets remaining in the TD (*not* including this TRB).
  *
  * Total TD packet count =3D total_packet_count =3D
- *     roundup(TD size in bytes / wMaxPacketSize)
+ *     DIV_ROUND_UP(TD size in bytes / wMaxPacketSize)
  *
  * Packets transferred up to and including this TRB =3D packets_transferre=
d =3D
  *     rounddown(total bytes transferred including this TRB / wMaxPacketSi=
ze)
@@ -3007,15 +3007,16 @@ static u32 xhci_td_remainder(unsigned int remainder=
)
  * TD size =3D total_packet_count - packets_transferred
  *
  * It must fit in bits 21:17, so it can't be bigger than 31.
+ * The last TRB in a TD must have the TD size set to zero.
  */
-
 static u32 xhci_v1_0_td_remainder(int running_total, int trb_buff_len,
-		unsigned int total_packet_count, struct urb *urb)
+		unsigned int total_packet_count, struct urb *urb,
+		unsigned int num_trbs_left)
 {
 	int packets_transferred;
=20
 	/* One TRB with a zero-length data packet. */
-	if (running_total =3D=3D 0 && trb_buff_len =3D=3D 0)
+	if (num_trbs_left =3D=3D 0 || (running_total =3D=3D 0 && trb_buff_len =3D=
=3D 0))
 		return 0;
=20
 	/* All the TRB queueing functions don't count the current TRB in
@@ -3024,7 +3025,9 @@ static u32 xhci_v1_0_td_remainder(int running_total, =
int trb_buff_len,
 	packets_transferred =3D (running_total + trb_buff_len) /
 		usb_endpoint_maxp(&urb->ep->desc);
=20
-	return xhci_td_remainder(total_packet_count - packets_transferred);
+	if ((total_packet_count - packets_transferred) > 31)
+		return 31 << 17;
+	return (total_packet_count - packets_transferred) << 17;
 }
=20
 static int queue_bulk_sg_tx(struct xhci_hcd *xhci, gfp_t mem_flags,
@@ -3051,7 +3054,7 @@ static int queue_bulk_sg_tx(struct xhci_hcd *xhci, gf=
p_t mem_flags,
=20
 	num_trbs =3D count_sg_trbs_needed(xhci, urb);
 	num_sgs =3D urb->num_mapped_sgs;
-	total_packet_count =3D roundup(urb->transfer_buffer_length,
+	total_packet_count =3D DIV_ROUND_UP(urb->transfer_buffer_length,
 			usb_endpoint_maxp(&urb->ep->desc));
=20
 	trb_buff_len =3D prepare_transfer(xhci, xhci->devs[slot_id],
@@ -3141,7 +3144,8 @@ static int queue_bulk_sg_tx(struct xhci_hcd *xhci, gf=
p_t mem_flags,
 					running_total);
 		} else {
 			remainder =3D xhci_v1_0_td_remainder(running_total,
-					trb_buff_len, total_packet_count, urb);
+					trb_buff_len, total_packet_count, urb,
+					num_trbs - 1);
 		}
 		length_field =3D TRB_LEN(trb_buff_len) |
 			remainder |
@@ -3258,7 +3262,7 @@ int xhci_queue_bulk_tx(struct xhci_hcd *xhci, gfp_t m=
em_flags,
 	start_cycle =3D ep_ring->cycle_state;
=20
 	running_total =3D 0;
-	total_packet_count =3D roundup(urb->transfer_buffer_length,
+	total_packet_count =3D DIV_ROUND_UP(urb->transfer_buffer_length,
 			usb_endpoint_maxp(&urb->ep->desc));
 	/* How much data is in the first TRB? */
 	addr =3D (u64) urb->transfer_dma;
@@ -3304,7 +3308,8 @@ int xhci_queue_bulk_tx(struct xhci_hcd *xhci, gfp_t m=
em_flags,
 					running_total);
 		} else {
 			remainder =3D xhci_v1_0_td_remainder(running_total,
-					trb_buff_len, total_packet_count, urb);
+					trb_buff_len, total_packet_count, urb,
+					num_trbs - 1);
 		}
 		length_field =3D TRB_LEN(trb_buff_len) |
 			remainder |
@@ -3579,7 +3584,7 @@ static int xhci_queue_isoc_tx(struct xhci_hcd *xhci, =
gfp_t mem_flags,
 		addr =3D start_addr + urb->iso_frame_desc[i].offset;
 		td_len =3D urb->iso_frame_desc[i].length;
 		td_remain_len =3D td_len;
-		total_packet_count =3D roundup(td_len,
+		total_packet_count =3D DIV_ROUND_UP(td_len,
 				usb_endpoint_maxp(&urb->ep->desc));
 		/* A zero-length transfer still involves at least one packet. */
 		if (total_packet_count =3D=3D 0)
@@ -3659,7 +3664,8 @@ static int xhci_queue_isoc_tx(struct xhci_hcd *xhci, =
gfp_t mem_flags,
 			} else {
 				remainder =3D xhci_v1_0_td_remainder(
 						running_total, trb_buff_len,
-						total_packet_count, urb);
+						total_packet_count, urb,
+						(trbs_per_td - j - 1));
 			}
 			length_field =3D TRB_LEN(trb_buff_len) |
 				remainder |
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index dab05d1..9dc5870 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -472,7 +472,7 @@ static bool compliance_mode_recovery_timer_quirk_check(=
void)
 	if (strstr(dmi_product_name, "Z420") ||
 			strstr(dmi_product_name, "Z620") ||
 			strstr(dmi_product_name, "Z820") ||
-			strstr(dmi_product_name, "Z1"))
+			strstr(dmi_product_name, "Z1 Workstation"))
 		return true;
=20
 	return false;
@@ -2241,7 +2241,7 @@ static bool xhci_is_async_ep(unsigned int ep_type)
=20
 static bool xhci_is_sync_in_ep(unsigned int ep_type)
 {
-	return (ep_type =3D=3D ISOC_IN_EP || ep_type !=3D INT_IN_EP);
+	return (ep_type =3D=3D ISOC_IN_EP || ep_type =3D=3D INT_IN_EP);
 }
=20
 static unsigned int xhci_get_ss_bw_consumed(struct xhci_bw_info *ep_bw)
diff --git a/drivers/usb/musb/cppi_dma.c b/drivers/usb/musb/cppi_dma.c
index 318fb4e..64d7b38 100644
--- a/drivers/usb/musb/cppi_dma.c
+++ b/drivers/usb/musb/cppi_dma.c
@@ -1313,6 +1313,7 @@ irqreturn_t cppi_interrupt(int irq, void *dev_id)
=20
 	return IRQ_HANDLED;
 }
+EXPORT_SYMBOL_GPL(cppi_interrupt);
=20
 /* Instantiate a software object representing a DMA controller. */
 struct dma_controller *__init
diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
index 35e6b5f..381d00d 100644
--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -120,6 +120,7 @@ static const struct usb_device_id id_table[] =3D {
 	{ USB_DEVICE(0x10C4, 0x8477) }, /* Balluff RFID */
 	{ USB_DEVICE(0x10C4, 0x85EA) }, /* AC-Services IBUS-IF */
 	{ USB_DEVICE(0x10C4, 0x85EB) }, /* AC-Services CIS-IBUS */
+	{ USB_DEVICE(0x10C4, 0x85F8) }, /* Virtenio Preon32 */
 	{ USB_DEVICE(0x10C4, 0x8664) }, /* AC-Services CAN-IF */
 	{ USB_DEVICE(0x10C4, 0x8665) }, /* AC-Services OBD-IF */
 	{ USB_DEVICE(0x10C4, 0xEA60) }, /* Silicon Labs factory default */
diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index e29a664..3f989d6 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -197,6 +197,7 @@ static struct usb_device_id id_table_combined [] =3D {
 	{ USB_DEVICE(FTDI_VID, FTDI_OPENDCC_THROTTLE_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_OPENDCC_GATEWAY_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_OPENDCC_GBM_PID) },
+	{ USB_DEVICE(NEWPORT_VID, NEWPORT_AGILIS_PID) },
 	{ USB_DEVICE(INTERBIOMETRICS_VID, INTERBIOMETRICS_IOBOARD_PID) },
 	{ USB_DEVICE(INTERBIOMETRICS_VID, INTERBIOMETRICS_MINI_IOBOARD_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_SPROG_II) },
@@ -1807,7 +1808,7 @@ static int ftdi_8u2232c_probe(struct usb_serial *seri=
al)
 	dbg("%s", __func__);
=20
 	if ((udev->manufacturer && !strcmp(udev->manufacturer, "CALAO Systems")) =
||
-	    (udev->product && !strcmp(udev->product, "BeagleBone/XDS100")))
+	    (udev->product && !strcmp(udev->product, "BeagleBone/XDS100V2")))
 		return ftdi_jtag_probe(serial);
=20
 	return 0;
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_si=
o_ids.h
index 7b5eb74..aedf65f 100644
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -752,6 +752,12 @@
 #define TTI_VID			0x103E	/* Vendor Id */
 #define TTI_QL355P_PID		0x03E8	/* TTi QL355P power supply */
=20
+/*
+ * Newport Cooperation (www.newport.com)
+ */
+#define NEWPORT_VID			0x104D
+#define NEWPORT_AGILIS_PID		0x3000
+
 /* Interbiometrics USB I/O Board */
 /* Developed for Interbiometrics by Rudolf Gugler */
 #define INTERBIOMETRICS_VID              0x1209
diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index a5f875d..872807b 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -80,6 +80,7 @@ static void option_instat_callback(struct urb *urb);
 #define OPTION_PRODUCT_GTM380_MODEM		0x7201
=20
 #define HUAWEI_VENDOR_ID			0x12D1
+#define HUAWEI_PRODUCT_E173			0x140C
 #define HUAWEI_PRODUCT_K4505			0x1464
 #define HUAWEI_PRODUCT_K3765			0x1465
 #define HUAWEI_PRODUCT_K4605			0x14C6
@@ -552,6 +553,8 @@ static const struct usb_device_id option_ids[] =3D {
 	{ USB_DEVICE(QUANTA_VENDOR_ID, QUANTA_PRODUCT_GLX) },
 	{ USB_DEVICE(QUANTA_VENDOR_ID, QUANTA_PRODUCT_GKE) },
 	{ USB_DEVICE(QUANTA_VENDOR_ID, QUANTA_PRODUCT_GLE) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E173, 0x=
ff, 0xff, 0xff),
+		.driver_info =3D (kernel_ulong_t) &net_intf1_blacklist },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K4505, 0=
xff, 0xff, 0xff),
 		.driver_info =3D (kernel_ulong_t) &huawei_cdc12_blacklist },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K3765, 0=
xff, 0xff, 0xff),
@@ -883,6 +886,10 @@ static const struct usb_device_id option_ids[] =3D {
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0126, 0xff, 0xff, 0xff),
 		.driver_info =3D (kernel_ulong_t)&net_intf5_blacklist },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0128, 0xff, 0xff, 0xff) =
},
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0135, 0xff, 0xff, 0xff) =
},
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0136, 0xff, 0xff, 0xff) =
},
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0137, 0xff, 0xff, 0xff) =
},
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0139, 0xff, 0xff, 0xff) =
},
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0142, 0xff, 0xff, 0xff) =
},
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0143, 0xff, 0xff, 0xff) =
},
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0144, 0xff, 0xff, 0xff) =
},
@@ -903,20 +910,34 @@ static const struct usb_device_id option_ids[] =3D {
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0165, 0xff, 0xff, 0xff) =
},
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0167, 0xff, 0xff, 0xff),
 	  .driver_info =3D (kernel_ulong_t)&net_intf4_blacklist },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0189, 0xff, 0xff, 0xff) =
},
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0191, 0xff, 0xff, 0xff),=
 /* ZTE EuFi890 */
 	  .driver_info =3D (kernel_ulong_t)&net_intf4_blacklist },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0196, 0xff, 0xff, 0xff) =
},
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0197, 0xff, 0xff, 0xff) =
},
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0199, 0xff, 0xff, 0xff),=
 /* ZTE MF820S */
 	  .driver_info =3D (kernel_ulong_t)&net_intf1_blacklist },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0200, 0xff, 0xff, 0xff) =
},
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0201, 0xff, 0xff, 0xff) =
},
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0254, 0xff, 0xff, 0xff) =
},
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0257, 0xff, 0xff, 0xff),=
 /* ZTE MF821 */
 	  .driver_info =3D (kernel_ulong_t)&net_intf3_blacklist },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0265, 0xff, 0xff, 0xff) =
},
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0284, 0xff, 0xff, 0xff) =
},
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0317, 0xff, 0xff, 0xff) =
},
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0326, 0xff, 0xff, 0xff),
 	  .driver_info =3D (kernel_ulong_t)&net_intf4_blacklist },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0330, 0xff, 0xff, 0xff) =
},
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0395, 0xff, 0xff, 0xff) =
},
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0414, 0xff, 0xff, 0xff) =
},
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0417, 0xff, 0xff, 0xff) =
},
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1008, 0xff, 0xff, 0xff),
 	  .driver_info =3D (kernel_ulong_t)&net_intf4_blacklist },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1010, 0xff, 0xff, 0xff),
 	  .driver_info =3D (kernel_ulong_t)&net_intf4_blacklist },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1012, 0xff, 0xff, 0xff),
 	  .driver_info =3D (kernel_ulong_t)&net_intf4_blacklist },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1018, 0xff, 0xff, 0xff) =
},
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1021, 0xff, 0xff, 0xff),
 	  .driver_info =3D (kernel_ulong_t)&net_intf2_blacklist },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1057, 0xff, 0xff, 0xff) =
},
@@ -1096,6 +1117,10 @@ static const struct usb_device_id option_ids[] =3D {
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1298, 0xff, 0xff, 0xff) =
},
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1299, 0xff, 0xff, 0xff) =
},
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1300, 0xff, 0xff, 0xff) =
},
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1301, 0xff, 0xff, 0xff) =
},
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1302, 0xff, 0xff, 0xff) =
},
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1303, 0xff, 0xff, 0xff) =
},
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1333, 0xff, 0xff, 0xff) =
},
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1401, 0xff, 0xff, 0xff),
 		.driver_info =3D (kernel_ulong_t)&net_intf2_blacklist },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1402, 0xff, 0xff, 0xff),
diff --git a/drivers/usb/storage/Kconfig b/drivers/usb/storage/Kconfig
index fe2d803..303c34b 100644
--- a/drivers/usb/storage/Kconfig
+++ b/drivers/usb/storage/Kconfig
@@ -203,7 +203,7 @@ config USB_STORAGE_ENE_UB6250
=20
 config USB_UAS
 	tristate "USB Attached SCSI"
-	depends on USB && SCSI
+	depends on USB && SCSI && BROKEN
 	help
 	  The USB Attached SCSI protocol is supported by some USB
 	  storage devices.  It permits higher performance by supporting
diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index c7a2c20..dc2eed1 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -121,6 +121,13 @@ static int vring_add_indirect(struct vring_virtqueue *=
vq,
 	unsigned head;
 	int i;
=20
+	/*
+	 * We require lowmem mappings for the descriptors because
+	 * otherwise virt_to_phys will give us bogus addresses in the
+	 * virtqueue.
+	 */
+	gfp &=3D ~(__GFP_HIGHMEM | __GFP_HIGH);
+
 	desc =3D kmalloc((out + in) * sizeof(struct vring_desc), gfp);
 	if (!desc)
 		return -ENOMEM;
diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index 1e9edbd..ca52e92 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -175,7 +175,10 @@ static int load_misc_binary(struct linux_binprm *bprm,=
 struct pt_regs *regs)
 		goto _error;
 	bprm->argc ++;
=20
-	bprm->interp =3D iname;	/* for binfmt_script */
+	/* Update interp in case binfmt_script needs it. */
+	retval =3D bprm_change_interp(iname, bprm);
+	if (retval < 0)
+		goto _error;
=20
 	interp_file =3D open_exec (iname);
 	retval =3D PTR_ERR (interp_file);
diff --git a/fs/binfmt_script.c b/fs/binfmt_script.c
index 396a988..e39c18a 100644
--- a/fs/binfmt_script.c
+++ b/fs/binfmt_script.c
@@ -82,7 +82,9 @@ static int load_script(struct linux_binprm *bprm,struct p=
t_regs *regs)
 	retval =3D copy_strings_kernel(1, &i_name, bprm);
 	if (retval) return retval;=20
 	bprm->argc++;
-	bprm->interp =3D interp;
+	retval =3D bprm_change_interp(interp, bprm);
+	if (retval < 0)
+		return retval;
=20
 	/*
 	 * OK, now restart the process with the interpreter's dentry.
diff --git a/fs/dcache.c b/fs/dcache.c
index 63c0c6b..bb7f4cc 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1492,7 +1492,7 @@ static struct dentry * d_find_any_alias(struct inode =
*inode)
  */
 struct dentry *d_obtain_alias(struct inode *inode)
 {
-	static const struct qstr anonstring =3D { .name =3D "" };
+	static const struct qstr anonstring =3D { .name =3D "/", .len =3D 1 };
 	struct dentry *tmp;
 	struct dentry *res;
=20
diff --git a/fs/exec.c b/fs/exec.c
index 121ccae..c27fa0d 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1095,7 +1095,8 @@ int flush_old_exec(struct linux_binprm * bprm)
 	bprm->mm =3D NULL;		/* We're using it now */
=20
 	set_fs(USER_DS);
-	current->flags &=3D ~(PF_RANDOMIZE | PF_KTHREAD | PF_NOFREEZE);
+	current->flags &=3D
+		~(PF_RANDOMIZE | PF_KTHREAD | PF_NOFREEZE | PF_FREEZER_NOSIG);
 	flush_thread();
 	current->personality &=3D ~bprm->per_clear;
=20
@@ -1201,9 +1202,24 @@ void free_bprm(struct linux_binprm *bprm)
 		mutex_unlock(&current->signal->cred_guard_mutex);
 		abort_creds(bprm->cred);
 	}
+	/* If a binfmt changed the interp, free it. */
+	if (bprm->interp !=3D bprm->filename)
+		kfree(bprm->interp);
 	kfree(bprm);
 }
=20
+int bprm_change_interp(char *interp, struct linux_binprm *bprm)
+{
+	/* If a binfmt changed the interp, free it first. */
+	if (bprm->interp !=3D bprm->filename)
+		kfree(bprm->interp);
+	bprm->interp =3D kstrdup(interp, GFP_KERNEL);
+	if (!bprm->interp)
+		return -ENOMEM;
+	return 0;
+}
+EXPORT_SYMBOL(bprm_change_interp);
+
 /*
  * install the new credentials for this executable
  */
diff --git a/fs/ext4/acl.c b/fs/ext4/acl.c
index a5c29bb..8535c45 100644
--- a/fs/ext4/acl.c
+++ b/fs/ext4/acl.c
@@ -410,8 +410,10 @@ ext4_xattr_set_acl(struct dentry *dentry, const char *=
name, const void *value,
=20
 retry:
 	handle =3D ext4_journal_start(inode, EXT4_DATA_TRANS_BLOCKS(inode->i_sb))=
;
-	if (IS_ERR(handle))
-		return PTR_ERR(handle);
+	if (IS_ERR(handle)) {
+		error =3D PTR_ERR(handle);
+		goto release_and_out;
+	}
 	error =3D ext4_set_acl(handle, inode, type, acl);
 	ext4_journal_stop(handle);
 	if (error =3D=3D -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries=
))
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index bac2330..8424dda 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1422,6 +1422,7 @@ static void ext4_da_block_invalidatepages(struct mpag=
e_da_data *mpd)
=20
 	index =3D mpd->first_page;
 	end   =3D mpd->next_page - 1;
+	pagevec_init(&pvec, 0);
 	while (index <=3D end) {
 		nr_pages =3D pagevec_lookup(&pvec, mapping, index, PAGEVEC_SIZE);
 		if (nr_pages =3D=3D 0)
diff --git a/fs/nfs/client.c b/fs/nfs/client.c
index 873bf00..d03a400 100644
--- a/fs/nfs/client.c
+++ b/fs/nfs/client.c
@@ -672,8 +672,7 @@ static int nfs_create_rpc_client(struct nfs_client *clp=
,
  */
 static void nfs_destroy_server(struct nfs_server *server)
 {
-	if (!(server->flags & NFS_MOUNT_LOCAL_FLOCK) ||
-			!(server->flags & NFS_MOUNT_LOCAL_FCNTL))
+	if (server->nlm_host)
 		nlmclnt_done(server->nlm_host);
 }
=20
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 864b831..2f98c53 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -5544,13 +5544,26 @@ static void nfs41_sequence_prepare(struct rpc_task =
*task, void *data)
 	rpc_call_start(task);
 }
=20
+static void nfs41_sequence_prepare_privileged(struct rpc_task *task, void =
*data)
+{
+	rpc_task_set_priority(task, RPC_PRIORITY_PRIVILEGED);
+	nfs41_sequence_prepare(task, data);
+}
+
 static const struct rpc_call_ops nfs41_sequence_ops =3D {
 	.rpc_call_done =3D nfs41_sequence_call_done,
 	.rpc_call_prepare =3D nfs41_sequence_prepare,
 	.rpc_release =3D nfs41_sequence_release,
 };
=20
-static struct rpc_task *_nfs41_proc_sequence(struct nfs_client *clp, struc=
t rpc_cred *cred)
+static const struct rpc_call_ops nfs41_sequence_privileged_ops =3D {
+	.rpc_call_done =3D nfs41_sequence_call_done,
+	.rpc_call_prepare =3D nfs41_sequence_prepare_privileged,
+	.rpc_release =3D nfs41_sequence_release,
+};
+
+static struct rpc_task *_nfs41_proc_sequence(struct nfs_client *clp, struc=
t rpc_cred *cred,
+					     const struct rpc_call_ops *seq_ops)
 {
 	struct nfs4_sequence_data *calldata;
 	struct rpc_message msg =3D {
@@ -5560,7 +5573,7 @@ static struct rpc_task *_nfs41_proc_sequence(struct n=
fs_client *clp, struct rpc_
 	struct rpc_task_setup task_setup_data =3D {
 		.rpc_client =3D clp->cl_rpcclient,
 		.rpc_message =3D &msg,
-		.callback_ops =3D &nfs41_sequence_ops,
+		.callback_ops =3D seq_ops,
 		.flags =3D RPC_TASK_ASYNC | RPC_TASK_SOFT,
 	};
=20
@@ -5586,7 +5599,7 @@ static int nfs41_proc_async_sequence(struct nfs_clien=
t *clp, struct rpc_cred *cr
=20
 	if ((renew_flags & NFS4_RENEW_TIMEOUT) =3D=3D 0)
 		return 0;
-	task =3D _nfs41_proc_sequence(clp, cred);
+	task =3D _nfs41_proc_sequence(clp, cred, &nfs41_sequence_ops);
 	if (IS_ERR(task))
 		ret =3D PTR_ERR(task);
 	else
@@ -5600,7 +5613,7 @@ static int nfs4_proc_sequence(struct nfs_client *clp,=
 struct rpc_cred *cred)
 	struct rpc_task *task;
 	int ret;
=20
-	task =3D _nfs41_proc_sequence(clp, cred);
+	task =3D _nfs41_proc_sequence(clp, cred, &nfs41_sequence_privileged_ops);
 	if (IS_ERR(task)) {
 		ret =3D PTR_ERR(task);
 		goto out;
diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index b8c5538..fe5c5fb 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -193,6 +193,7 @@ static __be32
 do_open_lookup(struct svc_rqst *rqstp, struct svc_fh *current_fh, struct n=
fsd4_open *open)
 {
 	struct svc_fh resfh;
+	int accmode;
 	__be32 status;
=20
 	fh_init(&resfh, NFS4_FHSIZE);
@@ -252,9 +253,10 @@ do_open_lookup(struct svc_rqst *rqstp, struct svc_fh *=
current_fh, struct nfsd4_o
 	/* set reply cache */
 	fh_copy_shallow(&open->op_openowner->oo_owner.so_replay.rp_openfh,
 			&resfh.fh_handle);
-	if (!open->op_created)
-		status =3D do_open_permission(rqstp, current_fh, open,
-					    NFSD_MAY_NOP);
+	accmode =3D NFSD_MAY_NOP;
+	if (open->op_created)
+		accmode |=3D NFSD_MAY_OWNER_OVERRIDE;
+	status =3D do_open_permission(rqstp, current_fh, open, accmode);
=20
 out:
 	fh_put(&resfh);
diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index d225b51..8b197d2 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -2309,7 +2309,7 @@ nfsd4_init_slabs(void)
 	if (openowner_slab =3D=3D NULL)
 		goto out_nomem;
 	lockowner_slab =3D kmem_cache_create("nfsd4_lockowners",
-			sizeof(struct nfs4_openowner), 0, 0, NULL);
+			sizeof(struct nfs4_lockowner), 0, 0, NULL);
 	if (lockowner_slab =3D=3D NULL)
 		goto out_nomem;
 	file_slab =3D kmem_cache_create("nfsd4_files",
diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 87a1746..800c215 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -2909,11 +2909,16 @@ nfsd4_encode_read(struct nfsd4_compoundres *resp, _=
_be32 nfserr,
 	len =3D maxcount;
 	v =3D 0;
 	while (len > 0) {
-		pn =3D resp->rqstp->rq_resused++;
+		pn =3D resp->rqstp->rq_resused;
+		if (!resp->rqstp->rq_respages[pn]) { /* ran out of pages */
+			maxcount -=3D len;
+			break;
+		}
 		resp->rqstp->rq_vec[v].iov_base =3D
 			page_address(resp->rqstp->rq_respages[pn]);
 		resp->rqstp->rq_vec[v].iov_len =3D
 			len < PAGE_SIZE ? len : PAGE_SIZE;
+		resp->rqstp->rq_resused++;
 		v++;
 		len -=3D PAGE_SIZE;
 	}
@@ -2959,6 +2964,8 @@ nfsd4_encode_readlink(struct nfsd4_compoundres *resp,=
 __be32 nfserr, struct nfsd
 		return nfserr;
 	if (resp->xbuf->page_len)
 		return nfserr_resource;
+	if (!resp->rqstp->rq_respages[resp->rqstp->rq_resused])
+		return nfserr_resource;
=20
 	page =3D page_address(resp->rqstp->rq_respages[resp->rqstp->rq_resused++]=
);
=20
@@ -3008,6 +3015,8 @@ nfsd4_encode_readdir(struct nfsd4_compoundres *resp, =
__be32 nfserr, struct nfsd4
 		return nfserr;
 	if (resp->xbuf->page_len)
 		return nfserr_resource;
+	if (!resp->rqstp->rq_respages[resp->rqstp->rq_resused])
+		return nfserr_resource;
=20
 	RESERVE_SPACE(8);  /* verifier */
 	savep =3D p;
diff --git a/fs/nfsd/nfssvc.c b/fs/nfsd/nfssvc.c
index eda7d7e..7595582 100644
--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -633,7 +633,7 @@ nfsd_dispatch(struct svc_rqst *rqstp, __be32 *statp)
 	}
=20
 	/* Store reply in cache. */
-	nfsd_cache_update(rqstp, proc->pc_cachetype, statp + 1);
+	nfsd_cache_update(rqstp, rqstp->rq_cachetype, statp + 1);
 	return 1;
 }
=20
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 5c3cd82..1ec1fde 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1458,13 +1458,19 @@ do_nfsd_create(struct svc_rqst *rqstp, struct svc_f=
h *fhp,
 		case NFS3_CREATE_EXCLUSIVE:
 			if (   dchild->d_inode->i_mtime.tv_sec =3D=3D v_mtime
 			    && dchild->d_inode->i_atime.tv_sec =3D=3D v_atime
-			    && dchild->d_inode->i_size  =3D=3D 0 )
+			    && dchild->d_inode->i_size  =3D=3D 0 ) {
+				if (created)
+					*created =3D 1;
 				break;
+			}
 		case NFS4_CREATE_EXCLUSIVE4_1:
 			if (   dchild->d_inode->i_mtime.tv_sec =3D=3D v_mtime
 			    && dchild->d_inode->i_atime.tv_sec =3D=3D v_atime
-			    && dchild->d_inode->i_size  =3D=3D 0 )
+			    && dchild->d_inode->i_size  =3D=3D 0 ) {
+				if (created)
+					*created =3D 1;
 				goto set_attr;
+			}
 			 /* fallthru */
 		case NFS3_CREATE_GUARDED:
 			err =3D nfserr_exist;
diff --git a/fs/proc/array.c b/fs/proc/array.c
index 3a1dafd..439b5a1 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -204,7 +204,7 @@ static inline void task_state(struct seq_file *m, struc=
t pid_namespace *ns,
 	group_info =3D cred->group_info;
 	task_unlock(p);
=20
-	for (g =3D 0; g < min(group_info->ngroups, NGROUPS_SMALL); g++)
+	for (g =3D 0; g < group_info->ngroups; g++)
 		seq_printf(m, "%d ", GROUP_AT(group_info, g));
 	put_cred(cred);
=20
diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index e2787d0..15df1a4 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -744,6 +744,8 @@ static struct buffer_head *inode_getblk(struct inode *i=
node, sector_t block,
 				goal, err);
 		if (!newblocknum) {
 			brelse(prev_epos.bh);
+			brelse(cur_epos.bh);
+			brelse(next_epos.bh);
 			*err =3D -ENOSPC;
 			return NULL;
 		}
@@ -774,6 +776,8 @@ static struct buffer_head *inode_getblk(struct inode *i=
node, sector_t block,
 	udf_update_extents(inode, laarr, startnum, endnum, &prev_epos);
=20
 	brelse(prev_epos.bh);
+	brelse(cur_epos.bh);
+	brelse(next_epos.bh);
=20
 	newblock =3D udf_get_pblock(inode->i_sb, newblocknum,
 				iinfo->i_location.partitionReferenceNum, 0);
diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
index fd88a39..f606406 100644
--- a/include/linux/binfmts.h
+++ b/include/linux/binfmts.h
@@ -127,6 +127,7 @@ extern int setup_arg_pages(struct linux_binprm * bprm,
 			   unsigned long stack_top,
 			   int executable_stack);
 extern int bprm_mm_init(struct linux_binprm *bprm);
+extern int bprm_change_interp(char *interp, struct linux_binprm *bprm);
 extern int copy_strings_kernel(int argc, const char *const *argv,
 			       struct linux_binprm *bprm);
 extern int prepare_bprm_creds(struct linux_binprm *bprm);
diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 1b7f9d5..9bab75f 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -32,7 +32,6 @@ extern int cgroup_lock_is_held(void);
 extern bool cgroup_lock_live_group(struct cgroup *cgrp);
 extern void cgroup_unlock(void);
 extern void cgroup_fork(struct task_struct *p);
-extern void cgroup_fork_callbacks(struct task_struct *p);
 extern void cgroup_post_fork(struct task_struct *p);
 extern void cgroup_exit(struct task_struct *p, int run_callbacks);
 extern int cgroupstats_build(struct cgroupstats *stats,
diff --git a/include/linux/freezer.h b/include/linux/freezer.h
index b5d6b6a..862e67b 100644
--- a/include/linux/freezer.h
+++ b/include/linux/freezer.h
@@ -88,9 +88,16 @@ static inline int cgroup_freezing_or_frozen(struct task_=
struct *task)
  * parent.
  */
=20
-/*
- * If the current task is a user space one, tell the freezer not to count =
it as
- * freezable.
+/**
+ * freezer_do_not_count - tell freezer to ignore %current if a user space =
task
+ *
+ * Tell freezers to ignore the current task when determining whether the
+ * target frozen state is reached.  IOW, the current task will be
+ * considered frozen enough by freezers.
+ *
+ * The caller shouldn't do anything which isn't allowed for a frozen task
+ * until freezer_cont() is called.  Usually, freezer[_do_not]_count() pair
+ * wrap a scheduling operation and nothing much else.
  */
 static inline void freezer_do_not_count(void)
 {
@@ -98,24 +105,48 @@ static inline void freezer_do_not_count(void)
 		current->flags |=3D PF_FREEZER_SKIP;
 }
=20
-/*
- * If the current task is a user space one, tell the freezer to count it a=
s
- * freezable again and try to freeze it.
+/**
+ * freezer_count - tell freezer to stop ignoring %current if a user space =
task
+ *
+ * Undo freezer_do_not_count().  It tells freezers that %current should be
+ * considered again and tries to freeze if freezing condition is already i=
n
+ * effect.
  */
 static inline void freezer_count(void)
 {
 	if (current->mm) {
 		current->flags &=3D ~PF_FREEZER_SKIP;
+		/*
+		 * If freezing is in progress, the following paired with smp_mb()
+		 * in freezer_should_skip() ensures that either we see %true
+		 * freezing() or freezer_should_skip() sees !PF_FREEZER_SKIP.
+		 */
+		smp_mb();
 		try_to_freeze();
 	}
 }
=20
-/*
- * Check if the task should be counted as freezable by the freezer
+/**
+ * freezer_should_skip - whether to skip a task when determining frozen
+ *			 state is reached
+ * @p: task in quesion
+ *
+ * This function is used by freezers after establishing %true freezing() t=
o
+ * test whether a task should be skipped when determining the target froze=
n
+ * state is reached.  IOW, if this function returns %true, @p is considere=
d
+ * frozen enough.
  */
-static inline int freezer_should_skip(struct task_struct *p)
+static inline bool freezer_should_skip(struct task_struct *p)
 {
-	return !!(p->flags & PF_FREEZER_SKIP);
+	/*
+	 * The following smp_mb() paired with the one in freezer_count()
+	 * ensures that either freezer_count() sees %true freezing() or we
+	 * see cleared %PF_FREEZER_SKIP and return %false.  This makes it
+	 * impossible for a task to slip frozen state testing after
+	 * clearing %PF_FREEZER_SKIP.
+	 */
+	smp_mb();
+	return p->flags & PF_FREEZER_SKIP;
 }
=20
 /*
diff --git a/include/linux/highmem.h b/include/linux/highmem.h
index 3a93f73..52e9620 100644
--- a/include/linux/highmem.h
+++ b/include/linux/highmem.h
@@ -38,10 +38,17 @@ extern unsigned long totalhigh_pages;
=20
 void kmap_flush_unused(void);
=20
+struct page *kmap_to_page(void *addr);
+
 #else /* CONFIG_HIGHMEM */
=20
 static inline unsigned int nr_free_highpages(void) { return 0; }
=20
+static inline struct page *kmap_to_page(void *addr)
+{
+	return virt_to_page(addr);
+}
+
 #define totalhigh_pages 0UL
=20
 #ifndef ARCH_HAS_KMAP
diff --git a/include/linux/mempolicy.h b/include/linux/mempolicy.h
index 3e8f2f7..f85c5ab 100644
--- a/include/linux/mempolicy.h
+++ b/include/linux/mempolicy.h
@@ -137,16 +137,6 @@ static inline void mpol_cond_put(struct mempolicy *pol=
)
 		__mpol_put(pol);
 }
=20
-extern struct mempolicy *__mpol_cond_copy(struct mempolicy *tompol,
-					  struct mempolicy *frompol);
-static inline struct mempolicy *mpol_cond_copy(struct mempolicy *tompol,
-						struct mempolicy *frompol)
-{
-	if (!frompol)
-		return frompol;
-	return __mpol_cond_copy(tompol, frompol);
-}
-
 extern struct mempolicy *__mpol_dup(struct mempolicy *pol);
 static inline struct mempolicy *mpol_dup(struct mempolicy *pol)
 {
@@ -270,12 +260,6 @@ static inline void mpol_cond_put(struct mempolicy *pol=
)
 {
 }
=20
-static inline struct mempolicy *mpol_cond_copy(struct mempolicy *to,
-						struct mempolicy *from)
-{
-	return from;
-}
-
 static inline void mpol_get(struct mempolicy *pol)
 {
 }
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 1874c5e..5776609 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -752,6 +752,7 @@
 #define PCI_DEVICE_ID_HP_CISSD		0x3238
 #define PCI_DEVICE_ID_HP_CISSE		0x323a
 #define PCI_DEVICE_ID_HP_CISSF		0x323b
+#define PCI_DEVICE_ID_HP_CISSH		0x323c
 #define PCI_DEVICE_ID_HP_ZX2_IOC	0x4031
=20
 #define PCI_VENDOR_ID_PCTECH		0x1042
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 6337535..b6cacf1 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2636,9 +2636,7 @@ static int cgroup_create_dir(struct cgroup *cgrp, str=
uct dentry *dentry,
 		dentry->d_fsdata =3D cgrp;
 		inc_nlink(parent->d_inode);
 		rcu_assign_pointer(cgrp->dentry, dentry);
-		dget(dentry);
 	}
-	dput(dentry);
=20
 	return error;
 }
@@ -4508,41 +4506,19 @@ void cgroup_fork(struct task_struct *child)
 }
=20
 /**
- * cgroup_fork_callbacks - run fork callbacks
- * @child: the new task
- *
- * Called on a new task very soon before adding it to the
- * tasklist. No need to take any locks since no-one can
- * be operating on this task.
- */
-void cgroup_fork_callbacks(struct task_struct *child)
-{
-	if (need_forkexit_callback) {
-		int i;
-		/*
-		 * forkexit callbacks are only supported for builtin
-		 * subsystems, and the builtin section of the subsys array is
-		 * immutable, so we don't need to lock the subsys array here.
-		 */
-		for (i =3D 0; i < CGROUP_BUILTIN_SUBSYS_COUNT; i++) {
-			struct cgroup_subsys *ss =3D subsys[i];
-			if (ss->fork)
-				ss->fork(ss, child);
-		}
-	}
-}
-
-/**
  * cgroup_post_fork - called on a new task after adding it to the task lis=
t
  * @child: the task in question
  *
- * Adds the task to the list running through its css_set if necessary.
- * Has to be after the task is visible on the task list in case we race
- * with the first call to cgroup_iter_start() - to guarantee that the
- * new task ends up on its list.
+ * Adds the task to the list running through its css_set if necessary and
+ * call the subsystem fork() callbacks.  Has to be after the task is
+ * visible on the task list in case we race with the first call to
+ * cgroup_iter_start() - to guarantee that the new task ends up on its
+ * list.
  */
 void cgroup_post_fork(struct task_struct *child)
 {
+	int i;
+
 	if (use_task_css_set_links) {
 		write_lock(&css_set_lock);
 		task_lock(child);
@@ -4551,7 +4527,21 @@ void cgroup_post_fork(struct task_struct *child)
 		task_unlock(child);
 		write_unlock(&css_set_lock);
 	}
+
+	/*
+	 * Call ss->fork().  This must happen after @child is linked on
+	 * css_set; otherwise, @child might change state between ->fork()
+	 * and addition to css_set.
+	 */
+	if (need_forkexit_callback) {
+		for (i =3D 0; i < CGROUP_BUILTIN_SUBSYS_COUNT; i++) {
+			struct cgroup_subsys *ss =3D subsys[i];
+			if (ss->fork)
+				ss->fork(ss, child);
+		}
+	}
 }
+
 /**
  * cgroup_exit - detach cgroup from exiting task
  * @tsk: pointer to task_struct of exiting process
diff --git a/kernel/cgroup_freezer.c b/kernel/cgroup_freezer.c
index 213c035..6c132a4 100644
--- a/kernel/cgroup_freezer.c
+++ b/kernel/cgroup_freezer.c
@@ -197,23 +197,15 @@ static void freezer_fork(struct cgroup_subsys *ss, st=
ruct task_struct *task)
 {
 	struct freezer *freezer;
=20
-	/*
-	 * No lock is needed, since the task isn't on tasklist yet,
-	 * so it can't be moved to another cgroup, which means the
-	 * freezer won't be removed and will be valid during this
-	 * function call.  Nevertheless, apply RCU read-side critical
-	 * section to suppress RCU lockdep false positives.
-	 */
 	rcu_read_lock();
 	freezer =3D task_freezer(task);
-	rcu_read_unlock();
=20
 	/*
 	 * The root cgroup is non-freezable, so we can skip the
 	 * following check.
 	 */
 	if (!freezer->css.cgroup->parent)
-		return;
+		goto out;
=20
 	spin_lock_irq(&freezer->lock);
 	BUG_ON(freezer->state =3D=3D CGROUP_FROZEN);
@@ -221,7 +213,10 @@ static void freezer_fork(struct cgroup_subsys *ss, str=
uct task_struct *task)
 	/* Locking avoids race with FREEZING -> THAWED transitions. */
 	if (freezer->state =3D=3D CGROUP_FREEZING)
 		freeze_task(task, true);
+
 	spin_unlock_irq(&freezer->lock);
+out:
+	rcu_read_unlock();
 }
=20
 /*
diff --git a/kernel/fork.c b/kernel/fork.c
index 222457a..ce0c182 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1057,7 +1057,6 @@ static struct task_struct *copy_process(unsigned long=
 clone_flags,
 {
 	int retval;
 	struct task_struct *p;
-	int cgroup_callbacks_done =3D 0;
=20
 	if ((clone_flags & (CLONE_NEWNS|CLONE_FS)) =3D=3D (CLONE_NEWNS|CLONE_FS))
 		return ERR_PTR(-EINVAL);
@@ -1312,12 +1311,6 @@ static struct task_struct *copy_process(unsigned lon=
g clone_flags,
 	p->group_leader =3D p;
 	INIT_LIST_HEAD(&p->thread_group);
=20
-	/* Now that the task is set up, run cgroup callbacks if
-	 * necessary. We need to run them before the task is visible
-	 * on the tasklist. */
-	cgroup_fork_callbacks(p);
-	cgroup_callbacks_done =3D 1;
-
 	/* Need tasklist lock for parent etc handling! */
 	write_lock_irq(&tasklist_lock);
=20
@@ -1419,7 +1412,7 @@ bad_fork_cleanup_cgroup:
 #endif
 	if (clone_flags & CLONE_THREAD)
 		threadgroup_fork_read_unlock(current);
-	cgroup_exit(p, cgroup_callbacks_done);
+	cgroup_exit(p, 0);
 	delayacct_tsk_free(p);
 	module_put(task_thread_info(p)->exec_domain->module);
 bad_fork_cleanup_count:
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 7600092..382a6bd 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -701,6 +701,7 @@ static void
 irq_thread_check_affinity(struct irq_desc *desc, struct irqaction *action)
 {
 	cpumask_var_t mask;
+	bool valid =3D true;
=20
 	if (!test_and_clear_bit(IRQTF_AFFINITY, &action->thread_flags))
 		return;
@@ -715,10 +716,18 @@ irq_thread_check_affinity(struct irq_desc *desc, stru=
ct irqaction *action)
 	}
=20
 	raw_spin_lock_irq(&desc->lock);
-	cpumask_copy(mask, desc->irq_data.affinity);
+	/*
+	 * This code is triggered unconditionally. Check the affinity
+	 * mask pointer. For CPU_MASK_OFFSTACK=3Dn this is optimized out.
+	 */
+	if (desc->irq_data.affinity)
+		cpumask_copy(mask, desc->irq_data.affinity);
+	else
+		valid =3D false;
 	raw_spin_unlock_irq(&desc->lock);
=20
-	set_cpus_allowed_ptr(current, mask);
+	if (valid)
+		set_cpus_allowed_ptr(current, mask);
 	free_cpumask_var(mask);
 }
 #else
@@ -950,6 +959,16 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, s=
truct irqaction *new)
 		 */
 		get_task_struct(t);
 		new->thread =3D t;
+		/*
+		 * Tell the thread to set its affinity. This is
+		 * important for shared interrupt handlers as we do
+		 * not invoke setup_affinity() for the secondary
+		 * handlers as everything is already set up. Even for
+		 * interrupts marked with IRQF_NO_BALANCE this is
+		 * correct as we want the thread to move to the cpu(s)
+		 * on which the requesting code placed the interrupt.
+		 */
+		set_bit(IRQTF_AFFINITY, &new->thread_flags);
 	}
=20
 	if (!alloc_cpumask_var(&mask, GFP_KERNEL)) {
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index a122196..1aa52af 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -202,13 +202,13 @@ DEFINE_PER_CPU(struct rcu_dynticks, rcu_dynticks) =3D=
 {
 };
 #endif /* #ifdef CONFIG_NO_HZ */
=20
-static int blimit =3D 10;		/* Maximum callbacks per rcu_do_batch. */
-static int qhimark =3D 10000;	/* If this many pending, ignore blimit. */
-static int qlowmark =3D 100;	/* Once only this many pending, use blimit. *=
/
+static long blimit =3D 10;	/* Maximum callbacks per rcu_do_batch. */
+static long qhimark =3D 10000;	/* If this many pending, ignore blimit. */
+static long qlowmark =3D 100;	/* Once only this many pending, use blimit. =
*/
=20
-module_param(blimit, int, 0);
-module_param(qhimark, int, 0);
-module_param(qlowmark, int, 0);
+module_param(blimit, long, 0);
+module_param(qhimark, long, 0);
+module_param(qlowmark, long, 0);
=20
 int rcu_cpu_stall_suppress __read_mostly;
 module_param(rcu_cpu_stall_suppress, int, 0644);
@@ -1260,7 +1260,7 @@ static void rcu_do_batch(struct rcu_state *rsp, struc=
t rcu_data *rdp)
 {
 	unsigned long flags;
 	struct rcu_head *next, *list, **tail;
-	int bl, count;
+	long bl, count;
=20
 	/* If no callbacks are ready, just return.*/
 	if (!cpu_has_callbacks_ready_to_invoke(rdp)) {
diff --git a/kernel/sched_autogroup.c b/kernel/sched_autogroup.c
index 429242f..f280df1 100644
--- a/kernel/sched_autogroup.c
+++ b/kernel/sched_autogroup.c
@@ -160,15 +160,11 @@ autogroup_move_group(struct task_struct *p, struct au=
togroup *ag)
=20
 	p->signal->autogroup =3D autogroup_kref_get(ag);
=20
-	if (!ACCESS_ONCE(sysctl_sched_autogroup_enabled))
-		goto out;
-
 	t =3D p;
 	do {
 		sched_move_task(t);
 	} while_each_thread(p, t);
=20
-out:
 	unlock_task_sighand(p, &flags);
 	autogroup_kref_put(prev);
 }
diff --git a/kernel/sched_autogroup.h b/kernel/sched_autogroup.h
index c2f0e72..3d7a50e 100644
--- a/kernel/sched_autogroup.h
+++ b/kernel/sched_autogroup.h
@@ -1,11 +1,6 @@
 #ifdef CONFIG_SCHED_AUTOGROUP
=20
 struct autogroup {
-	/*
-	 * reference doesn't mean how many thread attach to this
-	 * autogroup now. It just stands for the number of task
-	 * could use this autogroup.
-	 */
 	struct kref		kref;
 	struct task_group	*tg;
 	struct rw_semaphore	lock;
diff --git a/kernel/sys.c b/kernel/sys.c
index d7c4ab0..f5939c2 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1190,7 +1190,7 @@ static int override_release(char __user *release, siz=
e_t len)
 			rest++;
 		}
 		v =3D ((LINUX_VERSION_CODE >> 8) & 0xff) + 40;
-		copy =3D min(sizeof(buf), max_t(size_t, 1, len));
+		copy =3D clamp_t(size_t, len, 1, sizeof(buf));
 		copy =3D scnprintf(buf, copy, "2.6.%u%s", v, rest);
 		ret =3D copy_to_user(release, buf, copy + 1);
 	}
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 25b4f4d..54dba59 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2074,7 +2074,7 @@ static void reset_iter_read(struct ftrace_iterator *i=
ter)
 {
 	iter->pos =3D 0;
 	iter->func_pos =3D 0;
-	iter->flags &=3D ~(FTRACE_ITER_PRINTALL & FTRACE_ITER_HASH);
+	iter->flags &=3D ~(FTRACE_ITER_PRINTALL | FTRACE_ITER_HASH);
 }
=20
 static void *t_start(struct seq_file *m, loff_t *pos)
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index f5b7b5c..6fdc629 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2683,7 +2683,7 @@ unsigned long ring_buffer_oldest_event_ts(struct ring=
_buffer *buffer, int cpu)
 	unsigned long flags;
 	struct ring_buffer_per_cpu *cpu_buffer;
 	struct buffer_page *bpage;
-	unsigned long ret;
+	unsigned long ret =3D 0;
=20
 	if (!cpumask_test_cpu(cpu, buffer->cpumask))
 		return 0;
@@ -2698,7 +2698,8 @@ unsigned long ring_buffer_oldest_event_ts(struct ring=
_buffer *buffer, int cpu)
 		bpage =3D cpu_buffer->reader_page;
 	else
 		bpage =3D rb_set_head_page(cpu_buffer);
-	ret =3D bpage->page->time_stamp;
+	if (bpage)
+		ret =3D bpage->page->time_stamp;
 	raw_spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
=20
 	return ret;
@@ -3005,6 +3006,8 @@ rb_get_reader_page(struct ring_buffer_per_cpu *cpu_bu=
ffer)
 	 * Splice the empty reader page into the list around the head.
 	 */
 	reader =3D rb_set_head_page(cpu_buffer);
+	if (!reader)
+		goto out;
 	cpu_buffer->reader_page->list.next =3D rb_list_head(reader->list.next);
 	cpu_buffer->reader_page->list.prev =3D reader->list.prev;
=20
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index d551d5f..7bf068a 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1146,8 +1146,8 @@ int queue_delayed_work_on(int cpu, struct workqueue_s=
truct *wq,
 	if (!test_and_set_bit(WORK_STRUCT_PENDING_BIT, work_data_bits(work))) {
 		unsigned int lcpu;
=20
-		BUG_ON(timer_pending(timer));
-		BUG_ON(!list_empty(&work->entry));
+		WARN_ON_ONCE(timer_pending(timer));
+		WARN_ON_ONCE(!list_empty(&work->entry));
=20
 		timer_stats_timer_set_start_info(&dwork->timer);
=20
diff --git a/mm/dmapool.c b/mm/dmapool.c
index c5ab33b..da1b0f0 100644
--- a/mm/dmapool.c
+++ b/mm/dmapool.c
@@ -50,7 +50,6 @@ struct dma_pool {		/* the pool */
 	size_t allocation;
 	size_t boundary;
 	char name[32];
-	wait_queue_head_t waitq;
 	struct list_head pools;
 };
=20
@@ -62,8 +61,6 @@ struct dma_page {		/* cacheable header for 'allocation' b=
ytes */
 	unsigned int offset;
 };
=20
-#define	POOL_TIMEOUT_JIFFIES	((100 /* msec */ * HZ) / 1000)
-
 static DEFINE_MUTEX(pools_lock);
=20
 static ssize_t
@@ -172,7 +169,6 @@ struct dma_pool *dma_pool_create(const char *name, stru=
ct device *dev,
 	retval->size =3D size;
 	retval->boundary =3D boundary;
 	retval->allocation =3D allocation;
-	init_waitqueue_head(&retval->waitq);
=20
 	if (dev) {
 		int ret;
@@ -227,7 +223,6 @@ static struct dma_page *pool_alloc_page(struct dma_pool=
 *pool, gfp_t mem_flags)
 		memset(page->vaddr, POOL_POISON_FREED, pool->allocation);
 #endif
 		pool_initialise_page(pool, page);
-		list_add(&page->page_list, &pool->page_list);
 		page->in_use =3D 0;
 		page->offset =3D 0;
 	} else {
@@ -315,30 +310,21 @@ void *dma_pool_alloc(struct dma_pool *pool, gfp_t mem=
_flags,
 	might_sleep_if(mem_flags & __GFP_WAIT);
=20
 	spin_lock_irqsave(&pool->lock, flags);
- restart:
 	list_for_each_entry(page, &pool->page_list, page_list) {
 		if (page->offset < pool->allocation)
 			goto ready;
 	}
-	page =3D pool_alloc_page(pool, GFP_ATOMIC);
-	if (!page) {
-		if (mem_flags & __GFP_WAIT) {
-			DECLARE_WAITQUEUE(wait, current);
=20
-			__set_current_state(TASK_UNINTERRUPTIBLE);
-			__add_wait_queue(&pool->waitq, &wait);
-			spin_unlock_irqrestore(&pool->lock, flags);
+	/* pool_alloc_page() might sleep, so temporarily drop &pool->lock */
+	spin_unlock_irqrestore(&pool->lock, flags);
=20
-			schedule_timeout(POOL_TIMEOUT_JIFFIES);
+	page =3D pool_alloc_page(pool, mem_flags);
+	if (!page)
+		return NULL;
=20
-			spin_lock_irqsave(&pool->lock, flags);
-			__remove_wait_queue(&pool->waitq, &wait);
-			goto restart;
-		}
-		retval =3D NULL;
-		goto done;
-	}
+	spin_lock_irqsave(&pool->lock, flags);
=20
+	list_add(&page->page_list, &pool->page_list);
  ready:
 	page->in_use++;
 	offset =3D page->offset;
@@ -348,7 +334,6 @@ void *dma_pool_alloc(struct dma_pool *pool, gfp_t mem_f=
lags,
 #ifdef	DMAPOOL_DEBUG
 	memset(retval, POOL_POISON_ALLOCATED, pool->size);
 #endif
- done:
 	spin_unlock_irqrestore(&pool->lock, flags);
 	return retval;
 }
@@ -435,8 +420,6 @@ void dma_pool_free(struct dma_pool *pool, void *vaddr, =
dma_addr_t dma)
 	page->in_use--;
 	*(int *)vaddr =3D page->offset;
 	page->offset =3D offset;
-	if (waitqueue_active(&pool->waitq))
-		wake_up_locked(&pool->waitq);
 	/*
 	 * Resist a temptation to do
 	 *    if (!is_page_busy(page)) pool_free_page(pool, page);
diff --git a/mm/highmem.c b/mm/highmem.c
index 57d82c6..2a07f97 100644
--- a/mm/highmem.c
+++ b/mm/highmem.c
@@ -94,6 +94,19 @@ static DECLARE_WAIT_QUEUE_HEAD(pkmap_map_wait);
 		do { spin_unlock(&kmap_lock); (void)(flags); } while (0)
 #endif
=20
+struct page *kmap_to_page(void *vaddr)
+{
+	unsigned long addr =3D (unsigned long)vaddr;
+
+	if (addr >=3D PKMAP_ADDR(0) && addr <=3D PKMAP_ADDR(LAST_PKMAP)) {
+		int i =3D (addr - PKMAP_ADDR(0)) >> PAGE_SHIFT;
+		return pte_page(pkmap_page_table[i]);
+	}
+
+	return virt_to_page(addr);
+}
+EXPORT_SYMBOL(kmap_to_page);
+
 static void flush_all_zero_pkmaps(void)
 {
 	int i;
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 8f005e9..470cbb4 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -921,6 +921,8 @@ int do_huge_pmd_wp_page(struct mm_struct *mm, struct vm=
_area_struct *vma,
 		count_vm_event(THP_FAULT_FALLBACK);
 		ret =3D do_huge_pmd_wp_page_fallback(mm, vma, address,
 						   pmd, orig_pmd, page, haddr);
+		if (ret & VM_FAULT_OOM)
+			split_huge_page(page);
 		put_page(page);
 		goto out;
 	}
@@ -928,6 +930,7 @@ int do_huge_pmd_wp_page(struct mm_struct *mm, struct vm=
_area_struct *vma,
=20
 	if (unlikely(mem_cgroup_newpage_charge(new_page, mm, GFP_KERNEL))) {
 		put_page(new_page);
+		split_huge_page(page);
 		put_page(page);
 		ret |=3D VM_FAULT_OOM;
 		goto out;
diff --git a/mm/memory.c b/mm/memory.c
index 70f5daf..15e686a 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3469,6 +3469,7 @@ int handle_mm_fault(struct mm_struct *mm, struct vm_a=
rea_struct *vma,
 	if (unlikely(is_vm_hugetlb_page(vma)))
 		return hugetlb_fault(mm, vma, address, flags);
=20
+retry:
 	pgd =3D pgd_offset(mm, address);
 	pud =3D pud_alloc(mm, pgd, address);
 	if (!pud)
@@ -3482,13 +3483,24 @@ int handle_mm_fault(struct mm_struct *mm, struct vm=
_area_struct *vma,
 							  pmd, flags);
 	} else {
 		pmd_t orig_pmd =3D *pmd;
+		int ret;
+
 		barrier();
 		if (pmd_trans_huge(orig_pmd)) {
 			if (flags & FAULT_FLAG_WRITE &&
 			    !pmd_write(orig_pmd) &&
-			    !pmd_trans_splitting(orig_pmd))
-				return do_huge_pmd_wp_page(mm, vma, address,
-							   pmd, orig_pmd);
+			    !pmd_trans_splitting(orig_pmd)) {
+				ret =3D do_huge_pmd_wp_page(mm, vma, address, pmd,
+							  orig_pmd);
+				/*
+				 * If COW results in an oom, the huge pmd will
+				 * have been split, so retry the fault on the
+				 * pte for a smaller charge.
+				 */
+				if (unlikely(ret & VM_FAULT_OOM))
+					goto retry;
+				return ret;
+			}
 			return 0;
 		}
 	}
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 4c82c21..c59d44b 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1999,28 +1999,6 @@ struct mempolicy *__mpol_dup(struct mempolicy *old)
 	return new;
 }
=20
-/*
- * If *frompol needs [has] an extra ref, copy *frompol to *tompol ,
- * eliminate the * MPOL_F_* flags that require conditional ref and
- * [NOTE!!!] drop the extra ref.  Not safe to reference *frompol directly
- * after return.  Use the returned value.
- *
- * Allows use of a mempolicy for, e.g., multiple allocations with a single
- * policy lookup, even if the policy needs/has extra ref on lookup.
- * shmem_readahead needs this.
- */
-struct mempolicy *__mpol_cond_copy(struct mempolicy *tompol,
-						struct mempolicy *frompol)
-{
-	if (!mpol_needs_cond_ref(frompol))
-		return frompol;
-
-	*tompol =3D *frompol;
-	tompol->flags &=3D ~MPOL_F_SHARED;	/* copy doesn't need unref */
-	__mpol_put(frompol);
-	return tompol;
-}
-
 /* Slow path of a mempolicy comparison */
 int __mpol_equal(struct mempolicy *a, struct mempolicy *b)
 {
diff --git a/mm/shmem.c b/mm/shmem.c
index 2d46e23..12b9e80 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -798,24 +798,28 @@ static struct mempolicy *shmem_get_sbmpol(struct shme=
m_sb_info *sbinfo)
 static struct page *shmem_swapin(swp_entry_t swap, gfp_t gfp,
 			struct shmem_inode_info *info, pgoff_t index)
 {
-	struct mempolicy mpol, *spol;
 	struct vm_area_struct pvma;
-
-	spol =3D mpol_cond_copy(&mpol,
-			mpol_shared_policy_lookup(&info->policy, index));
+	struct page *page;
=20
 	/* Create a pseudo vma that just contains the policy */
 	pvma.vm_start =3D 0;
 	pvma.vm_pgoff =3D index;
 	pvma.vm_ops =3D NULL;
-	pvma.vm_policy =3D spol;
-	return swapin_readahead(swap, gfp, &pvma, 0);
+	pvma.vm_policy =3D mpol_shared_policy_lookup(&info->policy, index);
+
+	page =3D swapin_readahead(swap, gfp, &pvma, 0);
+
+	/* Drop reference taken by mpol_shared_policy_lookup() */
+	mpol_cond_put(pvma.vm_policy);
+
+	return page;
 }
=20
 static struct page *shmem_alloc_page(gfp_t gfp,
 			struct shmem_inode_info *info, pgoff_t index)
 {
 	struct vm_area_struct pvma;
+	struct page *page;
=20
 	/* Create a pseudo vma that just contains the policy */
 	pvma.vm_start =3D 0;
@@ -823,10 +827,12 @@ static struct page *shmem_alloc_page(gfp_t gfp,
 	pvma.vm_ops =3D NULL;
 	pvma.vm_policy =3D mpol_shared_policy_lookup(&info->policy, index);
=20
-	/*
-	 * alloc_page_vma() will drop the shared policy reference
-	 */
-	return alloc_page_vma(gfp, &pvma, 0);
+	page =3D alloc_page_vma(gfp, &pvma, 0);
+
+	/* Drop reference taken by mpol_shared_policy_lookup() */
+	mpol_cond_put(pvma.vm_policy);
+
+	return page;
 }
 #else /* !CONFIG_NUMA */
 #ifdef CONFIG_TMPFS
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 1e4ee1a..313381c 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2492,19 +2492,6 @@ unsigned long try_to_free_mem_cgroup_pages(struct me=
m_cgroup *mem_cont,
 }
 #endif
=20
-static bool zone_balanced(struct zone *zone, int order,
-			  unsigned long balance_gap, int classzone_idx)
-{
-	if (!zone_watermark_ok_safe(zone, order, high_wmark_pages(zone) +
-				    balance_gap, classzone_idx, 0))
-		return false;
-
-	if (COMPACTION_BUILD && order && !compaction_suitable(zone, order))
-		return false;
-
-	return true;
-}
-
 /*
  * pgdat_balanced is used when checking if a node is balanced for high-ord=
er
  * allocations. Only zones that meet watermarks and are in a zone allowed
@@ -2564,7 +2551,8 @@ static bool sleeping_prematurely(pg_data_t *pgdat, in=
t order, long remaining,
 			continue;
 		}
=20
-		if (!zone_balanced(zone, order, 0, i))
+		if (!zone_watermark_ok_safe(zone, order, high_wmark_pages(zone),
+							i, 0))
 			all_zones_ok =3D false;
 		else
 			balanced +=3D zone->present_pages;
@@ -2667,7 +2655,8 @@ loop_again:
 				shrink_active_list(SWAP_CLUSTER_MAX, zone,
 							&sc, priority, 0);
=20
-			if (!zone_balanced(zone, order, 0, 0)) {
+			if (!zone_watermark_ok_safe(zone, order,
+					high_wmark_pages(zone), 0, 0)) {
 				end_zone =3D i;
 				break;
 			} else {
@@ -2728,8 +2717,9 @@ loop_again:
 				(zone->present_pages +
 					KSWAPD_ZONE_BALANCE_GAP_RATIO-1) /
 				KSWAPD_ZONE_BALANCE_GAP_RATIO);
-			if (!zone_balanced(zone, order,
-					   balance_gap, end_zone)) {
+			if (!zone_watermark_ok_safe(zone, order,
+					high_wmark_pages(zone) + balance_gap,
+					end_zone, 0)) {
 				shrink_zone(priority, zone, &sc);
=20
 				reclaim_state->reclaimed_slab =3D 0;
@@ -2756,7 +2746,8 @@ loop_again:
 				continue;
 			}
=20
-			if (!zone_balanced(zone, order, 0, end_zone)) {
+			if (!zone_watermark_ok_safe(zone, order,
+					high_wmark_pages(zone), end_zone, 0)) {
 				all_zones_ok =3D 0;
 				/*
 				 * We are still under min water mark.  This
diff --git a/net/9p/trans_virtio.c b/net/9p/trans_virtio.c
index 32aa983..55f0c09 100644
--- a/net/9p/trans_virtio.c
+++ b/net/9p/trans_virtio.c
@@ -37,6 +37,7 @@
 #include <linux/inet.h>
 #include <linux/idr.h>
 #include <linux/file.h>
+#include <linux/highmem.h>
 #include <linux/slab.h>
 #include <net/9p/9p.h>
 #include <linux/parser.h>
@@ -323,7 +324,7 @@ static int p9_get_mapped_pages(struct virtio_chan *chan=
,
 		int count =3D nr_pages;
 		while (nr_pages) {
 			s =3D rest_of_page(data);
-			pages[index++] =3D virt_to_page(data);
+			pages[index++] =3D kmap_to_page(data);
 			data +=3D s;
 			nr_pages--;
 		}
diff --git a/net/bluetooth/rfcomm/sock.c b/net/bluetooth/rfcomm/sock.c
index 7ee4ead..14c4864 100644
--- a/net/bluetooth/rfcomm/sock.c
+++ b/net/bluetooth/rfcomm/sock.c
@@ -486,7 +486,7 @@ static int rfcomm_sock_accept(struct socket *sock, stru=
ct socket *newsock, int f
 	long timeo;
 	int err =3D 0;
=20
-	lock_sock(sk);
+	lock_sock_nested(sk, SINGLE_DEPTH_NESTING);
=20
 	if (sk->sk_type !=3D SOCK_STREAM) {
 		err =3D -EINVAL;
@@ -523,7 +523,7 @@ static int rfcomm_sock_accept(struct socket *sock, stru=
ct socket *newsock, int f
=20
 		release_sock(sk);
 		timeo =3D schedule_timeout(timeo);
-		lock_sock(sk);
+		lock_sock_nested(sk, SINGLE_DEPTH_NESTING);
 	}
 	__set_current_state(TASK_RUNNING);
 	remove_wait_queue(sk_sleep(sk), &wait);
diff --git a/net/ipv4/ip_fragment.c b/net/ipv4/ip_fragment.c
index fdaabf2..a4e7131 100644
--- a/net/ipv4/ip_fragment.c
+++ b/net/ipv4/ip_fragment.c
@@ -684,28 +684,27 @@ EXPORT_SYMBOL(ip_defrag);
=20
 struct sk_buff *ip_check_defrag(struct sk_buff *skb, u32 user)
 {
-	const struct iphdr *iph;
+	struct iphdr iph;
 	u32 len;
=20
 	if (skb->protocol !=3D htons(ETH_P_IP))
 		return skb;
=20
-	if (!pskb_may_pull(skb, sizeof(struct iphdr)))
+	if (!skb_copy_bits(skb, 0, &iph, sizeof(iph)))
 		return skb;
=20
-	iph =3D ip_hdr(skb);
-	if (iph->ihl < 5 || iph->version !=3D 4)
+	if (iph.ihl < 5 || iph.version !=3D 4)
 		return skb;
-	if (!pskb_may_pull(skb, iph->ihl*4))
-		return skb;
-	iph =3D ip_hdr(skb);
-	len =3D ntohs(iph->tot_len);
-	if (skb->len < len || len < (iph->ihl * 4))
+
+	len =3D ntohs(iph.tot_len);
+	if (skb->len < len || len < (iph.ihl * 4))
 		return skb;
=20
-	if (ip_is_fragment(ip_hdr(skb))) {
+	if (ip_is_fragment(&iph)) {
 		skb =3D skb_share_check(skb, GFP_ATOMIC);
 		if (skb) {
+			if (!pskb_may_pull(skb, iph.ihl*4))
+				return skb;
 			if (pskb_trim_rcsum(skb, len))
 				return skb;
 			memset(IPCB(skb), 0, sizeof(struct inet_skb_parm));
diff --git a/net/sctp/chunk.c b/net/sctp/chunk.c
index 6c85564..0018b65 100644
--- a/net/sctp/chunk.c
+++ b/net/sctp/chunk.c
@@ -183,7 +183,7 @@ struct sctp_datamsg *sctp_datamsg_from_user(struct sctp=
_association *asoc,
=20
 	msg =3D sctp_datamsg_new(GFP_KERNEL);
 	if (!msg)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
=20
 	/* Note: Calculate this outside of the loop, so that all fragments
 	 * have the same expiration.
@@ -280,11 +280,14 @@ struct sctp_datamsg *sctp_datamsg_from_user(struct sc=
tp_association *asoc,
=20
 		chunk =3D sctp_make_datafrag_empty(asoc, sinfo, len, frag, 0);
=20
-		if (!chunk)
+		if (!chunk) {
+			err =3D -ENOMEM;
 			goto errout;
+		}
+
 		err =3D sctp_user_addto_chunk(chunk, offset, len, msgh->msg_iov);
 		if (err < 0)
-			goto errout;
+			goto errout_chunk_free;
=20
 		offset +=3D len;
=20
@@ -315,8 +318,10 @@ struct sctp_datamsg *sctp_datamsg_from_user(struct sct=
p_association *asoc,
=20
 		chunk =3D sctp_make_datafrag_empty(asoc, sinfo, over, frag, 0);
=20
-		if (!chunk)
+		if (!chunk) {
+			err =3D -ENOMEM;
 			goto errout;
+		}
=20
 		err =3D sctp_user_addto_chunk(chunk, offset, over,msgh->msg_iov);
=20
@@ -324,7 +329,7 @@ struct sctp_datamsg *sctp_datamsg_from_user(struct sctp=
_association *asoc,
 		__skb_pull(chunk->skb, (__u8 *)chunk->chunk_hdr
 			   - (__u8 *)chunk->skb->data);
 		if (err < 0)
-			goto errout;
+			goto errout_chunk_free;
=20
 		sctp_datamsg_assign(msg, chunk);
 		list_add_tail(&chunk->frag_list, &msg->chunks);
@@ -332,6 +337,9 @@ struct sctp_datamsg *sctp_datamsg_from_user(struct sctp=
_association *asoc,
=20
 	return msg;
=20
+errout_chunk_free:
+	sctp_chunk_free(chunk);
+
 errout:
 	list_for_each_safe(pos, temp, &msg->chunks) {
 		list_del_init(pos);
@@ -339,7 +347,7 @@ errout:
 		sctp_chunk_free(chunk);
 	}
 	sctp_datamsg_put(msg);
-	return NULL;
+	return ERR_PTR(err);
 }
=20
 /* Check whether this message has expired. */
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 8e49d76..fa8333b 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -1908,8 +1908,8 @@ SCTP_STATIC int sctp_sendmsg(struct kiocb *iocb, stru=
ct sock *sk,
=20
 	/* Break the message into multiple chunks of maximum size. */
 	datamsg =3D sctp_datamsg_from_user(asoc, sinfo, msg, msg_len);
-	if (!datamsg) {
-		err =3D -ENOMEM;
+	if (IS_ERR(datamsg)) {
+		err =3D PTR_ERR(datamsg);
 		goto out_free;
 	}
=20
diff --git a/security/device_cgroup.c b/security/device_cgroup.c
index 92e24bb..4450fbe 100644
--- a/security/device_cgroup.c
+++ b/security/device_cgroup.c
@@ -202,8 +202,8 @@ static void devcgroup_destroy(struct cgroup_subsys *ss,
=20
 	dev_cgroup =3D cgroup_to_devcgroup(cgroup);
 	list_for_each_entry_safe(wh, tmp, &dev_cgroup->whitelist, list) {
-		list_del_rcu(&wh->list);
-		kfree_rcu(wh, rcu);
+		list_del(&wh->list);
+		kfree(wh);
 	}
 	kfree(dev_cgroup);
 }
@@ -278,7 +278,7 @@ static int may_access_whitelist(struct dev_cgroup *c,
 {
 	struct dev_whitelist_item *whitem;
=20
-	list_for_each_entry_rcu(whitem, &c->whitelist, list) {
+	list_for_each_entry(whitem, &c->whitelist, list) {
 		if (whitem->type & DEV_ALL)
 			return 1;
 		if ((refwh->type & DEV_BLOCK) && !(whitem->type & DEV_BLOCK))
diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index 53345bc..a1e312f 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -148,6 +148,7 @@ MODULE_SUPPORTED_DEVICE("{{Intel, ICH6},"
 			 "{Intel, PCH},"
 			 "{Intel, CPT},"
 			 "{Intel, PPT},"
+			 "{Intel, LPT},"
 			 "{Intel, PBG},"
 			 "{Intel, SCH},"
 			 "{ATI, SB450},"
@@ -2973,6 +2974,10 @@ static DEFINE_PCI_DEVICE_TABLE(azx_ids) =3D {
 	{ PCI_DEVICE(0x8086, 0x1e20),
 	  .driver_data =3D AZX_DRIVER_PCH | AZX_DCAPS_SCH_SNOOP |
 	  AZX_DCAPS_BUFSIZE},
+	/* Lynx Point */
+	{ PCI_DEVICE(0x8086, 0x8c20),
+	  .driver_data =3D AZX_DRIVER_PCH | AZX_DCAPS_SCH_SNOOP |
+	  AZX_DCAPS_BUFSIZE},
 	/* SCH */
 	{ PCI_DEVICE(0x8086, 0x811b),
 	  .driver_data =3D AZX_DRIVER_SCH | AZX_DCAPS_SCH_SNOOP |
diff --git a/sound/pci/hda/patch_conexant.c b/sound/pci/hda/patch_conexant.=
c
index 58c287b..498b62e 100644
--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -4505,6 +4505,7 @@ static const struct snd_pci_quirk cxt5051_fixups[] =
=3D {
 };
=20
 static const struct snd_pci_quirk cxt5066_fixups[] =3D {
+	SND_PCI_QUIRK(0x1025, 0x0543, "Acer Aspire One 522", CXT_FIXUP_STEREO_DMI=
C),
 	SND_PCI_QUIRK(0x17aa, 0x20f2, "Lenovo T400", CXT_PINCFG_LENOVO_TP410),
 	SND_PCI_QUIRK(0x17aa, 0x215e, "Lenovo T410", CXT_PINCFG_LENOVO_TP410),
 	SND_PCI_QUIRK(0x17aa, 0x215f, "Lenovo T510", CXT_PINCFG_LENOVO_TP410),
diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index c119f33..bde2615 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -424,9 +424,11 @@ static void hdmi_init_pin(struct hda_codec *codec, hda=
_nid_t pin_nid)
 	if (get_wcaps(codec, pin_nid) & AC_WCAP_OUT_AMP)
 		snd_hda_codec_write(codec, pin_nid, 0,
 				AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_UNMUTE);
-	/* Disable pin out until stream is active*/
+	/* Enable pin out: some machines with GM965 gets broken output when
+	 * the pin is disabled or changed while using with HDMI
+	 */
 	snd_hda_codec_write(codec, pin_nid, 0,
-			    AC_VERB_SET_PIN_WIDGET_CONTROL, 0);
+			    AC_VERB_SET_PIN_WIDGET_CONTROL, PIN_OUT);
 }
=20
 static int hdmi_get_channel_count(struct hda_codec *codec, hda_nid_t cvt_n=
id)
@@ -1141,17 +1143,11 @@ static int generic_hdmi_playback_pcm_prepare(struct=
 hda_pcm_stream *hinfo,
 	struct hdmi_spec *spec =3D codec->spec;
 	int pin_idx =3D hinfo_to_pin_index(spec, hinfo);
 	hda_nid_t pin_nid =3D spec->pins[pin_idx].pin_nid;
-	int pinctl;
=20
 	hdmi_set_channel_count(codec, cvt_nid, substream->runtime->channels);
=20
 	hdmi_setup_audio_infoframe(codec, pin_idx, substream);
=20
-	pinctl =3D snd_hda_codec_read(codec, pin_nid, 0,
-				    AC_VERB_GET_PIN_WIDGET_CONTROL, 0);
-	snd_hda_codec_write(codec, pin_nid, 0,
-			    AC_VERB_SET_PIN_WIDGET_CONTROL, pinctl | PIN_OUT);
-
 	return hdmi_setup_stream(codec, cvt_nid, pin_nid, stream_tag, format);
 }
=20
@@ -1163,7 +1159,6 @@ static int generic_hdmi_playback_pcm_cleanup(struct h=
da_pcm_stream *hinfo,
 	int cvt_idx, pin_idx;
 	struct hdmi_spec_per_cvt *per_cvt;
 	struct hdmi_spec_per_pin *per_pin;
-	int pinctl;
=20
 	snd_hda_codec_cleanup_stream(codec, hinfo->nid);
=20
@@ -1182,11 +1177,6 @@ static int generic_hdmi_playback_pcm_cleanup(struct =
hda_pcm_stream *hinfo,
 			return -EINVAL;
 		per_pin =3D &spec->pins[pin_idx];
=20
-		pinctl =3D snd_hda_codec_read(codec, per_pin->pin_nid, 0,
-					    AC_VERB_GET_PIN_WIDGET_CONTROL, 0);
-		snd_hda_codec_write(codec, per_pin->pin_nid, 0,
-				    AC_VERB_SET_PIN_WIDGET_CONTROL,
-				    pinctl & ~PIN_OUT);
 		snd_hda_spdif_ctls_unassign(codec, pin_idx);
 	}
=20
@@ -1911,6 +1901,7 @@ static const struct hda_codec_preset snd_hda_preset_h=
dmi[] =3D {
 { .id =3D 0x80862804, .name =3D "IbexPeak HDMI",	.patch =3D patch_generic_=
hdmi },
 { .id =3D 0x80862805, .name =3D "CougarPoint HDMI",	.patch =3D patch_gener=
ic_hdmi },
 { .id =3D 0x80862806, .name =3D "PantherPoint HDMI", .patch =3D patch_gene=
ric_hdmi },
+{ .id =3D 0x80862880, .name =3D "CedarTrail HDMI",	.patch =3D patch_generi=
c_hdmi },
 { .id =3D 0x808629fb, .name =3D "Crestline HDMI",	.patch =3D patch_generic=
_hdmi },
 {} /* terminator */
 };
@@ -1957,6 +1948,7 @@ MODULE_ALIAS("snd-hda-codec-id:80862803");
 MODULE_ALIAS("snd-hda-codec-id:80862804");
 MODULE_ALIAS("snd-hda-codec-id:80862805");
 MODULE_ALIAS("snd-hda-codec-id:80862806");
+MODULE_ALIAS("snd-hda-codec-id:80862880");
 MODULE_ALIAS("snd-hda-codec-id:808629fb");
=20
 MODULE_LICENSE("GPL");
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 1a09fbf..f3e0b24 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -3854,6 +3854,7 @@ static void alc_auto_init_std(struct hda_codec *codec=
)
 	((spec)->beep_amp =3D HDA_COMPOSE_AMP_VAL(nid, 3, idx, dir))
=20
 static const struct snd_pci_quirk beep_white_list[] =3D {
+	SND_PCI_QUIRK(0x1043, 0x103c, "ASUS", 1),
 	SND_PCI_QUIRK(0x1043, 0x829f, "ASUS", 1),
 	SND_PCI_QUIRK(0x1043, 0x83ce, "EeePC", 1),
 	SND_PCI_QUIRK(0x1043, 0x831a, "EeePC", 1),
@@ -5468,8 +5469,8 @@ static void alc861vd_fixup_dallas(struct hda_codec *c=
odec,
 				  const struct alc_fixup *fix, int action)
 {
 	if (action =3D=3D ALC_FIXUP_ACT_PRE_PROBE) {
-		snd_hda_override_pin_caps(codec, 0x18, 0x00001714);
-		snd_hda_override_pin_caps(codec, 0x19, 0x0000171c);
+		snd_hda_override_pin_caps(codec, 0x18, 0x00000734);
+		snd_hda_override_pin_caps(codec, 0x19, 0x0000073c);
 	}
 }
=20
diff --git a/sound/pci/hda/patch_sigmatel.c b/sound/pci/hda/patch_sigmatel.=
c
index 2b973f5..467a73b 100644
--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -1716,7 +1716,7 @@ static const struct snd_pci_quirk stac92hd83xxx_cfg_t=
bl[] =3D {
 	SND_PCI_QUIRK(PCI_VENDOR_ID_HP, 0x1658,
 			  "HP", STAC_92HD83XXX_HP_cNB11_INTQUAD),
 	SND_PCI_QUIRK(PCI_VENDOR_ID_HP, 0x1659,
-			  "HP", STAC_92HD83XXX_HP_cNB11_INTQUAD),
+			  "HP Pavilion dv7", STAC_HP_DV7_4000),
 	SND_PCI_QUIRK(PCI_VENDOR_ID_HP, 0x165A,
 			  "HP", STAC_92HD83XXX_HP_cNB11_INTQUAD),
 	SND_PCI_QUIRK(PCI_VENDOR_ID_HP, 0x165B,
diff --git a/sound/usb/midi.c b/sound/usb/midi.c
index eeefbce..34b9bb7 100644
--- a/sound/usb/midi.c
+++ b/sound/usb/midi.c
@@ -116,6 +116,7 @@ struct snd_usb_midi {
 	struct list_head list;
 	struct timer_list error_timer;
 	spinlock_t disc_lock;
+	struct rw_semaphore disc_rwsem;
 	struct mutex mutex;
 	u32 usb_id;
 	int next_midi_device;
@@ -125,8 +126,10 @@ struct snd_usb_midi {
 		struct snd_usb_midi_in_endpoint *in;
 	} endpoints[MIDI_MAX_ENDPOINTS];
 	unsigned long input_triggered;
-	unsigned int opened;
+	bool autopm_reference;
+	unsigned int opened[2];
 	unsigned char disconnected;
+	unsigned char input_running;
=20
 	struct snd_kcontrol *roland_load_ctl;
 };
@@ -148,7 +151,6 @@ struct snd_usb_midi_out_endpoint {
 		struct snd_usb_midi_out_endpoint* ep;
 		struct snd_rawmidi_substream *substream;
 		int active;
-		bool autopm_reference;
 		uint8_t cable;		/* cable number << 4 */
 		uint8_t state;
 #define STATE_UNKNOWN	0
@@ -1033,29 +1035,58 @@ static void update_roland_altsetting(struct snd_usb=
_midi* umidi)
 	snd_usbmidi_input_start(&umidi->list);
 }
=20
-static void substream_open(struct snd_rawmidi_substream *substream, int op=
en)
+static int substream_open(struct snd_rawmidi_substream *substream, int dir=
,
+			  int open)
 {
 	struct snd_usb_midi* umidi =3D substream->rmidi->private_data;
 	struct snd_kcontrol *ctl;
+	int err;
+
+	down_read(&umidi->disc_rwsem);
+	if (umidi->disconnected) {
+		up_read(&umidi->disc_rwsem);
+		return open ? -ENODEV : 0;
+	}
=20
 	mutex_lock(&umidi->mutex);
 	if (open) {
-		if (umidi->opened++ =3D=3D 0 && umidi->roland_load_ctl) {
-			ctl =3D umidi->roland_load_ctl;
-			ctl->vd[0].access |=3D SNDRV_CTL_ELEM_ACCESS_INACTIVE;
-			snd_ctl_notify(umidi->card,
+		if (!umidi->opened[0] && !umidi->opened[1]) {
+			err =3D usb_autopm_get_interface(umidi->iface);
+			umidi->autopm_reference =3D err >=3D 0;
+			if (err < 0 && err !=3D -EACCES) {
+				mutex_unlock(&umidi->mutex);
+				up_read(&umidi->disc_rwsem);
+				return -EIO;
+			}
+			if (umidi->roland_load_ctl) {
+				ctl =3D umidi->roland_load_ctl;
+				ctl->vd[0].access |=3D SNDRV_CTL_ELEM_ACCESS_INACTIVE;
+				snd_ctl_notify(umidi->card,
 				       SNDRV_CTL_EVENT_MASK_INFO, &ctl->id);
-			update_roland_altsetting(umidi);
+				update_roland_altsetting(umidi);
+			}
 		}
+		umidi->opened[dir]++;
+		if (umidi->opened[1])
+			snd_usbmidi_input_start(&umidi->list);
 	} else {
-		if (--umidi->opened =3D=3D 0 && umidi->roland_load_ctl) {
-			ctl =3D umidi->roland_load_ctl;
-			ctl->vd[0].access &=3D ~SNDRV_CTL_ELEM_ACCESS_INACTIVE;
-			snd_ctl_notify(umidi->card,
+		umidi->opened[dir]--;
+		if (!umidi->opened[1])
+			snd_usbmidi_input_stop(&umidi->list);
+		if (!umidi->opened[0] && !umidi->opened[1]) {
+			if (umidi->roland_load_ctl) {
+				ctl =3D umidi->roland_load_ctl;
+				ctl->vd[0].access &=3D ~SNDRV_CTL_ELEM_ACCESS_INACTIVE;
+				snd_ctl_notify(umidi->card,
 				       SNDRV_CTL_EVENT_MASK_INFO, &ctl->id);
+			}
+			if (umidi->autopm_reference)
+				usb_autopm_put_interface(umidi->iface);
 		}
 	}
 	mutex_unlock(&umidi->mutex);
+	up_read(&umidi->disc_rwsem);
+	return 0;
 }
=20
 static int snd_usbmidi_output_open(struct snd_rawmidi_substream *substream=
)
@@ -1063,7 +1094,6 @@ static int snd_usbmidi_output_open(struct snd_rawmidi=
_substream *substream)
 	struct snd_usb_midi* umidi =3D substream->rmidi->private_data;
 	struct usbmidi_out_port* port =3D NULL;
 	int i, j;
-	int err;
=20
 	for (i =3D 0; i < MIDI_MAX_ENDPOINTS; ++i)
 		if (umidi->endpoints[i].out)
@@ -1076,25 +1106,15 @@ static int snd_usbmidi_output_open(struct snd_rawmi=
di_substream *substream)
 		snd_BUG();
 		return -ENXIO;
 	}
-	err =3D usb_autopm_get_interface(umidi->iface);
-	port->autopm_reference =3D err >=3D 0;
-	if (err < 0 && err !=3D -EACCES)
-		return -EIO;
+
 	substream->runtime->private_data =3D port;
 	port->state =3D STATE_UNKNOWN;
-	substream_open(substream, 1);
-	return 0;
+	return substream_open(substream, 0, 1);
 }
=20
 static int snd_usbmidi_output_close(struct snd_rawmidi_substream *substrea=
m)
 {
-	struct snd_usb_midi* umidi =3D substream->rmidi->private_data;
-	struct usbmidi_out_port *port =3D substream->runtime->private_data;
-
-	substream_open(substream, 0);
-	if (port->autopm_reference)
-		usb_autopm_put_interface(umidi->iface);
-	return 0;
+	return substream_open(substream, 0, 0);
 }
=20
 static void snd_usbmidi_output_trigger(struct snd_rawmidi_substream *subst=
ream, int up)
@@ -1147,14 +1167,12 @@ static void snd_usbmidi_output_drain(struct snd_raw=
midi_substream *substream)
=20
 static int snd_usbmidi_input_open(struct snd_rawmidi_substream *substream)
 {
-	substream_open(substream, 1);
-	return 0;
+	return substream_open(substream, 1, 1);
 }
=20
 static int snd_usbmidi_input_close(struct snd_rawmidi_substream *substream=
)
 {
-	substream_open(substream, 0);
-	return 0;
+	return substream_open(substream, 1, 0);
 }
=20
 static void snd_usbmidi_input_trigger(struct snd_rawmidi_substream *substr=
eam, int up)
@@ -1403,9 +1421,12 @@ void snd_usbmidi_disconnect(struct list_head* p)
 	 * a timer may submit an URB. To reliably break the cycle
 	 * a flag under lock must be used
 	 */
+	down_write(&umidi->disc_rwsem);
 	spin_lock_irq(&umidi->disc_lock);
 	umidi->disconnected =3D 1;
 	spin_unlock_irq(&umidi->disc_lock);
+	up_write(&umidi->disc_rwsem);
+
 	for (i =3D 0; i < MIDI_MAX_ENDPOINTS; ++i) {
 		struct snd_usb_midi_endpoint* ep =3D &umidi->endpoints[i];
 		if (ep->out)
@@ -2060,12 +2081,15 @@ void snd_usbmidi_input_stop(struct list_head* p)
 	unsigned int i, j;
=20
 	umidi =3D list_entry(p, struct snd_usb_midi, list);
+	if (!umidi->input_running)
+		return;
 	for (i =3D 0; i < MIDI_MAX_ENDPOINTS; ++i) {
 		struct snd_usb_midi_endpoint* ep =3D &umidi->endpoints[i];
 		if (ep->in)
 			for (j =3D 0; j < INPUT_URBS; ++j)
 				usb_kill_urb(ep->in->urbs[j]);
 	}
+	umidi->input_running =3D 0;
 }
=20
 static void snd_usbmidi_input_start_ep(struct snd_usb_midi_in_endpoint* ep=
)
@@ -2090,8 +2114,11 @@ void snd_usbmidi_input_start(struct list_head* p)
 	int i;
=20
 	umidi =3D list_entry(p, struct snd_usb_midi, list);
+	if (umidi->input_running || !umidi->opened[1])
+		return;
 	for (i =3D 0; i < MIDI_MAX_ENDPOINTS; ++i)
 		snd_usbmidi_input_start_ep(umidi->endpoints[i].in);
+	umidi->input_running =3D 1;
 }
=20
 /*
@@ -2117,6 +2144,7 @@ int snd_usbmidi_create(struct snd_card *card,
 	umidi->usb_protocol_ops =3D &snd_usbmidi_standard_ops;
 	init_timer(&umidi->error_timer);
 	spin_lock_init(&umidi->disc_lock);
+	init_rwsem(&umidi->disc_rwsem);
 	mutex_init(&umidi->mutex);
 	umidi->usb_id =3D USB_ID(le16_to_cpu(umidi->dev->descriptor.idVendor),
 			       le16_to_cpu(umidi->dev->descriptor.idProduct));
@@ -2229,9 +2257,6 @@ int snd_usbmidi_create(struct snd_card *card,
 	}
=20
 	list_add_tail(&umidi->list, midi_list);
-
-	for (i =3D 0; i < MIDI_MAX_ENDPOINTS; ++i)
-		snd_usbmidi_input_start_ep(umidi->endpoints[i].in);
 	return 0;
 }
=20



--=-Jednz7RuyNwCxbQOx9Ff
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUOYuGee/yOyVhhEJAQoyEhAA0nYAFXlRpg6RooXZTjXKVeQo9Wc98UFm
i/KKTnMWsQlwlYkF1n29RdgU42oYM/8TmkTM+t59JBrn12JEoZvnGuZmjsssaaTl
gdUR/Td2LR983WQ2D0MCiQhHz989T5k9iNBa3WQkIJuGnOujg28BS4wD3HTULtw7
oUDqtU0qGJcDKIF84oHoDnHsTKuYlmF6TwIdqsMQxNxNplSjOw8EWWoiDPyHEB5g
EaqBFK9CsUOcl8ENC9MhfKUHlAd3jJac/J6PynqPxo4q0ulEFAL1p4jThEKwdN59
01hPboI2/OMrQq1KpVCiqubl39QFdCxV4LpWD63XUPn/LNMtYoWGVL2vHLKcwF/E
NhOaubCjGrFQ65hcUO3uENyJ9aPGvUR/7CpjgJmBjtHMSblI7efxrzCSdnMEcfNP
NuEse23H4qXuSIWWSu1YhlzU2HMytKiHHCFTQb9fOP6e8L3FdZeI8c1D5uULHTeg
/Gp8xTrEBcCWJO0dLyrdmS92y2gAKEPA9qGOjXRdQUcsHWYoV/KUT0lD5zHRTk4+
m66hQCoMVng+ms543Jm0b+vpuXjGiYrjglMifMkoeqBfDxcRWwzbqgOMguUtjBqP
4ChR/ulbh2nQ2Y33VA0qxk7Ig1cmB5ytAcSCRwjGCyYZWnCEv17f23FgWAbZHFuQ
j8HDTcbO5DM=
=uBk4
-----END PGP SIGNATURE-----

--=-Jednz7RuyNwCxbQOx9Ff--
