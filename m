Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755843Ab2GATLd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 15:11:33 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47620 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751176Ab2GATLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 15:11:31 -0400
Message-ID: <1341169877.4852.121.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 00/48] 3.2.22-stable review
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Date: Sun, 01 Jul 2012 20:11:17 +0100
In-Reply-To: <20120701172006.535271340@decadent.org.uk>
References: <20120701172006.535271340@decadent.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-uTdvX9R+Wvc0pNFv5i26"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-uTdvX9R+Wvc0pNFv5i26
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

diff --git a/Documentation/stable_kernel_rules.txt b/Documentation/stable_k=
ernel_rules.txt
index 21fd05c..e1f856b 100644
--- a/Documentation/stable_kernel_rules.txt
+++ b/Documentation/stable_kernel_rules.txt
@@ -12,6 +12,12 @@ Rules on what kind of patches are accepted, and which on=
es are not, into the
    marked CONFIG_BROKEN), an oops, a hang, data corruption, a real
    security issue, or some "oh, that's not good" issue.  In short, somethi=
ng
    critical.
+ - Serious issues as reported by a user of a distribution kernel may also
+   be considered if they fix a notable performance or interactivity issue.
+   As these fixes are not as obvious and have a higher risk of a subtle
+   regression they should only be submitted by a distribution kernel
+   maintainer and include an addendum linking to a bugzilla entry if it
+   exists and additional information on the user-visible impact.
  - New device IDs and quirks are also accepted.
  - No "theoretical race condition" issues, unless an explanation of how th=
e
    race can be exploited is also provided.
diff --git a/Makefile b/Makefile
index 7eb465e..fec37c5 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION =3D 3
 PATCHLEVEL =3D 2
-SUBLEVEL =3D 21
-EXTRAVERSION =3D
+SUBLEVEL =3D 22
+EXTRAVERSION =3D -rc1
 NAME =3D Saber-toothed Squirrel
=20
 # *DOCUMENTATION*
diff --git a/arch/arm/plat-samsung/include/plat/map-s3c.h b/arch/arm/plat-s=
amsung/include/plat/map-s3c.h
index 7d04875..c0c70a8 100644
--- a/arch/arm/plat-samsung/include/plat/map-s3c.h
+++ b/arch/arm/plat-samsung/include/plat/map-s3c.h
@@ -22,7 +22,7 @@
 #define S3C24XX_VA_WATCHDOG	S3C_VA_WATCHDOG
=20
 #define S3C2412_VA_SSMC		S3C_ADDR_CPU(0x00000000)
-#define S3C2412_VA_EBI		S3C_ADDR_CPU(0x00010000)
+#define S3C2412_VA_EBI		S3C_ADDR_CPU(0x00100000)
=20
 #define S3C2410_PA_UART		(0x50000000)
 #define S3C24XX_PA_UART		S3C2410_PA_UART
diff --git a/arch/arm/plat-samsung/include/plat/watchdog-reset.h b/arch/arm=
/plat-samsung/include/plat/watchdog-reset.h
index 40dbb2b..11b19ea 100644
--- a/arch/arm/plat-samsung/include/plat/watchdog-reset.h
+++ b/arch/arm/plat-samsung/include/plat/watchdog-reset.h
@@ -24,7 +24,7 @@ static inline void arch_wdt_reset(void)
=20
 	__raw_writel(0, S3C2410_WTCON);	  /* disable watchdog, to be safe  */
=20
-	if (s3c2410_wdtclk)
+	if (!IS_ERR(s3c2410_wdtclk))
 		clk_enable(s3c2410_wdtclk);
=20
 	/* put initial values into count and data */
diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufe=
ature.h
index f3444f7..0c3b775 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -175,7 +175,7 @@
 #define X86_FEATURE_XSAVEOPT	(7*32+ 4) /* Optimized Xsave */
 #define X86_FEATURE_PLN		(7*32+ 5) /* Intel Power Limit Notification */
 #define X86_FEATURE_PTS		(7*32+ 6) /* Intel Package Thermal Status */
-#define X86_FEATURE_DTS		(7*32+ 7) /* Digital Thermal Sensor */
+#define X86_FEATURE_DTHERM	(7*32+ 7) /* Digital Thermal Sensor */
=20
 /* Virtualization flags: Linux defined, word 8 */
 #define X86_FEATURE_TPR_SHADOW  (8*32+ 0) /* Intel TPR Shadow */
diff --git a/arch/x86/include/asm/pgtable-3level.h b/arch/x86/include/asm/p=
gtable-3level.h
index effff47..cb00ccc 100644
--- a/arch/x86/include/asm/pgtable-3level.h
+++ b/arch/x86/include/asm/pgtable-3level.h
@@ -31,6 +31,60 @@ static inline void native_set_pte(pte_t *ptep, pte_t pte=
)
 	ptep->pte_low =3D pte.pte_low;
 }
