Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758941Ab0DAXSs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 19:18:48 -0400
Received: from kroah.org ([198.145.64.141]:35349 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752464Ab0DAXSk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 19:18:40 -0400
Date: Thu, 1 Apr 2010 16:11:56 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org, lwn@lwn.net
Subject: Re: Linux 2.6.27.46
Message-ID: <20100401231156.GB11167@kroah.com>
References: <20100401231141.GA11167@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100401231141.GA11167@kroah.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Documentation/filesystems/tmpfs.txt b/Documentation/filesystems/tmpfs.txt
index 222437e..a94fede 100644
--- a/Documentation/filesystems/tmpfs.txt
+++ b/Documentation/filesystems/tmpfs.txt
@@ -82,11 +82,13 @@ tmpfs has a mount option to set the NUMA memory allocation policy for
 all files in that instance (if CONFIG_NUMA is enabled) - which can be
 adjusted on the fly via 'mount -o remount ...'
 
-mpol=default             prefers to allocate memory from the local node
+mpol=default             use the process allocation policy
+                         (see set_mempolicy(2))
 mpol=prefer:Node         prefers to allocate memory from the given Node
 mpol=bind:NodeList       allocates memory only from nodes in NodeList
 mpol=interleave          prefers to allocate from each node in turn
 mpol=interleave:NodeList allocates from each node of NodeList in turn
+mpol=local		 prefers to allocate memory from the local node
 
 NodeList format is a comma-separated list of decimal numbers and ranges,
 a range being two hyphen-separated decimal numbers, the smallest and
@@ -134,3 +136,5 @@ Author:
    Christoph Rohland <cr@sap.com>, 1.12.01
 Updated:
    Hugh Dickins <hugh@veritas.com>, 4 June 2007
+Updated:
+   KOSAKI Motohiro, 16 Mar 2010
diff --git a/Makefile b/Makefile
index e94783d..ff8d4a3 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 27
-EXTRAVERSION = .45
+EXTRAVERSION = .46
 NAME = Trembling Tortoise
 
 # *DOCUMENTATION*
diff --git a/arch/x86/ia32/ia32_aout.c b/arch/x86/ia32/ia32_aout.c
index a0e1dbe..5efd5b2 100644
--- a/arch/x86/ia32/ia32_aout.c
+++ b/arch/x86/ia32/ia32_aout.c
@@ -324,7 +324,6 @@ static int load_aout_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 	current->mm->free_area_cache = TASK_UNMAPPED_BASE;
 	current->mm->cached_hole_size = 0;
 
-	current->mm->mmap = NULL;
 	compute_creds(bprm);
 	current->flags &= ~PF_FORKNOEXEC;
 
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 4cee61a..7981dbe 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2464,6 +2464,9 @@ static int handle_dr(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	unsigned long val;
 	int dr, reg;
 
+	if (!kvm_require_cpl(vcpu, 0))
+		return 1;
+
 	/*
 	 * FIXME: this code assumes the host is debugging the guest.
 	 *        need to deal with guest debugging itself too.
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index bf872f2..80ffc99 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -198,6 +198,19 @@ static void __queue_exception(struct kvm_vcpu *vcpu)
 }
 
 /*
+ * Checks if cpl <= required_cpl; if true, return true.  Otherwise queue
+ * a #GP and return false.
+ */
+bool kvm_require_cpl(struct kvm_vcpu *vcpu, int required_cpl)
+{
+	if (kvm_x86_ops->get_cpl(vcpu) <= required_cpl)
+		return true;
+	kvm_queue_exception_e(vcpu, GP_VECTOR, 0);
+	return false;
+}
+EXPORT_SYMBOL_GPL(kvm_require_cpl);
+
+/*
  * Load the pae pdptrs.  Return true is they are all valid.
  */
 int load_pdptrs(struct kvm_vcpu *vcpu, unsigned long cr3)
@@ -3645,7 +3658,13 @@ int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
 
 	vcpu->arch.cr2 = sregs->cr2;
 	mmu_reset_needed |= vcpu->arch.cr3 != sregs->cr3;
-	vcpu->arch.cr3 = sregs->cr3;
+
+	down_read(&vcpu->kvm->slots_lock);
+	if (gfn_to_memslot(vcpu->kvm, sregs->cr3 >> PAGE_SHIFT))
+		vcpu->arch.cr3 = sregs->cr3;
+	else
+		set_bit(KVM_REQ_TRIPLE_FAULT, &vcpu->requests);
+	up_read(&vcpu->kvm->slots_lock);
 
 	kvm_set_cr8(vcpu, sregs->cr8);
 
diff --git a/arch/x86/kvm/x86_emulate.c b/arch/x86/kvm/x86_emulate.c
index f2f9046..1dc1cfd 100644
--- a/arch/x86/kvm/x86_emulate.c
+++ b/arch/x86/kvm/x86_emulate.c
@@ -581,6 +581,9 @@ static int do_insn_fetch(struct x86_emulate_ctxt *ctxt,
 {
 	int rc = 0;
 
+	/* x86 instructions are limited to 15 bytes. */
+	if (eip + size - ctxt->decode.eip_orig > 15)
+		return X86EMUL_UNHANDLEABLE;
 	eip += ctxt->cs_base;
 	while (size--) {
 		rc = do_fetch_insn_byte(ctxt, ops, eip++, dest++);
@@ -839,7 +842,7 @@ x86_decode_insn(struct x86_emulate_ctxt *ctxt, struct x86_emulate_ops *ops)
 	/* Shadow copy of register state. Committed on successful emulation. */
 
 	memset(c, 0, sizeof(struct decode_cache));
-	c->eip = ctxt->vcpu->arch.rip;
+	c->eip = c->eip_orig = ctxt->vcpu->arch.rip;
 	ctxt->cs_base = seg_base(ctxt, VCPU_SREG_CS);
 	memcpy(c->regs, ctxt->vcpu->arch.regs, sizeof c->regs);
 
diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 672b08e..3191fc8 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -724,6 +724,9 @@ static ssize_t read_zero(struct file * file, char __user * buf,
 		written += chunk - unwritten;
 		if (unwritten)
 			break;
+		/* Consider changing this to just 'signal_pending()' with lots of testing */
+		if (fatal_signal_pending(current))
+			return written ? written : -EINTR;
 		buf += chunk;
 		count -= chunk;
 		cond_resched();
diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index c4b82c7..e6788f4 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -2437,8 +2437,10 @@ static int tty_fasync(int fd, struct file *filp, int on)
 			pid = task_pid(current);
 			type = PIDTYPE_PID;
 		}
-		retval = __f_setown(filp, pid, type, 0);
+		get_pid(pid);
 		spin_unlock_irqrestore(&tty->ctrl_lock, flags);
+		retval = __f_setown(filp, pid, type, 0);
+		put_pid(pid);
 		if (retval)
 			goto out;
 	} else {
diff --git a/drivers/gpu/drm/r128/r128_cce.c b/drivers/gpu/drm/r128/r128_cce.c
index c31afbd..11bb1fd 100644
--- a/drivers/gpu/drm/r128/r128_cce.c
+++ b/drivers/gpu/drm/r128/r128_cce.c
@@ -353,6 +353,11 @@ static int r128_do_init_cce(struct drm_device * dev, drm_r128_init_t * init)
 
 	DRM_DEBUG("\n");
 
+	if (dev->dev_private) {
+		DRM_DEBUG("called when already initialized\n");
+		return -EINVAL;
+	}
+
 	dev_priv = drm_alloc(sizeof(drm_r128_private_t), DRM_MEM_DRIVER);
 	if (dev_priv == NULL)
 		return -ENOMEM;
@@ -651,6 +656,8 @@ int r128_cce_start(struct drm_device *dev, void *data, struct drm_file *file_pri
 
 	LOCK_TEST_WITH_RETURN(dev, file_priv);
 
+	DEV_INIT_TEST_WITH_RETURN(dev_priv);
+
 	if (dev_priv->cce_running || dev_priv->cce_mode == R128_PM4_NONPM4) {
 		DRM_DEBUG("while CCE running\n");
 		return 0;
@@ -673,6 +680,8 @@ int r128_cce_stop(struct drm_device *dev, void *data, struct drm_file *file_priv
 
 	LOCK_TEST_WITH_RETURN(dev, file_priv);
 
+	DEV_INIT_TEST_WITH_RETURN(dev_priv);
+
 	/* Flush any pending CCE commands.  This ensures any outstanding
 	 * commands are exectuted by the engine before we turn it off.
 	 */
@@ -710,10 +719,7 @@ int r128_cce_reset(struct drm_device *dev, void *data, struct drm_file *file_pri
 
 	LOCK_TEST_WITH_RETURN(dev, file_priv);
 
-	if (!dev_priv) {
-		DRM_DEBUG("called before init done\n");
-		return -EINVAL;
-	}
+	DEV_INIT_TEST_WITH_RETURN(dev_priv);
 
 	r128_do_cce_reset(dev_priv);
 
@@ -730,6 +736,8 @@ int r128_cce_idle(struct drm_device *dev, void *data, struct drm_file *file_priv
 
 	LOCK_TEST_WITH_RETURN(dev, file_priv);
 
+	DEV_INIT_TEST_WITH_RETURN(dev_priv);
+
 	if (dev_priv->cce_running) {
 		r128_do_cce_flush(dev_priv);
 	}
@@ -743,6 +751,8 @@ int r128_engine_reset(struct drm_device *dev, void *data, struct drm_file *file_
 
 	LOCK_TEST_WITH_RETURN(dev, file_priv);
 
+	DEV_INIT_TEST_WITH_RETURN(dev->dev_private);
+
 	return r128_do_engine_reset(dev);
 }
 
diff --git a/drivers/gpu/drm/r128/r128_drv.h b/drivers/gpu/drm/r128/r128_drv.h
index 011105e..bc030f6 100644
--- a/drivers/gpu/drm/r128/r128_drv.h
+++ b/drivers/gpu/drm/r128/r128_drv.h
@@ -418,6 +418,14 @@ static __inline__ void r128_update_ring_snapshot(drm_r128_private_t * dev_priv)
  * Misc helper macros
  */
 
+#define DEV_INIT_TEST_WITH_RETURN(_dev_priv)                            \
+do {                                                                    \
+	if (!_dev_priv) {                                               \
+		DRM_ERROR("called with no initialization\n");           \
+		return -EINVAL;                                         \
+	}                                                               \
+} while (0)
+
 #define RING_SPACE_TEST_WITH_RETURN( dev_priv )				\
 do {									\
 	drm_r128_ring_buffer_t *ring = &dev_priv->ring; int i;		\
diff --git a/drivers/gpu/drm/r128/r128_state.c b/drivers/gpu/drm/r128/r128_state.c
index 51a9afc..7cd107f 100644
--- a/drivers/gpu/drm/r128/r128_state.c
+++ b/drivers/gpu/drm/r128/r128_state.c
@@ -1244,14 +1244,18 @@ static void r128_cce_dispatch_stipple(struct drm_device * dev, u32 * stipple)
 static int r128_cce_clear(struct drm_device *dev, void *data, struct drm_file *file_priv)
 {
 	drm_r128_private_t *dev_priv = dev->dev_private;
-	drm_r128_sarea_t *sarea_priv = dev_priv->sarea_priv;
+	drm_r128_sarea_t *sarea_priv;
 	drm_r128_clear_t *clear = data;
 	DRM_DEBUG("\n");
 
 	LOCK_TEST_WITH_RETURN(dev, file_priv);
 
+	DEV_INIT_TEST_WITH_RETURN(dev_priv);
+
 	RING_SPACE_TEST_WITH_RETURN(dev_priv);
 
+	sarea_priv = dev_priv->sarea_priv;
+
 	if (sarea_priv->nbox > R128_NR_SAREA_CLIPRECTS)
 		sarea_priv->nbox = R128_NR_SAREA_CLIPRECTS;
 
@@ -1312,6 +1316,8 @@ static int r128_cce_flip(struct drm_device *dev, void *data, struct drm_file *fi
 
 	LOCK_TEST_WITH_RETURN(dev, file_priv);
 
+	DEV_INIT_TEST_WITH_RETURN(dev_priv);
+
 	RING_SPACE_TEST_WITH_RETURN(dev_priv);
 
 	if (!dev_priv->page_flipping)
@@ -1331,6 +1337,8 @@ static int r128_cce_swap(struct drm_device *dev, void *data, struct drm_file *fi
 
 	LOCK_TEST_WITH_RETURN(dev, file_priv);
 
+	DEV_INIT_TEST_WITH_RETURN(dev_priv);
+
 	RING_SPACE_TEST_WITH_RETURN(dev_priv);
 
 	if (sarea_priv->nbox > R128_NR_SAREA_CLIPRECTS)
@@ -1354,10 +1362,7 @@ static int r128_cce_vertex(struct drm_device *dev, void *data, struct drm_file *
 
 	LOCK_TEST_WITH_RETURN(dev, file_priv);
 
-	if (!dev_priv) {
-		DRM_ERROR("called with no initialization\n");
-		return -EINVAL;
-	}
+	DEV_INIT_TEST_WITH_RETURN(dev_priv);
 
 	DRM_DEBUG("pid=%d index=%d count=%d discard=%d\n",
 		  DRM_CURRENTPID, vertex->idx, vertex->count, vertex->discard);
@@ -1410,10 +1415,7 @@ static int r128_cce_indices(struct drm_device *dev, void *data, struct drm_file
 
 	LOCK_TEST_WITH_RETURN(dev, file_priv);
 
-	if (!dev_priv) {
-		DRM_ERROR("called with no initialization\n");
-		return -EINVAL;
-	}
+	DEV_INIT_TEST_WITH_RETURN(dev_priv);
 
 	DRM_DEBUG("pid=%d buf=%d s=%d e=%d d=%d\n", DRM_CURRENTPID,
 		  elts->idx, elts->start, elts->end, elts->discard);
@@ -1476,6 +1478,8 @@ static int r128_cce_blit(struct drm_device *dev, void *data, struct drm_file *fi
 
 	LOCK_TEST_WITH_RETURN(dev, file_priv);
 
+	DEV_INIT_TEST_WITH_RETURN(dev_priv);
+
 	DRM_DEBUG("pid=%d index=%d\n", DRM_CURRENTPID, blit->idx);
 
 	if (blit->idx < 0 || blit->idx >= dma->buf_count) {
@@ -1501,6 +1505,8 @@ static int r128_cce_depth(struct drm_device *dev, void *data, struct drm_file *f
 
 	LOCK_TEST_WITH_RETURN(dev, file_priv);
 
+	DEV_INIT_TEST_WITH_RETURN(dev_priv);
+
 	RING_SPACE_TEST_WITH_RETURN(dev_priv);
 
 	ret = -EINVAL;
@@ -1531,6 +1537,8 @@ static int r128_cce_stipple(struct drm_device *dev, void *data, struct drm_file
 
 	LOCK_TEST_WITH_RETURN(dev, file_priv);
 
+	DEV_INIT_TEST_WITH_RETURN(dev_priv);
+
 	if (DRM_COPY_FROM_USER(&mask, stipple->mask, 32 * sizeof(u32)))
 		return -EFAULT;
 
@@ -1555,10 +1563,7 @@ static int r128_cce_indirect(struct drm_device *dev, void *data, struct drm_file
 
 	LOCK_TEST_WITH_RETURN(dev, file_priv);
 
-	if (!dev_priv) {
-		DRM_ERROR("called with no initialization\n");
-		return -EINVAL;
-	}
+	DEV_INIT_TEST_WITH_RETURN(dev_priv);
 
 	DRM_DEBUG("idx=%d s=%d e=%d d=%d\n",
 		  indirect->idx, indirect->start, indirect->end,
@@ -1620,10 +1625,7 @@ static int r128_getparam(struct drm_device *dev, void *data, struct drm_file *fi
 	drm_r128_getparam_t *param = data;
 	int value;
 
-	if (!dev_priv) {
-		DRM_ERROR("called with no initialization\n");
-		return -EINVAL;
-	}
+	DEV_INIT_TEST_WITH_RETURN(dev_priv);
 
 	DRM_DEBUG("pid=%d\n", DRM_CURRENTPID);
 
diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
index 93c1722..2b8f439 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -191,7 +191,7 @@ static int __devinit adjust_tjmax(struct cpuinfo_x86 *c, u32 id, struct device *
 		if (err) {
 			dev_warn(dev,
 				 "Unable to access MSR 0xEE, for Tjmax, left"
-				 " at default");
+				 " at default\n");
 		} else if (eax & 0x40000000) {
 			tjmax = 85000;
 		}
diff --git a/drivers/hwmon/lm78.c b/drivers/hwmon/lm78.c
index affee01..488e867 100644
--- a/drivers/hwmon/lm78.c
+++ b/drivers/hwmon/lm78.c
@@ -655,7 +655,7 @@ static int __devinit lm78_isa_probe(struct platform_device *pdev)
 
 	/* Reserve the ISA region */
 	res = platform_get_resource(pdev, IORESOURCE_IO, 0);
-	if (!request_region(res->start, LM78_EXTENT, "lm78")) {
+	if (!request_region(res->start + LM78_ADDR_REG_OFFSET, 2, "lm78")) {
 		err = -EBUSY;
 		goto exit;
 	}
@@ -699,7 +699,7 @@ static int __devinit lm78_isa_probe(struct platform_device *pdev)
 	device_remove_file(&pdev->dev, &dev_attr_name);
 	kfree(data);
  exit_release_region:
-	release_region(res->start, LM78_EXTENT);
+	release_region(res->start + LM78_ADDR_REG_OFFSET, 2);
  exit:
 	return err;
 }
@@ -711,7 +711,7 @@ static int __devexit lm78_isa_remove(struct platform_device *pdev)
 	hwmon_device_unregister(data->hwmon_dev);
 	sysfs_remove_group(&pdev->dev.kobj, &lm78_group);
 	device_remove_file(&pdev->dev, &dev_attr_name);
-	release_region(data->client.addr, LM78_EXTENT);
+	release_region(data->client.addr + LM78_ADDR_REG_OFFSET, 2);
 	kfree(data);
 
 	return 0;
@@ -836,9 +836,17 @@ static struct lm78_data *lm78_update_device(struct device *dev)
 static int __init lm78_isa_found(unsigned short address)
 {
 	int val, save, found = 0;
-
-	if (!request_region(address, LM78_EXTENT, "lm78"))
-		return 0;
+	int port;
+
+	/* Some boards declare base+0 to base+7 as a PNP device, some base+4
+	 * to base+7 and some base+5 to base+6. So we better request each port
+	 * individually for the probing phase. */
+	for (port = address; port < address + LM78_EXTENT; port++) {
+		if (!request_region(port, 1, "lm78")) {
+			pr_debug("lm78: Failed to request port 0x%x\n", port);
+			goto release;
+		}
+	}
 
 #define REALLY_SLOW_IO
 	/* We need the timeouts for at least some LM78-like
@@ -901,7 +909,8 @@ static int __init lm78_isa_found(unsigned short address)
 			val & 0x80 ? "LM79" : "LM78", (int)address);
 
  release:
-	release_region(address, LM78_EXTENT);
+	for (port--; port >= address; port--)
+		release_region(port, 1);
 	return found;
 }
 
diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index a10d0d2..3d3fb00 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -644,6 +644,9 @@ int i2c_del_adapter(struct i2c_adapter *adap)
 		}
 	}
 
+	/* device name is gone after device_unregister */
+	dev_dbg(&adap->dev, "adapter [%s] unregistered\n", adap->name);
+
 	/* clean up the sysfs representation */
 	init_completion(&adap->dev_released);
 	device_unregister(&adap->dev);
@@ -654,8 +657,6 @@ int i2c_del_adapter(struct i2c_adapter *adap)
 	/* free bus id */
 	idr_remove(&i2c_adapter_idr, adap->nr);
 
-	dev_dbg(&adap->dev, "adapter [%s] unregistered\n", adap->name);
-
 	/* Clear the device structure in case this adapter is ever going to be
 	   added again */
 	memset(&adap->dev, 0, sizeof(adap->dev));
diff --git a/drivers/media/video/em28xx/em28xx-dvb.c b/drivers/media/video/em28xx/em28xx-dvb.c
index d2b1a1a..72894f4 100644
--- a/drivers/media/video/em28xx/em28xx-dvb.c
+++ b/drivers/media/video/em28xx/em28xx-dvb.c
@@ -501,6 +501,7 @@ static int dvb_fini(struct em28xx *dev)
 
 	if (dev->dvb) {
 		unregister_dvb(dev->dvb);
+		kfree(dev->dvb);
 		dev->dvb = NULL;
 	}
 
diff --git a/drivers/mtd/ubi/cdev.c b/drivers/mtd/ubi/cdev.c
index 03c759b..82dfbe5 100644
--- a/drivers/mtd/ubi/cdev.c
+++ b/drivers/mtd/ubi/cdev.c
@@ -793,7 +793,6 @@ static int ubi_cdev_ioctl(struct inode *inode, struct file *file,
 			break;
 		}
 
-		req.name[req.name_len] = '\0';
 		err = verify_mkvol_req(ubi, &req);
 		if (err)
 			break;
diff --git a/drivers/net/b44.c b/drivers/net/b44.c
index f1521c6..012614e 100644
--- a/drivers/net/b44.c
+++ b/drivers/net/b44.c
@@ -1502,8 +1502,7 @@ static int b44_magic_pattern(u8 *macaddr, u8 *ppattern, u8 *pmask, int offset)
 		for (k = 0; k< ethaddr_bytes; k++) {
 			ppattern[offset + magicsync +
 				(j * ETH_ALEN) + k] = macaddr[k];
-			len++;
-			set_bit(len, (unsigned long *) pmask);
+			set_bit(len++, (unsigned long *) pmask);
 		}
 	}
 	return len - 1;
diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 5a07b50..598d2e9 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -2228,6 +2228,9 @@ static int bond_miimon_inspect(struct bonding *bond)
 {
 	struct slave *slave;
 	int i, link_state, commit = 0;
+	bool ignore_updelay;
+
+	ignore_updelay = !bond->curr_active_slave ? true : false;
 
 	bond_for_each_slave(bond, slave, i) {
 		slave->new_link = BOND_LINK_NOCHANGE;
@@ -2292,6 +2295,7 @@ static int bond_miimon_inspect(struct bonding *bond)
 				       ": %s: link status up for "
 				       "interface %s, enabling it in %d ms.\n",
 				       bond->dev->name, slave->dev->name,
+				       ignore_updelay ? 0 :
 				       bond->params.updelay *
 				       bond->params.miimon);
 			}
@@ -2310,9 +2314,13 @@ static int bond_miimon_inspect(struct bonding *bond)
 				continue;
 			}
 
+			if (ignore_updelay)
+				slave->delay = 0;
+
 			if (slave->delay <= 0) {
 				slave->new_link = BOND_LINK_UP;
 				commit++;
+				ignore_updelay = false;
 				continue;
 			}
 
diff --git a/drivers/net/r8169.c b/drivers/net/r8169.c
index f718215..68bba7f 100644
--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -1842,9 +1842,9 @@ static void __devexit rtl8169_remove_one(struct pci_dev *pdev)
 static void rtl8169_set_rxbufsize(struct rtl8169_private *tp,
 				  struct net_device *dev)
 {
-	unsigned int mtu = dev->mtu;
+	unsigned int max_frame = dev->mtu + VLAN_ETH_HLEN + ETH_FCS_LEN;
 
-	tp->rx_buf_sz = (mtu > RX_BUF_SIZE) ? mtu + ETH_HLEN + 8 : RX_BUF_SIZE;
+	tp->rx_buf_sz = (max_frame > RX_BUF_SIZE) ? max_frame : RX_BUF_SIZE;
 }
 
 static int rtl8169_open(struct net_device *dev)
diff --git a/drivers/net/sky2.c b/drivers/net/sky2.c
index 42963a9..aa9ff46 100644
--- a/drivers/net/sky2.c
+++ b/drivers/net/sky2.c
@@ -1438,7 +1438,6 @@ static int sky2_up(struct net_device *dev)
 	if (ramsize > 0) {
 		u32 rxspace;
 
-		hw->flags |= SKY2_HW_RAM_BUFFER;
 		pr_debug(PFX "%s: ram buffer %dK\n", dev->name, ramsize);
 		if (ramsize < 16)
 			rxspace = ramsize / 2;
@@ -2846,6 +2845,9 @@ static int __devinit sky2_init(struct sky2_hw *hw)
 			++hw->ports;
 	}
 
+	if (sky2_read8(hw, B2_E_0))
+		hw->flags |= SKY2_HW_RAM_BUFFER;
+
 	return 0;
 }
 
diff --git a/drivers/parisc/eisa_eeprom.c b/drivers/parisc/eisa_eeprom.c
index 5ac2079..7eee236 100644
--- a/drivers/parisc/eisa_eeprom.c
+++ b/drivers/parisc/eisa_eeprom.c
@@ -55,7 +55,7 @@ static ssize_t eisa_eeprom_read(struct file * file,
 	ssize_t ret;
 	int i;
 	
-	if (*ppos >= HPEE_MAX_LENGTH)
+	if (*ppos < 0 || *ppos >= HPEE_MAX_LENGTH)
 		return 0;
 	
 	count = *ppos + count < HPEE_MAX_LENGTH ? count : HPEE_MAX_LENGTH - *ppos;
diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index 3499a9d..f84f068 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -70,6 +70,9 @@ static unsigned int nr_uarts = CONFIG_SERIAL_8250_RUNTIME_UARTS;
 
 #define PASS_LIMIT	256
 
+#define BOTH_EMPTY 	(UART_LSR_TEMT | UART_LSR_THRE)
+
+
 /*
  * We default to IRQ0 for the "no irq" hack.   Some
  * machine types want others as well - they're free
@@ -1656,7 +1659,7 @@ static unsigned int serial8250_tx_empty(struct uart_port *port)
 	up->lsr_saved_flags |= lsr & LSR_SAVE_FLAGS;
 	spin_unlock_irqrestore(&up->port.lock, flags);
 
-	return lsr & UART_LSR_TEMT ? TIOCSER_TEMT : 0;
+	return (lsr & BOTH_EMPTY) == BOTH_EMPTY ? TIOCSER_TEMT : 0;
 }
 
 static unsigned int serial8250_get_mctrl(struct uart_port *port)
@@ -1714,8 +1717,6 @@ static void serial8250_break_ctl(struct uart_port *port, int break_state)
 	spin_unlock_irqrestore(&up->port.lock, flags);
 }
 
-#define BOTH_EMPTY (UART_LSR_TEMT | UART_LSR_THRE)
-
 /*
  *	Wait for transmitter & holding register to empty
  */
diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
index 33b2935..8657266 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -1123,6 +1123,13 @@ static int proc_do_submiturb(struct dev_state *ps, struct usbdevfs_urb *uurb,
 			free_async(as);
 			return -ENOMEM;
 		}
+		/* Isochronous input data may end up being discontiguous
+		 * if some of the packets are short.  Clear the buffer so
+		 * that the gaps don't leak kernel data to userspace.
+		 */
+		if (is_in && uurb->type == USBDEVFS_URB_TYPE_ISO)
+			memset(as->urb->transfer_buffer, 0,
+					uurb->buffer_length);
 	}
 	as->urb->dev = ps->dev;
 	as->urb->pipe = (uurb->type << 30) |
@@ -1224,10 +1231,14 @@ static int processcompl(struct async *as, void __user * __user *arg)
 	void __user *addr = as->userurb;
 	unsigned int i;
 
-	if (as->userbuffer)
-		if (copy_to_user(as->userbuffer, urb->transfer_buffer,
-				 urb->transfer_buffer_length))
+	if (as->userbuffer && urb->actual_length) {
+		if (urb->number_of_packets > 0)		/* Isochronous */
+			i = urb->transfer_buffer_length;
+		else					/* Non-Isoc */
+			i = urb->actual_length;
+		if (copy_to_user(as->userbuffer, urb->transfer_buffer, i))
 			goto err_out;
+	}
 	if (put_user(as->status, &userurb->status))
 		goto err_out;
 	if (put_user(urb->actual_length, &userurb->actual_length))
@@ -1246,14 +1257,11 @@ static int processcompl(struct async *as, void __user * __user *arg)
 		}
 	}
 
-	free_async(as);
-
 	if (put_user(addr, (void __user * __user *)arg))
 		return -EFAULT;
 	return 0;
 
 err_out:
-	free_async(as);
 	return -EFAULT;
 }
 
@@ -1283,8 +1291,11 @@ static struct async *reap_as(struct dev_state *ps)
 static int proc_reapurb(struct dev_state *ps, void __user *arg)
 {
 	struct async *as = reap_as(ps);
-	if (as)
-		return processcompl(as, (void __user * __user *)arg);
+	if (as) {
+		int retval = processcompl(as, (void __user * __user *)arg);
+		free_async(as);
+		return retval;
+	}
 	if (signal_pending(current))
 		return -EINTR;
 	return -EIO;
@@ -1292,11 +1303,16 @@ static int proc_reapurb(struct dev_state *ps, void __user *arg)
 
 static int proc_reapurbnonblock(struct dev_state *ps, void __user *arg)
 {
+	int retval;
 	struct async *as;
 
-	if (!(as = async_getcompleted(ps)))
-		return -EAGAIN;
-	return processcompl(as, (void __user * __user *)arg);
+	as = async_getcompleted(ps);
+	retval = -EAGAIN;
+	if (as) {
+		retval = processcompl(as, (void __user * __user *)arg);
+		free_async(as);
+	}
+	return retval;
 }
 
 #ifdef CONFIG_COMPAT
@@ -1347,9 +1363,9 @@ static int processcompl_compat(struct async *as, void __user * __user *arg)
 	void __user *addr = as->userurb;
 	unsigned int i;
 
-	if (as->userbuffer)
+	if (as->userbuffer && urb->actual_length)
 		if (copy_to_user(as->userbuffer, urb->transfer_buffer,
-				 urb->transfer_buffer_length))
+				 urb->actual_length))
 			return -EFAULT;
 	if (put_user(as->status, &userurb->status))
 		return -EFAULT;
@@ -1369,7 +1385,6 @@ static int processcompl_compat(struct async *as, void __user * __user *arg)
 		}
 	}
 
-	free_async(as);
 	if (put_user(ptr_to_compat(addr), (u32 __user *)arg))
 		return -EFAULT;
 	return 0;
@@ -1378,8 +1393,11 @@ static int processcompl_compat(struct async *as, void __user * __user *arg)
 static int proc_reapurb_compat(struct dev_state *ps, void __user *arg)
 {
 	struct async *as = reap_as(ps);
-	if (as)
-		return processcompl_compat(as, (void __user * __user *)arg);
+	if (as) {
+		int retval = processcompl_compat(as, (void __user * __user *)arg);
+		free_async(as);
+		return retval;
+	}
 	if (signal_pending(current))
 		return -EINTR;
 	return -EIO;
@@ -1387,11 +1405,16 @@ static int proc_reapurb_compat(struct dev_state *ps, void __user *arg)
 
 static int proc_reapurbnonblock_compat(struct dev_state *ps, void __user *arg)
 {
+	int retval;
 	struct async *as;
 
-	if (!(as = async_getcompleted(ps)))
-		return -EAGAIN;
-	return processcompl_compat(as, (void __user * __user *)arg);
+	retval = -EAGAIN;
+	as = async_getcompleted(ps);
+	if (as) {
+		retval = processcompl_compat(as, (void __user * __user *)arg);
+		free_async(as);
+	}
+	return retval;
 }
 
 #endif
diff --git a/drivers/usb/host/ehci-hub.c b/drivers/usb/host/ehci-hub.c
index ef9b038..f1a29e2 100644
--- a/drivers/usb/host/ehci-hub.c
+++ b/drivers/usb/host/ehci-hub.c
@@ -254,10 +254,8 @@ static int ehci_bus_resume (struct usb_hcd *hcd)
 		temp = ehci_readl(ehci, &ehci->regs->port_status [i]);
 		temp &= ~(PORT_RWC_BITS | PORT_WAKE_BITS);
 		if (test_bit(i, &ehci->bus_suspended) &&
-				(temp & PORT_SUSPEND)) {
-			ehci->reset_done [i] = jiffies + msecs_to_jiffies (20);
+				(temp & PORT_SUSPEND))
 			temp |= PORT_RESUME;
-		}
 		ehci_writel(ehci, temp, &ehci->regs->port_status [i]);
 	}
 	i = HCS_N_PORTS (ehci->hcs_params);
@@ -752,6 +750,9 @@ static int ehci_hub_control (
 					ehci_readl(ehci, status_reg));
 		}
 
+		if (!(temp & (PORT_RESUME|PORT_RESET)))
+			ehci->reset_done[wIndex] = 0;
+
 		/* transfer dedicated ports to the companion hc */
 		if ((temp & PORT_CONNECT) &&
 				test_bit(wIndex, &ehci->companion_ports)) {
diff --git a/drivers/usb/host/ehci-q.c b/drivers/usb/host/ehci-q.c
index 097dd55..da88a80 100644
--- a/drivers/usb/host/ehci-q.c
+++ b/drivers/usb/host/ehci-q.c
@@ -346,12 +346,11 @@ qh_completions (struct ehci_hcd *ehci, struct ehci_qh *qh)
 				 */
 				if ((token & QTD_STS_XACT) &&
 						QTD_CERR(token) == 0 &&
-						--qh->xacterrs > 0 &&
+						++qh->xacterrs < QH_XACTERR_MAX &&
 						!urb->unlinked) {
 					ehci_dbg(ehci,
-	"detected XactErr len %d/%d retry %d\n",
-	qtd->length - QTD_LENGTH(token), qtd->length,
-	QH_XACTERR_MAX - qh->xacterrs);
+	"detected XactErr len %zu/%zu retry %d\n",
+	qtd->length - QTD_LENGTH(token), qtd->length, qh->xacterrs);
 
 					/* reset the token in the qtd and the
 					 * qh overlay (which still contains
@@ -451,7 +450,7 @@ halt:
 		last = qtd;
 
 		/* reinit the xacterr counter for the next qtd */
-		qh->xacterrs = QH_XACTERR_MAX;
+		qh->xacterrs = 0;
 	}
 
 	/* last urb's completion might still need calling */
@@ -898,7 +897,7 @@ static void qh_link_async (struct ehci_hcd *ehci, struct ehci_qh *qh)
 	head->qh_next.qh = qh;
 	head->hw_next = dma;
 
-	qh->xacterrs = QH_XACTERR_MAX;
+	qh->xacterrs = 0;
 	qh->qh_state = QH_STATE_LINKED;
 	/* qtd completions reported later by interrupt */
 }
diff --git a/drivers/usb/host/ehci-sched.c b/drivers/usb/host/ehci-sched.c
index 18e8741..e813ca8 100644
--- a/drivers/usb/host/ehci-sched.c
+++ b/drivers/usb/host/ehci-sched.c
@@ -542,6 +542,7 @@ static int qh_link_periodic (struct ehci_hcd *ehci, struct ehci_qh *qh)
 		}
 	}
 	qh->qh_state = QH_STATE_LINKED;
+	qh->xacterrs = 0;
 	qh_get (qh);
 
 	/* update per-qh bandwidth for usbfs */
diff --git a/fs/exec.c b/fs/exec.c
index 5ec0f56..50da182 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1826,8 +1826,9 @@ int do_coredump(long signr, int exit_code, struct pt_regs * regs)
 	/*
 	 * Dont allow local users get cute and trick others to coredump
 	 * into their pre-created files:
+	 * Note, this is not relevant for pipes
 	 */
-	if (inode->i_uid != current->fsuid)
+	if (!ispipe && (inode->i_uid != current->fsuid))
 		goto close_fail;
 	if (!file->f_op)
 		goto close_fail;
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index db2642a..baacaf8 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -254,7 +254,8 @@ static const char *ext4_decode_error(struct super_block *sb, int errno,
 		errstr = "Out of memory";
 		break;
 	case -EROFS:
-		if (!sb || EXT4_SB(sb)->s_journal->j_flags & JBD2_ABORT)
+		if (!sb || (EXT4_SB(sb)->s_journal &&
+			    EXT4_SB(sb)->s_journal->j_flags & JBD2_ABORT))
 			errstr = "Journal has aborted";
 		else
 			errstr = "Readonly filesystem";
diff --git a/fs/fcntl.c b/fs/fcntl.c
index 4eed4d6..ac79b7e 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -200,9 +200,7 @@ static int setfl(int fd, struct file * filp, unsigned long arg)
 static void f_modown(struct file *filp, struct pid *pid, enum pid_type type,
                      uid_t uid, uid_t euid, int force)
 {
-	unsigned long flags;
-
-	write_lock_irqsave(&filp->f_owner.lock, flags);
+	write_lock_irq(&filp->f_owner.lock);
 	if (force || !filp->f_owner.pid) {
 		put_pid(filp->f_owner.pid);
 		filp->f_owner.pid = get_pid(pid);
@@ -210,7 +208,7 @@ static void f_modown(struct file *filp, struct pid *pid, enum pid_type type,
 		filp->f_owner.uid = uid;
 		filp->f_owner.euid = euid;
 	}
-	write_unlock_irqrestore(&filp->f_owner.lock, flags);
+	write_unlock_irq(&filp->f_owner.lock);
 }
 
 int __f_setown(struct file *filp, struct pid *pid, enum pid_type type,
diff --git a/fs/namei.c b/fs/namei.c
index e6c73de..832cd4b 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -841,6 +841,17 @@ fail:
 }
 
 /*
+ * This is a temporary kludge to deal with "automount" symlinks; proper
+ * solution is to trigger them on follow_mount(), so that do_lookup()
+ * would DTRT.  To be killed before 2.6.34-final.
+ */
+static inline int follow_on_final(struct inode *inode, unsigned lookup_flags)
+{
+	return inode && unlikely(inode->i_op->follow_link) &&
+		((lookup_flags & LOOKUP_FOLLOW) || S_ISDIR(inode->i_mode));
+}
+
+/*
  * Name resolution.
  * This is the basic name resolution function, turning a pathname into
  * the final dentry. We expect 'base' to be positive and a directory.
@@ -984,8 +995,7 @@ last_component:
 		if (err)
 			break;
 		inode = next.dentry->d_inode;
-		if ((lookup_flags & LOOKUP_FOLLOW)
-		    && inode && inode->i_op && inode->i_op->follow_link) {
+		if (follow_on_final(inode, lookup_flags)) {
 			err = do_follow_link(&next, nd);
 			if (err)
 				goto return_err;
diff --git a/include/asm-x86/checksum_32.h b/include/asm-x86/checksum_32.h
index 52bbb0d..0fbf77e 100644
--- a/include/asm-x86/checksum_32.h
+++ b/include/asm-x86/checksum_32.h
@@ -161,7 +161,8 @@ static inline __sum16 csum_ipv6_magic(const struct in6_addr *saddr,
 	    "adcl $0, %0	;\n"
 	    : "=&r" (sum)
 	    : "r" (saddr), "r" (daddr),
-	      "r" (htonl(len)), "r" (htonl(proto)), "0" (sum));
+	      "r" (htonl(len)), "r" (htonl(proto)), "0" (sum)
+	    : "memory");
 
 	return csum_fold(sum);
 }
diff --git a/include/asm-x86/kvm_host.h b/include/asm-x86/kvm_host.h
index cf7c887..69d4de9 100644
--- a/include/asm-x86/kvm_host.h
+++ b/include/asm-x86/kvm_host.h
@@ -537,6 +537,7 @@ void kvm_queue_exception(struct kvm_vcpu *vcpu, unsigned nr);
 void kvm_queue_exception_e(struct kvm_vcpu *vcpu, unsigned nr, u32 error_code);
 void kvm_inject_page_fault(struct kvm_vcpu *vcpu, unsigned long cr2,
 			   u32 error_code);
+bool kvm_require_cpl(struct kvm_vcpu *vcpu, int required_cpl);
 
 void kvm_inject_nmi(struct kvm_vcpu *vcpu);
 
diff --git a/include/asm-x86/kvm_x86_emulate.h b/include/asm-x86/kvm_x86_emulate.h
index 4e8c1e4..fcbb680 100644
--- a/include/asm-x86/kvm_x86_emulate.h
+++ b/include/asm-x86/kvm_x86_emulate.h
@@ -128,7 +128,7 @@ struct decode_cache {
 	u8 seg_override;
 	unsigned int d;
 	unsigned long regs[NR_VCPU_REGS];
-	unsigned long eip;
+	unsigned long eip, eip_orig;
 	/* modrm */
 	u8 modrm;
 	u8 modrm_mod;
diff --git a/include/linux/sched.h b/include/linux/sched.h
index ebe801e..6d32974 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -901,7 +901,7 @@ struct sched_class {
 	void (*yield_task) (struct rq *rq);
 	int  (*select_task_rq)(struct task_struct *p, int sync);
 
-	void (*check_preempt_curr) (struct rq *rq, struct task_struct *p);
+	void (*check_preempt_curr) (struct rq *rq, struct task_struct *p, int sync);
 
 	struct task_struct * (*pick_next_task) (struct rq *rq);
 	void (*put_prev_task) (struct rq *rq, struct task_struct *p);
@@ -2232,6 +2232,28 @@ static inline void mm_init_owner(struct mm_struct *mm, struct task_struct *p)
 
 #define TASK_STATE_TO_CHAR_STR "RSDTtZX"
 
+static inline unsigned long task_rlimit(const struct task_struct *tsk,
+		unsigned int limit)
+{
+	return ACCESS_ONCE(tsk->signal->rlim[limit].rlim_cur);
+}
+
+static inline unsigned long task_rlimit_max(const struct task_struct *tsk,
+		unsigned int limit)
+{
+	return ACCESS_ONCE(tsk->signal->rlim[limit].rlim_max);
+}
+
+static inline unsigned long rlimit(unsigned int limit)
+{
+	return task_rlimit(current, limit);
+}
+
+static inline unsigned long rlimit_max(unsigned int limit)
+{
+	return task_rlimit_max(current, limit);
+}
+
 #endif /* __KERNEL__ */
 
 #endif
diff --git a/include/linux/topology.h b/include/linux/topology.h
index 2158fc0..2565f4a 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -99,7 +99,7 @@ void arch_update_cpu_topology(void);
 				| SD_BALANCE_FORK	\
 				| SD_BALANCE_EXEC	\
 				| SD_WAKE_AFFINE	\
-				| SD_WAKE_IDLE		\
+				| SD_WAKE_BALANCE	\
 				| SD_SHARE_CPUPOWER,	\
 	.last_balance		= jiffies,		\
 	.balance_interval	= 1,			\
@@ -120,10 +120,10 @@ void arch_update_cpu_topology(void);
 	.wake_idx		= 1,			\
 	.forkexec_idx		= 1,			\
 	.flags			= SD_LOAD_BALANCE	\
-				| SD_BALANCE_NEWIDLE	\
 				| SD_BALANCE_FORK	\
 				| SD_BALANCE_EXEC	\
 				| SD_WAKE_AFFINE	\
+				| SD_WAKE_BALANCE	\
 				| SD_SHARE_PKG_RESOURCES\
 				| BALANCE_FOR_MC_POWER,	\
 	.last_balance		= jiffies,		\
diff --git a/kernel/futex.c b/kernel/futex.c
index ec84da5..02d07e4 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -533,8 +533,25 @@ lookup_pi_state(u32 uval, struct futex_hash_bucket *hb,
 				return -EINVAL;
 
 			WARN_ON(!atomic_read(&pi_state->refcount));
-			WARN_ON(pid && pi_state->owner &&
-				pi_state->owner->pid != pid);
+
+			/*
+			 * When pi_state->owner is NULL then the owner died
+			 * and another waiter is on the fly. pi_state->owner
+			 * is fixed up by the task which acquires
+			 * pi_state->rt_mutex.
+			 *
+			 * We do not check for pid == 0 which can happen when
+			 * the owner died and robust_list_exit() cleared the
+			 * TID.
+			 */
+			if (pid && pi_state->owner) {
+				/*
+				 * Bail out if user space manipulated the
+				 * futex value.
+				 */
+				if (pid != task_pid_vnr(pi_state->owner))
+					return -EINVAL;
+			}
 
 			atomic_inc(&pi_state->refcount);
 			*ps = pi_state;
@@ -630,6 +647,13 @@ static int wake_futex_pi(u32 __user *uaddr, u32 uval, struct futex_q *this)
 	if (!pi_state)
 		return -EINVAL;
 
+	/*
+	 * If current does not own the pi_state then the futex is
+	 * inconsistent and user space fiddled with the futex value.
+	 */
+	if (pi_state->owner != current)
+		return -EINVAL;
+
 	spin_lock(&pi_state->pi_mutex.wait_lock);
 	new_owner = rt_mutex_next_owner(&pi_state->pi_mutex);
 
diff --git a/kernel/printk.c b/kernel/printk.c
index 204660d..b9df41b 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -995,7 +995,7 @@ int printk_needs_cpu(int cpu)
 void wake_up_klogd(void)
 {
 	if (waitqueue_active(&log_wait))
-		__get_cpu_var(printk_pending) = 1;
+		__raw_get_cpu_var(printk_pending) = 1;
 }
 
 /**
diff --git a/kernel/sched.c b/kernel/sched.c
index 98c0cdc..f01ff16 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -604,9 +604,9 @@ struct rq {
 
 static DEFINE_PER_CPU_SHARED_ALIGNED(struct rq, runqueues);
 
-static inline void check_preempt_curr(struct rq *rq, struct task_struct *p)
+static inline void check_preempt_curr(struct rq *rq, struct task_struct *p, int sync)
 {
-	rq->curr->sched_class->check_preempt_curr(rq, p);
+	rq->curr->sched_class->check_preempt_curr(rq, p, sync);
 }
 
 static inline int cpu_of(struct rq *rq)
@@ -2285,7 +2285,7 @@ out_running:
 	trace_mark(kernel_sched_wakeup,
 		"pid %d state %ld ## rq %p task %p rq->curr %p",
 		p->pid, p->state, rq, p, rq->curr);
-	check_preempt_curr(rq, p);
+	check_preempt_curr(rq, p, sync);
 
 	p->state = TASK_RUNNING;
 #ifdef CONFIG_SMP
@@ -2420,7 +2420,7 @@ void wake_up_new_task(struct task_struct *p, unsigned long clone_flags)
 	trace_mark(kernel_sched_wakeup_new,
 		"pid %d state %ld ## rq %p task %p rq->curr %p",
 		p->pid, p->state, rq, p, rq->curr);
-	check_preempt_curr(rq, p);
+	check_preempt_curr(rq, p, 0);
 #ifdef CONFIG_SMP
 	if (p->sched_class->task_wake_up)
 		p->sched_class->task_wake_up(rq, p);
@@ -2880,7 +2880,7 @@ static void pull_task(struct rq *src_rq, struct task_struct *p,
 	 * Note that idle threads have a prio of MAX_PRIO, for this test
 	 * to be always true for them.
 	 */
-	check_preempt_curr(this_rq, p);
+	check_preempt_curr(this_rq, p, 0);
 }
 
 /*
@@ -5957,7 +5957,7 @@ static int __migrate_task(struct task_struct *p, int src_cpu, int dest_cpu)
 	set_task_cpu(p, dest_cpu);
 	if (on_rq) {
 		activate_task(rq_dest, p, 0);
-		check_preempt_curr(rq_dest, p);
+		check_preempt_curr(rq_dest, p, 0);
 	}
 done:
 	ret = 1;
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index fb8994c..ab8e6f3 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1331,7 +1331,7 @@ static inline int depth_se(struct sched_entity *se)
 /*
  * Preempt the current task with a newly woken task if needed:
  */
-static void check_preempt_wakeup(struct rq *rq, struct task_struct *p)
+static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int sync)
 {
 	struct task_struct *curr = rq->curr;
 	struct cfs_rq *cfs_rq = task_cfs_rq(curr);
@@ -1360,6 +1360,13 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p)
 	if (!sched_feat(WAKEUP_PREEMPT))
 		return;
 
+	if (sched_feat(WAKEUP_OVERLAP) && sync &&
+			se->avg_overlap < sysctl_sched_migration_cost &&
+			pse->avg_overlap < sysctl_sched_migration_cost) {
+		resched_task(curr);
+		return;
+	}
+
 	/*
 	 * preemption test can be made between sibling entities who are in the
 	 * same cfs_rq i.e who have a common parent. Walk up the hierarchy of
@@ -1642,7 +1649,7 @@ static void prio_changed_fair(struct rq *rq, struct task_struct *p,
 		if (p->prio > oldprio)
 			resched_task(rq->curr);
 	} else
-		check_preempt_curr(rq, p);
+		check_preempt_curr(rq, p, 0);
 }
 
 /*
@@ -1659,7 +1666,7 @@ static void switched_to_fair(struct rq *rq, struct task_struct *p,
 	if (running)
 		resched_task(rq->curr);
 	else
-		check_preempt_curr(rq, p);
+		check_preempt_curr(rq, p, 0);
 }
 
 /* Account for a task changing its policy or group.
diff --git a/kernel/sched_features.h b/kernel/sched_features.h
index c4c88ae..4e51893 100644
--- a/kernel/sched_features.h
+++ b/kernel/sched_features.h
@@ -11,3 +11,4 @@ SCHED_FEAT(ASYM_GRAN, 1)
 SCHED_FEAT(LB_BIAS, 1)
 SCHED_FEAT(LB_WAKEUP_UPDATE, 1)
 SCHED_FEAT(ASYM_EFF_LOAD, 1)
+SCHED_FEAT(WAKEUP_OVERLAP, 1)
diff --git a/kernel/sched_idletask.c b/kernel/sched_idletask.c
index 3a4f92d..dec4cca 100644
--- a/kernel/sched_idletask.c
+++ b/kernel/sched_idletask.c
@@ -14,7 +14,7 @@ static int select_task_rq_idle(struct task_struct *p, int sync)
 /*
  * Idle tasks are unconditionally rescheduled:
  */
-static void check_preempt_curr_idle(struct rq *rq, struct task_struct *p)
+static void check_preempt_curr_idle(struct rq *rq, struct task_struct *p, int sync)
 {
 	resched_task(rq->idle);
 }
@@ -76,7 +76,7 @@ static void switched_to_idle(struct rq *rq, struct task_struct *p,
 	if (running)
 		resched_task(rq->curr);
 	else
-		check_preempt_curr(rq, p);
+		check_preempt_curr(rq, p, 0);
 }
 
 static void prio_changed_idle(struct rq *rq, struct task_struct *p,
@@ -93,7 +93,7 @@ static void prio_changed_idle(struct rq *rq, struct task_struct *p,
 		if (p->prio > oldprio)
 			resched_task(rq->curr);
 	} else
-		check_preempt_curr(rq, p);
+		check_preempt_curr(rq, p, 0);
 }
 
 /*
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 37f0721..68c4745 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -784,7 +784,7 @@ static void check_preempt_equal_prio(struct rq *rq, struct task_struct *p)
 /*
  * Preempt the current task with a newly woken task if needed:
  */
-static void check_preempt_curr_rt(struct rq *rq, struct task_struct *p)
+static void check_preempt_curr_rt(struct rq *rq, struct task_struct *p, int sync)
 {
 	if (p->prio < rq->curr->prio) {
 		resched_task(rq->curr);
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 7acf81c..b759b7d 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2029,8 +2029,8 @@ int mpol_parse_str(char *str, struct mempolicy **mpol, int no_context)
 			char *rest = nodelist;
 			while (isdigit(*rest))
 				rest++;
-			if (!*rest)
-				err = 0;
+			if (*rest)
+				goto out;
 		}
 		break;
 	case MPOL_INTERLEAVE:
@@ -2039,7 +2039,6 @@ int mpol_parse_str(char *str, struct mempolicy **mpol, int no_context)
 		 */
 		if (!nodelist)
 			nodes = node_states[N_HIGH_MEMORY];
-		err = 0;
 		break;
 	case MPOL_LOCAL:
 		/*
@@ -2049,11 +2048,19 @@ int mpol_parse_str(char *str, struct mempolicy **mpol, int no_context)
 			goto out;
 		mode = MPOL_PREFERRED;
 		break;
-
-	/*
-	 * case MPOL_BIND:    mpol_new() enforces non-empty nodemask.
-	 * case MPOL_DEFAULT: mpol_new() enforces empty nodemask, ignores flags.
-	 */
+	case MPOL_DEFAULT:
+		/*
+		 * Insist on a empty nodelist
+		 */
+		if (!nodelist)
+			err = 0;
+		goto out;
+	case MPOL_BIND:
+		/*
+		 * Insist on a nodelist
+		 */
+		if (!nodelist)
+			goto out;
 	}
 
 	mode_flags = 0;
@@ -2067,14 +2074,17 @@ int mpol_parse_str(char *str, struct mempolicy **mpol, int no_context)
 		else if (!strcmp(flags, "relative"))
 			mode_flags |= MPOL_F_RELATIVE_NODES;
 		else
-			err = 1;
+			goto out;
 	}
 
 	new = mpol_new(mode, mode_flags, &nodes);
 	if (IS_ERR(new))
-		err = 1;
-	else if (no_context)
-		new->w.user_nodemask = nodes;	/* save for contextualization */
+		goto out;
+	err = 0;
+	if (no_context) {
+		/* save for contextualization */
+		new->w.user_nodemask = nodes;
+	}
 
 out:
 	/* Restore string for error message */
diff --git a/mm/migrate.c b/mm/migrate.c
index d493c02..96178f4 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1062,6 +1062,9 @@ SYSCALL_DEFINE6(move_pages, pid_t, pid, unsigned long, nr_pages,
 				goto out;
 
 			err = -ENODEV;
+			if (node < 0 || node >= MAX_NUMNODES)
+				goto out;
+
 			if (!node_state(node, N_HIGH_MEMORY))
 				goto out;
 
diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index cd9d526..2268a7e 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -894,7 +894,6 @@ struct sock *ax25_make_new(struct sock *osk, struct ax25_dev *ax25_dev)
 
 	sock_init_data(NULL, sk);
 
-	sk->sk_destruct = ax25_free_sock;
 	sk->sk_type     = osk->sk_type;
 	sk->sk_priority = osk->sk_priority;
 	sk->sk_protocol = osk->sk_protocol;
@@ -932,6 +931,7 @@ struct sock *ax25_make_new(struct sock *osk, struct ax25_dev *ax25_dev)
 	}
 
 	sk->sk_protinfo = ax25;
+	sk->sk_destruct = ax25_free_sock;
 	ax25->sk    = sk;
 
 	return sk;
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index f976fc5..6d108fb 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -362,7 +362,7 @@ void tcp_twsk_destructor(struct sock *sk)
 #ifdef CONFIG_TCP_MD5SIG
 	struct tcp_timewait_sock *twsk = tcp_twsk(sk);
 	if (twsk->tw_md5_keylen)
-		tcp_put_md5sig_pool();
+		tcp_free_md5sig_pool();
 #endif
 }
 
diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index b7a50e9..0a913c9 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -260,7 +260,7 @@ static int ipip6_tunnel_get_prl(struct ip_tunnel *t,
 
 	c = 0;
 	for (prl = t->prl; prl; prl = prl->next) {
-		if (c > cmax)
+		if (c >= cmax)
 			break;
 		if (kprl.addr != htonl(INADDR_ANY) && prl->addr != kprl.addr)
 			continue;
diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index 1122c95..2b801a0 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -1453,6 +1453,8 @@ static int tc_fill_tclass(struct sk_buff *skb, struct Qdisc *q,
 	nlh = NLMSG_NEW(skb, pid, seq, event, sizeof(*tcm), flags);
 	tcm = NLMSG_DATA(nlh);
 	tcm->tcm_family = AF_UNSPEC;
+	tcm->tcm__pad1 = 0;
+	tcm->tcm__pad2 = 0;
 	tcm->tcm_ifindex = qdisc_dev(q)->ifindex;
 	tcm->tcm_parent = q->handle;
 	tcm->tcm_handle = q->handle;
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index facdaa9..3c33817 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1491,6 +1491,7 @@ static int unix_stream_sendmsg(struct kiocb *kiocb, struct socket *sock,
 	struct sk_buff *skb;
 	int sent=0;
 	struct scm_cookie tmp_scm;
+	bool fds_sent = false;
 
 	if (NULL == siocb->scm)
 		siocb->scm = &tmp_scm;
@@ -1552,12 +1553,14 @@ static int unix_stream_sendmsg(struct kiocb *kiocb, struct socket *sock,
 		size = min_t(int, size, skb_tailroom(skb));
 
 		memcpy(UNIXCREDS(skb), &siocb->scm->creds, sizeof(struct ucred));
-		if (siocb->scm->fp) {
+		/* Only send the fds in the first buffer */
+		if (siocb->scm->fp && !fds_sent) {
 			err = unix_attach_fds(siocb->scm, skb);
 			if (err) {
 				kfree_skb(skb);
 				goto out_err;
 			}
+			fds_sent = true;
 		}
 
 		if ((err = memcpy_fromiovec(skb_put(skb,size), msg->msg_iov, size)) != 0) {
