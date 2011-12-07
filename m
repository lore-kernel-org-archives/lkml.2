Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933033Ab1LGXxx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 18:53:53 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:34031 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753668Ab1LGXxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 18:53:51 -0500
X-Authority-Analysis: v=2.0 cv=FIuZNpUs c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=5SG0PmZfjMsA:10 a=VwQbUJbxAAAA:8 a=W98gzNEr8RGV3-i1FtcA:9 a=WJbGz3kr0NphWRibvTsA:7 a=QEXdDO2ut3YA:10 a=bD-9mOnkiZiMM1B5:21 a=2wI0_A3e-OsPhMLa:21 a=yPd-oTK1le2s_Crre9AA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: [ANNOUNCE] 3.0.12-rt30
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Clark Williams <williams@redhat.com>,
        John Kacur <jkacur@redhat.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-93wtmk+M2Y1yd3egnV3f"
Date: Wed, 07 Dec 2011 18:53:47 -0500
Message-ID: <1323302027.30977.117.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-93wtmk+M2Y1yd3egnV3f
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


Dear RT Folks,

I'm pleased to announce the 3.0.12-rt30 stable release.


You can get this release via the git tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git

  Head SHA1: b6154617aa6dc001d1ccf0e90a19cd857619dd03


Or to build 3.0.12-rt30 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.0/linux-3.0.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.0/patch-3.0.12.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.0/patch-3.0.12-rt30.=
patch.xz


You can also build from 3.0.12-rt29 by applying the incremental patch:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.0/incr/patch-3.0.12-=
rt29-rt30.patch.xz


The broken out patches are available at:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.0/patches-3.0.12-rt3=
0.tar.xz

Enjoy,

-- Steve


Changes from 3.0.12-rt29:

---

Andre Przywara (1):
      KVM: fix XSAVE bit scanning (now properly)

Avi Kivity (1):
      KVM: Sanitize cpuid

Clark Williams (1):
      ACPI: Convert embedded controller lock to raw spinlock

Edward Donovan (1):
      genirq: fix regression in irqfixup, irqpoll

Ingo Molnar (1):
      tasklet/rt: Prevent tasklets from going into infinite spin in RT

Peter Zijlstra (2):
      slab, lockdep: Fix silly bug
      slab, lockdep: Annotate all slab caches

Roland Dreier (1):
      intel-iommu: Fix AB-BA lockdep report

Steven Rostedt (1):
      Linux 3.0.12-rt30

Thomas Gleixner (3):
      wait: Provide __wake_up_all_locked
      pci: Use __wake_up_all_locked pci_unblock_user_cfg_access()
      acpi: Make gbl_[hardware|gpe]_lock raw

----
 arch/x86/kvm/x86.c              |   44 +++++++-
 drivers/acpi/acpica/acglobal.h  |    4 +-
 drivers/acpi/acpica/evgpe.c     |    4 +-
 drivers/acpi/acpica/evgpeblk.c  |    8 +-
 drivers/acpi/acpica/evgpeutil.c |   12 +-
 drivers/acpi/acpica/evxface.c   |   10 +-
 drivers/acpi/acpica/evxfgpe.c   |   24 +++---
 drivers/acpi/acpica/hwregs.c    |    4 +-
 drivers/acpi/acpica/hwxface.c   |    4 +-
 drivers/acpi/acpica/utmutex.c   |   21 +----
 drivers/acpi/ec.c               |   22 ++--
 drivers/acpi/internal.h         |    2 +-
 drivers/pci/access.c            |    2 +-
 drivers/pci/intel-iommu.c       |    4 +-
 include/linux/interrupt.h       |   39 ++++----
 include/linux/wait.h            |    5 +-
 kernel/irq/spurious.c           |    4 +-
 kernel/sched.c                  |    4 +-
 kernel/softirq.c                |  208 ++++++++++++++++++++++++++++-------=
----
 localversion-rt                 |    2 +-
 mm/slab.c                       |   55 ++++++-----
 21 files changed, 302 insertions(+), 180 deletions(-)
---------------------------
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 545c61b..3567c76 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2283,6 +2283,13 @@ static void do_cpuid_1_ent(struct kvm_cpuid_entry2 *=
entry, u32 function,
 	entry->flags =3D 0;
 }
=20
+static bool supported_xcr0_bit(unsigned bit)
+{
+	u64 mask =3D ((u64)1 << bit);
+
+	return mask & (XSTATE_FP | XSTATE_SSE | XSTATE_YMM) & host_xcr0;
+}
+
 #define F(x) bit(X86_FEATURE_##x)
=20
 static void do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
@@ -2393,6 +2400,8 @@ static void do_cpuid_ent(struct kvm_cpuid_entry2 *ent=
ry, u32 function,
 		}
 		break;
 	}