=20
+#define pmd_read_atomic pmd_read_atomic
+/*
+ * pte_offset_map_lock on 32bit PAE kernels was reading the pmd_t with
+ * a "*pmdp" dereference done by gcc. Problem is, in certain places
+ * where pte_offset_map_lock is called, concurrent page faults are
+ * allowed, if the mmap_sem is hold for reading. An example is mincore
+ * vs page faults vs MADV_DONTNEED. On the page fault side
+ * pmd_populate rightfully does a set_64bit, but if we're reading the
+ * pmd_t with a "*pmdp" on the mincore side, a SMP race can happen
+ * because gcc will not read the 64bit of the pmd atomically. To fix
+ * this all places running pmd_offset_map_lock() while holding the
+ * mmap_sem in read mode, shall read the pmdp pointer using this
+ * function to know if the pmd is null nor not, and in turn to know if
+ * they can run pmd_offset_map_lock or pmd_trans_huge or other pmd
+ * operations.
+ *
+ * Without THP if the mmap_sem is hold for reading, the pmd can only
+ * transition from null to not null while pmd_read_atomic runs. So
+ * we can always return atomic pmd values with this function.
+ *
+ * With THP if the mmap_sem is hold for reading, the pmd can become
+ * trans_huge or none or point to a pte (and in turn become "stable")
+ * at any time under pmd_read_atomic. We could read it really
+ * atomically here with a atomic64_read for the THP enabled case (and
+ * it would be a whole lot simpler), but to avoid using cmpxchg8b we
+ * only return an atomic pmdval if the low part of the pmdval is later
+ * found stable (i.e. pointing to a pte). And we're returning a none
+ * pmdval if the low part of the pmd is none. In some cases the high
+ * and low part of the pmdval returned may not be consistent if THP is
+ * enabled (the low part may point to previously mapped hugepage,
+ * while the high part may point to a more recently mapped hugepage),
+ * but pmd_none_or_trans_huge_or_clear_bad() only needs the low part
+ * of the pmd to be read atomically to decide if the pmd is unstable
+ * or not, with the only exception of when the low part of the pmd is
+ * zero in which case we return a none pmd.
+ */
+static inline pmd_t pmd_read_atomic(pmd_t *pmdp)
+{
+	pmdval_t ret;
+	u32 *tmp =3D (u32 *)pmdp;
+
+	ret =3D (pmdval_t) (*tmp);
+	if (ret) {
+		/*
+		 * If the low part is null, we must not read the high part
+		 * or we can end up with a partial pmd.
+		 */
+		smp_rmb();
+		ret |=3D ((pmdval_t)*(tmp + 1)) << 32;
+	}
+
+	return (pmd_t) { ret };
+}
+
 static inline void native_set_pte_atomic(pte_t *ptep, pte_t pte)
 {
 	set_64bit((unsigned long long *)(ptep), native_pte_val(pte));
diff --git a/arch/x86/kernel/cpu/scattered.c b/arch/x86/kernel/cpu/scattere=
d.c
index c7f64e6..ea6106c 100644
--- a/arch/x86/kernel/cpu/scattered.c
+++ b/arch/x86/kernel/cpu/scattered.c
@@ -31,7 +31,7 @@ void __cpuinit init_scattered_cpuid_features(struct cpuin=
fo_x86 *c)
 	const struct cpuid_bit *cb;
=20
 	static const struct cpuid_bit __cpuinitconst cpuid_bits[] =3D {
-		{ X86_FEATURE_DTS,		CR_EAX, 0, 0x00000006, 0 },
+		{ X86_FEATURE_DTHERM,		CR_EAX, 0, 0x00000006, 0 },
 		{ X86_FEATURE_IDA,		CR_EAX, 1, 0x00000006, 0 },
 		{ X86_FEATURE_ARAT,		CR_EAX, 2, 0x00000006, 0 },
 		{ X86_FEATURE_PLN,		CR_EAX, 4, 0x00000006, 0 },
diff --git a/drivers/acpi/acpi_pad.c b/drivers/acpi/acpi_pad.c
index a43fa1a..1502c502 100644
--- a/drivers/acpi/acpi_pad.c
+++ b/drivers/acpi/acpi_pad.c
@@ -36,6 +36,7 @@
 #define ACPI_PROCESSOR_AGGREGATOR_DEVICE_NAME "Processor Aggregator"
 #define ACPI_PROCESSOR_AGGREGATOR_NOTIFY 0x80
 static DEFINE_MUTEX(isolated_cpus_lock);
+static DEFINE_MUTEX(round_robin_lock);
=20
 static unsigned long power_saving_mwait_eax;
=20
@@ -107,7 +108,7 @@ static void round_robin_cpu(unsigned int tsk_index)
 	if (!alloc_cpumask_var(&tmp, GFP_KERNEL))
 		return;
=20
-	mutex_lock(&isolated_cpus_lock);
+	mutex_lock(&round_robin_lock);
 	cpumask_clear(tmp);
 	for_each_cpu(cpu, pad_busy_cpus)
 		cpumask_or(tmp, tmp, topology_thread_cpumask(cpu));
@@ -116,7 +117,7 @@ static void round_robin_cpu(unsigned int tsk_index)
 	if (cpumask_empty(tmp))
 		cpumask_andnot(tmp, cpu_online_mask, pad_busy_cpus);
 	if (cpumask_empty(tmp)) {
-		mutex_unlock(&isolated_cpus_lock);
+		mutex_unlock(&round_robin_lock);
 		return;
 	}
 	for_each_cpu(cpu, tmp) {
@@ -131,7 +132,7 @@ static void round_robin_cpu(unsigned int tsk_index)
 	tsk_in_cpu[tsk_index] =3D preferred_cpu;
 	cpumask_set_cpu(preferred_cpu, pad_busy_cpus);
 	cpu_weight[preferred_cpu]++;
-	mutex_unlock(&isolated_cpus_lock);
+	mutex_unlock(&round_robin_lock);
=20
 	set_cpus_allowed_ptr(current, cpumask_of(preferred_cpu));
 }
diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index c3d2dfc..b96544a 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -869,7 +869,7 @@ static int __device_suspend(struct device *dev, pm_mess=
age_t state, bool async)
 	dpm_wait_for_children(dev, async);
=20
 	if (async_error)
-		return 0;
+		goto Complete;
=20
 	pm_runtime_get_noresume(dev);
 	if (pm_runtime_barrier(dev) && device_may_wakeup(dev))
@@ -878,7 +878,7 @@ static int __device_suspend(struct device *dev, pm_mess=
age_t state, bool async)
 	if (pm_wakeup_pending()) {
 		pm_runtime_put_sync(dev);
 		async_error =3D -EBUSY;
-		return 0;
+		goto Complete;
 	}
=20
 	device_lock(dev);
@@ -926,6 +926,8 @@ static int __device_suspend(struct device *dev, pm_mess=
age_t state, bool async)
 	}
=20
 	device_unlock(dev);
+
+ Complete:
 	complete_all(&dev->power.completion);
=20
 	if (error) {
diff --git a/drivers/char/hw_random/atmel-rng.c b/drivers/char/hw_random/at=
mel-rng.c
index 0477982..1b5675b 100644
--- a/drivers/char/hw_random/atmel-rng.c
+++ b/drivers/char/hw_random/atmel-rng.c
@@ -34,7 +34,7 @@ static int atmel_trng_read(struct hwrng *rng, void *buf, =
size_t max,
 	u32 *data =3D buf;
=20
 	/* data ready? */
-	if (readl(trng->base + TRNG_ODATA) & 1) {
+	if (readl(trng->base + TRNG_ISR) & 1) {
 		*data =3D readl(trng->base + TRNG_ODATA);
 		/*
 		  ensure data ready is only set again AFTER the next data
diff --git a/drivers/edac/i7core_edac.c b/drivers/edac/i7core_edac.c
index 70ad892..b3ccefa 100644
--- a/drivers/edac/i7core_edac.c
+++ b/drivers/edac/i7core_edac.c
@@ -1932,12 +1932,6 @@ static int i7core_mce_check_error(struct notifier_bl=
ock *nb, unsigned long val,
 	if (mce->bank !=3D 8)
 		return NOTIFY_DONE;
=20
-#ifdef CONFIG_SMP
-	/* Only handle if it is the right mc controller */
-	if (mce->socketid !=3D pvt->i7core_dev->socket)
-		return NOTIFY_DONE;
-#endif
-
 	smp_rmb();
 	if ((pvt->mce_out + 1) % MCE_LOG_LEN =3D=3D pvt->mce_in) {
 		smp_wmb();
@@ -2234,8 +2228,6 @@ static void i7core_unregister_mci(struct i7core_dev *=
i7core_dev)
 	if (pvt->enable_scrub)
 		disable_sdram_scrub_setting(mci);
=20
-	atomic_notifier_chain_unregister(&x86_mce_decoder_chain, &i7_mce_dec);
-
 	/* Disable EDAC polling */
 	i7core_pci_ctl_release(pvt);
=20
@@ -2336,8 +2328,6 @@ static int i7core_register_mci(struct i7core_dev *i7c=
ore_dev)
 	/* DCLK for scrub rate setting */
 	pvt->dclk_freq =3D get_dclk_freq();
=20
-	atomic_notifier_chain_register(&x86_mce_decoder_chain, &i7_mce_dec);
-
 	return 0;
=20
 fail0:
@@ -2481,8 +2471,10 @@ static int __init i7core_init(void)
=20
 	pci_rc =3D pci_register_driver(&i7core_driver);
=20
-	if (pci_rc >=3D 0)
+	if (pci_rc >=3D 0) {
+		atomic_notifier_chain_register(&x86_mce_decoder_chain, &i7_mce_dec);
 		return 0;
+	}
=20
 	i7core_printk(KERN_ERR, "Failed to register device with error %d.\n",
 		      pci_rc);
@@ -2498,6 +2490,7 @@ static void __exit i7core_exit(void)
 {
 	debugf2("MC: " __FILE__ ": %s()\n", __func__);
 	pci_unregister_driver(&i7core_driver);
+	atomic_notifier_chain_unregister(&x86_mce_decoder_chain, &i7_mce_dec);
 }
=20
 module_init(i7core_init);
diff --git a/drivers/edac/sb_edac.c b/drivers/edac/sb_edac.c
index 7a402bf..18a1293 100644
--- a/drivers/edac/sb_edac.c
+++ b/drivers/edac/sb_edac.c
@@ -1661,9 +1661,6 @@ static void sbridge_unregister_mci(struct sbridge_dev=
 *sbridge_dev)
 	debugf0("MC: " __FILE__ ": %s(): mci =3D %p, dev =3D %p\n",
 		__func__, mci, &sbridge_dev->pdev[0]->dev);
=20
-	atomic_notifier_chain_unregister(&x86_mce_decoder_chain,
-					 &sbridge_mce_dec);
-
 	/* Remove MC sysfs nodes */
 	edac_mc_del_mc(mci->dev);
=20
@@ -1731,8 +1728,6 @@ static int sbridge_register_mci(struct sbridge_dev *s=
bridge_dev)
 		goto fail0;
 	}
=20
-	atomic_notifier_chain_register(&x86_mce_decoder_chain,
-				       &sbridge_mce_dec);
 	return 0;
=20
 fail0:
@@ -1861,8 +1856,10 @@ static int __init sbridge_init(void)
=20
 	pci_rc =3D pci_register_driver(&sbridge_driver);
=20
-	if (pci_rc >=3D 0)
+	if (pci_rc >=3D 0) {
+		atomic_notifier_chain_register(&x86_mce_decoder_chain, &sbridge_mce_dec)=
;
 		return 0;
+	}
=20
 	sbridge_printk(KERN_ERR, "Failed to register device with error %d.\n",
 		      pci_rc);
@@ -1878,6 +1875,7 @@ static void __exit sbridge_exit(void)
 {
 	debugf2("MC: " __FILE__ ": %s()\n", __func__);
 	pci_unregister_driver(&sbridge_driver);
+	atomic_notifier_chain_unregister(&x86_mce_decoder_chain, &sbridge_mce_dec=
);
 }
=20
 module_init(sbridge_init);
diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
index 3e927ce..a1ee634 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -585,7 +585,7 @@ static bool
 drm_monitor_supports_rb(struct edid *edid)
 {
 	if (edid->revision >=3D 4) {
-		bool ret;
+		bool ret =3D false;
 		drm_for_each_detailed_block((u8 *)edid, is_rb, &ret);
 		return ret;
 	}
diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_ge=
m.c
index 3e7c478..3e2edc6 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -3312,6 +3312,10 @@ i915_gem_ring_throttle(struct drm_device *dev, struc=
t drm_file *file)
=20
 			if (ret =3D=3D 0 && atomic_read(&dev_priv->mm.wedged))
 				ret =3D -EIO;
+		} else if (wait_for(i915_seqno_passed(ring->get_seqno(ring),
+						      seqno) ||
+				    atomic_read(&dev_priv->mm.wedged), 3000)) {
+			ret =3D -EBUSY;
 		}
 	}
=20
diff --git a/drivers/gpu/drm/i915/i915_irq.c b/drivers/gpu/drm/i915/i915_ir=
q.c
index d3820c2..578ddfc 100644
--- a/drivers/gpu/drm/i915/i915_irq.c
+++ b/drivers/gpu/drm/i915/i915_irq.c
@@ -424,6 +424,30 @@ static void gen6_pm_rps_work(struct work_struct *work)
 	mutex_unlock(&dev_priv->dev->struct_mutex);
 }
=20
+static void gen6_queue_rps_work(struct drm_i915_private *dev_priv,
+				u32 pm_iir)
+{
+	unsigned long flags;
+
+	/*
+	 * IIR bits should never already be set because IMR should
+	 * prevent an interrupt from being shown in IIR. The warning
+	 * displays a case where we've unsafely cleared
+	 * dev_priv->pm_iir. Although missing an interrupt of the same
+	 * type is not a problem, it displays a problem in the logic.
+	 *
+	 * The mask bit in IMR is cleared by rps_work.
+	 */
+
+	spin_lock_irqsave(&dev_priv->rps_lock, flags);
+	dev_priv->pm_iir |=3D pm_iir;
+	I915_WRITE(GEN6_PMIMR, dev_priv->pm_iir);
+	POSTING_READ(GEN6_PMIMR);
+	spin_unlock_irqrestore(&dev_priv->rps_lock, flags);
+
+	queue_work(dev_priv->wq, &dev_priv->rps_work);
+}
+
 static void pch_irq_handler(struct drm_device *dev, u32 pch_iir)
 {
 	drm_i915_private_t *dev_priv =3D (drm_i915_private_t *) dev->dev_private;
@@ -529,16 +553,8 @@ static irqreturn_t ivybridge_irq_handler(DRM_IRQ_ARGS)
 		pch_irq_handler(dev, pch_iir);
 	}
=20
-	if (pm_iir & GEN6_PM_DEFERRED_EVENTS) {
-		unsigned long flags;
-		spin_lock_irqsave(&dev_priv->rps_lock, flags);
-		WARN(dev_priv->pm_iir & pm_iir, "Missed a PM interrupt\n");
-		dev_priv->pm_iir |=3D pm_iir;
-		I915_WRITE(GEN6_PMIMR, dev_priv->pm_iir);
-		POSTING_READ(GEN6_PMIMR);
-		spin_unlock_irqrestore(&dev_priv->rps_lock, flags);
-		queue_work(dev_priv->wq, &dev_priv->rps_work);
-	}
+	if (pm_iir & GEN6_PM_DEFERRED_EVENTS)
+		gen6_queue_rps_work(dev_priv, pm_iir);
=20
 	/* should clear PCH hotplug event before clear CPU irq */
 	I915_WRITE(SDEIIR, pch_iir);
@@ -634,25 +650,8 @@ static irqreturn_t ironlake_irq_handler(DRM_IRQ_ARGS)
 		i915_handle_rps_change(dev);
 	}
=20
-	if (IS_GEN6(dev) && pm_iir & GEN6_PM_DEFERRED_EVENTS) {
-		/*
-		 * IIR bits should never already be set because IMR should
-		 * prevent an interrupt from being shown in IIR. The warning
-		 * displays a case where we've unsafely cleared
-		 * dev_priv->pm_iir. Although missing an interrupt of the same
-		 * type is not a problem, it displays a problem in the logic.
-		 *
-		 * The mask bit in IMR is cleared by rps_work.
-		 */
-		unsigned long flags;
-		spin_lock_irqsave(&dev_priv->rps_lock, flags);
-		WARN(dev_priv->pm_iir & pm_iir, "Missed a PM interrupt\n");
-		dev_priv->pm_iir |=3D pm_iir;
-		I915_WRITE(GEN6_PMIMR, dev_priv->pm_iir);
-		POSTING_READ(GEN6_PMIMR);
-		spin_unlock_irqrestore(&dev_priv->rps_lock, flags);
-		queue_work(dev_priv->wq, &dev_priv->rps_work);
-	}
+	if (IS_GEN6(dev) && pm_iir & GEN6_PM_DEFERRED_EVENTS)
+		gen6_queue_rps_work(dev_priv, pm_iir);
=20
 	/* should clear PCH hotplug event before clear CPU irq */
 	I915_WRITE(SDEIIR, pch_iir);
diff --git a/drivers/gpu/drm/i915/i915_suspend.c b/drivers/gpu/drm/i915/i91=
5_suspend.c
index a1eb83d..f38d196 100644
--- a/drivers/gpu/drm/i915/i915_suspend.c
+++ b/drivers/gpu/drm/i915/i915_suspend.c
@@ -739,8 +739,11 @@ static void i915_restore_display(struct drm_device *de=
v)
 	if (HAS_PCH_SPLIT(dev)) {
 		I915_WRITE(BLC_PWM_PCH_CTL1, dev_priv->saveBLC_PWM_CTL);
 		I915_WRITE(BLC_PWM_PCH_CTL2, dev_priv->saveBLC_PWM_CTL2);
-		I915_WRITE(BLC_PWM_CPU_CTL, dev_priv->saveBLC_CPU_PWM_CTL);
+		/* NOTE: BLC_PWM_CPU_CTL must be written after BLC_PWM_CPU_CTL2;
+		 * otherwise we get blank eDP screen after S3 on some machines
+		 */
 		I915_WRITE(BLC_PWM_CPU_CTL2, dev_priv->saveBLC_CPU_PWM_CTL2);
+		I915_WRITE(BLC_PWM_CPU_CTL, dev_priv->saveBLC_CPU_PWM_CTL);
 		I915_WRITE(PCH_PP_ON_DELAYS, dev_priv->savePP_ON_DELAYS);
 		I915_WRITE(PCH_PP_OFF_DELAYS, dev_priv->savePP_OFF_DELAYS);
 		I915_WRITE(PCH_PP_DIVISOR, dev_priv->savePP_DIVISOR);
diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/in=
tel_display.c
index 5c1cdb8..6aa7716 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -2187,6 +2187,33 @@ intel_pipe_set_base_atomic(struct drm_crtc *crtc, st=
ruct drm_framebuffer *fb,
 }
=20
 static int
+intel_finish_fb(struct drm_framebuffer *old_fb)
+{
+	struct drm_i915_gem_object *obj =3D to_intel_framebuffer(old_fb)->obj;
+	struct drm_i915_private *dev_priv =3D obj->base.dev->dev_private;
+	bool was_interruptible =3D dev_priv->mm.interruptible;
+	int ret;
+
+	wait_event(dev_priv->pending_flip_queue,
+		   atomic_read(&dev_priv->mm.wedged) ||
+		   atomic_read(&obj->pending_flip) =3D=3D 0);
+
+	/* Big Hammer, we also need to ensure that any pending
+	 * MI_WAIT_FOR_EVENT inside a user batch buffer on the
+	 * current scanout is retired before unpinning the old
+	 * framebuffer.
+	 *
+	 * This should only fail upon a hung GPU, in which case we
+	 * can safely continue.
+	 */
+	dev_priv->mm.interruptible =3D false;
+	ret =3D i915_gem_object_finish_gpu(obj);
+	dev_priv->mm.interruptible =3D was_interruptible;
+
+	return ret;
+}
+
+static int
 intel_pipe_set_base(struct drm_crtc *crtc, int x, int y,
 		    struct drm_framebuffer *old_fb)
 {
@@ -2224,25 +2251,8 @@ intel_pipe_set_base(struct drm_crtc *crtc, int x, in=
t y,
 		return ret;
 	}
=20
-	if (old_fb) {
-		struct drm_i915_private *dev_priv =3D dev->dev_private;
-		struct drm_i915_gem_object *obj =3D to_intel_framebuffer(old_fb)->obj;
-
-		wait_event(dev_priv->pending_flip_queue,
-			   atomic_read(&dev_priv->mm.wedged) ||
-			   atomic_read(&obj->pending_flip) =3D=3D 0);
-
-		/* Big Hammer, we also need to ensure that any pending
-		 * MI_WAIT_FOR_EVENT inside a user batch buffer on the
-		 * current scanout is retired before unpinning the old
-		 * framebuffer.
-		 *
-		 * This should only fail upon a hung GPU, in which case we
-		 * can safely continue.
-		 */
-		ret =3D i915_gem_object_finish_gpu(obj);
-		(void) ret;
-	}
+	if (old_fb)
+		intel_finish_fb(old_fb);
=20
 	ret =3D intel_pipe_set_base_atomic(crtc, crtc->fb, x, y,
 					 LEAVE_ATOMIC_MODE_SET);
@@ -3312,6 +3322,23 @@ static void intel_crtc_disable(struct drm_crtc *crtc=
)
 	struct drm_crtc_helper_funcs *crtc_funcs =3D crtc->helper_private;
 	struct drm_device *dev =3D crtc->dev;
=20
+	/* Flush any pending WAITs before we disable the pipe. Note that
+	 * we need to drop the struct_mutex in order to acquire it again
+	 * during the lowlevel dpms routines around a couple of the
+	 * operations. It does not look trivial nor desirable to move
+	 * that locking higher. So instead we leave a window for the
+	 * submission of further commands on the fb before we can actually
+	 * disable it. This race with userspace exists anyway, and we can
+	 * only rely on the pipe being disabled by userspace after it
+	 * receives the hotplug notification and has flushed any pending
+	 * batches.
+	 */
+	if (crtc->fb) {
+		mutex_lock(&dev->struct_mutex);
+		intel_finish_fb(crtc->fb);
+		mutex_unlock(&dev->struct_mutex);
+	}
+
 	crtc_funcs->dpms(crtc, DRM_MODE_DPMS_OFF);
=20
 	if (crtc->fb) {
diff --git a/drivers/gpu/drm/i915/intel_ringbuffer.c b/drivers/gpu/drm/i915=
/intel_ringbuffer.c
index 933e66b..f6613dc 100644
--- a/drivers/gpu/drm/i915/intel_ringbuffer.c
+++ b/drivers/gpu/drm/i915/intel_ringbuffer.c
@@ -306,7 +306,7 @@ static int init_ring_common(struct intel_ring_buffer *r=
ing)
=20
 	I915_WRITE_CTL(ring,
 			((ring->size - PAGE_SIZE) & RING_NR_PAGES)
-			| RING_REPORT_64K | RING_VALID);
+			| RING_VALID);
=20
 	/* If the head is still not zero, the ring is dead */
 	if ((I915_READ_CTL(ring) & RING_VALID) =3D=3D 0 ||
@@ -1157,18 +1157,6 @@ int intel_wait_ring_buffer(struct intel_ring_buffer =
*ring, int n)
 	struct drm_device *dev =3D ring->dev;
 	struct drm_i915_private *dev_priv =3D dev->dev_private;
 	unsigned long end;
-	u32 head;
-
-	/* If the reported head position has wrapped or hasn't advanced,
-	 * fallback to the slow and accurate path.
-	 */
-	head =3D intel_read_status_page(ring, 4);
-	if (head > ring->head) {
-		ring->head =3D head;
-		ring->space =3D ring_space(ring);
-		if (ring->space >=3D n)
-			return 0;
-	}
=20
 	trace_i915_ring_wait_begin(ring);
 	end =3D jiffies + 3 * HZ;
diff --git a/drivers/gpu/drm/nouveau/nouveau_fbcon.c b/drivers/gpu/drm/nouv=
eau/nouveau_fbcon.c
index 3a4cc32..cc0801d 100644
--- a/drivers/gpu/drm/nouveau/nouveau_fbcon.c
+++ b/drivers/gpu/drm/nouveau/nouveau_fbcon.c
@@ -499,7 +499,7 @@ int nouveau_fbcon_init(struct drm_device *dev)
 	nfbdev->helper.funcs =3D &nouveau_fbcon_helper_funcs;
=20
 	ret =3D drm_fb_helper_init(dev, &nfbdev->helper,
-				 nv_two_heads(dev) ? 2 : 1, 4);
+				 dev->mode_config.num_crtc, 4);
 	if (ret) {
 		kfree(nfbdev);
 		return ret;
diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
index 4c07436..d99aa84 100644
--- a/drivers/hwmon/applesmc.c
+++ b/drivers/hwmon/applesmc.c
@@ -215,7 +215,7 @@ static int read_smc(u8 cmd, const char *key, u8 *buffer=
, u8 len)
 	int i;
=20
 	if (send_command(cmd) || send_argument(key)) {
-		pr_warn("%s: read arg fail\n", key);
+		pr_warn("%.4s: read arg fail\n", key);
 		return -EIO;
 	}
=20
@@ -223,7 +223,7 @@ static int read_smc(u8 cmd, const char *key, u8 *buffer=
, u8 len)
=20
 	for (i =3D 0; i < len; i++) {
 		if (__wait_status(0x05)) {
-			pr_warn("%s: read data fail\n", key);
+			pr_warn("%.4s: read data fail\n", key);
 			return -EIO;
 		}
 		buffer[i] =3D inb(APPLESMC_DATA_PORT);
diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
index 427468f..0790c98 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -660,7 +660,7 @@ static void __cpuinit get_core_online(unsigned int cpu)
 	 * sensors. We check this bit only, all the early CPUs
 	 * without thermal sensors will be filtered out.
 	 */
-	if (!cpu_has(c, X86_FEATURE_DTS))
+	if (!cpu_has(c, X86_FEATURE_DTHERM))
 		return;
=20
 	if (!pdev) {
diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index da2f021..532a902 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -288,8 +288,10 @@ static void __cell_release(struct cell *cell, struct b=
io_list *inmates)
=20
 	hlist_del(&cell->list);
=20
-	bio_list_add(inmates, cell->holder);
-	bio_list_merge(inmates, &cell->bios);
+	if (inmates) {
+		bio_list_add(inmates, cell->holder);
+		bio_list_merge(inmates, &cell->bios);
+	}
=20
 	mempool_free(cell, prison->cell_pool);
 }
@@ -312,9 +314,10 @@ static void cell_release(struct cell *cell, struct bio=
_list *bios)
  */
 static void __cell_release_singleton(struct cell *cell, struct bio *bio)
 {
-	hlist_del(&cell->list);
 	BUG_ON(cell->holder !=3D bio);
 	BUG_ON(!bio_list_empty(&cell->bios));
+
+	__cell_release(cell, NULL);
 }
=20
 static void cell_release_singleton(struct cell *cell, struct bio *bio)
diff --git a/drivers/media/dvb/siano/smsusb.c b/drivers/media/dvb/siano/sms=
usb.c
index b7d1e3e..fb68805 100644
--- a/drivers/media/dvb/siano/smsusb.c
+++ b/drivers/media/dvb/siano/smsusb.c
@@ -544,6 +544,8 @@ static const struct usb_device_id smsusb_id_table[] __d=
evinitconst =3D {
 		.driver_info =3D SMS1XXX_BOARD_HAUPPAUGE_WINDHAM },
 	{ USB_DEVICE(0x2040, 0xc0a0),
 		.driver_info =3D SMS1XXX_BOARD_HAUPPAUGE_WINDHAM },
+	{ USB_DEVICE(0x2040, 0xf5a0),
+		.driver_info =3D SMS1XXX_BOARD_HAUPPAUGE_WINDHAM },
 	{ } /* Terminating entry */
 	};
=20
diff --git a/drivers/media/video/gspca/gspca.c b/drivers/media/video/gspca/=
gspca.c
index 2ca10df..981501f 100644
--- a/drivers/media/video/gspca/gspca.c
+++ b/drivers/media/video/gspca/gspca.c
@@ -1697,7 +1697,7 @@ static int vidioc_streamoff(struct file *file, void *=
priv,
 				enum v4l2_buf_type buf_type)
 {
 	struct gspca_dev *gspca_dev =3D priv;
-	int ret;
+	int i, ret;
=20
 	if (buf_type !=3D V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
@@ -1728,6 +1728,8 @@ static int vidioc_streamoff(struct file *file, void *=
priv,
 	wake_up_interruptible(&gspca_dev->wq);
=20
 	/* empty the transfer queues */
+	for (i =3D 0; i < gspca_dev->nframes; i++)
+		gspca_dev->frame[i].v4l2_buf.flags &=3D ~BUF_ALL_FLAGS;
 	atomic_set(&gspca_dev->fr_q, 0);
 	atomic_set(&gspca_dev->fr_i, 0);
 	gspca_dev->fr_o =3D 0;
diff --git a/drivers/net/can/c_can/c_can.c b/drivers/net/can/c_can/c_can.c
index 8dc84d6..86cd532 100644
--- a/drivers/net/can/c_can/c_can.c
+++ b/drivers/net/can/c_can/c_can.c
@@ -590,8 +590,8 @@ static void c_can_chip_config(struct net_device *dev)
 	priv->write_reg(priv, &priv->regs->control,
 			CONTROL_ENABLE_AR);
=20
-	if (priv->can.ctrlmode & (CAN_CTRLMODE_LISTENONLY &
-					CAN_CTRLMODE_LOOPBACK)) {
+	if ((priv->can.ctrlmode & CAN_CTRLMODE_LISTENONLY) &&
+	    (priv->can.ctrlmode & CAN_CTRLMODE_LOOPBACK)) {
 		/* loopback + silent mode : useful for hot self-test */
 		priv->write_reg(priv, &priv->regs->control, CONTROL_EIE |
 				CONTROL_SIE | CONTROL_IE | CONTROL_TEST);
diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index e023379..e59d006 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -933,12 +933,12 @@ static int __devinit flexcan_probe(struct platform_de=
vice *pdev)
 	u32 clock_freq =3D 0;
=20
 	if (pdev->dev.of_node) {
-		const u32 *clock_freq_p;
+		const __be32 *clock_freq_p;
=20
 		clock_freq_p =3D of_get_property(pdev->dev.of_node,
 						"clock-frequency", NULL);
 		if (clock_freq_p)
-			clock_freq =3D *clock_freq_p;
+			clock_freq =3D be32_to_cpup(clock_freq_p);
 	}
=20
 	if (!clock_freq) {
diff --git a/drivers/net/ethernet/intel/e1000e/82571.c b/drivers/net/ethern=
et/intel/e1000e/82571.c
index a3e65fd..e556fc3 100644
--- a/drivers/net/ethernet/intel/e1000e/82571.c
+++ b/drivers/net/ethernet/intel/e1000e/82571.c
@@ -2080,8 +2080,9 @@ const struct e1000_info e1000_82574_info =3D {
 				  | FLAG_HAS_SMART_POWER_DOWN
 				  | FLAG_HAS_AMT
 				  | FLAG_HAS_CTRLEXT_ON_LOAD,
-	.flags2			  =3D FLAG2_CHECK_PHY_HANG
+	.flags2			=3D FLAG2_CHECK_PHY_HANG
 				  | FLAG2_DISABLE_ASPM_L0S
+				  | FLAG2_DISABLE_ASPM_L1
 				  | FLAG2_NO_DISABLE_RX,
 	.pba			=3D 32,
 	.max_hw_frame_size	=3D DEFAULT_JUMBO,
diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ether=
net/intel/e1000e/netdev.c
index 4e933d1..64d3f98 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -5132,14 +5132,6 @@ static int e1000_change_mtu(struct net_device *netde=
v, int new_mtu)
 		return -EINVAL;
 	}
=20
-	/* 82573 Errata 17 */
-	if (((adapter->hw.mac.type =3D=3D e1000_82573) ||
-	     (adapter->hw.mac.type =3D=3D e1000_82574)) &&
-	    (max_frame > ETH_FRAME_LEN + ETH_FCS_LEN)) {
-		adapter->flags2 |=3D FLAG2_DISABLE_ASPM_L1;
-		e1000e_disable_aspm(adapter->pdev, PCIE_LINK_STATE_L1);
-	}
-
 	while (test_and_set_bit(__E1000_RESETTING, &adapter->state))
 		usleep_range(1000, 2000);
 	/* e1000e_down -> e1000e_reset dependent on max_frame_size & mtu */
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath=
/ath9k/hw.c
index 8b0c2ca..6973620 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -718,13 +718,25 @@ static void ath9k_hw_init_qos(struct ath_hw *ah)
=20
 u32 ar9003_get_pll_sqsum_dvc(struct ath_hw *ah)
 {
+	struct ath_common *common =3D ath9k_hw_common(ah);
+	int i =3D 0;
+
 	REG_CLR_BIT(ah, PLL3, PLL3_DO_MEAS_MASK);
 	udelay(100);
 	REG_SET_BIT(ah, PLL3, PLL3_DO_MEAS_MASK);
=20
-	while ((REG_READ(ah, PLL4) & PLL4_MEAS_DONE) =3D=3D 0)
+	while ((REG_READ(ah, PLL4) & PLL4_MEAS_DONE) =3D=3D 0) {
+
 		udelay(100);
=20
+		if (WARN_ON_ONCE(i >=3D 100)) {
+			ath_err(common, "PLL4 meaurement not done\n");
+			break;
+		}
+
+		i++;
+	}
+
 	return (REG_READ(ah, PLL3) & SQSUM_DVC_MASK) >> 3;
 }
 EXPORT_SYMBOL(ar9003_get_pll_sqsum_dvc);
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/a=
th/ath9k/main.c
index f76a814..95437fc 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1042,6 +1042,15 @@ void ath_hw_pll_work(struct work_struct *work)
 					    hw_pll_work.work);
 	u32 pll_sqsum;
=20
+	/*
+	 * ensure that the PLL WAR is executed only
+	 * after the STA is associated (or) if the
+	 * beaconing had started in interfaces that
+	 * uses beacons.
+	 */
+	if (!(sc->sc_flags & SC_OP_BEACONS))
+		return;
+
 	if (AR_SREV_9485(sc->sc_ah)) {
=20
 		ath9k_ps_wakeup(sc);
@@ -1486,15 +1495,6 @@ static int ath9k_add_interface(struct ieee80211_hw *=
hw,
 		}
 	}
=20
-	if ((ah->opmode =3D=3D NL80211_IFTYPE_ADHOC) ||
-	    ((vif->type =3D=3D NL80211_IFTYPE_ADHOC) &&
-	     sc->nvifs > 0)) {
-		ath_err(common, "Cannot create ADHOC interface when other"
-			" interfaces already exist.\n");
-		ret =3D -EINVAL;
-		goto out;
-	}
-
 	ath_dbg(common, ATH_DBG_CONFIG,
 		"Attach a VIF of type: %d\n", vif->type);
=20
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/a=
th/ath9k/xmit.c
index 76fd277..c59c592 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -936,13 +936,13 @@ static void ath_buf_set_rate(struct ath_softc *sc, st=
ruct ath_buf *bf,
 		}
=20
 		/* legacy rates */
+		rate =3D &sc->sbands[tx_info->band].bitrates[rates[i].idx];
 		if ((tx_info->band =3D=3D IEEE80211_BAND_2GHZ) &&
 		    !(rate->flags & IEEE80211_RATE_ERP_G))
 			phy =3D WLAN_RC_PHY_CCK;
 		else
 			phy =3D WLAN_RC_PHY_OFDM;
=20
-		rate =3D &sc->sbands[tx_info->band].bitrates[rates[i].idx];
 		info->rates[i].Rate =3D rate->hw_value;
 		if (rate->hw_value_short) {
 			if (rates[i].flags & IEEE80211_TX_RC_USE_SHORT_PREAMBLE)
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wi=
reless/iwlwifi/iwl-trans-pcie.c
index 5815cf5..4661a64 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -1777,6 +1777,7 @@ static ssize_t iwl_dbgfs_rx_queue_read(struct file *f=
ile,
 	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 }
=20
+#ifdef CONFIG_IWLWIFI_DEBUG
 static ssize_t iwl_dbgfs_log_event_read(struct file *file,
 					 char __user *user_buf,
 					 size_t count, loff_t *ppos)
@@ -1814,6 +1815,7 @@ static ssize_t iwl_dbgfs_log_event_write(struct file =
*file,
=20
 	return count;
 }
+#endif
=20
 static ssize_t iwl_dbgfs_interrupt_read(struct file *file,
 					char __user *user_buf,
@@ -1941,7 +1943,9 @@ static ssize_t iwl_dbgfs_fh_reg_read(struct file *fil=
e,
 	return ret;
 }
=20
+#ifdef CONFIG_IWLWIFI_DEBUG
 DEBUGFS_READ_WRITE_FILE_OPS(log_event);
+#endif
 DEBUGFS_READ_WRITE_FILE_OPS(interrupt);
 DEBUGFS_READ_FILE_OPS(fh_reg);
 DEBUGFS_READ_FILE_OPS(rx_queue);
@@ -1957,7 +1961,9 @@ static int iwl_trans_pcie_dbgfs_register(struct iwl_t=
rans *trans,
 {
 	DEBUGFS_ADD_FILE(rx_queue, dir, S_IRUSR);
 	DEBUGFS_ADD_FILE(tx_queue, dir, S_IRUSR);
+#ifdef CONFIG_IWLWIFI_DEBUG
 	DEBUGFS_ADD_FILE(log_event, dir, S_IWUSR | S_IRUSR);
+#endif
 	DEBUGFS_ADD_FILE(interrupt, dir, S_IWUSR | S_IRUSR);
 	DEBUGFS_ADD_FILE(csr, dir, S_IWUSR);
 	DEBUGFS_ADD_FILE(fh_reg, dir, S_IRUSR);
diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index 226faab..fc35308 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -1922,14 +1922,14 @@ static int __devexit xennet_remove(struct xenbus_de=
vice *dev)
=20
 	dev_dbg(&dev->dev, "%s\n", dev->nodename);
=20
-	unregister_netdev(info->netdev);
-
 	xennet_disconnect_backend(info);
=20
-	del_timer_sync(&info->rx_refill_timer);
-
 	xennet_sysfs_delif(info->netdev);
=20
+	unregister_netdev(info->netdev);
+
+	del_timer_sync(&info->rx_refill_timer);
+
 	free_percpu(info->stats);
=20
 	free_netdev(info->netdev);
diff --git a/drivers/oprofile/oprofile_perf.c b/drivers/oprofile/oprofile_p=
erf.c
index da14432..efc4b7f 100644
--- a/drivers/oprofile/oprofile_perf.c
+++ b/drivers/oprofile/oprofile_perf.c
@@ -25,7 +25,7 @@ static int oprofile_perf_enabled;
 static DEFINE_MUTEX(oprofile_perf_mutex);
=20
 static struct op_counter_config *counter_config;
-static struct perf_event **perf_events[nr_cpumask_bits];
+static struct perf_event **perf_events[NR_CPUS];
 static int num_counters;
=20
 /*
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 4b63c73..a26a6e9 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1811,6 +1811,8 @@ static int sd_try_rc16_first(struct scsi_device *sdp)
 {
 	if (sdp->host->max_cmd_len < 16)
 		return 0;
+	if (sdp->try_rc_10_first)
+		return 0;
 	if (sdp->scsi_level > SCSI_SPC_2)
 		return 1;
 	if (scsi_device_protection(sdp))
diff --git a/drivers/staging/iio/adc/ad7606_core.c b/drivers/staging/iio/ad=
c/ad7606_core.c
index 54423ab..2ee187f 100644
--- a/drivers/staging/iio/adc/ad7606_core.c
+++ b/drivers/staging/iio/adc/ad7606_core.c
@@ -241,6 +241,7 @@ static const struct attribute_group ad7606_attribute_gr=
oup =3D {
 		.indexed =3D 1,				\
 		.channel =3D num,				\
 		.address =3D num,				\
+		.info_mask =3D (1 << IIO_CHAN_INFO_SCALE_SHARED), \
 		.scan_index =3D num,			\
 		.scan_type =3D IIO_ST('s', 16, 16, 0),	\
 	}
diff --git a/drivers/staging/rtl8712/usb_intf.c b/drivers/staging/rtl8712/u=
sb_intf.c
index ec41d38..f4b738f 100644
--- a/drivers/staging/rtl8712/usb_intf.c
+++ b/drivers/staging/rtl8712/usb_intf.c
@@ -102,6 +102,8 @@ static struct usb_device_id rtl871x_usb_id_tbl[] =3D {
 	/* - */
 	{USB_DEVICE(0x20F4, 0x646B)},
 	{USB_DEVICE(0x083A, 0xC512)},
+	{USB_DEVICE(0x25D4, 0x4CA1)},
+	{USB_DEVICE(0x25D4, 0x4CAB)},
=20
 /* RTL8191SU */
 	/* Realtek */
diff --git a/drivers/staging/rts_pstor/rtsx_transport.c b/drivers/staging/r=
ts_pstor/rtsx_transport.c
index 4e3d2c1..9b2e5c9 100644
--- a/drivers/staging/rts_pstor/rtsx_transport.c
+++ b/drivers/staging/rts_pstor/rtsx_transport.c
@@ -335,6 +335,7 @@ static int rtsx_transfer_sglist_adma_partial(struct rts=
x_chip *chip, u8 card,
 	int sg_cnt, i, resid;
 	int err =3D 0;
 	long timeleft;
+	struct scatterlist *sg_ptr;
 	u32 val =3D TRIG_DMA;
=20
 	if ((sg =3D=3D NULL) || (num_sg <=3D 0) || !offset || !index)
@@ -371,7 +372,7 @@ static int rtsx_transfer_sglist_adma_partial(struct rts=
x_chip *chip, u8 card,
 	sg_cnt =3D dma_map_sg(&(rtsx->pci->dev), sg, num_sg, dma_dir);
=20
 	resid =3D size;
-
+	sg_ptr =3D sg;
 	chip->sgi =3D 0;
 	/* Usually the next entry will be @sg@ + 1, but if this sg element
 	 * is part of a chained scatterlist, it could jump to the start of
@@ -379,14 +380,14 @@ static int rtsx_transfer_sglist_adma_partial(struct r=
tsx_chip *chip, u8 card,
 	 * the proper sg
 	 */
 	for (i =3D 0; i < *index; i++)
-		sg =3D sg_next(sg);
+		sg_ptr =3D sg_next(sg_ptr);
 	for (i =3D *index; i < sg_cnt; i++) {
 		dma_addr_t addr;
 		unsigned int len;
 		u8 option;
=20
-		addr =3D sg_dma_address(sg);
-		len =3D sg_dma_len(sg);
+		addr =3D sg_dma_address(sg_ptr);
+		len =3D sg_dma_len(sg_ptr);
=20
 		RTSX_DEBUGP("DMA addr: 0x%x, Len: 0x%x\n",
 			     (unsigned int)addr, len);
@@ -415,7 +416,7 @@ static int rtsx_transfer_sglist_adma_partial(struct rts=
x_chip *chip, u8 card,
 		if (!resid)
 			break;
=20
-		sg =3D sg_next(sg);
+		sg_ptr =3D sg_next(sg_ptr);
 	}
=20
 	RTSX_DEBUGP("SG table count =3D %d\n", chip->sgi);
diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
index aa0c43f..35e6b5f 100644
--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -93,6 +93,7 @@ static const struct usb_device_id id_table[] =3D {
 	{ USB_DEVICE(0x10C4, 0x814B) }, /* West Mountain Radio RIGtalk */
 	{ USB_DEVICE(0x10C4, 0x8156) }, /* B&G H3000 link cable */
 	{ USB_DEVICE(0x10C4, 0x815E) }, /* Helicomm IP-Link 1220-DVM */
+	{ USB_DEVICE(0x10C4, 0x815F) }, /* Timewave HamLinkUSB */
 	{ USB_DEVICE(0x10C4, 0x818B) }, /* AVIT Research USB to TTL */
 	{ USB_DEVICE(0x10C4, 0x819F) }, /* MJS USB Toslink Switcher */
 	{ USB_DEVICE(0x10C4, 0x81A6) }, /* ThinkOptics WavIt */
@@ -134,7 +135,13 @@ static const struct usb_device_id id_table[] =3D {
 	{ USB_DEVICE(0x10CE, 0xEA6A) }, /* Silicon Labs MobiData GPRS USB Modem 1=
00EU */
 	{ USB_DEVICE(0x13AD, 0x9999) }, /* Baltech card reader */
 	{ USB_DEVICE(0x1555, 0x0004) }, /* Owen AC4 USB-RS485 Converter */
+	{ USB_DEVICE(0x166A, 0x0201) }, /* Clipsal 5500PACA C-Bus Pascal Automati=
on Controller */
+	{ USB_DEVICE(0x166A, 0x0301) }, /* Clipsal 5800PC C-Bus Wireless PC Inter=
face */
 	{ USB_DEVICE(0x166A, 0x0303) }, /* Clipsal 5500PCU C-Bus USB interface */
+	{ USB_DEVICE(0x166A, 0x0304) }, /* Clipsal 5000CT2 C-Bus Black and White =
Touchscreen */
+	{ USB_DEVICE(0x166A, 0x0305) }, /* Clipsal C-5000CT2 C-Bus Spectrum Colou=
r Touchscreen */
+	{ USB_DEVICE(0x166A, 0x0401) }, /* Clipsal L51xx C-Bus Architectural Dimm=
er */
+	{ USB_DEVICE(0x166A, 0x0101) }, /* Clipsal 5560884 C-Bus Multi-room Audio=
 Matrix Switcher */
 	{ USB_DEVICE(0x16D6, 0x0001) }, /* Jablotron serial interface */
 	{ USB_DEVICE(0x16DC, 0x0010) }, /* W-IE-NE-R Plein & Baus GmbH PL512 Powe=
r Supply */
 	{ USB_DEVICE(0x16DC, 0x0011) }, /* W-IE-NE-R Plein & Baus GmbH RCM Remote=
 Control for MARATON Power Supply */
@@ -146,7 +153,11 @@ static const struct usb_device_id id_table[] =3D {
 	{ USB_DEVICE(0x1843, 0x0200) }, /* Vaisala USB Instrument Cable */
 	{ USB_DEVICE(0x18EF, 0xE00F) }, /* ELV USB-I2C-Interface */
 	{ USB_DEVICE(0x1BE3, 0x07A6) }, /* WAGO 750-923 USB Service Cable */
+	{ USB_DEVICE(0x1E29, 0x0102) }, /* Festo CPX-USB */
+	{ USB_DEVICE(0x1E29, 0x0501) }, /* Festo CMSP */
 	{ USB_DEVICE(0x3195, 0xF190) }, /* Link Instruments MSO-19 */
+	{ USB_DEVICE(0x3195, 0xF280) }, /* Link Instruments MSO-28 */
+	{ USB_DEVICE(0x3195, 0xF281) }, /* Link Instruments MSO-28 */
 	{ USB_DEVICE(0x413C, 0x9500) }, /* DW700 GPS USB interface */
 	{ } /* Terminating Entry */
 };
diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 61d6c31..21a4734 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -235,6 +235,7 @@ static void option_instat_callback(struct urb *urb);
 #define NOVATELWIRELESS_PRODUCT_G1		0xA001
 #define NOVATELWIRELESS_PRODUCT_G1_M		0xA002
 #define NOVATELWIRELESS_PRODUCT_G2		0xA010
+#define NOVATELWIRELESS_PRODUCT_MC551		0xB001
=20
 /* AMOI PRODUCTS */
 #define AMOI_VENDOR_ID				0x1614
@@ -496,6 +497,10 @@ static void option_instat_callback(struct urb *urb);
 /* MediaTek products */
 #define MEDIATEK_VENDOR_ID			0x0e8d
=20
+/* Cellient products */
+#define CELLIENT_VENDOR_ID			0x2692
+#define CELLIENT_PRODUCT_MEN200			0x9005
+
 /* some devices interfaces need special handling due to a number of reason=
s */
 enum option_blacklist_reason {
 		OPTION_BLACKLIST_NONE =3D 0,
@@ -730,6 +735,8 @@ static const struct usb_device_id option_ids[] =3D {
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_G1) },
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_G1_M) },
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_G2) },
+	/* Novatel Ovation MC551 a.k.a. Verizon USB551L */
+	{ USB_DEVICE_AND_INTERFACE_INFO(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELES=
S_PRODUCT_MC551, 0xff, 0xff, 0xff) },
=20
 	{ USB_DEVICE(AMOI_VENDOR_ID, AMOI_PRODUCT_H01) },
 	{ USB_DEVICE(AMOI_VENDOR_ID, AMOI_PRODUCT_H01A) },
@@ -1227,6 +1234,7 @@ static const struct usb_device_id option_ids[] =3D {
 	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, 0x00a1, 0xff, 0x02, 0=
x01) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, 0x00a2, 0xff, 0x00, 0=
x00) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, 0x00a2, 0xff, 0x02, 0=
x01) },        /* MediaTek MT6276M modem & app port */
+	{ USB_DEVICE(CELLIENT_VENDOR_ID, CELLIENT_PRODUCT_MEN200) },
 	{ } /* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, option_ids);
diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglue.=
c
index 13b8bcd..3799fa4 100644
--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -213,6 +213,12 @@ static int slave_configure(struct scsi_device *sdev)
 		if (us->fflags & US_FL_NO_READ_CAPACITY_16)
 			sdev->no_read_capacity_16 =3D 1;
=20
+		/*
+		 * Many devices do not respond properly to READ_CAPACITY_16.
+		 * Tell the SCSI layer to try READ_CAPACITY_10 first.
+		 */
+		sdev->try_rc_10_first =3D 1;
+
 		/* assume SPC3 or latter devices support sense size > 18 */
 		if (sdev->scsi_level > SCSI_SPC_2)
 			us->fflags |=3D US_FL_SANE_SENSE;
diff --git a/fs/exec.c b/fs/exec.c
index 160cd2f..fa4dd09 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -820,10 +820,10 @@ static int exec_mmap(struct mm_struct *mm)
 	/* Notify parent that we're no longer interested in the old VM */
 	tsk =3D current;
 	old_mm =3D current->mm;
-	sync_mm_rss(tsk, old_mm);
 	mm_release(tsk, old_mm);
=20
 	if (old_mm) {
+		sync_mm_rss(tsk, old_mm);
 		/*
 		 * Make sure that if there is a core dump in progress
 		 * for the old mm, we get out and die instead of going
diff --git a/fs/nilfs2/gcinode.c b/fs/nilfs2/gcinode.c
index 08a07a2..57ceaf3 100644
--- a/fs/nilfs2/gcinode.c
+++ b/fs/nilfs2/gcinode.c
@@ -191,6 +191,8 @@ void nilfs_remove_all_gcinodes(struct the_nilfs *nilfs)
 	while (!list_empty(head)) {
 		ii =3D list_first_entry(head, struct nilfs_inode_info, i_dirty);
 		list_del_init(&ii->i_dirty);
+		truncate_inode_pages(&ii->vfs_inode.i_data, 0);
+		nilfs_btnode_cache_clear(&ii->i_btnode_cache);
 		iput(&ii->vfs_inode);
 	}
 }
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index bb24ab6..6f24e67 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -2309,6 +2309,8 @@ nilfs_remove_written_gcinodes(struct the_nilfs *nilfs=
, struct list_head *head)
 		if (!test_bit(NILFS_I_UPDATED, &ii->i_state))
 			continue;
 		list_del_init(&ii->i_dirty);
+		truncate_inode_pages(&ii->vfs_inode.i_data, 0);
+		nilfs_btnode_cache_clear(&ii->i_btnode_cache);
 		iput(&ii->vfs_inode);
 	}
 }
diff --git a/include/asm-generic/pgtable.h b/include/asm-generic/pgtable.h
index a03c098..bc00876 100644
--- a/include/asm-generic/pgtable.h
+++ b/include/asm-generic/pgtable.h
@@ -445,6 +445,18 @@ static inline int pmd_write(pmd_t pmd)
 #endif /* __HAVE_ARCH_PMD_WRITE */
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
=20
+#ifndef pmd_read_atomic
+static inline pmd_t pmd_read_atomic(pmd_t *pmdp)
+{
+	/*
+	 * Depend on compiler for an atomic pmd read. NOTE: this is
+	 * only going to work, if the pmdval_t isn't larger than
+	 * an unsigned long.
+	 */
+	return *pmdp;
+}
+#endif
+
 /*
  * This function is meant to be used by sites walking pagetables with
  * the mmap_sem hold in read mode to protect against MADV_DONTNEED and
@@ -458,14 +470,30 @@ static inline int pmd_write(pmd_t pmd)
  * undefined so behaving like if the pmd was none is safe (because it
  * can return none anyway). The compiler level barrier() is critically
  * important to compute the two checks atomically on the same pmdval.
+ *
+ * For 32bit kernels with a 64bit large pmd_t this automatically takes
+ * care of reading the pmd atomically to avoid SMP race conditions
+ * against pmd_populate() when the mmap_sem is hold for reading by the
+ * caller (a special atomic read not done by "gcc" as in the generic
+ * version above, is also needed when THP is disabled because the page
+ * fault can populate the pmd from under us).
  */
 static inline int pmd_none_or_trans_huge_or_clear_bad(pmd_t *pmd)
 {
-	/* depend on compiler for an atomic pmd read */
-	pmd_t pmdval =3D *pmd;
+	pmd_t pmdval =3D pmd_read_atomic(pmd);
 	/*
 	 * The barrier will stabilize the pmdval in a register or on
 	 * the stack so that it will stop changing under the code.
+	 *
+	 * When CONFIG_TRANSPARENT_HUGEPAGE=3Dy on x86 32bit PAE,
+	 * pmd_read_atomic is allowed to return a not atomic pmdval
+	 * (for example pointing to an hugepage that has never been
+	 * mapped in the pmd). The below checks will only care about
+	 * the low part of the pmd with 32bit PAE x86 anyway, with the
+	 * exception of pmd_none(). So the important thing is that if
+	 * the low part of the pmd is found null, the high part will
+	 * be also null or the pmd_none() check below would be
+	 * confused.
 	 */
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	barrier();
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 5b42f1b..e32f8e8 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -56,8 +56,18 @@ struct page {
 		};
=20
 		union {
+#if defined(CONFIG_HAVE_CMPXCHG_DOUBLE) && \
+	defined(CONFIG_HAVE_ALIGNED_STRUCT_PAGE)
 			/* Used for cmpxchg_double in slub */
 			unsigned long counters;
+#else
+			/*
+			 * Keep _count separate from slub cmpxchg_double data.
+			 * As the rest of the double word is protected by
+			 * slab_lock but _count is not.
+			 */
+			unsigned counters;
+#endif
=20
 			struct {
=20
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 5591ed5..a8f4b75 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -150,6 +150,7 @@ struct scsi_device {
 					   SD_LAST_BUGGY_SECTORS */
 	unsigned no_read_disc_info:1;	/* Avoid READ_DISC_INFO cmds */
 	unsigned no_read_capacity_16:1; /* Avoid READ_CAPACITY_16 cmds */
+	unsigned try_rc_10_first:1;	/* Try READ_CAPACACITY_10 first */
 	unsigned is_visible:1;	/* is the device visible in sysfs */
=20
 	DECLARE_BITMAP(supported_events, SDEV_EVT_MAXBITS); /* supported events *=
/
diff --git a/kernel/exit.c b/kernel/exit.c
index 5a8a66e..83fea52 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -641,6 +641,7 @@ static void exit_mm(struct task_struct * tsk)
 	mm_release(tsk, mm);
 	if (!mm)
 		return;
+	sync_mm_rss(tsk, mm);
 	/*
 	 * Serialize with any possible pending coredump.
 	 * We must hold mmap_sem around checking core_state
diff --git a/net/batman-adv/routing.c b/net/batman-adv/routing.c
index f961cc5..da587ad 100644
--- a/net/batman-adv/routing.c
+++ b/net/batman-adv/routing.c
@@ -619,6 +619,8 @@ int recv_tt_query(struct sk_buff *skb, struct hard_ifac=
e *recv_if)
 		/* packet needs to be linearized to access the TT changes */
 		if (skb_linearize(skb) < 0)
 			goto out;
+		/* skb_linearize() possibly changed skb->data */
+		tt_query =3D (struct tt_query_packet *)skb->data;
=20
 		if (is_my_mac(tt_query->dst))
 			handle_tt_response(bat_priv, tt_query);
diff --git a/net/batman-adv/translation-table.c b/net/batman-adv/translatio=
n-table.c
index 5f09a57..088af45 100644
--- a/net/batman-adv/translation-table.c
+++ b/net/batman-adv/translation-table.c
@@ -1816,10 +1816,10 @@ bool is_ap_isolated(struct bat_priv *bat_priv, uint=
8_t *src, uint8_t *dst)
 {
 	struct tt_local_entry *tt_local_entry =3D NULL;
 	struct tt_global_entry *tt_global_entry =3D NULL;
-	bool ret =3D true;
+	bool ret =3D false;
=20
 	if (!atomic_read(&bat_priv->ap_isolation))
-		return false;
+		goto out;
=20
 	tt_local_entry =3D tt_local_hash_find(bat_priv, dst);
 	if (!tt_local_entry)
@@ -1829,10 +1829,10 @@ bool is_ap_isolated(struct bat_priv *bat_priv, uint=
8_t *src, uint8_t *dst)
 	if (!tt_global_entry)
 		goto out;
=20
-	if (_is_ap_isolated(tt_local_entry, tt_global_entry))
+	if (!_is_ap_isolated(tt_local_entry, tt_global_entry))
 		goto out;
=20
-	ret =3D false;
+	ret =3D true;
=20
 out:
 	if (tt_global_entry)
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index c1c99dd..d57d05b 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1369,7 +1369,7 @@ static void reg_set_request_processed(void)
 	spin_unlock(&reg_requests_lock);
=20
 	if (last_request->initiator =3D=3D NL80211_REGDOM_SET_BY_USER)
-		cancel_delayed_work_sync(&reg_timeout);
+		cancel_delayed_work(&reg_timeout);
=20
 	if (need_more_processing)
 		schedule_work(&reg_work);
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 0005bde..5f096a5 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -5988,6 +5988,7 @@ static const struct hda_codec_preset snd_hda_preset_r=
ealtek[] =3D {
 	{ .id =3D 0x10ec0272, .name =3D "ALC272", .patch =3D patch_alc662 },
 	{ .id =3D 0x10ec0275, .name =3D "ALC275", .patch =3D patch_alc269 },
 	{ .id =3D 0x10ec0276, .name =3D "ALC276", .patch =3D patch_alc269 },
+	{ .id =3D 0x10ec0280, .name =3D "ALC280", .patch =3D patch_alc269 },
 	{ .id =3D 0x10ec0861, .rev =3D 0x100340, .name =3D "ALC660",
 	  .patch =3D patch_alc861 },
 	{ .id =3D 0x10ec0660, .name =3D "ALC660-VD", .patch =3D patch_alc861vd },
diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
index 11224ed..323d4d9 100644
--- a/tools/hv/hv_kvp_daemon.c
+++ b/tools/hv/hv_kvp_daemon.c
@@ -384,14 +384,18 @@ int main(void)
 	pfd.fd =3D fd;
=20
 	while (1) {
+		struct sockaddr *addr_p =3D (struct sockaddr *) &addr;
+		socklen_t addr_l =3D sizeof(addr);
 		pfd.events =3D POLLIN;
 		pfd.revents =3D 0;
 		poll(&pfd, 1, -1);
=20
-		len =3D recv(fd, kvp_recv_buffer, sizeof(kvp_recv_buffer), 0);
+		len =3D recvfrom(fd, kvp_recv_buffer, sizeof(kvp_recv_buffer), 0,
+				addr_p, &addr_l);
=20
-		if (len < 0) {
-			syslog(LOG_ERR, "recv failed; error:%d", len);
+		if (len < 0 || addr.nl_pid) {
+			syslog(LOG_ERR, "recvfrom failed; pid:%u error:%d %s",
+					addr.nl_pid, errno, strerror(errno));
 			close(fd);
 			return -1;
 		}


--=20
Ben Hutchings
If you seem to know what you are doing, you'll be given more to do.

--=-uTdvX9R+Wvc0pNFv5i26
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT/Cg1ue/yOyVhhEJAQqr4Q//WhpfiANb1IkWSLXtngvCb+lQpq2EOAeN
ekLfsBeVXpcHu6QRwQMhC/l2U1YQjZ3IvP/B8gRbBTwA3MbyZ5RTVpBSHX7zjfJF
TEDL3LlmM6AZSpwjnz7883fHzIZd1dn5gnngSW5UMXkinFtg4hNqMDu3On9Cwjpp
PZmIdHx7jrBJ8xHJdeHPUEugks8asbA05Fc6PbUj1pJkQwGJxd4WWhd/Lj9l6/Cu
VTJmF6IeVDmYPBIZKVfp+fUouSeV4pZKRWheYrz3L36Fvg9r2efeuZBm+VQNdEmc
9QVS69YqDA7cHIw2qMxWB1h7wO3/FjPXS6MVqOiuSxf2rzSccqK08rNyExyYgrYS
wpVmXH0tR17e2WZX2MNmIlxrnNC8oK+HE37tIlKyFbxer76aalg8lsuSMrQNBjRU
fxN6JSoR+DRgVHkZeWfySN4dycZJswodBtZGgckL0ApQ+j2wIdAlcUs6DJnirimu
KtA1E+zsyEAI//6Fni/5AbaVlP4wQIV9ZQcHad6bb/JYB9NX0cFxkfA7wlE3RhPl
aObp1MCS3WfV+1bC7k8J4Gf9Zmmc/Vb8vaR2R3rBaMbCk5LnYspJ0IS8jcdSZIME
UX/07JAJ/VZpsN/aNiTgEoAvrxMQfcPckjDr2g5O5Ym1bXRn7ATCOKCNRTDxcFNp
POm0HU61Jvg=
=QggW
-----END PGP SIGNATURE-----

--=-uTdvX9R+Wvc0pNFv5i26--
