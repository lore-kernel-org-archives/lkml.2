Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117Ab1DVQCe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 12:02:34 -0400
Received: from kroah.org ([198.145.64.141]:46378 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756076Ab1DVQCa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 12:02:30 -0400
Date: Fri, 22 Apr 2011 09:03:22 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org, lwn@lwn.net
Subject: Re: Linux 2.6.33.12
Message-ID: <20110422160322.GB20218@kroah.com>
References: <20110422160310.GA20218@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110422160310.GA20218@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/MAINTAINERS b/MAINTAINERS
index eebc1f0..b612a1f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5131,7 +5131,6 @@ F:	arch/alpha/kernel/srm_env.c
 
 STABLE BRANCH
 M:	Greg Kroah-Hartman <greg@kroah.com>
-M:	Chris Wright <chrisw@sous-sol.org>
 L:	stable@kernel.org
 S:	Maintained
 
diff --git a/Makefile b/Makefile
index 20107ca..46a1d6a 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 33
-EXTRAVERSION = .11
+EXTRAVERSION = .12
 NAME = Man-Eating Seals of Antiquity
 
 # *DOCUMENTATION*
diff --git a/arch/ia64/kernel/mca.c b/arch/ia64/kernel/mca.c
index 378b483..ad2b308 100644
--- a/arch/ia64/kernel/mca.c
+++ b/arch/ia64/kernel/mca.c
@@ -1858,7 +1858,8 @@ ia64_mca_cpu_init(void *cpu_data)
 			data = mca_bootmem();
 			first_time = 0;
 		} else
-			data = __get_free_pages(GFP_KERNEL, get_order(sz));
+			data = (void *)__get_free_pages(GFP_KERNEL,
+							get_order(sz));
 		if (!data)
 			panic("Could not allocate MCA memory for cpu %d\n",
 					cpu);
diff --git a/arch/ia64/sn/pci/tioca_provider.c b/arch/ia64/sn/pci/tioca_provider.c
index efb4545..129a0d1 100644
--- a/arch/ia64/sn/pci/tioca_provider.c
+++ b/arch/ia64/sn/pci/tioca_provider.c
@@ -508,7 +508,7 @@ tioca_dma_unmap(struct pci_dev *pdev, dma_addr_t bus_addr, int dir)
  * use the GART mapped mode.
  */
 static u64
-tioca_dma_map(struct pci_dev *pdev, u64 paddr, size_t byte_count, int dma_flags)
+tioca_dma_map(struct pci_dev *pdev, unsigned long paddr, size_t byte_count, int dma_flags)
 {
 	u64 mapaddr;
 
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 5928fc0..ad6338e 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -82,11 +82,15 @@
 #define MSR_IA32_MC0_ADDR		0x00000402
 #define MSR_IA32_MC0_MISC		0x00000403
 
+#define MSR_AMD64_MC0_MASK		0xc0010044
+
 #define MSR_IA32_MCx_CTL(x)		(MSR_IA32_MC0_CTL + 4*(x))
 #define MSR_IA32_MCx_STATUS(x)		(MSR_IA32_MC0_STATUS + 4*(x))
 #define MSR_IA32_MCx_ADDR(x)		(MSR_IA32_MC0_ADDR + 4*(x))
 #define MSR_IA32_MCx_MISC(x)		(MSR_IA32_MC0_MISC + 4*(x))
 
+#define MSR_AMD64_MCx_MASK(x)		(MSR_AMD64_MC0_MASK + (x))
+
 /* These are consecutive and not in the normal 4er MCE bank block */
 #define MSR_IA32_MC0_CTL2		0x00000280
 #define MSR_IA32_MCx_CTL2(x)		(MSR_IA32_MC0_CTL2 + (x))
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 6757357..7eb1dd7 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -1031,4 +1031,23 @@ unsigned long calc_aperfmperf_ratio(struct aperfmperf *old,
 	return ratio;
 }
 
+/*
+ * AMD errata checking
+ */
+#ifdef CONFIG_CPU_SUP_AMD
+extern const int amd_erratum_400[];
+extern bool cpu_has_amd_erratum(const int *);
+
+#define AMD_LEGACY_ERRATUM(...)		{ -1, __VA_ARGS__, 0 }
+#define AMD_OSVW_ERRATUM(osvw_id, ...)	{ osvw_id, __VA_ARGS__, 0 }
+#define AMD_MODEL_RANGE(f, m_start, s_start, m_end, s_end) \
+	((f << 24) | (m_start << 16) | (s_start << 12) | (m_end << 4) | (s_end))
+#define AMD_MODEL_RANGE_FAMILY(range)	(((range) >> 24) & 0xff)
+#define AMD_MODEL_RANGE_START(range)	(((range) >> 12) & 0xfff)
+#define AMD_MODEL_RANGE_END(range)	((range) & 0xfff)
+
+#else
+#define cpu_has_amd_erratum(x)	(false)
+#endif /* CONFIG_CPU_SUP_AMD */
+
 #endif /* _ASM_X86_PROCESSOR_H */
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index d11629a..b203d0d 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -564,6 +564,29 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 		}
 	}
 #endif