+	case 9:
+		break;
 	case 0xb: {
 		int i, level_type;
=20
@@ -2410,16 +2419,17 @@ static void do_cpuid_ent(struct kvm_cpuid_entry2 *e=
ntry, u32 function,
 		break;
 	}
 	case 0xd: {
-		int i;
+		int idx, i;
=20
 		entry->flags |=3D KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
-		for (i =3D 1; *nent < maxnent && i < 64; ++i) {
-			if (entry[i].eax =3D=3D 0)
+		for (idx =3D 1, i =3D 1; *nent < maxnent && idx < 64; ++idx) {
+			do_cpuid_1_ent(&entry[i], function, idx);
+			if (entry[i].eax =3D=3D 0 || !supported_xcr0_bit(idx))
 				continue;
-			do_cpuid_1_ent(&entry[i], function, i);
 			entry[i].flags |=3D
 			       KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
 			++*nent;
+			++i;
 		}
 		break;
 	}
@@ -2451,6 +2461,24 @@ static void do_cpuid_ent(struct kvm_cpuid_entry2 *en=
try, u32 function,
 		entry->ecx &=3D kvm_supported_word6_x86_features;
 		cpuid_mask(&entry->ecx, 6);
 		break;
+	case 0x80000008: {
+		unsigned g_phys_as =3D (entry->eax >> 16) & 0xff;
+		unsigned virt_as =3D max((entry->eax >> 8) & 0xff, 48U);
+		unsigned phys_as =3D entry->eax & 0xff;
+
+		if (!g_phys_as)
+			g_phys_as =3D phys_as;
+		entry->eax =3D g_phys_as | (virt_as << 8);
+		entry->ebx =3D entry->edx =3D 0;
+		break;
+	}
+	case 0x80000019:
+		entry->ecx =3D entry->edx =3D 0;
+		break;
+	case 0x8000001a:
+		break;
+	case 0x8000001d:
+		break;
 	/*Add support for Centaur's CPUID instruction*/
 	case 0xC0000000:
 		/*Just support up to 0xC0000004 now*/
@@ -2460,10 +2488,16 @@ static void do_cpuid_ent(struct kvm_cpuid_entry2 *e=
ntry, u32 function,
 		entry->edx &=3D kvm_supported_word5_x86_features;
 		cpuid_mask(&entry->edx, 5);
 		break;
+	case 3: /* Processor serial number */
+	case 5: /* MONITOR/MWAIT */
+	case 6: /* Thermal management */
+	case 0xA: /* Architectural Performance Monitoring */
+	case 0x80000007: /* Advanced power management */
 	case 0xC0000002:
 	case 0xC0000003:
 	case 0xC0000004:
-		/*Now nothing to do, reserved for the future*/
+	default:
+		entry->eax =3D entry->ebx =3D entry->ecx =3D entry->edx =3D 0;
 		break;
 	}
=20
diff --git a/drivers/acpi/acpica/acglobal.h b/drivers/acpi/acpica/acglobal.=
h
index 73863d8..6c169a2 100644
--- a/drivers/acpi/acpica/acglobal.h
+++ b/drivers/acpi/acpica/acglobal.h
@@ -229,8 +229,8 @@ ACPI_EXTERN u8 acpi_gbl_global_lock_pending;
  * Spinlocks are used for interfaces that can be possibly called at
  * interrupt level
  */
-ACPI_EXTERN acpi_spinlock acpi_gbl_gpe_lock;	/* For GPE data structs and r=
egisters */
-ACPI_EXTERN acpi_spinlock acpi_gbl_hardware_lock;	/* For ACPI H/W except G=
PE registers */
+extern raw_spinlock_t acpi_gbl_gpe_lock;	/* For GPE data structs and regis=
ters */
+extern raw_spinlock_t acpi_gbl_hardware_lock;	/* For ACPI H/W except GPE r=
egisters */
=20
 /*************************************************************************=
****
  *
diff --git a/drivers/acpi/acpica/evgpe.c b/drivers/acpi/acpica/evgpe.c
index 65c79ad..36e7e10 100644
--- a/drivers/acpi/acpica/evgpe.c
+++ b/drivers/acpi/acpica/evgpe.c
@@ -357,7 +357,7 @@ u32 acpi_ev_gpe_detect(struct acpi_gpe_xrupt_info * gpe=
_xrupt_list)
 	 * Note: Not necessary to obtain the hardware lock, since the GPE
 	 * registers are owned by the gpe_lock.
 	 */
-	flags =3D acpi_os_acquire_lock(acpi_gbl_gpe_lock);
+	raw_spin_lock_irqsave(&acpi_gbl_gpe_lock, flags);
=20
 	/* Examine all GPE blocks attached to this interrupt level */
=20
@@ -440,7 +440,7 @@ u32 acpi_ev_gpe_detect(struct acpi_gpe_xrupt_info * gpe=
_xrupt_list)
=20
       unlock_and_exit:
=20
-	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
+	raw_spin_unlock_irqrestore(&acpi_gbl_gpe_lock, flags);
 	return (int_status);
 }
=20
diff --git a/drivers/acpi/acpica/evgpeblk.c b/drivers/acpi/acpica/evgpeblk.=
c
index ca2c41a..60c47b9 100644
--- a/drivers/acpi/acpica/evgpeblk.c
+++ b/drivers/acpi/acpica/evgpeblk.c
@@ -95,7 +95,7 @@ acpi_ev_install_gpe_block(struct acpi_gpe_block_info *gpe=
_block,
=20
 	/* Install the new block at the end of the list with lock */
=20
-	flags =3D acpi_os_acquire_lock(acpi_gbl_gpe_lock);
+	raw_spin_lock_irqsave(&acpi_gbl_gpe_lock, flags);
 	if (gpe_xrupt_block->gpe_block_list_head) {
 		next_gpe_block =3D gpe_xrupt_block->gpe_block_list_head;
 		while (next_gpe_block->next) {
@@ -109,7 +109,7 @@ acpi_ev_install_gpe_block(struct acpi_gpe_block_info *g=
pe_block,
 	}
=20
 	gpe_block->xrupt_block =3D gpe_xrupt_block;
-	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
+	raw_spin_unlock_irqrestore(&acpi_gbl_gpe_lock, flags);
=20
       unlock_and_exit:
 	status =3D acpi_ut_release_mutex(ACPI_MTX_EVENTS);
@@ -156,7 +156,7 @@ acpi_status acpi_ev_delete_gpe_block(struct acpi_gpe_bl=
ock_info *gpe_block)
 	} else {
 		/* Remove the block on this interrupt with lock */
=20
-		flags =3D acpi_os_acquire_lock(acpi_gbl_gpe_lock);
+		raw_spin_lock_irqsave(&acpi_gbl_gpe_lock, flags);
 		if (gpe_block->previous) {
 			gpe_block->previous->next =3D gpe_block->next;
 		} else {
@@ -167,7 +167,7 @@ acpi_status acpi_ev_delete_gpe_block(struct acpi_gpe_bl=
ock_info *gpe_block)
 		if (gpe_block->next) {
 			gpe_block->next->previous =3D gpe_block->previous;
 		}
-		acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
+		raw_spin_unlock_irqrestore(&acpi_gbl_gpe_lock, flags);
 	}
=20
 	acpi_current_gpe_count -=3D gpe_block->gpe_count;
diff --git a/drivers/acpi/acpica/evgpeutil.c b/drivers/acpi/acpica/evgpeuti=
l.c
index 80a81d0..895b68ab 100644
--- a/drivers/acpi/acpica/evgpeutil.c
+++ b/drivers/acpi/acpica/evgpeutil.c
@@ -70,7 +70,7 @@ acpi_ev_walk_gpe_list(acpi_gpe_callback gpe_walk_callback=
, void *context)
=20
 	ACPI_FUNCTION_TRACE(ev_walk_gpe_list);
=20
-	flags =3D acpi_os_acquire_lock(acpi_gbl_gpe_lock);
+	raw_spin_lock_irqsave(&acpi_gbl_gpe_lock, flags);
=20
 	/* Walk the interrupt level descriptor list */
=20
@@ -101,7 +101,7 @@ acpi_ev_walk_gpe_list(acpi_gpe_callback gpe_walk_callba=
ck, void *context)
 	}
=20
       unlock_and_exit:
-	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
+	raw_spin_unlock_irqrestore(&acpi_gbl_gpe_lock, flags);
 	return_ACPI_STATUS(status);
 }
=20
@@ -237,7 +237,7 @@ struct acpi_gpe_xrupt_info *acpi_ev_get_gpe_xrupt_block=
(u32 interrupt_number)
=20
 	/* Install new interrupt descriptor with spin lock */
=20
-	flags =3D acpi_os_acquire_lock(acpi_gbl_gpe_lock);
+	raw_spin_lock_irqsave(&acpi_gbl_gpe_lock, flags);
 	if (acpi_gbl_gpe_xrupt_list_head) {
 		next_gpe_xrupt =3D acpi_gbl_gpe_xrupt_list_head;
 		while (next_gpe_xrupt->next) {
@@ -249,7 +249,7 @@ struct acpi_gpe_xrupt_info *acpi_ev_get_gpe_xrupt_block=
(u32 interrupt_number)
 	} else {
 		acpi_gbl_gpe_xrupt_list_head =3D gpe_xrupt;
 	}
-	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
+	raw_spin_unlock_irqrestore(&acpi_gbl_gpe_lock, flags);
=20
 	/* Install new interrupt handler if not SCI_INT */
=20
@@ -306,7 +306,7 @@ acpi_status acpi_ev_delete_gpe_xrupt(struct acpi_gpe_xr=
upt_info *gpe_xrupt)
=20
 	/* Unlink the interrupt block with lock */
=20
-	flags =3D acpi_os_acquire_lock(acpi_gbl_gpe_lock);
+	raw_spin_lock_irqsave(&acpi_gbl_gpe_lock, flags);
 	if (gpe_xrupt->previous) {
 		gpe_xrupt->previous->next =3D gpe_xrupt->next;
 	} else {
@@ -318,7 +318,7 @@ acpi_status acpi_ev_delete_gpe_xrupt(struct acpi_gpe_xr=
upt_info *gpe_xrupt)
 	if (gpe_xrupt->next) {
 		gpe_xrupt->next->previous =3D gpe_xrupt->previous;
 	}
-	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
+	raw_spin_unlock_irqrestore(&acpi_gbl_gpe_lock, flags);
=20
 	/* Free the block */
=20
diff --git a/drivers/acpi/acpica/evxface.c b/drivers/acpi/acpica/evxface.c
index e114140..e849c10 100644
--- a/drivers/acpi/acpica/evxface.c
+++ b/drivers/acpi/acpica/evxface.c
@@ -750,7 +750,7 @@ acpi_install_gpe_handler(acpi_handle gpe_device,
 		goto unlock_and_exit;
 	}
=20
-	flags =3D acpi_os_acquire_lock(acpi_gbl_gpe_lock);
+	raw_spin_lock_irqsave(&acpi_gbl_gpe_lock, flags);
=20
 	/* Ensure that we have a valid GPE number */
=20
@@ -798,14 +798,14 @@ acpi_install_gpe_handler(acpi_handle gpe_device,
 	    ~(ACPI_GPE_XRUPT_TYPE_MASK | ACPI_GPE_DISPATCH_MASK);
 	gpe_event_info->flags |=3D (u8) (type | ACPI_GPE_DISPATCH_HANDLER);
=20
-	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
+	raw_spin_unlock_irqrestore(&acpi_gbl_gpe_lock, flags);
=20
 unlock_and_exit:
 	(void)acpi_ut_release_mutex(ACPI_MTX_EVENTS);
 	return_ACPI_STATUS(status);
=20
 free_and_exit:
-	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
+	raw_spin_unlock_irqrestore(&acpi_gbl_gpe_lock, flags);
 	ACPI_FREE(handler);
 	goto unlock_and_exit;
 }
@@ -852,7 +852,7 @@ acpi_remove_gpe_handler(acpi_handle gpe_device,
 		return_ACPI_STATUS(status);
 	}
=20
-	flags =3D acpi_os_acquire_lock(acpi_gbl_gpe_lock);
+	raw_spin_lock_irqsave(&acpi_gbl_gpe_lock, flags);
=20
 	/* Ensure that we have a valid GPE number */
=20
@@ -903,7 +903,7 @@ acpi_remove_gpe_handler(acpi_handle gpe_device,
 	ACPI_FREE(handler);
=20
 unlock_and_exit:
-	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
+	raw_spin_unlock_irqrestore(&acpi_gbl_gpe_lock, flags);
=20
 	(void)acpi_ut_release_mutex(ACPI_MTX_EVENTS);
 	return_ACPI_STATUS(status);
diff --git a/drivers/acpi/acpica/evxfgpe.c b/drivers/acpi/acpica/evxfgpe.c
index 52aaff3..ce07ebb 100644
--- a/drivers/acpi/acpica/evxfgpe.c
+++ b/drivers/acpi/acpica/evxfgpe.c
@@ -121,7 +121,7 @@ acpi_status acpi_enable_gpe(acpi_handle gpe_device, u32=
 gpe_number)
=20
 	ACPI_FUNCTION_TRACE(acpi_enable_gpe);
=20
-	flags =3D acpi_os_acquire_lock(acpi_gbl_gpe_lock);
+	raw_spin_lock_irqsave(&acpi_gbl_gpe_lock, flags);
=20
 	/* Ensure that we have a valid GPE number */
=20
@@ -130,7 +130,7 @@ acpi_status acpi_enable_gpe(acpi_handle gpe_device, u32=
 gpe_number)
 		status =3D acpi_ev_add_gpe_reference(gpe_event_info);
 	}
=20
-	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
+	raw_spin_unlock_irqrestore(&acpi_gbl_gpe_lock, flags);
 	return_ACPI_STATUS(status);
 }
 ACPI_EXPORT_SYMBOL(acpi_enable_gpe)
@@ -158,7 +158,7 @@ acpi_status acpi_disable_gpe(acpi_handle gpe_device, u3=
2 gpe_number)
=20
 	ACPI_FUNCTION_TRACE(acpi_disable_gpe);
=20
-	flags =3D acpi_os_acquire_lock(acpi_gbl_gpe_lock);
+	raw_spin_lock_irqsave(&acpi_gbl_gpe_lock, flags);
=20
 	/* Ensure that we have a valid GPE number */
=20
@@ -167,7 +167,7 @@ acpi_status acpi_disable_gpe(acpi_handle gpe_device, u3=
2 gpe_number)
 		status =3D acpi_ev_remove_gpe_reference(gpe_event_info) ;
 	}
=20
-	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
+	raw_spin_unlock_irqrestore(&acpi_gbl_gpe_lock, flags);
 	return_ACPI_STATUS(status);
 }
 ACPI_EXPORT_SYMBOL(acpi_disable_gpe)
@@ -214,7 +214,7 @@ acpi_setup_gpe_for_wake(acpi_handle wake_device,
 		return_ACPI_STATUS(AE_BAD_PARAMETER);
 	}
=20
-	flags =3D acpi_os_acquire_lock(acpi_gbl_gpe_lock);
+	raw_spin_lock_irqsave(&acpi_gbl_gpe_lock, flags);
=20
 	/* Ensure that we have a valid GPE number */
=20
@@ -270,7 +270,7 @@ acpi_setup_gpe_for_wake(acpi_handle wake_device,
 	status =3D AE_OK;
=20
  unlock_and_exit:
-	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
+	raw_spin_unlock_irqrestore(&acpi_gbl_gpe_lock, flags);
 	return_ACPI_STATUS(status);
 }
 ACPI_EXPORT_SYMBOL(acpi_setup_gpe_for_wake)
@@ -300,7 +300,7 @@ acpi_status acpi_set_gpe_wake_mask(acpi_handle gpe_devi=
ce, u32 gpe_number, u8 ac
=20
 	ACPI_FUNCTION_TRACE(acpi_set_gpe_wake_mask);
=20
-	flags =3D acpi_os_acquire_lock(acpi_gbl_gpe_lock);
+	raw_spin_lock_irqsave(&acpi_gbl_gpe_lock, flags);
=20
 	/*
 	 * Ensure that we have a valid GPE number and that this GPE is in
@@ -346,7 +346,7 @@ acpi_status acpi_set_gpe_wake_mask(acpi_handle gpe_devi=
ce, u32 gpe_number, u8 ac
 	}
=20
 unlock_and_exit:
-	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
+	raw_spin_unlock_irqrestore(&acpi_gbl_gpe_lock, flags);
 	return_ACPI_STATUS(status);
 }
=20
@@ -372,7 +372,7 @@ acpi_status acpi_clear_gpe(acpi_handle gpe_device, u32 =
gpe_number)
=20
 	ACPI_FUNCTION_TRACE(acpi_clear_gpe);
=20
-	flags =3D acpi_os_acquire_lock(acpi_gbl_gpe_lock);
+	raw_spin_lock_irqsave(&acpi_gbl_gpe_lock, flags);
=20
 	/* Ensure that we have a valid GPE number */
=20
@@ -385,7 +385,7 @@ acpi_status acpi_clear_gpe(acpi_handle gpe_device, u32 =
gpe_number)
 	status =3D acpi_hw_clear_gpe(gpe_event_info);
=20
       unlock_and_exit:
-	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
+	raw_spin_unlock_irqrestore(&acpi_gbl_gpe_lock, flags);
 	return_ACPI_STATUS(status);
 }
=20
@@ -415,7 +415,7 @@ acpi_get_gpe_status(acpi_handle gpe_device,
=20
 	ACPI_FUNCTION_TRACE(acpi_get_gpe_status);
=20
-	flags =3D acpi_os_acquire_lock(acpi_gbl_gpe_lock);
+	raw_spin_lock_irqsave(&acpi_gbl_gpe_lock, flags);
=20
 	/* Ensure that we have a valid GPE number */
=20
@@ -433,7 +433,7 @@ acpi_get_gpe_status(acpi_handle gpe_device,
 		*event_status |=3D ACPI_EVENT_FLAG_HANDLE;
=20
       unlock_and_exit:
-	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
+	raw_spin_unlock_irqrestore(&acpi_gbl_gpe_lock, flags);
 	return_ACPI_STATUS(status);
 }
=20
diff --git a/drivers/acpi/acpica/hwregs.c b/drivers/acpi/acpica/hwregs.c
index 55accb7..4772930 100644
--- a/drivers/acpi/acpica/hwregs.c
+++ b/drivers/acpi/acpica/hwregs.c
@@ -263,7 +263,7 @@ acpi_status acpi_hw_clear_acpi_status(void)
 			  ACPI_BITMASK_ALL_FIXED_STATUS,
 			  ACPI_FORMAT_UINT64(acpi_gbl_xpm1a_status.address)));
=20
-	lock_flags =3D acpi_os_acquire_lock(acpi_gbl_hardware_lock);
+	raw_spin_lock_irqsave(&acpi_gbl_hardware_lock, lock_flags);
=20
 	/* Clear the fixed events in PM1 A/B */
=20
@@ -278,7 +278,7 @@ acpi_status acpi_hw_clear_acpi_status(void)
 	status =3D acpi_ev_walk_gpe_list(acpi_hw_clear_gpe_block, NULL);
=20
       unlock_and_exit:
-	acpi_os_release_lock(acpi_gbl_hardware_lock, lock_flags);
+	raw_spin_unlock_irqrestore(&acpi_gbl_hardware_lock, lock_flags);
 	return_ACPI_STATUS(status);
 }
