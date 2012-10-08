Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708Ab2JHNGY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 09:06:24 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:44171 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750876Ab2JHNGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 09:06:19 -0400
Message-ID: <1349701557.16173.164.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 000/108] 3.2.31-stable review
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Date: Mon, 08 Oct 2012 14:05:57 +0100
In-Reply-To: <20121007225834.673681075@decadent.org.uk>
References: <20121007225834.673681075@decadent.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-4Ae8Y3kX9zhwLFu1Wf8P"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-4Ae8Y3kX9zhwLFu1Wf8P
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

diff --git a/Makefile b/Makefile
index 9fd7e60..a815851 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION =3D 3
 PATCHLEVEL =3D 2
-SUBLEVEL =3D 30
-EXTRAVERSION =3D
+SUBLEVEL =3D 31
+EXTRAVERSION =3D -rc1
 NAME =3D Saber-toothed Squirrel
=20
 # *DOCUMENTATION*
diff --git a/arch/arm/boot/compressed/head.S b/arch/arm/boot/compressed/hea=
d.S
index 9c18ebd..d63632f 100644
--- a/arch/arm/boot/compressed/head.S
+++ b/arch/arm/boot/compressed/head.S
@@ -648,6 +648,7 @@ __armv7_mmu_cache_on:
 		mcrne	p15, 0, r0, c8, c7, 0	@ flush I,D TLBs
 #endif
 		mrc	p15, 0, r0, c1, c0, 0	@ read control reg
+		bic	r0, r0, #1 << 28	@ clear SCTLR.TRE
 		orr	r0, r0, #0x5000		@ I-cache enable, RR cache replacement
 		orr	r0, r0, #0x003c		@ write buffer
 #ifdef CONFIG_MMU
diff --git a/arch/arm/mach-imx/mach-armadillo5x0.c b/arch/arm/mach-imx/mach=
-armadillo5x0.c
index c9a9cf6..4adeb3e 100644
--- a/arch/arm/mach-imx/mach-armadillo5x0.c
+++ b/arch/arm/mach-imx/mach-armadillo5x0.c
@@ -517,7 +517,8 @@ static void __init armadillo5x0_init(void)
 	imx31_add_mxc_nand(&armadillo5x0_nand_board_info);
=20
 	/* set NAND page size to 2k if not configured via boot mode pins */
-	__raw_writel(__raw_readl(MXC_CCM_RCSR) | (1 << 30), MXC_CCM_RCSR);
+	__raw_writel(__raw_readl(mx3_ccm_base + MXC_CCM_RCSR) |
+					(1 << 30), mx3_ccm_base + MXC_CCM_RCSR);
=20
 	/* RTC */
 	/* Get RTC IRQ and register the chip */
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 73ef56c..bda833c 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -160,7 +160,7 @@ static const unsigned char * const k7_nops[ASM_NOP_MAX+=
2] =3D
 #endif
=20
 #ifdef P6_NOP1
-static const unsigned char  __initconst_or_module p6nops[] =3D
+static const unsigned char p6nops[] =3D
 {
 	P6_NOP1,
 	P6_NOP2,
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 44d4393..a1e21ae 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1289,6 +1289,10 @@ asmlinkage void __init xen_start_kernel(void)
=20
 		/* Make sure ACS will be enabled */
 		pci_request_acs();
+
+		/* Avoid searching for BIOS MP tables */
+		x86_init.mpparse.find_smp_config =3D x86_init_noop;
+		x86_init.mpparse.get_smp_config =3D x86_init_uint_noop;
 	}
 #ifdef CONFIG_PCI
 	/* PCI BIOS service won't work from a PV guest. */
diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index bb104b4..6e5a7f1 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -16,6 +16,7 @@
 #include <asm/e820.h>
 #include <asm/setup.h>
 #include <asm/acpi.h>
+#include <asm/numa.h>
 #include <asm/xen/hypervisor.h>
 #include <asm/xen/hypercall.h>
=20
@@ -431,4 +432,7 @@ void __init xen_arch_setup(void)
 	boot_option_idle_override =3D IDLE_HALT;
 	WARN_ON(set_pm_idle_to_default());
 	fiddle_vdso();
+#ifdef CONFIG_NUMA
+	numa_off =3D 1;
+#endif
 }
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index c04ad68..321e23e 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4118,6 +4118,7 @@ static const struct ata_blacklist_entry ata_device_bl=
acklist [] =3D {
=20
 	/* Devices which aren't very happy with higher link speeds */
 	{ "WD My Book",			NULL,	ATA_HORKAGE_1_5_GBPS, },
+	{ "Seagate FreeAgent GoFlex",	NULL,	ATA_HORKAGE_1_5_GBPS, },
=20
 	/*
 	 * Devices which choke on SETXFER.  Applies only if both the
diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
index de0435e..887f68f 100644
--- a/drivers/block/aoe/aoecmd.c
+++ b/drivers/block/aoe/aoecmd.c
@@ -35,6 +35,7 @@ new_skb(ulong len)
 		skb_reset_mac_header(skb);
 		skb_reset_network_header(skb);
 		skb->protocol =3D __constant_htons(ETH_P_AOE);
+		skb_checksum_none_assert(skb);
 	}
 	return skb;
 }
diff --git a/drivers/block/cciss_scsi.c b/drivers/block/cciss_scsi.c
index 38aa6dd..da33111 100644
--- a/drivers/block/cciss_scsi.c
+++ b/drivers/block/cciss_scsi.c
@@ -795,6 +795,7 @@ static void complete_scsi_command(CommandList_struct *c=
, int timeout,
 				}
 			break;
 			case CMD_PROTOCOL_ERR:
+				cmd->result =3D DID_ERROR << 16;
 				dev_warn(&h->pdev->dev,
 					"%p has protocol error\n", c);
                         break;
diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index c3f0ee1..86848c6 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -445,6 +445,14 @@ static void nbd_clear_que(struct nbd_device *lo)
 		req->errors++;
 		nbd_end_request(req);
 	}
+
+	while (!list_empty(&lo->waiting_queue)) {
+		req =3D list_entry(lo->waiting_queue.next, struct request,
+				 queuelist);
+		list_del_init(&req->queuelist);
+		req->errors++;
+		nbd_end_request(req);
+	}
 }
=20
=20
@@ -594,6 +602,7 @@ static int __nbd_ioctl(struct block_device *bdev, struc=
t nbd_device *lo,
 		lo->file =3D NULL;
 		nbd_clear_que(lo);
 		BUG_ON(!list_empty(&lo->queue_head));
+		BUG_ON(!list_empty(&lo->waiting_queue));
 		if (file)
 			fput(file);
 		return 0;
diff --git a/drivers/bluetooth/ath3k.c b/drivers/bluetooth/ath3k.c
index f1bd44f..5c6709d 100644
--- a/drivers/bluetooth/ath3k.c
+++ b/drivers/bluetooth/ath3k.c
@@ -62,6 +62,7 @@ static struct usb_device_id ath3k_table[] =3D {
=20
 	/* Atheros AR3011 with sflash firmware*/
 	{ USB_DEVICE(0x0CF3, 0x3002) },
+	{ USB_DEVICE(0x0CF3, 0xE019) },
 	{ USB_DEVICE(0x13d3, 0x3304) },
 	{ USB_DEVICE(0x0930, 0x0215) },
 	{ USB_DEVICE(0x0489, 0xE03D) },
@@ -76,12 +77,15 @@ static struct usb_device_id ath3k_table[] =3D {
 	{ USB_DEVICE(0x04CA, 0x3005) },
 	{ USB_DEVICE(0x13d3, 0x3362) },
 	{ USB_DEVICE(0x0CF3, 0xE004) },
+	{ USB_DEVICE(0x0930, 0x0219) },
+	{ USB_DEVICE(0x0489, 0xe057) },
=20
 	/* Atheros AR5BBU12 with sflash firmware */
 	{ USB_DEVICE(0x0489, 0xE02C) },
=20
 	/* Atheros AR5BBU22 with sflash firmware */
 	{ USB_DEVICE(0x0489, 0xE03C) },
+	{ USB_DEVICE(0x0489, 0xE036) },
=20
 	{ }	/* Terminating entry */
 };
@@ -100,9 +104,12 @@ static struct usb_device_id ath3k_blist_tbl[] =3D {
 	{ USB_DEVICE(0x04ca, 0x3005), .driver_info =3D BTUSB_ATH3012 },
 	{ USB_DEVICE(0x13d3, 0x3362), .driver_info =3D BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0cf3, 0xe004), .driver_info =3D BTUSB_ATH3012 },
+	{ USB_DEVICE(0x0930, 0x0219), .driver_info =3D BTUSB_ATH3012 },
+	{ USB_DEVICE(0x0489, 0xe057), .driver_info =3D BTUSB_ATH3012 },
=20
 	/* Atheros AR5BBU22 with sflash firmware */
 	{ USB_DEVICE(0x0489, 0xE03C), .driver_info =3D BTUSB_ATH3012 },
+	{ USB_DEVICE(0x0489, 0xE036), .driver_info =3D BTUSB_ATH3012 },
=20
 	{ }	/* Terminating entry */
 };
diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index fc4bcd6..6f95d98 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -60,6 +60,9 @@ static struct usb_device_id btusb_table[] =3D {
 	/* Generic Bluetooth USB device */
 	{ USB_DEVICE_INFO(0xe0, 0x01, 0x01) },
=20
+	/* Apple-specific (Broadcom) devices */
+	{ USB_VENDOR_AND_INTERFACE_INFO(0x05ac, 0xff, 0x01, 0x01) },
+
 	/* Broadcom SoftSailing reporting vendor specific */
 	{ USB_DEVICE(0x0a5c, 0x21e1) },
=20
@@ -102,15 +105,14 @@ static struct usb_device_id btusb_table[] =3D {
=20
 	/* Broadcom BCM20702A0 */
 	{ USB_DEVICE(0x0489, 0xe042) },
-	{ USB_DEVICE(0x0a5c, 0x21e3) },
-	{ USB_DEVICE(0x0a5c, 0x21e6) },
-	{ USB_DEVICE(0x0a5c, 0x21e8) },
-	{ USB_DEVICE(0x0a5c, 0x21f3) },
 	{ USB_DEVICE(0x413c, 0x8197) },
=20
 	/* Foxconn - Hon Hai */
 	{ USB_DEVICE(0x0489, 0xe033) },
=20
+	/*Broadcom devices with vendor specific id */
+	{ USB_VENDOR_AND_INTERFACE_INFO(0x0a5c, 0xff, 0x01, 0x01) },
+
 	{ }	/* Terminating entry */
 };
=20
@@ -125,6 +127,7 @@ static struct usb_device_id blacklist_table[] =3D {
=20
 	/* Atheros 3011 with sflash firmware */
 	{ USB_DEVICE(0x0cf3, 0x3002), .driver_info =3D BTUSB_IGNORE },
+	{ USB_DEVICE(0x0cf3, 0xe019), .driver_info =3D BTUSB_IGNORE },
 	{ USB_DEVICE(0x13d3, 0x3304), .driver_info =3D BTUSB_IGNORE },
 	{ USB_DEVICE(0x0930, 0x0215), .driver_info =3D BTUSB_IGNORE },
 	{ USB_DEVICE(0x0489, 0xe03d), .driver_info =3D BTUSB_IGNORE },
@@ -139,12 +142,15 @@ static struct usb_device_id blacklist_table[] =3D {
 	{ USB_DEVICE(0x04ca, 0x3005), .driver_info =3D BTUSB_ATH3012 },
 	{ USB_DEVICE(0x13d3, 0x3362), .driver_info =3D BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0cf3, 0xe004), .driver_info =3D BTUSB_ATH3012 },
+	{ USB_DEVICE(0x0930, 0x0219), .driver_info =3D BTUSB_ATH3012 },
+	{ USB_DEVICE(0x0489, 0xe057), .driver_info =3D BTUSB_ATH3012 },
=20
 	/* Atheros AR5BBU12 with sflash firmware */
 	{ USB_DEVICE(0x0489, 0xe02c), .driver_info =3D BTUSB_IGNORE },
=20
 	/* Atheros AR5BBU12 with sflash firmware */
 	{ USB_DEVICE(0x0489, 0xe03c), .driver_info =3D BTUSB_ATH3012 },
+	{ USB_DEVICE(0x0489, 0xe036), .driver_info =3D BTUSB_ATH3012 },
=20
 	/* Broadcom BCM2035 */
 	{ USB_DEVICE(0x0a5c, 0x2035), .driver_info =3D BTUSB_WRONG_SCO_MTU },
diff --git a/drivers/cpufreq/powernow-k8.c b/drivers/cpufreq/powernow-k8.c
index ad683ec..b7fe343 100644
--- a/drivers/cpufreq/powernow-k8.c
+++ b/drivers/cpufreq/powernow-k8.c
@@ -32,7 +32,6 @@
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/cpumask.h>
-#include <linux/sched.h>	/* for current / set_cpus_allowed() */
 #include <linux/io.h>
 #include <linux/delay.h>
=20
@@ -1132,16 +1131,23 @@ static int transition_frequency_pstate(struct power=
now_k8_data *data,
 	return res;
 }
=20
-/* Driver entry point to switch to the target frequency */
-static int powernowk8_target(struct cpufreq_policy *pol,
-		unsigned targfreq, unsigned relation)
+struct powernowk8_target_arg {
+	struct cpufreq_policy		*pol;
+	unsigned			targfreq;
+	unsigned			relation;
+};
+
+static long powernowk8_target_fn(void *arg)
 {
-	cpumask_var_t oldmask;
+	struct powernowk8_target_arg *pta =3D arg;
+	struct cpufreq_policy *pol =3D pta->pol;
+	unsigned targfreq =3D pta->targfreq;
+	unsigned relation =3D pta->relation;
 	struct powernow_k8_data *data =3D per_cpu(powernow_data, pol->cpu);
 	u32 checkfid;
 	u32 checkvid;
 	unsigned int newstate;
-	int ret =3D -EIO;
+	int ret;
=20
 	if (!data)
 		return -EINVAL;
@@ -1149,29 +1155,16 @@ static int powernowk8_target(struct cpufreq_policy =
*pol,
 	checkfid =3D data->currfid;
 	checkvid =3D data->currvid;
=20
-	/* only run on specific CPU from here on. */
-	/* This is poor form: use a workqueue or smp_call_function_single */
-	if (!alloc_cpumask_var(&oldmask, GFP_KERNEL))
-		return -ENOMEM;
-
-	cpumask_copy(oldmask, tsk_cpus_allowed(current));
-	set_cpus_allowed_ptr(current, cpumask_of(pol->cpu));
-
-	if (smp_processor_id() !=3D pol->cpu) {
-		printk(KERN_ERR PFX "limiting to cpu %u failed\n", pol->cpu);
-		goto err_out;
-	}
-
 	if (pending_bit_stuck()) {
 		printk(KERN_ERR PFX "failing targ, change pending bit set\n");
-		goto err_out;
+		return -EIO;
 	}
=20
 	pr_debug("targ: cpu %d, %d kHz, min %d, max %d, relation %d\n",
 		pol->cpu, targfreq, pol->min, pol->max, relation);
=20
 	if (query_current_values_with_pending_wait(data))
-		goto err_out;
+		return -EIO;
=20
 	if (cpu_family !=3D CPU_HW_PSTATE) {
 		pr_debug("targ: curr fid 0x%x, vid 0x%x\n",
@@ -1189,7 +1182,7 @@ static int powernowk8_target(struct cpufreq_policy *p=
ol,
=20
 	if (cpufreq_frequency_table_target(pol, data->powernow_table,
 				targfreq, relation, &newstate))
-		goto err_out;
+		return -EIO;
=20
 	mutex_lock(&fidvid_mutex);
=20
@@ -1202,9 +1195,8 @@ static int powernowk8_target(struct cpufreq_policy *p=
ol,
 		ret =3D transition_frequency_fidvid(data, newstate);
 	if (ret) {
 		printk(KERN_ERR PFX "transition frequency failed\n");
-		ret =3D 1;
 		mutex_unlock(&fidvid_mutex);
-		goto err_out;
+		return 1;
 	}
 	mutex_unlock(&fidvid_mutex);
=20
@@ -1213,12 +1205,25 @@ static int powernowk8_target(struct cpufreq_policy =
*pol,
 				data->powernow_table[newstate].index);
 	else
 		pol->cur =3D find_khz_freq_from_fid(data->currfid);
-	ret =3D 0;
=20
-err_out:
-	set_cpus_allowed_ptr(current, oldmask);
-	free_cpumask_var(oldmask);
-	return ret;
+	return 0;
+}
+
+/* Driver entry point to switch to the target frequency */
+static int powernowk8_target(struct cpufreq_policy *pol,
+		unsigned targfreq, unsigned relation)
+{
+	struct powernowk8_target_arg pta =3D { .pol =3D pol, .targfreq =3D targfr=
eq,
+					     .relation =3D relation };
+
+	/*
+	 * Must run on @pol->cpu.  cpufreq core is responsible for ensuring
+	 * that we're bound to the current CPU and pol->cpu stays online.
+	 */
+	if (smp_processor_id() =3D=3D pol->cpu)
+		return powernowk8_target_fn(&pta);
+	else
+		return work_on_cpu(pol->cpu, powernowk8_target_fn, &pta);
 }
=20
 /* Driver entry point to verify the policy and range of frequencies */
diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index 79dcf6e..c60d9c1 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -678,7 +678,7 @@ atc_prep_slave_sg(struct dma_chan *chan, struct scatter=
list *sgl,
 			flags);
=20
 	if (unlikely(!atslave || !sg_len)) {
-		dev_dbg(chan2dev(chan), "prep_dma_memcpy: length is zero!\n");
+		dev_dbg(chan2dev(chan), "prep_slave_sg: sg length is zero!\n");
 		return NULL;
 	}
=20
@@ -706,6 +706,11 @@ atc_prep_slave_sg(struct dma_chan *chan, struct scatte=
rlist *sgl,
=20
 			mem =3D sg_dma_address(sg);
 			len =3D sg_dma_len(sg);
+			if (unlikely(!len)) {
+				dev_dbg(chan2dev(chan),
+					"prep_slave_sg: sg(%d) data length is zero\n", i);
+				goto err;
+			}
 			mem_width =3D 2;
 			if (unlikely(mem & 3 || len & 3))
 				mem_width =3D 0;
@@ -740,6 +745,11 @@ atc_prep_slave_sg(struct dma_chan *chan, struct scatte=
rlist *sgl,
=20
 			mem =3D sg_dma_address(sg);
 			len =3D sg_dma_len(sg);
+			if (unlikely(!len)) {
+				dev_dbg(chan2dev(chan),
+					"prep_slave_sg: sg(%d) data length is zero\n", i);
+				goto err;
+			}
 			mem_width =3D 2;
 			if (unlikely(mem & 3 || len & 3))
 				mem_width =3D 0;
@@ -773,6 +783,7 @@ atc_prep_slave_sg(struct dma_chan *chan, struct scatter=
list *sgl,
=20
 err_desc_get:
 	dev_err(chan2dev(chan), "not enough descriptors available\n");
+err:
 	atc_desc_put(atchan, first);
 	return NULL;
 }
diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index 57104147..e8eedb7 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -858,6 +858,11 @@ pl330_probe(struct amba_device *adev, const struct amb=
a_id *id)
 	/* Initialize channel parameters */
 	num_chan =3D max(pdat ? pdat->nr_valid_peri : 0, (u8)pi->pcfg.num_chan);
 	pdmac->peripherals =3D kzalloc(num_chan * sizeof(*pch), GFP_KERNEL);
+	if (!pdmac->peripherals) {
+		ret =3D -ENOMEM;
+		dev_err(&adev->dev, "unable to allocate pdmac->peripherals\n");
+		goto probe_err4;
+	}
=20
 	for (i =3D 0; i < num_chan; i++) {
 		pch =3D &pdmac->peripherals[i];
diff --git a/drivers/edac/sb_edac.c b/drivers/edac/sb_edac.c
index 0db57b5..da71881 100644
--- a/drivers/edac/sb_edac.c
+++ b/drivers/edac/sb_edac.c
@@ -554,7 +554,8 @@ static int get_dimm_config(const struct mem_ctl_info *m=
ci)
 {
 	struct sbridge_pvt *pvt =3D mci->pvt_info;
 	struct csrow_info *csr;
-	int i, j, banks, ranks, rows, cols, size, npages;
+	unsigned i, j, banks, ranks, rows, cols, npages;
+	u64 size;
 	int csrow =3D 0;
 	unsigned long last_page =3D 0;
 	u32 reg;
@@ -626,10 +627,10 @@ static int get_dimm_config(const struct mem_ctl_info =
*mci)
 				cols =3D numcol(mtr);
=20
 				/* DDR3 has 8 I/O banks */
-				size =3D (rows * cols * banks * ranks) >> (20 - 3);
+				size =3D ((u64)rows * cols * banks * ranks) >> (20 - 3);
 				npages =3D MiB_TO_PAGES(size);
=20
-				debugf0("mc#%d: channel %d, dimm %d, %d Mb (%d pages) bank: %d, rank: =
%d, row: %#x, col: %#x\n",
+				debugf0("mc#%d: channel %d, dimm %d, %Ld Mb (%d pages) bank: %d, rank:=
 %d, row: %#x, col: %#x\n",
 					pvt->sbridge_dev->mc, i, j,
 					size, npages,
 					banks, ranks, rows, cols);
diff --git a/drivers/gpio/gpio-lpc32xx.c b/drivers/gpio/gpio-lpc32xx.c
index 5b69480..2c40776 100644
--- a/drivers/gpio/gpio-lpc32xx.c
+++ b/drivers/gpio/gpio-lpc32xx.c
@@ -295,6 +295,7 @@ static int lpc32xx_gpio_dir_output_p012(struct gpio_chi=
p *chip, unsigned pin,
 {
 	struct lpc32xx_gpio_chip *group =3D to_lpc32xx_gpio(chip);
=20
+	__set_gpio_level_p012(group, pin, value);
 	__set_gpio_dir_p012(group, pin, 0);
=20
 	return 0;
@@ -305,6 +306,7 @@ static int lpc32xx_gpio_dir_output_p3(struct gpio_chip =
*chip, unsigned pin,
 {
 	struct lpc32xx_gpio_chip *group =3D to_lpc32xx_gpio(chip);
=20
+	__set_gpio_level_p3(group, pin, value);
 	__set_gpio_dir_p3(group, pin, 0);
=20
 	return 0;
@@ -313,6 +315,9 @@ static int lpc32xx_gpio_dir_output_p3(struct gpio_chip =
*chip, unsigned pin,
 static int lpc32xx_gpio_dir_out_always(struct gpio_chip *chip, unsigned pi=
n,
 	int value)
 {
+	struct lpc32xx_gpio_chip *group =3D to_lpc32xx_gpio(chip);
+
+	__set_gpo_level_p3(group, pin, value);
 	return 0;
 }
=20
diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_ge=
m.c
index 548a400..e48e01e 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -3357,7 +3357,8 @@ i915_gem_object_pin(struct drm_i915_gem_object *obj,
 	struct drm_i915_private *dev_priv =3D dev->dev_private;
 	int ret;
=20
-	BUG_ON(obj->pin_count =3D=3D DRM_I915_GEM_OBJECT_MAX_PIN_COUNT);
+	if (WARN_ON(obj->pin_count =3D=3D DRM_I915_GEM_OBJECT_MAX_PIN_COUNT))
+		return -EBUSY;
 	WARN_ON(i915_verify_lists(dev));
=20
 	if (obj->gtt_space !=3D NULL) {
diff --git a/drivers/gpu/drm/i915/intel_hdmi.c b/drivers/gpu/drm/i915/intel=
_hdmi.c
index 9cd81ba..c2a64f4 100644
--- a/drivers/gpu/drm/i915/intel_hdmi.c
+++ b/drivers/gpu/drm/i915/intel_hdmi.c
@@ -271,7 +271,7 @@ static void intel_hdmi_dpms(struct drm_encoder *encoder=
, int mode)
 	u32 temp;
 	u32 enable_bits =3D SDVO_ENABLE;
=20
-	if (intel_hdmi->has_audio)
+	if (intel_hdmi->has_audio || mode !=3D DRM_MODE_DPMS_ON)
 		enable_bits |=3D SDVO_AUDIO_ENABLE;
=20
 	temp =3D I915_READ(intel_hdmi->sdvox_reg);
diff --git a/drivers/gpu/drm/radeon/atombios_crtc.c b/drivers/gpu/drm/radeo=
n/atombios_crtc.c
index ceffd20..a4011b0 100644
--- a/drivers/gpu/drm/radeon/atombios_crtc.c
+++ b/drivers/gpu/drm/radeon/atombios_crtc.c
@@ -1446,98 +1446,14 @@ static void radeon_legacy_atom_fixup(struct drm_crt=
c *crtc)
 	}
 }
=20
-/**
- * radeon_get_pll_use_mask - look up a mask of which pplls are in use
- *
- * @crtc: drm crtc
- *
- * Returns the mask of which PPLLs (Pixel PLLs) are in use.
- */
-static u32 radeon_get_pll_use_mask(struct drm_crtc *crtc)
-{
-	struct drm_device *dev =3D crtc->dev;
-	struct drm_crtc *test_crtc;
-	struct radeon_crtc *radeon_test_crtc;
-	u32 pll_in_use =3D 0;
-
-	list_for_each_entry(test_crtc, &dev->mode_config.crtc_list, head) {
-		if (crtc =3D=3D test_crtc)
-			continue;
-
-		radeon_test_crtc =3D to_radeon_crtc(test_crtc);
-		if (radeon_test_crtc->pll_id !=3D ATOM_PPLL_INVALID)
-			pll_in_use |=3D (1 << radeon_test_crtc->pll_id);
-	}
-	return pll_in_use;
-}
-
-/**
- * radeon_get_shared_dp_ppll - return the PPLL used by another crtc for DP
- *
- * @crtc: drm crtc
- *
- * Returns the PPLL (Pixel PLL) used by another crtc/encoder which is
- * also in DP mode.  For DP, a single PPLL can be used for all DP
- * crtcs/encoders.
- */
-static int radeon_get_shared_dp_ppll(struct drm_crtc *crtc)
-{
-	struct drm_device *dev =3D crtc->dev;
-	struct drm_encoder *test_encoder;
-	struct radeon_crtc *radeon_test_crtc;
-
-	list_for_each_entry(test_encoder, &dev->mode_config.encoder_list, head) {
-		if (test_encoder->crtc && (test_encoder->crtc !=3D crtc)) {
-			if (ENCODER_MODE_IS_DP(atombios_get_encoder_mode(test_encoder))) {
-				/* for DP use the same PLL for all */
-				radeon_test_crtc =3D to_radeon_crtc(test_encoder->crtc);
-				if (radeon_test_crtc->pll_id !=3D ATOM_PPLL_INVALID)
-					return radeon_test_crtc->pll_id;
-			}
-		}
-	}
-	return ATOM_PPLL_INVALID;
-}
-
-/**
- * radeon_atom_pick_pll - Allocate a PPLL for use by the crtc.
- *
- * @crtc: drm crtc
- *
- * Returns the PPLL (Pixel PLL) to be used by the crtc.  For DP monitors
- * a single PPLL can be used for all DP crtcs/encoders.  For non-DP
- * monitors a dedicated PPLL must be used.  If a particular board has
- * an external DP PLL, return ATOM_PPLL_INVALID to skip PLL programming
- * as there is no need to program the PLL itself.  If we are not able to
- * allocate a PLL, return ATOM_PPLL_INVALID to skip PLL programming to
- * avoid messing up an existing monitor.
- *
- * Asic specific PLL information
- *
- * DCE 6.1
- * - PPLL2 is only available to UNIPHYA (both DP and non-DP)
- * - PPLL0, PPLL1 are available for UNIPHYB/C/D/E/F (both DP and non-DP)
- *
- * DCE 6.0
- * - PPLL0 is available to all UNIPHY (DP only)
- * - PPLL1, PPLL2 are available for all UNIPHY (both DP and non-DP) and DA=
C
- *
- * DCE 5.0
- * - DCPLL is available to all UNIPHY (DP only)
- * - PPLL1, PPLL2 are available for all UNIPHY (both DP and non-DP) and DA=
C
- *
- * DCE 3.0/4.0/4.1
- * - PPLL1, PPLL2 are available for all UNIPHY (both DP and non-DP) and DA=
C
- *
- */
 static int radeon_atom_pick_pll(struct drm_crtc *crtc)
 {
 	struct radeon_crtc *radeon_crtc =3D to_radeon_crtc(crtc);
 	struct drm_device *dev =3D crtc->dev;
 	struct radeon_device *rdev =3D dev->dev_private;
 	struct drm_encoder *test_encoder;
-	u32 pll_in_use;
-	int pll;
+	struct drm_crtc *test_crtc;
+	uint32_t pll_in_use =3D 0;
=20
 	if (ASIC_IS_DCE4(rdev)) {
 		list_for_each_entry(test_encoder, &dev->mode_config.encoder_list, head) =
{
@@ -1545,7 +1461,7 @@ static int radeon_atom_pick_pll(struct drm_crtc *crtc=
)
 				/* in DP mode, the DP ref clock can come from PPLL, DCPLL, or ext cloc=
k,
 				 * depending on the asic:
 				 * DCE4: PPLL or ext clock
-				 * DCE5: PPLL, DCPLL, or ext clock
+				 * DCE5: DCPLL or ext clock
 				 *
 				 * Setting ATOM_PPLL_INVALID will cause SetPixelClock to skip
 				 * PPLL/DCPLL programming and only program the DP DTO for the
@@ -1553,31 +1469,29 @@ static int radeon_atom_pick_pll(struct drm_crtc *cr=
tc)
 				 */
 				if (ENCODER_MODE_IS_DP(atombios_get_encoder_mode(test_encoder))) {
 					if (rdev->clock.dp_extclk)
-						/* skip PPLL programming if using ext clock */
 						return ATOM_PPLL_INVALID;
 					else if (ASIC_IS_DCE5(rdev))
-						/* use DCPLL for all DP */
 						return ATOM_DCPLL;
-					else {
-						/* use the same PPLL for all DP monitors */
-						pll =3D radeon_get_shared_dp_ppll(crtc);
-						if (pll !=3D ATOM_PPLL_INVALID)
-							return pll;
-					}
 				}
-				break;
 			}
 		}
-		/* all other cases */
-		pll_in_use =3D radeon_get_pll_use_mask(crtc);
-		if (!(pll_in_use & (1 << ATOM_PPLL2)))
-			return ATOM_PPLL2;
-		if (!(pll_in_use & (1 << ATOM_PPLL1)))
+
+		/* otherwise, pick one of the plls */
+		list_for_each_entry(test_crtc, &dev->mode_config.crtc_list, head) {
+			struct radeon_crtc *radeon_test_crtc;
+
+			if (crtc =3D=3D test_crtc)
+				continue;
+
+			radeon_test_crtc =3D to_radeon_crtc(test_crtc);
+			if ((radeon_test_crtc->pll_id >=3D ATOM_PPLL1) &&
+			    (radeon_test_crtc->pll_id <=3D ATOM_PPLL2))
+				pll_in_use |=3D (1 << radeon_test_crtc->pll_id);
+		}
+		if (!(pll_in_use & 1))
 			return ATOM_PPLL1;
-		DRM_ERROR("unable to allocate a PPLL\n");
-		return ATOM_PPLL_INVALID;
+		return ATOM_PPLL2;
 	} else
-		/* use PPLL1 or PPLL2 */
 		return radeon_crtc->crtc_id;
=20
 }
@@ -1696,7 +1610,7 @@ static void atombios_crtc_disable(struct drm_crtc *cr=
tc)
 		break;
 	}
 done:
-	radeon_crtc->pll_id =3D ATOM_PPLL_INVALID;
+	radeon_crtc->pll_id =3D -1;
 }
=20
 static const struct drm_crtc_helper_funcs atombios_helper_funcs =3D {
@@ -1745,6 +1659,6 @@ void radeon_atombios_init_crtc(struct drm_device *dev=
,
 		else
 			radeon_crtc->crtc_offset =3D 0;
 	}
-	radeon_crtc->pll_id =3D ATOM_PPLL_INVALID;
+	radeon_crtc->pll_id =3D -1;
 	drm_crtc_helper_add(&radeon_crtc->base, &atombios_helper_funcs);
 }
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 0c8bea9..a21e763 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1026,7 +1026,7 @@ static struct hid_report *hid_get_report(struct hid_r=
eport_enum *report_enum,
 	return report;
 }
=20
-void hid_report_raw_event(struct hid_device *hid, int type, u8 *data, int =
size,
+int hid_report_raw_event(struct hid_device *hid, int type, u8 *data, int s=
ize,
 		int interrupt)
 {
 	struct hid_report_enum *report_enum =3D hid->report_enum + type;
@@ -1034,10 +1034,11 @@ void hid_report_raw_event(struct hid_device *hid, i=
nt type, u8 *data, int size,
 	unsigned int a;
 	int rsize, csize =3D size;
 	u8 *cdata =3D data;
+	int ret =3D 0;
=20
 	report =3D hid_get_report(report_enum, data);
 	if (!report)
-		return;
+		goto out;
=20
 	if (report_enum->numbered) {
 		cdata++;
@@ -1057,14 +1058,19 @@ void hid_report_raw_event(struct hid_device *hid, i=
nt type, u8 *data, int size,
=20
 	if ((hid->claimed & HID_CLAIMED_HIDDEV) && hid->hiddev_report_event)
 		hid->hiddev_report_event(hid, report);
-	if (hid->claimed & HID_CLAIMED_HIDRAW)
-		hidraw_report_event(hid, data, size);
+	if (hid->claimed & HID_CLAIMED_HIDRAW) {
+		ret =3D hidraw_report_event(hid, data, size);
+		if (ret)
+			goto out;
+	}
=20
 	for (a =3D 0; a < report->maxfield; a++)
 		hid_input_field(hid, report->field[a], cdata, interrupt);
=20
 	if (hid->claimed & HID_CLAIMED_INPUT)
 		hidinput_report_event(hid, report);
+out:
+	return ret;
 }
 EXPORT_SYMBOL_GPL(hid_report_raw_event);
=20
@@ -1141,7 +1147,7 @@ nomem:
 		}
 	}
=20
-	hid_report_raw_event(hid, type, data, size, interrupt);
+	ret =3D hid_report_raw_event(hid, type, data, size, interrupt);
=20
 unlock:
 	up(&hid->driver_lock);
diff --git a/drivers/hid/hid-logitech-dj.c b/drivers/hid/hid-logitech-dj.c
index 2eac8c5..8821ecc 100644
--- a/drivers/hid/hid-logitech-dj.c
+++ b/drivers/hid/hid-logitech-dj.c
@@ -185,6 +185,7 @@ static struct hid_ll_driver logi_dj_ll_driver;
 static int logi_dj_output_hidraw_report(struct hid_device *hid, u8 * buf,
 					size_t count,
 					unsigned char report_type);
+static int logi_dj_recv_query_paired_devices(struct dj_receiver_dev *djrcv=
_dev);
=20
 static void logi_dj_recv_destroy_djhid_device(struct dj_receiver_dev *djrc=
v_dev,
 						struct dj_report *dj_report)
@@ -225,6 +226,7 @@ static void logi_dj_recv_add_djhid_device(struct dj_rec=
eiver_dev *djrcv_dev,
 	if (dj_report->report_params[DEVICE_PAIRED_PARAM_SPFUNCTION] &
 	    SPFUNCTION_DEVICE_LIST_EMPTY) {
 		dbg_hid("%s: device list is empty\n", __func__);
+		djrcv_dev->querying_devices =3D false;
 		return;
 	}
=20
@@ -235,6 +237,12 @@ static void logi_dj_recv_add_djhid_device(struct dj_re=
ceiver_dev *djrcv_dev,
 		return;
 	}
=20
+	if (djrcv_dev->paired_dj_devices[dj_report->device_index]) {
+		/* The device is already known. No need to reallocate it. */
+		dbg_hid("%s: device is already known\n", __func__);
+		return;
+	}
+
 	dj_hiddev =3D hid_allocate_device();
 	if (IS_ERR(dj_hiddev)) {
 		dev_err(&djrcv_hdev->dev, "%s: hid_allocate_device failed\n",
@@ -298,6 +306,7 @@ static void delayedwork_callback(struct work_struct *wo=
rk)
 	struct dj_report dj_report;
 	unsigned long flags;
 	int count;
+	int retval;
=20
 	dbg_hid("%s\n", __func__);
=20
@@ -330,6 +339,25 @@ static void delayedwork_callback(struct work_struct *w=
ork)
 		logi_dj_recv_destroy_djhid_device(djrcv_dev, &dj_report);
 		break;
 	default:
+	/* A normal report (i. e. not belonging to a pair/unpair notification)
+	 * arriving here, means that the report arrived but we did not have a
+	 * paired dj_device associated to the report's device_index, this
+	 * means that the original "device paired" notification corresponding
+	 * to this dj_device never arrived to this driver. The reason is that
+	 * hid-core discards all packets coming from a device while probe() is
+	 * executing. */
+	if (!djrcv_dev->paired_dj_devices[dj_report.device_index]) {
+		/* ok, we don't know the device, just re-ask the
+		 * receiver for the list of connected devices. */
+		retval =3D logi_dj_recv_query_paired_devices(djrcv_dev);
+		if (!retval) {
+			/* everything went fine, so just leave */
+			break;
+		}
+		dev_err(&djrcv_dev->hdev->dev,
+			"%s:logi_dj_recv_query_paired_devices "
+			"error:%d\n", __func__, retval);
+		}
 		dbg_hid("%s: unexpected report type\n", __func__);
 	}
 }
@@ -360,6 +388,12 @@ static void logi_dj_recv_forward_null_report(struct dj=
_receiver_dev *djrcv_dev,
 	if (!djdev) {
 		dbg_hid("djrcv_dev->paired_dj_devices[dj_report->device_index]"
 			" is NULL, index %d\n", dj_report->device_index);
+		kfifo_in(&djrcv_dev->notif_fifo, dj_report, sizeof(struct dj_report));
+
+		if (schedule_work(&djrcv_dev->work) =3D=3D 0) {
+			dbg_hid("%s: did not schedule the work item, was already "
+			"queued\n", __func__);
+		}
 		return;
 	}
=20
@@ -390,6 +424,12 @@ static void logi_dj_recv_forward_report(struct dj_rece=
iver_dev *djrcv_dev,
 	if (dj_device =3D=3D NULL) {
 		dbg_hid("djrcv_dev->paired_dj_devices[dj_report->device_index]"
 			" is NULL, index %d\n", dj_report->device_index);
+		kfifo_in(&djrcv_dev->notif_fifo, dj_report, sizeof(struct dj_report));
+
+		if (schedule_work(&djrcv_dev->work) =3D=3D 0) {
+			dbg_hid("%s: did not schedule the work item, was already "
+			"queued\n", __func__);
+		}
 		return;
 	}
=20
@@ -428,27 +468,42 @@ static int logi_dj_recv_send_report(struct dj_receive=
r_dev *djrcv_dev,
=20
 static int logi_dj_recv_query_paired_devices(struct dj_receiver_dev *djrcv=
_dev)
 {
-	struct dj_report dj_report;
+	struct dj_report *dj_report;
+	int retval;
+
+	/* no need to protect djrcv_dev->querying_devices */
+	if (djrcv_dev->querying_devices)
+		return 0;
=20
-	memset(&dj_report, 0, sizeof(dj_report));
-	dj_report.report_id =3D REPORT_ID_DJ_SHORT;
-	dj_report.device_index =3D 0xFF;
-	dj_report.report_type =3D REPORT_TYPE_CMD_GET_PAIRED_DEVICES;
-	return logi_dj_recv_send_report(djrcv_dev, &dj_report);
+	dj_report =3D kzalloc(sizeof(struct dj_report), GFP_KERNEL);
+	if (!dj_report)
+		return -ENOMEM;
+	dj_report->report_id =3D REPORT_ID_DJ_SHORT;
+	dj_report->device_index =3D 0xFF;
+	dj_report->report_type =3D REPORT_TYPE_CMD_GET_PAIRED_DEVICES;
+	retval =3D logi_dj_recv_send_report(djrcv_dev, dj_report);
+	kfree(dj_report);
+	return retval;
 }
=20
+
 static int logi_dj_recv_switch_to_dj_mode(struct dj_receiver_dev *djrcv_de=
v,
 					  unsigned timeout)
 {
-	struct dj_report dj_report;
+	struct dj_report *dj_report;
+	int retval;
=20
-	memset(&dj_report, 0, sizeof(dj_report));
-	dj_report.report_id =3D REPORT_ID_DJ_SHORT;
-	dj_report.device_index =3D 0xFF;
-	dj_report.report_type =3D REPORT_TYPE_CMD_SWITCH;
-	dj_report.report_params[CMD_SWITCH_PARAM_DEVBITFIELD] =3D 0x1F;
-	dj_report.report_params[CMD_SWITCH_PARAM_TIMEOUT_SECONDS] =3D (u8)timeout=
;
-	return logi_dj_recv_send_report(djrcv_dev, &dj_report);
+	dj_report =3D kzalloc(sizeof(struct dj_report), GFP_KERNEL);
+	if (!dj_report)
+		return -ENOMEM;
+	dj_report->report_id =3D REPORT_ID_DJ_SHORT;
+	dj_report->device_index =3D 0xFF;
+	dj_report->report_type =3D REPORT_TYPE_CMD_SWITCH;
+	dj_report->report_params[CMD_SWITCH_PARAM_DEVBITFIELD] =3D 0x3F;
+	dj_report->report_params[CMD_SWITCH_PARAM_TIMEOUT_SECONDS] =3D (u8)timeou=
t;
+	retval =3D logi_dj_recv_send_report(djrcv_dev, dj_report);
+	kfree(dj_report);
+	return retval;
 }
=20
=20
diff --git a/drivers/hid/hid-logitech-dj.h b/drivers/hid/hid-logitech-dj.h
index fd28a5e..4a40003 100644
--- a/drivers/hid/hid-logitech-dj.h
+++ b/drivers/hid/hid-logitech-dj.h
@@ -101,6 +101,7 @@ struct dj_receiver_dev {
 	struct work_struct work;
 	struct kfifo notif_fifo;
 	spinlock_t lock;
+	bool querying_devices;
 };
=20
 struct dj_device {
diff --git a/drivers/hid/hidraw.c b/drivers/hid/hidraw.c
index cf7d6d5..17d15bb 100644
--- a/drivers/hid/hidraw.c
+++ b/drivers/hid/hidraw.c
@@ -42,6 +42,7 @@ static struct cdev hidraw_cdev;
 static struct class *hidraw_class;
 static struct hidraw *hidraw_table[HIDRAW_MAX_DEVICES];
 static DEFINE_MUTEX(minors_lock);
+static void drop_ref(struct hidraw *hid, int exists_bit);
=20
 static ssize_t hidraw_read(struct file *file, char __user *buffer, size_t =
count, loff_t *ppos)
 {
@@ -87,13 +88,16 @@ static ssize_t hidraw_read(struct file *file, char __us=
er *buffer, size_t count,
 		len =3D list->buffer[list->tail].len > count ?
 			count : list->buffer[list->tail].len;
=20
-		if (copy_to_user(buffer, list->buffer[list->tail].value, len)) {
-			ret =3D -EFAULT;
-			goto out;
+		if (list->buffer[list->tail].value) {
+			if (copy_to_user(buffer, list->buffer[list->tail].value, len)) {
+				ret =3D -EFAULT;
+				goto out;
+			}
+			ret =3D len;
 		}
-		ret =3D len;
=20
 		kfree(list->buffer[list->tail].value);
+		list->buffer[list->tail].value =3D NULL;
 		list->tail =3D (list->tail + 1) & (HIDRAW_BUFFER_SIZE - 1);
 	}
 out:
@@ -110,7 +114,7 @@ static ssize_t hidraw_send_report(struct file *file, co=
nst char __user *buffer,
 	__u8 *buf;
 	int ret =3D 0;
=20
-	if (!hidraw_table[minor]) {
+	if (!hidraw_table[minor] || !hidraw_table[minor]->exist) {
 		ret =3D -ENODEV;
 		goto out;
 	}
@@ -258,7 +262,7 @@ static int hidraw_open(struct inode *inode, struct file=
 *file)
 	}
=20
 	mutex_lock(&minors_lock);
-	if (!hidraw_table[minor]) {
+	if (!hidraw_table[minor] || !hidraw_table[minor]->exist) {
 		err =3D -ENODEV;
 		goto out_unlock;
 	}
@@ -295,32 +299,12 @@ out:
 static int hidraw_release(struct inode * inode, struct file * file)
 {
 	unsigned int minor =3D iminor(inode);
-	struct hidraw *dev;
 	struct hidraw_list *list =3D file->private_data;
-	int ret;
-
-	mutex_lock(&minors_lock);
-	if (!hidraw_table[minor]) {
-		ret =3D -ENODEV;
-		goto unlock;
-	}
=20
+	drop_ref(hidraw_table[minor], 0);
 	list_del(&list->node);
-	dev =3D hidraw_table[minor];
-	if (!--dev->open) {
-		if (list->hidraw->exist) {
-			hid_hw_power(dev->hid, PM_HINT_NORMAL);
-			hid_hw_close(dev->hid);
-		} else {
-			kfree(list->hidraw);
-		}
-	}
 	kfree(list);
-	ret =3D 0;
-unlock:
-	mutex_unlock(&minors_lock);
-
-	return ret;
+	return 0;
 }
=20
 static long hidraw_ioctl(struct file *file, unsigned int cmd,
@@ -437,19 +421,29 @@ static const struct file_operations hidraw_ops =3D {
 	.llseek =3D	noop_llseek,
 };
=20
-void hidraw_report_event(struct hid_device *hid, u8 *data, int len)
+int hidraw_report_event(struct hid_device *hid, u8 *data, int len)
 {
 	struct hidraw *dev =3D hid->hidraw;
 	struct hidraw_list *list;
+	int ret =3D 0;
=20
 	list_for_each_entry(list, &dev->list, node) {
-		list->buffer[list->head].value =3D kmemdup(data, len, GFP_ATOMIC);
+		int new_head =3D (list->head + 1) & (HIDRAW_BUFFER_SIZE - 1);
+
+		if (new_head =3D=3D list->tail)
+			continue;
+
+		if (!(list->buffer[list->head].value =3D kmemdup(data, len, GFP_ATOMIC))=
) {
+			ret =3D -ENOMEM;
+			break;
+		}
 		list->buffer[list->head].len =3D len;
-		list->head =3D (list->head + 1) & (HIDRAW_BUFFER_SIZE - 1);
+		list->head =3D new_head;
 		kill_fasync(&list->fasync, SIGIO, POLL_IN);
 	}
=20
 	wake_up_interruptible(&dev->wait);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(hidraw_report_event);
=20
@@ -512,21 +506,7 @@ EXPORT_SYMBOL_GPL(hidraw_connect);
 void hidraw_disconnect(struct hid_device *hid)
 {
 	struct hidraw *hidraw =3D hid->hidraw;
-
-	mutex_lock(&minors_lock);
-	hidraw->exist =3D 0;
-
-	device_destroy(hidraw_class, MKDEV(hidraw_major, hidraw->minor));
-
-	hidraw_table[hidraw->minor] =3D NULL;
-
-	if (hidraw->open) {
-		hid_hw_close(hid);
-		wake_up_interruptible(&hidraw->wait);
-	} else {
-		kfree(hidraw);
-	}
-	mutex_unlock(&minors_lock);
+	drop_ref(hidraw, 1);
 }
 EXPORT_SYMBOL_GPL(hidraw_disconnect);
=20
@@ -542,21 +522,28 @@ int __init hidraw_init(void)
=20
 	if (result < 0) {
 		pr_warn("can't get major number\n");
-		result =3D 0;
 		goto out;
 	}
=20
 	hidraw_class =3D class_create(THIS_MODULE, "hidraw");
 	if (IS_ERR(hidraw_class)) {
 		result =3D PTR_ERR(hidraw_class);
-		unregister_chrdev(hidraw_major, "hidraw");
-		goto out;
+		goto error_cdev;
 	}
=20
         cdev_init(&hidraw_cdev, &hidraw_ops);
-        cdev_add(&hidraw_cdev, dev_id, HIDRAW_MAX_DEVICES);
+	result =3D cdev_add(&hidraw_cdev, dev_id, HIDRAW_MAX_DEVICES);
+	if (result < 0)
+		goto error_class;
+
 out:
 	return result;
+
+error_class:
+	class_destroy(hidraw_class);
+error_cdev:
+	unregister_chrdev_region(dev_id, HIDRAW_MAX_DEVICES);
+	goto out;
 }
=20
 void hidraw_exit(void)
@@ -568,3 +555,23 @@ void hidraw_exit(void)
 	unregister_chrdev_region(dev_id, HIDRAW_MAX_DEVICES);
=20
 }
+
+static void drop_ref(struct hidraw *hidraw, int exists_bit)
+{
+	mutex_lock(&minors_lock);
+	if (exists_bit) {
+		hid_hw_close(hidraw->hid);
+		hidraw->exist =3D 0;
+		if (hidraw->open)
+			wake_up_interruptible(&hidraw->wait);
+	} else {
+		--hidraw->open;
+	}
+
+	if (!hidraw->open && !hidraw->exist) {
+		device_destroy(hidraw_class, MKDEV(hidraw_major, hidraw->minor));
+		hidraw_table[hidraw->minor] =3D NULL;
+		kfree(hidraw);
+	}
+	mutex_unlock(&minors_lock);
+}
diff --git a/drivers/hwmon/ad7314.c b/drivers/hwmon/ad7314.c
index 5d760f3..08e2947 100644
--- a/drivers/hwmon/ad7314.c
+++ b/drivers/hwmon/ad7314.c
@@ -96,10 +96,18 @@ static ssize_t ad7314_show_temperature(struct device *d=
ev,
 	}
 }
=20
+static ssize_t ad7314_show_name(struct device *dev,
+				struct device_attribute *devattr, char *buf)
+{
+	return sprintf(buf, "%s\n", to_spi_device(dev)->modalias);
+}
+
+static DEVICE_ATTR(name, S_IRUGO, ad7314_show_name, NULL);
 static SENSOR_DEVICE_ATTR(temp1_input, S_IRUGO,
 			  ad7314_show_temperature, NULL, 0);
=20
 static struct attribute *ad7314_attributes[] =3D {
+	&dev_attr_name.attr,
 	&sensor_dev_attr_temp1_input.dev_attr.attr,
 	NULL,
 };
diff --git a/drivers/hwmon/ads7871.c b/drivers/hwmon/ads7871.c
index 04450f8..685aae6 100644
--- a/drivers/hwmon/ads7871.c
+++ b/drivers/hwmon/ads7871.c
@@ -133,6 +133,12 @@ static ssize_t show_voltage(struct device *dev,
 	}
 }
=20
+static ssize_t ads7871_show_name(struct device *dev,
+				 struct device_attribute *devattr, char *buf)
+{
+	return sprintf(buf, "%s\n", to_spi_device(dev)->modalias);
+}
+
 static SENSOR_DEVICE_ATTR(in0_input, S_IRUGO, show_voltage, NULL, 0);
 static SENSOR_DEVICE_ATTR(in1_input, S_IRUGO, show_voltage, NULL, 1);
 static SENSOR_DEVICE_ATTR(in2_input, S_IRUGO, show_voltage, NULL, 2);
@@ -142,6 +148,8 @@ static SENSOR_DEVICE_ATTR(in5_input, S_IRUGO, show_volt=
age, NULL, 5);
 static SENSOR_DEVICE_ATTR(in6_input, S_IRUGO, show_voltage, NULL, 6);
 static SENSOR_DEVICE_ATTR(in7_input, S_IRUGO, show_voltage, NULL, 7);
=20
+static DEVICE_ATTR(name, S_IRUGO, ads7871_show_name, NULL);
+
 static struct attribute *ads7871_attributes[] =3D {
 	&sensor_dev_attr_in0_input.dev_attr.attr,
 	&sensor_dev_attr_in1_input.dev_attr.attr,
@@ -151,6 +159,7 @@ static struct attribute *ads7871_attributes[] =3D {
 	&sensor_dev_attr_in5_input.dev_attr.attr,
 	&sensor_dev_attr_in6_input.dev_attr.attr,
 	&sensor_dev_attr_in7_input.dev_attr.attr,
+	&dev_attr_name.attr,
 	NULL
 };
=20
diff --git a/drivers/hwmon/fam15h_power.c b/drivers/hwmon/fam15h_power.c
index e8e18ca..ac2d6cb 100644
--- a/drivers/hwmon/fam15h_power.c
+++ b/drivers/hwmon/fam15h_power.c
@@ -128,12 +128,12 @@ static bool __devinit fam15h_power_is_internal_node0(=
struct pci_dev *f4)
  * counter saturations resulting in bogus power readings.
  * We correct this value ourselves to cope with older BIOSes.
  */
-static DEFINE_PCI_DEVICE_TABLE(affected_device) =3D {
+static const struct pci_device_id affected_device[] =3D {
 	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_15H_NB_F4) },
 	{ 0 }
 };
=20
-static void __devinit tweak_runavg_range(struct pci_dev *pdev)
+static void tweak_runavg_range(struct pci_dev *pdev)
 {
 	u32 val;
=20
@@ -157,6 +157,16 @@ static void __devinit tweak_runavg_range(struct pci_de=
v *pdev)
 		REG_TDP_RUNNING_AVERAGE, val);
 }
=20
+#ifdef CONFIG_PM
+static int fam15h_power_resume(struct pci_dev *pdev)
+{
+	tweak_runavg_range(pdev);
+	return 0;
+}
+#else
+#define fam15h_power_resume NULL
+#endif
+
 static void __devinit fam15h_power_init_data(struct pci_dev *f4,
 					     struct fam15h_power_data *data)
 {
@@ -255,6 +265,7 @@ static struct pci_driver fam15h_power_driver =3D {
 	.id_table =3D fam15h_power_id_table,
 	.probe =3D fam15h_power_probe,
 	.remove =3D __devexit_p(fam15h_power_remove),
+	.resume =3D fam15h_power_resume,
 };
=20
 static int __init fam15h_power_init(void)
diff --git a/drivers/input/serio/i8042-x86ia64io.h b/drivers/input/serio/i8=
042-x86ia64io.h
index d4ec371..cd1a843 100644
--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -335,6 +335,12 @@ static const struct dmi_system_id __initconst i8042_dm=
i_nomux_table[] =3D {
 	},
 	{
 		.matches =3D {
+			DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "SATELLITE C850D"),
+		},
+	},
+	{
+		.matches =3D {
 			DMI_MATCH(DMI_SYS_VENDOR, "ALIENWARE"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "Sentia"),
 		},
diff --git a/drivers/iommu/intr_remapping.c b/drivers/iommu/intr_remapping.=
c
index 6777ca0..73ca321 100644
--- a/drivers/iommu/intr_remapping.c
+++ b/drivers/iommu/intr_remapping.c
@@ -752,6 +752,7 @@ int __init parse_ioapics_under_ir(void)
 {
 	struct dmar_drhd_unit *drhd;
 	int ir_supported =3D 0;
+	int ioapic_idx;
=20
 	for_each_drhd_unit(drhd) {
 		struct intel_iommu *iommu =3D drhd->iommu;
@@ -764,13 +765,20 @@ int __init parse_ioapics_under_ir(void)
 		}
 	}
=20
-	if (ir_supported && ir_ioapic_num !=3D nr_ioapics) {
-		printk(KERN_WARNING
-		       "Not all IO-APIC's listed under remapping hardware\n");
-		return -1;
+	if (!ir_supported)
+		return 0;
+
+	for (ioapic_idx =3D 0; ioapic_idx < nr_ioapics; ioapic_idx++) {
+		int ioapic_id =3D mpc_ioapic_id(ioapic_idx);
+		if (!map_ioapic_to_ir(ioapic_id)) {
+			pr_err(FW_BUG "ioapic %d has no mapping iommu, "
+			       "interrupt remapping will be disabled\n",
+			       ioapic_id);
+			return -1;
+		}
 	}
=20
-	return ir_supported;
+	return 1;
 }
=20
 int __init ir_dev_scope_init(void)
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 8e91321..52848ab 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1350,17 +1350,25 @@ static int device_is_nonrot(struct dm_target *ti, s=
truct dm_dev *dev,
 	return q && blk_queue_nonrot(q);
 }
=20
-static bool dm_table_is_nonrot(struct dm_table *t)
+static int device_is_not_random(struct dm_target *ti, struct dm_dev *dev,
+			     sector_t start, sector_t len, void *data)
+{
+	struct request_queue *q =3D bdev_get_queue(dev->bdev);
+
+	return q && !blk_queue_add_random(q);
+}
+
+static bool dm_table_all_devices_attribute(struct dm_table *t,
+					   iterate_devices_callout_fn func)
 {
 	struct dm_target *ti;
 	unsigned i =3D 0;
=20
-	/* Ensure that all underlying device are non-rotational. */
 	while (i < dm_table_get_num_targets(t)) {
 		ti =3D dm_table_get_target(t, i++);
=20
 		if (!ti->type->iterate_devices ||
-		    !ti->type->iterate_devices(ti, device_is_nonrot, NULL))
+		    !ti->type->iterate_devices(ti, func, NULL))
 			return 0;
 	}
=20
@@ -1392,7 +1400,8 @@ void dm_table_set_restrictions(struct dm_table *t, st=
ruct request_queue *q,
 	if (!dm_table_discard_zeroes_data(t))
 		q->limits.discard_zeroes_data =3D 0;
=20
-	if (dm_table_is_nonrot(t))
+	/* Ensure that all underlying devices are non-rotational. */
+	if (dm_table_all_devices_attribute(t, device_is_nonrot))
 		queue_flag_set_unlocked(QUEUE_FLAG_NONROT, q);
 	else
 		queue_flag_clear_unlocked(QUEUE_FLAG_NONROT, q);
@@ -1400,6 +1409,15 @@ void dm_table_set_restrictions(struct dm_table *t, s=
truct request_queue *q,
 	dm_table_set_integrity(t);
=20
 	/*
+	 * Determine whether or not this queue's I/O timings contribute
+	 * to the entropy pool, Only request-based targets use this.
+	 * Clear QUEUE_FLAG_ADD_RANDOM if any underlying device does not
+	 * have it set.
+	 */
+	if (blk_queue_add_random(q) && dm_table_all_devices_attribute(t, device_i=
s_not_random))
+		queue_flag_clear_unlocked(QUEUE_FLAG_ADD_RANDOM, q);
+
+	/*
 	 * QUEUE_FLAG_STACKABLE must be set after all queue settings are
 	 * visible to other CPUs because, once the flag is set, incoming bios
 	 * are processed by request-based dm, which refers to the queue
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 4720f68..502dcf7 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -866,10 +866,14 @@ static void dm_done(struct request *clone, int error,=
 bool mapped)
 {
 	int r =3D error;
 	struct dm_rq_target_io *tio =3D clone->end_io_data;
-	dm_request_endio_fn rq_end_io =3D tio->ti->type->rq_end_io;
+	dm_request_endio_fn rq_end_io =3D NULL;
=20
-	if (mapped && rq_end_io)
-		r =3D rq_end_io(tio->ti, clone, error, &tio->info);
+	if (tio->ti) {
+		rq_end_io =3D tio->ti->type->rq_end_io;
+
+		if (mapped && rq_end_io)
+			r =3D rq_end_io(tio->ti, clone, error, &tio->info);
+	}
=20
 	if (r <=3D 0)
 		/* The target wants to complete the I/O */
@@ -1566,15 +1570,6 @@ static int map_request(struct dm_target *ti, struct =
request *clone,
 	int r, requeued =3D 0;
 	struct dm_rq_target_io *tio =3D clone->end_io_data;
=20
-	/*
-	 * Hold the md reference here for the in-flight I/O.
-	 * We can't rely on the reference count by device opener,
-	 * because the device may be closed during the request completion
-	 * when all bios are completed.
-	 * See the comment in rq_completed() too.
-	 */
-	dm_get(md);
-
 	tio->ti =3D ti;
 	r =3D ti->type->map_rq(ti, clone, &tio->info);
 	switch (r) {
@@ -1606,6 +1601,26 @@ static int map_request(struct dm_target *ti, struct =
request *clone,
 	return requeued;
 }
=20
+static struct request *dm_start_request(struct mapped_device *md, struct r=
equest *orig)
+{
+	struct request *clone;
+
+	blk_start_request(orig);
+	clone =3D orig->special;
+	atomic_inc(&md->pending[rq_data_dir(clone)]);
+
+	/*
+	 * Hold the md reference here for the in-flight I/O.
+	 * We can't rely on the reference count by device opener,
+	 * because the device may be closed during the request completion
+	 * when all bios are completed.
+	 * See the comment in rq_completed() too.
+	 */
+	dm_get(md);
+
+	return clone;
+}
+
 /*
  * q->request_fn for request-based dm.
  * Called with the queue lock held.
@@ -1635,14 +1650,21 @@ static void dm_request_fn(struct request_queue *q)
 			pos =3D blk_rq_pos(rq);
=20
 		ti =3D dm_table_find_target(map, pos);
-		BUG_ON(!dm_target_is_valid(ti));
+		if (!dm_target_is_valid(ti)) {
+			/*
+			 * Must perform setup, that dm_done() requires,
+			 * before calling dm_kill_unmapped_request
+			 */
+			DMERR_LIMIT("request attempted access beyond the end of device");
+			clone =3D dm_start_request(md, rq);
+			dm_kill_unmapped_request(clone, -EIO);
+			continue;
+		}
=20
 		if (ti->type->busy && ti->type->busy(ti))
 			goto delay_and_out;
=20
-		blk_start_request(rq);
-		clone =3D rq->special;
-		atomic_inc(&md->pending[rq_data_dir(clone)]);
+		clone =3D dm_start_request(md, rq);
=20
 		spin_unlock(q->queue_lock);
 		if (map_request(ti, clone, md))
@@ -1662,8 +1684,6 @@ delay_and_out:
 	blk_delay_queue(q, HZ / 10);
 out:
 	dm_table_put(map);
-
-	return;
 }
=20
 int dm_underlying_device_busy(struct request_queue *q)
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 7a9eef6..0634ee5 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1226,14 +1226,16 @@ static int enough(struct r10conf *conf, int ignore)
 	do {
 		int n =3D conf->copies;
 		int cnt =3D 0;
+		int this =3D first;
 		while (n--) {
-			if (conf->mirrors[first].rdev &&
-			    first !=3D ignore)
+			if (conf->mirrors[this].rdev &&
+			    this !=3D ignore)
 				cnt++;
-			first =3D (first+1) % conf->raid_disks;
+			this =3D (this+1) % conf->raid_disks;
 		}
 		if (cnt =3D=3D 0)
 			return 0;
+		first =3D (first + conf->near_copies) % conf->raid_disks;
 	} while (first !=3D 0);
 	return 1;
 }
diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 6ce32a7..aaeaff2 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -2712,8 +2712,9 @@ int sdhci_add_host(struct sdhci_host *host)
 	    mmc_card_is_removable(mmc))
 		mmc->caps |=3D MMC_CAP_NEEDS_POLL;
=20
-	/* UHS-I mode(s) supported by the host controller. */
-	if (host->version >=3D SDHCI_SPEC_300)
+	/* Any UHS-I mode in caps implies SDR12 and SDR25 support. */
+	if (caps[1] & (SDHCI_SUPPORT_SDR104 | SDHCI_SUPPORT_SDR50 |
+		       SDHCI_SUPPORT_DDR50))
 		mmc->caps |=3D MMC_CAP_UHS_SDR12 | MMC_CAP_UHS_SDR25;
=20
 	/* SDR104 supports also implies SDR50 support */
diff --git a/drivers/net/can/janz-ican3.c b/drivers/net/can/janz-ican3.c
index 32778d5..46194bc 100644
--- a/drivers/net/can/janz-ican3.c
+++ b/drivers/net/can/janz-ican3.c
@@ -1250,7 +1250,6 @@ static irqreturn_t ican3_irq(int irq, void *dev_id)
  */
 static int ican3_reset_module(struct ican3_dev *mod)
 {
-	u8 val =3D 1 << mod->num;
 	unsigned long start;
 	u8 runold, runnew;
=20
@@ -1264,8 +1263,7 @@ static int ican3_reset_module(struct ican3_dev *mod)
 	runold =3D ioread8(mod->dpm + TARGET_RUNNING);
=20
 	/* reset the module */
-	iowrite8(val, &mod->ctrl->reset_assert);
-	iowrite8(val, &mod->ctrl->reset_deassert);
+	iowrite8(0x00, &mod->dpmctrl->hwreset);
=20
 	/* wait until the module has finished resetting and is running */
 	start =3D jiffies;
diff --git a/drivers/net/can/ti_hecc.c b/drivers/net/can/ti_hecc.c
index 2adc294..79c70ae 100644
--- a/drivers/net/can/ti_hecc.c
+++ b/drivers/net/can/ti_hecc.c
@@ -971,12 +971,12 @@ static int __devexit ti_hecc_remove(struct platform_d=
evice *pdev)
 	struct net_device *ndev =3D platform_get_drvdata(pdev);
 	struct ti_hecc_priv *priv =3D netdev_priv(ndev);
=20
+	unregister_candev(ndev);
 	clk_disable(priv->clk);
 	clk_put(priv->clk);
 	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	iounmap(priv->base);
 	release_mem_region(res->start, resource_size(res));
-	unregister_candev(ndev);
 	free_candev(ndev);
 	platform_set_drvdata(pdev, NULL);
=20
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c b/drivers/net/=
ethernet/broadcom/bnx2x/bnx2x_cmn.c
index 2c1a5c0..4c50ac0 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -554,14 +554,16 @@ static inline void bnx2x_set_skb_rxhash(struct bnx2x =
*bp, union eth_rx_cqe *cqe,
 static void bnx2x_csum_validate(struct sk_buff *skb, union eth_rx_cqe *cqe=
,
 				struct bnx2x_fastpath *fp)
 {
-	/* Do nothing if no IP/L4 csum validation was done */
-
+	/* Do nothing if no L4 csum validation was done.
+	 * We do not check whether IP csum was validated. For IPv4 we assume
+	 * that if the card got as far as validating the L4 csum, it also
+	 * validated the IP csum. IPv6 has no IP csum.
+	 */
 	if (cqe->fast_path_cqe.status_flags &
-	    (ETH_FAST_PATH_RX_CQE_IP_XSUM_NO_VALIDATION_FLG |
-	     ETH_FAST_PATH_RX_CQE_L4_XSUM_NO_VALIDATION_FLG))
+	    ETH_FAST_PATH_RX_CQE_L4_XSUM_NO_VALIDATION_FLG)
 		return;
=20
-	/* If both IP/L4 validation were done, check if an error was found. */
+	/* If L4 validation was done, check if an error was found. */
=20
 	if (cqe->fast_path_cqe.type_error_flags &
 	    (ETH_FAST_PATH_RX_CQE_IP_BAD_XSUM_FLG |
diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/bro=
adcom/tg3.c
index 6b258d9..01bc102 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -14013,9 +14013,13 @@ static int __devinit tg3_get_invariants(struct tg3=
 *tp)
 	if (tg3_flag(tp, HW_TSO_1) ||
 	    tg3_flag(tp, HW_TSO_2) ||
 	    tg3_flag(tp, HW_TSO_3) ||
-	    (tp->fw_needed && !tg3_flag(tp, ENABLE_ASF)))
+	    tp->fw_needed) {
+		/* For firmware TSO, assume ASF is disabled.
+		 * We'll disable TSO later if we discover ASF
+		 * is enabled in tg3_get_eeprom_hw_cfg().
+		 */
 		tg3_flag_set(tp, TSO_CAPABLE);
-	else {
+	} else {
 		tg3_flag_clear(tp, TSO_CAPABLE);
 		tg3_flag_clear(tp, TSO_BUG);
 		tp->fw_needed =3D NULL;
@@ -14290,6 +14294,12 @@ static int __devinit tg3_get_invariants(struct tg3=
 *tp)
 	 */
 	tg3_get_eeprom_hw_cfg(tp);
=20
+	if (tp->fw_needed && tg3_flag(tp, ENABLE_ASF)) {
+		tg3_flag_clear(tp, TSO_CAPABLE);
+		tg3_flag_clear(tp, TSO_BUG);
+		tp->fw_needed =3D NULL;
+	}
+
 	if (tg3_flag(tp, ENABLE_APE)) {
 		/* Allow reads and writes to the
 		 * APE register and memory space.
diff --git a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c b/drivers=
/net/ethernet/qlogic/netxen/netxen_nic_main.c
index 8cf3173..da5204d 100644
--- a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
+++ b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
@@ -1351,6 +1351,10 @@ static void netxen_mask_aer_correctable(struct netxe=
n_adapter *adapter)
 	struct pci_dev *root =3D pdev->bus->self;
 	u32 aer_pos;
=20
+	/* root bus? */
+	if (!root)
+		return;
+
 	if (adapter->ahw.board_type !=3D NETXEN_BRDTYPE_P3_4_GB_MM &&
 		adapter->ahw.board_type !=3D NETXEN_BRDTYPE_P3_10G_TP)
 		return;
diff --git a/drivers/net/ethernet/ti/davinci_cpdma.c b/drivers/net/ethernet=
/ti/davinci_cpdma.c
index c97d2f5..bfc3b0d 100644
--- a/drivers/net/ethernet/ti/davinci_cpdma.c
+++ b/drivers/net/ethernet/ti/davinci_cpdma.c
@@ -851,6 +851,7 @@ int cpdma_chan_stop(struct cpdma_chan *chan)
=20
 		next_dma =3D desc_read(desc, hw_next);
 		chan->head =3D desc_from_phys(pool, next_dma);
+		chan->count--;
 		chan->stats.teardown_dequeue++;
=20
 		/* issue callback without locks held */
diff --git a/drivers/net/ppp/pppoe.c b/drivers/net/ppp/pppoe.c
index bc9a4bb..1161584 100644
--- a/drivers/net/ppp/pppoe.c
+++ b/drivers/net/ppp/pppoe.c
@@ -576,7 +576,7 @@ static int pppoe_release(struct socket *sock)
=20
 	po =3D pppox_sk(sk);
=20
-	if (sk->sk_state & (PPPOX_CONNECTED | PPPOX_BOUND)) {
+	if (sk->sk_state & (PPPOX_CONNECTED | PPPOX_BOUND | PPPOX_ZOMBIE)) {
 		dev_put(po->pppoe_dev);
 		po->pppoe_dev =3D NULL;
 	}
diff --git a/drivers/net/usb/asix.c b/drivers/net/usb/asix.c
index fc147a5..6729585 100644
--- a/drivers/net/usb/asix.c
+++ b/drivers/net/usb/asix.c
@@ -1648,6 +1648,10 @@ static const struct usb_device_id	products [] =3D {
 	USB_DEVICE (0x2001, 0x3c05),
 	.driver_info =3D (unsigned long) &ax88772_info,
 }, {
+       // DLink DUB-E100 H/W Ver C1
+       USB_DEVICE (0x2001, 0x1a02),
+       .driver_info =3D (unsigned long) &ax88772_info,
+}, {
 	// Linksys USB1000
 	USB_DEVICE (0x1737, 0x0039),
 	.driver_info =3D (unsigned long) &ax88178_info,
diff --git a/drivers/net/usb/sierra_net.c b/drivers/net/usb/sierra_net.c
index 864448b..e773250 100644
--- a/drivers/net/usb/sierra_net.c
+++ b/drivers/net/usb/sierra_net.c
@@ -678,7 +678,7 @@ static int sierra_net_get_fw_attr(struct usbnet *dev, u=
16 *datap)
 		return -EIO;
 	}
=20
-	*datap =3D *attrdata;
+	*datap =3D le16_to_cpu(*attrdata);
=20
 	kfree(attrdata);
 	return result;
diff --git a/drivers/net/wan/ixp4xx_hss.c b/drivers/net/wan/ixp4xx_hss.c
index aaaca9a..3f575af 100644
--- a/drivers/net/wan/ixp4xx_hss.c
+++ b/drivers/net/wan/ixp4xx_hss.c
@@ -10,6 +10,7 @@
=20
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
=20
+#include <linux/module.h>
 #include <linux/bitops.h>
 #include <linux/cdev.h>
 #include <linux/dma-mapping.h>
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c b/drivers=
/net/wireless/brcm80211/brcmfmac/dhd_common.c
index 8918261..746202f 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
@@ -775,8 +775,11 @@ static void brcmf_c_arp_offload_set(struct brcmf_pub *=
drvr, int arp_mode)
 {
 	char iovbuf[32];
 	int retcode;
+	__le32 arp_mode_le;
=20
-	brcmf_c_mkiovar("arp_ol", (char *)&arp_mode, 4, iovbuf, sizeof(iovbuf));
+	arp_mode_le =3D cpu_to_le32(arp_mode);
+	brcmf_c_mkiovar("arp_ol", (char *)&arp_mode_le, 4, iovbuf,
+			sizeof(iovbuf));
 	retcode =3D brcmf_proto_cdc_set_dcmd(drvr, 0, BRCMF_C_SET_VAR,
 				   iovbuf, sizeof(iovbuf));
 	retcode =3D retcode >=3D 0 ? 0 : retcode;
@@ -792,8 +795,11 @@ static void brcmf_c_arp_offload_enable(struct brcmf_pu=
b *drvr, int arp_enable)
 {
 	char iovbuf[32];
 	int retcode;
+	__le32 arp_enable_le;
=20
-	brcmf_c_mkiovar("arpoe", (char *)&arp_enable, 4,
+	arp_enable_le =3D cpu_to_le32(arp_enable);
+
+	brcmf_c_mkiovar("arpoe", (char *)&arp_enable_le, 4,
 			iovbuf, sizeof(iovbuf));
 	retcode =3D brcmf_proto_cdc_set_dcmd(drvr, 0, BRCMF_C_SET_VAR,
 				   iovbuf, sizeof(iovbuf));
@@ -814,10 +820,10 @@ int brcmf_c_preinit_dcmds(struct brcmf_pub *drvr)
 	char buf[128], *ptr;
 	u32 dongle_align =3D BRCMF_SDALIGN;
 	u32 glom =3D 0;
-	u32 roaming =3D 1;
-	uint bcn_timeout =3D 3;
-	int scan_assoc_time =3D 40;
-	int scan_unassoc_time =3D 40;
+	__le32 roaming_le =3D cpu_to_le32(1);
+	__le32 bcn_timeout_le =3D cpu_to_le32(3);
+	__le32 scan_assoc_time_le =3D cpu_to_le32(40);
+	__le32 scan_unassoc_time_le =3D cpu_to_le32(40);
 	int i;
=20
 	brcmf_os_proto_block(drvr);
@@ -852,14 +858,14 @@ int brcmf_c_preinit_dcmds(struct brcmf_pub *drvr)
=20
 	/* Setup timeout if Beacons are lost and roam is off to report
 		 link down */
-	brcmf_c_mkiovar("bcn_timeout", (char *)&bcn_timeout, 4, iovbuf,
+	brcmf_c_mkiovar("bcn_timeout", (char *)&bcn_timeout_le, 4, iovbuf,
 		    sizeof(iovbuf));
 	brcmf_proto_cdc_set_dcmd(drvr, 0, BRCMF_C_SET_VAR, iovbuf,
 				  sizeof(iovbuf));
=20
 	/* Enable/Disable build-in roaming to allowed ext supplicant to take
 		 of romaing */
-	brcmf_c_mkiovar("roam_off", (char *)&roaming, 4,
+	brcmf_c_mkiovar("roam_off", (char *)&roaming_le, 4,
 		      iovbuf, sizeof(iovbuf));
 	brcmf_proto_cdc_set_dcmd(drvr, 0, BRCMF_C_SET_VAR, iovbuf,
 				  sizeof(iovbuf));
@@ -874,9 +880,9 @@ int brcmf_c_preinit_dcmds(struct brcmf_pub *drvr)
 				  sizeof(iovbuf));
=20
 	brcmf_proto_cdc_set_dcmd(drvr, 0, BRCMF_C_SET_SCAN_CHANNEL_TIME,
-			 (char *)&scan_assoc_time, sizeof(scan_assoc_time));
+		 (char *)&scan_assoc_time_le, sizeof(scan_assoc_time_le));
 	brcmf_proto_cdc_set_dcmd(drvr, 0, BRCMF_C_SET_SCAN_UNASSOC_TIME,
-			 (char *)&scan_unassoc_time, sizeof(scan_unassoc_time));
+		 (char *)&scan_unassoc_time_le, sizeof(scan_unassoc_time_le));
=20
 	/* Set and enable ARP offload feature */
 	brcmf_c_arp_offload_set(drvr, BRCMF_ARPOL_MODE);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/driver=
s/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 5eddabe..e4e326a 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -498,8 +498,10 @@ static void wl_iscan_prep(struct brcmf_scan_params_le =
*params_le,
 	params_le->active_time =3D cpu_to_le32(-1);
 	params_le->passive_time =3D cpu_to_le32(-1);
 	params_le->home_time =3D cpu_to_le32(-1);
-	if (ssid && ssid->SSID_len)
-		memcpy(&params_le->ssid_le, ssid, sizeof(struct brcmf_ssid));
+	if (ssid && ssid->SSID_len) {
+		params_le->ssid_le.SSID_len =3D cpu_to_le32(ssid->SSID_len);
+		memcpy(&params_le->ssid_le.SSID, ssid->SSID, ssid->SSID_len);
+	}
 }
=20
 static s32
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/def.h b/drivers/net/wir=
eless/rtlwifi/rtl8192ce/def.h
index 9fc804d..7305a47 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/def.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/def.h
@@ -117,6 +117,7 @@
=20
 #define CHIP_VER_B			BIT(4)
 #define CHIP_92C_BITMASK		BIT(0)
+#define CHIP_UNKNOWN			BIT(7)
 #define CHIP_92C_1T2R			0x03
 #define CHIP_92C			0x01
 #define CHIP_88C			0x00
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c b/drivers/net/wire=
less/rtlwifi/rtl8192ce/hw.c
index a3deaef..cb480d8 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
@@ -1001,8 +1001,16 @@ static enum version_8192c _rtl92ce_read_chip_version=
(struct ieee80211_hw *hw)
 		version =3D (value32 & TYPE_ID) ? VERSION_A_CHIP_92C :
 			   VERSION_A_CHIP_88C;
 	} else {
-		version =3D (value32 & TYPE_ID) ? VERSION_B_CHIP_92C :
-			   VERSION_B_CHIP_88C;
+		version =3D (enum version_8192c) (CHIP_VER_B |
+				((value32 & TYPE_ID) ? CHIP_92C_BITMASK : 0) |
+				((value32 & VENDOR_ID) ? CHIP_VENDOR_UMC : 0));
+		if ((!IS_CHIP_VENDOR_UMC(version)) && (value32 &
+		     CHIP_VER_RTL_MASK)) {
+			version =3D (enum version_8192c)(version |
+				   ((((value32 & CHIP_VER_RTL_MASK) =3D=3D BIT(12))
+				   ? CHIP_VENDOR_UMC_B_CUT : CHIP_UNKNOWN) |
+				   CHIP_VENDOR_UMC));
+		}
 	}
=20
 	switch (version) {
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c b/drivers/net/wire=
less/rtlwifi/rtl8192ce/sw.c
index f2aa33d..df852e8 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
@@ -165,12 +165,14 @@ int rtl92c_init_sw_vars(struct ieee80211_hw *hw)
=20
 	/* request fw */
 	if (IS_VENDOR_UMC_A_CUT(rtlhal->version) &&
-	    !IS_92C_SERIAL(rtlhal->version))
+	    !IS_92C_SERIAL(rtlhal->version)) {
 		fw_name =3D "rtlwifi/rtl8192cfwU.bin";
-	else if (IS_81xxC_VENDOR_UMC_B_CUT(rtlhal->version))
+	} else if (IS_81xxC_VENDOR_UMC_B_CUT(rtlhal->version)) {
 		fw_name =3D "rtlwifi/rtl8192cfwU_B.bin";
-	else
+		pr_info("****** This B_CUT device may not work with kernels 3.6 and earl=
ier\n");
+	} else {
 		fw_name =3D rtlpriv->cfg->fw_name;
+	}
 	err =3D request_firmware(&firmware, fw_name, rtlpriv->io.dev);
 	if (err) {
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpip=
hp_glue.c
index 9ddf69e..74d38ca 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -132,6 +132,15 @@ register_slot(acpi_handle handle, u32 lvl, void *conte=
xt, void **rv)
 	if (!acpi_pci_check_ejectable(pbus, handle) && !is_dock_device(handle))
 		return AE_OK;
=20
+	status =3D acpi_evaluate_integer(handle, "_ADR", NULL, &adr);
+	if (ACPI_FAILURE(status)) {
+		warn("can't evaluate _ADR (%#x)\n", status);
+		return AE_OK;
+	}
+
+	device =3D (adr >> 16) & 0xffff;
+	function =3D adr & 0xffff;
+
 	pdev =3D pbus->self;
 	if (pdev && pci_is_pcie(pdev)) {
 		tmp =3D acpi_find_root_bridge_handle(pdev);
@@ -144,10 +153,6 @@ register_slot(acpi_handle handle, u32 lvl, void *conte=
xt, void **rv)
 		}
 	}
=20
-	acpi_evaluate_integer(handle, "_ADR", NULL, &adr);
-	device =3D (adr >> 16) & 0xffff;
-	function =3D adr & 0xffff;
-
 	newfunc =3D kzalloc(sizeof(struct acpiphp_func), GFP_KERNEL);
 	if (!newfunc)
 		return AE_NO_MEMORY;
diff --git a/drivers/platform/x86/asus-laptop.c b/drivers/platform/x86/asus=
-laptop.c
index edaccad..f75a4c8 100644
--- a/drivers/platform/x86/asus-laptop.c
+++ b/drivers/platform/x86/asus-laptop.c
@@ -823,9 +823,9 @@ static ssize_t show_infos(struct device *dev,
 	 * The significance of others is yet to be found.
 	 * If we don't find the method, we assume the device are present.
 	 */
-	rv =3D acpi_evaluate_integer(asus->handle, "HRWS", NULL, &temp);
+	rv =3D acpi_evaluate_integer(asus->handle, "HWRS", NULL, &temp);
 	if (!ACPI_FAILURE(rv))
-		len +=3D sprintf(page + len, "HRWS value         : %#x\n",
+		len +=3D sprintf(page + len, "HWRS value         : %#x\n",
 			       (uint) temp);
 	/*
 	 * Another value for userspace: the ASYM method returns 0x02 for
@@ -1660,9 +1660,9 @@ static int asus_laptop_get_info(struct asus_laptop *a=
sus)
 	 * The significance of others is yet to be found.
 	 */
 	status =3D
-	    acpi_evaluate_integer(asus->handle, "HRWS", NULL, &hwrs_result);
+	    acpi_evaluate_integer(asus->handle, "HWRS", NULL, &hwrs_result);
 	if (!ACPI_FAILURE(status))
-		pr_notice("  HRWS returned %x", (int)hwrs_result);
+		pr_notice("  HWRS returned %x", (int)hwrs_result);
=20
 	if (!acpi_check_handle(asus->handle, METHOD_WL_STATUS, NULL))
 		asus->have_rsts =3D true;
diff --git a/drivers/rtc/rtc-twl.c b/drivers/rtc/rtc-twl.c
index 20687d5..a3e98f1 100644
--- a/drivers/rtc/rtc-twl.c
+++ b/drivers/rtc/rtc-twl.c
@@ -462,6 +462,11 @@ static int __devinit twl_rtc_probe(struct platform_dev=
ice *pdev)
 			goto out1;
 	}
=20
+	/* ensure interrupts are disabled, bootloaders can be strange */
+	ret =3D twl_rtc_write_u8(0, REG_RTC_INTERRUPTS_REG);
+	if (ret < 0)
+		dev_warn(&pdev->dev, "unable to disable interrupt\n");
+
 	/* init cached IRQ enable bits */
 	ret =3D twl_rtc_read_u8(&rtc_irq_bits, REG_RTC_INTERRUPTS_REG);
 	if (ret < 0)
diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hwi.=
c
index 1ad0b82..1069974 100644
--- a/drivers/scsi/bnx2i/bnx2i_hwi.c
+++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
@@ -1264,6 +1264,9 @@ int bnx2i_send_fw_iscsi_init_msg(struct bnx2i_hba *hb=
a)
 	int rc =3D 0;
 	u64 mask64;
=20
+	memset(&iscsi_init, 0x00, sizeof(struct iscsi_kwqe_init1));
+	memset(&iscsi_init2, 0x00, sizeof(struct iscsi_kwqe_init2));
+
 	bnx2i_adjust_qp_size(hba);
=20
 	iscsi_init.flags =3D
diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index b4d2c86..be9aad8 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1213,8 +1213,9 @@ static void complete_scsi_command(struct CommandList =
*cp)
 	}
 		break;
 	case CMD_PROTOCOL_ERR:
+		cmd->result =3D DID_ERROR << 16;
 		dev_warn(&h->pdev->dev, "cp %p has "
-			"protocol error \n", cp);
+			"protocol error\n", cp);
 		break;
 	case CMD_HARDWARE_ERR:
 		cmd->result =3D DID_ERROR << 16;
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt=
2sas_base.c
index 98cb5e6..17de348 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -1156,6 +1156,13 @@ _base_check_enable_msix(struct MPT2SAS_ADAPTER *ioc)
 	u16 message_control;
=20
=20
+	/* Check whether controller SAS2008 B0 controller,
+	   if it is SAS2008 B0 controller use IO-APIC instead of MSIX */
+	if (ioc->pdev->device =3D=3D MPI2_MFGPAGE_DEVID_SAS2008 &&
+	    ioc->pdev->revision =3D=3D 0x01) {
+		return -EINVAL;
+	}
+
 	base =3D pci_find_capability(ioc->pdev, PCI_CAP_ID_MSIX);
 	if (!base) {
 		dfailprintk(ioc, printk(MPT2SAS_INFO_FMT "msix not "
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target=
_core_transport.c
index 597fb9b..34d114a 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -3039,15 +3039,20 @@ static int transport_generic_cmd_sequencer(
 			/* Returns CHECK_CONDITION + INVALID_CDB_FIELD */
 			goto out_invalid_cdb_field;
 		}
-
+		/*
+		 * For the overflow case keep the existing fabric provided
+		 * ->data_length.  Otherwise for the underflow case, reset
+		 * ->data_length to the smaller SCSI expected data transfer
+		 * length.
+		 */
 		if (size > cmd->data_length) {
 			cmd->se_cmd_flags |=3D SCF_OVERFLOW_BIT;
 			cmd->residual_count =3D (size - cmd->data_length);
 		} else {
 			cmd->se_cmd_flags |=3D SCF_UNDERFLOW_BIT;
 			cmd->residual_count =3D (cmd->data_length - size);
+			cmd->data_length =3D size;
 		}
-		cmd->data_length =3D size;
 	}
=20
 	/* reject any command that we don't have a handler for */
diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index 08b92a6..8d70fbc 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -236,6 +236,9 @@ struct eg20t_port {
 	int				tx_dma_use;
 	void				*rx_buf_virt;
 	dma_addr_t			rx_buf_dma;
+
+	/* protect the eg20t_port private structure and io access to membase */
+	spinlock_t lock;
 };
=20
 /**
@@ -964,7 +967,7 @@ static irqreturn_t pch_uart_interrupt(int irq, void *de=
v_id)
 	unsigned int iid;
 	unsigned long flags;
=20
-	spin_lock_irqsave(&priv->port.lock, flags);
+	spin_lock_irqsave(&priv->lock, flags);
 	handled =3D 0;
 	while ((iid =3D pch_uart_hal_get_iid(priv)) > 1) {
 		switch (iid) {
@@ -1017,7 +1020,7 @@ static irqreturn_t pch_uart_interrupt(int irq, void *=
dev_id)
 			priv->int_dis_flag =3D 0;
 	}
=20
-	spin_unlock_irqrestore(&priv->port.lock, flags);
+	spin_unlock_irqrestore(&priv->lock, flags);
 	return IRQ_RETVAL(handled);
 }
=20
@@ -1131,9 +1134,9 @@ static void pch_uart_break_ctl(struct uart_port *port=
, int ctl)
 	unsigned long flags;
=20
 	priv =3D container_of(port, struct eg20t_port, port);
-	spin_lock_irqsave(&port->lock, flags);
+	spin_lock_irqsave(&priv->lock, flags);
 	pch_uart_hal_set_break(priv, ctl);
-	spin_unlock_irqrestore(&port->lock, flags);
+	spin_unlock_irqrestore(&priv->lock, flags);
 }
=20
 /* Grab any interrupt resources and initialise any low level driver state.=
 */
@@ -1284,7 +1287,8 @@ static void pch_uart_set_termios(struct uart_port *po=
rt,
=20
 	baud =3D uart_get_baud_rate(port, termios, old, 0, port->uartclk / 16);
=20
-	spin_lock_irqsave(&port->lock, flags);
+	spin_lock_irqsave(&priv->lock, flags);
+	spin_lock(&port->lock);
=20
 	uart_update_timeout(port, termios->c_cflag, baud);
 	rtn =3D pch_uart_hal_set_line(priv, baud, parity, bits, stb);
@@ -1297,7 +1301,8 @@ static void pch_uart_set_termios(struct uart_port *po=
rt,
 		tty_termios_encode_baud_rate(termios, baud, baud);
=20
 out:
-	spin_unlock_irqrestore(&port->lock, flags);
+	spin_unlock(&port->lock);
+	spin_unlock_irqrestore(&priv->lock, flags);
 }
=20
 static const char *pch_uart_type(struct uart_port *port)
@@ -1449,6 +1454,8 @@ static struct eg20t_port *pch_uart_init_port(struct p=
ci_dev *pdev,
 	pci_enable_msi(pdev);
 	pci_set_master(pdev);
=20
+	spin_lock_init(&priv->lock);
+
 	iobase =3D pci_resource_start(pdev, 0);
 	mapbase =3D pci_resource_start(pdev, 1);
 	priv->mapbase =3D mapbase;
diff --git a/drivers/usb/core/devices.c b/drivers/usb/core/devices.c
index d956965..3440812 100644
--- a/drivers/usb/core/devices.c
+++ b/drivers/usb/core/devices.c
@@ -624,7 +624,7 @@ static ssize_t usb_device_read(struct file *file, char =
__user *buf,
 	/* print devices for all busses */
 	list_for_each_entry(bus, &usb_bus_list, bus_list) {
 		/* recurse through all children of the root hub */
-		if (!bus->root_hub)
+		if (!bus_to_hcd(bus)->rh_registered)
 			continue;
 		usb_lock_device(bus->root_hub);
 		ret =3D usb_device_dump(&buf, &nbytes, &skip_bytes, ppos,
diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index 8cb9304..032e5a6 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -1002,10 +1002,7 @@ static int register_root_hub(struct usb_hcd *hcd)
 	if (retval) {
 		dev_err (parent_dev, "can't register root hub for %s, %d\n",
 				dev_name(&usb_dev->dev), retval);
-	}
-	mutex_unlock(&usb_bus_list_lock);
-
-	if (retval =3D=3D 0) {
+	} else {
 		spin_lock_irq (&hcd_root_hub_lock);
 		hcd->rh_registered =3D 1;
 		spin_unlock_irq (&hcd_root_hub_lock);
@@ -1014,6 +1011,7 @@ static int register_root_hub(struct usb_hcd *hcd)
 		if (HCD_DEAD(hcd))
 			usb_hc_died (hcd);	/* This time clean up */
 	}
+	mutex_unlock(&usb_bus_list_lock);
=20
 	return retval;
 }
diff --git a/drivers/usb/gadget/dummy_hcd.c b/drivers/usb/gadget/dummy_hcd.=
c
index 527736e..d584eaf 100644
--- a/drivers/usb/gadget/dummy_hcd.c
+++ b/drivers/usb/gadget/dummy_hcd.c
@@ -2292,10 +2292,8 @@ static int dummy_hcd_probe(struct platform_device *p=
dev)
 	hs_hcd->has_tt =3D 1;
=20
 	retval =3D usb_add_hcd(hs_hcd, 0, 0);
-	if (retval !=3D 0) {
-		usb_put_hcd(hs_hcd);
-		return retval;
-	}
+	if (retval)
+		goto put_usb2_hcd;
=20
 	if (mod_data.is_super_speed) {
 		ss_hcd =3D usb_create_shared_hcd(&dummy_hcd, &pdev->dev,
@@ -2314,6 +2312,8 @@ static int dummy_hcd_probe(struct platform_device *pd=
ev)
 put_usb3_hcd:
 	usb_put_hcd(ss_hcd);
 dealloc_usb2_hcd:
+	usb_remove_hcd(hs_hcd);
+put_usb2_hcd:
 	usb_put_hcd(hs_hcd);
 	the_controller.hs_hcd =3D the_controller.ss_hcd =3D NULL;
 	return retval;
diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
index 3c166d3..f62be89 100644
--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -813,6 +813,9 @@ static int __devinit hpwdt_init_one(struct pci_dev *dev=
,
 	hpwdt_timer_reg =3D pci_mem_addr + 0x70;
 	hpwdt_timer_con =3D pci_mem_addr + 0x72;
=20
+	/* Make sure that timer is disabled until /dev/watchdog is opened */
+	hpwdt_stop();
+
 	/* Make sure that we have a valid soft_margin */
 	if (hpwdt_change_timer(soft_margin))
 		hpwdt_change_timer(DEFAULT_MARGIN);
diff --git a/fs/cifs/cifs_unicode.c b/fs/cifs/cifs_unicode.c
index 1b2e180..667776e 100644
--- a/fs/cifs/cifs_unicode.c
+++ b/fs/cifs/cifs_unicode.c
@@ -327,6 +327,6 @@ cifsConvertToUCS(__le16 *target, const char *source, in=
t srclen,
 	}
=20
 ctoUCS_out:
-	return i;
+	return j;
 }
=20
diff --git a/fs/dcache.c b/fs/dcache.c
index eb723d3..63c0c6b 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -311,7 +311,7 @@ static struct dentry *d_kill(struct dentry *dentry, str=
uct dentry *parent)
 	 * Inform try_to_ascend() that we are no longer attached to the
 	 * dentry tree
 	 */
-	dentry->d_flags |=3D DCACHE_DISCONNECTED;
+	dentry->d_flags |=3D DCACHE_DENTRY_KILLED;
 	if (parent)
 		spin_unlock(&parent->d_lock);
 	dentry_iput(dentry);
@@ -968,7 +968,7 @@ static struct dentry *try_to_ascend(struct dentry *old,=
 int locked, unsigned seq
 	 * or deletion
 	 */
 	if (new !=3D old->d_parent ||
-		 (old->d_flags & DCACHE_DISCONNECTED) ||
+		 (old->d_flags & DCACHE_DENTRY_KILLED) ||
 		 (!locked && read_seqretry(&rename_lock, seq))) {
 		spin_unlock(&new->d_lock);
 		new =3D NULL;
@@ -1054,6 +1054,8 @@ positive:
 	return 1;
=20
 rename_retry:
+	if (locked)
+		goto again;
 	locked =3D 1;
 	write_seqlock(&rename_lock);
 	goto again;
@@ -1156,6 +1158,8 @@ out:
 rename_retry:
 	if (found)
 		return found;
+	if (locked)
+		goto again;
 	locked =3D 1;
 	write_seqlock(&rename_lock);
 	goto again;
@@ -2922,6 +2926,8 @@ resume:
 	return;
=20
 rename_retry:
+	if (locked)
+		goto again;
 	locked =3D 1;
 	write_seqlock(&rename_lock);
 	goto again;
diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index 53c3bce..0be1aa4 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -123,9 +123,6 @@ static struct dentry *proc_sys_lookup(struct inode *dir=
, struct dentry *dentry,
=20
 	err =3D ERR_PTR(-ENOMEM);
 	inode =3D proc_sys_make_inode(dir->i_sb, h ? h : head, p);
-	if (h)
-		sysctl_head_finish(h);
-
 	if (!inode)
 		goto out;
=20
@@ -134,6 +131,8 @@ static struct dentry *proc_sys_lookup(struct inode *dir=
, struct dentry *dentry,
 	d_add(dentry, inode);
=20
 out:
+	if (h)
+		sysctl_head_finish(h);
 	sysctl_head_finish(head);
 	return err;
 }
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index 4eb8c80..1dfe974 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -219,6 +219,8 @@ struct dentry_operations {
 #define DCACHE_MANAGED_DENTRY \
 	(DCACHE_MOUNTED|DCACHE_NEED_AUTOMOUNT|DCACHE_MANAGE_TRANSIT)
=20
+#define DCACHE_DENTRY_KILLED	0x100000
+
 extern seqlock_t rename_lock;
=20
 static inline int dname_external(struct dentry *dentry)
diff --git a/include/linux/hid.h b/include/linux/hid.h
index c235e4e..331e2ef 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -875,7 +875,7 @@ static inline int hid_hw_power(struct hid_device *hdev,=
 int level)
 	return hdev->ll_driver->power ? hdev->ll_driver->power(hdev, level) : 0;
 }
=20
-void hid_report_raw_event(struct hid_device *hid, int type, u8 *data, int =
size,
+int hid_report_raw_event(struct hid_device *hid, int type, u8 *data, int s=
ize,
 		int interrupt);
=20
 extern int hid_generic_init(void);
diff --git a/include/linux/hidraw.h b/include/linux/hidraw.h
index 4b88e69..9cdc9b6 100644
--- a/include/linux/hidraw.h
+++ b/include/linux/hidraw.h
@@ -76,13 +76,13 @@ struct hidraw_list {
 #ifdef CONFIG_HIDRAW
 int hidraw_init(void);
 void hidraw_exit(void);
-void hidraw_report_event(struct hid_device *, u8 *, int);
+int hidraw_report_event(struct hid_device *, u8 *, int);
 int hidraw_connect(struct hid_device *);
 void hidraw_disconnect(struct hid_device *);
 #else
 static inline int hidraw_init(void) { return 0; }
 static inline void hidraw_exit(void) { }
-static inline void hidraw_report_event(struct hid_device *hid, u8 *data, i=
nt len) { }
+static inline int hidraw_report_event(struct hid_device *hid, u8 *data, in=
t len) { }
 static inline int hidraw_connect(struct hid_device *hid) { return -1; }
 static inline void hidraw_disconnect(struct hid_device *hid) { }
 #endif
diff --git a/include/linux/memory.h b/include/linux/memory.h
index 935699b..6bea2c2 100644
--- a/include/linux/memory.h
+++ b/include/linux/memory.h
@@ -20,7 +20,7 @@
 #include <linux/compiler.h>
 #include <linux/mutex.h>
=20
-#define MIN_MEMORY_BLOCK_SIZE     (1 << SECTION_SIZE_BITS)
+#define MIN_MEMORY_BLOCK_SIZE     (1UL << SECTION_SIZE_BITS)
=20
 struct memory_block {
 	unsigned long start_section_nr;
diff --git a/include/linux/xfrm.h b/include/linux/xfrm.h
index 22e61fd..28e493b 100644
--- a/include/linux/xfrm.h
+++ b/include/linux/xfrm.h
@@ -84,6 +84,8 @@ struct xfrm_replay_state {
 	__u32	bitmap;
 };
=20
+#define XFRMA_REPLAY_ESN_MAX	4096
+
 struct xfrm_replay_state_esn {
 	unsigned int	bmp_len;
 	__u32		oseq;
diff --git a/include/net/bluetooth/smp.h b/include/net/bluetooth/smp.h
index 15b97d5..fe810d4 100644
--- a/include/net/bluetooth/smp.h
+++ b/include/net/bluetooth/smp.h
@@ -131,7 +131,7 @@ struct smp_chan {
 };
=20
 /* SMP Commands */
-int smp_conn_security(struct l2cap_conn *conn, __u8 sec_level);
+int smp_conn_security(struct hci_conn *hcon, __u8 sec_level);
 int smp_sig_channel(struct l2cap_conn *conn, struct sk_buff *skb);
 int smp_distribute_keys(struct l2cap_conn *conn, __u8 force);
=20
diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index b203e14..921f627 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -269,6 +269,9 @@ struct xfrm_replay {
 	int	(*check)(struct xfrm_state *x,
 			 struct sk_buff *skb,
 			 __be32 net_seq);
+	int	(*recheck)(struct xfrm_state *x,
+			   struct sk_buff *skb,
+			   __be32 net_seq);
 	void	(*notify)(struct xfrm_state *x, int event);
 	int	(*overflow)(struct xfrm_state *x, struct sk_buff *skb);
 };
diff --git a/include/trace/events/kmem.h b/include/trace/events/kmem.h
index a9c87ad..a9536da 100644
--- a/include/trace/events/kmem.h
+++ b/include/trace/events/kmem.h
@@ -214,7 +214,7 @@ TRACE_EVENT(mm_page_alloc,
=20
 	TP_printk("page=3D%p pfn=3D%lu order=3D%d migratetype=3D%d gfp_flags=3D%s=
",
 		__entry->page,
-		page_to_pfn(__entry->page),
+		__entry->page ? page_to_pfn(__entry->page) : 0,
 		__entry->order,
 		__entry->migratetype,
 		show_gfp_flags(__entry->gfp_flags))
@@ -240,7 +240,7 @@ DECLARE_EVENT_CLASS(mm_page,
=20
 	TP_printk("page=3D%p pfn=3D%lu order=3D%u migratetype=3D%d percpu_refill=
=3D%d",
 		__entry->page,
-		page_to_pfn(__entry->page),
+		__entry->page ? page_to_pfn(__entry->page) : 0,
 		__entry->order,
 		__entry->migratetype,
 		__entry->order =3D=3D 0)
diff --git a/kernel/async.c b/kernel/async.c
index 80b74b8..009f516 100644
--- a/kernel/async.c
+++ b/kernel/async.c
@@ -88,6 +88,13 @@ static async_cookie_t  __lowest_in_progress(struct list_=
head *running)
 {
 	struct async_entry *entry;
=20
+	if (!running) { /* just check the entry count */
+		if (atomic_read(&entry_count))
+			return 0; /* smaller than any cookie */
+		else
+			return next_cookie;
+	}
+
 	if (!list_empty(running)) {
 		entry =3D list_first_entry(running,
 			struct async_entry, list);
@@ -238,9 +245,7 @@ EXPORT_SYMBOL_GPL(async_schedule_domain);
  */
 void async_synchronize_full(void)
 {
-	do {
-		async_synchronize_cookie(next_cookie);
-	} while (!list_empty(&async_running) || !list_empty(&async_pending));
+	async_synchronize_cookie_domain(next_cookie, NULL);
 }
 EXPORT_SYMBOL_GPL(async_synchronize_full);
=20
@@ -260,7 +265,7 @@ EXPORT_SYMBOL_GPL(async_synchronize_full_domain);
 /**
  * async_synchronize_cookie_domain - synchronize asynchronous function cal=
ls within a certain domain with cookie checkpointing
  * @cookie: async_cookie_t to use as checkpoint
- * @running: running list to synchronize on
+ * @running: running list to synchronize on, NULL indicates all lists
  *
  * This function waits until all asynchronous function calls for the
  * synchronization domain specified by the running list @list submitted
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 46a1d3c..84a524b 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2080,6 +2080,9 @@ static void scan_for_empty_cpusets(struct cpuset *roo=
t)
  * (of no affect) on systems that are actively using CPU hotplug
  * but making no active use of cpusets.
  *
+ * The only exception to this is suspend/resume, where we don't
+ * modify cpusets at all.
+ *
  * This routine ensures that top_cpuset.cpus_allowed tracks
  * cpu_active_mask on each CPU hotplug (cpuhp) event.
  *
diff --git a/kernel/exit.c b/kernel/exit.c
index 5a8a66e..234e152 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1019,6 +1019,22 @@ NORET_TYPE void do_exit(long code)
=20
 	preempt_disable();
 	exit_rcu();
+
+	/*
+	 * The setting of TASK_RUNNING by try_to_wake_up() may be delayed
+	 * when the following two conditions become true.
+	 *   - There is race condition of mmap_sem (It is acquired by
+	 *     exit_mm()), and
+	 *   - SMI occurs before setting TASK_RUNINNG.
+	 *     (or hypervisor of virtual machine switches to other guest)
+	 *  As a result, we may become TASK_RUNNING after becoming TASK_DEAD
+	 *
+	 * To avoid it, we have to wait for releasing tsk->pi_lock which
+	 * is held by try_to_wake_up()
+	 */
+	smp_mb();
+	raw_spin_unlock_wait(&tsk->pi_lock);
+
 	/* causes final put_task_struct in finish_task_switch(). */
 	tsk->state =3D TASK_DEAD;
 	schedule();
diff --git a/kernel/sched.c b/kernel/sched.c
index 910db7d..fcc893f 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8192,34 +8192,66 @@ int __init sched_create_sysfs_power_savings_entries=
(struct sysdev_class *cls)
 }
 #endif /* CONFIG_SCHED_MC || CONFIG_SCHED_SMT */
=20
+static int num_cpus_frozen;	/* used to mark begin/end of suspend/resume */
+
 /*
  * Update cpusets according to cpu_active mask.  If cpusets are
  * disabled, cpuset_update_active_cpus() becomes a simple wrapper
  * around partition_sched_domains().
+ *
+ * If we come here as part of a suspend/resume, don't touch cpusets becaus=
e we
+ * want to restore it back to its original state upon resume anyway.
  */
 static int cpuset_cpu_active(struct notifier_block *nfb, unsigned long act=
ion,
 			     void *hcpu)
 {
-	switch (action & ~CPU_TASKS_FROZEN) {
+	switch (action) {
+	case CPU_ONLINE_FROZEN:
+	case CPU_DOWN_FAILED_FROZEN:
+
+		/*
+		 * num_cpus_frozen tracks how many CPUs are involved in suspend
+		 * resume sequence. As long as this is not the last online
+		 * operation in the resume sequence, just build a single sched
+		 * domain, ignoring cpusets.
+		 */
+		num_cpus_frozen--;
+		if (likely(num_cpus_frozen)) {
+			partition_sched_domains(1, NULL, NULL);
+			break;
+		}
+
+		/*
+		 * This is the last CPU online operation. So fall through and
+		 * restore the original sched domains by considering the
+		 * cpuset configurations.
+		 */
+
 	case CPU_ONLINE:
 	case CPU_DOWN_FAILED:
 		cpuset_update_active_cpus();
-		return NOTIFY_OK;
+		break;
 	default:
 		return NOTIFY_DONE;
 	}
+	return NOTIFY_OK;
 }
=20
 static int cpuset_cpu_inactive(struct notifier_block *nfb, unsigned long a=
ction,
 			       void *hcpu)
 {
-	switch (action & ~CPU_TASKS_FROZEN) {
+	switch (action) {
 	case CPU_DOWN_PREPARE:
 		cpuset_update_active_cpus();
-		return NOTIFY_OK;
+		break;
+	case CPU_DOWN_PREPARE_FROZEN:
+		num_cpus_frozen++;
+		partition_sched_domains(1, NULL, NULL);
+		break;
 	default:
 		return NOTIFY_DONE;
 	}
+	return NOTIFY_OK;
 }
=20
 static int update_runtime(struct notifier_block *nfb,
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 979d4de..b413138 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3627,18 +3627,17 @@ static int __devinit workqueue_cpu_down_callback(st=
ruct notifier_block *nfb,
 #ifdef CONFIG_SMP
=20
 struct work_for_cpu {
-	struct completion completion;
+	struct work_struct work;
 	long (*fn)(void *);
 	void *arg;
 	long ret;
 };
=20
-static int do_work_for_cpu(void *_wfc)
+static void work_for_cpu_fn(struct work_struct *work)
 {
-	struct work_for_cpu *wfc =3D _wfc;
+	struct work_for_cpu *wfc =3D container_of(work, struct work_for_cpu, work=
);
+
 	wfc->ret =3D wfc->fn(wfc->arg);
-	complete(&wfc->completion);
-	return 0;
 }
=20
 /**
@@ -3653,19 +3652,11 @@ static int do_work_for_cpu(void *_wfc)
  */
 long work_on_cpu(unsigned int cpu, long (*fn)(void *), void *arg)
 {
-	struct task_struct *sub_thread;
-	struct work_for_cpu wfc =3D {
-		.completion =3D COMPLETION_INITIALIZER_ONSTACK(wfc.completion),
-		.fn =3D fn,
-		.arg =3D arg,
-	};
+	struct work_for_cpu wfc =3D { .fn =3D fn, .arg =3D arg };
=20
-	sub_thread =3D kthread_create(do_work_for_cpu, &wfc, "work_for_cpu");
-	if (IS_ERR(sub_thread))
-		return PTR_ERR(sub_thread);
-	kthread_bind(sub_thread, cpu);
-	wake_up_process(sub_thread);
-	wait_for_completion(&wfc.completion);
+	INIT_WORK_ONSTACK(&wfc.work, work_for_cpu_fn);
+	schedule_work_on(cpu, &wfc.work);
+	flush_work(&wfc.work);
 	return wfc.ret;
 }
 EXPORT_SYMBOL_GPL(work_on_cpu);
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 6629faf..9ad7d1e 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -127,9 +127,6 @@ static void register_page_bootmem_info_section(unsigned=
 long start_pfn)
 	struct mem_section *ms;
 	struct page *page, *memmap;
=20
-	if (!pfn_valid(start_pfn))
-		return;
-
 	section_nr =3D pfn_to_section_nr(start_pfn);
 	ms =3D __nr_to_section(section_nr);
=20
@@ -188,9 +185,16 @@ void register_page_bootmem_info_node(struct pglist_dat=
a *pgdat)
 	end_pfn =3D pfn + pgdat->node_spanned_pages;
=20
 	/* register_section info */
-	for (; pfn < end_pfn; pfn +=3D PAGES_PER_SECTION)
-		register_page_bootmem_info_section(pfn);
-
+	for (; pfn < end_pfn; pfn +=3D PAGES_PER_SECTION) {
+		/*
+		 * Some platforms can assign the same pfn to multiple nodes - on
+		 * node0 as well as nodeN.  To avoid registering a pfn against
+		 * multiple nodes we check that this pfn does not already
+		 * reside in some other node.
+		 */
+		if (pfn_valid(pfn) && (pfn_to_nid(pfn) =3D=3D node))
+			register_page_bootmem_info_section(pfn);
+	}
 }
 #endif /* !CONFIG_SPARSEMEM_VMEMMAP */
=20
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 6e51bf0..a88dded 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -541,7 +541,7 @@ static inline void __free_one_page(struct page *page,
 		combined_idx =3D buddy_idx & page_idx;
 		higher_page =3D page + (combined_idx - page_idx);
 		buddy_idx =3D __find_buddy_index(combined_idx, order + 1);
-		higher_buddy =3D page + (buddy_idx - combined_idx);
+		higher_buddy =3D higher_page + (buddy_idx - combined_idx);
 		if (page_is_buddy(higher_page, higher_buddy, order + 1)) {
 			list_add_tail(&page->lru,
 				&zone->free_area[order].free_list[migratetype]);
diff --git a/net/8021q/vlan_core.c b/net/8021q/vlan_core.c
index f5ffc02..9ddbd4e 100644
--- a/net/8021q/vlan_core.c
+++ b/net/8021q/vlan_core.c
@@ -106,7 +106,6 @@ static struct sk_buff *vlan_reorder_header(struct sk_bu=
ff *skb)
 		return NULL;
 	memmove(skb->data - ETH_HLEN, skb->data - VLAN_ETH_HLEN, 2 * ETH_ALEN);
 	skb->mac_header +=3D VLAN_HLEN;
-	skb_reset_mac_len(skb);
 	return skb;
 }
=20
@@ -173,6 +172,8 @@ struct sk_buff *vlan_untag(struct sk_buff *skb)
=20
 	skb_reset_network_header(skb);
 	skb_reset_transport_header(skb);
+	skb_reset_mac_len(skb);
+
 	return skb;
=20
 err_free:
diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index 98bfbd5..1fb1aec 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -44,6 +44,7 @@
=20
 #include <net/bluetooth/bluetooth.h>
 #include <net/bluetooth/hci_core.h>
+#include <net/bluetooth/smp.h>
=20
 static void hci_le_connect(struct hci_conn *conn)
 {
@@ -641,6 +642,9 @@ int hci_conn_security(struct hci_conn *conn, __u8 sec_l=
evel, __u8 auth_type)
 {
 	BT_DBG("conn %p", conn);
=20
+	if (conn->type =3D=3D LE_LINK)
+		return smp_conn_security(conn, sec_level);
+
 	/* For sdp we don't need the link key. */
 	if (sec_level =3D=3D BT_SECURITY_SDP)
 		return 1;
diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index dd76177..04175d9 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -902,14 +902,15 @@ static void l2cap_chan_ready(struct sock *sk)
 static void l2cap_conn_ready(struct l2cap_conn *conn)
 {
 	struct l2cap_chan *chan;
+	struct hci_conn *hcon =3D conn->hcon;
=20
 	BT_DBG("conn %p", conn);
=20
-	if (!conn->hcon->out && conn->hcon->type =3D=3D LE_LINK)
+	if (!hcon->out && hcon->type =3D=3D LE_LINK)
 		l2cap_le_conn_ready(conn);
=20
-	if (conn->hcon->out && conn->hcon->type =3D=3D LE_LINK)
-		smp_conn_security(conn, conn->hcon->pending_sec_level);
+	if (hcon->out && hcon->type =3D=3D LE_LINK)
+		smp_conn_security(hcon, hcon->pending_sec_level);
=20
 	read_lock(&conn->chan_lock);
=20
@@ -918,8 +919,8 @@ static void l2cap_conn_ready(struct l2cap_conn *conn)
=20
 		bh_lock_sock(sk);
=20
-		if (conn->hcon->type =3D=3D LE_LINK) {
-			if (smp_conn_security(conn, chan->sec_level))
+		if (hcon->type =3D=3D LE_LINK) {
+			if (smp_conn_security(hcon, chan->sec_level))
 				l2cap_chan_ready(sk);
=20
 		} else if (chan->chan_type !=3D L2CAP_CHAN_CONN_ORIENTED) {
diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
index 6dedd6f..158887a 100644
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -616,7 +616,7 @@ static int l2cap_sock_setsockopt(struct socket *sock, i=
nt level, int optname, ch
 				break;
 			}
=20
-			if (smp_conn_security(conn, sec.level))
+			if (smp_conn_security(conn->hcon, sec.level))
 				break;
=20
 			err =3D 0;
diff --git a/net/bluetooth/smp.c b/net/bluetooth/smp.c
index 759b635..c27b4e3 100644
--- a/net/bluetooth/smp.c
+++ b/net/bluetooth/smp.c
@@ -554,9 +554,9 @@ static u8 smp_cmd_security_req(struct l2cap_conn *conn,=
 struct sk_buff *skb)
 	return 0;
 }
=20
-int smp_conn_security(struct l2cap_conn *conn, __u8 sec_level)
+int smp_conn_security(struct hci_conn *hcon, __u8 sec_level)
 {
-	struct hci_conn *hcon =3D conn->hcon;
+	struct l2cap_conn *conn =3D hcon->l2cap_data;
 	struct smp_chan *smp =3D conn->smp_chan;
=20
 	BT_DBG("conn %p hcon %p level 0x%2.2x", conn, hcon, sec_level);
diff --git a/net/core/dev.c b/net/core/dev.c
index 832ba6d..abe1147 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2108,7 +2108,8 @@ static bool can_checksum_protocol(unsigned long featu=
res, __be16 protocol)
=20
 static u32 harmonize_features(struct sk_buff *skb, __be16 protocol, u32 fe=
atures)
 {
-	if (!can_checksum_protocol(features, protocol)) {
+	if (skb->ip_summed !=3D CHECKSUM_NONE &&
+	    !can_checksum_protocol(features, protocol)) {
 		features &=3D ~NETIF_F_ALL_CSUM;
 		features &=3D ~NETIF_F_SG;
 	} else if (illegal_highdma(skb->dev, skb)) {
@@ -2686,16 +2687,17 @@ ipv6:
 		nhoff +=3D poff;
 		if (pskb_may_pull(skb, nhoff + 4)) {
 			ports.v32 =3D * (__force u32 *) (skb->data + nhoff);
-			if (ports.v16[1] < ports.v16[0])
-				swap(ports.v16[0], ports.v16[1]);
 			skb->l4_rxhash =3D 1;
 		}
 	}
=20
 	/* get a consistent hash (same value on both flow directions) */
-	if (addr2 < addr1)
+	if (addr2 < addr1 ||
+	    (addr2 =3D=3D addr1 &&
+	     ports.v16[1] < ports.v16[0])) {
 		swap(addr1, addr2);
-
+		swap(ports.v16[0], ports.v16[1]);
+	}
 	hash =3D jhash_3words(addr1, addr2, ports.v32, hashrnd);
 	if (!hash)
 		hash =3D 1;
@@ -6387,7 +6389,8 @@ static struct hlist_head *netdev_create_hash(void)
 /* Initialize per network namespace state */
 static int __net_init netdev_init(struct net *net)
 {
-	INIT_LIST_HEAD(&net->dev_base_head);
+	if (net !=3D &init_net)
+		INIT_LIST_HEAD(&net->dev_base_head);
=20
 	net->dev_name_head =3D netdev_create_hash();
 	if (net->dev_name_head =3D=3D NULL)
diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index 31a5ae5..dd00b71 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -25,7 +25,9 @@ static DEFINE_MUTEX(net_mutex);
 LIST_HEAD(net_namespace_list);
 EXPORT_SYMBOL_GPL(net_namespace_list);
=20
-struct net init_net;
+struct net init_net =3D {
+	.dev_base_head =3D LIST_HEAD_INIT(init_net.dev_base_head),
+};
 EXPORT_SYMBOL(init_net);
=20
 #define INITIAL_NET_GEN_PTRS	13 /* +1 for len +2 for rcu_head */
diff --git a/net/core/sock.c b/net/core/sock.c
index 018fd41..1e8a882 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -593,7 +593,8 @@ set_rcvbuf:
=20
 	case SO_KEEPALIVE:
 #ifdef CONFIG_INET
-		if (sk->sk_protocol =3D=3D IPPROTO_TCP)
+		if (sk->sk_protocol =3D=3D IPPROTO_TCP &&
+		    sk->sk_type =3D=3D SOCK_STREAM)
 			tcp_set_keepalive(sk, valbool);
 #endif
 		sock_valbool_flag(sk, SOCK_KEEPOPEN, valbool);
diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index 007e2eb..e1d4f30 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -131,18 +131,20 @@ found:
  *	0 - deliver
  *	1 - block
  */
-static __inline__ int icmp_filter(struct sock *sk, struct sk_buff *skb)
+static int icmp_filter(const struct sock *sk, const struct sk_buff *skb)
 {
-	int type;
+	struct icmphdr _hdr;
+	const struct icmphdr *hdr;
=20
-	if (!pskb_may_pull(skb, sizeof(struct icmphdr)))
+	hdr =3D skb_header_pointer(skb, skb_transport_offset(skb),
+				 sizeof(_hdr), &_hdr);
+	if (!hdr)
 		return 1;
=20
-	type =3D icmp_hdr(skb)->type;
-	if (type < 32) {
+	if (hdr->type < 32) {
 		__u32 data =3D raw_sk(sk)->filter.data;
=20
-		return ((1 << type) & data) !=3D 0;
+		return ((1U << hdr->type) & data) !=3D 0;
 	}
=20
 	/* Do not block unknown ICMP types */
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 043d49b..7397ad8 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1589,8 +1589,14 @@ int tcp_recvmsg(struct kiocb *iocb, struct sock *sk,=
 struct msghdr *msg,
 		}
=20
 #ifdef CONFIG_NET_DMA
-		if (tp->ucopy.dma_chan)
-			dma_async_memcpy_issue_pending(tp->ucopy.dma_chan);
+		if (tp->ucopy.dma_chan) {
+			if (tp->rcv_wnd =3D=3D 0 &&
+			    !skb_queue_empty(&sk->sk_async_wait_queue)) {
+				tcp_service_net_dma(sk, true);
+				tcp_cleanup_rbuf(sk, copied);
+			} else
+				dma_async_memcpy_issue_pending(tp->ucopy.dma_chan);
+		}
 #endif
 		if (copied >=3D target) {
 			/* Do not sleep, just process backlog. */
diff --git a/net/ipv6/mip6.c b/net/ipv6/mip6.c
index 43242e6..42853c4 100644
--- a/net/ipv6/mip6.c
+++ b/net/ipv6/mip6.c
@@ -84,28 +84,30 @@ static int mip6_mh_len(int type)
=20
 static int mip6_mh_filter(struct sock *sk, struct sk_buff *skb)
 {
-	struct ip6_mh *mh;
+	struct ip6_mh _hdr;
+	const struct ip6_mh *mh;
=20
-	if (!pskb_may_pull(skb, (skb_transport_offset(skb)) + 8) ||
-	    !pskb_may_pull(skb, (skb_transport_offset(skb) +
-				 ((skb_transport_header(skb)[1] + 1) << 3))))
+	mh =3D skb_header_pointer(skb, skb_transport_offset(skb),
+				sizeof(_hdr), &_hdr);
+	if (!mh)
 		return -1;
=20
-	mh =3D (struct ip6_mh *)skb_transport_header(skb);
+	if (((mh->ip6mh_hdrlen + 1) << 3) > skb->len)
+		return -1;
=20
 	if (mh->ip6mh_hdrlen < mip6_mh_len(mh->ip6mh_type)) {
 		LIMIT_NETDEBUG(KERN_DEBUG "mip6: MH message too short: %d vs >=3D%d\n",
 			       mh->ip6mh_hdrlen, mip6_mh_len(mh->ip6mh_type));
-		mip6_param_prob(skb, 0, ((&mh->ip6mh_hdrlen) -
-					 skb_network_header(skb)));
+		mip6_param_prob(skb, 0, offsetof(struct ip6_mh, ip6mh_hdrlen) +
+				skb_network_header_len(skb));
 		return -1;
 	}
=20
 	if (mh->ip6mh_proto !=3D IPPROTO_NONE) {
 		LIMIT_NETDEBUG(KERN_DEBUG "mip6: MH invalid payload proto =3D %d\n",
 			       mh->ip6mh_proto);
-		mip6_param_prob(skb, 0, ((&mh->ip6mh_proto) -
-					 skb_network_header(skb)));
+		mip6_param_prob(skb, 0, offsetof(struct ip6_mh, ip6mh_proto) +
+				skb_network_header_len(skb));
 		return -1;
 	}
=20
diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index 361ebf3..6e6c2c4 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -107,21 +107,20 @@ found:
  *	0 - deliver
  *	1 - block
  */
-static __inline__ int icmpv6_filter(struct sock *sk, struct sk_buff *skb)
+static int icmpv6_filter(const struct sock *sk, const struct sk_buff *skb)
 {
-	struct icmp6hdr *icmph;
-	struct raw6_sock *rp =3D raw6_sk(sk);
-
-	if (pskb_may_pull(skb, sizeof(struct icmp6hdr))) {
-		__u32 *data =3D &rp->filter.data[0];
-		int bit_nr;
+	struct icmp6hdr *_hdr;
+	const struct icmp6hdr *hdr;
=20
-		icmph =3D (struct icmp6hdr *) skb->data;
-		bit_nr =3D icmph->icmp6_type;
+	hdr =3D skb_header_pointer(skb, skb_transport_offset(skb),
+				 sizeof(_hdr), &_hdr);
+	if (hdr) {
+		const __u32 *data =3D &raw6_sk(sk)->filter.data[0];
+		unsigned int type =3D hdr->icmp6_type;
=20
-		return (data[bit_nr >> 5] & (1 << (bit_nr & 31))) !=3D 0;
+		return (data[type >> 5] & (1U << (type & 31))) !=3D 0;
 	}
-	return 0;
+	return 1;
 }
=20
 #if defined(CONFIG_IPV6_MIP6) || defined(CONFIG_IPV6_MIP6_MODULE)
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 2e21751..488a1b7 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -1435,17 +1435,18 @@ static int __ip6_del_rt(struct rt6_info *rt, struct=
 nl_info *info)
 	struct fib6_table *table;
 	struct net *net =3D dev_net(rt->rt6i_dev);
=20
-	if (rt =3D=3D net->ipv6.ip6_null_entry)
-		return -ENOENT;
+	if (rt =3D=3D net->ipv6.ip6_null_entry) {
+		err =3D -ENOENT;
+		goto out;
+	}
=20
 	table =3D rt->rt6i_table;
 	write_lock_bh(&table->tb6_lock);
-
 	err =3D fib6_del(rt, info);
-	dst_release(&rt->dst);
-
 	write_unlock_bh(&table->tb6_lock);
=20
+out:
+	dst_release(&rt->dst);
 	return err;
 }
=20
diff --git a/net/l2tp/l2tp_eth.c b/net/l2tp/l2tp_eth.c
index 3c55f63..2cef50b 100644
--- a/net/l2tp/l2tp_eth.c
+++ b/net/l2tp/l2tp_eth.c
@@ -132,7 +132,7 @@ static void l2tp_eth_dev_recv(struct l2tp_session *sess=
ion, struct sk_buff *skb,
 		printk("\n");
 	}
=20
-	if (!pskb_may_pull(skb, sizeof(ETH_HLEN)))
+	if (!pskb_may_pull(skb, ETH_HLEN))
 		goto error;
=20
 	secpath_reset(skb);
diff --git a/net/netrom/af_netrom.c b/net/netrom/af_netrom.c
index 732152f..f156382 100644
--- a/net/netrom/af_netrom.c
+++ b/net/netrom/af_netrom.c
@@ -1170,7 +1170,12 @@ static int nr_recvmsg(struct kiocb *iocb, struct soc=
ket *sock,
 		msg->msg_flags |=3D MSG_TRUNC;
 	}
=20
-	skb_copy_datagram_iovec(skb, 0, msg->msg_iov, copied);
+	er =3D skb_copy_datagram_iovec(skb, 0, msg->msg_iov, copied);
+	if (er < 0) {
+		skb_free_datagram(sk, skb);
+		release_sock(sk);
+		return er;
+	}
=20
 	if (sax !=3D NULL) {
 		sax->sax25_family =3D AF_NETROM;
diff --git a/net/rds/recv.c b/net/rds/recv.c
index bc3f8cd..fc57d31 100644
--- a/net/rds/recv.c
+++ b/net/rds/recv.c
@@ -410,6 +410,8 @@ int rds_recvmsg(struct kiocb *iocb, struct socket *sock=
, struct msghdr *msg,
=20
 	rdsdebug("size %zu flags 0x%x timeo %ld\n", size, msg_flags, timeo);
=20
+	msg->msg_namelen =3D 0;
+
 	if (msg_flags & MSG_OOB)
 		goto out;
=20
@@ -485,6 +487,7 @@ int rds_recvmsg(struct kiocb *iocb, struct socket *sock=
, struct msghdr *msg,
 			sin->sin_port =3D inc->i_hdr.h_sport;
 			sin->sin_addr.s_addr =3D inc->i_saddr;
 			memset(sin->sin_zero, 0, sizeof(sin->sin_zero));
+			msg->msg_namelen =3D sizeof(*sin);
 		}
 		break;
 	}
diff --git a/net/sched/sch_cbq.c b/net/sched/sch_cbq.c
index 24d94c0..599f67a 100644
--- a/net/sched/sch_cbq.c
+++ b/net/sched/sch_cbq.c
@@ -250,10 +250,11 @@ cbq_classify(struct sk_buff *skb, struct Qdisc *sch, =
int *qerr)
 			else if ((cl =3D defmap[res.classid & TC_PRIO_MAX]) =3D=3D NULL)
 				cl =3D defmap[TC_PRIO_BESTEFFORT];
=20
-			if (cl =3D=3D NULL || cl->level >=3D head->level)
+			if (cl =3D=3D NULL)
 				goto fallback;
 		}
-
+		if (cl->level >=3D head->level)
+			goto fallback;
 #ifdef CONFIG_NET_CLS_ACT
 		switch (result) {
 		case TC_ACT_QUEUED:
diff --git a/net/sched/sch_qfq.c b/net/sched/sch_qfq.c
index 7b03254..ca0fb48 100644
--- a/net/sched/sch_qfq.c
+++ b/net/sched/sch_qfq.c
@@ -829,7 +829,10 @@ static void qfq_update_start(struct qfq_sched *q, stru=
ct qfq_class *cl)
 		if (mask) {
 			struct qfq_group *next =3D qfq_ffs(q, mask);
 			if (qfq_gt(roundedF, next->F)) {
-				cl->S =3D next->F;
+				if (qfq_gt(limit, next->F))
+					cl->S =3D next->F;
+				else /* preserve timestamp correctness */
+					cl->S =3D limit;
 				return;
 			}
 		}
diff --git a/net/sctp/output.c b/net/sctp/output.c
index 8fc4dcd..32ba8d0 100644
--- a/net/sctp/output.c
+++ b/net/sctp/output.c
@@ -334,6 +334,25 @@ finish:
 	return retval;
 }
=20
+static void sctp_packet_release_owner(struct sk_buff *skb)
+{
+	sk_free(skb->sk);
+}
+
+static void sctp_packet_set_owner_w(struct sk_buff *skb, struct sock *sk)
+{
+	skb_orphan(skb);
+	skb->sk =3D sk;
+	skb->destructor =3D sctp_packet_release_owner;
+
+	/*
+	 * The data chunks have already been accounted for in sctp_sendmsg(),
+	 * therefore only reserve a single byte to keep socket around until
+	 * the packet has been transmitted.
+	 */
+	atomic_inc(&sk->sk_wmem_alloc);
+}
+
 /* All packets are sent to the network through this function from
  * sctp_outq_tail().
  *
@@ -375,7 +394,7 @@ int sctp_packet_transmit(struct sctp_packet *packet)
 	/* Set the owning socket so that we know where to get the
 	 * destination IP address.
 	 */
-	skb_set_owner_w(nskb, sk);
+	sctp_packet_set_owner_w(nskb, sk);
=20
 	if (!sctp_transport_dst_check(tp)) {
 		sctp_transport_route(tp, NULL, sctp_sk(sk));
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index d57d05b..fa39731 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -331,6 +331,9 @@ static void reg_regdb_search(struct work_struct *work)
 	struct reg_regdb_search_request *request;
 	const struct ieee80211_regdomain *curdom, *regdom;
 	int i, r;
+	bool set_reg =3D false;
+
+	mutex_lock(&cfg80211_mutex);
=20
 	mutex_lock(&reg_regdb_search_mutex);
 	while (!list_empty(&reg_regdb_search_list)) {
@@ -346,9 +349,7 @@ static void reg_regdb_search(struct work_struct *work)
 				r =3D reg_copy_regd(&regdom, curdom);
 				if (r)
 					break;
-				mutex_lock(&cfg80211_mutex);
-				set_regdom(regdom);
-				mutex_unlock(&cfg80211_mutex);
+				set_reg =3D true;
 				break;
 			}
 		}
@@ -356,6 +357,11 @@ static void reg_regdb_search(struct work_struct *work)
 		kfree(request);
 	}
 	mutex_unlock(&reg_regdb_search_mutex);
+
+	if (set_reg)
+		set_regdom(regdom);
+
+	mutex_unlock(&cfg80211_mutex);
 }
=20
 static DECLARE_WORK(reg_regdb_work, reg_regdb_search);
diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
index 54a0dc2..ab2bb42 100644
--- a/net/xfrm/xfrm_input.c
+++ b/net/xfrm/xfrm_input.c
@@ -212,7 +212,7 @@ resume:
 		/* only the first xfrm gets the encap type */
 		encap_type =3D 0;
=20
-		if (async && x->repl->check(x, skb, seq)) {
+		if (async && x->repl->recheck(x, skb, seq)) {
 			XFRM_INC_STATS(net, LINUX_MIB_XFRMINSTATESEQERROR);
 			goto drop_unlock;
 		}
diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 0174034..113d20e 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -1761,7 +1761,7 @@ static struct dst_entry *make_blackhole(struct net *n=
et, u16 family,
=20
 	if (!afinfo) {
 		dst_release(dst_orig);
-		ret =3D ERR_PTR(-EINVAL);
+		return ERR_PTR(-EINVAL);
 	} else {
 		ret =3D afinfo->blackhole_route(net, dst_orig);
 	}
diff --git a/net/xfrm/xfrm_replay.c b/net/xfrm/xfrm_replay.c
index 2f6d11d..3efb07d 100644
--- a/net/xfrm/xfrm_replay.c
+++ b/net/xfrm/xfrm_replay.c
@@ -420,6 +420,18 @@ err:
 	return -EINVAL;
 }
=20
+static int xfrm_replay_recheck_esn(struct xfrm_state *x,
+				   struct sk_buff *skb, __be32 net_seq)
+{
+	if (unlikely(XFRM_SKB_CB(skb)->seq.input.hi !=3D
+		     htonl(xfrm_replay_seqhi(x, net_seq)))) {
+			x->stats.replay_window++;
+			return -EINVAL;
+	}
+
+	return xfrm_replay_check_esn(x, skb, net_seq);
+}
+
 static void xfrm_replay_advance_esn(struct xfrm_state *x, __be32 net_seq)
 {
 	unsigned int bitnr, nr, i;
@@ -479,6 +491,7 @@ static void xfrm_replay_advance_esn(struct xfrm_state *=
x, __be32 net_seq)
 static struct xfrm_replay xfrm_replay_legacy =3D {
 	.advance	=3D xfrm_replay_advance,
 	.check		=3D xfrm_replay_check,
+	.recheck	=3D xfrm_replay_check,
 	.notify		=3D xfrm_replay_notify,
 	.overflow	=3D xfrm_replay_overflow,
 };
@@ -486,6 +499,7 @@ static struct xfrm_replay xfrm_replay_legacy =3D {
 static struct xfrm_replay xfrm_replay_bmp =3D {
 	.advance	=3D xfrm_replay_advance_bmp,
 	.check		=3D xfrm_replay_check_bmp,
+	.recheck	=3D xfrm_replay_check_bmp,
 	.notify		=3D xfrm_replay_notify_bmp,
 	.overflow	=3D xfrm_replay_overflow_bmp,
 };
@@ -493,6 +507,7 @@ static struct xfrm_replay xfrm_replay_bmp =3D {
 static struct xfrm_replay xfrm_replay_esn =3D {
 	.advance	=3D xfrm_replay_advance_esn,
 	.check		=3D xfrm_replay_check_esn,
+	.recheck	=3D xfrm_replay_recheck_esn,
 	.notify		=3D xfrm_replay_notify_bmp,
 	.overflow	=3D xfrm_replay_overflow_esn,
 };
diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 7cae73e..ede01a8 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -123,9 +123,21 @@ static inline int verify_replay(struct xfrm_usersa_inf=
o *p,
 				struct nlattr **attrs)
 {
 	struct nlattr *rt =3D attrs[XFRMA_REPLAY_ESN_VAL];
+	struct xfrm_replay_state_esn *rs;
=20
-	if ((p->flags & XFRM_STATE_ESN) && !rt)
-		return -EINVAL;
+	if (p->flags & XFRM_STATE_ESN) {
+		if (!rt)
+			return -EINVAL;
+
+		rs =3D nla_data(rt);
+
+		if (rs->bmp_len > XFRMA_REPLAY_ESN_MAX / sizeof(rs->bmp[0]) / 8)
+			return -EINVAL;
+
+		if (nla_len(rt) < xfrm_replay_state_esn_len(rs) &&
+		    nla_len(rt) !=3D sizeof(*rs))
+			return -EINVAL;
+	}
=20
 	if (!rt)
 		return 0;
@@ -370,14 +382,15 @@ static inline int xfrm_replay_verify_len(struct xfrm_=
replay_state_esn *replay_es
 					 struct nlattr *rp)
 {
 	struct xfrm_replay_state_esn *up;
+	int ulen;
=20
 	if (!replay_esn || !rp)
 		return 0;
=20
 	up =3D nla_data(rp);
+	ulen =3D xfrm_replay_state_esn_len(up);
=20
-	if (xfrm_replay_state_esn_len(replay_esn) !=3D
-			xfrm_replay_state_esn_len(up))
+	if (nla_len(rp) < ulen || xfrm_replay_state_esn_len(replay_esn) !=3D ulen=
)
 		return -EINVAL;
=20
 	return 0;
@@ -388,22 +401,28 @@ static int xfrm_alloc_replay_state_esn(struct xfrm_re=
play_state_esn **replay_esn
 				       struct nlattr *rta)
 {
 	struct xfrm_replay_state_esn *p, *pp, *up;
+	int klen, ulen;
=20
 	if (!rta)
 		return 0;
=20
 	up =3D nla_data(rta);
+	klen =3D xfrm_replay_state_esn_len(up);
+	ulen =3D nla_len(rta) >=3D klen ? klen : sizeof(*up);
=20
-	p =3D kmemdup(up, xfrm_replay_state_esn_len(up), GFP_KERNEL);
+	p =3D kzalloc(klen, GFP_KERNEL);
 	if (!p)
 		return -ENOMEM;
=20
-	pp =3D kmemdup(up, xfrm_replay_state_esn_len(up), GFP_KERNEL);
+	pp =3D kzalloc(klen, GFP_KERNEL);
 	if (!pp) {
 		kfree(p);
 		return -ENOMEM;
 	}
=20
+	memcpy(p, up, ulen);
+	memcpy(pp, up, ulen);
+
 	*replay_esn =3D p;
 	*preplay_esn =3D pp;
=20
@@ -442,10 +461,11 @@ static void copy_from_user_state(struct xfrm_state *x=
, struct xfrm_usersa_info *
  * somehow made shareable and move it to xfrm_state.c - JHS
  *
 */
-static void xfrm_update_ae_params(struct xfrm_state *x, struct nlattr **at=
trs)
+static void xfrm_update_ae_params(struct xfrm_state *x, struct nlattr **at=
trs,
+				  int update_esn)
 {
 	struct nlattr *rp =3D attrs[XFRMA_REPLAY_VAL];
-	struct nlattr *re =3D attrs[XFRMA_REPLAY_ESN_VAL];
+	struct nlattr *re =3D update_esn ? attrs[XFRMA_REPLAY_ESN_VAL] : NULL;
 	struct nlattr *lt =3D attrs[XFRMA_LTIME_VAL];
 	struct nlattr *et =3D attrs[XFRMA_ETIMER_THRESH];
 	struct nlattr *rt =3D attrs[XFRMA_REPLAY_THRESH];
@@ -555,7 +575,7 @@ static struct xfrm_state *xfrm_state_construct(struct n=
et *net,
 		goto error;
=20
 	/* override default values from above */
-	xfrm_update_ae_params(x, attrs);
+	xfrm_update_ae_params(x, attrs, 0);
=20
 	return x;
=20
@@ -689,6 +709,7 @@ out:
=20
 static void copy_to_user_state(struct xfrm_state *x, struct xfrm_usersa_in=
fo *p)
 {
+	memset(p, 0, sizeof(*p));
 	memcpy(&p->id, &x->id, sizeof(p->id));
 	memcpy(&p->sel, &x->sel, sizeof(p->sel));
 	memcpy(&p->lft, &x->lft, sizeof(p->lft));
@@ -742,7 +763,7 @@ static int copy_to_user_auth(struct xfrm_algo_auth *aut=
h, struct sk_buff *skb)
 		return -EMSGSIZE;
=20
 	algo =3D nla_data(nla);
-	strcpy(algo->alg_name, auth->alg_name);
+	strncpy(algo->alg_name, auth->alg_name, sizeof(algo->alg_name));
 	memcpy(algo->alg_key, auth->alg_key, (auth->alg_key_len + 7) / 8);
 	algo->alg_key_len =3D auth->alg_key_len;
=20
@@ -862,6 +883,7 @@ static struct sk_buff *xfrm_state_netlink(struct sk_buf=
f *in_skb,
 {
 	struct xfrm_dump_info info;
 	struct sk_buff *skb;
+	int err;
=20
 	skb =3D nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_ATOMIC);
 	if (!skb)
@@ -872,9 +894,10 @@ static struct sk_buff *xfrm_state_netlink(struct sk_bu=
ff *in_skb,
 	info.nlmsg_seq =3D seq;
 	info.nlmsg_flags =3D 0;
=20
-	if (dump_one_state(x, 0, &info)) {
+	err =3D dump_one_state(x, 0, &info);
+	if (err) {
 		kfree_skb(skb);
-		return NULL;
+		return ERR_PTR(err);
 	}
=20
 	return skb;
@@ -1297,6 +1320,7 @@ static void copy_from_user_policy(struct xfrm_policy =
*xp, struct xfrm_userpolicy
=20
 static void copy_to_user_policy(struct xfrm_policy *xp, struct xfrm_userpo=
licy_info *p, int dir)
 {
+	memset(p, 0, sizeof(*p));
 	memcpy(&p->sel, &xp->selector, sizeof(p->sel));
 	memcpy(&p->lft, &xp->lft, sizeof(p->lft));
 	memcpy(&p->curlft, &xp->curlft, sizeof(p->curlft));
@@ -1401,6 +1425,7 @@ static int copy_to_user_tmpl(struct xfrm_policy *xp, =
struct sk_buff *skb)
 		struct xfrm_user_tmpl *up =3D &vec[i];
 		struct xfrm_tmpl *kp =3D &xp->xfrm_vec[i];
=20
+		memset(up, 0, sizeof(*up));
 		memcpy(&up->id, &kp->id, sizeof(up->id));
 		up->family =3D kp->encap_family;
 		memcpy(&up->saddr, &kp->saddr, sizeof(up->saddr));
@@ -1529,6 +1554,7 @@ static struct sk_buff *xfrm_policy_netlink(struct sk_=
buff *in_skb,
 {
 	struct xfrm_dump_info info;
 	struct sk_buff *skb;
+	int err;
=20
 	skb =3D nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
 	if (!skb)
@@ -1539,9 +1565,10 @@ static struct sk_buff *xfrm_policy_netlink(struct sk=
_buff *in_skb,
 	info.nlmsg_seq =3D seq;
 	info.nlmsg_flags =3D 0;
=20
-	if (dump_one_policy(xp, dir, 0, &info) < 0) {
+	err =3D dump_one_policy(xp, dir, 0, &info);
+	if (err) {
 		kfree_skb(skb);
-		return NULL;
+		return ERR_PTR(err);
 	}
=20
 	return skb;
@@ -1794,7 +1821,7 @@ static int xfrm_new_ae(struct sk_buff *skb, struct nl=
msghdr *nlh,
 		goto out;
=20
 	spin_lock_bh(&x->lock);
-	xfrm_update_ae_params(x, attrs);
+	xfrm_update_ae_params(x, attrs, 1);
 	spin_unlock_bh(&x->lock);
=20
 	c.event =3D nlh->nlmsg_type;
diff --git a/sound/soc/samsung/dma.c b/sound/soc/samsung/dma.c
index a68b264..a9a593a 100644
--- a/sound/soc/samsung/dma.c
+++ b/sound/soc/samsung/dma.c
@@ -34,9 +34,7 @@ static const struct snd_pcm_hardware dma_hardware =3D {
 	.info			=3D SNDRV_PCM_INFO_INTERLEAVED |
 				    SNDRV_PCM_INFO_BLOCK_TRANSFER |
 				    SNDRV_PCM_INFO_MMAP |
-				    SNDRV_PCM_INFO_MMAP_VALID |
-				    SNDRV_PCM_INFO_PAUSE |
-				    SNDRV_PCM_INFO_RESUME,
+				    SNDRV_PCM_INFO_MMAP_VALID,
 	.formats		=3D SNDRV_PCM_FMTBIT_S16_LE |
 				    SNDRV_PCM_FMTBIT_U16_LE |
 				    SNDRV_PCM_FMTBIT_U8 |
@@ -246,15 +244,11 @@ static int dma_trigger(struct snd_pcm_substream *subs=
tream, int cmd)
=20
 	switch (cmd) {
 	case SNDRV_PCM_TRIGGER_START:
-	case SNDRV_PCM_TRIGGER_RESUME:
-	case SNDRV_PCM_TRIGGER_PAUSE_RELEASE:
 		prtd->state |=3D ST_RUNNING;
 		prtd->params->ops->trigger(prtd->params->ch);
 		break;
=20
 	case SNDRV_PCM_TRIGGER_STOP:
-	case SNDRV_PCM_TRIGGER_SUSPEND:
-	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
 		prtd->state &=3D ~ST_RUNNING;
 		prtd->params->ops->stop(prtd->params->ch);
 		break;


--=20
Ben Hutchings
Who are all these weirdos? - David Bowie, about L-Space IRC channel #afp

--=-4Ae8Y3kX9zhwLFu1Wf8P
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUHLPtue/yOyVhhEJAQqOyA/+Pvh2YFVxwZkaTYNCRAsnD0+VPQCVJ6Yv
y7NZqNjLQ3jC7xjX0FmVSV7FOJcWQyMEIlJRxxPGojp+417wUtW02CaRQ/fwVU1Y
fUXZbsWcO+5kiPdQY86lpAowSScTOpdkKqSzwMSN63ISGdgxgg4h1J79L+2JzvNR
Na9ZcmQO7PI8W7n+BBMcJWWqWOVwReMKasYfppsoFTfi0+FQSvhdK3T1nSQhPKSd
jxgtx0kznBgUDzwR3BMwPq1x7BMYMlUlLRKX/3tTHqOKXowj3ucTIv7lO8L3jpX8
3BtfKFeHsRLTNLLBwJxwjikVj0WvlrOx1B5gHZ2DIto8rnJb5VsRSWGAOxG3X8YO
m9qWLKUws3PSgmooeV9x7+0U9Gp37zR1LwCXave1WPmLCNjQiEnsKGm2uRs1bJVj
ffNzY22bXdoNe8jvfhcDRE7buhQl3NDCFhjj5JsRdK1lsvix62Y7G05sq7QLkAH9
Lx1JDnl79BY6foqhNH5w22Mt0Ie273QdzPqiVIHlcVUg1QFVxN1R9sx84JqiL12F
7n/vHyndsLQMxdQCzmkkCrU0rW0QOg2e4MtdnlVGFDrbaQvkSeacZicugLEVMk6c
sPrk34qFXCZcJABrypnFTIimtl1UqRZmEJHWmYnXZqg1fFLC4AMDT9I4312GtJV6
FyPxf44qhng=
=Tbev
-----END PGP SIGNATURE-----

--=-4Ae8Y3kX9zhwLFu1Wf8P--