+
+	/* As a rule processors have APIC timer running in deep C states */
+	if (c->x86 >= 0xf && !cpu_has_amd_erratum(amd_erratum_400))
+		set_cpu_cap(c, X86_FEATURE_ARAT);
+
+	/*
+	 * Disable GART TLB Walk Errors on Fam10h. We do this here
+	 * because this is always needed when GART is enabled, even in a
+	 * kernel which has no MCE support built in.
+	 */
+	if (c->x86 == 0x10) {
+		/*
+		 * BIOS should disable GartTlbWlk Errors themself. If
+		 * it doesn't do it here as suggested by the BKDG.
+		 *
+		 * Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=33012
+		 */
+		u64 mask;
+
+		rdmsrl(MSR_AMD64_MCx_MASK(4), mask);
+		mask |= (1 << 10);
+		wrmsrl(MSR_AMD64_MCx_MASK(4), mask);
+	}
 }
 
 #ifdef CONFIG_X86_32
@@ -608,3 +631,68 @@ static const struct cpu_dev __cpuinitconst amd_cpu_dev = {
 };
 
 cpu_dev_register(amd_cpu_dev);
+
+/*
+ * AMD errata checking
+ *
+ * Errata are defined as arrays of ints using the AMD_LEGACY_ERRATUM() or
+ * AMD_OSVW_ERRATUM() macros. The latter is intended for newer errata that
+ * have an OSVW id assigned, which it takes as first argument. Both take a
+ * variable number of family-specific model-stepping ranges created by
+ * AMD_MODEL_RANGE(). Each erratum also has to be declared as extern const
+ * int[] in arch/x86/include/asm/processor.h.
+ *
+ * Example:
+ *
+ * const int amd_erratum_319[] =
+ *	AMD_LEGACY_ERRATUM(AMD_MODEL_RANGE(0x10, 0x2, 0x1, 0x4, 0x2),
+ *			   AMD_MODEL_RANGE(0x10, 0x8, 0x0, 0x8, 0x0),
+ *			   AMD_MODEL_RANGE(0x10, 0x9, 0x0, 0x9, 0x0));
+ */
+
+const int amd_erratum_400[] =
+	AMD_OSVW_ERRATUM(1, AMD_MODEL_RANGE(0xf, 0x41, 0x2, 0xff, 0xf),
+			    AMD_MODEL_RANGE(0x10, 0x2, 0x1, 0xff, 0xf));
+
+
+bool cpu_has_amd_erratum(const int *erratum)
+{
+	struct cpuinfo_x86 *cpu = &current_cpu_data;
+	int osvw_id = *erratum++;
+	u32 range;
+	u32 ms;
+
+	/*
+	 * If called early enough that current_cpu_data hasn't been initialized
+	 * yet, fall back to boot_cpu_data.
+	 */
+	if (cpu->x86 == 0)
+		cpu = &boot_cpu_data;
+
+	if (cpu->x86_vendor != X86_VENDOR_AMD)
+		return false;
+
+	if (osvw_id >= 0 && osvw_id < 65536 &&
+	    cpu_has(cpu, X86_FEATURE_OSVW)) {
+		u64 osvw_len;
+
+		rdmsrl(MSR_AMD64_OSVW_ID_LENGTH, osvw_len);
+		if (osvw_id < osvw_len) {
+			u64 osvw_bits;
+
+			rdmsrl(MSR_AMD64_OSVW_STATUS + (osvw_id >> 6),
+			    osvw_bits);
+			return osvw_bits & (1ULL << (osvw_id & 0x3f));
+		}
+	}
+
+	/* OSVW unavailable or ID unknown, match family-model-stepping range */
+	ms = (cpu->x86_model << 4) | cpu->x86_mask;
+	while ((range = *erratum++))
+		if ((cpu->x86 == AMD_MODEL_RANGE_FAMILY(range)) &&
+		    (ms >= AMD_MODEL_RANGE_START(range)) &&
+		    (ms <= AMD_MODEL_RANGE_END(range)))
+			return true;
+
+	return false;
+}
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 0571b72..11bd5e5 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -518,42 +518,6 @@ static int __cpuinit mwait_usable(const struct cpuinfo_x86 *c)
 	return (edx & MWAIT_EDX_C1);
 }
 