=20
diff --git a/drivers/acpi/acpica/hwxface.c b/drivers/acpi/acpica/hwxface.c
index f75f81a..76159ba 100644
--- a/drivers/acpi/acpica/hwxface.c
+++ b/drivers/acpi/acpica/hwxface.c
@@ -386,7 +386,7 @@ acpi_status acpi_write_bit_register(u32 register_id, u3=
2 value)
 		return_ACPI_STATUS(AE_BAD_PARAMETER);
 	}
=20
-	lock_flags =3D acpi_os_acquire_lock(acpi_gbl_hardware_lock);
+	raw_spin_lock_irqsave(&acpi_gbl_hardware_lock, lock_flags);
=20
 	/*
 	 * At this point, we know that the parent register is one of the
@@ -447,7 +447,7 @@ acpi_status acpi_write_bit_register(u32 register_id, u3=
2 value)
=20
 unlock_and_exit:
=20
-	acpi_os_release_lock(acpi_gbl_hardware_lock, lock_flags);
+	raw_spin_unlock_irqrestore(&acpi_gbl_hardware_lock, lock_flags);
 	return_ACPI_STATUS(status);
 }
=20
diff --git a/drivers/acpi/acpica/utmutex.c b/drivers/acpi/acpica/utmutex.c
index 7d797e2..420eecf 100644
--- a/drivers/acpi/acpica/utmutex.c
+++ b/drivers/acpi/acpica/utmutex.c
@@ -52,6 +52,9 @@ static acpi_status acpi_ut_create_mutex(acpi_mutex_handle=
 mutex_id);
=20
 static void acpi_ut_delete_mutex(acpi_mutex_handle mutex_id);
=20
+DEFINE_RAW_SPINLOCK(acpi_gbl_gpe_lock);
+DEFINE_RAW_SPINLOCK(acpi_gbl_hardware_lock);
+
 /*************************************************************************=
******
  *
  * FUNCTION:    acpi_ut_mutex_initialize
@@ -81,18 +84,6 @@ acpi_status acpi_ut_mutex_initialize(void)
 		}
 	}
=20
-	/* Create the spinlocks for use at interrupt level */
-
-	status =3D acpi_os_create_lock (&acpi_gbl_gpe_lock);
-	if (ACPI_FAILURE (status)) {
-		return_ACPI_STATUS (status);
-	}
-
-	status =3D acpi_os_create_lock (&acpi_gbl_hardware_lock);
-	if (ACPI_FAILURE (status)) {
-		return_ACPI_STATUS (status);
-	}
-
 	/* Mutex for _OSI support */
 	status =3D acpi_os_create_mutex(&acpi_gbl_osi_mutex);
 	if (ACPI_FAILURE(status)) {
@@ -132,13 +123,7 @@ void acpi_ut_mutex_terminate(void)
=20
 	acpi_os_delete_mutex(acpi_gbl_osi_mutex);
=20
-	/* Delete the spinlocks */
-
-	acpi_os_delete_lock(acpi_gbl_gpe_lock);
-	acpi_os_delete_lock(acpi_gbl_hardware_lock);
-
 	/* Delete the reader/writer lock */
-
 	acpi_ut_delete_rw_lock(&acpi_gbl_namespace_rw_lock);
 	return_VOID;
 }
diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index b19a18d..5812e01 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -152,10 +152,10 @@ static int ec_transaction_done(struct acpi_ec *ec)
 {
 	unsigned long flags;
 	int ret =3D 0;
-	spin_lock_irqsave(&ec->curr_lock, flags);
+	raw_spin_lock_irqsave(&ec->curr_lock, flags);
 	if (!ec->curr || ec->curr->done)
 		ret =3D 1;
-	spin_unlock_irqrestore(&ec->curr_lock, flags);
+	raw_spin_unlock_irqrestore(&ec->curr_lock, flags);
 	return ret;
 }
=20
@@ -169,7 +169,7 @@ static void start_transaction(struct acpi_ec *ec)
 static void advance_transaction(struct acpi_ec *ec, u8 status)
 {
 	unsigned long flags;
-	spin_lock_irqsave(&ec->curr_lock, flags);
+	raw_spin_lock_irqsave(&ec->curr_lock, flags);
 	if (!ec->curr)
 		goto unlock;
 	if (ec->curr->wlen > ec->curr->wi) {
@@ -194,7 +194,7 @@ err:
 	if (in_interrupt())
 		++ec->curr->irq_count;
 unlock:
-	spin_unlock_irqrestore(&ec->curr_lock, flags);
+	raw_spin_unlock_irqrestore(&ec->curr_lock, flags);
 }
=20
 static int acpi_ec_sync_query(struct acpi_ec *ec);
@@ -232,9 +232,9 @@ static int ec_poll(struct acpi_ec *ec)
 		if (acpi_ec_read_status(ec) & ACPI_EC_FLAG_IBF)
 			break;
 		pr_debug(PREFIX "controller reset, restart transaction\n");
-		spin_lock_irqsave(&ec->curr_lock, flags);
+		raw_spin_lock_irqsave(&ec->curr_lock, flags);
 		start_transaction(ec);
-		spin_unlock_irqrestore(&ec->curr_lock, flags);
+		raw_spin_unlock_irqrestore(&ec->curr_lock, flags);
 	}
 	return -ETIME;
 }
