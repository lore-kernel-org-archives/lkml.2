Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753725Ab1HHR4N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 13:56:13 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:58772 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753540Ab1HHR4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 13:56:10 -0400
X-Sasl-enc: me5gYGFUQ+3+N6r5jNPXaMev+GynCZelnGWFjAkFkeNE 1312826169
Date: Mon, 8 Aug 2011 10:55:32 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org, lwn@lwn.net
Subject: Re: Linux 2.6.33.17
Message-ID: <20110808175532.GB16998@kroah.com>
References: <20110808175522.GA16998@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110808175522.GA16998@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index db07635..45fc26d 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 33
-EXTRAVERSION = .16
+EXTRAVERSION = .17
 NAME = Man-Eating Seals of Antiquity
 
 # *DOCUMENTATION*
diff --git a/arch/alpha/kernel/osf_sys.c b/arch/alpha/kernel/osf_sys.c
index 62619f2..a94e49c 100644
--- a/arch/alpha/kernel/osf_sys.c
+++ b/arch/alpha/kernel/osf_sys.c
@@ -431,7 +431,7 @@ SYSCALL_DEFINE2(osf_getdomainname, char __user *, name, int, namelen)
 		return -EFAULT;
 
 	len = namelen;
-	if (namelen > 32)
+	if (len > 32)
 		len = 32;
 
 	down_read(&uts_sem);
@@ -618,7 +618,7 @@ SYSCALL_DEFINE3(osf_sysinfo, int, command, char __user *, buf, long, count)
 	down_read(&uts_sem);
 	res = sysinfo_table[offset];
 	len = strlen(res)+1;
-	if (len > count)
+	if ((unsigned long)len > (unsigned long)count)
 		len = count;
 	if (copy_to_user(buf, res, len))
 		err = -EFAULT;