-/*
- * Check for AMD CPUs, where APIC timer interrupt does not wake up CPU from C1e.
- * For more information see
- * - Erratum #400 for NPT family 0xf and family 0x10 CPUs
- * - Erratum #365 for family 0x11 (not affected because C1e not in use)
- */
-static int __cpuinit check_c1e_idle(const struct cpuinfo_x86 *c)
-{
-	u64 val;
-	if (c->x86_vendor != X86_VENDOR_AMD)
-		goto no_c1e_idle;
-
-	/* Family 0x0f models < rev F do not have C1E */
-	if (c->x86 == 0x0F && c->x86_model >= 0x40)
-		return 1;
-
-	if (c->x86 == 0x10) {
-		/*
-		 * check OSVW bit for CPUs that are not affected
-		 * by erratum #400
-		 */
-		if (cpu_has(c, X86_FEATURE_OSVW)) {
-			rdmsrl(MSR_AMD64_OSVW_ID_LENGTH, val);
-			if (val >= 2) {
-				rdmsrl(MSR_AMD64_OSVW_STATUS, val);
-				if (!(val & BIT(1)))
-					goto no_c1e_idle;
-			}
-		}
-		return 1;
-	}
-
-no_c1e_idle:
-	return 0;
-}
-
 static cpumask_var_t c1e_mask;
 static int c1e_detected;
 
@@ -631,7 +595,8 @@ void __cpuinit select_idle_routine(const struct cpuinfo_x86 *c)
 		 */
 		printk(KERN_INFO "using mwait in idle threads.\n");
 		pm_idle = mwait_idle;
-	} else if (check_c1e_idle(c)) {
+	} else if (cpu_has_amd_erratum(amd_erratum_400)) {
+		/* E400: APIC timer interrupt does not wake up CPU from C1e */
 		printk(KERN_INFO "using C1E aware idle routine\n");
 		pm_idle = c1e_idle;
 	} else
diff --git a/arch/x86/lib/semaphore_32.S b/arch/x86/lib/semaphore_32.S
index 648fe47..f35eec7 100644
--- a/arch/x86/lib/semaphore_32.S
+++ b/arch/x86/lib/semaphore_32.S
@@ -36,7 +36,7 @@
  */
 #ifdef CONFIG_SMP
 ENTRY(__write_lock_failed)
-	CFI_STARTPROC simple
+	CFI_STARTPROC
 	FRAME
 2: 	LOCK_PREFIX
 	addl	$ RW_LOCK_BIAS,(%eax)
diff --git a/drivers/media/video/sn9c102/sn9c102_core.c b/drivers/media/video/sn9c102/sn9c102_core.c
index cbf8087..8e86f20 100644
--- a/drivers/media/video/sn9c102/sn9c102_core.c
+++ b/drivers/media/video/sn9c102/sn9c102_core.c
@@ -1430,9 +1430,9 @@ static DEVICE_ATTR(i2c_reg, S_IRUGO | S_IWUSR,
 		   sn9c102_show_i2c_reg, sn9c102_store_i2c_reg);
 static DEVICE_ATTR(i2c_val, S_IRUGO | S_IWUSR,
 		   sn9c102_show_i2c_val, sn9c102_store_i2c_val);
-static DEVICE_ATTR(green, S_IWUGO, NULL, sn9c102_store_green);
-static DEVICE_ATTR(blue, S_IWUGO, NULL, sn9c102_store_blue);
-static DEVICE_ATTR(red, S_IWUGO, NULL, sn9c102_store_red);
+static DEVICE_ATTR(green, S_IWUSR, NULL, sn9c102_store_green);
+static DEVICE_ATTR(blue, S_IWUSR, NULL, sn9c102_store_blue);
+static DEVICE_ATTR(red, S_IWUSR, NULL, sn9c102_store_red);
 static DEVICE_ATTR(frame_header, S_IRUGO, sn9c102_show_frame_header, NULL);
 
 