@@ -247,17 +247,17 @@ static int acpi_ec_transaction_unlocked(struct acpi_e=
c *ec,
 	if (EC_FLAGS_MSI)
 		udelay(ACPI_EC_MSI_UDELAY);
 	/* start transaction */
-	spin_lock_irqsave(&ec->curr_lock, tmp);
+	raw_spin_lock_irqsave(&ec->curr_lock, tmp);
 	/* following two actions should be kept atomic */
 	ec->curr =3D t;
 	start_transaction(ec);
 	if (ec->curr->command =3D=3D ACPI_EC_COMMAND_QUERY)
 		clear_bit(EC_FLAGS_QUERY_PENDING, &ec->flags);
-	spin_unlock_irqrestore(&ec->curr_lock, tmp);
+	raw_spin_unlock_irqrestore(&ec->curr_lock, tmp);
 	ret =3D ec_poll(ec);
-	spin_lock_irqsave(&ec->curr_lock, tmp);
+	raw_spin_lock_irqsave(&ec->curr_lock, tmp);
 	ec->curr =3D NULL;
-	spin_unlock_irqrestore(&ec->curr_lock, tmp);
+	raw_spin_unlock_irqrestore(&ec->curr_lock, tmp);
 	return ret;
 }
=20
@@ -678,7 +678,7 @@ static struct acpi_ec *make_acpi_ec(void)
 	mutex_init(&ec->lock);
 	init_waitqueue_head(&ec->wait);
 	INIT_LIST_HEAD(&ec->list);
-	spin_lock_init(&ec->curr_lock);
+	raw_spin_lock_init(&ec->curr_lock);
 	return ec;
 }
=20
diff --git a/drivers/acpi/internal.h b/drivers/acpi/internal.h
index ca75b9c..68ed95f 100644
--- a/drivers/acpi/internal.h
+++ b/drivers/acpi/internal.h
@@ -62,7 +62,7 @@ struct acpi_ec {
 	wait_queue_head_t wait;
 	struct list_head list;
 	struct transaction *curr;
-	spinlock_t curr_lock;
+	raw_spinlock_t curr_lock;
 };
=20
 extern struct acpi_ec *first_ec;
diff --git a/drivers/pci/access.c b/drivers/pci/access.c
index fdaa42a..1a6cc67 100644
--- a/drivers/pci/access.c
+++ b/drivers/pci/access.c
@@ -441,7 +441,7 @@ void pci_unblock_user_cfg_access(struct pci_dev *dev)
 	WARN_ON(!dev->block_ucfg_access);
=20
 	dev->block_ucfg_access =3D 0;
-	wake_up_all(&pci_ucfg_wait);
+	wake_up_all_locked(&pci_ucfg_wait);
 	raw_spin_unlock_irqrestore(&pci_lock, flags);
 }
 EXPORT_SYMBOL_GPL(pci_unblock_user_cfg_access);
diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index 8c2564d..bc05a51 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -3569,6 +3569,8 @@ static void domain_remove_one_dev_info(struct dmar_do=
main *domain,
 			found =3D 1;
 	}
=20
+	spin_unlock_irqrestore(&device_domain_lock, flags);
+
 	if (found =3D=3D 0) {
 		unsigned long tmp_flags;
 		spin_lock_irqsave(&domain->iommu_lock, tmp_flags);
@@ -3585,8 +3587,6 @@ static void domain_remove_one_dev_info(struct dmar_do=
main *domain,
 			spin_unlock_irqrestore(&iommu->lock, tmp_flags);
 		}
 	}
-
-	spin_unlock_irqrestore(&device_domain_lock, flags);
 }
=20
 static void vm_domain_remove_all_dev_info(struct dmar_domain *domain)
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index a62158f..3142442 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -501,8 +501,9 @@ extern void __send_remote_softirq(struct call_single_da=
ta *cp, int cpu,
      to be executed on some cpu at least once after this.
    * If the tasklet is already scheduled, but its execution is still not
      started, it will be executed only once.
-   * If this tasklet is already running on another CPU (or schedule is cal=
led
-     from tasklet itself), it is rescheduled for later.
+   * If this tasklet is already running on another CPU, it is rescheduled
+     for later.
+   * Schedule must not be called from the tasklet itself (a lockup occurs)
    * Tasklet is strictly serialized wrt itself, but not
      wrt another tasklets. If client needs some intertask synchronization,
      he makes it with spinlocks.
@@ -527,27 +528,36 @@ struct tasklet_struct name =3D { NULL, 0, ATOMIC_INIT=
(1), func, data }
 enum
 {
 	TASKLET_STATE_SCHED,	/* Tasklet is scheduled for execution */
-	TASKLET_STATE_RUN	/* Tasklet is running (SMP only) */
+	TASKLET_STATE_RUN,	/* Tasklet is running (SMP only) */
+	TASKLET_STATE_PENDING	/* Tasklet is pending */
 };
=20
-#ifdef CONFIG_SMP
+#define TASKLET_STATEF_SCHED	(1 << TASKLET_STATE_SCHED)
+#define TASKLET_STATEF_RUN	(1 << TASKLET_STATE_RUN)
+#define TASKLET_STATEF_PENDING	(1 << TASKLET_STATE_PENDING)
+
+#if defined(CONFIG_SMP) || defined(CONFIG_PREEMPT_RT_FULL)
 static inline int tasklet_trylock(struct tasklet_struct *t)
 {
 	return !test_and_set_bit(TASKLET_STATE_RUN, &(t)->state);
 }
=20
+static inline int tasklet_tryunlock(struct tasklet_struct *t)
+{
+	return cmpxchg(&t->state, TASKLET_STATEF_RUN, 0) =3D=3D TASKLET_STATEF_RU=
N;
+}
+
 static inline void tasklet_unlock(struct tasklet_struct *t)
 {
 	smp_mb__before_clear_bit();=20
 	clear_bit(TASKLET_STATE_RUN, &(t)->state);
 }
=20
-static inline void tasklet_unlock_wait(struct tasklet_struct *t)
-{
-	while (test_bit(TASKLET_STATE_RUN, &(t)->state)) { barrier(); }
-}
+extern void tasklet_unlock_wait(struct tasklet_struct *t);
+
 #else
 #define tasklet_trylock(t) 1
+#define tasklet_tryunlock(t)	1
 #define tasklet_unlock_wait(t) do { } while (0)
 #define tasklet_unlock(t) do { } while (0)
 #endif
@@ -596,17 +606,8 @@ static inline void tasklet_disable(struct tasklet_stru=
ct *t)
 	smp_mb();
 }