@@ -673,7 +673,7 @@ SYSCALL_DEFINE5(osf_getsysinfo, unsigned long, op, void __user *, buffer,
 		return 1;
 
 	case GSI_GET_HWRPB:
-		if (nbytes < sizeof(*hwrpb))
+		if (nbytes > sizeof(*hwrpb))
 			return -EINVAL;
 		if (copy_to_user(buffer, hwrpb, nbytes) != 0)
 			return -EFAULT;
@@ -1035,6 +1035,7 @@ SYSCALL_DEFINE4(osf_wait4, pid_t, pid, int __user *, ustatus, int, options,
 {
 	struct rusage r;
 	long ret, err;
+	unsigned int status = 0;
 	mm_segment_t old_fs;
 
 	if (!ur)
@@ -1043,13 +1044,15 @@ SYSCALL_DEFINE4(osf_wait4, pid_t, pid, int __user *, ustatus, int, options,
 	old_fs = get_fs();
 		
 	set_fs (KERNEL_DS);
-	ret = sys_wait4(pid, ustatus, options, (struct rusage __user *) &r);
+	ret = sys_wait4(pid, (unsigned int __user *) &status, options,
+			(struct rusage __user *) &r);
 	set_fs (old_fs);
 
 	if (!access_ok(VERIFY_WRITE, ur, sizeof(*ur)))
 		return -EFAULT;
 
 	err = 0;
+	err |= put_user(status, ustatus);
 	err |= __put_user(r.ru_utime.tv_sec, &ur->ru_utime.tv_sec);
 	err |= __put_user(r.ru_utime.tv_usec, &ur->ru_utime.tv_usec);
 	err |= __put_user(r.ru_stime.tv_sec, &ur->ru_stime.tv_sec);
diff --git a/arch/arm/mach-davinci/board-dm365-evm.c b/arch/arm/mach-davinci/board-dm365-evm.c
index b476395..a950248 100644
--- a/arch/arm/mach-davinci/board-dm365-evm.c
+++ b/arch/arm/mach-davinci/board-dm365-evm.c
@@ -453,7 +453,7 @@ fail:
 	 */
 	if (have_imager()) {
 		label = "HD imager";
-		mux |= 1;
+		mux |= 2;
 
 		/* externally mux MMC1/ENET/AIC33 to imager */
 		mux |= BIT(6) | BIT(5) | BIT(3);
@@ -474,7 +474,7 @@ fail:
 		resets &= ~BIT(1);
 
 		if (have_tvp7002()) {
-			mux |= 2;
+			mux |= 1;
 			resets &= ~BIT(2);
 			label = "tvp7002 HD";
 		} else {
diff --git a/arch/arm/mach-pxa/cm-x300.c b/arch/arm/mach-pxa/cm-x300.c
index d37cfa1..38c5cad 100644
--- a/arch/arm/mach-pxa/cm-x300.c
+++ b/arch/arm/mach-pxa/cm-x300.c
@@ -154,10 +154,10 @@ static mfp_cfg_t cm_x3xx_mfp_cfg[] __initdata = {
 	GPIO99_GPIO,			/* Ethernet IRQ */
 
 	/* RTC GPIOs */
-	GPIO95_GPIO,			/* RTC CS */
-	GPIO96_GPIO,			/* RTC WR */
-	GPIO97_GPIO,			/* RTC RD */
-	GPIO98_GPIO,			/* RTC IO */
+	GPIO95_GPIO | MFP_LPM_DRIVE_HIGH,	/* RTC CS */
+	GPIO96_GPIO | MFP_LPM_DRIVE_HIGH,	/* RTC WR */
+	GPIO97_GPIO | MFP_LPM_DRIVE_HIGH,	/* RTC RD */
+	GPIO98_GPIO,				/* RTC IO */
 
 	/* Standard I2C */
 	GPIO21_I2C_SCL,
diff --git a/arch/powerpc/kernel/crash.c b/arch/powerpc/kernel/crash.c
index 29df48f..23cbddc 100644
--- a/arch/powerpc/kernel/crash.c
+++ b/arch/powerpc/kernel/crash.c
@@ -176,12 +176,8 @@ static void crash_kexec_wait_realmode(int cpu)
 
 		while (paca[i].kexec_state < KEXEC_STATE_REAL_MODE) {
 			barrier();
-			if (!cpu_possible(i)) {
+			if (!cpu_possible(i) || !cpu_online(i) || (msecs <= 0))
 				break;
-			}
-			if (!cpu_online(i)) {
-				break;
-			}
 			msecs--;
 			mdelay(1);
 		}
diff --git a/arch/powerpc/platforms/pseries/hvconsole.c b/arch/powerpc/platforms/pseries/hvconsole.c
index 3f6a89b..041e87c 100644
--- a/arch/powerpc/platforms/pseries/hvconsole.c
+++ b/arch/powerpc/platforms/pseries/hvconsole.c
@@ -73,7 +73,7 @@ int hvc_put_chars(uint32_t vtermno, const char *buf, int count)
 	if (ret == H_SUCCESS)
 		return count;
 	if (ret == H_BUSY)
-		return 0;
+		return -EAGAIN;
 	return -EIO;
 }
 
diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 9ae9b0b..e10582c 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -27,6 +27,9 @@
 #define HPET_DEV_FSB_CAP		0x1000
 #define HPET_DEV_PERI_CAP		0x2000
 
+#define HPET_MIN_CYCLES			128
+#define HPET_MIN_PROG_DELTA		(HPET_MIN_CYCLES + (HPET_MIN_CYCLES >> 1))
+
 #define EVT_TO_HPET_DEV(evt) container_of(evt, struct hpet_dev, evt)
 
 /*
@@ -299,8 +302,9 @@ static void hpet_legacy_clockevent_register(void)
 	/* Calculate the min / max delta */
 	hpet_clockevent.max_delta_ns = clockevent_delta2ns(0x7FFFFFFF,
 							   &hpet_clockevent);
-	/* 5 usec minimum reprogramming delta. */
-	hpet_clockevent.min_delta_ns = 5000;
+	/* Setup minimum reprogramming delta. */
+	hpet_clockevent.min_delta_ns = clockevent_delta2ns(HPET_MIN_PROG_DELTA,
+							   &hpet_clockevent);
 
 	/*
 	 * Start hpet with the boot cpu mask and make it
@@ -380,36 +384,37 @@ static int hpet_next_event(unsigned long delta,
 			   struct clock_event_device *evt, int timer)
 {
 	u32 cnt;
+	s32 res;
 
 	cnt = hpet_readl(HPET_COUNTER);
 	cnt += (u32) delta;
 	hpet_writel(cnt, HPET_Tn_CMP(timer));
 
 	/*
-	 * We need to read back the CMP register on certain HPET
-	 * implementations (ATI chipsets) which seem to delay the
-	 * transfer of the compare register into the internal compare
-	 * logic. With small deltas this might actually be too late as
-	 * the counter could already be higher than the compare value
-	 * at that point and we would wait for the next hpet interrupt
-	 * forever. We found out that reading the CMP register back
-	 * forces the transfer so we can rely on the comparison with
-	 * the counter register below. If the read back from the
-	 * compare register does not match the value we programmed
-	 * then we might have a real hardware problem. We can not do
-	 * much about it here, but at least alert the user/admin with
-	 * a prominent warning.
-	 * An erratum on some chipsets (ICH9,..), results in comparator read
-	 * immediately following a write returning old value. Workaround
-	 * for this is to read this value second time, when first
-	 * read returns old value.
+	 * HPETs are a complete disaster. The compare register is
+	 * based on a equal comparison and neither provides a less
+	 * than or equal functionality (which would require to take
+	 * the wraparound into account) nor a simple count down event
+	 * mode. Further the write to the comparator register is
+	 * delayed internally up to two HPET clock cycles in certain
+	 * chipsets (ATI, ICH9,10). Some newer AMD chipsets have even
+	 * longer delays. We worked around that by reading back the
+	 * compare register, but that required another workaround for
+	 * ICH9,10 chips where the first readout after write can
+	 * return the old stale value. We already had a minimum
+	 * programming delta of 5us enforced, but a NMI or SMI hitting
+	 * between the counter readout and the comparator write can
+	 * move us behind that point easily. Now instead of reading
+	 * the compare register back several times, we make the ETIME
+	 * decision based on the following: Return ETIME if the
+	 * counter value after the write is less than HPET_MIN_CYCLES
+	 * away from the event or if the counter is already ahead of
+	 * the event. The minimum programming delta for the generic
+	 * clockevents code is set to 1.5 * HPET_MIN_CYCLES.
 	 */
-	if (unlikely((u32)hpet_readl(HPET_Tn_CMP(timer)) != cnt)) {
-		WARN_ONCE(hpet_readl(HPET_Tn_CMP(timer)) != cnt,
-		  KERN_WARNING "hpet: compare register read back failed.\n");
-	}
+	res = (s32)(cnt - hpet_readl(HPET_COUNTER));
 
-	return (s32)(hpet_readl(HPET_COUNTER) - cnt) >= 0 ? -ETIME : 0;
+	return res < HPET_MIN_CYCLES ? -ETIME : 0;
 }
 
 static void hpet_legacy_set_mode(enum clock_event_mode mode,
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index ff8cc40..7a5cb07 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -469,6 +469,14 @@ static struct dmi_system_id __initdata pci_reboot_dmi_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "iMac9,1"),
 		},
 	},
+	{	/* Handle problems with rebooting on the Latitude E5420. */
+		.callback = set_pci_reboot,
+		.ident = "Dell Latitude E5420",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Latitude E5420"),
+		},
+	},
 	{ }
 };
 
diff --git a/arch/x86/kernel/relocate_kernel_32.S b/arch/x86/kernel/relocate_kernel_32.S
index 4123553..36818f8 100644
--- a/arch/x86/kernel/relocate_kernel_32.S
+++ b/arch/x86/kernel/relocate_kernel_32.S
@@ -97,6 +97,8 @@ relocate_kernel:
 	ret
 
 identity_mapped:
+	/* set return address to 0 if not preserving context */
+	pushl	$0
 	/* store the start address on the stack */
 	pushl   %edx
 
diff --git a/arch/x86/kernel/relocate_kernel_64.S b/arch/x86/kernel/relocate_kernel_64.S
index 4de8f5b..7a6f3b3 100644
--- a/arch/x86/kernel/relocate_kernel_64.S
+++ b/arch/x86/kernel/relocate_kernel_64.S
@@ -100,6 +100,8 @@ relocate_kernel:
 	ret
 
 identity_mapped:
+	/* set return address to 0 if not preserving context */
+	pushq	$0
 	/* store the start address on the stack */
 	pushq   %rdx
 
diff --git a/arch/xtensa/kernel/ptrace.c b/arch/xtensa/kernel/ptrace.c
index 9486882..885ebe7 100644
--- a/arch/xtensa/kernel/ptrace.c
+++ b/arch/xtensa/kernel/ptrace.c
@@ -136,6 +136,9 @@ int ptrace_setxregs(struct task_struct *child, void __user *uregs)
 	elf_xtregs_t *xtregs = uregs;
 	int ret = 0;
 
+	if (!access_ok(VERIFY_READ, uregs, sizeof(elf_xtregs_t)))
+		return -EFAULT;
+
 #if XTENSA_HAVE_COPROCESSORS
 	/* Flush all coprocessors before we overwrite them. */
 	coprocessor_flush_all(ti);
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 228740f..17a69bf 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -2716,10 +2716,11 @@ int ata_eh_reset(struct ata_link *link, int classify,
 	}
 
 	/*
-	 * Some controllers can't be frozen very well and may set
-	 * spuruious error conditions during reset.  Clear accumulated
-	 * error information.  As reset is the final recovery action,
-	 * nothing is lost by doing this.
+	 * Some controllers can't be frozen very well and may set spurious
+	 * error conditions during reset.  Clear accumulated error
+	 * information and re-thaw the port if frozen.  As reset is the
+	 * final recovery action and we cross check link onlineness against
+	 * device classification later, no hotplug event is lost by this.
 	 */
 	spin_lock_irqsave(link->ap->lock, flags);
 	memset(&link->eh_info, 0, sizeof(link->eh_info));
@@ -2728,6 +2729,9 @@ int ata_eh_reset(struct ata_link *link, int classify,
 	ap->pflags &= ~ATA_PFLAG_EH_PENDING;
 	spin_unlock_irqrestore(link->ap->lock, flags);
 
+	if (ap->pflags & ATA_PFLAG_FROZEN)
+		ata_eh_thaw_port(ap);
+
 	/*
 	 * Make sure onlineness and classification result correspond.
 	 * Hotplug could have happened during reset and some
diff --git a/drivers/block/cciss.h b/drivers/block/cciss.h
index b8901ff..658b617 100644
--- a/drivers/block/cciss.h
+++ b/drivers/block/cciss.h
@@ -181,7 +181,7 @@ static void SA5_submit_command( ctlr_info_t *h, CommandList_struct *c)
 	 printk("Sending %x - down to controller\n", c->busaddr );
 #endif /* CCISS_DEBUG */ 
          writel(c->busaddr, h->vaddr + SA5_REQUEST_PORT_OFFSET);
-	readl(h->vaddr + SA5_REQUEST_PORT_OFFSET);
+	readl(h->vaddr + SA5_SCRATCHPAD_OFFSET);
 	 h->commands_outstanding++;
 	 if ( h->commands_outstanding > h->max_outstanding)
 		h->max_outstanding = h->commands_outstanding;
diff --git a/drivers/hwmon/asus_atk0110.c b/drivers/hwmon/asus_atk0110.c
index 028284f..fff2446 100644
--- a/drivers/hwmon/asus_atk0110.c
+++ b/drivers/hwmon/asus_atk0110.c
@@ -654,6 +654,7 @@ static int atk_debugfs_gitm_get(void *p, u64 *val)
 	else
 		err = -EIO;
 
+	ACPI_FREE(ret);
 	return err;
 }
 
diff --git a/drivers/hwmon/max1111.c b/drivers/hwmon/max1111.c
index 9ac4972..5b6001b 100644
--- a/drivers/hwmon/max1111.c
+++ b/drivers/hwmon/max1111.c
@@ -39,6 +39,8 @@ struct max1111_data {
 	struct spi_transfer	xfer[2];
 	uint8_t *tx_buf;
 	uint8_t *rx_buf;
+	struct mutex		drvdata_lock;
+	/* protect msg, xfer and buffers from multiple access */
 };
 
 static int max1111_read(struct device *dev, int channel)
@@ -47,6 +49,9 @@ static int max1111_read(struct device *dev, int channel)
 	uint8_t v1, v2;
 	int err;
 
+	/* writing to drvdata struct is not thread safe, wait on mutex */
+	mutex_lock(&data->drvdata_lock);
+
 	data->tx_buf[0] = (channel << MAX1111_CTRL_SEL_SH) |
 		MAX1111_CTRL_PD0 | MAX1111_CTRL_PD1 |
 		MAX1111_CTRL_SGL | MAX1111_CTRL_UNI | MAX1111_CTRL_STR;
@@ -54,12 +59,15 @@ static int max1111_read(struct device *dev, int channel)
 	err = spi_sync(data->spi, &data->msg);
 	if (err < 0) {
 		dev_err(dev, "spi_sync failed with %d\n", err);
+		mutex_unlock(&data->drvdata_lock);
 		return err;
 	}
 
 	v1 = data->rx_buf[0];
 	v2 = data->rx_buf[1];
 
+	mutex_unlock(&data->drvdata_lock);
+
 	if ((v1 & 0xc0) || (v2 & 0x3f))
 		return -EINVAL;
 
@@ -175,6 +183,8 @@ static int __devinit max1111_probe(struct spi_device *spi)
 	if (err)
 		goto err_free_data;
 
+	mutex_init(&data->drvdata_lock);
+
 	data->spi = spi;
 	spi_set_drvdata(spi, data);
 
@@ -212,6 +222,7 @@ static int __devexit max1111_remove(struct spi_device *spi)
 
 	hwmon_device_unregister(data->hwmon_dev);
 	sysfs_remove_group(&spi->dev.kobj, &max1111_attr_group);
+	mutex_destroy(&data->drvdata_lock);
 	kfree(data->rx_buf);
 	kfree(data->tx_buf);
 	kfree(data);
diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index d43e186..a1f088b 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -782,6 +782,11 @@ static int parse_features(struct arg_set *as, struct multipath *m)
 	if (!argc)
 		return 0;
 
+	if (argc > as->argc) {
+		ti->error = "not enough arguments for features";
+		return -EINVAL;
+	}
+
 	do {
 		param_name = shift(as);
 		argc--;
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 2e41d5e..99f0602 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -36,6 +36,8 @@ static const char *_name = DM_NAME;
 static unsigned int major = 0;
 static unsigned int _major = 0;
 
+static DEFINE_IDR(_minor_idr);
+
 static DEFINE_SPINLOCK(_minor_lock);
 /*
  * For bio-based dm.
@@ -324,6 +326,12 @@ static void __exit dm_exit(void)
 
 	while (i--)
 		_exits[i]();
+
+	/*
+	 * Should be empty by this point.
+	 */
+	idr_remove_all(&_minor_idr);
+	idr_destroy(&_minor_idr);
 }
 
 /*
@@ -1772,8 +1780,6 @@ static int dm_any_congested(void *congested_data, int bdi_bits)
 /*-----------------------------------------------------------------
  * An IDR is used to keep track of allocated minor numbers.
  *---------------------------------------------------------------*/
-static DEFINE_IDR(_minor_idr);
-
 static void free_minor(int minor)
 {
 	spin_lock(&_minor_lock);
diff --git a/drivers/media/radio/si4713-i2c.c b/drivers/media/radio/si4713-i2c.c
index 6a0028e..93653c6 100644
--- a/drivers/media/radio/si4713-i2c.c
+++ b/drivers/media/radio/si4713-i2c.c
@@ -1003,7 +1003,7 @@ static int si4713_write_econtrol_string(struct si4713_device *sdev,
 		char ps_name[MAX_RDS_PS_NAME + 1];
 
 		len = control->size - 1;
-		if (len > MAX_RDS_PS_NAME) {
+		if (len < 0 || len > MAX_RDS_PS_NAME) {
 			rval = -ERANGE;
 			goto exit;
 		}
@@ -1025,7 +1025,7 @@ static int si4713_write_econtrol_string(struct si4713_device *sdev,
 		char radio_text[MAX_RDS_RADIO_TEXT + 1];
 
 		len = control->size - 1;
-		if (len > MAX_RDS_RADIO_TEXT) {
+		if (len < 0 || len > MAX_RDS_RADIO_TEXT) {
 			rval = -ERANGE;
 			goto exit;
 		}
diff --git a/drivers/media/video/bt8xx/bttv-driver.c b/drivers/media/video/bt8xx/bttv-driver.c
index ae08b07..41594ea 100644
--- a/drivers/media/video/bt8xx/bttv-driver.c
+++ b/drivers/media/video/bt8xx/bttv-driver.c
@@ -3526,7 +3526,7 @@ static int radio_s_tuner(struct file *file, void *priv,
 	if (0 != t->index)
 		return -EINVAL;
 
-	bttv_call_all(btv, tuner, g_tuner, t);
+	bttv_call_all(btv, tuner, s_tuner, t);
 	return 0;
 }
 
diff --git a/drivers/media/video/pvrusb2/pvrusb2-hdw.c b/drivers/media/video/pvrusb2/pvrusb2-hdw.c
index 1bbdab0..dd99414 100644
--- a/drivers/media/video/pvrusb2/pvrusb2-hdw.c
+++ b/drivers/media/video/pvrusb2/pvrusb2-hdw.c
@@ -3015,6 +3015,8 @@ static void pvr2_subdev_update(struct pvr2_hdw *hdw)
 	if (hdw->input_dirty || hdw->audiomode_dirty || hdw->force_dirty) {
 		struct v4l2_tuner vt;
 		memset(&vt, 0, sizeof(vt));
+		vt.type = (hdw->input_val == PVR2_CVAL_INPUT_RADIO) ?
+			V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
 		vt.audmode = hdw->audiomode_val;
 		v4l2_device_call_all(&hdw->v4l2_dev, 0, tuner, s_tuner, &vt);
 	}
@@ -5101,6 +5103,8 @@ void pvr2_hdw_status_poll(struct pvr2_hdw *hdw)
 {
 	struct v4l2_tuner *vtp = &hdw->tuner_signal_info;
 	memset(vtp, 0, sizeof(*vtp));
+	vtp->type = (hdw->input_val == PVR2_CVAL_INPUT_RADIO) ?
+		V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
 	hdw->tuner_signal_stale = 0;
 	/* Note: There apparently is no replacement for VIDIOC_CROPCAP
 	   using v4l2-subdev - therefore we can't support that AT ALL right
diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index 4b11257..0f97ff8 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -1632,6 +1632,8 @@ static long __video_do_ioctl(struct file *file,
 		if (!ops->vidioc_g_tuner)
 			break;
 
+		p->type = (vfd->vfl_type == VFL_TYPE_RADIO) ?
+			V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
 		ret = ops->vidioc_g_tuner(file, fh, p);
 		if (!ret)
 			dbgarg(cmd, "index=%d, name=%s, type=%d, "
@@ -1650,6 +1652,8 @@ static long __video_do_ioctl(struct file *file,
 
 		if (!ops->vidioc_s_tuner)
 			break;
+		p->type = (vfd->vfl_type == VFL_TYPE_RADIO) ?
+			V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
 		dbgarg(cmd, "index=%d, name=%s, type=%d, "
 				"capability=0x%x, rangelow=%d, "
 				"rangehigh=%d, signal=%d, afc=%d, "
@@ -1668,6 +1672,8 @@ static long __video_do_ioctl(struct file *file,
 		if (!ops->vidioc_g_frequency)
 			break;
 
+		p->type = (vfd->vfl_type == VFL_TYPE_RADIO) ?
+			V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
 		ret = ops->vidioc_g_frequency(file, fh, p);
 		if (!ret)
 			dbgarg(cmd, "tuner=%d, type=%d, frequency=%d\n",
diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index e3551d2..ce97078 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -189,8 +189,7 @@ config SGI_XP
 
 config CS5535_MFGPT
 	tristate "CS5535/CS5536 Geode Multi-Function General Purpose Timer (MFGPT) support"
-	depends on PCI
-	depends on X86
+	depends on PCI && X86 && MFD_CS5535
 	default n
 	help
 	  This driver provides access to MFGPT functionality for other
diff --git a/drivers/net/jme.c b/drivers/net/jme.c
index 981c9fb..2590534 100644
--- a/drivers/net/jme.c
+++ b/drivers/net/jme.c
@@ -681,20 +681,28 @@ jme_make_new_rx_buf(struct jme_adapter *jme, int i)
 	struct jme_ring *rxring = &(jme->rxring[0]);
 	struct jme_buffer_info *rxbi = rxring->bufinf + i;
 	struct sk_buff *skb;
+	dma_addr_t mapping;
 
 	skb = netdev_alloc_skb(jme->dev,
 		jme->dev->mtu + RX_EXTRA_LEN);
 	if (unlikely(!skb))
 		return -ENOMEM;
 
+	mapping = pci_map_page(jme->pdev, virt_to_page(skb->data),
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
 	rxbi->skb = skb;
 	rxbi->len = skb_tailroom(skb);
-	rxbi->mapping = pci_map_page(jme->pdev,
-					virt_to_page(skb->data),
-					offset_in_page(skb->data),
-					rxbi->len,
-					PCI_DMA_FROMDEVICE);
-
+	rxbi->mapping = mapping;
 	return 0;
 }
 
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index b8eb5e7..5e25102 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1528,7 +1528,7 @@ void pci_enable_ari(struct pci_dev *dev)
 {
 	int pos;
 	u32 cap;
-	u16 ctrl;
+	u16 flags, ctrl;
 	struct pci_dev *bridge;
 
 	if (!pci_is_pcie(dev) || dev->devfn)
@@ -1546,6 +1546,11 @@ void pci_enable_ari(struct pci_dev *dev)
 	if (!pos)
 		return;
 
+	/* ARI is a PCIe v2 feature */
+	pci_read_config_word(bridge, pos + PCI_EXP_FLAGS, &flags);
+	if ((flags & PCI_EXP_FLAGS_VERS) < 2)
+		return;
+
 	pci_read_config_dword(bridge, pos + PCI_EXP_DEVCAP2, &cap);
 	if (!(cap & PCI_EXP_DEVCAP2_ARI))
 		return;
diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 33cf988..4f43306 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -840,6 +840,9 @@ static struct domain_device *sas_ex_discover_expander(
 
 	res = sas_discover_expander(child);
 	if (res) {
+		spin_lock_irq(&parent->port->dev_list_lock);
+		list_del(&child->dev_list_node);
+		spin_unlock_irq(&parent->port->dev_list_lock);
 		kfree(child);
 		return NULL;
 	}
diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index 2dc225e..4372723 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -3576,6 +3576,9 @@ static long pmcraid_ioctl_passthrough(
 			pmcraid_err("couldn't build passthrough ioadls\n");
 			goto out_free_buffer;
 		}
+	} else if (request_size < 0) {
+		rc = -EINVAL;
+		goto out_free_buffer;
 	}
 
 	/* If data is being written into the device, copy the data from user
diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index 37af178..f6926c1 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -196,6 +196,7 @@ static struct {
 	{"IBM", "ProFibre 4000R", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
 	{"IBM", "2105", NULL, BLIST_RETRY_HWERROR},
 	{"iomega", "jaz 1GB", "J.86", BLIST_NOTQ | BLIST_NOLUN},
+	{"IOMEGA", "ZIP", NULL, BLIST_NOTQ | BLIST_NOLUN},
 	{"IOMEGA", "Io20S         *F", NULL, BLIST_KEY},
 	{"INSITE", "Floptical   F*8I", NULL, BLIST_KEY},
 	{"INSITE", "I325VM", NULL, BLIST_KEY},
@@ -242,6 +243,7 @@ static struct {
 	{"Tornado-", "F4", "*", BLIST_NOREPORTLUN},
 	{"TOSHIBA", "CDROM", NULL, BLIST_ISROM},
 	{"TOSHIBA", "CD-ROM", NULL, BLIST_ISROM},
+	{"Traxdata", "CDR4120", NULL, BLIST_NOLUN},	/* locks up */
 	{"USB2.0", "SMARTMEDIA/XD", NULL, BLIST_FORCELUN | BLIST_INQUIRY_36},
 	{"WangDAT", "Model 2600", "01.7", BLIST_SELECT_NO_ATN},
 	{"WangDAT", "Model 3200", "02.2", BLIST_SELECT_NO_ATN},
diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index 3b082dd..340124d 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -157,6 +157,10 @@ static unsigned char *ses_get_page2_descriptor(struct enclosure_device *edev,
 	return NULL;
 }
 
+/* For device slot and array device slot elements, byte 3 bit 6
+ * is "fault sensed" while byte 3 bit 5 is "fault reqstd". As this
+ * code stands these bits are shifted 4 positions right so in
+ * sysfs they will appear as bits 2 and 1 respectively. Strange. */
 static void ses_get_fault(struct enclosure_device *edev,
 			  struct enclosure_component *ecomp)
 {
@@ -178,7 +182,7 @@ static int ses_set_fault(struct enclosure_device *edev,
 		/* zero is disabled */
 		break;
 	case ENCLOSURE_SETTING_ENABLED:
-		desc[2] = 0x02;
+		desc[3] = 0x20;
 		break;
 	default:
 		/* SES doesn't do the SGPIO blink settings */
diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
index 8117748..18610b0 100644
--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -362,8 +362,8 @@ static int do_devinfo_ioctl(struct comedi_device *dev,
 	/* fill devinfo structure */
 	devinfo.version_code = COMEDI_VERSION_CODE;
 	devinfo.n_subdevs = dev->n_subdevices;
-	memcpy(devinfo.driver_name, dev->driver->driver_name, COMEDI_NAMELEN);
-	memcpy(devinfo.board_name, dev->board_name, COMEDI_NAMELEN);
+	strlcpy(devinfo.driver_name, dev->driver->driver_name, COMEDI_NAMELEN);
+	strlcpy(devinfo.board_name, dev->board_name, COMEDI_NAMELEN);
 
 	if (read_subdev)
 		devinfo.read_subdevice = read_subdev - dev->subdevices;
diff --git a/drivers/usb/gadget/dummy_hcd.c b/drivers/usb/gadget/dummy_hcd.c
index 5e09664..7adb671 100644
--- a/drivers/usb/gadget/dummy_hcd.c
+++ b/drivers/usb/gadget/dummy_hcd.c
@@ -1886,6 +1886,7 @@ static int dummy_hcd_probe(struct platform_device *pdev)
 	if (!hcd)
 		return -ENOMEM;
 	the_controller = hcd_to_dummy (hcd);
+	hcd->has_tt = 1;
 
 	retval = usb_add_hcd(hcd, 0, 0);
 	if (retval != 0) {
diff --git a/drivers/usb/host/ehci-hub.c b/drivers/usb/host/ehci-hub.c
index ec45293..131fce2 100644
--- a/drivers/usb/host/ehci-hub.c
+++ b/drivers/usb/host/ehci-hub.c
@@ -760,10 +760,11 @@ static int ehci_hub_control (
 			 * power switching; they're allowed to just limit the
 			 * current.  khubd will turn the power back on.
 			 */
-			if (HCS_PPC (ehci->hcs_params)){
+			if ((temp & PORT_OC) && HCS_PPC(ehci->hcs_params)) {
 				ehci_writel(ehci,
 					temp & ~(PORT_RWC_BITS | PORT_POWER),
 					status_reg);
+				temp = ehci_readl(ehci, status_reg);
 			}
 		}
 
diff --git a/drivers/usb/host/ehci-q.c b/drivers/usb/host/ehci-q.c
index 781c573..9b46a1e 100644
--- a/drivers/usb/host/ehci-q.c
+++ b/drivers/usb/host/ehci-q.c
@@ -103,7 +103,7 @@ qh_update (struct ehci_hcd *ehci, struct ehci_qh *qh, struct ehci_qtd *qtd)
 	if (!(hw->hw_info1 & cpu_to_hc32(ehci, 1 << 14))) {
 		unsigned	is_out, epnum;
 
-		is_out = !(qtd->hw_token & cpu_to_hc32(ehci, 1 << 8));
+		is_out = qh->is_out;
 		epnum = (hc32_to_cpup(ehci, &hw->hw_info1) >> 8) & 0x0f;
 		if (unlikely (!usb_gettoggle (qh->dev, epnum, is_out))) {
 			hw->hw_token &= ~cpu_to_hc32(ehci, QTD_TOGGLE);
@@ -945,6 +945,7 @@ done:
 	hw = qh->hw;
 	hw->hw_info1 = cpu_to_hc32(ehci, info1);
 	hw->hw_info2 = cpu_to_hc32(ehci, info2);
+	qh->is_out = !is_input;
 	usb_settoggle (urb->dev, usb_pipeendpoint (urb->pipe), !is_input, 1);
 	qh_refresh (ehci, qh);
 	return qh;
diff --git a/drivers/usb/host/ehci.h b/drivers/usb/host/ehci.h
index 556c0b4..e7c406e 100644
--- a/drivers/usb/host/ehci.h
+++ b/drivers/usb/host/ehci.h
@@ -365,6 +365,7 @@ struct ehci_qh {
 #define NO_FRAME ((unsigned short)~0)			/* pick new start */
 
 	struct usb_device	*dev;		/* access to TT */
+	unsigned		is_out:1;	/* bulk or intr OUT */
 	unsigned		clearing_tt:1;	/* Clear-TT-Buf in progress */
 };
 
diff --git a/drivers/usb/musb/musb_core.c b/drivers/usb/musb/musb_core.c
index e176a06..2413c0f 100644
--- a/drivers/usb/musb/musb_core.c
+++ b/drivers/usb/musb/musb_core.c
@@ -1640,6 +1640,7 @@ void musb_dma_completion(struct musb *musb, u8 epnum, u8 transmit)
 			}
 		}
 	}
+	musb_writeb(musb_base, MUSB_INDEX, musb->context.index);
 }
 
 #else
diff --git a/drivers/usb/serial/pl2303.c b/drivers/usb/serial/pl2303.c
index 3ebbddd..6849ca6 100644
--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -99,6 +99,8 @@ static struct usb_device_id id_table [] = {
 	{ USB_DEVICE(CRESSI_VENDOR_ID, CRESSI_EDY_PRODUCT_ID) },
 	{ USB_DEVICE(SONY_VENDOR_ID, SONY_QN3USB_PRODUCT_ID) },
 	{ USB_DEVICE(SANWA_VENDOR_ID, SANWA_PRODUCT_ID) },
+	{ USB_DEVICE(ADLINK_VENDOR_ID, ADLINK_ND6530_PRODUCT_ID) },
+	{ USB_DEVICE(WINCHIPHEAD_VENDOR_ID, WINCHIPHEAD_USBSER_PRODUCT_ID) },
 	{ }					/* Terminating entry */
 };
 
diff --git a/drivers/usb/serial/pl2303.h b/drivers/usb/serial/pl2303.h
index a5c94a4..e854fb0 100644
--- a/drivers/usb/serial/pl2303.h
+++ b/drivers/usb/serial/pl2303.h
@@ -5,7 +5,7 @@
  *	it under the terms of the GNU General Public License as published by
  *	the Free Software Foundation; either version 2 of the License, or
  *	(at your option) any later version.
- * 
+ *
  */
 
 #define BENQ_VENDOR_ID			0x04a5
@@ -136,3 +136,11 @@
 /* Sanwa KB-USB2 multimeter cable (ID: 11ad:0001) */
 #define SANWA_VENDOR_ID		0x11ad
 #define SANWA_PRODUCT_ID	0x0001
+
+/* ADLINK ND-6530 RS232,RS485 and RS422 adapter */
+#define ADLINK_VENDOR_ID		0x0b63
+#define ADLINK_ND6530_PRODUCT_ID	0x6530
+
+/* WinChipHead USB->RS 232 adapter */
+#define WINCHIPHEAD_VENDOR_ID		0x4348
+#define WINCHIPHEAD_USBSER_PRODUCT_ID	0x5523
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 5d8d311..8db62b2 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1211,7 +1211,6 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, int for_part)
 			if (!bdev->bd_part)
 				goto out_clear;
 
-			ret = 0;
 			if (disk->fops->open) {
 				ret = disk->fops->open(bdev, mode);
 				if (ret == -ERESTARTSYS) {
@@ -1227,18 +1226,9 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, int for_part)
 					mutex_unlock(&bdev->bd_mutex);
 					goto restart;
 				}
+				if (ret)
+					goto out_clear;
 			}
-			/*
-			 * If the device is invalidated, rescan partition
-			 * if open succeeded or failed with -ENOMEDIUM.
-			 * The latter is necessary to prevent ghost
-			 * partitions on a removed medium.
-			 */
-			if (bdev->bd_invalidated && (!ret || ret == -ENOMEDIUM))
-				rescan_partitions(disk, bdev);
-			if (ret)
-				goto out_clear;
-
 			if (!bdev->bd_openers) {
 				bd_set_size(bdev,(loff_t)get_capacity(disk)<<9);
 				bdi = blk_get_backing_dev_info(bdev);
@@ -1246,6 +1236,8 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, int for_part)
 					bdi = &default_backing_dev_info;
 				bdev->bd_inode->i_data.backing_dev_info = bdi;
 			}
+			if (bdev->bd_invalidated)
+				rescan_partitions(disk, bdev);
 		} else {
 			struct block_device *whole;
 			whole = bdget_disk(disk, 0);
@@ -1272,14 +1264,13 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, int for_part)
 		put_disk(disk);
 		disk = NULL;
 		if (bdev->bd_contains == bdev) {
-			ret = 0;
-			if (bdev->bd_disk->fops->open)
+			if (bdev->bd_disk->fops->open) {
 				ret = bdev->bd_disk->fops->open(bdev, mode);
-			/* the same as first opener case, read comment there */
-			if (bdev->bd_invalidated && (!ret || ret == -ENOMEDIUM))
+				if (ret)
+					goto out_unlock_bdev;
+			}
+			if (bdev->bd_invalidated)
 				rescan_partitions(bdev->bd_disk, bdev);
-			if (ret)
-				goto out_unlock_bdev;
 		}
 	}
 	bdev->bd_openers++;
diff --git a/fs/ext3/xattr.c b/fs/ext3/xattr.c
index 66895cc..bea1209 100644
--- a/fs/ext3/xattr.c
+++ b/fs/ext3/xattr.c
@@ -803,8 +803,16 @@ inserted:
 			/* We need to allocate a new block */
 			ext3_fsblk_t goal = ext3_group_first_block_no(sb,
 						EXT3_I(inode)->i_block_group);
-			ext3_fsblk_t block = ext3_new_block(handle, inode,
-							goal, &error);
+			ext3_fsblk_t block;
+
+			/*
+			 * Protect us agaist concurrent allocations to the
+			 * same inode from ext3_..._writepage(). Reservation
+			 * code does not expect racing allocations.
+			 */
+			mutex_lock(&EXT3_I(inode)->truncate_mutex);
+			block = ext3_new_block(handle, inode, goal, &error);
+			mutex_unlock(&EXT3_I(inode)->truncate_mutex);
 			if (error)
 				goto cleanup;
 			ea_idebug(inode, "creating block %d", block);
diff --git a/fs/proc/base.c b/fs/proc/base.c
index 65053a1..3f14afff 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2519,6 +2519,9 @@ static int do_io_accounting(struct task_struct *task, char *buffer, int whole)
 	struct task_io_accounting acct = task->ioac;
 	unsigned long flags;
 
+	if (!ptrace_may_access(task, PTRACE_MODE_READ))
+		return -EACCES;
+
 	if (whole && lock_task_sighand(task, &flags)) {
 		struct task_struct *t = task;
 
@@ -2641,7 +2644,7 @@ static const struct pid_entry tgid_base_stuff[] = {
 	REG("coredump_filter", S_IRUGO|S_IWUSR, proc_coredump_filter_operations),
 #endif
 #ifdef CONFIG_TASK_IO_ACCOUNTING
-	INF("io",	S_IRUGO, proc_tgid_io_accounting),
+	INF("io",	S_IRUSR, proc_tgid_io_accounting),
 #endif
 };
 
@@ -2977,7 +2980,7 @@ static const struct pid_entry tid_base_stuff[] = {
 	REG("make-it-fail", S_IRUGO|S_IWUSR, proc_fault_inject_operations),
 #endif
 #ifdef CONFIG_TASK_IO_ACCOUNTING
-	INF("io",	S_IRUGO, proc_tid_io_accounting),
+	INF("io",	S_IRUSR, proc_tid_io_accounting),
 #endif
 };
 
diff --git a/include/drm/i915_drm.h b/include/drm/i915_drm.h
index b64a8d7..1c3b291 100644
--- a/include/drm/i915_drm.h
+++ b/include/drm/i915_drm.h
@@ -227,7 +227,7 @@ typedef struct _drm_i915_sarea {
 #define DRM_IOCTL_I915_GEM_GET_APERTURE	DRM_IOR  (DRM_COMMAND_BASE + DRM_I915_GEM_GET_APERTURE, struct drm_i915_gem_get_aperture)
 #define DRM_IOCTL_I915_GET_PIPE_FROM_CRTC_ID DRM_IOWR(DRM_COMMAND_BASE + DRM_I915_GET_PIPE_FROM_CRTC_ID, struct drm_i915_get_pipe_from_crtc_id)
 #define DRM_IOCTL_I915_GEM_MADVISE	DRM_IOWR(DRM_COMMAND_BASE + DRM_I915_GEM_MADVISE, struct drm_i915_gem_madvise)
-#define DRM_IOCTL_I915_OVERLAY_PUT_IMAGE	DRM_IOW(DRM_COMMAND_BASE + DRM_IOCTL_I915_OVERLAY_ATTRS, struct drm_intel_overlay_put_image)
+#define DRM_IOCTL_I915_OVERLAY_PUT_IMAGE	DRM_IOW(DRM_COMMAND_BASE + DRM_I915_OVERLAY_PUT_IMAGE, struct drm_intel_overlay_put_image)
 #define DRM_IOCTL_I915_OVERLAY_ATTRS	DRM_IOWR(DRM_COMMAND_BASE + DRM_I915_OVERLAY_ATTRS, struct drm_intel_overlay_attrs)
 
 /* Allow drivers to submit batchbuffers directly to hardware, relying
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 992c700..6782a1e 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1226,9 +1226,12 @@ static inline int skb_gro_header_hard(struct sk_buff *skb, unsigned int hlen)
 static inline void *skb_gro_header_slow(struct sk_buff *skb, unsigned int hlen,
 					unsigned int offset)
 {
+	if (!pskb_may_pull(skb, hlen))
+		return NULL;
+
 	NAPI_GRO_CB(skb)->frag0 = NULL;
 	NAPI_GRO_CB(skb)->frag0_len = 0;
-	return pskb_may_pull(skb, hlen) ? skb->data + offset : NULL;
+	return skb->data + offset;
 }
 
 static inline void *skb_gro_mac_header(struct sk_buff *skb)
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 2114e45..8567d47 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -75,6 +75,7 @@ struct net_bridge_port
 	bridge_id			designated_bridge;
 	u32				path_cost;
 	u32				designated_cost;
+	unsigned long			designated_age;
 
 	struct timer_list		forward_delay_timer;
 	struct timer_list		hold_timer;
diff --git a/net/bridge/br_stp.c b/net/bridge/br_stp.c
index fd3f8d6..c7d6bfc 100644
--- a/net/bridge/br_stp.c
+++ b/net/bridge/br_stp.c
@@ -165,8 +165,7 @@ void br_transmit_config(struct net_bridge_port *p)
 	else {
 		struct net_bridge_port *root
 			= br_get_port(br, br->root_port);
-		bpdu.message_age = br->max_age
-			- (root->message_age_timer.expires - jiffies)
+		bpdu.message_age = (jiffies - root->designated_age)
 			+ MESSAGE_AGE_INCR;
 	}
 	bpdu.max_age = br->max_age;
@@ -190,6 +189,7 @@ static inline void br_record_config_information(struct net_bridge_port *p,
 	p->designated_cost = bpdu->root_path_cost;
 	p->designated_bridge = bpdu->bridge_id;
 	p->designated_port = bpdu->port_id;
+	p->designated_age = jiffies + bpdu->message_age;
 
 	mod_timer(&p->message_age_timer, jiffies
 		  + (p->br->max_age - bpdu->message_age));
diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index aa70db1..f8b72db 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -1667,14 +1667,15 @@ static int __init ipgre_init(void)
 
 	printk(KERN_INFO "GRE over IPv4 tunneling driver\n");
 
-	if (inet_add_protocol(&ipgre_protocol, IPPROTO_GRE) < 0) {
-		printk(KERN_INFO "ipgre init: can't add protocol\n");
-		return -EAGAIN;
-	}
-
 	err = register_pernet_device(&ipgre_net_ops);
 	if (err < 0)
-		goto gen_device_failed;
+		return err;
+
+	err = inet_add_protocol(&ipgre_protocol, IPPROTO_GRE);
+	if (err < 0) {
+		printk(KERN_INFO "ipgre init: can't add protocol\n");
+		goto add_proto_failed;
+	}
 
 	err = rtnl_link_register(&ipgre_link_ops);
 	if (err < 0)
@@ -1690,9 +1691,9 @@ out:
 tap_ops_failed:
 	rtnl_link_unregister(&ipgre_link_ops);
 rtnl_link_failed:
-	unregister_pernet_device(&ipgre_net_ops);
-gen_device_failed:
 	inet_del_protocol(&ipgre_protocol, IPPROTO_GRE);
+add_proto_failed:
+	unregister_pernet_device(&ipgre_net_ops);
 	goto out;
 }
 
@@ -1700,9 +1701,9 @@ static void __exit ipgre_fini(void)
 {
 	rtnl_link_unregister(&ipgre_tap_ops);
 	rtnl_link_unregister(&ipgre_link_ops);
-	unregister_pernet_device(&ipgre_net_ops);
 	if (inet_del_protocol(&ipgre_protocol, IPPROTO_GRE) < 0)
 		printk(KERN_INFO "ipgre close: can't remove protocol\n");
+	unregister_pernet_device(&ipgre_net_ops);
 }
 
 module_init(ipgre_init);
diff --git a/net/ipv6/xfrm6_tunnel.c b/net/ipv6/xfrm6_tunnel.c
index 438831d..23fb100 100644
--- a/net/ipv6/xfrm6_tunnel.c
+++ b/net/ipv6/xfrm6_tunnel.c
@@ -353,13 +353,19 @@ static struct xfrm6_tunnel xfrm46_tunnel_handler = {
 
 static int __init xfrm6_tunnel_init(void)
 {
-	if (xfrm_register_type(&xfrm6_tunnel_type, AF_INET6) < 0)
+	int rv;
+
+	rv = xfrm_register_type(&xfrm6_tunnel_type, AF_INET6);
+	if (rv < 0)
 		goto err;
-	if (xfrm6_tunnel_register(&xfrm6_tunnel_handler, AF_INET6))
+	rv = xfrm6_tunnel_register(&xfrm6_tunnel_handler, AF_INET6);
+	if (rv < 0)
 		goto unreg;
-	if (xfrm6_tunnel_register(&xfrm46_tunnel_handler, AF_INET))
+	rv = xfrm6_tunnel_register(&xfrm46_tunnel_handler, AF_INET);
+	if (rv < 0)
 		goto dereg6;
-	if (xfrm6_tunnel_spi_init() < 0)
+	rv = xfrm6_tunnel_spi_init();
+	if (rv < 0)
 		goto dereg46;
 	return 0;
 
@@ -370,7 +376,7 @@ dereg6:
 unreg:
 	xfrm_unregister_type(&xfrm6_tunnel_type, AF_INET6);
 err:
-	return -EAGAIN;
+	return rv;
 }
 
 static void __exit xfrm6_tunnel_fini(void)
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index ecc1e4f..f65942f 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2318,6 +2318,9 @@ void ieee80211_sta_restart(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 
+	if (!ifmgd->associated)
+		return;
+
 	if (test_and_clear_bit(TMR_RUNNING_TIMER, &ifmgd->timers_running))
 		add_timer(&ifmgd->timer);
 	if (test_and_clear_bit(TMR_RUNNING_CHANSW, &ifmgd->timers_running))
diff --git a/net/sunrpc/rpcb_clnt.c b/net/sunrpc/rpcb_clnt.c
index 3e3772d..4ac622d 100644
--- a/net/sunrpc/rpcb_clnt.c
+++ b/net/sunrpc/rpcb_clnt.c
@@ -579,7 +579,7 @@ void rpcb_getport_async(struct rpc_task *task)
 	u32 bind_version;
 	struct rpc_xprt *xprt;
 	struct rpc_clnt	*rpcb_clnt;
-	static struct rpcbind_args *map;
+	struct rpcbind_args *map;
 	struct rpc_task	*child;
 	struct sockaddr_storage addr;
 	struct sockaddr *sap = (struct sockaddr *)&addr;
diff --git a/net/sunrpc/sched.c b/net/sunrpc/sched.c
index 03a5c9e..416ca5e 100644
--- a/net/sunrpc/sched.c
+++ b/net/sunrpc/sched.c
@@ -628,30 +628,25 @@ static void __rpc_execute(struct rpc_task *task)
 	BUG_ON(RPC_IS_QUEUED(task));
 
 	for (;;) {
+		void (*do_action)(struct rpc_task *);
 
 		/*
-		 * Execute any pending callback.
+		 * Execute any pending callback first.
 		 */
-		if (task->tk_callback) {
-			void (*save_callback)(struct rpc_task *);
-
-			/*
-			 * We set tk_callback to NULL before calling it,
-			 * in case it sets the tk_callback field itself:
-			 */
-			save_callback = task->tk_callback;
-			task->tk_callback = NULL;
-			save_callback(task);
-		} else {
+		do_action = task->tk_callback;
+		task->tk_callback = NULL;
+		if (do_action == NULL) {
 			/*
 			 * Perform the next FSM step.
-			 * tk_action may be NULL when the task has been killed
-			 * by someone else.
+			 * tk_action may be NULL if the task has been killed.
+			 * In particular, note that rpc_killall_tasks may
+			 * do this at any time, so beware when dereferencing.
 			 */
-			if (task->tk_action == NULL)
+			do_action = task->tk_action;
+			if (do_action == NULL)
 				break;
-			task->tk_action(task);
 		}
+		do_action(task);
 
 		/*
 		 * Lockless check for whether task is sleeping or not.
diff --git a/net/sunrpc/svc_xprt.c b/net/sunrpc/svc_xprt.c
index a55d3d3..c87afb2 100644
--- a/net/sunrpc/svc_xprt.c
+++ b/net/sunrpc/svc_xprt.c
@@ -884,12 +884,13 @@ void svc_delete_xprt(struct svc_xprt *xprt)
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
 
diff --git a/sound/core/pcm_compat.c b/sound/core/pcm_compat.c
index 08bfed5..038232d 100644
--- a/sound/core/pcm_compat.c
+++ b/sound/core/pcm_compat.c
@@ -341,7 +341,7 @@ static int snd_pcm_ioctl_xfern_compat(struct snd_pcm_substream *substream,
 			kfree(bufs);
 			return -EFAULT;
 		}
-		bufs[ch] = compat_ptr(ptr);
+		bufs[i] = compat_ptr(ptr);
 		bufptr++;
 	}
 	if (dir == SNDRV_PCM_STREAM_PLAYBACK)
diff --git a/sound/soc/blackfin/bf5xx-i2s-pcm.c b/sound/soc/blackfin/bf5xx-i2s-pcm.c
index 62fbb84..77dae16 100644
--- a/sound/soc/blackfin/bf5xx-i2s-pcm.c
+++ b/sound/soc/blackfin/bf5xx-i2s-pcm.c
@@ -139,11 +139,20 @@ static snd_pcm_uframes_t bf5xx_pcm_pointer(struct snd_pcm_substream *substream)
 	pr_debug("%s enter\n", __func__);
 	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
 		diff = sport_curr_offset_tx(sport);
-		frames = bytes_to_frames(substream->runtime, diff);
 	} else {
 		diff = sport_curr_offset_rx(sport);
-		frames = bytes_to_frames(substream->runtime, diff);
 	}
+
+	/*
+	 * TX at least can report one frame beyond the end of the
+	 * buffer if we hit the wraparound case - clamp to within the
+	 * buffer as the ALSA APIs require.
+	 */
+	if (diff == snd_pcm_lib_buffer_bytes(substream))
+		diff = 0;
+
+	frames = bytes_to_frames(substream->runtime, diff);
+
 	return frames;
 }
 