diff --git a/drivers/net/usb/cdc-phonet.c b/drivers/net/usb/cdc-phonet.c
index 6491c9c..722a9a5 100644
--- a/drivers/net/usb/cdc-phonet.c
+++ b/drivers/net/usb/cdc-phonet.c
@@ -325,13 +325,13 @@ int usbpn_probe(struct usb_interface *intf, const struct usb_device_id *id)
 {
 	static const char ifname[] = "usbpn%d";
 	const struct usb_cdc_union_desc *union_header = NULL;
-	const struct usb_cdc_header_desc *phonet_header = NULL;
 	const struct usb_host_interface *data_desc;
 	struct usb_interface *data_intf;
 	struct usb_device *usbdev = interface_to_usbdev(intf);
 	struct net_device *dev;
 	struct usbpn_dev *pnd;
 	u8 *data;
+	int phonet = 0;
 	int len, err;
 
 	data = intf->altsetting->extra;
@@ -352,10 +352,7 @@ int usbpn_probe(struct usb_interface *intf, const struct usb_device_id *id)
 					(struct usb_cdc_union_desc *)data;
 				break;
 			case 0xAB:
-				if (phonet_header || dlen < 5)
-					break;
-				phonet_header =
-					(struct usb_cdc_header_desc *)data;
+				phonet = 1;
 				break;
 			}
 		}
@@ -363,7 +360,7 @@ int usbpn_probe(struct usb_interface *intf, const struct usb_device_id *id)
 		len -= dlen;
 	}
 
-	if (!union_header || !phonet_header)
+	if (!union_header || !phonet)
 		return -EINVAL;
 
 	data_intf = usb_ifnum_to_if(usbdev, union_header->bSlaveInterface0);