=20
-static inline void tasklet_enable(struct tasklet_struct *t)
-{
-	smp_mb__before_atomic_dec();
-	atomic_dec(&t->count);
-}
-
-static inline void tasklet_hi_enable(struct tasklet_struct *t)
-{
-	smp_mb__before_atomic_dec();
-	atomic_dec(&t->count);
-}
+extern  void tasklet_enable(struct tasklet_struct *t);
+extern  void tasklet_hi_enable(struct tasklet_struct *t);
=20
 extern void tasklet_kill(struct tasklet_struct *t);
 extern void tasklet_kill_immediate(struct tasklet_struct *t, unsigned int =
cpu);
diff --git a/include/linux/wait.h b/include/linux/wait.h
index 3efc9f3..1e904b8 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -157,7 +157,7 @@ void __wake_up(wait_queue_head_t *q, unsigned int mode,=
 int nr, void *key);
 void __wake_up_locked_key(wait_queue_head_t *q, unsigned int mode, void *k=
ey);
 void __wake_up_sync_key(wait_queue_head_t *q, unsigned int mode, int nr,
 			void *key);
-void __wake_up_locked(wait_queue_head_t *q, unsigned int mode);
+void __wake_up_locked(wait_queue_head_t *q, unsigned int mode, int nr);
 void __wake_up_sync(wait_queue_head_t *q, unsigned int mode, int nr);
 void __wake_up_bit(wait_queue_head_t *, void *, int);
 int __wait_on_bit(wait_queue_head_t *, struct wait_bit_queue *, int (*)(vo=
id *), unsigned);
@@ -170,7 +170,8 @@ wait_queue_head_t *bit_waitqueue(void *, int);
 #define wake_up(x)			__wake_up(x, TASK_NORMAL, 1, NULL)
 #define wake_up_nr(x, nr)		__wake_up(x, TASK_NORMAL, nr, NULL)
 #define wake_up_all(x)			__wake_up(x, TASK_NORMAL, 0, NULL)
-#define wake_up_locked(x)		__wake_up_locked((x), TASK_NORMAL)
+#define wake_up_locked(x)		__wake_up_locked((x), TASK_NORMAL, 1)
+#define wake_up_all_locked(x)		__wake_up_locked((x), TASK_NORMAL, 0)
=20
 #define wake_up_interruptible(x)	__wake_up(x, TASK_INTERRUPTIBLE, 1, NULL)
 #define wake_up_interruptible_nr(x, nr)	__wake_up(x, TASK_INTERRUPTIBLE, n=
r, NULL)
diff --git a/kernel/irq/spurious.c b/kernel/irq/spurious.c
index bfe1004..d09e0f5 100644
--- a/kernel/irq/spurious.c
+++ b/kernel/irq/spurious.c
@@ -84,7 +84,9 @@ static int try_one_irq(int irq, struct irq_desc *desc, bo=
ol force)
 	 */
 	action =3D desc->action;
 	if (!action || !(action->flags & IRQF_SHARED) ||
-	    (action->flags & __IRQF_TIMER) || !action->next)
+	    (action->flags & __IRQF_TIMER) ||
+	    (action->handler(irq, action->dev_id) =3D=3D IRQ_HANDLED) ||
+	    !action->next)
 		goto out;
=20
 	/* Already running on another processor */
diff --git a/kernel/sched.c b/kernel/sched.c
index 640f740..63aeba0 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4642,9 +4642,9 @@ EXPORT_SYMBOL(__wake_up);
 /*
  * Same as __wake_up but called with the spinlock in wait_queue_head_t hel=
d.
  */
-void __wake_up_locked(wait_queue_head_t *q, unsigned int mode)
+void __wake_up_locked(wait_queue_head_t *q, unsigned int mode, int nr)
 {
-	__wake_up_common(q, mode, 1, 0, NULL);
+	__wake_up_common(q, mode, nr, 0, NULL);
 }
 EXPORT_SYMBOL_GPL(__wake_up_locked);
=20
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 026a283..3489d06 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -21,6 +21,7 @@
 #include <linux/freezer.h>
 #include <linux/kthread.h>
 #include <linux/rcupdate.h>
+#include <linux/delay.h>
 #include <linux/ftrace.h>
 #include <linux/smp.h>
 #include <linux/tick.h>
@@ -670,15 +671,45 @@ struct tasklet_head
 static DEFINE_PER_CPU(struct tasklet_head, tasklet_vec);
 static DEFINE_PER_CPU(struct tasklet_head, tasklet_hi_vec);
=20
+static void inline
+__tasklet_common_schedule(struct tasklet_struct *t, struct tasklet_head *h=
ead, unsigned int nr)
+{
+	if (tasklet_trylock(t)) {
+again:
+		/* We may have been preempted before tasklet_trylock
+		 * and __tasklet_action may have already run.
+		 * So double check the sched bit while the takslet
+		 * is locked before adding it to the list.
+		 */
+		if (test_bit(TASKLET_STATE_SCHED, &t->state)) {
+			t->next =3D NULL;
+			*head->tail =3D t;
+			head->tail =3D &(t->next);
+			raise_softirq_irqoff(nr);
+			tasklet_unlock(t);
+		} else {
+			/* This is subtle. If we hit the corner case above
+			 * It is possible that we get preempted right here,
+			 * and another task has successfully called
+			 * tasklet_schedule(), then this function, and
+			 * failed on the trylock. Thus we must be sure
+			 * before releasing the tasklet lock, that the
+			 * SCHED_BIT is clear. Otherwise the tasklet
+			 * may get its SCHED_BIT set, but not added to the
+			 * list
+			 */
+			if (!tasklet_tryunlock(t))
+				goto again;
+		}
+	}
+}
+
 void __tasklet_schedule(struct tasklet_struct *t)
 {
 	unsigned long flags;
=20
 	local_irq_save(flags);
-	t->next =3D NULL;
-	*__this_cpu_read(tasklet_vec.tail) =3D t;
-	__this_cpu_write(tasklet_vec.tail, &(t->next));
-	raise_softirq_irqoff(TASKLET_SOFTIRQ);
+	__tasklet_common_schedule(t, &__get_cpu_var(tasklet_vec), TASKLET_SOFTIRQ=
);
 	local_irq_restore(flags);
 }
=20
@@ -689,10 +720,7 @@ void __tasklet_hi_schedule(struct tasklet_struct *t)
 	unsigned long flags;