diff --git a/drivers/usb/core/devices.c b/drivers/usb/core/devices.c
index 355dffc..2ce5963 100644
--- a/drivers/usb/core/devices.c
+++ b/drivers/usb/core/devices.c
@@ -211,7 +211,7 @@ static char *usb_dump_endpoint_descriptor(int speed, char *start, char *end,
 		break;
 	case USB_ENDPOINT_XFER_INT:
 		type = "Int.";
-		if (speed == USB_SPEED_HIGH)
+		if (speed == USB_SPEED_HIGH || speed == USB_SPEED_SUPER)
 			interval = 1 << (desc->bInterval - 1);
 		else
 			interval = desc->bInterval;
@@ -219,7 +219,8 @@ static char *usb_dump_endpoint_descriptor(int speed, char *start, char *end,
 	default:	/* "can't happen" */
 		return start;
 	}
-	interval *= (speed == USB_SPEED_HIGH) ? 125 : 1000;
+	interval *= (speed == USB_SPEED_HIGH ||
+		     speed == USB_SPEED_SUPER) ? 125 : 1000;
 	if (interval % 1000)
 		unit = 'u';
 	else {
@@ -529,8 +530,9 @@ static ssize_t usb_device_dump(char __user **buffer, size_t *nbytes,
 	if (level == 0) {
 		int	max;
 
-		/* high speed reserves 80%, full/low reserves 90% */
-		if (usbdev->speed == USB_SPEED_HIGH)
+		/* super/high speed reserves 80%, full/low reserves 90% */
+		if (usbdev->speed == USB_SPEED_HIGH ||
+		    usbdev->speed == USB_SPEED_SUPER)
 			max = 800;
 		else
 			max = FRAME_TIME_MAX_USECS_ALLOC;
diff --git a/drivers/usb/host/ehci-q.c b/drivers/usb/host/ehci-q.c
index d1d4bb1..781c573 100644
--- a/drivers/usb/host/ehci-q.c
+++ b/drivers/usb/host/ehci-q.c
@@ -1246,24 +1246,27 @@ static void start_unlink_async (struct ehci_hcd *ehci, struct ehci_qh *qh)
 
 static void scan_async (struct ehci_hcd *ehci)
 {
+	bool			stopped;
 	struct ehci_qh		*qh;
 	enum ehci_timer_action	action = TIMER_IO_WATCHDOG;
 
 	ehci->stamp = ehci_readl(ehci, &ehci->regs->frame_index);
 	timer_action_done (ehci, TIMER_ASYNC_SHRINK);
 rescan:
+	stopped = !HC_IS_RUNNING(ehci_to_hcd(ehci)->state);
 	qh = ehci->async->qh_next.qh;
 	if (likely (qh != NULL)) {
 		do {
 			/* clean any finished work for this qh */
-			if (!list_empty (&qh->qtd_list)
-					&& qh->stamp != ehci->stamp) {
+			if (!list_empty(&qh->qtd_list) && (stopped ||
+					qh->stamp != ehci->stamp)) {
 				int temp;
 
 				/* unlinks could happen here; completion
 				 * reporting drops the lock.  rescan using
 				 * the latest schedule, but don't rescan
-				 * qhs we already finished (no looping).
+				 * qhs we already finished (no looping)
+				 * unless the controller is stopped.
 				 */
 				qh = qh_get (qh);
 				qh->stamp = ehci->stamp;
@@ -1284,9 +1287,9 @@ rescan:
 			 */
 			if (list_empty(&qh->qtd_list)
 					&& qh->qh_state == QH_STATE_LINKED) {
-				if (!ehci->reclaim
-					&& ((ehci->stamp - qh->stamp) & 0x1fff)
-						>= (EHCI_SHRINK_FRAMES * 8))
+				if (!ehci->reclaim && (stopped ||
+					((ehci->stamp - qh->stamp) & 0x1fff)
+						>= EHCI_SHRINK_FRAMES * 8))
 					start_unlink_async(ehci, qh);
 				else
 					action = TIMER_ASYNC_SHRINK;
diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
index 6c1f673..8d548e2 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -492,6 +492,47 @@ int xhci_setup_addressable_virt_dev(struct xhci_hcd *xhci, struct usb_device *ud
 	return 0;
 }
 
+/*
+ * Convert interval expressed as 2^(bInterval - 1) == interval into
+ * straight exponent value 2^n == interval.
+ *
+ */
+static unsigned int xhci_parse_exponent_interval(struct usb_device *udev,
+		struct usb_host_endpoint *ep)
+{
+	unsigned int interval;
+
+	interval = clamp_val(ep->desc.bInterval, 1, 16) - 1;
+	if (interval != ep->desc.bInterval - 1)
+		dev_warn(&udev->dev,
+			 "ep %#x - rounding interval to %d microframes\n",
+			 ep->desc.bEndpointAddress,
+			 1 << interval);
+
+	return interval;
+}
+
+/*
+ * Convert bInterval expressed in frames (in 1-255 range) to exponent of
+ * microframes, rounded down to nearest power of 2.
+ */
+static unsigned int xhci_parse_frame_interval(struct usb_device *udev,
+		struct usb_host_endpoint *ep)
+{
+	unsigned int interval;
+
+	interval = fls(8 * ep->desc.bInterval) - 1;
+	interval = clamp_val(interval, 3, 10);
+	if ((1 << interval) != 8 * ep->desc.bInterval)
+		dev_warn(&udev->dev,
+			 "ep %#x - rounding interval to %d microframes, ep desc says %d microframes\n",
+			 ep->desc.bEndpointAddress,
+			 1 << interval,
+			 8 * ep->desc.bInterval);
+
+	return interval;
+}
+
 /* Return the polling or NAK interval.
  *
  * The polling interval is expressed in "microframes".  If xHCI's Interval field
@@ -509,40 +550,38 @@ static inline unsigned int xhci_get_endpoint_interval(struct usb_device *udev,
 	case USB_SPEED_HIGH:
 		/* Max NAK rate */
 		if (usb_endpoint_xfer_control(&ep->desc) ||
-				usb_endpoint_xfer_bulk(&ep->desc))
+		    usb_endpoint_xfer_bulk(&ep->desc)) {
 			interval = ep->desc.bInterval;
+			break;
+		}
 		/* Fall through - SS and HS isoc/int have same decoding */
+
 	case USB_SPEED_SUPER:
 		if (usb_endpoint_xfer_int(&ep->desc) ||
-				usb_endpoint_xfer_isoc(&ep->desc)) {
-			if (ep->desc.bInterval == 0)
-				interval = 0;
-			else
-				interval = ep->desc.bInterval - 1;
-			if (interval > 15)
-				interval = 15;
-			if (interval != ep->desc.bInterval + 1)
-				dev_warn(&udev->dev, "ep %#x - rounding interval to %d microframes\n",
-						ep->desc.bEndpointAddress, 1 << interval);
+		    usb_endpoint_xfer_isoc(&ep->desc)) {
+			interval = xhci_parse_exponent_interval(udev, ep);
 		}
 		break;
-	/* Convert bInterval (in 1-255 frames) to microframes and round down to
-	 * nearest power of 2.
-	 */
+
 	case USB_SPEED_FULL:
+		if (usb_endpoint_xfer_int(&ep->desc)) {
+			interval = xhci_parse_exponent_interval(udev, ep);
+			break;
+		}
+		/*
+		 * Fall through for isochronous endpoint interval decoding
+		 * since it uses the same rules as low speed interrupt
+		 * endpoints.
+		 */
+
 	case USB_SPEED_LOW:
 		if (usb_endpoint_xfer_int(&ep->desc) ||
-				usb_endpoint_xfer_isoc(&ep->desc)) {
-			interval = fls(8*ep->desc.bInterval) - 1;
-			if (interval > 10)
-				interval = 10;
-			if (interval < 3)
-				interval = 3;
-			if ((1 << interval) != 8*ep->desc.bInterval)
-				dev_warn(&udev->dev, "ep %#x - rounding interval to %d microframes\n",
-						ep->desc.bEndpointAddress, 1 << interval);
+		    usb_endpoint_xfer_isoc(&ep->desc)) {
+
+			interval = xhci_parse_frame_interval(udev, ep);
 		}
 		break;
+
 	default:
 		BUG();
 	}
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index 9e904a6..4b1abfb 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -232,7 +232,7 @@ struct xhci_op_regs {
  * notification type that matches a bit set in this bit field.
  */
 #define	DEV_NOTE_MASK		(0xffff)
-#define ENABLE_DEV_NOTE(x)	(1 << x)
+#define ENABLE_DEV_NOTE(x)	(1 << (x))
 /* Most of the device notification types should only be used for debug.
  * SW does need to pay attention to function wake notifications.
  */
@@ -579,11 +579,11 @@ struct xhci_ep_ctx {
 #define EP_STATE_STOPPED	3
 #define EP_STATE_ERROR		4
 /* Mult - Max number of burtst within an interval, in EP companion desc. */
-#define EP_MULT(p)		((p & 0x3) << 8)
+#define EP_MULT(p)		(((p) & 0x3) << 8)
 /* bits 10:14 are Max Primary Streams */
 /* bit 15 is Linear Stream Array */
 /* Interval - period between requests to an endpoint - 125u increments. */
-#define EP_INTERVAL(p)		((p & 0xff) << 16)
+#define EP_INTERVAL(p)		(((p) & 0xff) << 16)
 #define EP_INTERVAL_TO_UFRAMES(p)		(1 << (((p) >> 16) & 0xff))
 
 /* ep_info2 bitmasks */
diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 06af705..7ba67e3 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -155,6 +155,8 @@ static struct ftdi_sio_quirk ftdi_stmclite_quirk = {
  * /sys/bus/usb/ftdi_sio/new_id, then send patch/report!
  */
 static struct usb_device_id id_table_combined [] = {
+	{ USB_DEVICE(FTDI_VID, FTDI_CTI_MINI_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_CTI_NANO_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_AMC232_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_CANUSB_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_CANDAPTER_PID) },
@@ -525,6 +527,7 @@ static struct usb_device_id id_table_combined [] = {
 	{ USB_DEVICE(SEALEVEL_VID, SEALEVEL_2803_8_PID) },
 	{ USB_DEVICE(IDTECH_VID, IDTECH_IDT1221U_PID) },
 	{ USB_DEVICE(OCT_VID, OCT_US101_PID) },
+	{ USB_DEVICE(OCT_VID, OCT_DK201_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_HE_TIRA1_PID),
 		.driver_info = (kernel_ulong_t)&ftdi_HE_TIRA1_quirk },
 	{ USB_DEVICE(FTDI_VID, FTDI_USB_UIRT_PID),
@@ -786,6 +789,8 @@ static struct usb_device_id id_table_combined [] = {
 	{ USB_DEVICE(FTDI_VID, MARVELL_OPENRD_PID),
 		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
 	{ USB_DEVICE(FTDI_VID, HAMEG_HO820_PID) },
+	{ USB_DEVICE(FTDI_VID, HAMEG_HO720_PID) },
+	{ USB_DEVICE(FTDI_VID, HAMEG_HO730_PID) },
 	{ USB_DEVICE(FTDI_VID, HAMEG_HO870_PID) },
 	{ USB_DEVICE(FTDI_VID, MJSG_GENERIC_PID) },
 	{ USB_DEVICE(FTDI_VID, MJSG_SR_RADIO_PID) },
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_sio_ids.h
index 2ed7fcf..f3200c4 100644
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -280,6 +280,8 @@
  * Hameg HO820 and HO870 interface (using VID 0x0403)
  */
 #define        HAMEG_HO820_PID         0xed74
+#define HAMEG_HO730_PID			0xed73
+#define HAMEG_HO720_PID			0xed72
 #define        HAMEG_HO870_PID         0xed71
 
 /*
@@ -559,6 +561,7 @@
 /* Note: OCT US101 is also rebadged as Dick Smith Electronics (NZ) XH6381 */
 /* Also rebadged as Dick Smith Electronics (Aus) XH6451 */
 /* Also rebadged as SIIG Inc. model US2308 hardware version 1 */
+#define OCT_DK201_PID		0x0103	/* OCT DK201 USB docking station */
 #define OCT_US101_PID		0x0421	/* OCT US101 USB to RS-232 */
 
 /*
@@ -1093,3 +1096,12 @@
 #define XVERVE_SIGNALYZER_SH2_PID	0xBCA2
 #define XVERVE_SIGNALYZER_SH4_PID	0xBCA4
 
+/*
+ * CTI GmbH RS485 Converter http://www.cti-lean.com/
+ */
+/* USB-485-Mini*/
+#define FTDI_CTI_MINI_PID	0xF608
+/* USB-Nano-485*/
+#define FTDI_CTI_NANO_PID	0xF60B
+
+
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 2e9e09c..623b159 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2554,7 +2554,7 @@ try_mount_again:
 
 remote_path_check:
 	/* check if a whole path (including prepath) is not remote */
-	if (!rc && cifs_sb->prepathlen && tcon) {
+	if (!rc && tcon) {
 		/* build_path_to_root works only when we have a valid tcon */
 		full_path = cifs_build_path_to_root(cifs_sb);
 		if (full_path == NULL) {
diff --git a/fs/proc/base.c b/fs/proc/base.c
index 8dce96c..65053a1 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2872,11 +2872,16 @@ static int proc_pid_fill_cache(struct file *filp, void *dirent, filldir_t filldi
 /* for the /proc/ directory itself, after non-process stuff has been done */
 int proc_pid_readdir(struct file * filp, void * dirent, filldir_t filldir)
 {
-	unsigned int nr = filp->f_pos - FIRST_PROCESS_ENTRY;
-	struct task_struct *reaper = get_proc_task(filp->f_path.dentry->d_inode);
+	unsigned int nr;
+	struct task_struct *reaper;
 	struct tgid_iter iter;
 	struct pid_namespace *ns;
 
+	if (filp->f_pos >= PID_MAX_LIMIT + TGID_OFFSET)
+		goto out_no_task;
+	nr = filp->f_pos - FIRST_PROCESS_ENTRY;
+
+	reaper = get_proc_task(filp->f_path.dentry->d_inode);
 	if (!reaper)
 		goto out_no_task;
 
diff --git a/fs/ramfs/file-nommu.c b/fs/ramfs/file-nommu.c
index 1739a4a..b090327 100644
--- a/fs/ramfs/file-nommu.c
+++ b/fs/ramfs/file-nommu.c
@@ -111,6 +111,7 @@ int ramfs_nommu_expand_for_mapping(struct inode *inode, size_t newsize)
 		SetPageDirty(page);
 
 		unlock_page(page);
+		put_page(page);
 	}
 
 	return 0;
diff --git a/fs/ubifs/debug.c b/fs/ubifs/debug.c
index eef3ed5..6554130 100644
--- a/fs/ubifs/debug.c
+++ b/fs/ubifs/debug.c
@@ -2686,19 +2686,19 @@ int dbg_debugfs_init_fs(struct ubifs_info *c)
 	}
 
 	fname = "dump_lprops";
-	dent = debugfs_create_file(fname, S_IWUGO, d->dfs_dir, c, &dfs_fops);
+	dent = debugfs_create_file(fname, S_IWUSR, d->dfs_dir, c, &dfs_fops);
 	if (IS_ERR(dent))
 		goto out_remove;
 	d->dfs_dump_lprops = dent;
 
 	fname = "dump_budg";
-	dent = debugfs_create_file(fname, S_IWUGO, d->dfs_dir, c, &dfs_fops);
+	dent = debugfs_create_file(fname, S_IWUSR, d->dfs_dir, c, &dfs_fops);
 	if (IS_ERR(dent))
 		goto out_remove;
 	d->dfs_dump_budg = dent;
 
 	fname = "dump_tnc";
-	dent = debugfs_create_file(fname, S_IWUGO, d->dfs_dir, c, &dfs_fops);
+	dent = debugfs_create_file(fname, S_IWUSR, d->dfs_dir, c, &dfs_fops);
 	if (IS_ERR(dent))
 		goto out_remove;
 	d->dfs_dump_tnc = dent;
diff --git a/fs/ubifs/file.c b/fs/ubifs/file.c
index 16a6444..98ae58c 100644
--- a/fs/ubifs/file.c
+++ b/fs/ubifs/file.c
@@ -1311,6 +1311,9 @@ int ubifs_fsync(struct file *file, struct dentry *dentry, int datasync)
 
 	dbg_gen("syncing inode %lu", inode->i_ino);
 
+	if (inode->i_sb->s_flags & MS_RDONLY)
+		return 0;
+
 	/*
 	 * VFS has already synchronized dirty pages for this inode. Synchronize
 	 * the inode unless this is a 'datasync()' call.
diff --git a/include/linux/pid.h b/include/linux/pid.h
index 49f1c2f..ec9f2df 100644
--- a/include/linux/pid.h
+++ b/include/linux/pid.h
@@ -117,7 +117,7 @@ extern struct pid *find_vpid(int nr);
  */
 extern struct pid *find_get_pid(int nr);
 extern struct pid *find_ge_pid(int nr, struct pid_namespace *);
-int next_pidmap(struct pid_namespace *pid_ns, int last);
+int next_pidmap(struct pid_namespace *pid_ns, unsigned int last);
 
 extern struct pid *alloc_pid(struct pid_namespace *ns);
 extern void free_pid(struct pid *pid);
diff --git a/kernel/pid.c b/kernel/pid.c
index 2e17c9c..55b5dc6 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -183,11 +183,14 @@ static int alloc_pidmap(struct pid_namespace *pid_ns)
 	return -1;
 }
 
-int next_pidmap(struct pid_namespace *pid_ns, int last)
+int next_pidmap(struct pid_namespace *pid_ns, unsigned int last)
 {
 	int offset;
 	struct pidmap *map, *end;
 
+	if (last >= PID_MAX_LIMIT)
+		return -1;
+
 	offset = (last + 1) & BITS_PER_PAGE_MASK;
 	map = &pid_ns->pidmap[(last + 1)/BITS_PER_PAGE];
 	end = &pid_ns->pidmap[PIDMAP_ENTRIES];
diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index 2ff5d33..414439b 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -1391,7 +1391,7 @@ static int ax25_getname(struct socket *sock, struct sockaddr *uaddr,
 	ax25_cb *ax25;
 	int err = 0;
 
-	memset(fsa, 0, sizeof(fsa));
+	memset(fsa, 0, sizeof(*fsa));
 	lock_sock(sk);
 	ax25 = ax25_sk(sk);
 
diff --git a/net/rds/rdma.c b/net/rds/rdma.c
index 1fa0f4b..61ab2d2 100644
--- a/net/rds/rdma.c
+++ b/net/rds/rdma.c
@@ -497,6 +497,17 @@ static struct rds_rdma_op *rds_rdma_prepare(struct rds_sock *rs,
 
 		max_pages = max(nr, max_pages);
 		nr_pages += nr;
+
+		/*
+		 * nr for one entry in limited to (UINT_MAX>>PAGE_SHIFT)+1
+		 * so nr_pages cannot overflow without becoming bigger than
+		 * INT_MAX first. If nr cannot overflow then max_pages should
+		 * be ok.
+		 */
+		if (nr_pages > INT_MAX) {
+			ret = -EINVAL;
+			goto out;
+		}
 	}
 
 	pages = kcalloc(max_pages, sizeof(struct page *), GFP_KERNEL);