=20
 	local_irq_save(flags);
-	t->next =3D NULL;
-	*__this_cpu_read(tasklet_hi_vec.tail) =3D t;
-	__this_cpu_write(tasklet_hi_vec.tail,  &(t->next));
-	raise_softirq_irqoff(HI_SOFTIRQ);
+	__tasklet_common_schedule(t, &__get_cpu_var(tasklet_hi_vec), HI_SOFTIRQ);
 	local_irq_restore(flags);
 }
=20
@@ -700,50 +728,119 @@ EXPORT_SYMBOL(__tasklet_hi_schedule);
=20
 void __tasklet_hi_schedule_first(struct tasklet_struct *t)
 {
-	BUG_ON(!irqs_disabled());
-
-	t->next =3D __this_cpu_read(tasklet_hi_vec.head);
-	__this_cpu_write(tasklet_hi_vec.head, t);
-	__raise_softirq_irqoff(HI_SOFTIRQ);
+	__tasklet_hi_schedule(t);
 }
=20
 EXPORT_SYMBOL(__tasklet_hi_schedule_first);
+=20
+void  tasklet_enable(struct tasklet_struct *t)
+{
+	if (!atomic_dec_and_test(&t->count))
+		return;
+	if (test_and_clear_bit(TASKLET_STATE_PENDING, &t->state))
+		tasklet_schedule(t);
+}
+=20
+EXPORT_SYMBOL(tasklet_enable);
=20
-static void tasklet_action(struct softirq_action *a)
+void  tasklet_hi_enable(struct tasklet_struct *t)
 {
-	struct tasklet_struct *list;
+	if (!atomic_dec_and_test(&t->count))
+		return;
+	if (test_and_clear_bit(TASKLET_STATE_PENDING, &t->state))
+		tasklet_hi_schedule(t);
+}
=20
-	local_irq_disable();
-	list =3D __this_cpu_read(tasklet_vec.head);
-	__this_cpu_write(tasklet_vec.head, NULL);
-	__this_cpu_write(tasklet_vec.tail, &__get_cpu_var(tasklet_vec).head);
-	local_irq_enable();
+EXPORT_SYMBOL(tasklet_hi_enable);
+
+static void
+__tasklet_action(struct softirq_action *a, struct tasklet_struct *list)
+{
+	int loops =3D 1000000;
=20
 	while (list) {
 		struct tasklet_struct *t =3D list;
=20
 		list =3D list->next;
=20
-		if (tasklet_trylock(t)) {
-			if (!atomic_read(&t->count)) {
-				if (!test_and_clear_bit(TASKLET_STATE_SCHED, &t->state))
-					BUG();
-				t->func(t->data);
-				tasklet_unlock(t);
-				continue;
-			}
-			tasklet_unlock(t);
+		/*
+		 * Should always succeed - after a tasklist got on the
+		 * list (after getting the SCHED bit set from 0 to 1),
+		 * nothing but the tasklet softirq it got queued to can
+		 * lock it:
+		 */
+		if (!tasklet_trylock(t)) {
+			WARN_ON(1);
+			continue;
 		}
=20
-		local_irq_disable();
 		t->next =3D NULL;
-		*__this_cpu_read(tasklet_vec.tail) =3D t;
-		__this_cpu_write(tasklet_vec.tail, &(t->next));
-		__raise_softirq_irqoff(TASKLET_SOFTIRQ);
-		local_irq_enable();
+
+		/*
+		 * If we cannot handle the tasklet because it's disabled,
+		 * mark it as pending. tasklet_enable() will later
+		 * re-schedule the tasklet.
+		 */
+		if (unlikely(atomic_read(&t->count))) {
+out_disabled:
+			/* implicit unlock: */
+			wmb();
+			t->state =3D TASKLET_STATEF_PENDING;
+			continue;
+		}
+
+		/*
+		 * After this point on the tasklet might be rescheduled
+		 * on another CPU, but it can only be added to another
+		 * CPU's tasklet list if we unlock the tasklet (which we
+		 * dont do yet).
+		 */
+		if (!test_and_clear_bit(TASKLET_STATE_SCHED, &t->state))
+			WARN_ON(1);
+
+again:
+		t->func(t->data);
+
+		/*
+		 * Try to unlock the tasklet. We must use cmpxchg, because
+		 * another CPU might have scheduled or disabled the tasklet.
+		 * We only allow the STATE_RUN -> 0 transition here.
+		 */
+		while (!tasklet_tryunlock(t)) {
+			/*
+			 * If it got disabled meanwhile, bail out:
+			 */
+			if (atomic_read(&t->count))
+				goto out_disabled;
+			/*
+			 * If it got scheduled meanwhile, re-execute
+			 * the tasklet function:
+			 */
+			if (test_and_clear_bit(TASKLET_STATE_SCHED, &t->state))
+				goto again;
+			if (!--loops) {
+				printk("hm, tasklet state: %08lx\n", t->state);
+				WARN_ON(1);
+				tasklet_unlock(t);
+				break;
+			}
+		}
 	}
 }
=20
+static void tasklet_action(struct softirq_action *a)
+{
+	struct tasklet_struct *list;
+
+	local_irq_disable();
+	list =3D __get_cpu_var(tasklet_vec).head;
+	__get_cpu_var(tasklet_vec).head =3D NULL;
+	__get_cpu_var(tasklet_vec).tail =3D &__get_cpu_var(tasklet_vec).head;
+	local_irq_enable();
+
+	__tasklet_action(a, list);
+}
+
 static void tasklet_hi_action(struct softirq_action *a)
 {
 	struct tasklet_struct *list;
@@ -754,29 +851,7 @@ static void tasklet_hi_action(struct softirq_action *a=
)
 	__this_cpu_write(tasklet_hi_vec.tail, &__get_cpu_var(tasklet_hi_vec).head=
);
 	local_irq_enable();
=20
-	while (list) {
-		struct tasklet_struct *t =3D list;
-
-		list =3D list->next;
-
-		if (tasklet_trylock(t)) {
-			if (!atomic_read(&t->count)) {
-				if (!test_and_clear_bit(TASKLET_STATE_SCHED, &t->state))
-					BUG();
-				t->func(t->data);
-				tasklet_unlock(t);
-				continue;
-			}
-			tasklet_unlock(t);
-		}
-
-		local_irq_disable();
-		t->next =3D NULL;
-		*__this_cpu_read(tasklet_hi_vec.tail) =3D t;
-		__this_cpu_write(tasklet_hi_vec.tail, &(t->next));
-		__raise_softirq_irqoff(HI_SOFTIRQ);
-		local_irq_enable();
-	}
+	__tasklet_action(a, list);
 }
=20
=20
@@ -799,7 +874,7 @@ void tasklet_kill(struct tasklet_struct *t)
=20
 	while (test_and_set_bit(TASKLET_STATE_SCHED, &t->state)) {
 		do {
-			yield();
+			msleep(1);
 		} while (test_bit(TASKLET_STATE_SCHED, &t->state));
 	}
 	tasklet_unlock_wait(t);
@@ -1005,6 +1080,23 @@ void __init softirq_init(void)
 	open_softirq(HI_SOFTIRQ, tasklet_hi_action);
 }
=20
+#if defined(CONFIG_SMP) || defined(CONFIG_PREEMPT_RT_FULL)
+void tasklet_unlock_wait(struct tasklet_struct *t)
+{
+	while (test_bit(TASKLET_STATE_RUN, &(t)->state)) {
+		/*
+		 * Hack for now to avoid this busy-loop:
+		 */
+#ifdef CONFIG_PREEMPT_RT_FULL
+		msleep(1);
+#else
+		barrier();
+#endif
+	}
+}
+EXPORT_SYMBOL(tasklet_unlock_wait);
+#endif
+
 static int run_ksoftirqd(void * __bind_cpu)
 {
 	ksoftirqd_set_sched_params();
diff --git a/localversion-rt b/localversion-rt
index 90290c6..b72862e 100644
--- a/localversion-rt
+++ b/localversion-rt
@@ -1 +1 @@
--rt29
+-rt30
diff --git a/mm/slab.c b/mm/slab.c
index 015cd76..5251b99 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -594,6 +594,7 @@ static enum {
 	PARTIAL_AC,
 	PARTIAL_L3,
 	EARLY,
+	LATE,
 	FULL
 } g_cpucache_up;
=20
@@ -605,6 +606,12 @@ int slab_is_available(void)
 	return g_cpucache_up >=3D EARLY;
 }
=20
+/*
+ * Guard access to the cache-chain.
+ */
+static DEFINE_MUTEX(cache_chain_mutex);
+static struct list_head cache_chain;
+
 #ifdef CONFIG_LOCKDEP
=20
 /*
@@ -666,38 +673,41 @@ static void slab_set_debugobj_lock_classes(struct kme=
m_cache *cachep)
 		slab_set_debugobj_lock_classes_node(cachep, node);
 }
=20
-static void init_node_lock_keys(int q)
+static void init_lock_keys(struct kmem_cache *cachep, int node)
 {
-	struct cache_sizes *s =3D malloc_sizes;
+	struct kmem_list3 *l3;
=20
-	if (g_cpucache_up !=3D FULL)
+	if (g_cpucache_up < LATE)
 		return;
=20
-	for (s =3D malloc_sizes; s->cs_size !=3D ULONG_MAX; s++) {
-		struct kmem_list3 *l3;
+	l3 =3D cachep->nodelists[node];
+	if (!l3 || OFF_SLAB(cachep))
+		return;
=20
-		l3 =3D s->cs_cachep->nodelists[q];
-		if (!l3 || OFF_SLAB(s->cs_cachep))
-			continue;
+	slab_set_lock_classes(cachep, &on_slab_l3_key, &on_slab_alc_key, node);
+}
=20
-		slab_set_lock_classes(s->cs_cachep, &on_slab_l3_key,
-				&on_slab_alc_key, q);
-	}
+static void init_node_lock_keys(int node)
+{
+	struct kmem_cache *cachep;
+
+	list_for_each_entry(cachep, &cache_chain, next)
+		init_lock_keys(cachep, node);
 }
=20
-static inline void init_lock_keys(void)
+static inline void init_cachep_lock_keys(struct kmem_cache *cachep)
 {
 	int node;
=20
 	for_each_node(node)
-		init_node_lock_keys(node);
+		init_lock_keys(cachep, node);
 }
 #else
-static void init_node_lock_keys(int q)
+static void init_node_lock_keys(int node)
 {
 }
=20
-static inline void init_lock_keys(void)
+static void init_cachep_lock_keys(struct kmem_cache *cachep)
 {
 }
=20
@@ -710,12 +720,6 @@ static void slab_set_debugobj_lock_classes(struct kmem=
_cache *cachep)
 }
 #endif
=20
-/*
- * Guard access to the cache-chain.
- */
-static DEFINE_MUTEX(cache_chain_mutex);
-static struct list_head cache_chain;
-
 static DEFINE_PER_CPU(struct delayed_work, slab_reap_work);
 static DEFINE_PER_CPU(struct list_head, slab_free_list);
 static DEFINE_LOCAL_IRQ_LOCK(slab_lock);
@@ -1725,14 +1729,15 @@ void __init kmem_cache_init_late(void)
 {
 	struct kmem_cache *cachep;
=20
-	/* Annotate slab for lockdep -- annotate the malloc caches */
-	init_lock_keys();
+	g_cpucache_up =3D LATE;
=20
 	/* 6) resize the head arrays to their final sizes */
 	mutex_lock(&cache_chain_mutex);
-	list_for_each_entry(cachep, &cache_chain, next)
+	list_for_each_entry(cachep, &cache_chain, next) {
+		init_cachep_lock_keys(cachep);
 		if (enable_cpucache(cachep, GFP_NOWAIT))
 			BUG();
+	}
 	mutex_unlock(&cache_chain_mutex);
=20
 	/* Done! */
@@ -2543,6 +2548,8 @@ kmem_cache_create (const char *name, size_t size, siz=
e_t align,
 		slab_set_debugobj_lock_classes(cachep);
 	}
=20
+	init_cachep_lock_keys(cachep);
+
 	/* cache setup completed, link it into the list */
 	list_add(&cachep->next, &cache_chain);
 oops:


--=-93wtmk+M2Y1yd3egnV3f
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJO3/yGAAoJEIy3vGnGbaoAz+UQAIiaVuDJtA8ZC/q3O37iABk4
o/nPWXTHs5TIuI+KCCq3EMTboXa6nx+J88U0LYbQRL7nSj1F1CBLwAF55uY8AHTF
EXnx9zFx3AJk9AF41cDe8kOdOKdrMDtWvvmmmR3QleDYMBiBxhpTOSnRQOBLKU90
mBiGIiOrzjfSW7hSkbpJWkUa0SO0OAyRumxX85331yhV3eNkyqgyL0s2TAom221a
cD4lPipv0lhDg/etry2/OVnUVINFo6Y2YEQm9TZJ53g0AAhAb72uVkWWZr4cP5sz
OWVZJxzk57kwPd6vCL0GZjb+PqOOR9N0fL6i5qo2VbbC6RGb5DjF9c7gU0BZIOQ5
Tr8aEdsUX+1odqNx71WCo42bZCrP4Ii5iGVh9ktAUh9r+2QcZDfqbx8fBzCBq+Hm
0PsstlqRzDR0cZ7imtZEA9J7gtycopdePUiNn7LyFY8ysgznOM41hqd/ovHsRdCL
l+t6L/MqJrQ6jaYQ7g0vu6cV8YN7sQ5VuwdlF7XvW3wYrdpEvDd28bzPB6nncCrP
qT8ZbjL+7xUYeO07yEvsIyQL5d0K2IH0n+idBgu97KRpYx3DvtzMgfQH6QJAAD6T
kCOW4WUQ82ekO9CGKHcRjmgMgEncNNlphUGSneOy+IYnoPhAKJ96ra4XZXC1/HSB
nmSpq4aeqtQdoeehmeIa
=xow2
-----END PGP SIGNATURE-----

--=-93wtmk+M2Y1yd3egnV3f--

